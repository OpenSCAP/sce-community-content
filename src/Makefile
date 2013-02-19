GROUP_FILES=$(shell find . -name group.xml -printf "%h/%f ")
OSCAP=oscap

all: all-xccdf.xml guide.html sds-datastream.xml

all-xccdf.xml: template.xml $(GROUP_FILES) ../utils/xccdf_compose.py
	../utils/xccdf_compose.py .
	$(OSCAP) xccdf validate-xml all-xccdf.xml

all-resolved-xccdf.xml: all-xccdf.xml
	$(OSCAP) xccdf resolve -o all-resolved-xccdf.xml all-xccdf.xml

guide.html: all-resolved-xccdf.xml
	$(OSCAP) xccdf generate guide all-resolved-xccdf.xml > guide.html

eval: all-resolved-xccdf.xml
	$(OSCAP) xccdf eval all-resolved-xccdf.xml; exit 0

results.xml: all-resolved-xccdf.xml
	$(OSCAP) xccdf eval --results results.xml all-resolved-xccdf.xml; exit 0

report.html: results.xml
	$(OSCAP) xccdf generate report results.xml > report.html

sds-datastream.xml: all-xccdf.xml
	$(OSCAP) ds sds-compose sds-datastream.xml sds-datastream.xml
	
clean:
	rm -f "all-xccdf.xml"
	rm -f "all-resolved-xccdf.xml"
	rm -f "guide.html"
	rm -f "results.xml"
	rm -f "report.html"
	rm -f "sds-datastream.xml"
