<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ReportControl.ascx.cs" 
    Inherits="WebFormsIdentity.Report_Control.ReportControl" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>

<ef:EntityDataSource ID="EntityDataSource1" runat="server"
    DefaultContainerName="WebFormsIdentityDatabaseEntities"
    ConnectionString="name=WebFormsIdentityDatabaseEntities"
    EnableFlattening="false" EntitySetName="partner_indicator_results"
    Include="indicator_report_planner.partner_indicators"
    AutoGenerateWhereClause="true" EnableDelete="true" EnableUpdate="true">
    <WhereParameters>
        <asp:Parameter Name="partner_report_id" Type="Int64" />
    </WhereParameters>
</ef:EntityDataSource>

<ef:EntityDataSource ID="EntityDataSource2" runat="server"
    DefaultContainerName="WebFormsIdentityDatabaseEntities"
    ConnectionString="name=WebFormsIdentityDatabaseEntities"
    EnableFlattening="false" EntitySetName="partner_challenges"
    AutoGenerateWhereClause="true" EnableDelete="true" EnableUpdate="true">
    <WhereParameters>
        <asp:Parameter Name="partner_report_id" Type="Int64" />
    </WhereParameters>
</ef:EntityDataSource>
<asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

<%--<div class="well">Basic Well</div>--%>

