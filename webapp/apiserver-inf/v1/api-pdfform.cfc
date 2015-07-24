<!---~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 Copyright (c) 2013 Mike Nimer.

 This file is part of ApiServer Project.

 The ApiServer Project is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 The ApiServer Project is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with the ApiServer Project.  If not, see <http://www.gnu.org/licenses/>.
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--->

<cfcomponent>



    <cffunction name="extractFormFieldsAsXml" output="yes" access="remote" returntype="xml" returnformat="plain">
        <cfargument name="file">
        <cfargument name="options" type="any">

        <cftry>
            <!--- fdf XML --->
            <cfpdfform
                    action="read"
                    source="#file#"
                    XMLdata="xmlResult"/>

            <cfreturn xmlResult/>

            <cfcatch type="any">
                <cfheader statuscode="400" statustext="#cfcatch.detail#"/>
                <cfcontent type="application/json">
                <cfreturn cfcatch/>
            </cfcatch>
        </cftry>
    </cffunction>




    <cffunction name="extractFormFieldsAsJson" output="yes" access="remote" returntype="string" returnformat="json">
        <cfargument name="file">
        <cfargument name="options" type="any">

        <cftry>
            <!--- json --->
            <cfpdfform
                    action="read"
                    source="#file#"
                    result="pdfResult"/>

            <cfreturn serializeJSON(pdfResult)/>

            <cfcatch type="any">
                <cfheader statuscode="400" statustext="#cfcatch.detail#"/>
                <cfcontent type="application/json">
                <cfreturn cfcatch/>
            </cfcatch>
        </cftry>
    </cffunction>



    <cffunction name="populateFormFields" access="remote" returntype="Any">
        <cfargument name="file"/>
        <cfargument name="options" required="true" type="any">

        <cfdump var="#arguments#" output="console"/>
        <cftry>
            <cfset _options = DeserializeJSON(options) >
            <cfset tmpOutputFile = "#getTempDirectory()#/#createUUID()#.pdf">


            <cfpdfform
                    action="populate"
                    source="#file#"
                    attributeCollection="#_options#"
                    destination="#tmpOutputFile#">
            </cfpdfform>

            <cfcontent file="#tmpOutputFile#" type="application/pdf" deletefile="yes">

            <cfcatch type="any">
                <cfdump var="#cfcatch#" output="console"/>
                <cfheader statuscode="400" statustext="#cfcatch.detail#"/>
                <cfcontent type="application/json">
                <cfreturn cfcatch/>
            </cfcatch>
        </cftry>
    </cffunction>


</cfcomponent>

