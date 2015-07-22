
<cffile file="/Users/mnimer/Development/github/APIAppEngine/service-pdf/src/test/resources/testdoc-annualreportfromword.pdf"
    variable="source"/>

<cfpdf
        action="protect"
        source="#source#"
        destination="/Users/mnimer/Development/github/APIAppEngine/service-pdf/src/test/resources/test.pdf"
        newUserPassword="admin" overwrite="true">