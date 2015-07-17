<cfcomponent extends="utils">


<!---
    Set passwords and encrypt PDF documnets
--->
    <cffunction name="protectPdf" output="yes" access="remote" returnformat="plain">
        <cfargument name="file" type="any">
        <cfargument name="options" type="any">
        <cfargument name="format" default="pdf" type="any">

        <cfset tmpFile = "ram://#createUUID()#.pdf">
        <cfset _options = transformMapToStruct( DeserializeJSON(options) )>

        <cfpdf
                action="protect"
                source="#file#"
                destination="#tmpFile#"
                attributeCollection="#_options#">

        <cfscript>
            returnBinary(tmpFile);
        </cfscript>
    </cffunction>



<!---
    Add footer
--->
    <cffunction name="addFooter"  access="remote">
        <cfargument name="file">
        <cfargument name="options">

        <cfscript>
            var images = arrayNew(1);
            var tmpDir = GetTempDirectory();
            var tmpDir = "#tmpDir##createUUID()#";
            var tmpFile = "";//init

// create tmp dir.
            directoryCreate(tmpDir);

            var tmpFile = GetTempFile(tmpDir, "#createUUID()#.pdf");

            if( not isDefined("options")){
                options = structNew();
            }


        </cfscript>


        <cfset _options = transformMapToStruct(options)>

        <cfif not isDefined("_options.text") and not isdefined("_options.image")>
            <cfthrow message="Missing Footer Text or Image"/>
        </cfif>

        <cftry>
            <cfif isBase64(file)>
                <cffile action="write" file="#tmpFile#" output="#BinaryDecode(file, "Base64")#"/>
                <cfelse>
                <cfset tmpFile = file>
            </cfif>

            <cfpdf
                    action="addFooter"
                    name="pdfResult"
                    source="#tmpFile#"
                    attributeCollection="#_options#">


<!--- Display results --->
<!---cfcontent type="application/pdf" variable="#ToBinary(pdfResult)#" /--->
            <cfreturn BinaryEncode(toBinary(pdfResult), "Base64")>

            <cffinally>
                <cfif directoryExists(tmpDir)>
                    <cfset directoryDelete(tmpDir, true)>
                </cfif>
            </cffinally>
        </cftry>
    </cffunction>


<!---
    Add Header
--->
    <cffunction name="addHeader" access="remote" >
        <cfargument name="file">
        <cfargument name="options">

        <cfscript>
            var images = arrayNew(1);
            var tmpDir = GetTempDirectory();
            var tmpDir = "#tmpDir##createUUID()#";
            var tmpFile = "";//init

// create tmp dir.
            directoryCreate(tmpDir);

            var tmpFile = GetTempFile(tmpDir, "#createUUID()#.pdf");

            if( not isDefined("options")){
                options = structNew();
            }


        </cfscript>


        <cfset _options = transformMapToStruct(options)>

        <cftry>
            <cfif isBase64(file)>
                <cffile action="write" file="#tmpFile#" output="#BinaryDecode(file, "Base64")#"/>
            <cfelse>
                <cfset tmpFile = file>
            </cfif>


            <cfpdf
                    action="addHeader"
                    name="pdfResult"
                    source="#tmpFile#"
                    attributeCollection="#_options#">

            <!--- Display results --->
            <!---cfcontent type="application/pdf" variable="#ToBinary(pdfResult)#" /--->
            <cfreturn BinaryEncode(toBinary(pdfResult), "Base64")>

            <cffinally>
                <cfif directoryExists(tmpDir)>
                    <cfset directoryDelete(tmpDir, true)>
                </cfif>
            </cffinally>
        </cftry>
    </cffunction>


<!---
    Delete headers and footers .
--->
    <cffunction name="removeHeaderFooter">
        <cfargument name="file">
        <cfargument name="options">

        <cfpdf
                action="removeheaderfooter"
                name="pdfResult"
                source="#file#"
                attributeCollection="#options#">


    </cffunction>


<!---
    Delete pages from a PDF document
--->
    <cffunction name="deletePages">
        <cfargument name="file">
        <cfargument name="options">

        <cfpdf
                action="deletepages"
                name="pdfResult"
                source="#file#"
                attributeCollection="#options#">

        <cfreturn pdfResult>
    </cffunction>


<!---
    extract all the words in the PDF.
