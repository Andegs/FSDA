using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Security.Claims;
using System.Threading;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebFormsIdentity.Data_Access;

namespace WebFormsIdentity.Partner
{
    public partial class CreateNewReportForm : System.Web.UI.Page
    {
        WebFormsIdentityDatabaseEntities db = new WebFormsIdentityDatabaseEntities();

        protected void Page_Load(object sender, EventArgs e)
        {
            if(User.IsInRole("Partner"))
            {
                var principal = (ClaimsPrincipal)Thread.CurrentPrincipal;
                var project = principal.Claims.Where(c => c.Type == "Project").Select(c => c.Value).SingleOrDefault();

                //Add a new where parameter to the project linqdatasource
                LinqDataSource1.Where = "project_id = " + project;
            }
            else if (User.IsInRole("Pillar"))
            {
                var principal = (ClaimsPrincipal)Thread.CurrentPrincipal;
                var pillar = principal.Claims.Where(c => c.Type == "Pillar").Select(c => c.Value).SingleOrDefault();

                int pillarID = Int32.Parse(pillar);

                var projects = from data in db.projects where data.pillar_id == pillarID select data.project_id;

                foreach (var project in projects)
                {
                    //Add a new where parameter to the project entitydatasource
                    LinqDataSource1.Where = "project_id = " + project;
                }
            }
        }

        protected void CreateReportButton_Click(object sender, EventArgs e)
        {
            int partner = int.Parse(Partner.SelectedValue);
            int reportPeriod = int.Parse(ReportPeriod.SelectedValue);
            int year = int.Parse(Year.SelectedValue);

            var report = from data in db.partner_reports
                         where data.project_id == partner
                         && data.report_period_id == reportPeriod
                         && data.year_id == year
                         select data;
            if (report.Count() == 0)
            {
                //======Add the Narrative Part of the report to the Database======
                partner_reports myReport = new partner_reports();
                myReport.project_id = partner;
                myReport.report_period_id = reportPeriod;
                myReport.year_id = year;
                myReport.draft = true;
                myReport.saved = true;
                db.partner_reports.Add(myReport);

                //=======Add the Risks part of the Report to the database============
                var _theRisks = from data in db.project_risk
                                where (data.is_general_risk == true
                                || data.project_id == partner)
                                && data.active == true
                                select data;
                foreach (var theRisk in _theRisks)
                {
                    project_risk_report risk = new project_risk_report();
                    risk.risk_id = theRisk.risk_id;
                    risk.partner_reports = myReport;
                    risk.project_id = partner;
                    risk.report_period_id = reportPeriod;
                    risk.year_id = year;
                    db.project_risk_report.Add(risk);
                }
                

                //=======Add the Indicator part of the report to the database======
                var reportIndicators = from data in db.partner_indicators
                                       where data.project_id == partner
                                       select data.partner_indicator_id;

               /* DataTable dt = new DataTable();
                dt.Columns.AddRange(
                    new DataColumn[3]
                    {
                        new DataColumn("partner_indicator_id"),
                        new DataColumn("report_period_id"),
                        new DataColumn("year_id")
                    });*/

                foreach (var _reportIndicators in reportIndicators)
                {
                    var filteredReportIndicators = from data in db.indicator_report_planner
                                                   where data.report_period_id == reportPeriod
                                                   && data.year_id == year
                                                   && data.partner_indicator_id == _reportIndicators
                                                   select data;

                    foreach (var _filteredReportIndicators in filteredReportIndicators)
                    {

                        /*//Populate a data table that can be queried for an empty indicator results set
                        var row = dt.NewRow();
                        row["partner_indicator_id"] = _filteredReportIndicators.partner_indicator_id;
                        row["report_period_id"] = _filteredReportIndicators.report_period_id;
                        row["year_id"] = _filteredReportIndicators.year_id;
                        dt.Rows.Add(row);*/

                        partner_indicator_results myResults = new partner_indicator_results();
                        myResults.partner_indicator_id = _filteredReportIndicators.partner_indicator_id;
                        myResults.report_period_id = _filteredReportIndicators.report_period_id;
                        myResults.year_id = _filteredReportIndicators.year_id;
                        myResults.partner_reports = myReport;
                        db.partner_indicator_results.Add(myResults);


                        //================Added this peace of code to add disaggregated results=====================
                        var indDisaggregation = from data in db.project_indicator_disaggregation
                                                where data.project_indicator_id == _filteredReportIndicators.partner_indicator_id
                                                select data;
                        foreach(var _indDisaggregation in indDisaggregation)
                        {
                            project_indicator_disaggregation_result myDisaggregatedResults = new project_indicator_disaggregation_result();
                            myDisaggregatedResults.project_indicator_disaggregation_id = _indDisaggregation.id;
                            myDisaggregatedResults.partner_reports = myReport;
                            myDisaggregatedResults.report_period_id = _filteredReportIndicators.report_period_id;
                            myDisaggregatedResults.year_id = _filteredReportIndicators.year_id;
                            db.project_indicator_disaggregation_result.Add(myDisaggregatedResults);
                        }
                        //==================End added this peace of code=======================
                    }
                }
                /*if(dt.Rows.Count <= 0)
                {
                    AlertLabel.Text = "You cannot create that report, "+
                        "there are no indicators assigned to that reporting period."+
                        "Please contact the MRM Team";

                    ScriptManager.RegisterStartupScript(
                        Page,
                        Page.GetType(),
                        "alertModal", "$('#alertModal').modal('show');",
                        true);

                    //End page execution
                    //Response.End();//ends execution like below
                    return;
                }
                else if(dt.Rows.Count > 0)
                {
                    foreach (DataRow row in dt.Rows)
                    {
                        partner_indicator_results myResults = new partner_indicator_results();
                        myResults.partner_indicator_id = int.Parse(row["partner_indicator_id"].ToString());
                        myResults.report_period_id = int.Parse(row["report_period_id"].ToString());
                        myResults.year_id = int.Parse(row["year_id"].ToString());
                        myResults.partner_reports = myReport;
                        db.partner_indicator_results.Add(myResults);
                    }
                }*/
                //==================================================================

                try
                {
                    if (db.SaveChanges() > 0)
                    {
                        db.SaveChanges();

                        alertDiv.Visible = true;
                    }
                }
                catch(Exception ex)
                {
                    AlertLabel.Text = "You cannot create that report, please check again"+ex.InnerException;

                    ScriptManager.RegisterStartupScript(
                        Page,
                        Page.GetType(),
                        "alertModal", "$('#alertModal').modal('show');",
                        true);

                    return;
                }
            }
            else
            {
                AlertLabel.Text = "That Report has Already Been Created";

                ScriptManager.RegisterStartupScript(
                    Page,
                    Page.GetType(),
                    "alertModal", "$('#alertModal').modal('show');",
                    true);

                return;
            }
        }
    }
}