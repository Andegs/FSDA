using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebFormsIdentity.Data_Access;
using WebFormsIdentity.MRM.Project_Indicators;

namespace WebFormsIdentity.Report_Control
{
    public delegate void ReportHelper(int count);

    public partial class ReportControl : System.Web.UI.UserControl
    {
        /*public int RefImplementingPartner { get; set; }
        public int RefReportPeriod { get; set; }
        public int RefYear { get; set; }*/

        public event ReportHelper sendCount;

        public int ReportId { get; set; }

        int completeSections = 0;

        WebFormsIdentityDatabaseEntities db = new WebFormsIdentityDatabaseEntities();
        protected void Page_Load(object sender, EventArgs e)
        {
            /*IPLabel.Text = RefImplementingPartner.ToString();
            ReportPeriodLabel.Text = RefReportPeriod.ToString();
            YearLabel.Text = RefYear.ToString();*/

            //ReportIdLabel.Text = ReportId.ToString();
            
            if (!IsPostBack)
            {
                populateFinancialSummary(ReportId);

                populateAchievements(ReportId);

                populateLessonsLearned(ReportId);

                populateNextSteps(ReportId);

                //populateFinExp(ReportId);

                indicatorResultsSectionComplete();

                challengesCompletedSection();

                ProjectRatingCompleted();

                riskCompletedSection();

                EntityDataSource1.WhereParameters["partner_report_id"].DefaultValue = ReportId.ToString();
                EntityDataSource2.WhereParameters["partner_report_id"].DefaultValue = ReportId.ToString();
                EntityDataSource4.WhereParameters["partner_report_id"].DefaultValue = ReportId.ToString();
            }
            else if (this.IsPostBack)
            {
                PaneName.Value = Request.Form[PaneName.UniqueID];
                Page.MaintainScrollPositionOnPostBack = true;
            }
        }

        protected void populateFinancialSummary(int reportID)
        {
            //Populate the project budget section
            var projectBudget = (from data in db.partner_reports
                                 where data.partner_report_id == reportID
                                 select new
                                 {
                                     data.project.budget,
                                     data.project_id
                                 }).Single();
            if(projectBudget != null)
            {
                ProjectBudgetTxBx.Text = string.Format("{0:#,##0.00}", projectBudget.budget);
            }

            //Populate the financial expenditure attachment section
            var reportData = (from data in db.partner_reports
                              where data.partner_report_id == reportID
                              select data).FirstOrDefault();
            if (reportData != null)
            {
                if(!string.IsNullOrEmpty(reportData.cumulative_expenditure.ToString()))
                {
                    decimal delivery = decimal.Parse(((reportData.cumulative_expenditure / projectBudget.budget) * 100).ToString());

                    DeliveryTextBox.Text = Math.Round(delivery, 2).ToString() + "%";
                /*}

                if (!String.IsNullOrWhiteSpace(reportData.cumulative_expenditure.ToString()))
                {*/
                    finSum_heading.Style.Add("background-color", "chartreuse");
                    ExpenditureTextBox.Text = reportData.cumulative_expenditure.ToString().Trim();

                    /*if (string.IsNullOrEmpty(reportData.cumulative_expenditure_attachment))
                    {
                        uploadFinExp.Visible = true;
                        uploadedFinExp.Visible = false;
                    }
                    else
                    {*/
                        uploadFinExp.Visible = false;

                        uploadedFinExp.Visible = true;
                        FinExpAttachmentRemoveButton.CommandArgument = reportID.ToString();
                        FinExpHyperLink.NavigateUrl = "~/downloading.aspx?file=" + reportData.cumulative_expenditure_attachment.Trim();
                    //}

                    sendCount(completeSections++);
                }

                if(string.IsNullOrEmpty(reportData.cumulative_expenditure_attachment))
                {
                    finSum_heading.Style.Add("background-color", "orangered");

                    uploadFinExp.Visible = true;
                    uploadedFinExp.Visible = false;
                }
            }
        }

        protected void populateAchievements(int reportID)
        {
            var reportData = (from data in db.partner_reports
                              where data.partner_report_id == reportID
                              select data).FirstOrDefault();
            if(reportData != null)
            {
                if(!String.IsNullOrWhiteSpace(reportData.achievements))
                {
                    n1_heading.Style.Add("background-color", "chartreuse");
                    ca_text.Value = reportData.achievements.Trim();

                    if(!string.IsNullOrEmpty(reportData.achievements_attachment))
                    {
                        achievementsLink.Visible = true;
                        achievementsHyperLink.NavigateUrl = "~/downloading.aspx?file=" + reportData.achievements_attachment.Trim();

                        achievementsRemoveLink.Visible = true;
                        achievementsRemoveButton.CommandArgument = reportID.ToString();
                    }
                    else
                    {
                        achievementsLink.Visible = false;
                        achievementsRemoveLink.Visible = false;
                    }

                    try
                    {
                        sendCount(completeSections++);
                    }
                    catch(Exception ex)
                    {
                        throw new Exception();
                    }
                }
                else
                {
                    n1_heading.Style.Add("background-color", "orangered");
                }
            }
        }

