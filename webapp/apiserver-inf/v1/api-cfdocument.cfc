<cfcomponent extends="utils">

    <cffunction name="urlToPdf" access="remote" returntype="Binary">
        <cfargument name="path" type="string">
        <cfargument name="options" type="any" default="#structNew()#">

        <cfdump var="#options#" output="console"/>
        <cfscript>
            if( isJSON(arguments.options) )
            {
                arguments.options = DeserializeJSON(arguments.options);
            }
        </cfscript>

        <cfdocument
                format="pdf"
                src="#path#" name="pdfResult"
                attributeCollection="#options#"></cfdocument>

        <cfreturn pdfResult/>
    </cffunction>



    <cffunction name="htmlToPdf" >
        <cfargument name="HTML" type="string">
        <cfargument name="HEADERHTML" type="string" default="default header">
        <cfargument name="FOOTERHTML" type="string" default="default footer">
        <cfargument name="OPTIONS" type="STRUCT" default="#structNew()#">

        <cfparam name="HEADERHTML" default="default header2"/>

        <cfdump var="#arguments#" output="console">

        <cfscript>
            if( isJSON(arguments.options) )
            {
                arguments.options = DeserializeJSON(arguments.options);
            }
        </cfscript>

        <cfoutput>
            <cfdocument
                    name="pdfResult"
                    format="pdf"
                    attributeCollection="#arguments.options#">
                <cfdocumentitem type="header">Header:<cfif isDefined("HEADERHTML")>#HEADERHTML#</cfif></cfdocumentitem>
                #HTML#

                <cfdocumentitem type="footer" evalatprint="true">
                    <cfoutput>#cfdocument.currentpagenumber# of #cfdocument.totalpagecount#</cfoutput>
                </cfdocumentitem>
            </cfdocument></cfoutput>

        <cfreturn pdfResult/>
    </cffunction>



</cfcomponent>