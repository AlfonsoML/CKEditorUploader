<%@ Page Language="VB" Strict="true"%>
<script runat="server">
    Sub Page_Load(ByVal o As Object, ByVal e As EventArgs)
        Response.Write(processUpload())
    End Sub

    ' Upload script for CKEditor.
    ' Use at your own risk, no warranty provided. Be careful about who is able to access this file
    ' The upload folder shouldn't be able to upload any kind of script, just in case.
    ' If you're not sure, hire a professional that takes care of adjusting the server configuration as well as this script for you.
    ' (I am not such professional)

    Private Function processUpload() As String
        ' Step 1: change the true for whatever condition you use in your environment to verify that the user
        ' is logged in and is allowed to use the script
        if (true)
			return sendError("You're not allowed to upload files")
		end if

        ' Step 2: Put here the full absolute path of the folder where you want to save the files:
        ' You must set the proper permissions on that folder
        Dim basePath As String = "D:\\CKFinder\\ckfinder\\userfiles\\"

        ' Step 3: Put here the Url that should be used for the upload folder (it the URL to access the folder that you have set in $basePath
        ' you can use a relative url "/images/", or a path including the host "http://example.com/images/"
        ' ALWAYS put the final slash (/)
        Dim baseUrl As String = "/ckfinder/userfiles/"

        ' Done. Now test it!

        ' No need to modify anything below this line
        '----------------------------------------------------

        ' ------------------------
        ' Input parameters: optional means that you can ignore it, and required means that you
        ' must use it to provide the data back to CKEditor.
        ' ------------------------

        ' Optional: instance name (might be used to adjust the server folders for example)
        Dim CKEditor As String = HttpContext.Current.Request("CKEditor")

        ' Required: Function number as indicated by CKEditor.
        Dim funcNum As String = HttpContext.Current.Request("CKEditorFuncNum")

        ' Optional: To provide localized messages
        Dim langCode As String = HttpContext.Current.Request("langCode")

        ' ------------------------
        ' Data processing
        ' ------------------------

        Dim total As Integer
        Try
            total = HttpContext.Current.Request.Files.Count
        Catch ex As Exception
            Return sendError("Error uploading the file")
        End Try

        If (total = 0) Then
            Return sendError("No file has been sent")
        End If

        If (Not System.IO.Directory.Exists(basePath)) Then
            Return sendError("basePath folder doesn't exists")
        End If

        'Grab the file name from its fully qualified path at client
        Dim theFile As HttpPostedFile = HttpContext.Current.Request.Files(0)

        Dim strFileName As String = theFile.FileName
        If (strFileName = "") Then
            Return sendError("File name is empty")
        End If

        Dim sFileName As String = System.IO.Path.GetFileName(strFileName)

        Dim name As String = System.IO.Path.Combine(basePath, sFileName)
        theFile.SaveAs(name)

        Dim url As String = baseUrl + sFileName.Replace("'", "\'")

        ' ------------------------
        ' Write output
        ' ------------------------
        Return "<scr" + "ipt type='text/javascript'> window.parent.CKEDITOR.tools.callFunction(" + funcNum + ", '" + url + "', '')</scr" + "ipt>"
    End Function


    Private Function sendError(ByVal msg As String) As String
        Dim funcNum As String = HttpContext.Current.Request("CKEditorFuncNum")
        Return "<scr" + "ipt type='text/javascript'> window.parent.CKEDITOR.tools.callFunction(" + funcNum + ", '', '" + msg + "')</scr" + "ipt>"
    End Function
</script>