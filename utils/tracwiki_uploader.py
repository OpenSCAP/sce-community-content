#!/usr/bin/env python2

# Nasty little script that uploads any given files as attachments to given page
# on sce community content wiki.
#
# This is used to upload guides and result reports from automatic runs on
# various machines.
#
# copyright (c) 2012 Red Hat, Inc.
# license: GPLv2+
# author: Martin Preisler <mpreisle@redhat.com>

BASE_URI="fedorahosted.org/sce-community-content"

def main():
    import sys
    import xmlrpclib
    import base64

    # I would use argparse but it's not in python 2.6 which is still prevalent
    # on older systems.
    if len(sys.argv) != 6:
        print("Invalid arguments!")
        print("tracwiki_uploader.py username password wiki_page wiki_attachment_name wiki_attachment_source_file")
        exit(1)

    # we do no sanitization or checks of any passed data
    username = sys.argv[1]
    password = sys.argv[2]
    wiki_pagename = sys.argv[3]
    wiki_attachment_name = sys.argv[4]
    wiki_attachment_source_file = sys.argv[5]

    uri = "https://%s:%s@%s/login/rpc" % (username, password, BASE_URI)
    # uncomment if you need to debug, printing password to stdout by default
    # is not a good idea
    #print("Connecting to '%s'..." % (uri))
    server = xmlrpclib.ServerProxy(uri)
    print("Reading attachment source...")
    
    data = None
    with open(wiki_attachment_source_file, "r") as f:
        # xmlrpclib's base64 wrapper, can't pass base64.b64encode data
        data = xmlrpclib.Binary(f.read())
    assert(data is not None)

    print("Uploading attachment...")
    server.wiki.putAttachmentEx(wiki_pagename, wiki_attachment_name, "", data, True)
    print("done!")

if __name__ == "__main__":
    main()