        protected void SaveAchievements_Click(object sender, EventArgs e)
        {
            //string myScript = "$(document).ready(function () { $('[id*=SaveCA]').click(); });";
            //ScriptManager.RegisterStartupScript(this, GetType(), "load", myScript, true);

            //ScriptManager.RegisterStartupScript(this, GetType(), "load", "ShowProgress()", true);

            //The loading progress is working
            //System.Threading.Thread.Sleep(1000);

            partner_reports context = db.partner_reports.SingleOrDefault(
                data => data.partner_report_id == ReportId);

            context.achievements = ca_text.Value.Trim();

            //save the upload if it exists
            if (achievementsFileUpload.HasFile)
            {
                string myFolderPath = "~/Attachments/";
                string folderPath = Server.MapPath(myFolderPath);

                //check if the directory exists
                if(!Directory.Exists(folderPath))
                {
                    //If the directory does not exist. Create it.
                    Directory.CreateDirectory(folderPath);
                }

                //Save the file to the directory
                string myFileName = ReportId + "_Achievements_" + Path.GetFileName(achievementsFileUpload.FileName);

                //Check if the was a previous upload (for brevity)
                if(File.Exists(Server.MapPath(context.achievements_attachment)))
                {
                    //if it exists, delete it
                    File.Delete(Server.MapPath(context.achievements_attachment.Trim()));
                }
                achievementsFileUpload.SaveAs(folderPath + myFileName.Trim());

                //Save the path to the database
                context.achievements_attachment = myFileName;
            }

            db.SaveChanges();

            populateAchievements(ReportId);
        }

        protected void populateLessonsLearned(int reportID)
        {
            var reportData = (from data in db.partner_reports
                              where data.partner_report_id == reportID
                              select data).FirstOrDefault();
            if (reportData != null)
            {
                if (!String.IsNullOrWhiteSpace(reportData.lessons_learned))
                {
                    n4_heading.Style.Add("background-color", "chartreuse");
                    ll_text.Value = reportData.lessons_learned.Trim();

                    if (!string.IsNullOrEmpty(reportData.lessons_learned_attachment))
                    {
                        TableCell1.Visible = true;
                        lessonsLearnedHyperLink.NavigateUrl = "~/downloading.aspx?file=" + reportData.lessons_learned_attachment.Trim();

                        TableCell2.Visible = true;
                        lessonsRemoveButton.CommandArgument = reportID.ToString();
                    }
                    else
                    {
                        TableCell1.Visible = false;
                        TableCell2.Visible = false;
                    }

                    sendCount(completeSections++);
                }
                else
                {
                    n4_heading.Style.Add("background-color", "orangered");
                }
            }
        }

        protected void SaveLlBtn_Click(object sender, EventArgs e)
        {
            partner_reports context = db.partner_reports.SingleOrDefault(
                data => data.partner_report_id == ReportId);

            context.lessons_learned = ll_text.Value.Trim();

            //save the upload if it exists
            if (lessonsLearnedFileUpload.HasFile)
            {
                string myFolderPath = "~/Attachments/";
                string folderPath = Server.MapPath(myFolderPath);

                //check if the directory exists
                if (!Directory.Exists(folderPath))
                {
                    //If the directory does not exist. Create it.
                    Directory.CreateDirectory(folderPath);
                }

                //Save the file to the directory
                string myFileName = ReportId + "_LessonsLearned_" + Path.GetFileName(lessonsLearnedFileUpload.FileName);

                //Check if there was a previous upload (for brevity)
                if (File.Exists(Server.MapPath(context.lessons_learned_attachment)))
                {
                    //if it exists, delete it
                    File.Delete(Server.MapPath(context.lessons_learned_attachment.Trim()));
                }
                lessonsLearnedFileUpload.SaveAs(folderPath + myFileName.Trim());

                //Save the path to the database
                context.lessons_learned_attachment = myFileName;
            }

            db.SaveChanges();

            populateLessonsLearned(ReportId);
        }

        protected void populateNextSteps(int reportID)
        {
            var reportData = (from data in db.partner_reports
                              where data.partner_report_id == reportID
                              select data).FirstOrDefault();
            if (reportData != null)
            {
                if (!String.IsNullOrWhiteSpace(reportData.next_steps))
                {
                    n5_heading.Style.Add("background-color", "chartreuse");
                    nextSteps_text.Value = reportData.next_steps.Trim();

                    if (!string.IsNullOrEmpty(reportData.next_steps_attachment))
                    {
                        TableCell3.Visible = true;
                        nexStepsHyperLink.NavigateUrl = "~/downloading.aspx?file=" + reportData.next_steps_attachment.Trim();

                        TableCell4.Visible = true;
                        nextStepsRemoveButton.CommandArgument = reportID.ToString();
                    }
                    else
                    {
                        TableCell3.Visible = false;
                        TableCell4.Visible = false;
                    }

                    sendCount(completeSections++);
                }
                else
                {
                    n5_heading.Style.Add("background-color", "orangered");
                }
            }
        }

