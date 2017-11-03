using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Threading;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using WebFormsIdentity.Data_Access;
using WebFormsIdentity.Report_Template;

namespace WebFormsIdentity.Partner
{
    public partial class CreatedPartnerReports : System.Web.UI.Page
    {
        WebFormsIdentityDatabaseEntities db = new WebFormsIdentityDatabaseEntities();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (User.IsInRole("Partner"))
            {
                var principal = (ClaimsPrincipal)Thread.CurrentPrincipal;
                var project = principal.Claims.Where(c => c.Type == "Project").Select(c => c.Value).SingleOrDefault();

                //Add a new where parameter to the project entitydatasource
                Parameter parameter = new Parameter("project_id", TypeCode.Int32, project);
                EntityDataSource1.WhereParameters.Add(parameter);
            }
            else if (User.IsInRole("Pillar"))
            {
                var principal = (ClaimsPrincipal)Thread.CurrentPrincipal;
                var pillars = principal.Claims.Where(c => c.Type == "Pillar").Select(c => c.Value);

                foreach (var pillar in pillars)
                {
                    int pillarID = Int32.Parse(pillar);

                    var projects = from data in db.projects where data.pillar_id == pillarID select data.project_id;

                    foreach (var project in projects)
                    {
                        //Add a new where parameter to the project entitydatasource
                        Parameter parameter = new Parameter("project_id", TypeCode.Int32, project.ToString());
                        EntityDataSource1.WhereParameters.Add(parameter);
                    }
                }
            }
        }

        protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            //Get the selected Row
            int currentRowIndex = Convert.ToInt32(e.CommandArgument);
            //GridViewRow row = GridView1.Rows[currentRowIndex];

            //Get the DataKey names for the selected row
            int reportId = int.Parse(this.GridView1.DataKeys[currentRowIndex].Values["partner_report_id"].ToString());

            if (e.CommandName == "Edit")
            {
                Response.Redirect(String.Format("~/Partner/PartnerReport.aspx?reportID={0}", reportId));
            }
            else if (e.CommandName == "pdf")
            {
                PDFCreator pdf = new PDFCreator();
                pdf.createPDF(reportId);
            }
        }

        protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                LinkButton del = e.Row.Cells[6].Controls[0] as LinkButton;
                del.Attributes.Add("onclick", "return confirm('Are you sure you want to delete this event?');");
            }
        }
    }
}