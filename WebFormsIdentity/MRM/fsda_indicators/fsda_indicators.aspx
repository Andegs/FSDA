<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" 
    CodeBehind="fsda_indicators.aspx.cs" MaintainScrollPositionOnPostback="true"
    Inherits="WebFormsIdentity.MRM.fsda_indicators.fsda_indicators" ValidateRequest="false" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

    <ef:EntityDataSource ID="EntityDataSource1" runat="server"
        DefaultContainerName="WebFormsIdentityDatabaseEntities"
        ConnectionString="name=WebFormsIdentityDatabaseEntities"
        EnableFlattening="false" EntitySetName="fsda_indicators"
        EnableDelete="true" EnableUpdate="true">
    </ef:EntityDataSource>

    <div id="expand-box-header" style="margin-bottom: 10px">
      <span style="float:left;">
          <asp:Label ID="HeaderLabel" runat="server" CssClass="h4">FSDA Indicators</asp:Label>
      </span> 
      <span style="float:right;">
          <asp:Button ID="Button1" runat="server" CssClass="btn btn-default" Text="New FSDA Indicator"
              OnClick="Button1_Click" />
      </span>
      <div style="clear:both;"></div>
    </div>
    <hr />

    <asp:GridView ID="GridView1" runat="server" DataSourceID="EntityDataSource1"
        CssClass="table table-hover" AutoGenerateColumns="false" 
        OnRowCommand="GridView1_RowCommand" DataKeyNames="id"
        OnRowDataBound="GridView1_RowDataBound">
        <AlternatingRowStyle BackColor="White" />
        <Columns>
            <asp:BoundField DataField="id" HeaderText="ID" 
                    Visible="false" SortExpression="id"></asp:BoundField>
            <asp:TemplateField HeaderText="FSDA Indicator Code" SortExpression="fsda_indicator_code">
                <ItemTemplate>
                    <asp:Label runat="server" Text='<%# Bind("fsda_indicator_code") %>' ID="Label1"></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Indicator" SortExpression="indicator">
                <ItemTemplate>
                    <asp:Label runat="server" Text='<%# Bind("indicator") %>' ID="Label2"></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:ButtonField ButtonType="Link" Text="Edit" CommandName="editThis" HeaderText="EDIT" />
            <asp:CommandField ShowDeleteButton="true" ButtonType="Link" HeaderText="DELETE" />
        </Columns>
        <HeaderStyle BackColor="#339966" ForeColor="White" />
    </asp:GridView>

    <%--Add a new FSDA Indicator Modal--%>
    <div id="FSDAIndicatorModal" class="modal fade in" role="dialog">
        <div class="modal-dialog modal-lg">
            <%--<asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Always">
                <ContentTemplate>--%>
                    <!-- Modal Content -->
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal">
                                &times</button>
                            <h4 class="modal-title">
                                <asp:Label ID="Label5" runat="server" Text="Add FSDA Indicator"></asp:Label></h4>
                        </div>
                        <div class="modal-body">
                            <div role="form">
                                <asp:HiddenField ID="IndicatorIdHiddenField" runat="server" />
                                <div style="margin-bottom: 10px">
                                    <asp:Label ID="Label6" runat="server" 
                                        AssociatedControlID="FSDAIndicatorCode" Text="FSDA Indicator Code"></asp:Label>
                                    <div>
                                        <asp:TextBox ID="FSDAIndicatorCode" runat="server"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                                            ErrorMessage="Required Field" ForeColor="Red" ValidationGroup="cd"
                                            ControlToValidate="FSDAIndicatorCode" SetFocusOnError="true"></asp:RequiredFieldValidator>
                                    </div>
                                </div>
                                <div style="margin-bottom:10px">
                                    <asp:Label ID="Label3" runat="server" Text="FSDA Indicator"
                                        AssociatedControlID="FSDAIndicator"></asp:Label>
                                    <div>
                                        <asp:TextBox ID="FSDAIndicator" runat="server" 
                                            TextMode="MultiLine" Rows="5" Columns="20" CssClass="ckeditor"></asp:TextBox>
                                        <%--<textarea id="FSDAIndicator" runat="server" cols="20" rows="2" class="ckeditor"></textarea>--%>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                                            ErrorMessage="Required Field" ForeColor="Red" ValidationGroup="cd"
                                            ControlToValidate="FSDAIndicator" SetFocusOnError="true"></asp:RequiredFieldValidator>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <asp:Button ID="AddIndBtn" CssClass="btn btn-default" runat="server" 
                                 Text="Add FSDA Indicator" OnClick="AddIndBtn_Click" ValidationGroup="cd"
                                OnClientClick="UpdateContent()" />
                            <asp:Button ID="SaveIndBtn" CssClass="btn btn-default" runat="server" 
                                 Text="Save FSDA Indicator" OnClick="SaveIndBtn_Click" ValidationGroup="cd"
                                OnClientClick="UpdateContent()" />
                            &nbsp;
                            <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                        </div>
                    </div>
                <%--</ContentTemplate>
            </asp:UpdatePanel>--%>
        </div>
    </div>

    <%--Success Modal--%>
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
    <script type="text/javascript">
        function UpdateContent() {
            var textBoxId = $(".ckeditor").attr('ID');
            if (textBoxId != null) {
                var editor = CKEDITOR.instances[textBoxId];
                editor.updateElement();
            }
        };
    </script>
</asp:Content>