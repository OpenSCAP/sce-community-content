#!/usr/bin/env python2

from xml.etree import ElementTree
import sys

import xccdf_compose


if len(sys.argv) < 3:
    print >>sys.stderr, "Usage: %s <file> <append0> ..." % sys.argv[0]
    exit(1)

with open(sys.argv[1]) as inf:
    base = ElementTree.fromstring(inf.read())

for app_fn in sys.argv[2:]:
    with open(app_fn) as inf:
        ext = ElementTree.fromstring(inf.read())

    base.extend(ext)

xccdf_compose.indent(base)
sys.stdout.write(ElementTree.tostring(base, "utf-8"))
sys.stdout.flush()
