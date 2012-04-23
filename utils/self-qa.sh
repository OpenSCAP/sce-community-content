#!/usr/bin/env sh

# Checks for issues within SCE community content itself
#
# requirements:
#   - perl-XML-XPath (I would use xmllint --xpath but it doesn't work well default namespaces)
#   - xmllint
#
# what does it do:
#   - validates all XCCDFs
#   - checks for missing stdout check-import

BASE_DIR="../"
INPUT_XCCDF="$@"
ALL_XCCDF="all-xccdf.xml"
XCCDF_SCHEMA="/usr/share/openscap/schemas/xccdf/1.1/xccdf-schema.xsd"

pushd $BASE_DIR > /dev/null

for file in $INPUT_XCCDF $ALL_XCCDF; do
    xmllint --schema "$XCCDF_SCHEMA" $file > /dev/null

    missing_check_import=$(xpath $file "//check[not(check-import[@import-name='stdout'])]" 2> /dev/null)
    if [[ "$missing_check_import" != "" ]]; then
        echo "stdout check-import is missing in $file, details follow:"
        echo $missing_check_import
        echo
    fi
done

missing_stig_idents=$(xpath STIG-xccdf.xml "//Rule[not(ident[@system='http://iase.disa.mil/stigs'])]" 2> /dev/null)
if [[ "$missing_stig_idents" != "" ]]; then
    echo "at least one STIG check is missing an <ident> entry, details follow:"
    echo $missing_stig_idents
    echo
fi

# TODO: Check that STIG checks ident match check-content-ref/@href

popd > /dev/null

