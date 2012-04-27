ALL_XCCDFS = NISPOM-xccdf.xml sectool-xccdf.xml STIG-xccdf.xml

all: all-xccdf.xml guide.html self-qa

all-xccdf.xml: utils/xccdf_merge.py utils/all-xccdf-template.xml $(ALL_XCCDFS)
	utils/xccdf_merge.py utils/all-xccdf-template.xml $(ALL_XCCDFS) > all-xccdf.xml

all-resolved-xccdf.xml: all-xccdf.xml
	oscap xccdf resolve -o all-resolved-xccdf.xml all-xccdf.xml

guide.html: all-resolved-xccdf.xml
	oscap xccdf generate guide all-resolved-xccdf.xml > guide.html

eval: all-resolved-xccdf.xml
	oscap xccdf eval all-xccdf.xml; exit 0

results.xml: all-resolved-xccdf.xml
	oscap xccdf eval --results results.xml all-resolved-xccdf.xml; exit 0

report.html: results.xml
	oscap xccdf generate report results.xml > report.html
	
self-qa: utils/self-qa.sh all-xccdf.xml
	cd utils; sh self-qa.sh $(ALL_XCCDFS)
	echo "Self-QA done" > self-qa

clean:
	rm -f "all-xccdf.xml"
	rm -f "all-resolved-xccdf.xml"
	rm -f "guide.html"
	rm -f "results.xml"
	rm -f "report.html"
	rm -f "self-qa"

