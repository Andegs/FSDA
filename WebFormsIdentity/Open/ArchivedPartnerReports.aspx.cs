using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebFormsIdentity.Report_Template;

namespace WebFormsIdentity.Open
{
    public partial class ArchivedPartnerReports : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            //Get the selected Row
            int currentRowIndex = Convert.ToInt32(e.CommandArgument);
            //GridViewRow row = GridView1.Rows[currentRowIndex];

            //Get the DataKey names for the selected row
            int reportId = int.Parse(this.GridView1.DataKeys[currentRowIndex].Values["partner_report_id"].ToString());

            if (e.CommandName == "pdf")
            {
                PDFCreator pdf = new PDFCreator();
                pdf.createPDF(reportId);
            }
        }
    }
}