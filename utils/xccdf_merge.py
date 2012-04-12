#!/usr/bin/env python2

import argparse
from xml.etree import ElementTree
parser = argparse.ArgumentParser(description = "Merges 1 or more XCCDFs (just Rules and Groups) into given template XCCDF")
parser.add_argument("template", type = str,
                    help = "The template XCCDF that the merge results will be put into")
parser.add_argument("globs", metavar = "F", type = str, nargs = "+",
                   help = "File or glob of an XCCDF to merge in")

args = parser.parse_args()

import glob
files = []
for g in args.globs:
    gfiles = glob.glob(g)
    files.extend(gfiles)
    if len(gfiles) == 0:
        print("No file matches '%s'" % (g))

template_dom = None
with open(args.template, "r") as file:
    template_dom = ElementTree.fromstring(file.read())

for file_path in files:
    with open(file_path, "r") as file:
        dom = ElementTree.fromstring(file.read())
        
        for child in dom.findall("*"):
            if child.tag.endswith("Group") or child.tag.endswith("Rule"):
                template_dom.append(child)
        
print(ElementTree.tostring(template_dom, "utf-8"))             
