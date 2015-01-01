<!---
Upload script for CKEditor.
Be careful about who is able to access this file
The upload folder shouldn't be able to upload any kind of script, just in case.
 --->
<cffunction name="processUpload" access="remote" output="false" returntype="string" returnformat="plain">
    <cfset var funcNum = url.CKEditorFuncNum><!--- required: function number as indicated by CKEditor --->
    <cfset var CKEditor = url.CKEditor><!--- optional: instance name (might be used to adjust the server folders for example) --->
    <cfset var langCode = url.langCode><!--- optional: Tt provide localized messages --->
    <cfset var bSession = false>
    <cfset var basePath = "">
    <cfset var baseUrl = "">
    <cfset var sFileName = "">

    <!--- url that should be used for the upload folder (it the URL to access the folder that you have set in $basePath.
    	you can use a relative url "/images/", or a path including the host "http://example.com/images/".
    	ALWAYS put the final slash (/) --->
    <cfset var baseUrl = application.applicationname & "/_files/ckeditorfiles/">

	<!--- full absolute path of the folder where you want to save the files.
		You must set the proper permissions on that folder --->
    <cfset basePath = application.applicationname & "/_files/ckeditorfiles/">

    <!--- verify that the user is logged in and is allowed to use the script --->
    <cfif NOT bSession>
        <cfreturn sendError("You're not allowed to upload files", funcNum)>
    </cfif>

	<!--- verify the file mimetype --->
	<cfset sFileName = getClientFileName("upload")>
	<cfif NOT listFindNoCase("jpg,gif,png", listLast(sFileName,"."))>
	    <cfreturn sendError("You're not allowed to upload files with this mimetype", funcNum)>
	</cfif>

	<cffile action="UPLOAD" filefield="upload" destination="#basePath#" nameconflict="MAKEUNIQUE">
	<cfset sFileName = baseUrl & replace(cffile.serverFile, "'", "\'", "all")>

	<!--- write output --->
    <cfreturn "<scr" & "ipt type='text/javascript'>window.parent.CKEDITOR.tools.callFunction(" & funcNum & ", '" & sFileName & "', '')</scr" & "ipt>">
</cffunction>

<!--- helper methods --->
<cffunction name="sendError" output="false" returntype="string">
 	<cfargument name="msg" required="true">
 	<cfargument name="funcNum" required="true">

	<cfreturn "<scr" & "ipt type='text/javascript'>window.parent.CKEDITOR.tools.callFunction(" & arguments.funcNum & ", '', '" & arguments.msg & "')</scr" & "ipt>">
</cffunction>

<cffunction name="getClientFileName" returntype="string" output="false" hint="get client upload file name">
	<cfargument name="fieldName" required="true" type="string" hint="Name of the Form field" />

	<cfset var bIsRailo = ( lCase(server.coldfusion.productname) IS "railo" )>
	<cfset var atmpParts = arrayNew(1)>
	<cfset var local = structNew()>

	<cfif bIsRailo>
		<cfreturn getPageContext().formScope().getUploadResource(arguments.fieldName).getName()>
	<cfelse>
		<cfset atmpParts = form.getPartsArray()>
		<cfif isDefined("atmpParts")>
			<cfloop array="#atmpParts#" index="local.tmpPart">
				<cfif local.tmpPart.isFile() AND local.tmpPart.getName() EQ arguments.fieldName>
					<cfreturn local.tmpPart.getFileName()>
				</cfif>
			</cfloop>
		</cfif>
	</cfif>

	<cfreturn "">
</cffunction>