<div class="panel-group" id="accordion">
  <div class="panel panel-default">
    <div id="n1_heading" runat="server" class="panel-heading" style="background-color:orangered">
      <h4 class="panel-title">
        <a data-toggle="collapse" data-parent="#accordion" href="#collapse1">
        Achievements for the quarter</a>
      </h4>
    </div>
    <div id="collapse1" class="panel-collapse collapse in">
      <div class="panel-body">
        <asp:Label runat="server" AssociatedControlID="ca_text">
          Instructions
          <br /><br />
          For each of this projects objectives, provide a <b>detailed</b> indication of the 
          progress made towards their achievement. Indicate what activities were implemented 
          that addresses each of these objectives.
          <br /><br /></asp:Label>
        <textarea class="form-control" id="ca_text" runat="server" 
              placeholder="Type in your achievements for this quarter" rows="15"></textarea>
            <br />
                  <asp:Table ID="Table1" runat="server" style="border-collapse:separate; border-spacing:20px 10px;">
                      <asp:TableRow>
                          <asp:TableCell ID="achievementsLink" runat="server" Visible="false">
                              <asp:HyperLink ID="achievementsHyperLink" runat="server">Download</asp:HyperLink>
                          </asp:TableCell>
                          <asp:TableCell ID="achievementsRemoveLink" runat="server" Visible="false">
                              <asp:LinkButton ID="achievementsRemoveButton" runat="server" 
                                  OnClick="achievementsRemoveButton_Click">Remove Attachment</asp:LinkButton>
                          </asp:TableCell>
                          <asp:TableCell>
                              <asp:FileUpload ID="achievementsFileUpload" runat="server" AllowMultiple="false" />
                          </asp:TableCell>
                      </asp:TableRow>
                  </asp:Table>
            <br />
         <asp:Button ID="SaveAchievements" runat="server" Text="Save Achievements" 
             class="btn btn-info" OnClick="SaveAchievements_Click" OnClientClick="ShowProgress()" />
      </div>
    </div>
  </div>
 
    <div class="panel panel-default">
    <div id="n2_heading" runat="server" class="panel-heading" style="background-color:orangered">
      <h4 class="panel-title">
        <a data-toggle="collapse" data-parent="#accordion" href="#collapse2">
        Indicator Results</a>
      </h4>
    </div>
    <div id="collapse2" class="panel-collapse collapse">
      <div class="panel-body">
          <div style="margin-bottom:10px;">
              <asp:Button ID="RefreshBtn" runat="server" Text="Refresh Indicators" 
                  CssClass="btn btn-default" OnClientClick="ShowProgress()" OnClick="RefreshBtn_Click" />
          </div>
        <div class="table-responsive">
            <asp:GridView ID="ResultsGridView" runat="server" DataSourceID="EntityDataSource1"
                CssClass="table table-hover table-bordered" AutoGenerateColumns="false"
                DataKeyNames="partner_indicator_result_id" OnRowCommand="ResultsGridView_RowCommand"
                OnRowDataBound="ResultsGridView_RowDataBound">
                <HeaderStyle BackColor="Tan" Font-Bold="True" />
                <EmptyDataRowStyle backcolor="LightBlue" forecolor="Red"/>
                <EmptyDataTemplate>
                    <asp:Label ID="EmptyDataLabel" runat="server"></asp:Label>
                </EmptyDataTemplate>
                <Columns>
                    <asp:TemplateField Visible="false">
                        <ItemTemplate>
                            <asp:Label ID="Label9" runat="server" Text='<%# Eval("partner_indicator_result_id") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Indicator">
                        <ItemTemplate>
                            <asp:Label ID="Label1" runat="server" Text='<%# Eval("indicator_report_planner.partner_indicators.indicator") %>'></asp:Label>
                        </ItemTemplate>
                        <EditItemTemplate>

                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Result">
                        <ItemTemplate>
                            <asp:Label ID="Label2" runat="server" Text='<%# Bind("result") %>'></asp:Label>
                        </ItemTemplate>
                        <EditItemTemplate>

                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Comment">
                        <ItemTemplate>
                            <%--<asp:Label ID="Label3" runat="server" Text='<%# Eval("comment") + " " + Eval("disaggregation") %>'></asp:Label>--%>
                            <asp:Label ID="Label3" runat="server" Text='<%# Eval("comment") %>'></asp:Label>
                            <asp:Label Visible="false" ID="Label10" runat="server"></asp:Label>
                        </ItemTemplate>
                        <EditItemTemplate>

                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Attachment">
                        <ItemTemplate>
                            <asp:HyperLink ID="IndicatorAttachmentLink" runat="server" 
                                Text="Link" Visible="false"></asp:HyperLink>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:ButtonField CommandName="giveResults" ButtonType="Link" Text="Edit" />
                </Columns>
            </asp:GridView>
        </div>
      </div>
    </div>
  </div>

    <div class="panel panel-default">
        <div id="n7_heading" runat="server" class="panel-heading" style="background-color:orangered">
          <h4 class="panel-title">
            <a data-toggle="collapse" data-parent="#accordion" href="#collapse7">
            Project Risk Monitoring</a>
          </h4>
        </div>
        <div id="collapse7" class="panel-collapse collapse">
            <div class="panel-body">Please provide information that will help your organization 
                and FSD Africa’s line staff to determine the risk outlook of this project.
              <br /><br />
                <ef:EntityDataSource ID="EntityDataSource4" runat="server"
                    DefaultContainerName="WebFormsIdentityDatabaseEntities"
                    ConnectionString="name=WebFormsIdentityDatabaseEntities"
                    EnableFlattening="false" EntitySetName="project_risk_report"
                    AutoGenerateWhereClause="true" EnableDelete="true" EnableUpdate="true"
                    EnableInsert="true" Include="project_risk">
                    <WhereParameters>
                        <asp:Parameter Name="partner_report_id" Type="Int64" />
                    </WhereParameters>
                </ef:EntityDataSource>

                <asp:GridView ID="RiskGridView" runat="server" DataSourceID="EntityDataSource4"
                    AutoGenerateColumns="false" CssClass="table table-hover table-bordered" 
                    DataKeyNames="project_risk_id" OnRowEditing="RiskGridView_RowEditing"
                    OnRowUpdating="RiskGridView_RowUpdating" OnRowDataBound="RiskGridView_RowDataBound"
                    OnPreRender="RiskGridView_PreRender">
                    <HeaderStyle BackColor="Tan" Font-Bold="True" />
                    <EmptyDataRowStyle backcolor="LightBlue" forecolor="Red"/>
                    <EmptyDataTemplate>
                        <asp:Label ID="Label2" runat="server" Text="There is no risk to show"></asp:Label>
                    </EmptyDataTemplate>
                    <Columns>
                        <asp:TemplateField Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="RiskIdLabel" runat="server" Text='<%# Eval("project_risk_id") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Risk" SortExpression="project_risk_id">
                            <ItemTemplate>
                                <asp:Label runat="server" Text='<%# Eval("project_risk.risk") %>' ID="Label1"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Response (Yes/No)">
                            <ItemTemplate>
                                <asp:Label ID="Label12" runat="server" Text='<%# Eval("response") %>'></asp:Label>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:DropDownList ID="ResponseDropDownList" runat="server" 
                                    SelectedValue='<%# Eval("response") %>'>
                                    <asp:ListItem Value="" Text=""></asp:ListItem>
                                    <asp:ListItem Value="no" Text="No" ></asp:ListItem>
                                    <asp:ListItem Value="yes" Text="Yes"></asp:ListItem>
                                </asp:DropDownList>
                            </EditItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Comment">
                            <ItemTemplate>
                                <asp:Label ID="Label13" runat="server" Text='<%# Eval("comment") %>'></asp:Label>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="CommentTextBox" runat="server" Width="300px" Height="70px" 
                                    TextMode="MultiLine" Text='<%# Eval("comment") %>'></asp:TextBox>
                            </EditItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Attachment">
                            <ItemTemplate>
                                <asp:HyperLink ID="RiskAttachmentLink" runat="server" Text="Link" Visible="false"></asp:HyperLink>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:FileUpload ID="RiskAttachmentFileUpload" runat="server" AllowMultiple="false" />
                                <br />
                                <asp:LinkButton ID="DelRiskAttachBtn" runat="server" Visible="false" OnClick="DelRiskAttachBtn_Click">Remove Attachment</asp:LinkButton>
                            </EditItemTemplate>
                        </asp:TemplateField>
                        <asp:CommandField ShowEditButton="true" ButtonType="Link" />
                    </Columns>
                </asp:GridView>

            </div>
        </div>
    </div>
    
    <div class="panel panel-default">
    <div id="n3_heading" runat="server" class="panel-heading" style="background-color:orangered">
      <h4 class="panel-title">
        <a data-toggle="collapse" data-parent="#accordion" href="#collapse3">
        Challenges Faced</a>
      </h4>
    </div>
    <div id="collapse3" class="panel-collapse collapse">
      <div class="panel-body">
          <asp:Label runat="server" AssociatedControlID="challangesForm">
          Describe the key challenges faced and how they influenced the 
          implementation of the project. Include a discussion of how these challenges 
          were mitigated.
          <br /><br />
            </asp:Label>
          
          <asp:PlaceHolder runat="server" ID="challangesForm">
              <div style="margin-bottom: 10px">
                <asp:Label runat="server" AssociatedControlID="challengeTxt">Challenge</asp:Label>
                <div>
                    <textarea class="form-control" id="challengeTxt" runat="server" cols="20" rows="2"
                        placeholder="Challenge"></textarea>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" 
                        ErrorMessage="**" ForeColor="Red" ValidationGroup="ch" 
                        ControlToValidate="challengeTxt"></asp:RequiredFieldValidator>
                </div>
            </div>
              <div style="margin-bottom:10px">
                  <asp:Label runat="server" AssociatedControlID="effectTxt">Effect on Project Implementation</asp:Label>
                  <div>
                      <textarea class="form-control" runat="server" id="effectTxt" cols="20" rows="2"
                          placeholder="Effect on Project Implementation"></textarea>
                      <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" 
                          ErrorMessage="**" ForeColor="Red" ValidationGroup="ch"
                          ControlToValidate="effectTxt"></asp:RequiredFieldValidator>
                  </div>
              </div>
              <div style="margin-bottom:10px">
                  <asp:Label runat="server" AssociatedControlID="mitigativeTxt">Mitigative Strategy</asp:Label>
                  <div>
                      <textarea class="form-control" runat="server" id="mitigativeTxt" cols="20" rows="2"
                          placeholder="Mitigative Strategies"></textarea>
                      <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" 
                          ErrorMessage="**" ForeColor="Red" ValidationGroup="ch"
                          ControlToValidate="mitigativeTxt"></asp:RequiredFieldValidator>
                  </div>
              </div>
              <div style="margin-bottom:10px">
                  <asp:Label ID="Label14" runat="server" Text="Upload Attachment"></asp:Label>
                  <div>
                      <asp:FileUpload ID="ChallengesFileUpload" runat="server" AllowMultiple="false" />
                  </div>
              </div>
              <div style="margin-bottom:10px">
                  <div>
                      <asp:Button ID="SaveChallengesBtn" runat="server" Text="Save Challenges"
                          class="btn btn-info" OnClientClick="if(Page_ClientValidate()) ShowProgress();" 
                          OnClick="SaveChallengesBtn_Click" ValidationGroup="ch" />
                  </div>
              </div>
        </asp:PlaceHolder>
          <br /><br />
          
          <asp:GridView ID="ChallengesGridView" runat="server" DataSourceID="EntityDataSource2"
              CssClass="table table-hover table-bordered" OnDataBound="ChallengesGridView_DataBound"
              DataKeyNames="challenge_id" AutoGenerateColumns="false" 
              OnRowDeleting="ChallengesGridView_RowDeleting" OnRowDataBound="ChallengesGridView_RowDataBound">
              <HeaderStyle BackColor="Tan" Font-Bold="True" />
              <EmptyDataRowStyle BackColor="LightBlue" ForeColor="Red" />
              <EmptyDataTemplate>
                  No Challenges Have Been Listed!
              </EmptyDataTemplate>
              <Columns>
                  <asp:TemplateField Visible="false">
                      <ItemTemplate>
                          <asp:Label ID="ChallengeIDLabel" runat="server" Text='<%# Bind("challenge_id") %>'></asp:Label>
                      </ItemTemplate>
                  </asp:TemplateField>
                  <asp:TemplateField HeaderText="Challenge">
                      <ItemTemplate>
                          <asp:Label ID="Label5" runat="server" Text='<%# Bind("challenge") %>'></asp:Label>
                      </ItemTemplate>
                      <EditItemTemplate>
                          <asp:TextBox ID="TextBox1" runat="server" Text='<%# Bind("challenge") %>' 
                              Rows="5" Columns="30" TextMode="MultiLine"></asp:TextBox>
                      </EditItemTemplate>
                  </asp:TemplateField>
                  <asp:TemplateField HeaderText="Effect On Implementation">
                      <ItemTemplate>
                          <asp:Label ID="Label6" runat="server" Text='<%# Bind("effect_on_implementation") %>'></asp:Label>
                      </ItemTemplate>
                      <EditItemTemplate>
                          <asp:TextBox ID="TextBox2" runat="server" Text='<%# Bind("effect_on_implementation") %>'
                              Rows="5" Columns="30" TextMode="MultiLine"></asp:TextBox>
                      </EditItemTemplate>
                  </asp:TemplateField>
                  <asp:TemplateField HeaderText="Mitigative Strategy">
                      <ItemTemplate>
                          <asp:Label ID="Label7" runat="server" Text='<%# Bind("mitigative_strategy") %>'></asp:Label>
                      </ItemTemplate>
                      <EditItemTemplate>
                          <asp:TextBox ID="TextBox3" runat="server" Text='<%# Bind("mitigative_strategy") %>'
                              Rows="5" Columns="30" TextMode="MultiLine"></asp:TextBox>
                      </EditItemTemplate>
                  </asp:TemplateField>
                  <asp:TemplateField HeaderText="Attachment">
                      <ItemTemplate>
                          <asp:HyperLink ID="uploadLink" runat="server" Visible="false" Text="Link"></asp:HyperLink>
                      </ItemTemplate>
                  </asp:TemplateField>
                  <asp:CommandField ShowEditButton="true" ButtonType="Link" />
                  <asp:CommandField ShowDeleteButton="true" ButtonType="Link" />
              </Columns>
          </asp:GridView>
      </div>
    </div>
  </div>
                  

  <div class="panel panel-default">
    <div id="n4_heading" runat="server" class="panel-heading" style="background-color:orangered">
      <h4 class="panel-title">
        <a data-toggle="collapse" data-parent="#accordion" href="#collapse4">
        Lessons Learned</a>
      </h4>
    </div>
    <div id="collapse4" class="panel-collapse collapse">
      <div class="panel-body">
          <asp:Label runat="server" AssociatedControlID="ll_text">
          As you reflect on the experiences and achievements of the project, 
          indicate the knowledge you have generated that <br />
              (i) Enhances understanding of market dynamics and behavioural change and 
              can influence the performance of similar/future interventions, <br />
              (ii) Improve future programming/functions within your institution, within FSDA, 
              and can potentially be borrowed by other organisations 
              implementing similar projects.
        <br /><br />
          </asp:Label>
        <textarea class="form-control" id="ll_text" runat="server" 
            placeholder="Type in your lessons learned for this quarter" rows="5"></textarea>
        <br />
          <asp:Table ID="Table2" runat="server" style="border-collapse:separate; border-spacing:20px 10px;">
            <asp:TableRow>
                <asp:TableCell ID="TableCell1" runat="server" Visible="false">
                    <asp:HyperLink ID="lessonsLearnedHyperLink" runat="server">Download</asp:HyperLink>
                </asp:TableCell>
                <asp:TableCell ID="TableCell2" runat="server" Visible="false">
                    <asp:LinkButton ID="lessonsRemoveButton" runat="server" 
                        OnClick="lessonsRemoveButton_Click">Remove Attachment</asp:LinkButton>
                </asp:TableCell>
                <asp:TableCell>
                    <asp:FileUpload ID="lessonsLearnedFileUpload" runat="server" AllowMultiple="false" />
                </asp:TableCell>
            </asp:TableRow>
        </asp:Table>
          <br />
        <asp:Button ID="SaveLlBtn" runat="server" Text="Save Lessons Learned"
            class="btn btn-info" OnClientClick="ShowProgress()" OnClick="SaveLlBtn_Click" />

        </div>
    </div>
  </div>

    <div class="panel panel-default">
    <div id="n5_heading" runat="server" class="panel-heading" style="background-color:orangered">
      <h4 class="panel-title">
        <a data-toggle="collapse" data-parent="#accordion" href="#collapse5">
        Next Steps</a>
      </h4>
    </div>
    <div id="collapse5" class="panel-collapse collapse">
      <div class="panel-body">
          <asp:Label runat="server" AssociatedControlID="nextSteps_text">
          Provide a highlight of the activities you plan to 
          implement in the next reporting period.
          <br /><br />
          </asp:Label>
        <textarea id="nextSteps_text" runat="server" class="form-control"
            placeholder="Type in your next steps for the coming quarter" rows="5"></textarea>
        <br />
          <asp:Table ID="Table3" runat="server" style="border-collapse:separate; border-spacing:20px 10px;">
            <asp:TableRow>
                <asp:TableCell ID="TableCell3" runat="server" Visible="false">
                    <asp:HyperLink ID="nexStepsHyperLink" runat="server">Download</asp:HyperLink>
                </asp:TableCell>
                <asp:TableCell ID="TableCell4" runat="server" Visible="false">
                    <asp:LinkButton ID="nextStepsRemoveButton" runat="server" 
                        OnClick="nextStepsRemoveButton_Click">Remove Attachment</asp:LinkButton>
                </asp:TableCell>
                <asp:TableCell>
                    <asp:FileUpload ID="nextStepsFileUpload" runat="server" AllowMultiple="false" />
                </asp:TableCell>
            </asp:TableRow>
        </asp:Table>
          <br />
        <asp:Button ID="SaveNextStepsBtn" runat="server" Text="Save Next Steps"
            class="btn btn-info" OnClientClick-="ShowProgress()" OnClick="SaveNextStepsBtn_Click" />

      </div>
    </div>
  </div>

    <div class="panel panel-default">
    <div id="finSum_heading" runat="server" class="panel-heading" style="background-color:orangered">
      <h4 class="panel-title">
        <a data-toggle="collapse" data-parent="#accordion" href="#collapse8">
        Cumulative Financial Summary</a>
      </h4>
    </div>
    <div id="collapse8" class="panel-collapse collapse">
      <div class="panel-body">

          <table style="border-collapse:separate; border-spacing:20px 10px; margin-left:auto;margin-right:auto;">
              <tr>
                  <td>Cumulative Expenditure</td>
                  <td>
                      <asp:TextBox ID="ExpenditureTextBox" runat="server"></asp:TextBox>
                  </td>
                  <td>
                      <asp:RegularExpressionValidator ID="REV1" runat="server" ErrorMessage="Wrong Value"
                          ForeColor="Red" ValidationGroup="fs" ControlToValidate="ExpenditureTextBox"
                          ValidationExpression="[\d]{1,9}([.][\d]{1,2})?"></asp:RegularExpressionValidator>
                      <asp:RequiredFieldValidator ID="RFV8" runat="server" ErrorMessage="Required" ForeColor="Red"
                          SetFocusOnError="true" ControlToValidate="ExpenditureTextBox" ValidationGroup="fs"></asp:RequiredFieldValidator>
                  </td>
              </tr>
              <tr>
                  <td>Project Budget</td>
                  <td>
                      <asp:TextBox ID="ProjectBudgetTxBx" runat="server" ReadOnly="true"></asp:TextBox>
                  </td>
              </tr>
              <tr>
                  <td>% Delivery against Project Budget</td>
                  <td>
                      <asp:TextBox ID="DeliveryTextBox" runat="server" ReadOnly="true"></asp:TextBox>
                  </td>
              </tr>
              <tr id="uploadFinExp" runat="server">
                  <td>
                      <asp:Label ID="Label18" runat="server">Upload the financial expenditure for the quarter</asp:Label>
                  </td>
                  <td>
                      <asp:FileUpload ID="CFSUpload" runat="server" AllowMultiple="false" />
                  </td>
              </tr>
              <tr id="uploadedFinExp" runat="server">
                  <td>
                      <asp:Label ID="Label15" runat="server">Uploaded Financial Expenditure</asp:Label>
                  </td>
                  <td>
                      <asp:HyperLink ID="FinExpHyperLink" runat="server">Download</asp:HyperLink>
                      <br />
                      <asp:LinkButton ID="FinExpAttachmentRemoveButton" runat="server" 
                          OnClick="FinExpAttachmentRemoveButton_Click">Remove Attachment</asp:LinkButton>
                  </td>
              </tr>
              <tr>
                  <td></td>
                  <td>
                      <asp:Button ID="SaveFSButton" runat="server" Text="Save" CssClass="btn-info btn"
                          OnClientClick="if(Page_ClientValidate()) ShowProgress();" OnClick="SaveFSButton_Click" ValidationGroup="fs" />
                  </td>
              </tr>
          </table>
          <%--<hr />
          <div style="width:500px; margin:0px auto">
              <div style="margin-bottom:10px;">
                <asp:Label ID="Label16" runat="server" AssociatedControlID="">Insert a caption for the upload(s) below</asp:Label>
                  <div>
                      <asp:TextBox ID="TextBox4" runat="server" TextMode="MultiLine" Width="500px"></asp:TextBox>
                  </div>
              </div>
              <div style="margin-bottom:10px;">
                <asp:Label ID="Label15" runat="server" AssociatedControlID="CFSUpload">Upload the financial expenditure for the quarter</asp:Label>
                  <div>
                      <asp:FileUpload ID="CFSUpload" runat="server" AllowMultiple="true" />
                  </div>
              </div>
              <div style="margin-bottom:10px;">
                  <asp:Button ID="Button1" runat="server" Text="Upload" CssClass="btn btn-info" />
              </div>
          </div>--%>

        </div>
    </div>
    </div>

    <div class="panel panel-default">
    <div id="n6_heading" runat="server" class="panel-heading" style="background-color:orangered">
      <h4 class="panel-title">
        <a data-toggle="collapse" data-parent="#accordion" href="#collapse6">
        Overall assessment and conclusion</a>
      </h4>
    </div>
    <div id="collapse6" class="panel-collapse collapse">
      <div class="panel-body">Provide summary thoughts 
          on the performance of the project against set targets.
          <br /><br />

            <div style="margin-bottom:10px">
                <asp:Label runat="server" AssociatedControlID="RatingList">Rating (tick as is appropriate)</asp:Label>
                <div>
                    <ef:EntityDataSource ID="EntityDataSource3" runat="server"
                        DefaultContainerName="WebFormsIdentityDatabaseEntities"
                        ConnectionString="name=WebFormsIdentityDatabaseEntities"
                        EnableFlattening="false" EntitySetName="project_rating">
                    </ef:EntityDataSource>
                    <asp:RadioButtonList ID="RatingList" runat="server" 
                        DataSourceID="EntityDataSource3" 
                        DataValueField="rating_id" DataTextField="rating"></asp:RadioButtonList>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" 
                        ErrorMessage="**" ForeColor="Red" ValidationGroup="rtng"
                        ControlToValidate="RatingList"></asp:RequiredFieldValidator>
                </div>
            </div>
          <div style="margin-bottom:10px">
              <asp:Label runat="server" AssociatedControlID="CommentaryText">Commentary</asp:Label>
              <div>
                  <textarea class="form-control" id="CommentaryText" runat="server" 
                      cols="20" rows="2" placeholder="Commentary"></textarea>
                  <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" 
                      ErrorMessage="**" ForeColor="Red" ValidationGroup="rtng"
                      ControlToValidate="CommentaryText"></asp:RequiredFieldValidator>
              </div>
          </div>
          <div style="margin-bottom:10px">
              <div>
                  <asp:Button ID="SaveAssBtn" runat="server" Text="Save Assessment and Conclusion" 
                      class="btn btn-info" OnClientClick="if(Page_ClientValidate()) ShowProgress();" 
                      OnClick="SaveAssBtn_Click" ValidationGroup="rtng" />
              </div>
          </div>

      </div>
    </div>
  </div>

    

    <asp:HiddenField ID="PaneName" runat="server" />
    <%--<asp:HiddenField ID="hfAccordionIndex" runat="server" />--%>
