#!/usr/bin/env python2

import os
import sys
import glob
from xml.etree import ElementTree
import re
import datetime

def collect_group_xmls(source_dir):
    ret = {}

    for dirname in os.listdir(source_dir):
        if not os.path.isdir(os.path.join(source_dir, dirname)):
            continue

        group_file_path = os.path.join(source_dir, dirname, "group.xml")
        if not os.path.isfile(group_file_path):
            print("Directory '%s' is missing a group.xml file!" % (os.path.join(source_dir, dirname)))
            continue

        with open(group_file_path, "r") as file:
            try:
                ret[dirname] = (ElementTree.fromstring(file.read()), collect_group_xmls(os.path.join(source_dir, dirname)))
            except ElementTree.ParseError as e:
                print("Encountered a parse error in file '%s', details: %s" % (group_file_path, e))

    return ret

def perform_autoqa(path_prefix, group_tree):
    for f, t in group_tree.iteritems():
        tree, subgroups = t

        group_xml_path = os.path.join(path_prefix, f, "group.xml")

        groups = tree.findall("{http://checklists.nist.gov/xccdf/1.1}Group")
        if len(groups) != 1:
            print("'%s' doesn't have exactly one Group element. Each group.xml file is allowed to have just one group in it, if you want to split a group into two, move the other half to a different folder!" % (group_xml_path))
            continue

        group = groups[0]

        full_path_prefix = os.path.join(path_prefix, f)
        expected_id = "xccdf_org.open-scap.sce-community-content_group_" + full_path_prefix.replace("." + os.path.sep, "").replace(os.path.sep, "_")
        expected_rule_id_prefix = "xccdf_org.open-scap.sce-community-content_rule_" + full_path_prefix.replace("." + os.path.sep, "").replace(os.path.sep, "_") + "-"

        if group.get("id") != expected_id:
            print("Group from '%s' has id '%s', however id '%s' was expected" % (group_xml_path, group.get("id", ""), expected_id))

        for element in tree.findall(".//{http://checklists.nist.gov/xccdf/1.1}Rule"):
            if not element.get("id", "").startswith(expected_rule_id_prefix):
                print("Rule from '%s' has unexpected id '%s', id prefixed with '%s' was expected!" % (group_xml_path, element.get("id", ""), expected_rule_id_prefix))

            checks = element.findall("{http://checklists.nist.gov/xccdf/1.1}check")
            if len(checks) != 1:
                print("Rule of id '%s' from '%s' doesn't have exactly one check element!" % (element.get("id", ""), group_xml_path))
                continue

            check = checks[0]
            
            if check.get("system") != "http://open-scap.org/page/SCE":
                print("Rule of id '%s' from '%s' has system name different from the SCE system name ('http://open-scap.org/page/SCE')!" % (element.get("id", ""), group_xml_path))

            crefs = check.findall("{http://checklists.nist.gov/xccdf/1.1}check-content-ref")
            if len(crefs) != 1:
                print("Rule of id '%s' from '%s' doesn't have exactly one check-content-ref inside its check element!" % (element.get("id", ""), group_xml_path))
                continue
        
            cref = crefs[0]

            if not os.path.isfile(os.path.join(path_prefix, f, cref.get("href", ""))):
                print("Rule of id '%s' from '%s' is referencing a script file that wasn't found! (href is '%s', expected location therefore is '%s')" % (element.get("id", ""), group_xml_path, cref.get("href", ""), os.path.join(path_prefix, f, cref.get("href", ""))))

        perform_autoqa(os.path.join(path_prefix, f), subgroups)

def repath_group_xml_tree(source_dir, new_base_dir, group_tree):
    for f, t in group_tree.iteritems():
        tree, subgroups = t

        old_base_dir = os.path.join(source_dir, f)
        
        path_prefix = os.path.relpath(old_base_dir, new_base_dir)
        for element in tree.findall(".//{http://checklists.nist.gov/xccdf/1.1}check-content-ref"):
            old_href = element.get("href")
            assert(old_href is not None)
            element.set("href", os.path.join(path_prefix, old_href))

        repath_group_xml_tree(old_base_dir, new_base_dir, subgroups)

