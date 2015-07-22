<cfcomponent>
    <cffunction name="writeToStream" output="yes" access="remote" returnformat="plain">
        <cfargument name="filePath"/>
        <cfargument name="contentType"/>

        <cftry>
            <cfscript>
                var _file = FileReadBinary(filePath);

                var context = getPageContext();
                    context.setFlushOutput(false);

                response = context.getResponse().getResponse();
                out = response.getOutputStream();
                response.setContentType(contentType);
                response.setContentLength(arrayLen(_file));

                out.write(_file);
                out.flush();
                out.close();
            </cfscript>

            <cfcatch type="any">
                <cfdump var="#cfcatch#" output="console">
                <cfrethrow>
            </cfcatch>
            <cffinally>
                <cfscript>
                    if (FileExists(filePath)) {
                        FileDelete(filePath);
                    }
                </cfscript>
            </cffinally>
        </cftry>
    </cffunction>


    <cffunction name="isBase64">
        <cfargument name="str">

        <cftry>
            <cfset x = toBinary(str)>
            <cfreturn true>

            <cfcatch type="any">
                <cfreturn false>
            </cfcatch>
        </cftry>
    </cffunction>

    
    <cffunction name="transformMapToStruct">
        <cfargument name="options">

        <cfif not isDefined("options")>
            <cfset options = structNew()>
        </cfif>

        <cfset _options = structNew()>
        <cfloop item="key" collection="#options#">
            <cfset _options[key] = options[key]>
        </cfloop>

        <cfreturn _options>
    </cffunction>

</cfcomponent>