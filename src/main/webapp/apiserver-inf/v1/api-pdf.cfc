<cfcomponent extends="utils">


<!---
    Set passwords and encrypt PDF documnets
--->
    <cffunction name="execute" output="yes" access="remote" returnformat="plain">
        <cfargument name="action" required="true" type="any">
        <cfargument name="file" required="true" type="any">
        <cfargument name="options" required="true" type="any">

        <cfset tmpOutputFile = "ram:///#createUUID()#.pdf">
        <cfset _options = DeserializeJSON(options) >


        <cfpdf
                action="#action#"
                overwrite="true"
                source="#file#"
                destination="#tmpOutputFile#"
                attributeCollection="#_options#">

        <cfscript>
            //writeToStream(tmpOutputFile, "application/pdf");
        </cfscript>

        <cfscript>
            var _file = FileReadBinary(tmpOutputFile);

            var context = getPageContext();
            context.setFlushOutput(false);

            response = context.getResponse().getResponse();
            out = response.getOutputStream();
            response.setContentType("application/pdf");
            response.setContentLength(arrayLen(_file));

            out.write(_file);
            out.flush();
            out.close();
        </cfscript>
    </cffunction>



</cfcomponent>