--->
    <cffunction name="extractText" access="remote">
        <cfargument name="file">
        <cfargument name="options" default="#structNew()#">

        <cfscript>
            var images = arrayNew(1);
            var tmpDir = GetTempDirectory();
            var tmpDir = "#tmpDir##createUUID()#";
            var tmpFile = "";//init

            // create tmp dir.
            directoryCreate(tmpDir);

            var tmpFile = GetTempFile(tmpDir, "#createUUID()#.pdf");

        </cfscript>


        <cfset _options = transformMapToStruct(options)>
        <cfparam name="_options.type" default="xml">
        <cfparam name="_options.pages" default="*">


        <cftry>
            <cfif isBase64(file)>
                <cffile action="write" file="#tmpFile#" output="#BinaryDecode(file, "Base64")#"/>
            <cfelse>
                <cfset tmpFile = file>
            </cfif>


            <cfpdf
                    action="extracttext"
                    name="pdfResult"
                    source="#tmpFile#"
                    attributeCollection="#_options#">

            <cfreturn pdfResult>

            <cffinally>
                <cfif directoryExists(tmpDir)>
                    <cfset directoryDelete(tmpDir, true)>
                </cfif>
            </cffinally>
        </cftry>

    </cffunction>

    <!---
        extract all the images in the PDF.
    --->
    <cffunction name="extractImage" access="remote">
        <cfargument name="file">
        <cfargument name="options">
        <cfscript>
            var images = arrayNew(1);
            var tmpDir = GetTempDirectory();
            var tmpDir = "#tmpDir##createUUID()#";
            var tmpFile = GetTempFile(tmpDir, "#createUUID()#.pdf");

        // create tmp dir.
            directoryCreate(tmpDir);

            if (not isDefined("options")) {
                //options = structNew();
            }
        </cfscript>

        <cftry>
            <cfparam name="options['pages']" default="*"/>
            <cfparam name="options['format']" default="jpg"/>

            <!---
            <cfif not isBinary(file)>
                <cfset tmpFile = file>
            <cfelse>
            </cfif>
            --->
            <cffile action="write" file="#tmpFile#" output="#BinaryDecode(file, "Base64")#"/>


            <cfpdf
                    action="extractimage"
                    overwrite="true"
                    destination="#tmpDir#"
                    pages="*"
                    format="#options['format']#"
                    source="#tmpFile#">

            <cfdirectory name="fileList" action="list" directory="#tmpDir#" filter="*.#options['format']#">
            <cfloop query="#fileList#">
                <cfscript>
                    file = fileReadBinary("#directory#/#name#");
                    fileStruct = structNew();
                    fileStruct.name = name;
                    fileStruct.file = BinaryEncode(file, "Base64");
                    arrayAppend(images, fileStruct);
                    //fileDelete("#directory#/#name#");
                </cfscript>
            </cfloop>
            <cfreturn images>

            <cffinally>
                <cfif directoryExists(tmpDir)>
                    <cfset directoryDelete(tmpDir, true)>
                </cfif>
            </cffinally>
        </cftry>

    </cffunction>


<!---
    Retrieve information about a PDF document
--->
    <cffunction name= 'getInfo' access="remote">
        <cfargument name="file">
        <cfargument name="options">

        <cfscript>
            var images = arrayNew(1);
            var tmpDir = GetTempDirectory();
            var tmpDir = "#tmpDir##createUUID()#";

            // create tmp dir.
            directoryCreate(tmpDir);

            var tmpFile = GetTempFile(tmpDir, "#createUUID()#.pdf");
        </cfscript>

        <cftry>
            <cfif isBase64(file)>
                <cffile action="write" file="#tmpFile#" output="#BinaryDecode(file, "Base64")#"/>
                <cfelse>
                <cfset tmpFile = file>
            </cfif>


            <cfpdf
                    action="getinfo"
                    name="pdfResult"
                    source="#tmpFile#">

            <cfreturn pdfResult>

            <cffinally>
                <cfif directoryExists(tmpDir)>
                    <cfset directoryDelete(tmpDir, true)>
                </cfif>
            </cffinally>
        </cftry>

    </cffunction>


<!---
    Generate thumbnails from pages in a PDF document
--->
    <cffunction name= 'generateThumbnail'>
        <cfargument name="file">
        <cfargument name="options">

        <cfpdf
                action="thumbnail"
                name="pdfResult"
                source="#file#"
                attributeCollection="#options#">

        <cfreturn pdfResult>
    </cffunction>


<!---
    Merge PDF documents into an output PDF file
--->
    <cffunction name= 'mergePdf'>
        <cfargument name="file">
        <cfargument name="options">

        <cfpdf
                action="merge"
                name="pdfResult"
                source="#file#"
                attributeCollection="#options#">

        <cfreturn pdfResult>
    </cffunction>


