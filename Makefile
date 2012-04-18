all-xccdf.xml: rootkit-checks-xccdf.xml sectool-xccdf.xml STIG-xccdf.xml
	utils/xccdf_merge.py utils/all-xccdf-template.xml rootkit-checks-xccdf.xml sectool-xccdf.xml STIG-xccdf.xml > all-xccdf.xml

clean:
	rm -f "all-xccdf.xml"

