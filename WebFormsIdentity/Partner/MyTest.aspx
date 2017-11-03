<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MyTest.aspx.cs" Inherits="WebFormsIdentity.Partner.MyTest" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        
    <script type = "text/javascript">
        function uploadComplete(sender) {
            $get("<%=lblMesg.ClientID%>").style.color = "green";
            $get("<%=lblMesg.ClientID%>").innerHTML = "File Uploaded Successfully";
        }

        function uploadError(sender) {
            $get("<%=lblMesg.ClientID%>").style.color = "red";
            $get("<%=lblMesg.ClientID%>").innerHTML = "File upload failed.";
        }
    </script>

        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
        <ajaxToolkit:AsyncFileUpload OnClientUploadError="uploadError" 
            OnClientUploadComplete="uploadComplete" runat="server"
            ID="AsyncFileUpload1" Width="400px" UploaderStyle="Modern"
            CompleteBackColor = "White"
            UploadingBackColor="#CCFFFF"  ThrobberID="imgLoader" 
            OnUploadedComplete = "FileUploadComplete"
          />
        <asp:Image ID="imgLoader" runat="server" ImageUrl = "~/images/loader_sm.gif" /> 
        <br />
       <asp:Label ID="lblMesg" runat="server" Text=""></asp:Label>

    </div>
    </form>
</body>
</html>