<!---
    Reduce the quality of a PDF document
--->
    <cffunction name= 'optimizePdf'>
        <cfargument name="file">
        <cfargument name="options">

        <cfpdf
                action="deletepages"
                name="pdfResult"
                source="#file#"
                attributeCollection="#options#">

        <cfreturn pdfResult>
    </cffunction>


<!---
    Use DDX instructions to manipulate PDF documents
--->
    <cffunction name= 'processDDX' access="remote">
        <cfargument name="file">
        <cfargument name="ddx">

        <cfscript>
            var images = arrayNew(1);
            var tmpDir = GetTempDirectory();
            var tmpDir = "#tmpDir##createUUID()#";
            var tmpFile = "";//init

// create tmp dir.
            directoryCreate(tmpDir);

            tmpFile = GetTempFile(tmpDir, "#createUUID()#.pdf");

            var inputStruct=StructNew();
            inputStruct.Doc1 = tmpFile;

            var outputStruct=StructNew();
            outputStruct.Out1="#tmpDir#/output.pdf";

        </cfscript>


        <cftry>
            <cfif isBase64(file)>
                <cffile action="write" file="#tmpFile#" output="#BinaryDecode(file, "Base64")#"/>
                <cfelse>
                <cffile action="write" file="#tmpFile#" output="#file#"/>
            </cfif>

            <cfpdf
                    action="processddx"
                    name="pdfResult"
                    inputfiles="#inputStruct#"
                    outputfiles="#outputStruct#"
                    ddxfile="#ddx#">

            <cfset result = ArrayNew(1)>
            <cfdirectory name="fileList" action="list" directory="#tmpDir#" filter="output.pdf">
            <cfloop item="item" collection="#outputStruct#">
                <cfscript>
                    file = fileReadBinary("#outputStruct[item]#");
                    fileStruct = structNew();
                    fileStruct.name = name;
                    fileStruct.file = BinaryEncode(file, "Base64");
                    arrayAppend(result, fileStruct);
//fileDelete("#directory#/#name#");
                </cfscript>
            </cfloop>
            <cfdump var="#result#" output="console" abort="true"/>
            <cfreturn result>


            <cfcatch type="any">
                <cfdump var="#cfcatch#" output="console">
            </cfcatch>
            <cffinally>
                <cfif directoryExists(tmpDir)>
                    <cfset directoryDelete(tmpDir, true)>
                </cfif>
            </cffinally>
        </cftry>

    </cffunction>




<!---
    Add a watermark to a PDF document
--->
    <cffunction name="addWatermark">
        <cfargument name="file">
        <cfargument name="options">

        <cfpdf
                action="addwatermark"
                name="pdfResult"
                source="#file#"
                attributeCollection="#options#">

        <cfreturn pdfResult>
    </cffunction>



<!---
    Remove a watermark from a PDF document
--->
    <cffunction name="removeWatermark">
        <cfargument name="file">
        <cfargument name="options">

        <cfpdf
                action="removewatermark"
                name="pdfResult"
                source="#file#"
                attributeCollection="#options#">

        <cfreturn pdfResult>
    </cffunction>



<!---
    Page level transformations
--->
    <cffunction name= 'transformPdf'>
        <cfargument name="file">
        <cfargument name="options">

        <cfpdf
                action="transform"
                name="pdfResult"
                source="#file#"
                attributeCollection="#options#">

        <cfreturn pdfResult>
    </cffunction>



<!---
    Set information about a PDF document
--->
    <cffunction name= 'setPdfInfo' access="remote">
        <cfargument name="file">
        <cfargument name="options">


        <cfscript>
            var images = arrayNew(1);
            var tmpDir = GetTempDirectory();
            var tmpDir = "#tmpDir##createUUID()#";

// create tmp dir.
//directoryCreate(tmpDir);

            var tmpFile = "ram://#createUUID()#.pdf";
        </cfscript>


        <cftry>
            <cfset _options = transformMapToStruct(options)>

            <cfif isBase64(file)>
                <cffile action="write" file="#tmpFile#" output="#BinaryDecode(file, "Base64")#"/>
            <cfelse>
                <cfset tmpFile = file>
            </cfif>


            <cfpdf
                    action="setinfo"
                    name="pdfResult"
                    source="#tmpFile#"
                    attributeCollection="#_options#">

            <cfreturn pdfResult>

            <cffinally>
            </cffinally>
        </cftry>

    </cffunction>

</cfcomponent>