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
            
    return ElementTree.tostring(template_dom, "utf-8")

def process(template, globs):
    files = []
    for g in globs:
        gfiles = glob.glob(g)
        files.extend(gfiles)
        if len(gfiles) == 0:
            print("No file matches '%s'" % (g))

    return merge_files(template, files)

def main():
    if len(sys.argv) < 3:
        print("xccdf_merge.py TEMPLATE FILE [FILE] ..")
    else:
        template = sys.argv[1]
        files = sys.argv[2:]

        print(process(template, files))

if __name__ == "__main__":
    main()


