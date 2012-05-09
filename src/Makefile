XCCDF_DEPS=$(find . -name group.xml)

all: all-xccdf.xml guide.html

all-xccdf.xml: $(XCCDF_DEPS)
	../utils/xccdf_compose.py .

all-resolved-xccdf.xml: all-xccdf.xml
	oscap xccdf resolve -o all-resolved-xccdf.xml all-xccdf.xml

guide.html: all-resolved-xccdf.xml
	oscap xccdf generate guide all-resolved-xccdf.xml > guide.html

eval: all-resolved-xccdf.xml
	oscap xccdf eval all-resolved-xccdf.xml; exit 0

results.xml: all-resolved-xccdf.xml
	oscap xccdf eval --results results.xml all-resolved-xccdf.xml; exit 0

report.html: results.xml
	oscap xccdf generate report results.xml > report.html
	
clean:
	rm -f "all-xccdf.xml"
	rm -f "all-resolved-xccdf.xml"
	rm -f "guide.html"
	rm -f "results.xml"
	rm -f "report.html"

