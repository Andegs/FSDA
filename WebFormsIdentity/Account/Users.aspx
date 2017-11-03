<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" 
    AutoEventWireup="true" CodeBehind="Users.aspx.cs" 
    Inherits="WebFormsIdentity.Account.Users" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

    <asp:SqlDataSource ID="SqlDataSource1" runat="server"
        ConnectionString='<%$ ConnectionStrings:SQLDatabaseConnectionString %>'
        SelectCommand="SELECT [Id], [Email], [UserName] FROM [AspNetUsers]" ConflictDetection="CompareAllValues" DeleteCommand="DELETE FROM [AspNetUsers] WHERE [Id] = @original_Id AND (([Email] = @original_Email) OR ([Email] IS NULL AND @original_Email IS NULL)) AND [UserName] = @original_UserName" InsertCommand="INSERT INTO [AspNetUsers] ([Id], [Email], [UserName]) VALUES (@Id, @Email, @UserName)" OldValuesParameterFormatString="original_{0}" UpdateCommand="UPDATE [AspNetUsers] SET [Email] = @Email, [UserName] = @UserName WHERE [Id] = @original_Id AND (([Email] = @original_Email) OR ([Email] IS NULL AND @original_Email IS NULL)) AND [UserName] = @original_UserName">
        <DeleteParameters>
            <asp:Parameter Name="original_Id" Type="String"></asp:Parameter>
            <asp:Parameter Name="original_Email" Type="String"></asp:Parameter>
            <asp:Parameter Name="original_UserName" Type="String"></asp:Parameter>
        </DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="Id" Type="String"></asp:Parameter>
            <asp:Parameter Name="Email" Type="String"></asp:Parameter>
            <asp:Parameter Name="UserName" Type="String"></asp:Parameter>
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="Email" Type="String"></asp:Parameter>
            <asp:Parameter Name="UserName" Type="String"></asp:Parameter>
            <asp:Parameter Name="original_Id" Type="String"></asp:Parameter>
            <asp:Parameter Name="original_Email" Type="String"></asp:Parameter>
            <asp:Parameter Name="original_UserName" Type="String"></asp:Parameter>
        </UpdateParameters>
    </asp:SqlDataSource>
    
    <p>
        <asp:Label ID="Label1" runat="server" Text="Label" ForeColor="Red" Visible="false"></asp:Label>

        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False"
            DataKeyNames="Id" DataSourceID="SqlDataSource1" CellPadding="3" 
            CssClass="table table-hover">
            <AlternatingRowStyle BackColor="White" />
            <HeaderStyle BackColor="#339966" ForeColor="White" />
        <Columns>
            <asp:BoundField DataField="Id" HeaderText="Id" ReadOnly="True" SortExpression="Id" Visible="false"></asp:BoundField>
            <asp:BoundField DataField="UserName" HeaderText="UserName" SortExpression="UserName"></asp:BoundField>
            <asp:BoundField DataField="Email" HeaderText="Email" SortExpression="Email"></asp:BoundField>
            <asp:TemplateField ShowHeader="False">
                    <EditItemTemplate>
                        <asp:LinkButton runat="server" Text="Update" CommandName="Update" CausesValidation="True" ID="LinkButton1"></asp:LinkButton>
                        &nbsp;
                        <asp:LinkButton runat="server" Text="Cancel" CommandName="Cancel" CausesValidation="False" ID="LinkButton2"></asp:LinkButton>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:LinkButton ID="LinkButton4" runat="server"  
                            CommandArgument='<%# Eval("Id") %>' 
                            OnClick="EditRoles_Click">
                            Edit Roles
                        </asp:LinkButton>
                        &nbsp;
                        <asp:LinkButton ID="LinkButton3" runat="server"  
                            CommandArgument='<%# Eval("Id") %>' 
                            OnClick="EditClaims_Click">
                            Edit Claims
                        </asp:LinkButton>
                        &nbsp;
                        <asp:LinkButton runat="server" Text="Edit" CommandName="Edit" CausesValidation="False" ID="LinkButton1"></asp:LinkButton>
                        &nbsp;
                        <asp:LinkButton runat="server" Text="Delete" CommandName="Delete" CausesValidation="False" ID="LinkButton2"></asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
        </Columns>
    </asp:GridView>
    </p>


    <!-- Update User Claims Modal -->
    <div id="updateClaimsModal" class="modal fade in" role="dialog">
        <div class="modal-dialog">
            <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <!-- Modal Content -->
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal">
                                &times</button>
                            <h4 class="modal-title">
                                <asp:Label ID="ModalHeaderLabel1" runat="server" Text="hjdsjga"></asp:Label></h4>
                        </div>
                        <div class="modal-body">
                            <div role="form">
                                <div style="margin-bottom:10px" id="Proj" runat="server" visible="false">
                                    <asp:Label ID="Label3" runat="server" Text="Projects" 
                                        AssociatedControlID="Implementing_Partner_List"></asp:Label>
                                    <div>
                                        <ef:EntityDataSource ID="EntityDataSource2" runat="server"
                                            DefaultContainerName="WebFormsIdentityDatabaseEntities"
                                            ConnectionString="name=WebFormsIdentityDatabaseEntities"
                                            EnableFlattening="false" EntitySetName="projects">
                                        </ef:EntityDataSource>
                                        <asp:RadioButtonList ID="Implementing_Partner_List" runat="server"
                                            DataSourceID="EntityDataSource2" DataTextField="project_name"
                                            DataValueField="project_id"></asp:RadioButtonList>
                                        <asp:CustomValidator ID="CustomValidator2" runat="server" 
                                        ErrorMessage="Select Atleast one Project" ForeColor="Red" SetFocusOnError="true"
                                        ValidationGroup="clm" ClientValidationFunction="ValidateProjectList"></asp:CustomValidator>
                                    </div>
                                </div>
                                <div style="margin-bottom:10px" id="Pill" runat="server" visible="false">
                                    <asp:Label ID="Label2" runat="server" Text="Pillars" 
                                        AssociatedControlID="Pillar_List"></asp:Label>
                                    <div>
                                        <ef:EntityDataSource ID="EntityDataSource3" runat="server"
                                            DefaultContainerName="WebFormsIdentityDatabaseEntities"
                                            ConnectionString="name=WebFormsIdentityDatabaseEntities"
                                            EnableFlattening="false" EntitySetName="pillars">
                                        </ef:EntityDataSource>
                                        <asp:CheckBoxList ID="Pillar_List" runat="server"
                                            DataSourceID="EntityDataSource3" DataValueField="pillar_id"
                                            DataTextField="name"></asp:CheckBoxList>
                                        <asp:CustomValidator ID="CustomValidator3" runat="server" 
                                        ErrorMessage="Select Atleast one Pillar" ForeColor="Red" SetFocusOnError="true"
                                        ValidationGroup="clm" ClientValidationFunction="ValidatePillarList"></asp:CustomValidator>
                                    </div>
                                </div>
                                <%--<div class="form-group">
                                    <asp:Label ID="Label2" runat="server" Text="UserName"></asp:Label>
                                    <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label3" runat="server" Text="Password"></asp:Label>
                                    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control"></asp:TextBox>
                                </div>
                                <hr class="divider">
                                <div class="form-group">
                                    <div class="row">
                                        <div class="col-sm-6">
                                            <asp:CheckBox ID="chkRemberme" runat="server" Text="Remember Me" CssClass="checkbox-inline" />
                                            |
                                            <asp:LinkButton ID="LinkButton1" runat="server" CssClass="text-primary">Forgot Password ?</asp:LinkButton>
                                        </div>
                                        <div class="col-sm-6">
                                            <span class="pull-right">
                                                <asp:Button ID="btnSumbit" CssClass="btn btn-success" runat="server" Text="Submit" /></span>
                                        </div>
                                    </div>
                                </div>--%>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <asp:Button ID="UpdateClaims" CssClass="btn btn-default" runat="server" OnClick="UpdateClaims_Click" Text="Update Claims"
                                ValidationGroup="clm" />
                            &nbsp;
                            <asp:Button ID="CancelClaims" CssClass="btn btn-default" runat="server" Text="Cancel" OnClientClick="$('#updateClaimsModal').modal('hide');" />
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>

    <!-- Update User Roles Modal -->
    <div id="updateRolesModal" class="modal fade in" role="dialog">
        <div class="modal-dialog">
            <asp:UpdatePanel ID="UpdatePanel2" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <!-- Modal Content -->
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal">
                                &times</button>
                            <h4 class="modal-title">
                                <asp:Label ID="ModalHeaderLabel2" runat="server" Text="hjdsjga"></asp:Label></h4>
                        </div>
                        <div class="modal-body">
                            <div role="form">
                                <div style="margin-bottom:10px">
                                    <asp:Label ID="Label4" runat="server" Text="Roles" 
                                        AssociatedControlID="Roles_List"></asp:Label>
                                    <div>
                                        <ef:EntityDataSource ID="EntityDataSource1" runat="server"
                                            DefaultContainerName="WebFormsIdentityDatabaseEntities"
                                            ConnectionString="name=WebFormsIdentityDatabaseEntities"
                                            EnableFlattening="false" EntitySetName="AspNetRoles">
                                        </ef:EntityDataSource>
                                        <asp:RadioButtonList ID="Roles_List" runat="server" DataSourceID="EntityDataSource1" 
                                            DataTextField="Name" DataValueField="Id"></asp:RadioButtonList>
                                        <asp:CustomValidator ID="CustomValidator1" runat="server" 
                                        ErrorMessage="Select Atleast one Role" ForeColor="Red" SetFocusOnError="true"
                                        ValidationGroup="rol" ClientValidationFunction="ValidateRoleList"></asp:CustomValidator>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <asp:Button ID="UpdateRoles" CssClass="btn btn-default" runat="server" Text="Update Roles" OnClick="UpdateRoles_Click"
                                ValidationGroup="rol" />
                            &nbsp;
                            <asp:Button ID="CancelRoles" CssClass="btn btn-default" runat="server" Text="Cancel" OnClientClick="$('#updateRolesModal').modal('hide');" />
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>

    <!-- Popup Notice Modal -->
  <div class="modal fade" id="infoModal" role="dialog">
    <div class="modal-dialog modal-sm">
      <div class="modal-content">
        <div class="modal-header" style="background-color:red">
          <button type="button" class="close" data-dismiss="modal">&times;</button>
          <h4 class="modal-title">Error</h4>
        </div>
        <div class="modal-body">
          <p>You must select atleast one partner</p>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        </div>
      </div>
    </div>
  </div>

    <script type="text/javascript">
        function ValidatePillarList(source, args)
        {
          var chkListModules= document.getElementById ('<%= Pillar_List.ClientID %>');
          var chkListinputs = chkListModules.getElementsByTagName("input");
          for (var i=0;i<chkListinputs .length;i++)
          {
            if (chkListinputs [i].checked)
            {
              args.IsValid = true;
              return;
            }
          }
          args.IsValid = false;
        }

        function ValidateProjectList(source, args)
        {
          var chkListModules= document.getElementById ('<%= Implementing_Partner_List.ClientID %>');
          var chkListinputs = chkListModules.getElementsByTagName("input");
          for (var i=0;i<chkListinputs .length;i++)
          {
            if (chkListinputs [i].checked)
            {
              args.IsValid = true;
              return;
            }
          }
          args.IsValid = false;
        }

        function ValidateRoleList(source, args)
        {
          var chkListModules= document.getElementById ('<%= Roles_List.ClientID %>');
          var chkListinputs = chkListModules.getElementsByTagName("input");
          for (var i=0;i<chkListinputs .length;i++)
          {
            if (chkListinputs [i].checked)
            {
              args.IsValid = true;
              return;
            }
          }
          args.IsValid = false;
        }
    </script>

</asp:Content>
