﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="SubmittedPartnerReports.aspx.cs" Inherits="WebFormsIdentity.Pillar.SubmittedPartnerReports" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <ef:EntityDataSource ID="EntityDataSource1" runat="server"
        DefaultContainerName="WebFormsIdentityDatabaseEntities"
        ConnectionString="name=WebFormsIdentityDatabaseEntities"
        EnableFlattening="false" EntitySetName="partner_reports"
        Include="project,report_periods,year"
        AutoGenerateWhereClause="true" EnableDelete="true">
        <WhereParameters>
            <asp:Parameter DefaultValue="true" Name="submitted" Type="Boolean" />
        </WhereParameters>
    </ef:EntityDataSource>

    <asp:Label ID="HeaderLabel" runat="server" CssClass="h4">Submitted Quarterly Reports</asp:Label>
    <hr />

    <% if (User.IsInRole("Partner")) { %>
    <asp:GridView ID="GridView2" runat="server" DataSourceID="EntityDataSource1"
            AutoGenerateColumns="False" CssClass="table table-hover" 
            DataKeyNames="partner_report_id">
            <AlternatingRowStyle BackColor="White" />
            <HeaderStyle BackColor="#339966" ForeColor="White" />
            <Columns>
                <asp:BoundField DataField="partner_report_id" HeaderText="Project ID" 
                    Visible="false" SortExpression="partner_report_id"></asp:BoundField>
                <asp:TemplateField HeaderText="Year" SortExpression="year_id">
                    <ItemTemplate>
                        <asp:Label runat="server" Text='<%# Eval("year.year1") %>' ID="Label1"></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Report Period" SortExpression="report_period_id">
                    <ItemTemplate>
                        <asp:Label runat="server" Text='<%# Eval("report_periods.period") %>' ID="Label2"></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Project" SortExpression="project_id">
                    <ItemTemplate>
                        <asp:Label runat="server" Text='<%# Eval("project.project_name") %>' ID="Label3"></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    <% } else { %>
    <asp:GridView ID="GridView1" runat="server" DataSourceID="EntityDataSource1"
            AutoGenerateColumns="False" CssClass="table table-hover" 
            DataKeyNames="partner_report_id" OnRowCommand="GridView1_RowCommand">
            <AlternatingRowStyle BackColor="White" />
            <HeaderStyle BackColor="#339966" ForeColor="White" />
            <Columns>
                <asp:BoundField DataField="partner_report_id" HeaderText="Project ID" 
                    Visible="false" SortExpression="partner_report_id"></asp:BoundField>
                <asp:TemplateField HeaderText="Year" SortExpression="year_id">
                    <ItemTemplate>
                        <asp:Label runat="server" Text='<%# Eval("year.year1") %>' ID="Label1"></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Report Period" SortExpression="report_period_id">
                    <ItemTemplate>
                        <asp:Label runat="server" Text='<%# Eval("report_periods.period") %>' ID="Label2"></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Project" SortExpression="project_id">
                    <ItemTemplate>
                        <asp:Label runat="server" Text='<%# Eval("project.project_name") %>' ID="Label3"></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:ButtonField ButtonType="Link" Text="Access" CommandName="Edit" HeaderText="DATA" />
                <asp:ButtonField ButtonType="Link" Text="Download" CommandName="pdf" HeaderText="PDF" />
            </Columns>
        </asp:GridView>
    <% } %>
</asp:Content>
