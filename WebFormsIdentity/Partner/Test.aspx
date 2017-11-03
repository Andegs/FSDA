<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Test.aspx.cs" Inherits="WebFormsIdentity.Partner.Test" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<%@ Register TagPrefix="uc" TagName="TestUC" Src="~/Report_Control/ReportControl.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <%--This is the User control for reporting--%>
    <%--<uc:TestUC ID="myUC" runat="server" />--%>

    <asp:TreeView ID="TreeView1" runat="server" NodeIndent="15" Visible="false">
        <HoverNodeStyle Font-Underline="true" ForeColor="Black" />
        <NodeStyle Font-Names="Tahoma" Font-Size="8pt" ForeColor="Black" HorizontalPadding="2px"
            NodeSpacing="0px" VerticalPadding="2px" />
        <ParentNodeStyle Font-Bold="false" />
        <SelectedNodeStyle BackColor="#B5B5B5" Font-Underline="false" HorizontalPadding="0px"
            VerticalPadding="0px" />
    </asp:TreeView>

    <hr />
    <asp:Label ID="Label1" runat="server" Text="Label"></asp:Label>
    <hr />

    
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

    <ajaxToolkit:AsyncFileUpload ID="FSUpload" runat="server" OnClientUploadError="uploadError"
        OnClientUploadComplete="uploadComplete" Width="400px" UploaderStyle="Modern" CompleteBackColor="White"
        UploadingBackColor="Orange" ThrobberID="imgLoader" OnUploadedComplete="FSUpload_UploadedComplete" />
                     
    <asp:Image ID="imgLoader" runat="server" ImageUrl="~/images/loader_sm.gif"/>
    <br />
    <asp:Label ID="Labelmsg" runat="server" Text=""></asp:Label>

</asp:Content>
