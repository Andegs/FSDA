<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" 
    CodeBehind="AddNewIndicator.aspx.cs" MaintainScrollPositionOnPostback="true" 
    Inherits="WebFormsIdentity.MRM.Project_Indicators.AddNewIndicator" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    
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

    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

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
        EntityTypeName="" TableName="indicator_types" 
        Select="new (indicator_type_id, indicator_type)">
    </asp:LinqDataSource>

    <asp:LinqDataSource ID="LinqDataSource3" runat="server"
        ContextTypeName="WebFormsIdentity.Data_Access.WebFormsIdentityDatabaseEntities"
        EntityTypeName="" TableName="fsda_indicators" 
        Select="new (id, fsda_indicator_code, indicator)">
    </asp:LinqDataSource>

    <asp:Label ID="HeaderLabel" runat="server" CssClass="h4">Add New Project Indicators Below</asp:Label>
    <hr />

    <div style="margin-bottom:10px;">
        <asp:Label runat="server" AssociatedControlID="implementingPartner">Project</asp:Label>
        <div>
            <asp:DropDownList ID="implementingPartner" runat="server" AppendDataBoundItems="true"
                DataSourceID="LinqDataSource1"
                    DataTextField="project_name" DataValueField="project_id">
                <asp:ListItem Selected="True" 
                        Text="<Select a Project>" Value="0" />
            </asp:DropDownList>
            <asp:RequiredFieldValidator ID="RFV1" runat="server" ErrorMessage="Select a Project"
                ForeColor="Red" ControlToValidate="implementingPartner" InitialValue="0"
                ValidationGroup="result"></asp:RequiredFieldValidator>
        </div>
    </div>

    <div style="margin-bottom:10px">
        <asp:Label runat="server" AssociatedControlID="indicatorType">Indicator Type</asp:Label>
        <div>
            <asp:RadioButtonList ID="indicatorType" runat="server" 
                DataSourceID="LinqDataSource2" DataValueField="indicator_type_id"
                DataTextField="indicator_type" OnSelectedIndexChanged="indicatorType_SelectedIndexChanged"
                AutoPostBack="true"></asp:RadioButtonList>
            <asp:RequiredFieldValidator ID="RFV2" runat="server" ErrorMessage="Select the Indicator Type"
                ControlToValidate="indicatorType" ForeColor="Red" SetFocusOnError="true"
                ValidationGroup="result"></asp:RequiredFieldValidator>
        </div>
    </div>

    <div style="margin-bottom:10px">
        <asp:Label runat="server" AssociatedControlID="fsdaIndicatorList">FSDA Indicator Association</asp:Label>
        <div>
            <asp:DropDownList ID="fsdaIndicatorList" runat="server" 
                DataSourceID="LinqDataSource3" DataValueField="id"
                DataTextField="fsda_indicator_code" AppendDataBoundItems="true">
                <asp:ListItem Text="N/A" Value="0" />
            </asp:DropDownList>
        </div>
    </div>

    <div style="margin-bottom:10px">
        <asp:Label runat="server" AssociatedControlID="indicator_text">Indicator</asp:Label>
        <div>
            <textarea class="form-control" id="indicator_text" runat="server" 
              placeholder="Type in the indicator" rows="2"></textarea>
            <asp:RequiredFieldValidator ID="RFV3" runat="server" ErrorMessage="Type in the Indicator"
                ControlToValidate="indicator_text" ForeColor="Red" SetFocusOnError="true"
                ValidationGroup="result"></asp:RequiredFieldValidator>
        </div>
    </div>

    <div style="margin-bottom:10px">
        <asp:Label runat="server" AssociatedControlID="Indicator_target">Indicator Target</asp:Label>
        <div>
            <textarea class="form-control" id="indicator_target" runat="server"
                placeholder="Type in the Overall target for the above indicator" rows="1" cols="5"></textarea>
            
            <asp:CompareValidator ID="NumberResultValidator" runat="server" 
                ErrorMessage="This must be a number" ForeColor="Red" Enabled="false"
                ControlToValidate="indicator_target" Operator="DataTypeCheck" Type="Integer"
                ValidationGroup="result" SetFocusOnError="true"></asp:CompareValidator>
        </div>
    </div>

    <div style="margin-bottom:10px;">
        <div>
            <asp:Button runat="server" OnClick="addIndicator_Click" 
                Text="Add Indicator" CssClass="btn btn-info" ValidationGroup="result" />
        </div>
    </div>

    <div id="indicatorsDatatableDiv" runat="server">
        <asp:Panel ID="Panel2" runat="server">
                  <%--<asp:UpdatePanel ID="UpdatePanel2" runat="server" UpdateMode="Conditional">
                      <ContentTemplate>--%>
        <hr />
        <asp:Label ID="Label1" runat="server" CssClass="h4">Review the List of Added Project Indicators</asp:Label>
        <hr />

        <div style="margin-bottom:10px;">
            <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="false" 
                OnRowDeleting="GridView1_RowDeleting" OnRowEditing="GridView1_RowEditing"
                OnRowUpdating="GridView1_RowUpdating" OnRowCancelingEdit="GridView1_RowCancelingEdit" 
                CssClass="table table-hover table-bordered table-condensed"
                OnRowCommand="GridView1_RowCommand" OnRowDataBound="GridView1_RowDataBound"
                DataKeyNames="id">
                <Columns>

                    <asp:TemplateField>
                        <ItemTemplate>
                            <img alt="" style="cursor:pointer" src="/images/plus.png" />
                            <%--<asp:Panel ID="pnlIndicatorPeriods" runat="server" style="display:none">--%>
                                <asp:UpdatePanel ID="pnlIndicatorPeriods" runat="server" UpdateMode="Always" style="display:none">
                      <ContentTemplate>
                                <asp:GridView ID="GridView2" runat="server" 
                                    AutoGenerateColumns="false"
                                    CssClass="table table-hover table-bordered table-condensed"
                                    OnRowEditing="GridView2_RowEditing"
                                    OnRowCancelingEdit="GridView2_RowCancelingEdit"
                                    OnRowUpdating="GridView2_RowUpdating"
                                    OnRowDeleting="GridView2_RowDeleting"
                                    OnRowDataBound="GridView2_RowDataBound"
                                    DataKeyNames="id">
                                    <Columns>
                                        <asp:TemplateField HeaderText="ID" Visible="false">
                                            <ItemTemplate>
                                                <asp:Label ID="IDLabel" runat="server" Text='<%# Bind("id") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="F_ID" Visible="false">
                                            <ItemTemplate>
                                                <asp:Label ID="F_IDLabel" runat="server" Text='<%# Bind("foreign_id") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Disaggregation Level">
                                            <ItemTemplate>
                                                <asp:Label ID="Label6" runat="server" Text='<%# Bind("disaggregation_id") %>'></asp:Label>
                                            </ItemTemplate>
                                            <%--<EditItemTemplate>
                                                <asp:TextBox ID="_disaggregation" runat="server" Text='<%# Bind("disaggregation") %>'></asp:TextBox>
                                            </EditItemTemplate>--%>
                                        </asp:TemplateField>
                                        <asp:CommandField ShowEditButton="true" ButtonType="Link" />
                                        <asp:CommandField ShowDeleteButton="true" ButtonType="Link" />
                                    </Columns>
                                </asp:GridView>
                          </ContentTemplate>
                      </asp:UpdatePanel>
                            <%--</asp:Panel>--%>
                            <asp:HiddenField ID="IsExpanded" runat="server" />
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField Visible="false">
                    <ItemTemplate>
                        <asp:Label ID="idLabel" runat="server" Text='<%# Bind("id") %>'></asp:Label>
                    </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Project">
                        <EditItemTemplate>
                            <asp:DropDownList ID="_implementingPartner" runat="server"
                                DataSourceID="LinqDataSource1" SelectedValue='<%# Bind("project_id") %>'
                                    DataTextField="project_name" DataValueField="project_id">
                            </asp:DropDownList>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label runat="server" Text='<%# Bind("project") %>' ID="Label1"></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Indicator Type">
                        <EditItemTemplate>
                            <asp:DropDownList ID="_indicatorType" runat="server"
                                DataSourceID="LinqDataSource2" SelectedValue='<%# Bind("indicator_type_id") %>'
                                    DataTextField="indicator_type" DataValueField="indicator_type_id">
                            </asp:DropDownList>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label runat="server" Text='<%# Bind("indicator_type") %>' ID="Label2"></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="FSDA Indicator Code">
                        <EditItemTemplate>
                            <asp:DropDownList ID="_fsdaIndicatorList" runat="server"
                                DataSourceID="LinqDataSource3" DataValueField="id"
                                DataTextField="fsda_indicator_code" AppendDataBoundItems="true"
                                SelectedValue='<%# Bind("fsda_indicator_code_id") %>'>
                                <asp:ListItem Text="N/A" Value="0" />
                            </asp:DropDownList>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="Label7" runat="server" Text='<%# Bind("fsda_indicator_code") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Indicator">
                        <EditItemTemplate>
                            <asp:TextBox runat="server" Text='<%# Bind("indicator") %>' ID="_indicator_text"></asp:TextBox>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label runat="server" Text='<%# Bind("indicator") %>' ID="Label3"></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Overall Target">
                        <EditItemTemplate>
                            <asp:TextBox runat="server" Text='<%# Bind("target") %>' ID="_indicator_target"></asp:TextBox>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label runat="server" Text='<%# Bind("target") %>' ID="Label4"></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:CommandField ShowEditButton="true" ButtonType="Link" />
                    <asp:ButtonField ButtonType="Link" Text="Disaggregate" CommandName="disaggregate" />
                    <asp:CommandField ShowDeleteButton="true" ButtonType="Link" />
                </Columns>
            </asp:GridView>
        </div>

        <div style="margin-bottom:10px;">
            <asp:Button ID="saveUpdateIndicatorsBtn" runat="server" Text="Save and Persist Indicators to Database" 
                CssClass="btn btn-warning" OnClick="saveUpdateIndicatorsBtn_Click" OnClientClick="ShowProgress()" />
        </div>
        <%--</ContentTemplate>
                      </asp:UpdatePanel>--%>
            </asp:Panel>
    </div>

    <%--<!-- Disaggregate Modal -->
    <div id="disaggragateModal" class="modal fade" role="dialog">
      <div class="modal-dialog modal-lg">
        <!-- Modal content-->
        <div class="modal-content">
          <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal">&times;</button>
            <h4 class="modal-title">Disaggregate this indicator.</h4>
          </div>
          <div class="modal-body">

        <asp:Panel ID="Panel1" runat="server">
            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>

            <div style="margin-bottom:10px;">
                 <asp:Label ID="ModalHeaderLabel" runat="server"></asp:Label>
                 <asp:HiddenField ID="HiddenProjectID" runat="server" />
             </div>
            <div style="margin-bottom:10px;">
                <asp:Label ID="Label4" runat="server" Text="Enter Disaggregation Level" 
                    AssociatedControlID="DisaggregationTextBox"></asp:Label>
                <div>
                    <asp:TextBox ID="DisaggregationTextBox" runat="server"></asp:TextBox>
                </div>
            </div>

            <div style="margin-bottom:10px;">
                <div>
                    <asp:Button runat="server" ID="OkBtn" OnClick="OkBtn_Click"
                        Text="Ok" CssClass="btn btn-default btn-info" />
                </div>
            </div>

                <div style="margin-bottom:10px;">
                    <asp:GridView ID="GridView3" runat="server" AutoGenerateColumns="false"
                        CssClass="table table-hover table-bordered table-condensed" 
                        OnRowEditing="GridView3_RowEditing" OnRowCancelingEdit="GridView3_RowCancelingEdit"
                        OnRowUpdating="GridView3_RowUpdating" OnRowDeleting="GridView3_RowDeleting">
                        <Columns>
                            <asp:TemplateField HeaderText="ID" Visible="false">
                                <ItemTemplate>
                                    <asp:Label ID="Label5" runat="server" Text='<%# Bind("foreign_id") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Disaggregation Level">
                                <ItemTemplate>
                                    <asp:Label ID="Label6" runat="server" Text='<%# Bind("disaggregation") %>'></asp:Label>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:TextBox ID="TextBox1" runat="server" Text='<%# Bind("disaggregation") %>'></asp:TextBox>
                                </EditItemTemplate>
                            </asp:TemplateField>
                            <asp:CommandField ShowEditButton="true" ButtonType="Link" />
                            <asp:CommandField ShowDeleteButton="true" ButtonType="Link" />
                        </Columns>
                    </asp:GridView>
                </div>
                <div style="margin-bottom:10px;">
                  <asp:Button ID="SaveDisaggregationBtn" runat="server" 
                       data-dismiss="modal"
                      CssClass="btn btn-default btn-warning" Visible="false" Text="Save and Exit"
                      OnClientClick="postback()" />
              </div>

            
            </ContentTemplate>
            </asp:UpdatePanel>
        </asp:Panel>

          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-default" data-dismiss="modal">Exit</button>
          </div>
        </div>
      </div>
    </div>
    <asp:Button ID="Button1" runat="server" Style="display:none" OnClick="SaveDisaggregationBtn_Click" />--%>

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
            <asp:Button ID="okButton" runat="server" Text="OK"  
                class="btn btn-default" OnClick="okButton_Click" />
        </div>
      </div>
    </div>
  </div>


    <%-- ==========================Begin Test Area==========================================--%>
    <!-- Disaggregate Modal -->
    <div id="disaggragateModal" class="modal fade" role="dialog">
      <div class="modal-dialog modal-lg">
        <!-- Modal content-->
        <div class="modal-content">
          <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal">&times;</button>
            <h4 class="modal-title">Disaggregate this indicator.</h4>
          </div>
          <div class="modal-body">

        <asp:Panel ID="Panel1" runat="server">
            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>

            <div style="margin-bottom:10px;">
                 <asp:Label ID="ModalHeaderLabel" runat="server"></asp:Label>
                 <asp:HiddenField ID="HiddenProjectIndicatorID" runat="server" />
             </div>
            <div style="margin-bottom:10px;">
                <asp:Label ID="Label4" runat="server" Text="Enter First Disaggregation Level" 
                    AssociatedControlID="Disaggregation1DropDown"></asp:Label>
                <div>
                    <asp:LinqDataSource ID="LinqDataSource4" runat="server"
                        ContextTypeName="WebFormsIdentity.Data_Access.WebFormsIdentityDatabaseEntities"
                        EntityTypeName="" Select="new (id, disaggregation_name)"
                        TableName="disaggregations" Where="disaggregation_id == null">
                    </asp:LinqDataSource>

                    
                    <%--<ajaxToolkit:ComboBox ID="ComboBox1" runat="server"
                        DataSourceID="LinqDataSource4" DataTextField="disaggregation_name"
                        DataValueField="id" MaxLength="0"
                        AutoCompleteMode="Append" DropDownStyle="Simple" ItemInsertLocation="Append">
                    </ajaxToolkit:ComboBox>--%>

                    <%--<asp:TextBox ID="DisagTextBox" runat="server" list="disag" AutoPostBack="true"
                        OnTextChanged="DisagTextBox_TextChanged"></asp:TextBox>
                    <datalist id="disag" runat="server">
                        <option value="test" id="1"></option>
                        <option value="none" id="2"></option>
                    </datalist>
                    <asp:Label ID="Label9" runat="server"></asp:Label>--%>

                    <asp:DropDownList ID="Disaggregation1DropDown" runat="server" AutoPostBack="true" DataSourceID="LinqDataSource4" 
                        AppendDataBoundItems="false" OnSelectedIndexChanged="Disaggregation1DropDown_SelectedIndexChanged"
                        DataTextField="disaggregation_name" DataValueField="id" OnDataBound="Disaggregation1DropDown_DataBound">
                    </asp:DropDownList>
                    <asp:HiddenField ID="disaglvl1field" runat="server" />


                </div>
            </div>
                    <div style="margin-bottom:10px;" id="lvl2" runat="server" visible="false">
                        <asp:Label ID="Label9" runat="server" Text="Enter Second Disaggregation Level" 
                            AssociatedControlID="Disaggregation2DropDown"></asp:Label>
                        <div>
                            <asp:LinqDataSource ID="LinqDataSource5" runat="server"
                                ContextTypeName="WebFormsIdentity.Data_Access.WebFormsIdentityDatabaseEntities"
                                EntityTypeName="" Select="new (id, disaggregation_name)"
                                TableName="disaggregations">
                            </asp:LinqDataSource>

                            <asp:DropDownList ID="Disaggregation2DropDown" runat="server" AutoPostBack="true" DataSourceID="LinqDataSource5" 
                                AppendDataBoundItems="false" OnSelectedIndexChanged="Disaggregation2DropDown_SelectedIndexChanged"
                                DataTextField="disaggregation_name" DataValueField="id" OnDataBound="Disaggregation2DropDown_DataBound">
                            </asp:DropDownList>
                            <asp:HiddenField ID="disaglvl2field" runat="server" />
                        </div>
                    </div>
                    <div style="margin-bottom:10px;" id="lvl3" runat="server" visible="false">
                        <asp:Label ID="Label10" runat="server" Text="Enter Third Disaggregation Level"
                            AssociatedControlID="Disaggregation3DropDown"></asp:Label>
                        <div>
                            <asp:LinqDataSource ID="LinqDataSource6" runat="server"
                                ContextTypeName="WebFormsIdentity.Data_Access.WebFormsIdentityDatabaseEntities"
                                EntityTypeName="" Select="new (id, disaggregation_name)"
                                TableName="disaggregations">
                            </asp:LinqDataSource>

                            <asp:DropDownList ID="Disaggregation3DropDown" runat="server" AutoPostBack="true" DataSourceID="LinqDataSource6" 
                                AppendDataBoundItems="false" OnSelectedIndexChanged="Disaggregation3DropDown_SelectedIndexChanged"
                                DataTextField="disaggregation_name" DataValueField="id" OnDataBound="Disaggregation3DropDown_DataBound">
                            </asp:DropDownList>
                            <asp:HiddenField ID="disaglvl3field" runat="server" />
                        </div>
                    </div>

            <div style="margin-bottom:10px;">
                <div>
                    <asp:Button runat="server" ID="OkBtn" OnClick="OkBtn_Click"
                        Text="Ok" CssClass="btn btn-default btn-info" />
                </div>
            </div>

                <div style="margin-bottom:10px;">

                    <ef:EntityDataSource ID="EntityDataSource1" runat="server"
                    DefaultContainerName="WebFormsIdentityDatabaseEntities"
                    ConnectionString="name=WebFormsIdentityDatabaseEntities"
                    EnableFlattening="false" EntitySetName="project_indicator_disaggregation" 
                    EnableDelete="true" EnableInsert="true" EnableUpdate="true"
                        AutoGenerateWhereClause="true"
                    Include="partner_indicators,disaggregation"></ef:EntityDataSource>

                    <asp:GridView ID="GridView3" runat="server" AutoGenerateColumns="false"
                        CssClass="table table-hover table-bordered table-condensed"
                        OnRowEditing="GridView3_RowEditing" OnRowCancelingEdit="GridView3_RowCancelingEdit"
                        OnRowUpdating="GridView3_RowUpdating" OnRowDeleting="GridView3_RowDeleting"  
                        OnRowDataBound="GridView3_RowDataBound">
                        <Columns>
                            <asp:TemplateField HeaderText="ID" Visible="false">
                                <ItemTemplate>
                                    <asp:Label ID="Label11" runat="server" Text='<%# Bind("foreign_id") %>'></asp:Label>
                                    <asp:Label ID="Label5" runat="server" Text='<%# Bind("disaggregation_id") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Disaggregation Level">
                                <ItemTemplate>
                                    <asp:Label ID="Label6" runat="server"></asp:Label>
                                </ItemTemplate>
                                <%--<EditItemTemplate>
                                    <asp:TextBox ID="TextBox1" runat="server" Text='<%# Bind("disaggregation") %>'></asp:TextBox>
                                </EditItemTemplate>--%>
                            </asp:TemplateField>
                            <%--<asp:CommandField ShowEditButton="true" ButtonType="Link" />--%>
                            <asp:CommandField ShowDeleteButton="true" ButtonType="Link" />
                        </Columns>
                    </asp:GridView>
                </div>
                <div style="margin-bottom:10px;">
                  <asp:Button ID="SaveDisaggregationBtn" runat="server" 
                       data-dismiss="modal"
                      CssClass="btn btn-default btn-warning" Visible="false" Text="Save and Exit"
                      OnClientClick="postback()" />
              </div>

            
            </ContentTemplate>
            </asp:UpdatePanel>
        </asp:Panel>

          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-default" data-dismiss="modal">Exit</button>
          </div>
        </div>
      </div>
    </div>
    <asp:Button ID="Button1" runat="server" Style="display:none" OnClick="SaveDisaggregationBtn_Click" />

    <div class="modal fade" id="newDisaggModal" role="dialog">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header" style="background-color:forestgreen;">
          <button type="button" class="close" data-dismiss="modal">&times;</button>
          <h4 class="modal-title">New Disaggregation Level</h4>
        </div>
        <div class="modal-body">

            <asp:Panel ID="Panel3" runat="server">
            <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                <ContentTemplate>
          <div style="margin-bottom:10px;">
                <asp:Label ID="Label8" runat="server" Text="Enter Disaggregation Level" 
                    AssociatedControlID="DisaggregationTxBx"></asp:Label>
                <div>
                    <asp:TextBox ID="DisaggregationTxBx" runat="server"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                        ErrorMessage="**" ForeColor="Red" ValidationGroup="ndl" ControlToValidate="DisaggregationTxBx"></asp:RequiredFieldValidator>
                </div>
            </div>
            <div style="margin-bottom:10px;">
                <div>
                    <asp:Button ID="NewDisagLvl1Btn" runat="server" Text="Ok(lvl1)" OnClick="NewDisagLvl1Btn_Click" Visible="false" ValidationGroup="ndl" />
                    <asp:Button ID="NewDisagLvl2Btn" runat="server" Text="Ok(lvl2)" OnClick="NewDisagLvl2Btn_Click" Visible="false" ValidationGroup="ndl" />
                    <asp:Button ID="NewDisagLvl3Btn" runat="server" Text="Ok(lvl3)" OnClick="NewDisagLvl3Btn_Click" Visible="false" ValidationGroup="ndl" /> 
                </div>
            </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
                </asp:Panel>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-default" data-dismiss="modal">Exit</button>
        </div>
      </div>
    </div>
  </div>

    <%-- ==========================End Test Area==========================================--%>


    <div class="loading" style="margin:auto">
    Loading. Please wait.<br />
    <br />
    <img src="/images/loader.gif" alt="" />
    </div>

    <script type="text/javascript">
        function ShowProgress() {
            setTimeout(function () {
                var modal = $('<div />');
                modal.addClass("modal");
                $('body').append(modal);
                var loading = $(".loading");
                loading.show();
                var top = Math.max($(window).height() / 2 - loading[0].offsetHeight / 2, 0);
                var left = Math.max($(window).width() / 2 - loading[0].offsetWidth / 2, 0);
                loading.css({ top: top, left: left });
            }, 200);
        }
        //$('form').live("submit", function () {
        //    ShowProgress();
        //});

        function postback() {
            var clickButton = document.getElementById("<%= Button1.ClientID %>");
            clickButton.click();
        }

    </script>

    <script type="text/javascript">
        function expand() {
            $(this).closest("tr").after("<tr><td></td><td colspan = '999'>" + $(this).next().html() + "</td></tr>")
            $(this).attr("src", "/images/minus.png");
            $(this).next().next().val(1);
        }
        function collapse() {
            $(this).attr("src", "/images/plus.png");
            $(this).closest("tr").next().remove();
            $(this).next().next().val("");
        }
        
        $(document).on("click", "[src*=plus]", expand);
        $(document).on("click", "[src*=minus]", collapse);

        $(function () {
            $("[id*=IsExpanded]").each(function () {
                if ($(this).val() == "1") {
                    $(this).closest("tr").after("<tr><td></td><td colspan = '999'>" + $("[id*=pnlIndicatorPeriods]", $(this).closest("tr")).html() + "</td></tr>")
                    $("[src*=plus]", $(this).closest("tr")).attr("src", "/images/minus.png");
                }
            });
        });

        /*$(document).on("click", "[src*=plus]", function () {
            $(this).closest("tr").after("<tr><td></td><td colspan = '999'>" + $(this).next().html() + "</td></tr>")
            $(this).attr("src", "/images/minus.png");
            $(this).next().next().val(1);
        });
        $(document).on("click", "[src*=minus]", function () {
            $(this).attr("src", "/images/plus.png");
            $(this).closest("tr").next().remove();
            $(this).next().next().val("");
        });
        $(function () {
            $("[id*=IsExpanded]").each(function () {
                if ($(this).val() == "1") {
                    $(this).closest("tr").after("<tr><td></td><td colspan = '999'>" + $("[id*=pnlIndicatorPeriods]", $(this).closest("tr")).html() + "</td></tr>")
                    $("[src*=plus]", $(this).closest("tr")).attr("src", "/images/minus.png");
                }
            });
        })*/
        
    </script>

</asp:Content>
