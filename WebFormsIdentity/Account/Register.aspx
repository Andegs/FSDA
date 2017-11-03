<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" 
    CodeBehind="Register.aspx.cs" 
    Inherits="WebFormsIdentity.Account.Register" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>
       function radioMe(e) {
          if (!e) e = window.event;
          var sender = e.target || e.srcElement;

          if (sender.nodeName != 'INPUT') return;
          var checker = sender;
          var chkBox = document.getElementById('<%= Implementing_Partner_List.ClientID %>');
          var chks = chkBox.getElementsByTagName('INPUT');
          for (i = 0; i < chks.length; i++) {
              if (chks[i] != checker)
              chks[i].checked = false;
          }
       }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
        <h4 style="font-size: medium">Register a new user</h4>
        <hr />
        <p>
            <asp:Literal runat="server" ID="StatusMessage" />
        </p>                
        <div style="margin-bottom:10px">
            <asp:Label runat="server" AssociatedControlID="UserName">User name</asp:Label>
            <div>
                <asp:TextBox runat="server" ID="UserName" />
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                    ErrorMessage="**" ForeColor="Red" ControlToValidate="UserName"
                    SetFocusOnError="true" ValidationGroup="reg"></asp:RequiredFieldValidator>                
            </div>
        </div>
        <div style="margin-bottom:10px">
            <asp:Label ID="Label1" runat="server" Text="Email" AssociatedControlID="Email"></asp:Label>
            <div>
                <asp:TextBox ID="Email" runat="server" TextMode="Email"></asp:TextBox>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" 
                    ErrorMessage="Enter a valid Email Address" ForeColor="Red" ControlToValidate="Email"
                    SetFocusOnError="true" ValidationGroup="reg" 
                    ValidationExpression="^([a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]){1,70}$"></asp:RegularExpressionValidator>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                    ErrorMessage="**" ForeColor="Red" ControlToValidate="Email"
                    SetFocusOnError="true" ValidationGroup="reg"></asp:RequiredFieldValidator>
            </div>
        </div>
        <div style="margin-bottom:10px">
            <asp:Label ID="Label2" runat="server" Text="Role" AssociatedControlID="RolesList"></asp:Label>
            <div>
                <%--Add some radial boxes here--%>
                <asp:RadioButtonList ID="RolesList" runat="server" AutoPostBack="true" EnableViewState="true" 
                    OnSelectedIndexChanged="RolesList_SelectedIndexChanged"></asp:RadioButtonList>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" 
                    ErrorMessage="**" ForeColor="Red" ControlToValidate="RolesList"
                    SetFocusOnError="true" ValidationGroup="reg"></asp:RequiredFieldValidator>
            </div>
        </div>
        
        <div id="pillar" runat="server" visible="false" style="margin-bottom:10px;">
            <asp:Label ID="Label4" runat="server" Text="Pillars" 
                AssociatedControlID="Pillars_List"></asp:Label>
            <div>
                <asp:CheckBoxList ID="Pillars_List" runat="server"
                    DataValueField="pillar_id" DataTextField="name"></asp:CheckBoxList>
                <asp:CustomValidator ID="CustomValidator1" runat="server" 
                    ErrorMessage="Select Atleast One Pillar" ForeColor="Red" SetFocusOnError="true" 
                    ValidationGroup="reg" ClientValidationFunction="ValidatePillarList"></asp:CustomValidator>
                <%--<asp:RequiredFieldValidator ID="PillarsListValidator" runat="server" 
                    ErrorMessage="**" ForeColor="Red" ControlToValidate="Pillars_List"
                    SetFocusOnError="true" ValidationGroup="reg"></asp:RequiredFieldValidator>--%>
            </div>
        </div>

        <div id="project" runat="server" visible="false" style="margin-bottom:10px;">
            <asp:Label ID="Label3" runat="server" Text="Projects" 
                AssociatedControlID="Implementing_Partner_List"></asp:Label>
            <div>
                <asp:CheckBoxList ID="Implementing_Partner_List" runat="server" 
                    DataValueField="project_id" DataTextField="project_name"></asp:CheckBoxList>
                <asp:CustomValidator ID="CustomValidator2" runat="server" 
                    ErrorMessage="Select Atleast one Project" ForeColor="Red" SetFocusOnError="true"
                    ValidationGroup="reg" ClientValidationFunction="ValidateProjectList"></asp:CustomValidator>
                <%--<asp:RequiredFieldValidator ID="PartnerListValidator" runat="server" 
                    ErrorMessage="**" ForeColor="Red" ControlToValidate="Implementing_Partner_List"
                    SetFocusOnError="true" ValidationGroup="reg"></asp:RequiredFieldValidator>--%>
            </div>
        </div>

        <div style="margin-bottom:10px">
            <asp:Label runat="server" AssociatedControlID="Password">Password</asp:Label>
            <div>
                <asp:TextBox runat="server" ID="Password" TextMode="Password" /> 
                <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" 
                    ErrorMessage="**" ForeColor="Red" ControlToValidate="Password"
                    SetFocusOnError="true" ValidationGroup="reg"></asp:RequiredFieldValidator>     
            </div>
        </div>
        <div style="margin-bottom:10px">
            <asp:Label runat="server" AssociatedControlID="ConfirmPassword">Confirm password</asp:Label>
            <div>
                <asp:TextBox runat="server" ID="ConfirmPassword" TextMode="Password" />  
                <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" 
                    ErrorMessage="**" ForeColor="Red" ControlToValidate="ConfirmPassword"
                    SetFocusOnError="true" ValidationGroup="reg"></asp:RequiredFieldValidator> 
                <asp:CompareValidator ID="CompareValidator1" runat="server" 
                    ErrorMessage="The Passwords do not match" ForeColor="Red" 
                    ControlToValidate="ConfirmPassword" ControlToCompare="Password"
                    SetFocusOnError="true" ValidationGroup="reg"></asp:CompareValidator>    
            </div>
        </div>
        <div style="margin-bottom:10px">
            <div>
                <asp:Button runat="server" OnClick="CreateUser_Click" Text="Register" 
                    ValidationGroup="reg" />
            </div>
        </div>

    <!-- Popup Notice Modal -->
  <div class="modal fade" id="infoModal" role="dialog">
    <div class="modal-dialog modal-sm">
      <div class="modal-content">
        <div class="modal-header" style="background-color:lawngreen">
          <button type="button" class="close" data-dismiss="modal">&times;</button>
          <h4 class="modal-title">Success</h4>
        </div>
        <div class="modal-body">
          <p>
              <asp:Label ID="SuccessLbl" runat="server"></asp:Label></p>
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
          var chkListModules= document.getElementById ('<%= Pillars_List.ClientID %>');
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
    </script>

    </asp:Content>
