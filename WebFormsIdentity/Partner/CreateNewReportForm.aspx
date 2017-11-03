<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CreateNewReportForm.aspx.cs" Inherits="WebFormsIdentity.Partner.CreateNewReportForm" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <asp:LinqDataSource ID="LinqDataSource1" runat="server"
        ContextTypeName="WebFormsIdentity.Data_Access.WebFormsIdentityDatabaseEntities"
        EntityTypeName="" Select="new (project_id, project_name)"
        TableName="projects" Where="status_id == @status_id">
        <WhereParameters>
            <asp:Parameter DefaultValue="1" Name="status_id" Type="Int32"></asp:Parameter>
        </WhereParameters>
    </asp:LinqDataSource>

    <asp:LinqDataSource ID="LinqDataSource2" runat="server" 
        ContextTypeName="WebFormsIdentity.Data_Access.WebFormsIdentityDatabaseEntities" 
        EntityTypeName="" Select="new (report_period_id, period, period_name)" 
        TableName="report_periods"></asp:LinqDataSource>

    <asp:LinqDataSource ID="LinqDataSource3" runat="server" 
        ContextTypeName="WebFormsIdentity.Data_Access.WebFormsIdentityDatabaseEntities" 
        EntityTypeName="" Select="new (year_id, year1)" TableName="years"></asp:LinqDataSource>

    <h4 style="font-size: medium">Create a New Report</h4>
    <hr />

    <div id="alertDiv" runat="server" visible="false" class="alert alert-success">
      <strong>Success!</strong> You can access the report at the <a href="CreatedPartnerReports.aspx" class="alert-link">Partner Reports</a> section.
    </div>

    <asp:PlaceHolder runat="server" ID="CreateReportForm" Visible="true">
        <div style="margin-bottom: 10px">
            <asp:Label runat="server" AssociatedControlID="Partner">Project</asp:Label>
            <div>
                <asp:DropDownList ID="Partner" runat="server" DataSourceID="LinqDataSource1"
                    DataTextField="project_name" DataValueField="project_id" 
                    AppendDataBoundItems="true">
                    <asp:ListItem Selected="True" 
                        Text="<Select Your Project>" Value="0" />
                </asp:DropDownList>
            </div>
        </div>
        <div style="margin-bottom: 10px">
            <asp:Label runat="server" AssociatedControlID="ReportPeriod">Report Period</asp:Label>
            <div>
                <asp:DropDownList ID="ReportPeriod" runat="server" DataSourceID="LinqDataSource2"
                    DataTextField="period"  
                    DataValueField="report_period_id" AppendDataBoundItems="true">
                    <asp:ListItem Selected="True"
                        Text="<Select Reporting Period>" Value="0" />
                </asp:DropDownList>
            </div>
        </div>
        <div style="margin-bottom: 10px">
            <asp:Label runat="server" AssociatedControlID="Year">Year</asp:Label>
            <div>
                <asp:DropDownList ID="Year" runat="server" DataSourceID="LinqDataSource3"
                    DataTextField="year1" DataValueField="year_id" AppendDataBoundItems="true">
                    <asp:ListItem Selected="True"
                        Text="<Select Year>" Value="0" />
                </asp:DropDownList>
            </div>
        </div>
    </asp:PlaceHolder>
    <asp:PlaceHolder runat="server" ID="CreateReportButton" Visible="true">
        <div style="margin-bottom: 10px">
            <div>
                <asp:Button runat="server" OnClick="CreateReportButton_Click" 
                    Text="Create Report" CssClass="btn btn-default" />
            </div>
        </div>
    </asp:PlaceHolder>

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
              <asp:Label ID="AlertLabel" runat="server"></asp:Label></p>
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
