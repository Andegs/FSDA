<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ProjectRisk.aspx.cs" Inherits="WebFormsIdentity.MRM.Project_Indicators.ProjectRisk" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

    <asp:Label ID="HeaderLabel" runat="server" CssClass="h4">Project Risk Matrix</asp:Label>
    <hr />
        <div id="expand-box-header" style="margin-bottom: 10px">
          <span style="float: left;">
              <asp:Button ID="Button2" runat="server" Text="Add A New Risk" CssClass="btn btn-group-lg btn-default"
                  OnClientClick="$('#addNewRiskModal').modal('show');return false;" />
          </span> 
          <span style="float: right;">
              <asp:Button ID="Button1" runat="server" Text="View Risk Report" CssClass="btn btn-group-lg btn-default"
                  OnClick="Button1_Click" />
          </span>
          <div style="clear:both;"></div>
        </div>
    <hr />


    <div id="well" runat="server" class="well well-lg" visible="false">

    </div>

    <%--<ef:EntityDataSource ID="EntityDataSource1" runat="server"
        DefaultContainerName="WebFormsIdentityDatabaseEntities"
        ConnectionString="name=WebFormsIdentityDatabaseEntities"
        EnableFlattening="false" EntitySetName="project_risk"
        AutoGenerateWhereClause="true" EnableDelete="true" EnableUpdate="true" 
        EnableInsert="true" Include="project">
        <WhereParameters>
            <asp:Parameter DefaultValue="true" Name="is_general_risk" Type="Boolean" />
        </WhereParameters>
    </ef:EntityDataSource>--%>
    <ef:EntityDataSource ID="EntityDataSource1" runat="server"
        DefaultContainerName="WebFormsIdentityDatabaseEntities"
        ConnectionString="name=WebFormsIdentityDatabaseEntities"
        EnableFlattening="false" EntitySetName="project_risk"
        AutoGenerateWhereClause="false" EnableDelete="true" EnableUpdate="true" 
        EnableInsert="true" Include="project">
    </ef:EntityDataSource>

    <ef:EntityDataSource ID="EntityDataSource2" runat="server"
        DefaultContainerName="WebFormsIdentityDatabaseEntities"
        ConnectionString="name=WebFormsIdentityDatabaseEntities"
        EnableFlattening="false" EntitySetName="projects"
        EnableDelete="true" EnableUpdate="true" EnableInsert="true">
    </ef:EntityDataSource>

    <asp:UpdatePanel ID="UpdatePanel3" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
    <asp:GridView ID="GridView1" runat="server" DataSourceID="EntityDataSource1"
        AutoGenerateColumns="False" CssClass="table table-hover" 
        DataKeyNames="risk_id" OnRowDataBound="GridView1_RowDataBound">
        <AlternatingRowStyle BackColor="White" />
        <HeaderStyle BackColor="#339966" ForeColor="White" />
        <EmptyDataRowStyle backcolor="LightBlue" forecolor="Red"/>
        <EmptyDataTemplate>
            <asp:Label ID="Label2" runat="server" Text="There is no risk to show"></asp:Label>
        </EmptyDataTemplate>
        <Columns>
            <asp:TemplateField Visible="false">
                <ItemTemplate>
                    <asp:Label ID="Label3" runat="server" Text='<%# Eval("risk_id") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="General Risk" SortExpression="risk_id">
                <ItemTemplate>
                    <asp:Label runat="server" Text='<%# Eval("risk") %>' ID="Label1"></asp:Label>
                </ItemTemplate>
                <EditItemTemplate>
                    <asp:TextBox ID="RiskTxBx" runat="server" Width="850px"
                        TextMode="MultiLine" Text='<%# Bind("risk") %>'></asp:TextBox>
                </EditItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Project">
                <ItemTemplate>
                    <asp:Label ID="Label9" runat="server" Text='<%# Eval("project.acronym") %>'></asp:Label>
                </ItemTemplate>
                <%--<EditItemTemplate>
                    <asp:DropDownList ID="InlineProjectList" runat="server" DataSourceID="EntityDataSource2" 
                        DataValueField="project_id" DataTextField="acronym">
                    </asp:DropDownList>
                </EditItemTemplate>--%>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Active?">
                <ItemTemplate>
                    <%--<%# (Boolean.Parse(Eval("active").ToString())) ? "Yes" : "No" %>--%>
                    <asp:CheckBox ID="CheckBox1" runat="server" Checked='<%# Bind("active") %>' Enabled="false" />
                </ItemTemplate>
                <EditItemTemplate>
                    <asp:CheckBox ID="CheckBox1" runat="server" Checked='<%# Bind("active") %>' />
                </EditItemTemplate>
            </asp:TemplateField>
            <asp:CommandField ShowEditButton ="true" />
            <asp:CommandField ShowDeleteButton="true" ButtonType="Link"/>
        </Columns>
    </asp:GridView>
            </ContentTemplate>
    </asp:UpdatePanel>

    <%--Add a new risk modal--%>
    <div id="addNewRiskModal" class="modal fade in" role="dialog">
        <div class="modal-dialog modal-lg">
            <%--<asp:UpdatePanel ID="UpdatePanel2" runat="server">
                <ContentTemplate>--%>
                    <!-- Modal Content -->
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal">
                                &times</button>
                            <h4 class="modal-title">
                                <asp:Label ID="Label5" runat="server" Text="Add a New Risk"></asp:Label></h4>
                        </div>
                        <div class="modal-body">
                            <div role="form">
                                <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Always" ChildrenAsTriggers="true">
                                    <ContentTemplate>
                                        <div style="margin-bottom:10px">
                                            <asp:Label ID="Label4" runat="server" AssociatedControlID="GeneralRiskRadioButtonList" 
                                                Text="Is this a general risk (Applies to all projects?)"></asp:Label>
                                            <div>
                                                <asp:RadioButtonList ID="GeneralRiskRadioButtonList" runat="server" AutoPostBack="true"
                                                    OnSelectedIndexChanged="GeneralRiskRadioButtonList_SelectedIndexChanged">
                                                    <asp:ListItem Value="yes" Text="Yes" />
                                                    <asp:ListItem Value="no" Text="No" />
                                                </asp:RadioButtonList>
                                            </div>
                                        </div>
                                        <div id="genRiskDiv" runat="server" visible="false" style="margin-bottom: 10px">
                                            <asp:Label ID="Label6" runat="server" 
                                                AssociatedControlID="RiskTextBox" Text="Enter The General Risk Below"></asp:Label>
                                            <div>
                                                <asp:TextBox ID="RiskTextBox" runat="server" TextMode="MultiLine" Width="75%"></asp:TextBox>
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                                                    ErrorMessage="Required" ForeColor="Red" SetFocusOnError="true" 
                                                    ControlToValidate="RiskTextBox" ValidationGroup="rsk"></asp:RequiredFieldValidator>
                                            </div>
                                        </div>
                                        <div id="projectRiskDiv" runat="server" visible="false" style="margin-bottom:10px">
                                            <div style="margin-bottom:10px">
                                                <asp:Label ID="Label7" runat="server" AssociatedControlID="ProjectList" 
                                                    Text="Select a Project"></asp:Label>
                                                <div>
                                                    <asp:DropDownList ID="ProjectList" runat="server" AppendDataBoundItems="true" 
                                                        DataSourceID="EntityDataSource2" DataValueField="project_id" DataTextField="acronym">
                                                        <asp:ListItem Value="0" Text="N/A" Selected="True" />
                                                    </asp:DropDownList>
                                                    <asp:RequiredFieldValidator ID="RFV2" runat="server" ErrorMessage="Required" 
                                                        ForeColor="Red" ControlToValidate="ProjectList" InitialValue="0"
                                                        ValidationGroup="rsk" SetFocusOnError="true"></asp:RequiredFieldValidator>
                                                </div>
                                            </div>
                                            <div style="margin-bottom:10px">
                                                <asp:Label ID="Label8" runat="server" Text="Enter the Project Risk Below"
                                                    AssociatedControlID="ProjectRiskTextBox"></asp:Label>
                                                <div>
                                                    <asp:TextBox ID="ProjectRiskTextBox" runat="server" TextMode="MultiLine" Width="75%"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                                                        ErrorMessage="Required" ForeColor="Red" SetFocusOnError="true"
                                                        ControlToValidate="ProjectRiskTextBox" ValidationGroup="rsk"></asp:RequiredFieldValidator>
                                                </div>
                                            </div>
                                        </div>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <asp:Button CssClass="btn btn-default" ID="RiskButton" runat="server" 
                                Text="Save Risk" OnClick="RiskButton_Click" ValidationGroup="rsk" />
                            &nbsp;
                            <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                        </div>
                    </div>
                <%--</ContentTemplate>
            </asp:UpdatePanel>--%>
        </div>
    </div>

    <script>
        $('#addNewRiskModal').on('hidden.bs.modal', function () {
            window.location.reload(true);
        })
    </script>

</asp:Content>