</div>


<!-- Results Modal -->
    <div id="resultsModal" class="modal fade" role="dialog">
      <div class="modal-dialog modal-lg">
        <!-- Modal content-->
        <div class="modal-content">
          <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal">&times;</button>
            <h4 class="modal-title">Give the results for this indicator, including its disaggregated results.</h4>
          </div>
          <div class="modal-body">
              <asp:Label ID="IndicatorLabel" runat="server" Text="Label"></asp:Label>
              <asp:HiddenField ID="IndicatorResultIDHiddenField" runat="server" />
              <hr />
                <div style="margin-bottom: 10px">
                    <asp:Label ID="Label11" runat="server" Text="Result" AssociatedControlID="ResultTxBx"></asp:Label>
                    <div>
                        <asp:TextBox ID="ResultTxBx" runat="server"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                            ErrorMessage="Required Field" ControlToValidate="ResultTxBx"
                            ValidationGroup="result" ForeColor="Red"></asp:RequiredFieldValidator>
                        <asp:CompareValidator ID="NumberResultValidator" runat="server" 
                            ErrorMessage="This must be a number" ForeColor="Red" 
                            ControlToValidate="ResultTxBx" Enabled="false"
                            ValidationGroup="result" Operator="DataTypeCheck" Type="Integer"></asp:CompareValidator>
                    </div>
                </div>
              <div style="margin-bottom:10px">
                  <asp:Label ID="Label4" runat="server" Text="Comment" 
                      AssociatedControlID="CommentTxBx"></asp:Label>
                  <div>
                      <asp:TextBox ID="CommentTxBx" runat="server" TextMode="MultiLine" Width="400px"></asp:TextBox>
                  </div>
              </div>
              <div style="margin-bottom:10px">
                  <asp:Label ID="Label17" runat="server" Text="Upload Attachment"></asp:Label>
                  <div>
                      <asp:FileUpload ID="IndicatorResultFileUpload" runat="server" AllowMultiple="false" />
                      <br />
                      <asp:LinkButton ID="RemoveIndicatorAttachBtn" runat="server" Visible="false"
                          OnClick="RemoveIndicatorAttachBtn_Click">Remove Attachment</asp:LinkButton>
                  </div>
              </div>

              <hr />
              <asp:Label ID="Label8" runat="server" Text="Disaggregated Results"></asp:Label>
              <hr />

              <asp:GridView ID="GridView1" runat="server"
                  AutoGenerateColumns="true"></asp:GridView>

              <asp:Repeater ID="DisaggregationRepeater" runat="server" OnItemDataBound="DisaggregationRepeater_ItemDataBound">
                  <ItemTemplate>
                      <asp:HiddenField ID="Disaggregation_Result_ID_HiddenField" runat="server" 
                          Value='<%# Bind("id") %>' />
                      <div style="margin-bottom:10px">
                          <asp:Label ID="Label4" runat="server" 
                              Text='<%# Eval("project_indicator_disaggregation.disaggregation.disaggregation_name") %>' 
                              AssociatedControlID="disagTxBx"></asp:Label>
                          <div>
                              <asp:TextBox ID="disagTxBx" runat="server" 
                                  Text='<%# Bind("disaggregation_result") %>'></asp:TextBox>
                              <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                                  ErrorMessage="Required Field" ControlToValidate="disagTxBx"
                                  ForeColor="Red" ValidationGroup="result"></asp:RequiredFieldValidator>
                          </div>
                      </div>
                  </ItemTemplate>
              </asp:Repeater>

              <asp:Button ID="SaveDataBtn" runat="server" Text="Save Result" CssClass="btn btn-default btn-info"
                  ValidationGroup="result" OnClick="SaveDataBtn_Click" />

          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-default" data-dismiss="modal">Exit</button>
          </div>
        </div>
      </div>
    </div>