        protected void SaveNextStepsBtn_Click(object sender, EventArgs e)
        {
            partner_reports context = db.partner_reports.SingleOrDefault(
                data => data.partner_report_id == ReportId);

            context.next_steps = nextSteps_text.Value.Trim();

            //save the upload if it exists
            if (nextStepsFileUpload.HasFile)
            {
                string myFolderPath = "~/Attachments/";
                string folderPath = Server.MapPath(myFolderPath);

                //check if the directory exists
                if (!Directory.Exists(folderPath))
                {
                    //If the directory does not exist. Create it.
                    Directory.CreateDirectory(folderPath);
                }

                //Save the file to the directory
                string myFileName = ReportId + "_NextSteps_" + Path.GetFileName(nextStepsFileUpload.FileName);

                //Check if there was a previous upload (for brevity)
                if (File.Exists(Server.MapPath(context.next_steps_attachment)))
                {
                    //if it exists, delete it
                    File.Delete(Server.MapPath(context.next_steps_attachment.Trim()));
                }
                nextStepsFileUpload.SaveAs(folderPath + myFileName.Trim());

                //Save the path to the database
                context.next_steps_attachment = myFileName;
            }

            db.SaveChanges();

            populateNextSteps(ReportId);
        }

        protected void SaveFSButton_Click(object sender, EventArgs e)
        {
            decimal expenditure = decimal.Parse(ExpenditureTextBox.Text.Trim());
            decimal budget = decimal.Parse(ProjectBudgetTxBx.Text.Trim());

            decimal delivery = (expenditure / budget) * 100;

            DeliveryTextBox.Text = Math.Round(delivery, 2).ToString() + "%";

            partner_reports context = db.partner_reports.SingleOrDefault(
                data => data.partner_report_id == ReportId);

            context.cumulative_expenditure = expenditure;

            //save the upload if it exists
            if (CFSUpload.HasFile)
            {
                string myFolderPath = "~/Attachments/";
                string folderPath = Server.MapPath(myFolderPath);

                //check if the directory exists
                if (!Directory.Exists(folderPath))
                {
                    //If the directory does not exist. Create it.
                    Directory.CreateDirectory(folderPath);
                }

                //Save the file to the directory
                string myFileName = ReportId + "_FinansialSummary_" + Path.GetFileName(CFSUpload.FileName);

                //Check if there was a previous upload (for brevity)
                if (File.Exists(Server.MapPath(context.cumulative_expenditure_attachment)))
                {
                    //if it exists, delete it
                    File.Delete(Server.MapPath(context.cumulative_expenditure_attachment.Trim()));
                }
                CFSUpload.SaveAs(folderPath + myFileName.Trim());

                //Save the path to the database
                context.cumulative_expenditure_attachment = myFileName;
            }

            db.SaveChanges();

            populateFinancialSummary(ReportId);
        }

        protected void SaveChallengesBtn_Click(object sender, EventArgs e)
        {
            var reportDetails = (from data in db.partner_reports
                                 where data.partner_report_id == ReportId
                                 select new
                                 {
                                     data.project_id,
                                     data.report_period_id,
                                     data.year_id
                                 }).SingleOrDefault();

            //=====Add the challenges part of the report to the database========
            partner_challenges challenges = new partner_challenges();
            challenges.partner_report_id = ReportId;
            challenges.project_id = reportDetails.project_id;
            challenges.report_period_id = reportDetails.report_period_id;
            challenges.year_id = reportDetails.year_id;
            challenges.challenge = challengeTxt.Value.Trim();
            challenges.effect_on_implementation = effectTxt.Value.Trim();
            challenges.mitigative_strategy = mitigativeTxt.Value.Trim();

            string myFolderPath = "~/Attachments/";
            string folderPath = Server.MapPath(myFolderPath);
            if (ChallengesFileUpload.HasFile)
            {
                //Check if the directory exists
                if (!Directory.Exists(folderPath))
                {
                    //If the directory does not exist. Create it.
                    Directory.CreateDirectory(folderPath);
                }

                //Save the file to the directory
                string myFileName = ReportId +
                    "_Challenges_" +
                    Path.GetFileName(ChallengesFileUpload.FileName);

                ChallengesFileUpload.SaveAs(folderPath + myFileName);

                //Save the path to database
                challenges.attachment = myFileName;
            }

            db.partner_challenges.Add(challenges);

            if (db.SaveChanges() > 0)
            {
                db.SaveChanges();
                ChallengesGridView.DataBind();
            }
            challengesCompletedSection();
        }

        protected void challengesCompletedSection()
        {
            var challenges = (from data in db.partner_challenges
                              where data.partner_report_id == ReportId
                              select data);

            if(challenges.Count() > 0)
            {
                n3_heading.Style.Add("background-color", "chartreuse");

                sendCount(completeSections++);
            }
            else if(challenges.Count() == 0)
            {
                n3_heading.Style.Add("background-color", "orangered");
            }
        }

        protected void riskCompletedSection()
        {
            int i = 0;
            var risks = (from data in db.project_risk_report
                        where data.partner_report_id == ReportId
                        && (data.response == string.Empty || data.response == null)
                        && (data.comment == string.Empty || data.comment == null)
                        select data);

            foreach(var risk in risks)
            {
                if(risks != null)
                {
                    i++;
                }
            }

            if (i == 0)
            {

                n7_heading.Style.Add("background-color", "chartreuse");
            }
            else if(i > 0)
            {
                n7_heading.Style.Add("background-color", "orangered");
            }
        }

