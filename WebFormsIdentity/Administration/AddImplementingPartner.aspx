<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" 
    CodeBehind="AddImplementingPartner.aspx.cs" 
    Inherits="WebFormsIdentity.Administration.AddImplementingPartner" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

    <asp:LinqDataSource ID="PillarsLinqDataSource" runat="server" 
        ContextTypeName="WebFormsIdentity.Data_Access.WebFormsIdentityDatabaseEntities" 
        EntityTypeName="" Select="new (pillar_id, name)" 
        TableName="pillars"></asp:LinqDataSource>

    <asp:LinqDataSource ID="ProjectStatusDataSource" runat="server" 
        ContextTypeName="WebFormsIdentity.Data_Access.WebFormsIdentityDatabaseEntities" 
        EntityTypeName="" Select="new (status_id, status)" 
        TableName="project_status"></asp:LinqDataSource>

    <ef:EntityDataSource ID="EntityDataSource1" runat="server"
        DefaultContainerName="WebFormsIdentityDatabaseEntities"
        ConnectionString="name=WebFormsIdentityDatabaseEntities"
        EnableFlattening="false" EntitySetName="projects" 
        EnableDelete="true" EnableInsert="true" EnableUpdate="true"
        Include="pillar,project_status"></ef:EntityDataSource>

    <%--<asp:EntityDataSource ID="EntityDataSource1_" runat="server" 
        ConnectionString="name=WebFormsIdentityDatabaseEntities" 
        DefaultContainerName="WebFormsIdentityDatabaseEntities" 
        EnableDelete="True" EnableFlattening="False" EnableInsert="True" 
        EnableUpdate="True" EntitySetName="implementing_partners" 
        Include="pillar"></asp:EntityDataSource>

    <asp:EntityDataSource ID="_EntityDataSource1" runat="server" 
        DefaultContainerName="WebFormsIdentityDatabaseEntities"
        ConnectionString="name=WebFormsIdentityDatabaseEntities"
        EnableFlattening="false" EntitySetName="implementing_partners" 
        Include="pillars"></asp:EntityDataSource>--%>

    <asp:LinqDataSource ID="LinqDataSource1" runat="server" 
        ContextTypeName="WebFormsIdentity.Data_Access.WebFormsIdentityDatabaseEntities" 
        EntityTypeName="" GroupBy="pillar" 
        Select="new (key as pillar, it as projects)" 
        TableName="projects"></asp:LinqDataSource>

    <asp:SqlDataSource ID="PartnersSqlDataSource" runat="server"
        ConflictDetection="CompareAllValues"
        ConnectionString='<%$ ConnectionStrings:DefaultConnection %>'
        DeleteCommand="DELETE FROM [projects] WHERE [project_id] = @original_project_id AND [pillar_id] = @original_pillar_id AND (([project_name] = @original_project_name) OR ([project_name] IS NULL AND @original_project_name IS NULL)) AND (([implementing_partner] = @original_implementing_partner) OR ([implementing_partner] IS NULL AND @original_implementing_partner IS NULL)) AND (([acronym] = @original_acronym) OR ([acronym] IS NULL AND @original_acronym IS NULL)) AND (([description] = @original_description) OR ([description] IS NULL AND @original_description IS NULL)) AND [status_id] = @original_status_id"
        InsertCommand="INSERT INTO [projects] ([pillar_id], [project_name], [implementing_partner], [acronym], [description], [status_id]) VALUES (@pillar_id, @project_name, @implementing_partner, @acronym, @description, @status_id)"
        OldValuesParameterFormatString="original_{0}"
        SelectCommand="SELECT * FROM [projects]"
        UpdateCommand="UPDATE [projects] SET [pillar_id] = @pillar_id, [project_name] = @project_name, [implementing_partner] = @implementing_partner, [acronym] = @acronym, [description] = @description, [status_id] = @status_id WHERE [project_id] = @original_project_id AND [pillar_id] = @original_pillar_id AND (([project_name] = @original_project_name) OR ([project_name] IS NULL AND @original_project_name IS NULL)) AND (([implementing_partner] = @original_implementing_partner) OR ([implementing_partner] IS NULL AND @original_implementing_partner IS NULL)) AND (([acronym] = @original_acronym) OR ([acronym] IS NULL AND @original_acronym IS NULL)) AND (([description] = @original_description) OR ([description] IS NULL AND @original_description IS NULL)) AND [status_id] = @original_status_id">
        <DeleteParameters>
            <asp:Parameter Name="original_project_id" Type="Int32"></asp:Parameter>
            <asp:Parameter Name="original_pillar_id" Type="Int32"></asp:Parameter>
            <asp:Parameter Name="original_project_name" Type="String"></asp:Parameter>
            <asp:Parameter Name="original_implementing_partner" Type="String"></asp:Parameter>
            <asp:Parameter Name="original_acronym" Type="String"></asp:Parameter>
            <asp:Parameter Name="original_description" Type="String"></asp:Parameter>
            <asp:Parameter Name="original_status_id" Type="Int32"></asp:Parameter>
        </DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="pillar_id" Type="Int32"></asp:Parameter>
            <asp:Parameter Name="project_name" Type="String"></asp:Parameter>
            <asp:Parameter Name="implementing_partner" Type="String"></asp:Parameter>
            <asp:Parameter Name="acronym" Type="String"></asp:Parameter>
            <asp:Parameter Name="description" Type="String"></asp:Parameter>
            <asp:Parameter Name="status_id" Type="Int32"></asp:Parameter>
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="pillar_id" Type="Int32"></asp:Parameter>
            <asp:Parameter Name="project_name" Type="String"></asp:Parameter>
            <asp:Parameter Name="implementing_partner" Type="String"></asp:Parameter>
            <asp:Parameter Name="acronym" Type="String"></asp:Parameter>
            <asp:Parameter Name="description" Type="String"></asp:Parameter>
            <asp:Parameter Name="status_id" Type="Int32"></asp:Parameter>
            <asp:Parameter Name="original_project_id" Type="Int32"></asp:Parameter>
            <asp:Parameter Name="original_pillar_id" Type="Int32"></asp:Parameter>
            <asp:Parameter Name="original_project_name" Type="String"></asp:Parameter>
            <asp:Parameter Name="original_implementing_partner" Type="String"></asp:Parameter>
            <asp:Parameter Name="original_acronym" Type="String"></asp:Parameter>
            <asp:Parameter Name="original_description" Type="String"></asp:Parameter>
            <asp:Parameter Name="original_status_id" Type="Int32"></asp:Parameter>
        </UpdateParameters>
    </asp:SqlDataSource>

    <asp:LinqDataSource ID="PartnersLinqDataSource" runat="server" 
        ContextTypeName="WebFormsIdentity.Data_Access.WebFormsIdentityDatabaseEntities" 
        EntityTypeName="" TableName="projects"></asp:LinqDataSource>

    <h4 style="font-size: medium">FSDA Projects</h4>
    <hr />

    <div id="expand-box-header" style="margin-bottom: 10px">
      <span style="float: left;">
          <asp:Button ID="Button2" runat="server" Text="New Pillar"
              OnClientClick="$('#addNewPillarModal').modal('show');return false;" />
      </span> 
      <span style="float: right;">
          <asp:Button ID="Button1" runat="server" Text="New Project" 
              OnClientClick="$('#addNewPartnerModal').modal('show');return false;" />
      </span>
      <div style="clear:both;"></div>
    </div>

    <asp:PlaceHolder runat="server" ID="ImplementingPartnersPlaceHolder" Visible="true">
        <div style="margin-bottom: 10px">
            <asp:GridView ID="PartnersGridView" runat="server" DataSourceID="EntityDataSource1"
                AutoGenerateColumns="False" CssClass="table table-hover" DataKeyNames="project_id">
                <AlternatingRowStyle BackColor="White" />
                <HeaderStyle BackColor="#339966" ForeColor="White" />
                <Columns>
                    <asp:BoundField DataField="project_id" HeaderText="project_id" 
                        ReadOnly="True" InsertVisible="False" SortExpression="project_id" 
                        Visible="false"></asp:BoundField>
                    <asp:TemplateField HeaderText="Pillar" SortExpression="pillar_id">
                        <EditItemTemplate>
                            <asp:DropDownList ID="DropDownList1" runat="server"
                                DataSourceID="PillarsLinqDataSource" SelectedValue='<%# Bind("pillar_id") %>'
                                DataTextField="name" DataValueField="pillar_id">
                            </asp:DropDownList>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label runat="server" Text='<%# Eval("pillar.name") %>' ID="Label1"></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Project Name" SortExpression="name">
                        <EditItemTemplate>
                            <asp:TextBox runat="server" Text='<%# Bind("project_name") %>' ID="TextBox2"></asp:TextBox>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label runat="server" Text='<%# Bind("project_name") %>' ID="Label2"></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Implementing Partner" SortExpression="implementing_partner">
                        <EditItemTemplate>
                            <asp:TextBox runat="server" Text='<%# Bind("implementing_partner") %>' ID="TextBox5"></asp:TextBox>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="Label8" runat="server" Text='<%# Bind("implementing_partner") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Acronym" SortExpression="acronym">
                        <EditItemTemplate>
                            <asp:TextBox runat="server" Text='<%# Bind("acronym") %>' ID="TextBox3"></asp:TextBox>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label runat="server" Text='<%# Bind("acronym") %>' ID="Label3"></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Project Description" SortExpression="description">
                        <EditItemTemplate>
                            <asp:TextBox runat="server" Text='<%# Bind("project_objectives") %>' ID="TextBox4"></asp:TextBox>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label runat="server" Text='<%# Bind("project_objectives") %>' ID="Label4"></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Project Status" SortExpression="status_id">
                        <EditItemTemplate>
                            <asp:DropDownList ID="DropDownList2" runat="server"
                                DataSourceID="ProjectStatusDataSource" SelectedValue='<%# Bind("status_id") %>'
                                DataTextField="status" DataValueField="status_id">
                            </asp:DropDownList>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="Label7" runat="server" Text='<%# Eval("project_status.status") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField ShowHeader="False">
                        <EditItemTemplate>
                            <asp:LinkButton runat="server" Text="Update" CommandName="Update" 
                                CausesValidation="True" ID="LinkButton1"></asp:LinkButton>
                            &nbsp;
                            <asp:LinkButton runat="server" Text="Cancel" CommandName="Cancel" 
                                CausesValidation="False" ID="LinkButton2"></asp:LinkButton>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:LinkButton runat="server" Text="Edit" CommandName="Edit" 
                                CausesValidation="False" ID="LinkButton1"></asp:LinkButton>
                            &nbsp;
                            <asp:LinkButton runat="server" Text="Delete" CommandName="Delete" 
                                CausesValidation="False" ID="LinkButton2"></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>


                </Columns>
            </asp:GridView>
        </div>
    </asp:PlaceHolder>

    <%--Start Register an implementing partner--%>
    <%--<asp:PlaceHolder runat="server" ID="IPRegistrationForm" Visible="true">
        <div style="margin-bottom: 10px">
            <asp:Label runat="server" AssociatedControlID="PillarDropDownList">Pillar</asp:Label>
            <div>
                <asp:DropDownList ID="PillarDropDownList" runat="server"
                    DataSourceID="PillarsLinqDataSource" 
                    DataTextField="name" DataValueField="pillar_id">
                </asp:DropDownList>
            </div>
        </div>
        <div style="margin-bottom: 10px">
            <asp:Label runat="server" AssociatedControlID="ParterName">Name of the Partner</asp:Label>
            <div>
                <asp:TextBox ID="ParterName" runat="server"></asp:TextBox>
            </div>
        </div>
        <div style="margin-bottom: 10px">
            <asp:Label runat="server" AssociatedControlID="Acronym">Acronym</asp:Label>
            <div>
                <asp:TextBox ID="Acronym" runat="server"></asp:TextBox>
            </div>
        </div>
        <div style="margin-bottom: 10px">
            <asp:Label runat="server" AssociatedControlID="Description">Description</asp:Label>
            <div>
                <asp:TextBox ID="Description" runat="server" TextMode="MultiLine"></asp:TextBox>
            </div>
        </div>
    </asp:PlaceHolder>--%>
    <%--<asp:PlaceHolder runat="server" ID="IPRegistrationButton" Visible="True">
        <div style="margin-bottom: 10px">
            <div>
                <asp:Button CssClass="btn btn-default" runat="server" 
                    OnClick="RegImplementingPartner_Click" Text="Add Implementing Partner" />
            </div>
        </div>
    </asp:PlaceHolder>--%>
    <%--End Register an Implementing Partner--%>

    <%--Add a new pillar modal--%>
    <div id="addNewPillarModal" class="modal fade in" role="dialog">
        <div class="modal-dialog">
            <asp:UpdatePanel ID="UpdatePanel2" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <!-- Modal Content -->
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal">
                                &times</button>
                            <h4 class="modal-title">
                                <asp:Label ID="Label5" runat="server" Text="Add a New Pillar"></asp:Label></h4>
                        </div>
                        <div class="modal-body">
                            <div role="form">
                                <div style="margin-bottom: 10px">
                                    <asp:Label ID="Label6" runat="server" 
                                        AssociatedControlID="PillarTextBox" Text="Pillar Name"></asp:Label>
                                    <div>
                                        <asp:TextBox ID="PillarTextBox" runat="server"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <asp:Button CssClass="btn btn-default" runat="server" 
                                OnClick="RegPillar_Click" Text="Add FSDA Pillar" />
                            &nbsp;
                            <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>

    <%--Add a new project modal--%>
    <div id="addNewPartnerModal" class="modal fade in" role="dialog">
        <div class="modal-dialog modal-lg">
            <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <!-- Modal Content -->
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal">
                                &times</button>
                            <h4 class="modal-title">
                                <asp:Label ID="ModalHeaderLabel" runat="server" Text="Add a New Project"></asp:Label></h4>
                        </div>
                        <div class="modal-body">
                            <div role="form">
                                <div style="margin-bottom: 10px">
                                    <asp:Label runat="server" AssociatedControlID="PillarDropDownList">Pillar</asp:Label>
                                    <div>
                                        <asp:DropDownList ID="PillarDropDownList" runat="server"
                                            DataSourceID="PillarsLinqDataSource" 
                                            DataTextField="name" DataValueField="pillar_id">
                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <div style="margin-bottom=10px">
                                    <asp:Label runat="server" AssociatedControlID="IPName">Name of the Organisation (Implementing Partner)</asp:Label>
                                    <div>
                                        <asp:TextBox ID="IPName" runat="server" Columns="80"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="RFV1" runat="server" ErrorMessage="Required" ForeColor="Red"
                                            ControlToValidate="IPName" ValidationGroup="reg"></asp:RequiredFieldValidator>
                                    </div>
                                </div>
                                <div style="margin-bottom: 10px">
                                    <asp:Label runat="server" AssociatedControlID="PartnerName">Name of the Project</asp:Label>
                                    <div>
                                        <asp:TextBox ID="PartnerName" runat="server" Columns="80"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="RFV2" runat="server" ErrorMessage="Required" ForeColor="Red"
                                            ControlToValidate="PartnerName" ValidationGroup="reg"></asp:RequiredFieldValidator>
                                    </div>
                                </div>
                                <div style="margin-bottom: 10px">
                                    <asp:Label runat="server" AssociatedControlID="Acronym">Acronym</asp:Label>
                                    <div>
                                        <asp:TextBox ID="Acronym" runat="server" Columns="80"></asp:TextBox>
                                    </div>
                                </div>
                                <div style="margin-bottom:10px">
                                    <asp:Label runat="server" AssociatedControlID="PartnershipRefNo">Partnership Reference Number</asp:Label>
                                    <div>
                                        <asp:TextBox ID="PartnershipRefNo" runat="server" Columns="80"></asp:TextBox>
                                    </div>
                                </div>
                                <div style="margin-bottom:10px">
                                    <asp:Label runat="server" AssociatedControlID="Budget">Project Budget</asp:Label>
                                    <div>
                                        <asp:TextBox ID="Budget" runat="server" Columns="80"></asp:TextBox>
                                        <asp:RegularExpressionValidator ID="REV1" runat="server" ControlToValidate="Budget"
                                            ValidationExpression="[\d]{1,9}([.][\d]{1,2})?" ValidationGroup="reg"
                                            ErrorMessage="Wrong Expression" ForeColor="Red"></asp:RegularExpressionValidator>
                                    </div>
                                </div>
                                <div style="margin-bottom: 10px">
                                    <asp:Label runat="server" AssociatedControlID="Objectives">Project Objectives</asp:Label>
                                    <div>
                                        <asp:TextBox ID="Objectives" runat="server" TextMode="MultiLine" Rows="10" CssClass="ckeditor"></asp:TextBox>
                                    </div>
                                </div>
                                <div style="margin-bottom:10px">
                                    <asp:Label runat="server" AssociatedControlID="Outcomes">Expected Outcomes</asp:Label>
                                    <div>
                                        <asp:TextBox ID="Outcomes" runat="server" TextMode="MultiLine" CssClass="ckeditor"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <asp:Button CssClass="btn btn-default" runat="server" 
                                OnClick="RegImplementingPartner_Click" Text="Add Implementing Partner" ValidationGroup="reg" />
                            &nbsp;
                            <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>

    <%--Success Modal--%>
    <div class="modal fade" id="successModal" role="dialog">
    <div class="modal-dialog modal-sm">
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal">&times;</button>
          <h4 class="modal-title">Success</h4>
        </div>
        <div class="modal-body">
          <p>Data saved successfully.</p>
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
