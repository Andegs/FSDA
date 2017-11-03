<%@ Page Title="" Language="C#" MaintainScrollPositionOnPostback="true" MasterPageFile="~/Site.Master" AutoEventWireup="true" 
    CodeBehind="PartnerReport.aspx.cs" Inherits="WebFormsIdentity.Partner.PartnerReport" %>
<%@ Register TagPrefix="uc" TagName="TestUC" Src="~/Report_Control/ReportControl.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        /*.modal
        {
            position: fixed;
            top: 0;
            left: 0;
            background-color: black;
            z-index: 99;
            opacity: 0.8;
            filter: alpha(opacity=80);
            -moz-opacity: 0.8;
            min-height: 100%;
            width: 100%;
        }*/
        .loading
        {
            font-family: Arial;
            font-size: 10pt;
            border: 5px solid #67CFF5;
            width: 200px;
            height: 100px;
            display: none;
            position: fixed;
            background-color: White;
            z-index: 999;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <asp:Label ID="HeaderLabel" runat="server" CssClass="h4"></asp:Label>
    <asp:HiddenField ID="NumberOfSectionsFilled" runat="server" />
    <hr />

    <%--This is the User control for reporting--%>
    <uc:TestUC ID="myUC" runat="server" />
    <hr />

    <div class="well" style="margin-bottom:20px;">
        <div style="float:left">

        </div>
        <div style="float:right">
            <asp:Button ID="SubmitPartnerReportBtn" runat="server" Text="Submit Report" 
                CssClass="btn btn-warning" OnClick="SubmitPartnerReportBtn_Click" />
        </div>
        <div style="clear:both"></div>
    </div>

    <%--Alert Modal--%>
    <div class="modal fade" id="alertModal" role="dialog">
        <div class="modal-dialog modal-sm">
          <div class="modal-content">
            <div class="modal-header">
              <button type="button" class="close" data-dismiss="modal">&times;</button>
              <h4 class="modal-title">Alert</h4>
            </div>
            <div class="modal-body">
              <p>
                  <asp:Label ID="AlertLabel" runat="server"></asp:Label>
              </p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">OK</button>
                <%--<asp:Button ID="successButton" runat="server" Text="OK" class="btn btn-default"
                    OnClick="successButton_Click" />--%>
            </div>
          </div>
        </div>
      </div>


</asp:Content>