<%--This is used for character limitation--%>
<script type="text/javascript">
    function validateLimit(obj, divID, maxchar) {
        objDiv = get_object(divID);
        if (this.id) obj = this;
        var remaningChar = maxchar - obj.value.length;
        if (objDiv) {
            objDiv.innerHTML = remaningChar + " characters left";
        }
        if (remaningChar <= 0) {
            obj.value = obj.value.substring(maxchar, 0);
            if (objDiv) {
                objDiv.innerHTML = "0 characters left";
            }
            return false;
        }
        else { return true; }
    }

    function get_object(id) {
        var object = null;
        if (document.layers) {
            object = document.layers[id];
        } else if (document.all) {
            object = document.all[id];
        } else if (document.getElementById) {
            object = document.getElementById(id);
        }
        return object;
    }
</script>

<%--This is used to show progress if there is a delay--%>
<div class="loading" style="margin:auto">
    Loading. Please wait.<br />
    <br />
    <img src="../images/loader.gif" alt="" />
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
</script>


<%--This script is used to re-open the currently opened panel on page postback--%>
<script type="text/javascript">
    $(function () {
        var paneName = $("[id*=PaneName]").val() != "" ? $("[id*=PaneName]").val() : "collapse1";
             
        //Remove the previous selected Pane.
        $("#accordion .in").removeClass("in");
             
        //Set the selected Pane.
        $("#" + paneName).collapse("show");
             
        //When Pane is clicked, save the ID to the Hidden Field.
        $(".panel-heading a").click(function () {
            $("[id*=PaneName]").val($(this).attr("href").replace("#", ""));
        });
    });
</script>
<%--<script type="text/javascript">
    $(document).ready(function () {
        var last = $('#<%= hfAccordionIndex.ClientID %>').val();
        if (last != null && last != "") {
            //remove default collapse settings
            $("#accordion .collapse").removeClass('in');
            //show the account_last visible group
            $("#" + last).collapse("show");
        }
    });

    //when a group is shown, save it as the active accordion group
    $("#accordion").on('shown', function () {
        var active = $("#accordion .in").attr('id');
        $('#<%= hfAccordionIndex.ClientID %>').val(active);
    });
</script>--%>