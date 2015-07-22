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


        <cfdocument
                name="pdfResult"
                format="pdf"
                attributeCollection="#options#"></cfdocument>

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
            <cfdocument
                    name="pdfResult"
                    format="pdf"
                    attributeCollection="#arguments.options#">
                <cfif isDefined("jsonMap.headerhtml")><cfdocumentitem type="header">#jsonMap.headerhtml#</cfdocumentitem></cfif>
                #options.html#
                <cfif isDefined("jsonMap.footerhtml")><cfdocumentitem type="footer">#jsonMap.footerhtml#</cfdocumentitem></cfif>
            </cfdocument>
        </cfoutput>

        <cfcontent variable="#pdfResult#" type="application/pdf">
    </cffunction>



</cfcomponent>