        protected void ResultsGridView_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            //Get the selected Row
            int currentRowIndex = Convert.ToInt32(e.CommandArgument);
            //GridViewRow row = GridView1.Rows[currentRowIndex];

            //Get the DataKey name values for the selected row
            int partnerIndicatorResultId = int.Parse(this.ResultsGridView.DataKeys[currentRowIndex].Values["partner_indicator_result_id"].ToString());

            //long reportID = (from data in db.partner_indicator_results
            //                 where data.partner_indicator_result_id == partnerIndicatorResultId
            //                 select data.partner_report_id).FirstOrDefault();

            if (e.CommandName == "giveResults")
            {
                IndicatorResultIDHiddenField.Value = partnerIndicatorResultId.ToString();

                var indicatorData = (from data in db.partner_indicator_results
                                       where data.partner_indicator_result_id == partnerIndicatorResultId
                                       select new
                                       {
                                           data.indicator_report_planner.partner_indicators.indicator,
                                           data.indicator_report_planner.partner_indicators.partner_indicator_id,
                                           data.indicator_report_planner.partner_indicators.indicator_type_id,
                                           data.partner_report_id,
                                           data.result,
                                           data.comment,
                                           data.attachment
                                       }).SingleOrDefault();

                if(indicatorData.indicator_type_id == 1)
                {
                    NumberResultValidator.Enabled = true;
                }
                else if(indicatorData.indicator_type_id != 1)
                {
                    NumberResultValidator.Enabled = false;
                }

                IndicatorLabel.Text = indicatorData.indicator;
                ResultTxBx.Text = indicatorData.result != null ? indicatorData.result.Trim() : string.Empty;
                CommentTxBx.Text = indicatorData.comment != null ? indicatorData.comment.Trim() : string.Empty;

                var disaggregatedData = from data in db.project_indicator_disaggregation_result
                                        where data.project_indicator_disaggregation.project_indicator_id == indicatorData.partner_indicator_id
                                        && data.partner_report_id == ReportId
                                        select data;

                GridView1.DataSource = disaggregatedData.ToList();
                //GridView1.DataBind();

                DisaggregationRepeater.DataSource = disaggregatedData.ToList();
                DisaggregationRepeater.DataBind();

                //If the result contains an attachement, give the option to just delete it
                if(!string.IsNullOrEmpty(indicatorData.attachment))
                {
                    RemoveIndicatorAttachBtn.Visible = true;
                    RemoveIndicatorAttachBtn.CommandArgument = partnerIndicatorResultId.ToString();
                }
                else
                {
                    RemoveIndicatorAttachBtn.Visible = false;
                    RemoveIndicatorAttachBtn.CommandArgument = string.Empty;
                }

                ScriptManager.RegisterStartupScript(
                    Page,
                    Page.GetType(),
                    "resultsModal", "$('#resultsModal').modal('show');",
                    true);
            }
        }

        protected void SaveDataBtn_Click(object sender, EventArgs e)
        {
            int indicatorResultID = int.Parse(IndicatorResultIDHiddenField.Value.Trim());
            string result = ResultTxBx.Text.Trim();
            string comment = CommentTxBx.Text.Trim();

            partner_indicator_results myResult = db.partner_indicator_results
                .Single(
                data => data.partner_indicator_result_id == indicatorResultID
                );

            //Save the result
            myResult.result = result;

            string myFolderPath = "~/Attachments/";
            string folderPath = Server.MapPath(myFolderPath);
            if (IndicatorResultFileUpload.HasFile)
            {
                //Check if the directory exists
                if (!Directory.Exists(folderPath))
                {
                    //If the directory does not exist. Create it.
                    Directory.CreateDirectory(folderPath);
                }

                //Save the file to the directory
                string myFileName = myResult.indicator_report_planner.partner_indicators.partner_indicator_id +
                    "_" + ReportId +
                    "_Indicator_" +
                    Path.GetFileName(IndicatorResultFileUpload.FileName);

                //Check if there was a previous upload
                if(File.Exists(Server.MapPath(myResult.attachment)))
                {
                    //If it exists delete it
                    File.Delete(Server.MapPath(myResult.attachment.Trim()));
                }

                IndicatorResultFileUpload.SaveAs(folderPath + myFileName.Trim());

                //Save the path to database
                myResult.attachment = myFileName;
            }

            //Save the disaggregations
            string combinedDisaggregations = string.Empty;
            foreach(RepeaterItem item in DisaggregationRepeater.Items)
            {
                HiddenField HF1 = item.FindControl("Disaggregation_Result_ID_HiddenField") as HiddenField;
                TextBox disagTxBx = item.FindControl("disagTxBx") as TextBox;

                int disagID = int.Parse(HF1.Value.Trim());
                string disag = disagTxBx.Text.Trim();

                //Fullproof the code not to deal with null strings
                if(!string.IsNullOrEmpty(disag))
                {
                    //Perform the insert operation from the repeater
                    project_indicator_disaggregation_result myDisagResult = db.project_indicator_disaggregation_result
                        .Single(
                        data => data.id == disagID
                        );

                    myDisagResult.disaggregation_result = disag;

                    combinedDisaggregations += myDisagResult.project_indicator_disaggregation.disaggregation.disaggregation_name
                        + " - [" + disag + "] ";
                }
            }
            
            //Save changes to the comment
            if(!string.IsNullOrEmpty(comment))
            {
                myResult.comment = comment;
            }
            else if(string.IsNullOrEmpty(comment))
            {
                myResult.comment = string.Empty;
            }

            if(!string.IsNullOrEmpty(combinedDisaggregations))
            {
                myResult.disaggregation = combinedDisaggregations;
            }

            if(db.SaveChanges() > 0 )
            {
                db.SaveChanges();
                ResultsGridView.DataBind();

                //Perform some clean up
                combinedDisaggregations = string.Empty;
            }
            indicatorResultsSectionComplete();
        }

