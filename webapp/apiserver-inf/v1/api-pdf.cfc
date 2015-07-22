<cfcomponent extends="utils">


    <cffunction name="executeForPdf" output="yes" access="remote" returnformat="plain">
        <cfargument name="action" required="true" type="any">
        <cfargument name="file" required="true" type="any">
        <cfargument name="options" required="true" type="any">

        <cfdump var="#arguments#" output="console"/>

        <cfset tmpOutputFile = "ram:///#createUUID()#.pdf">
        <cfset _options = DeserializeJSON(options) >

        <cftry>
            <cfif isdefined("arguments.image")>

                <cfpdf
                        action="#action#"
                        overwrite="true"
                        source="#file#"
                        image="#imageRead(image)#"
                        destination="#tmpOutputFile#"
                        attributeCollection="#_options#">

            <cfelse>

                <cfpdf
                        action="#action#"
                        overwrite="true"
                        source="#file#"
                        destination="#tmpOutputFile#"
                        attributeCollection="#_options#">

            </cfif>

            <cfcontent file="#tmpOutputFile#" type="application/pdf" deletefile="yes">

            <cfcatch type="any">
                <cfdump var="#cfcatch#" output="console"/>

                <cfheader statuscode="400" statustext="#cfcatch.detail#"/>
                <cfcontent type="application/json">
                <cfreturn SerializeJSON(cfcatch)/>
            </cfcatch>
        </cftry>
    </cffunction>


    <cffunction name="executeMultipleFilesForPdf" output="yes" access="remote" returnformat="plain">
        <cfargument name="action" required="true" type="any">
        <cfargument name="files" required="false" type="any">
        <cfargument name="options" required="true" type="any">

<cfdump var="#arguments#" output="console"/>

        <cfset tmpOutputFile = "ram:///#createUUID()#.pdf">
        <cfset _options = DeserializeJSON(options) >

        <cftry>
            <cfpdf
                    action="#action#"
                    overwrite="true"
                    source="#files#"
                    destination="#tmpOutputFile#"
                    attributeCollection="#_options#"/>


            <cfcontent file="#tmpOutputFile#" type="application/pdf" deletefile="yes">

            <cfcatch type="any">
                <cfheader statuscode="400" statustext="#cfcatch.detail#"/>
                <cfcontent type="application/json">
                <cfreturn SerializeJSON(cfcatch)/>
            </cfcatch>
        </cftry>
    </cffunction>



    <cffunction name="executeForZip" output="yes" access="remote" returnformat="plain">
        <cfargument name="action" required="true" type="any">
        <cfargument name="file" required="true" type="any">
        <cfargument name="options" required="true" type="any">

<cfdump var="#arguments#" output="console"/>

        <cftry>
            <cfset _options = DeserializeJSON(options) >

            <cfset tmpOutputDir = "#getTempDirectory()#/#createUUID()#">
            <cfset tmpOutputFile = "ram:///#createUUID()#.zip">
            <cfdirectory action = "create" directory = "#tmpOutputDir#">

            <cfpdf
                    action="#action#"
                    overwrite="true"
                    source="#file#"
                    destination="#tmpOutputDir#"
                    attributeCollection="#_options#">

            <cfzip action="zip"
                    source="#tmpOutputDir#"
                    file="#tmpOutputFile#">

            <cfdirectory action="delete" directory = "#tmpOutputDir#" recurse="true">
            <cfcontent file="#tmpOutputFile#" type="application/zip" deletefile="yes">

            <cfcatch type="any">
                <cfheader statuscode="400" statustext="#cfcatch.detail#"/>
                <cfcontent type="application/json">
                <cfreturn SerializeJSON(cfcatch)/>
            </cfcatch>
        </cftry>

    </cffunction>




    <cffunction name="executeForData" output="yes" access="remote" returnformat="JSON">
        <cfargument name="action" required="true" type="any">
        <cfargument name="file" required="true" type="any">
        <cfargument name="options" required="true" type="any">

<cfdump var="#arguments#" output="console"/>

        <cfset tmpOutputFile = "ram:///#createUUID()#.pdf">
        <cfset _options = DeserializeJSON(options) >

        <cftry>

            <cfpdf
                    action="#action#"
                    overwrite="true"
                    source="#file#"
                    name="results"
                    attributeCollection="#_options#">

            <cfreturn results/>
            <cfcatch type="any">
                <cfheader statuscode="400" statustext="#cfcatch.detail#"/>
                <cfcontent type="application/json">
                <cfreturn cfcatch/>
            </cfcatch>
        </cftry>

    </cffunction>




</cfcomponent>