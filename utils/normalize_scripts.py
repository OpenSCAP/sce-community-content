#!/usr/bin/env python2

import os.path
import re
import shutil
from xml.etree import ElementTree

NS_XCCDF = lambda s: '{http://checklists.nist.gov/xccdf/1.2}%s' % s
TAG_PROFILE = NS_XCCDF('Profile')
TAG_SELECT = NS_XCCDF('select')
TAG_RULE = NS_XCCDF('Rule')
TAG_GROUP = NS_XCCDF('Group')
TAG_FIX = NS_XCCDF('fix')
TAG_CHECK_CONTENT_REF = NS_XCCDF('check-content-ref')


def scan(path):
    for sub in os.listdir(path):
        full = os.path.join(path, sub)
        if sub == 'group.xml':
            yield path

        elif os.path.isdir(full):
            for res in scan(full):
                yield res


def handle_group_file(path):
    output = []
    print '---', path
    with open(os.path.join(path, 'group.xml')) as xml:
        tree = ElementTree.fromstring(xml.read())

    for item in tree.findall('.//%s' % TAG_RULE):
        content_ref_item = item.find('.//%s' % TAG_CHECK_CONTENT_REF)
        content_ref = content_ref_item.attrib['href']

        print '  %s: %s' % (item.attrib['id'], content_ref)

        filename = item.attrib['id'].rsplit('-', 1)[1] + '.sh'
        content_ref_item.attrib['href'] = filename

        shutil.move(os.path.join(path, content_ref), os.path.join(path, filename))

    with open(os.path.join(path, 'group.xml'), 'w') as xml:
        xml.write(ElementTree.tostring(tree))

ElementTree.register_namespace('xf', 'http://fedorahosted.org/sce-community-content/wiki/XCCDF-fragment')
ElementTree.register_namespace('xhtml', 'http://www.w3.org/1999/xhtml')
ElementTree.register_namespace('', 'http://checklists.nist.gov/xccdf/1.2')
for path in scan('.'):
    print '---', path
    handle_group_file(path)