        protected void indicatorResultsSectionComplete()
        {
            //Indicator to show section completedness
            int i = 0;
            var completedResults = from data in db.partner_indicator_results
                                   where data.partner_report_id == ReportId
                                   && (data.result == string.Empty || data.result == null)
                                   select data;

            foreach (var completedResult in completedResults)
            {
                if (completedResult != null)
                {
                    i++;
                }
            }

            if (i == 0)
            {
                n2_heading.Style.Add("background-color", "chartreuse");

                sendCount(completeSections++);
            }
            else if (i > 0)
            {
                n2_heading.Style.Add("background-color", "orangered");
            }
        }

        protected void ChallengesGridView_DataBound(object sender, EventArgs e)
        {
            challengesCompletedSection();
        }

        protected void SaveAssBtn_Click(object sender, EventArgs e)
        {
            var reportDetails = (from data in db.partner_reports
                                 where data.partner_report_id == ReportId
                                 select new
                                 {
                                     data.project_id,
                                     data.report_period_id,
                                     data.year_id
                                 }).SingleOrDefault();

            var ratingVar = (from data in db.project_overall_rating
                          where data.partner_report_id == ReportId
                          select data).SingleOrDefault();

            if (ratingVar == null)
            {
                project_overall_rating rating = new project_overall_rating();
                rating.partner_report_id = ReportId;
                rating.project_id = reportDetails.project_id;
                rating.report_period_id = reportDetails.report_period_id;
                rating.year_id = reportDetails.year_id;
                rating.rating_id = int.Parse(RatingList.SelectedValue.Trim());
                rating.comment = CommentaryText.Value.Trim();
                db.project_overall_rating.Add(rating);
            }
            else if (ratingVar != null)
            {
                ratingVar.rating_id = int.Parse(RatingList.SelectedValue.Trim());
                ratingVar.comment = CommentaryText.Value.Trim();
            }

            if (db.SaveChanges() > 0)
            {
                db.SaveChanges();
            }
            ProjectRatingCompleted();
        }

        protected void ProjectRatingCompleted()
        {
            var rating = (from data in db.project_overall_rating
                              where data.partner_report_id == ReportId
                              select data).SingleOrDefault();
            
            if (rating != null)
            {
                RatingList.SelectedValue = rating.rating_id.ToString();
                CommentaryText.Value = rating.comment.Trim();

                n6_heading.Style.Add("background-color", "chartreuse");

                sendCount(completeSections++);
            }
            else if (rating == null)
            {
                n6_heading.Style.Add("background-color", "orangered");
            }
        }

