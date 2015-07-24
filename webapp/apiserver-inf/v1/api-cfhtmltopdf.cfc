<cfcomponent displayname="api-cfdocument" extends="utils">


    <cffunction name="urlToPdf" output="yes" access="remote" returnformat="plain">
        <cfargument name="url" type="string">
        <cfargument name="options" type="any" default="#structNew()#">

        <cfdump var="#options#" output="console"/>
        <cfscript>
            if( isJSON(arguments.options) )
            {
                arguments.options = DeserializeJSON(arguments.options);
            }
        </cfscript>


        <cfhtmltopdf
                name="pdfResult"
                source="#options.url#"
                attributeCollection="#options#"/>

        <cfcontent variable="#pdfResult#" type="application/pdf">

    </cffunction>



    <cffunction name="htmlToPdf" output="yes" access="remote" returnformat="plain">
        <cfargument name="options" type="any" default="#structNew()#">

        <cfscript>
            this.headerHtml = "";
            this.footerHtml = "";
            jsonMap = DeserializeJSON(arguments.options);
            arguments.options = jsonMap;
        </cfscript>

        <cfoutput>
            <cfhtmltopdf
                    name="pdfResult"
                    attributeCollection="#arguments.options#">
                #options.html#
            </cfdocument>
        </cfoutput>

        <cfcontent variable="#pdfResult#" type="application/pdf">
    </cffunction>



</cfcomponent>