<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" 
    MaintainScrollPositionOnPostback="true" CodeBehind="ProjectIndicators.aspx.cs" Inherits="WebFormsIdentity.MRM.Project_Indicators.ProjectIndicators" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    
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
        EntityTypeName="" Select="new (year1, year_id)" TableName="years">
    </asp:LinqDataSource>

    <asp:LinqDataSource ID="LinqDataSource4" runat="server" 
        ContextTypeName="WebFormsIdentity.Data_Access.WebFormsIdentityDatabaseEntities" 
        EntityTypeName="" Select="new (report_period_id, period, period_name)" 
        TableName="report_periods">
    </asp:LinqDataSource>

    <ef:EntityDataSource ID="EntityDataSource1" runat="server"
        DefaultContainerName="WebFormsIdentityDatabaseEntities"
        ConnectionString="name=WebFormsIdentityDatabaseEntities"
        EnableFlattening="false" EntitySetName="partner_indicators"
        Include="project,indicator_types"
        AutoGenerateWhereClause="true" EnableDelete="true" EnableUpdate="true">
        <WhereParameters>
            <asp:Parameter Name="project_id" Type="Int64" />
        </WhereParameters>
    </ef:EntityDataSource>

    <ef:EntityDataSource ID="EntityDataSource2" runat="server"
        DefaultContainerName="WebFormsIdentityDatabaseEntities"
        ConnectionString="name=WebFormsIdentityDatabaseEntities"
        EnableFlattening="false" EntitySetName="indicator_report_planner"
        Include="partner_indicators,year,report_periods"
        AutoGenerateWhereClause="true" EnableDelete="true" EnableUpdate="true">
        <WhereParameters>
            <asp:Parameter Name="partner_indicator_id" Type="Int64" />
        </WhereParameters>
    </ef:EntityDataSource>

    <asp:Label ID="HeaderLabel" runat="server" CssClass="h4">Review Project indicators</asp:Label>
    <hr />

    <div style="margin-bottom:10px;">
        <asp:Label ID="Label1" runat="server">Select a Project Below</asp:Label>
        <div>
            <asp:DropDownList ID="ProjectDropDownList" runat="server" AppendDataBoundItems="true"
                DataSourceID="LinqDataSource1" DataTextField="project_name" 
                DataValueField="project_id" AutoPostBack="true"
                OnSelectedIndexChanged="ProjectDropDownList_SelectedIndexChanged">
                <asp:ListItem Selected="True" 
                        Text="<Select Implementing Partner>" Value="0" />
            </asp:DropDownList>
        </div>
    </div>

    <div id="indicatorsDatatableDiv" runat="server" style="margin-bottom:10px;">
        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="false" 
            DataSourceID="EntityDataSource1" Visible="false" DataKeyNames="partner_indicator_id"
            CssClass="table table-hover table-bordered table-condensed"
            OnRowCommand="GridView1_RowCommand" OnRowDataBound="GridView1_RowDataBound">
            <EmptyDataRowStyle backcolor="LightBlue" forecolor="Red"/>
            <EmptyDataTemplate>
                No Indicators Found!
            </EmptyDataTemplate>
            <Columns>
                <%--<asp:TemplateField>
                    <ItemTemplate>
                        <a href="javascript:expandcollapse('div<%# Eval("partner_indicator_id") %>', 'one');">
                            <img id="imgdiv<%# Eval("partner_indicator_id") %>" alt="Click to show/hide Orders for Customer <%# Eval("partner_indicator_id") %>" src="/images/plus.png"/>
                        </a>
                    </ItemTemplate>
                </asp:TemplateField>--%>
                <asp:TemplateField Visible="false">
                    <ItemTemplate>
                        <asp:Label ID="PidLabel" runat="server" Text='<%# Bind("partner_indicator_id") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField>
                    <ItemTemplate>
                        <img alt="" style="cursor:pointer" src="/images/plus.png" />


                        <asp:Panel ID="pnlIndicatorPeriods" runat="server" style="display:none">
                            <asp:GridView ID="gvIndicatorPeriods" runat="server" 
                                AutoGenerateColumns="false" Visible="true" 
                                CssClass="table table-hover table-bordered table-condensed"
                                DataKeyNames="partner_indicator_id,report_period_id,year_id"
                                OnRowEditing="gvIndicatorPeriods_RowEditing"
                                OnRowCancelingEdit="gvIndicatorPeriods_RowCancelingEdit"
                                OnRowDeleting="gvIndicatorPeriods_RowDeleting"
                                OnRowUpdating="gvIndicatorPeriods_RowUpdating">
                                <Columns>
                                    <asp:TemplateField HeaderText="Year">
                                        <ItemTemplate>
                                            <asp:Label ID="YrLabel" runat="server" Text='<%# Eval("year.year1") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Quarter">
                                        <ItemTemplate>
                                            <asp:Label ID="PeriodLabel" runat="server" Text='<%# Eval("report_periods.period") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Period Target">
                                        <ItemTemplate>
                                            <asp:Label ID="TargetLabel" runat="server" Text='<%# Bind("q_target") %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="TargetTextBox" runat="server" Text='<%# Bind("q_target") %>'></asp:TextBox>
                                        </EditItemTemplate>
                                    </asp:TemplateField>
                                    <asp:CommandField ShowEditButton="true" ButtonType="Link" />
                                    <asp:CommandField ShowDeleteButton="true" ButtonType="Link" />
                                </Columns>
                            </asp:GridView>

                            <asp:GridView ID="Periods_GridView" runat="server"
                      CssClass="table table-hover table-bordered table-condensed" 
                      AutoGenerateColumns="false" OnRowEditing="Periods_GridView_RowEditing"
                                OnRowCancelingEdit="Periods_GridView_RowCancelingEdit"
                                OnRowUpdating="Periods_GridView_RowUpdating" Visible="false">
                      <Columns>
                        <asp:TemplateField Visible="false">
                                <ItemTemplate>
                                    <asp:Label ID="YrIdLabel" runat="server" Text='<%# Bind("year_id") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                          <asp:TemplateField HeaderText="Year">
                              <ItemTemplate>
                                  <asp:Label ID="YrLabel" runat="server" Text='<%# Bind("year1") %>'></asp:Label>
                              </ItemTemplate>
                          </asp:TemplateField>
                          <asp:TemplateField HeaderText="Quarter 1">
                                <EditItemTemplate>
                                    <asp:CheckBox ID="CheckBox1" runat="server" Enabled="true" />
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:CheckBox ID="CheckBox1" runat="server" Enabled="false" />
                                </ItemTemplate>
                            </asp:TemplateField>
                          <asp:TemplateField HeaderText="Quarter 2">
                                <EditItemTemplate>
                                    <asp:CheckBox ID="CheckBox2" runat="server" Enabled="true" />
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:CheckBox ID="CheckBox2" runat="server" Enabled="false" />
                                </ItemTemplate>
                            </asp:TemplateField>
                          <asp:TemplateField HeaderText="Quarter 3">
                                <EditItemTemplate>
                                    <asp:CheckBox ID="CheckBox3" runat="server" Enabled="true" />
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:CheckBox ID="CheckBox3" runat="server" Enabled="false" />
                                </ItemTemplate>
                            </asp:TemplateField>
                          <asp:TemplateField HeaderText="Quarter 4">
                                <EditItemTemplate>
                                    <asp:CheckBox ID="CheckBox4" runat="server" Enabled="true" />
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:CheckBox ID="CheckBox4" runat="server" Enabled="false" />
                                </ItemTemplate>
                            </asp:TemplateField>
                          <asp:TemplateField HeaderText="Bi-Annual 1">
                                <EditItemTemplate>
                                    <asp:CheckBox ID="CheckBox5" runat="server" Enabled="true" />
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:CheckBox ID="CheckBox5" runat="server" Enabled="false" />
                                </ItemTemplate>
                            </asp:TemplateField>
                          <asp:TemplateField HeaderText="Bi-Annual 2">
                                <EditItemTemplate>
                                    <asp:CheckBox ID="CheckBox6" runat="server" Enabled="true" />
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:CheckBox ID="CheckBox6" runat="server" Enabled="false" />
                                </ItemTemplate>
                            </asp:TemplateField>
                          <asp:CommandField ShowEditButton="true" ButtonType="Link" />
                            <asp:CommandField ShowDeleteButton="true" ButtonType="Link" />
                      </Columns>
                  </asp:GridView>
                        </asp:Panel>
                        <asp:HiddenField ID="IsExpanded" runat="server" />

                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Implementing Partner">
                    <EditItemTemplate>
                        <asp:DropDownList ID="_implementingPartner" runat="server"
                            DataSourceID="LinqDataSource1" SelectedValue='<%# Bind("project_id") %>'
                                DataTextField="project_name" DataValueField="project_id">
                        </asp:DropDownList>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label runat="server" Text='<%# Eval("project.project_name") %>' ID="Label1"></asp:Label>
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
                        <asp:Label runat="server" Text='<%# Eval("indicator_types.indicator_type") %>' ID="Label2"></asp:Label>
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
                <asp:TemplateField HeaderText="Indicator Target">
                    <EditItemTemplate>
                        <asp:TextBox runat="server" Text='<%# Bind("target") %>' ID="_indicator_target"></asp:TextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label13" runat="server" Text='<%# Bind("target") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:ButtonField CommandName="plan" ButtonType="Link" Text="Set Targets / Plan" />
                <asp:ButtonField ButtonType="Link" Text="Disaggregation" CommandName="disaggregate" />
                <asp:CommandField ShowEditButton="true" ButtonType="Link" />
                <asp:CommandField ShowDeleteButton="true" ButtonType="Link" />
            </Columns>
        </asp:GridView>
    </div>


    <!-- Plan Modal -->
    <div id="planModal" class="modal fade" role="dialog">
      <div class="modal-dialog modal-lg">
        <!-- Modal content-->
        <div class="modal-content">
          <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal">&times;</button>
            <h4 class="modal-title">Set reporting periods for this indicator.</h4>
          </div>
          <div class="modal-body">

              <asp:Panel ID="Panel1" runat="server">
                  <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                      <ContentTemplate>

            <div style="margin-bottom:10px;">
                 <asp:Label ID="ModalPlanHeaderLabel" runat="server"></asp:Label>
                 <asp:HiddenField ID="HiddenPlanIndicatorID" runat="server" />
             </div>
            <hr />

            <div style="margin-bottom: 10px">
                <asp:Label ID="Label4" runat="server" Text="Year" AssociatedControlID="YearList"></asp:Label>
                <div>
                    <asp:DropDownList ID="YearList" runat="server" 
                        DataSourceID="LinqDataSource3" DataTextField="year1" 
                        DataValueField="year_id"></asp:DropDownList>
                </div>
            </div>

              <div style="margin-bottom:10px;">
                  <asp:Label ID="Label5" runat="server" Text="Period" AssociatedControlID="PeriodList"></asp:Label>
                  <div>
                      <asp:RadioButtonList ID="PeriodList" runat="server"
                          DataSourceID="LinqDataSource4" DataTextField="period_name"
                          DataValueField="report_period_id"></asp:RadioButtonList>
                  </div>
              </div>

            <div style="margin-bottom:10px;">
                <asp:Label ID="Label6" runat="server" Text="Period Target" AssociatedControlID="TargetTextBox"></asp:Label>
                <div>
                    <asp:TextBox ID="TargetTextBox" runat="server"></asp:TextBox>
                    <div id="error" runat="server" visible="false">
                        <br />
                        <asp:Label ID="Label12" runat="server" Text="This Target Requires a Number" ForeColor="Red"></asp:Label>
                    </div>
                </div>
            </div>

              
              <div style="margin-bottom:10px;">
                  <div>
                      <asp:Button runat="server" OnClick="SavePeriods_Click" 
                        Text="Add Report Period(s)" CssClass="btn btn-default btn-info" />
                  </div>
              </div>

              
              <div style="margin-bottom:10px;">
                  <asp:GridView ID="GridView3" runat="server" CssClass="table table-hover table-bordered table-condensed" 
                      AutoGenerateColumns="false" Visible="true" 
                      OnRowEditing="GridView3_RowEditing"
                      OnRowCancelingEdit="GridView3_RowCancelingEdit"
                      OnRowDeleting="GridView3_RowDeleting"
                      OnRowUpdating="GridView3_RowUpdating"
                      DataKeyNames="id">
                      <Columns>
                          <asp:TemplateField Visible="false">
                              <ItemTemplate>
                                  <asp:Label ID="PlannerLabel" runat="server" Text='<%# Bind("id") %>'></asp:Label>
                              </ItemTemplate>
                          </asp:TemplateField>
                          <asp:TemplateField Visible="false">
                              <ItemTemplate>
                                  <asp:Label ID="Label7" runat="server" Text='<%# Bind("partner_indicator_id") %>'></asp:Label>
                              </ItemTemplate>
                          </asp:TemplateField>
                          <asp:TemplateField HeaderText="Year">
                              <ItemTemplate>
                                  <asp:Label ID="Label8" runat="server" Text='<%# Bind("year1") %>'></asp:Label>
                              </ItemTemplate>
                          </asp:TemplateField>
                          <asp:TemplateField HeaderText="Report Period">
                              <ItemTemplate>
                                  <asp:Label ID="Label9" runat="server" Text='<%# Bind("period") %>'></asp:Label>
                              </ItemTemplate>
                          </asp:TemplateField>
                          <asp:TemplateField HeaderText="Indicator Target">
                              <ItemTemplate>
                                  <asp:Label ID="Label10" runat="server" Text='<%# Bind("target") %>'></asp:Label>
                              </ItemTemplate>
                              <EditItemTemplate>
                                  <asp:TextBox ID="TargetTxBx" runat="server" Text='<%# Bind("target") %>'></asp:TextBox>
                                    
                                    <%--<asp:Label ID="errorTarget" runat="server" 
                                        Text="This Target Requires a Number" 
                                        ForeColor="Red" Visible="false"></asp:Label>--%>
                              </EditItemTemplate>
                          </asp:TemplateField>
                        <asp:CommandField ShowEditButton="true" ButtonType="Link" />
                        <asp:CommandField ShowDeleteButton="true" ButtonType="Link" />
                      </Columns>
                  </asp:GridView>

                  <asp:GridView ID="GridView2" runat="server" OnRowEditing="GridView2_RowEditing"
                      CssClass="table table-hover table-bordered table-condensed" 
                      AutoGenerateColumns="false" OnRowCancelingEdit="GridView2_RowCancelingEdit"
                      OnRowDeleting="GridView2_RowDeleting" OnRowUpdating="GridView2_RowUpdating"
                      Visible="false">
                      <Columns>
                        <asp:TemplateField Visible="false">
                                <ItemTemplate>
                                    <asp:Label ID="YrIdLabel" runat="server" Text='<%# Bind("year_id") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                          <asp:TemplateField HeaderText="Year">
                              <ItemTemplate>
                                  <asp:Label ID="YrLabel" runat="server" Text='<%# Bind("year1") %>'></asp:Label>
                              </ItemTemplate>
                          </asp:TemplateField>
                          <asp:TemplateField HeaderText="Quarter 1">
                                <EditItemTemplate>
                                    <asp:CheckBox ID="CheckBox1" runat="server" Enabled="true" />
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:CheckBox ID="CheckBox1" runat="server" Enabled="false" />
                                </ItemTemplate>
                            </asp:TemplateField>
                          <asp:TemplateField HeaderText="Quarter 2">
                                <EditItemTemplate>
                                    <asp:CheckBox ID="CheckBox2" runat="server" Enabled="true" />
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:CheckBox ID="CheckBox2" runat="server" Enabled="false" />
                                </ItemTemplate>
                            </asp:TemplateField>
                          <asp:TemplateField HeaderText="Quarter 3">
                                <EditItemTemplate>
                                    <asp:CheckBox ID="CheckBox3" runat="server" Enabled="true" />
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:CheckBox ID="CheckBox3" runat="server" Enabled="false" />
                                </ItemTemplate>
                            </asp:TemplateField>
                          <asp:TemplateField HeaderText="Quarter 4">
                                <EditItemTemplate>
                                    <asp:CheckBox ID="CheckBox4" runat="server" Enabled="true" />
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:CheckBox ID="CheckBox4" runat="server" Enabled="false" />
                                </ItemTemplate>
                            </asp:TemplateField>
                          <asp:TemplateField HeaderText="Bi-Annual 1">
                                <EditItemTemplate>
                                    <asp:CheckBox ID="CheckBox5" runat="server" Enabled="true" />
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:CheckBox ID="CheckBox5" runat="server" Enabled="false" />
                                </ItemTemplate>
                            </asp:TemplateField>
                          <asp:TemplateField HeaderText="Bi-Annual 2">
                                <EditItemTemplate>
                                    <asp:CheckBox ID="CheckBox6" runat="server" Enabled="true" />
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:CheckBox ID="CheckBox6" runat="server" Enabled="false" />
                                </ItemTemplate>
                            </asp:TemplateField>
                          <asp:CommandField ShowEditButton="true" ButtonType="Link" />
                            <asp:CommandField ShowDeleteButton="true" ButtonType="Link" />
                      </Columns>
                  </asp:GridView>
                </div>

              <div style="margin-bottom:10px;">
                  <asp:Button ID="SavePeriodToDbBtn" runat="server" 
                        Text="Save Report Period(s) and Close" OnClick="SavePeriodToDbBtn_Click"
                      CssClass="btn btn-default btn-warning" Visible="false" />
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

    <!-- Disaggregate Modal -->
    <div id="disaggragateModal" class="modal fade" role="dialog">
      <div class="modal-dialog modal-lg">
        <!-- Modal content-->
        <div class="modal-content">
          <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal">&times;</button>
            <h4 class="modal-title">Review the disaggregation levels for this indicator.</h4>
          </div>
          <div class="modal-body">

              <asp:Panel ID="Panel2" runat="server">
                  <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                    <ContentTemplate>

                        <div style="margin-bottom:10px;">
                             <asp:Label ID="IndicatorLabel" runat="server"></asp:Label>
                             <asp:HiddenField ID="IndicatorIDHiddenField" runat="server" />
                         </div>
                        <hr />

                        <%--<div style="margin-bottom: 10px">
                            <asp:Label ID="Label11" runat="server" Text="Add a new disaggregation level" AssociatedControlID="DisaggregationTxBx"></asp:Label>
                            <div>
                                <asp:TextBox ID="DisaggregationTxBx" runat="server"></asp:TextBox>
                            </div>
                        </div>
                        <div style="margin-bottom: 10px">
                            <div>
                                <asp:Button ID="SaveDisaggregationButton" runat="server" Text="Save Disaggregation"
                                OnClick="SaveDisaggregationButton_Click" />
                            </div>
                        </div>--%>

                        <div style="margin-bottom:10px;">
                            <asp:Label ID="Label11" runat="server" Text="Enter First Disaggregation Level" 
                                AssociatedControlID="Disaggregation1DropDown"></asp:Label>
                            <div>
                                <asp:LinqDataSource ID="LinqDataSource5" runat="server"
                                    ContextTypeName="WebFormsIdentity.Data_Access.WebFormsIdentityDatabaseEntities"
                                    EntityTypeName="" Select="new (id, disaggregation_name)"
                                    TableName="disaggregations" Where="disaggregation_id == null">
                                </asp:LinqDataSource>
                                <asp:DropDownList ID="Disaggregation1DropDown" runat="server" AutoPostBack="true" DataSourceID="LinqDataSource5" 
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
                                <asp:LinqDataSource ID="LinqDataSource6" runat="server"
                                    ContextTypeName="WebFormsIdentity.Data_Access.WebFormsIdentityDatabaseEntities"
                                    EntityTypeName="" Select="new (id, disaggregation_name)"
                                    TableName="disaggregations">
                                </asp:LinqDataSource>

                                <asp:DropDownList ID="Disaggregation2DropDown" runat="server" AutoPostBack="true" DataSourceID="LinqDataSource6" 
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
                                <asp:LinqDataSource ID="LinqDataSource7" runat="server"
                                    ContextTypeName="WebFormsIdentity.Data_Access.WebFormsIdentityDatabaseEntities"
                                    EntityTypeName="" Select="new (id, disaggregation_name)"
                                    TableName="disaggregations">
                                </asp:LinqDataSource>

                                <asp:DropDownList ID="Disaggregation3DropDown" runat="server" AutoPostBack="true" DataSourceID="LinqDataSource7" 
                                    AppendDataBoundItems="false" OnSelectedIndexChanged="Disaggregation3DropDown_SelectedIndexChanged"
                                    DataTextField="disaggregation_name" DataValueField="id" OnDataBound="Disaggregation3DropDown_DataBound">
                                </asp:DropDownList>
                                <asp:HiddenField ID="disaglvl3field" runat="server" />
                            </div>
                        </div>
                        <div style="margin-bottom:10px;">
                            <div>
                                <asp:Button ID="SaveDisaggregationButton" runat="server" Text="Save Disaggregation"
                                OnClick="SaveDisaggregationButton_Click" />
                            </div>
                        </div>

                        <hr />

                        <ef:EntityDataSource ID="EntityDataSource3" runat="server"
                            DefaultContainerName="WebFormsIdentityDatabaseEntities"
                            ConnectionString="name=WebFormsIdentityDatabaseEntities"
                            EnableFlattening="false" EntitySetName="project_indicator_disaggregation"
                            Include="partner_indicators"
                            AutoGenerateWhereClause="true" EnableDelete="true" EnableUpdate="true">
                            <WhereParameters>
                                <asp:Parameter Name="project_indicator_id" Type="Int64" />
                            </WhereParameters>
                        </ef:EntityDataSource>

                        <asp:GridView ID="DisaggragationView" runat="server" 
                            DataSourceID="EntityDataSource3" AutoGenerateColumns="false"
                            OnRowDataBound="DisaggragationView_RowDataBound"
                            CssClass="table table-hover table-bordered table-condensed"
                            DataKeyNames="id">
                            <EmptyDataRowStyle backcolor="LightBlue" forecolor="Red"/>
                            <HeaderStyle BackColor="Tan" Font-Bold="True" />
                            <EmptyDataTemplate>
                                <asp:Label ID="EmptyDataLabel" runat="server"></asp:Label>
                            </EmptyDataTemplate>
                            <Columns>
                                <asp:TemplateField HeaderText="Disaggregation">
                                <ItemTemplate>
                                    <asp:Label ID="Label10" runat="server" Text='<%# Bind("disaggregation_id") %>'></asp:Label>
                                </ItemTemplate>
                                <%--<EditItemTemplate>
                                    <asp:TextBox ID="DisaggregationTxBx" runat="server" Text='<%# Bind("disaggregation_id") %>'></asp:TextBox>
                                </EditItemTemplate>--%>
                                </asp:TemplateField>
                                <%--<asp:CommandField ShowEditButton="true" ButtonType="Link" />--%>
                                <asp:CommandField ShowDeleteButton="true" ButtonType="Link" />
                            </Columns>
                        </asp:GridView>

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

    <div class="modal fade" id="newDisaggModal" role="dialog">
        <div class="modal-dialog">
          <div class="modal-content">
            <div class="modal-header" style="background-color:forestgreen;">
              <button type="button" class="close" data-dismiss="modal">&times;</button>
              <h4 class="modal-title">New Disaggregation Level</h4>
            </div>
            <div class="modal-body">

                <asp:Panel ID="Panel3" runat="server">
                <asp:UpdatePanel ID="UpdatePanel3" runat="server">
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

    <%--Alert Modal--%>
    <div class="modal fade" id="alertModal" role="dialog">
    <div class="modal-dialog modal-sm">
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal">&times;</button>
          <h4 class="modal-title">Alert</h4>
        </div>
        <div class="modal-body">
              <asp:Label ID="MsgLabel" runat="server">Saved!</asp:Label>
        </div>
        <div class="modal-footer">
            <asp:Button ID="okButton" runat="server" Text="OK"  
                class="btn btn-default" OnClick="okButton_Click" />
        </div>
      </div>
    </div>
  </div>

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

        /*$("[src*=plus]").live("click", function () {
            $(this).closest("tr").after("<tr><td></td><td colspan = '999'>" + $(this).next().html() + "</td></tr>")
            $(this).attr("src", "/images/minus.png");
        });
        $("[src*=minus]").live("click", function () {
            $(this).attr("src", "/images/plus.png");
            $(this).closest("tr").next().remove();
        });*/

        
    </script>

</asp:Content>