        protected void RefreshBtn_Click(object sender, EventArgs e)
        {
            try
            {
                var reportData = (from data in db.partner_reports
                                  where data.partner_report_id == ReportId
                                  select new
                                  {
                                      data.project_id,
                                      data.report_period_id,
                                      data.year_id
                                  }).SingleOrDefault();

                //get all the indicators for the project
                var projectIndicators = (from data in db.partner_indicators
                                         where data.project_id == reportData.project_id
                                         select new { data.partner_indicator_id });
                foreach (var projectIndicator in projectIndicators)
                {
                    //get all the planned indicator data for the particular quarter and year
                    var plannedProjectIndicators = (from data in db.indicator_report_planner
                                                    where data.partner_indicator_id == projectIndicator.partner_indicator_id
                                                    && data.report_period_id == reportData.report_period_id
                                                    && data.year_id == reportData.year_id
                                                    select new
                                                    {
                                                        data.partner_indicator_id,
                                                        data.report_period_id,
                                                        data.year_id
                                                    });

                    //======+++++++++++++++============Check from here

                    //Get all the indicator results data for the indicators for the particular quarter and year
                    var resultsProjectIndicators = (from data in db.partner_indicator_results
                                                    where data.partner_indicator_id == projectIndicator.partner_indicator_id
                                                    && data.report_period_id == reportData.report_period_id
                                                    && data.year_id == reportData.year_id
                                                    select new
                                                    {
                                                        data.partner_indicator_id,
                                                        data.report_period_id,
                                                        data.year_id
                                                    });

                    //This is what has been planned for but not among the results 
                    //(Data to be added)
                    var newData = plannedProjectIndicators.Except(resultsProjectIndicators);

                    //This is what is in the results but not among the planned indicators 
                    //(Data to be deleted)
                    var delData = resultsProjectIndicators.Except(plannedProjectIndicators);

                    //Add the new planned indicators to the results
                    foreach (var _newData in newData)
                    {
                        partner_indicator_results newResult = new partner_indicator_results();
                        newResult.partner_report_id = ReportId;
                        newResult.partner_indicator_id = _newData.partner_indicator_id;
                        newResult.report_period_id = _newData.report_period_id;
                        newResult.year_id = _newData.year_id;
                        db.partner_indicator_results.Add(newResult);

                        //Project indicator disaggregation result to be added
                        var indicatorDisaggregation = from data in db.project_indicator_disaggregation
                                                      where data.project_indicator_id == _newData.partner_indicator_id
                                                      select data;
                        if(indicatorDisaggregation != null)
                        {
                            foreach (var _indicatorDisaggregation in indicatorDisaggregation)
                            {
                                //Add the new disaggregations to the result
                                project_indicator_disaggregation_result newDisResult = new project_indicator_disaggregation_result();
                                newDisResult.project_indicator_disaggregation_id = _indicatorDisaggregation.id;
                                newDisResult.partner_report_id = ReportId;
                                newDisResult.report_period_id = _newData.report_period_id;
                                newDisResult.year_id = _newData.year_id;
                                db.project_indicator_disaggregation_result.Add(newDisResult);
                            }
                        }
                    }

                    //Remove the irrelevant results if the are not planned for
                    foreach (var _delData in delData)
                    {
                        partner_indicator_results delResult = db.partner_indicator_results
                            .Where(data => data.partner_report_id == ReportId
                            && data.partner_indicator_id == _delData.partner_indicator_id
                            && data.report_period_id == _delData.report_period_id
                            && data.year_id == _delData.year_id).Single();
                        db.partner_indicator_results.Remove(delResult);

                        //Project indicator disaggregation result to be removed
                        var indicatorDisaggregation = from data in db.project_indicator_disaggregation
                                                      where data.project_indicator_id == _delData.partner_indicator_id
                                                      select data;
                        if (indicatorDisaggregation != null)
                        {
                            foreach (var _indicatorDisaggregation in indicatorDisaggregation)
                            {
                                //Remove the old disaggregations to the result
                                project_indicator_disaggregation_result delDisResult = new project_indicator_disaggregation_result();
                                delDisResult.project_indicator_disaggregation_id = _indicatorDisaggregation.id;
                                delDisResult.partner_report_id = ReportId;
                                delDisResult.report_period_id = _delData.report_period_id;
                                delDisResult.year_id = _delData.year_id;
                                db.project_indicator_disaggregation_result.Remove(delDisResult);
                            }
                        }
                    }
                }
            }
            catch(Exception ex)
            {

            }
            finally
            {
                if(db.SaveChanges() > 0)
                {
                    db.SaveChanges();
                    ResultsGridView.DataBind();
                    indicatorResultsSectionComplete();
                }
            }
        }

        protected void DisaggregationRepeater_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                Label lbl = (Label)e.Item.FindControl("Label4");

                HiddenField HF1 = e.Item.FindControl("Disaggregation_Result_ID_HiddenField") as HiddenField;

                int disagID = int.Parse(HF1.Value.Trim());

                //Perform the insert operation from the repeater
                project_indicator_disaggregation_result _myDisagResult = db.project_indicator_disaggregation_result
                    .Single(
                    data => data.id == disagID
                    );

                var myDisagResults = from data in db.project_indicator_disaggregation_result
                                     where data.id == disagID
                                     select data;

