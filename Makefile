all: all-xccdf.xml guide.html qa

all-xccdf.xml: utils/xccdf_merge.py rootkit-checks-xccdf.xml sectool-xccdf.xml STIG-xccdf.xml
	utils/xccdf_merge.py utils/all-xccdf-template.xml rootkit-checks-xccdf.xml sectool-xccdf.xml STIG-xccdf.xml > all-xccdf.xml

guide.html: all-xccdf.xml
	oscap xccdf generate guide all-xccdf.xml > guide.html

eval: all-xccdf.xml
	oscap xccdf eval all-xccdf.xml; exit 0

qa: all-xccdf.xml
	cd utils; sh self-qa.sh

clean:
	rm -f "all-xccdf.xml"
	rm -f "guide.html"

