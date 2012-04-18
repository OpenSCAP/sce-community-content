#!/usr/bin/env python2

import sys
import glob
from xml.etree import ElementTree

def merge_files(template, files):
    template_dom = None
    with open(template, "r") as file:
        template_dom = ElementTree.fromstring(file.read())

    for file_path in files:
        with open(file_path, "r") as file:
            dom = ElementTree.fromstring(file.read())
            
            for child in dom.findall("*"):
                if child.tag.endswith("Group") or child.tag.endswith("Rule"):
                    template_dom.append(child)

                elif child.tag.endswith("Profile"):
                    assert(child.get("id") is not None)
                    merged = False

                    # look through profiles in the template XCCDF
                    for profile in template_dom.findall("*"):
                        # internal note: we avoid doing findall("Profile") here
                        # because that would be namespace sensitive, robustness > correctness
                        
                        if not profile.tag.endswith("Profile"):
                            continue

                        if profile.get("id") == child.get("id"):
                            for select in child.findall("*"): 
                                # again, we want to be robust when it comes to namespaces
                                if not select.tag.endswith("select"):
                                    continue

                                profile.append(select)

                            merged = True
                            break
                    
                    if not merged:
                        print("'%s' contains Profile of id '%s' that doesn't match any profiles in template, skipped!" % (file_path, child.get("id")), sys.stderr)

    return ElementTree.tostring(template_dom, "utf-8")

def process(template, globs):
    files = []
    for g in globs:
        gfiles = glob.glob(g)
        files.extend(gfiles)
        if len(gfiles) == 0:
            print("No file matches '%s'" % (g), sys.stderr)

    return merge_files(template, files)

def main():
    if len(sys.argv) < 3:
        print("xccdf_merge.py TEMPLATE FILE [FILE] ..", sys.stderr)
    else:
        template = sys.argv[1]
        files = sys.argv[2:]

        print(process(template, files))

if __name__ == "__main__":
    main()