                foreach (var myDisagResult in myDisagResults)
                {
                    AddNewIndicator ind = new AddNewIndicator();
                    lbl.Text = ind.displayDisaggregation(myDisagResult.project_indicator_disaggregation.disaggregation_id);
                }
            }
        }

        protected void ResultsGridView_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            // Give this message if there are no rows returned
            if (e.Row.RowType.Equals(DataControlRowType.EmptyDataRow))
            {
                Label lbl = e.Row.FindControl("EmptyDataLabel") as Label;
                if (lbl != null)
                {
                    lbl.Text = "No Indicators Found!";
                }
            }
            else if (e.Row.RowType == DataControlRowType.DataRow)
            {
                Label lbl = (Label)e.Row.FindControl("Label9");
                int indicatorResultId = int.Parse(lbl.Text);
                AddNewIndicator ind = new AddNewIndicator();

                var indicatorData = (from data in db.partner_indicator_results
                                   where data.partner_indicator_result_id == indicatorResultId
                                   select new
                                   {
                                       data.indicator_report_planner.partner_indicators.partner_indicator_id,
                                       data.attachment
                                   })
                                  .SingleOrDefault();

                var disaggregationIds = (from data in db.project_indicator_disaggregation_result
                                         where data.project_indicator_disaggregation.project_indicator_id == indicatorData.partner_indicator_id
                                         select new
                                         {
                                             data.project_indicator_disaggregation.disaggregation_id,
                                             data.disaggregation_result
                                         });

                StringBuilder text = new StringBuilder();
                string stext = string.Empty;
                foreach(var disaggregationId in disaggregationIds)
                {
                    stext += ind.displayDisaggregation(disaggregationId.disaggregation_id) + " [" + disaggregationId.disaggregation_result + "] ";
                }

                Label lbl10 = (Label)e.Row.FindControl("Label10");
                lbl10.Text = stext;

                //Set the hyperlink
                HyperLink link = (HyperLink)e.Row.FindControl("IndicatorAttachmentLink");
                if(!string.IsNullOrEmpty(indicatorData.attachment))
                {
                    link.NavigateUrl = "~/downloading.aspx?file=" + indicatorData.attachment;
                    link.Visible = true;
                }
            }
        }

        protected void RiskGridView_RowEditing(object sender, GridViewEditEventArgs e)
        {
            this.RiskGridView.EditIndex = e.NewEditIndex;
        }

        protected void RiskGridView_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            GridViewRow row = RiskGridView.Rows[e.RowIndex];

            Label RiskIdLabel = row.FindControl("RiskIdLabel") as Label;
            int riskId = int.Parse(RiskIdLabel.Text.Trim());

            DropDownList ResponseDropDownList = row.FindControl("ResponseDropDownList") as DropDownList;
            TextBox CommentTextBox = row.FindControl("CommentTextBox") as TextBox;

            project_risk_report risk = db.project_risk_report.SingleOrDefault(data => data.project_risk_id == riskId);
            risk.response = ResponseDropDownList.SelectedValue;
            risk.comment = CommentTextBox.Text.Trim();

            FileUpload riskAttachment = row.FindControl("RiskAttachmentFileUpload") as FileUpload;
            string myFolderPath = "~/Attachments/";
            string folderPath = Server.MapPath(myFolderPath);
            if(riskAttachment.HasFile)
            {
                //Check if the directory exists
                if (!Directory.Exists(folderPath))
                {
                    //If the directory does not exist. Create it.
                    Directory.CreateDirectory(folderPath);
                }

                //Save the file to the directory
                string myFileName = risk.project_id + ReportId +
                    "_Risk_" + Path.GetFileName(riskAttachment.FileName);

                //Check if there was a previous file
                if(File.Exists(Server.MapPath(risk.attachment)))
                {
                    //If it exists delete it
                    File.Delete(Server.MapPath(risk.attachment));
                }

                riskAttachment.SaveAs(folderPath + myFileName.Trim());

                //Save the path to the database
                risk.attachment = myFileName;
            }

            if (db.SaveChanges()>0)
            {
                db.SaveChanges();

                riskCompletedSection();
            }
        }

        /*protected void populateFinExp(int reportID)
        {
            var reportData = (from data in db.partner_reports
                              where data.partner_report_id == reportID
                              select data).FirstOrDefault();
            if (reportData != null)
            {
                if (!String.IsNullOrWhiteSpace(reportData.cumulative_expenditure.ToString()))
                {
                    finSum_heading.Style.Add("background-color", "chartreuse");
                    ExpenditureTextBox.Text = reportData.cumulative_expenditure.ToString().Trim();

                    if (!string.IsNullOrEmpty(reportData.cumulative_expenditure_attachment))
                    {
                        uploadFinExp.Visible = false;

                        uploadedFinExp.Visible = true;
                        FinExpAttachmentRemoveButton.CommandArgument = reportID.ToString();
                        FinExpHyperLink.NavigateUrl = reportData.cumulative_expenditure_attachment.Trim();
                    }
                    else
                    {
                        uploadFinExp.Visible = true;
                        uploadedFinExp.Visible = false;
                    }

                    sendCount(completeSections++);
                }
                else
                {
                    finSum_heading.Style.Add("background-color", "orangered");
                }
            }
        }*/
        
        protected void ChallengesGridView_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            GridViewRow row = (GridViewRow)ChallengesGridView.Rows[e.RowIndex];
            Label deleteID = (Label)row.FindControl("ChallengeIDLabel");
            int toDelete = int.Parse(deleteID.Text.Trim());

            partner_challenges deletion = db.partner_challenges.FirstOrDefault(
                d => d.challenge_id == toDelete);

            if(File.Exists(Server.MapPath(deletion.attachment)))
            {
                File.Delete(Server.MapPath(deletion.attachment));
            }
        }

        protected void ChallengesGridView_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                //((Button)e.Row.Cells[6].Controls[0]).OnClientClick =
                //    "if (!confirm('Do you really want to delete?')) return;";

                // loop all data rows
                foreach (DataControlFieldCell cell in e.Row.Cells)
                {
                    // check all cells in one row
                    foreach (Control control in cell.Controls)
                    {
                        // Must use LinkButton here instead of ImageButton
                        // if you are having Links (not images) as the command button.
                        LinkButton button = control as LinkButton;
                        if (button != null && button.CommandName == "Delete")
                            // Add delete confirmation
                            button.OnClientClick = "if (!confirm('Are you sure " +
                                   "you want to delete this record?')) return;";
                    }
                }

                //Set the hyperlink
                HyperLink link = (HyperLink)e.Row.FindControl("uploadLink");
                Label idLabel = (Label)e.Row.FindControl("ChallengeIDLabel");
                int challengeId = int.Parse(idLabel.Text.Trim());

                /*partner_challenges ch = db.partner_challenges.FirstOrDefault(
                    d => d.challenge_id == challengeId);*/
                var ch = (from d in db.partner_challenges
                          where d.challenge_id == challengeId
                          select d.attachment).FirstOrDefault();

                /*string str = String.Empty;
                str = ch.attachment.Trim();*/

                if(!string.IsNullOrEmpty(ch))
                {
                    link.NavigateUrl = "~/downloading.aspx?file=" + ch;
                    link.Visible = true;
                }
            }
        }

        protected void RiskGridView_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                //Set the Hyperlink
                HyperLink link = (HyperLink)e.Row.FindControl("RiskAttachmentLink");
                Label riskIdLabel = (Label)e.Row.FindControl("RiskIdLabel");
                int riskId = int.Parse(riskIdLabel.Text.Trim());

                var rsk = (from data in db.project_risk_report
                           where data.project_risk_id == riskId
                           select data.attachment).FirstOrDefault();

                if (link != null)
                {
                    if (!string.IsNullOrEmpty(rsk))
                    {
                        link.NavigateUrl = "~/downloading.aspx?file=" + rsk;
                        link.Visible = true;
                    }
                }
            }
        }

        protected void RiskGridView_PreRender(object sender, EventArgs e)
        {
            if(this.RiskGridView.EditIndex != -1)
            {
                LinkButton btn = (LinkButton)RiskGridView.Rows[RiskGridView.EditIndex].FindControl("DelRiskAttachBtn");
                Label riskID = (Label)RiskGridView.Rows[RiskGridView.EditIndex].FindControl("RiskIdLabel");

                if(riskID != null)
                {
                    int risk_id = int.Parse(riskID.Text);
                    var rsk = (from data in db.project_risk_report
                               where data.project_risk_id == risk_id
                               select data.attachment).FirstOrDefault();
                    if(!string.IsNullOrEmpty(rsk))
                    {
                        if (btn != null)
                        {
                            btn.Visible = true;
                            btn.CommandArgument = risk_id.ToString();
                        }
                    }
                }
            }
        }

        protected void DelRiskAttachBtn_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)(sender);
            int riskId = int.Parse(btn.CommandArgument);

            project_risk_report riskRpt = db.project_risk_report.FirstOrDefault(
                d => d.project_risk_id == riskId);
            if(File.Exists(Server.MapPath(riskRpt.attachment)))
            {
                File.Delete(Server.MapPath(riskRpt.attachment));
            }
            riskRpt.attachment = string.Empty;

            db.SaveChanges();

            RiskGridView.EditIndex = -1;
        }

        protected void RemoveIndicatorAttachBtn_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)(sender);
            int indResultId = int.Parse(btn.CommandArgument.Trim());

            partner_indicator_results indResult = db.partner_indicator_results.FirstOrDefault(
                d => d.partner_indicator_result_id == indResultId);
            if(File.Exists(Server.MapPath(indResult.attachment)))
            {
                File.Delete(Server.MapPath(indResult.attachment));
            }
            indResult.attachment = string.Empty;

            db.SaveChanges();

            ResultsGridView.DataBind();
        }

        protected void achievementsRemoveButton_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)(sender);
            int reportID = int.Parse(btn.CommandArgument.Trim());

            partner_reports rpt = db.partner_reports.FirstOrDefault(
                d => d.partner_report_id == reportID);
            if(File.Exists(Server.MapPath(rpt.achievements_attachment)))
            {
                File.Delete(Server.MapPath(rpt.achievements_attachment));
            }
            rpt.achievements_attachment = string.Empty;

            db.SaveChanges();
            populateAchievements(reportID);
        }

        protected void lessonsRemoveButton_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)(sender);
            int reportID = int.Parse(btn.CommandArgument.Trim());

            partner_reports rpt = db.partner_reports.FirstOrDefault(
                d => d.partner_report_id == reportID);
            if(File.Exists(Server.MapPath(rpt.lessons_learned_attachment)))
            {
                File.Delete(Server.MapPath(rpt.lessons_learned_attachment));
            }
            rpt.lessons_learned_attachment = string.Empty;

            db.SaveChanges();
            populateLessonsLearned(reportID);
        }

        protected void nextStepsRemoveButton_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)(sender);
            int reportID = int.Parse(btn.CommandArgument.Trim());

            partner_reports rpt = db.partner_reports.FirstOrDefault(
                d => d.partner_report_id == reportID);
            if(File.Exists(Server.MapPath(rpt.next_steps_attachment)))
            {
                File.Delete(Server.MapPath(rpt.next_steps_attachment));
            }
            rpt.next_steps_attachment = string.Empty;

            db.SaveChanges();
            populateNextSteps(reportID);
        }

        protected void FinExpAttachmentRemoveButton_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)(sender);
            int reportID = int.Parse(btn.CommandArgument.Trim());

            partner_reports rpt = db.partner_reports.FirstOrDefault(
                d => d.partner_report_id == reportID);
            if (File.Exists(Server.MapPath(rpt.cumulative_expenditure_attachment)))
            {
                File.Delete(Server.MapPath(rpt.cumulative_expenditure_attachment));
            }
            rpt.cumulative_expenditure_attachment = string.Empty;

            db.SaveChanges();
            populateFinancialSummary(reportID);
        }
    }
}