def merge_trees(target_tree, target_element, group_tree):
    for f in sorted(group_tree.iterkeys()):
        t = group_tree[f]
        tree, subgroups = t

        groups = tree.findall("{http://checklists.nist.gov/xccdf/1.1}Group")
        if len(groups) != 1:
            print("There are %i groups in '%s/group.xml' file. Exactly 1 group is expected! Skipping..." % (len(groups), f))
            continue

        target_element.append(groups[0])

        for child in tree.findall("{http://checklists.nist.gov/xccdf/1.1}Profile"):
            assert(child.get("id") is not None)
            merged = False

            # look through profiles in the template XCCDF
            for profile in target_tree.findall("{http://checklists.nist.gov/xccdf/1.1}Profile"):
                if profile.get("id") == child.get("id"):
                    for profile_child in child.findall("*"):
                        profile.append(profile_child)

                    merged = True
                    break
            
            if not merged:
                print("Found profile of id '%s' that doesn't match any profiles in template, skipped!" % (child.get("id")), sys.stderr)

        merge_trees(target_tree, groups[0], subgroups)

def resolve_selects(target_tree):
    default_selected_rules = set([])
    all_rules = set([])

    for rule in target_tree.findall(".//{http://checklists.nist.gov/xccdf/1.1}Rule"):
        if rule.get("selected", False):
            default_selected_rules.add(rule.get("id", ""))

        all_rules.add(rule.get("id", ""))

    for profile in target_tree.findall("{http://checklists.nist.gov/xccdf/1.1}Profile"):
        selected_rules = set(default_selected_rules)

        to_remove = [] # to avoid invalidating iterators
        for select in profile.findall("*"):
            if select.tag == "{http://checklists.nist.gov/xccdf/1.1}select":
                if select.get("selected", "false") == "true":
                    selected_rules.add(select.get("idref", ""))
                else:
                    selected_rules.remove(select.get("idref", ""))

                to_remove.append(select)

            elif select.tag == "{http://fedorahosted.org/sce-community-content/wiki/XCCDF-fragment}meta-select":
                needle = select.get("idref")
                for rule_id in all_rules:
                    if re.match(needle, rule_id):
                        if select.get("selected", "false") == "true":
                            selected_rules.add(rule_id)
                        elif rule_id in selected_rules:
                            selected_rules.remove(rule_id)

                to_remove.append(select)

        for rm in to_remove:
            profile.remove(rm)

        for rule in selected_rules:
            if rule not in default_selected_rules: # if it's selected by default, we don't care
                elem = ElementTree.Element("{http://checklists.nist.gov/xccdf/1.1}select")
                elem.set("idref", rule)
                elem.set("selected", "true")
                profile.append(elem)

        for rule in default_selected_rules:
            if rule not in selected_rules:
                elem = ElementTree.Element("{http://checklists.nist.gov/xccdf/1.1}select")
                elem.set("idref", rule)
                elem.set("selected", "false")
                profile.append(elem)

def refresh_status(target_tree):
    for status in target_tree.findall("{http://checklists.nist.gov/xccdf/1.1}status"):
        if status.get("date", "") == "${CURRENT_DATE}":
            status.set("date", datetime.date.today().strftime("%Y-%m-%d"))

# taken from http://effbot.org/zone/element-lib.htm#prettyprint
def indent(elem, level=0):
    i = "\n" + level*"  "
    if len(elem):
        if not elem.text or not elem.text.strip():
            elem.text = i + "  "
        if not elem.tail or not elem.tail.strip():
            elem.tail = i
        for elem in elem:
            indent(elem, level+1)
        if not elem.tail or not elem.tail.strip():
            elem.tail = i
    else:
        if level and (not elem.tail or not elem.tail.strip()):
            elem.tail = i

def main():
    if len(sys.argv) != 2:
        print("xccdf_compose.py DIR", sys.stderr)

    else:
        template_file = os.path.join(sys.argv[1], "template.xml")
        group_xmls = collect_group_xmls(sys.argv[1])

        perform_autoqa(sys.argv[1], group_xmls)
        new_base_dir = sys.argv[1]
        repath_group_xml_tree(sys.argv[1], new_base_dir, group_xmls)

        with open(template_file, "r") as file:
            target_tree = ElementTree.fromstring(file.read())

        merge_trees(target_tree, target_tree, group_xmls)
        resolve_selects(target_tree)
        refresh_status(target_tree)

        indent(target_tree)

        with open(os.path.join(sys.argv[1], "all-xccdf.xml"), "w") as file:
            file.write(ElementTree.tostring(target_tree, "utf-8"))

if __name__ == "__main__":
    main()

