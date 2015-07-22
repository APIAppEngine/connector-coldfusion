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

<cfcomponent output="false"  extends="utils">

    <cffunction name="writeToStream" output="yes" access="remote" returnformat="plain">
        <cfargument name="filePath"/>
        <cfargument name="format"/>

        <cftry>
            <cfscript>
                _file = FileReadBinary(filePath);

                context = getPageContext();
                context.setFlushOutput(false);
                response = context.getResponse().getResponse();
                out = response.getOutputStream();
                response.setContentType("image/#arguments.format#");
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
                    if (FileExists(dest)) {
                        FileDelete(dest);
                    }
                </cfscript>
            </cffinally>
        </cftry>
    </cffunction>


    <cffunction name="addBorder" output="yes" access="remote" returnFormat="plain">
        <cfargument name="image"/>
        <cfargument name="color" default="black"/>
        <cfargument name="thickness" default="10"/>
        <cfargument name="format" default="png"/>

        <cfset dest = "ram:///#CreateUUID()#.#arguments.format#">

        <cfimage
                action="border"
                quality="1"
                color="#arguments.color#"
                thickness="#arguments.thickness#"
                source="#ImageNew(image)#"
                destination="#dest#"
                format="#format#">

        <cfscript>
            writeToStream(dest, format);
        </cfscript>

    </cffunction>


    <cffunction name="resizeImage" output="yes" access="remote" returnformat="plain">
        <cfargument name="image"/>
        <cfargument name="width" default="1024"/>
        <cfargument name="height" default="768"/>
        <cfargument name="interpolation" default="bicubic"/>
        <cfargument name="scaleToFit" default="false"/>
        <cfargument name="format" default="png"/>

        <cfset dest = "ram:///#CreateUUID()#.#arguments.format#">

        <cfimage
                action="resize"
                quality="1"
                width="#arguments.width#"
                height="#arguments.height#"
                interpolation="#arguments.interpolation#"
                source="#ImageNew(arguments.image)#"
                destination="#dest#"
                format="#format#">

        <cfscript>
            writeToStream(dest, format);
        </cfscript>
    </cffunction>


    <cffunction name="rotateImage" output="yes" access="remote" returnformat="plain">
        <cfargument name="image"/>
        <cfargument name="angle" default="90"/>
        <cfargument name="format" default="png"/>

        <cfset dest = "ram:///#CreateUUID()#.#arguments.format#">

        <cfimage
                action="rotate"
                angle="#arguments.angle#"
                source="#ImageNew(arguments.image)#"
                destination="#dest#"
                format="#format#">


        <cfscript>
            writeToStream(dest, format);
        </cfscript>

    </cffunction>


    <cffunction name="addText" output="yes" access="remote" returnFormat="plain">
        <cfargument name="image"/>
        <cfargument name="text"/>
        <cfargument name="color"/>
        <cfargument name="fontSize"/>
        <cfargument name="fontStyle"/>
        <cfargument name="angle" type="numeric"/>
        <cfargument name="x" type="numeric"/>
        <cfargument name="y" type="numeric"/>
        <cfargument name="format" default="png"/>

        <CFIF arguments.angle gt 0>
            <cfthrow detail="Not Implemented Yet"/>
        </cfif>

        <cfset fileName = "#CreateUUID()#.#arguments.format#">
        <cfset dest = "ram:///#fileName#">

        <cfset myImage = ImageNew(arguments.image)>

        <cfset ImageSetDrawingColor(myImage, arguments.color)>
        <cfset attr = StructNew()>
        <cfset attr.size = val(arguments.fontSize) & "">
        <cfset attr.style = arguments.fontStyle>
        <cfset ImageDrawText(myImage, text, arguments.x, arguments.y, attr)>
        <cfset ImageWrite(myImage, dest, true, 1)>

        <cfscript>
            writeToStream(dest, format);
        </cfscript>
    </cffunction>

<!---

<cffunction name="imageMetadata" access="remote" returntype="any" returnformat="plain">
    <cfargument name="image"/>


	<cfset dest="#GetTempDirectory()#/#CreateUUID()#.#arguments.format#">

	<cftry>
		<cfimage
            action="read"
            source="#arguments.image#"
            destination="#dest#">


	    			<cfscript>
						_file = FileReadBinary(dest);

						context = getPageContext();
						context.setFlushOutput(false);
						response = context.getResponse().getResponse();
						out = response.getOutputStream();
						response.setContentType("image/#arguments.format#");
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
						if( FileExists(dest) ){
							FileDelete(dest);
						}
					</cfscript>
				</cffinally>
			</cftry>
</cffunction>






<cffunction name="generateCaptcha" access="remote" returntype="any" returnformat="plain">
    <cfargument name="difficulty"/>
    <cfargument name="width"/>
    <cfargument name="height"/>
    <cfargument name="text"/>
    <cfargument name="fontSize" default="40"/>
    <cfargument name="fontFamily" default="Verdana,Arial,Courier New,Courier"/>

	<cfset dest="#GetTempDirectory()#/#CreateUUID()#.#arguments.format#">

	<cftry>
    	<cfimage
            action="captcha"
            difficulty="#arguments.difficulty#"
            width="#arguments.width#"
            height="#arguments.height#"
            text="#arguments.text#"
            fontSize="#fontSize#"
            fonts="#fontFamily#"
            destination="#dest#">


			<cfscript>
				_file = FileReadBinary(dest);

				context = getPageContext();
				context.setFlushOutput(false);
				response = context.getResponse().getResponse();
				out = response.getOutputStream();
				response.setContentType("image/#arguments.format#");
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
				if( FileExists(dest) ){
					FileDelete(dest);
				}
			</cfscript>
		</cffinally>
	</cftry>
</cffunction>


<cffunction name="dump" access="remote" returnformat="json" returntype="String">
    <cfargument name="data">

    <cfsavecontent variable="dump">
        <cfdump var="#data#" expand="true"/>
    </cfsavecontent>

    <cfreturn dump>
</cffunction>

--->
</cfcomponent>