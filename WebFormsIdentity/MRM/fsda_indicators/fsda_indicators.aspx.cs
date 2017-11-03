using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using WebFormsIdentity.Data_Access;

namespace WebFormsIdentity.MRM.fsda_indicators
{
    public partial class fsda_indicators : System.Web.UI.Page
    {
        WebFormsIdentityDatabaseEntities db = new WebFormsIdentityDatabaseEntities();
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            //Get the selected Row
            int currentRowIndex = Convert.ToInt32(e.CommandArgument);
            //GridViewRow row = GridView1.Rows[currentRowIndex];

            //Get the DataKey names for the selected row
            int IndicatorID = int.Parse(this.GridView1.DataKeys[currentRowIndex].Values["id"].ToString());

            if (e.CommandName == "editThis")
            {
                Label5.Text = "Edit FSDA Indicator";
                IndicatorIdHiddenField.Value = IndicatorID.ToString();
                AddIndBtn.Visible = false;
                SaveIndBtn.Visible = true;

                var indicator = (from data in db.fsda_indicators
                                 where data.id == IndicatorID
                                 select data).SingleOrDefault();

                if(indicator != null)
                {
                    FSDAIndicatorCode.Text = indicator.fsda_indicator_code.Trim();
                    FSDAIndicator.Text = indicator.indicator.Trim();
                }

                FSDAIndicatorCode.ReadOnly = true;

                ScriptManager.RegisterStartupScript(
                    Page,
                    Page.GetType(),
                    "FSDAIndicatorModal", "$('#FSDAIndicatorModal').modal('show');",
                    true);
            }
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            Label5.Text = "Add FSDA Indicator";
            AddIndBtn.Visible = true;
            SaveIndBtn.Visible = false;

            ScriptManager.RegisterStartupScript(
                Page,
                Page.GetType(),
                "FSDAIndicatorModal", "$('#FSDAIndicatorModal').modal('show');",
                true);

            FSDAIndicatorCode.Text = null;
            FSDAIndicator.Text = null;
        }

        protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                LinkButton del = e.Row.Cells[4].Controls[0] as LinkButton;
                del.Attributes.Add("onclick", "return confirm('Are you sure you want to delete this event?');");
            }
        }

        protected void AddIndBtn_Click(object sender, EventArgs e)
        {
            string code = FSDAIndicatorCode.Text.Trim();
            string ind = FSDAIndicator.Text.Trim();

            var theCode = from data in db.fsda_indicators
                          where data.fsda_indicator_code == code
                          select data;

            if(theCode.Count() > 0)
            {
                AlertLabel.Text = "That code has already been used";

                ScriptManager.RegisterStartupScript(
                Page,
                Page.GetType(),
                "alertModal", "$('#alertModal').modal('show');",
                true);

                return;
            }
            else
            {
                Data_Access.fsda_indicators newInd = new Data_Access.fsda_indicators();
                newInd.fsda_indicator_code = code;
                newInd.indicator = ind;

                db.fsda_indicators.Add(newInd);

                if(db.SaveChanges() > 0)
                {
                    db.SaveChanges();
                    GridView1.DataBind();
                }

                ScriptManager.RegisterStartupScript(
                Page,
                Page.GetType(),
                "FSDAIndicatorModal", "$('#FSDAIndicatorModal').modal('hide');",
                true);

            }
        }

        protected void SaveIndBtn_Click(object sender, EventArgs e)
        {
            if(IndicatorIdHiddenField.Value != null)
            {
                int indID = int.Parse(IndicatorIdHiddenField.Value);
                Data_Access.fsda_indicators theIndicator = (from data in db.fsda_indicators
                                                            where data.id == indID
                                                            select data).SingleOrDefault();

                theIndicator.indicator = FSDAIndicator.Text.Trim();

                if(db.SaveChanges() > 0)
                {
                    db.SaveChanges();
                    GridView1.DataBind();
                }
            }
        }
    }
}