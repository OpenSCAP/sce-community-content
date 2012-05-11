#!/usr/bin/env python2

import os
import sys
import glob
from xml.etree import ElementTree

def collect_group_xmls(source_dir):
    ret = {}

    dirnames = set()

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
    for f, t in group_tree.iteritems():
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

        new_base_dir = sys.argv[1]
        repath_group_xml_tree(sys.argv[1], new_base_dir, group_xmls)

        with open(template_file, "r") as file:
            target_tree = ElementTree.fromstring(file.read())

        merge_trees(target_tree, target_tree, group_xmls)
        
        indent(target_tree)

        with open(os.path.join(sys.argv[1], "all-xccdf.xml"), "w") as file:
            file.write(ElementTree.tostring(target_tree, "utf-8"))

if __name__ == "__main__":
    main()

