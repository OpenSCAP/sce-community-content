ALL_XCCDFS = NISPOM-xccdf.xml rootkit-checks-xccdf.xml sectool-xccdf.xml STIG-xccdf.xml

all: all-xccdf.xml guide.html self-qa

all-xccdf.xml: utils/xccdf_merge.py utils/all-xccdf-template.xml $(ALL_XCCDFS)
	utils/xccdf_merge.py utils/all-xccdf-template.xml $(ALL_XCCDFS) > all-xccdf.xml

guide.html: all-xccdf.xml
	oscap xccdf generate guide all-xccdf.xml > guide.html

eval: all-xccdf.xml
	oscap xccdf eval all-xccdf.xml; exit 0

results.xml: all-xccdf.xml
	oscap xccdf eval --results results.xml all-xccdf.xml; exit 0

self-qa: utils/self-qa.sh all-xccdf.xml
	cd utils; sh self-qa.sh $(ALL_XCCDFS)
	echo "Self-QA done" > self-qa

clean:
	rm -f "all-xccdf.xml"
	rm -f "guide.html"
	rm -f "results.xml"
	rm -f "self-qa"

