using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using WebFormsIdentity.Data_Access;

namespace WebFormsIdentity.MRM.Project_Indicators
{
    public partial class ProjectRisk : System.Web.UI.Page
    {
        WebFormsIdentityDatabaseEntities db = new WebFormsIdentityDatabaseEntities();

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            if (well.Visible == false)
            {
                well.Visible = true;
            }
            else if(well.Visible == true)
            {
                well.Visible = false;
            }
        }

        protected void RiskButton_Click(object sender, EventArgs e)
        {
            project_risk risk = new project_risk();

            if (GeneralRiskRadioButtonList.SelectedValue == "yes")
            {
                risk.risk = RiskTextBox.Text.Trim();
                risk.is_general_risk = true;
            }
            else if(GeneralRiskRadioButtonList.SelectedValue == "no")
            {
                risk.is_general_risk = false;
                risk.risk = ProjectRiskTextBox.Text.Trim();
                risk.project_id = int.Parse(ProjectList.SelectedValue.Trim());
            }

            risk.active = true;
            db.project_risk.Add(risk);

            int dt = db.SaveChanges();
            if(db.SaveChanges() > 0)
            {
                db.SaveChanges();

                /*if(UpdatePanel1.HasControls())
                {
                    foreach(Control subCtrl in UpdatePanel1.Controls[0].Controls)
                    {
                        var textbox = subCtrl as TextBox;
                        if(textbox != null)
                        {
                            textbox.Text = string.Empty;
                        }
                    }
                }*/
            }

            GridView1.DataBind();

            ScriptManager.RegisterStartupScript(
                    Page,
                    Page.GetType(),
                    "addNewRiskModal",
                    "$('#addNewRiskModal').modal('hide');",
                    true);


            
        }

        protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
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
            }
        }

        protected void GeneralRiskRadioButtonList_SelectedIndexChanged(object sender, EventArgs e)
        {
            if(GeneralRiskRadioButtonList.SelectedValue == "yes")
            {
                genRiskDiv.Visible = true;
                projectRiskDiv.Visible = false;
            }
            else if(GeneralRiskRadioButtonList.SelectedValue == "no")
            {
                genRiskDiv.Visible = false;
                projectRiskDiv.Visible = true;
            }
        }
    }
}