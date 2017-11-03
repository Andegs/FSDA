using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using WebFormsIdentity.Data_Access;

namespace WebFormsIdentity.MRM.Project_Indicators
{
    public partial class ProjectIndicators : System.Web.UI.Page
    {
        WebFormsIdentityDatabaseEntities db = new WebFormsIdentityDatabaseEntities();
        DataTable dt = new DataTable();
        protected void Page_Load(object sender, EventArgs e)
        {
            dt.Columns.AddRange(
            new DataColumn[7]
            {
                    new DataColumn("partner_indicator_id"),
                    new DataColumn("report_period_id"),
                    new DataColumn("year_id"),
                    new DataColumn("year1"),
                    new DataColumn("target"),
                    new DataColumn("period"),
                    new DataColumn("id")
            });
            //Set AutoIncrement True for the First Column.
            dt.Columns["id"].AutoIncrement = true;

            //Set the Starting or Seed value.
            dt.Columns["id"].AutoIncrementSeed = 1;

            //Set the Increment value.
            dt.Columns["id"].AutoIncrementStep = 1;

            if (!this.IsPostBack)
            {
                ViewState["prd"] = dt;
                this.BindGrid();
            }
        }

        protected void BindGrid()
        {
            DataTable NewDt = ViewState["prd"] as DataTable;

            if (NewDt != null && NewDt.Rows.Count > 0)
            {
                SavePeriodToDbBtn.Visible = true;
            }
            else
            {
                SavePeriodToDbBtn.Visible = false;
            }

            GridView3.DataSource = NewDt;
            GridView3.DataBind();

            DataTable distinctIndicators = NewDt.DefaultView.ToTable(true, new string[] { "year_id", "year1" });
            
            GridView2.DataSource = distinctIndicators;
            GridView2.DataBind();

            foreach (GridViewRow row in GridView2.Rows)
            {
                if(row.RowType == DataControlRowType.DataRow)
                {
                    Label YrIdLabel = row.FindControl("YrIdLabel") as Label;
                    int YrId = int.Parse(YrIdLabel.Text.Trim());

                    //Check for double entry below
                    var periods = from data in NewDt.AsEnumerable()
                                 where data.Field<string>("year_id") == YrId.ToString()
                                 select data.Field<string>("report_period_id");

                    if (periods != null)
                    {
                        foreach(var period in periods)
                        {
                            if(period == "1")
                            {
                                CheckBox q1 = row.FindControl("CheckBox1") as CheckBox;
                                q1.Checked = true;
                            }
                            else if (period == "2")
                            {
                                CheckBox q2 = row.FindControl("CheckBox2") as CheckBox;
                                q2.Checked = true;
                            }
                            else if (period == "3")
                            {
                                CheckBox q3 = row.FindControl("CheckBox3") as CheckBox;
                                q3.Checked = true;
                            }
                            else if (period == "4")
                            {
                                CheckBox q4 = row.FindControl("CheckBox4") as CheckBox;
                                q4.Checked = true;
                            }
                            else if (period == "5")
                            {
                                CheckBox q5 = row.FindControl("CheckBox5") as CheckBox;
                                q5.Checked = true;
                            }
                            if (period == "6")
                            {
                                CheckBox q6 = row.FindControl("CheckBox6") as CheckBox;
                                q6.Checked = true;
                            }
                        }
                    }
                }
            }
        }

        protected void ProjectDropDownList_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddList = (DropDownList)sender;
            int partnerIndicator = int.Parse(ddList.SelectedValue.Trim());

            if(partnerIndicator != 0)
            {
                EntityDataSource1.WhereParameters["project_id"].DefaultValue = partnerIndicator.ToString();
                GridView1.Visible = true;
                GridView1.DataBind();
            }
            else if(partnerIndicator == 0)
            {
                GridView1.Visible = false;
            }
        }

        protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            //Get the selected Row
            int currentRowIndex = Convert.ToInt32(e.CommandArgument);
            //GridViewRow row = GridView1.Rows[currentRowIndex];

            //Get the DataKey name values for the selected row
            int partnerIndicatorId = int.Parse(this.GridView1.DataKeys[currentRowIndex].Values["partner_indicator_id"].ToString());

            string indicator = (from data in db.partner_indicators
                                where data.partner_indicator_id == partnerIndicatorId
                                select data.indicator).FirstOrDefault();

            if (e.CommandName == "plan")
            {
                //Clear the datatable of previous data and make it ready for new data
                dt.Clear();
                ViewState["prd"] = dt;

                SavePeriodToDbBtn.Visible = false;
                this.BindGrid();


                ModalPlanHeaderLabel.Text = indicator;

                HiddenPlanIndicatorID.Value = partnerIndicatorId.ToString();

                ScriptManager.RegisterStartupScript(
                    Page,
                    Page.GetType(),
                    "planModal", "$('#planModal').modal('show');",
                    true);
            }
            if(e.CommandName == "disaggregate")
            {
                IndicatorLabel.Text = indicator.Trim();
                IndicatorIDHiddenField.Value = partnerIndicatorId.ToString();

                EntityDataSource3.WhereParameters["project_indicator_id"].DefaultValue = partnerIndicatorId.ToString();
                DisaggragationView.DataBind();

                ScriptManager.RegisterStartupScript(
                    Page,
                    Page.GetType(),
                    "disaggragateModal", "$('#disaggragateModal').modal('show');",
                    true);
            }
        }

        protected void BindNestedGrid(GridView gview, int pid)
        {
            var periodsData = (from data in db.indicator_report_planner
                           where data.partner_indicator_id == pid
                           select data.year).Distinct();

            gview.DataSource = periodsData.ToList();
            gview.DataBind();

            foreach (GridViewRow row in gview.Rows)
            {
                if (row.RowType == DataControlRowType.DataRow)
                {
                    Label YrIdLabel = row.FindControl("YrIdLabel") as Label;
                    int YrId = int.Parse(YrIdLabel.Text.Trim());

                    //Check for double entry below
                    var periods = from data in db.indicator_report_planner
                                  where data.partner_indicator_id == pid
                                  && data.year_id == YrId
                                  select data.report_period_id;

                    if (periods != null)
                    {
                        foreach (var period in periods)
                        {
                            if (period == 1)
                            {
                                CheckBox q1 = row.FindControl("CheckBox1") as CheckBox;
                                q1.Checked = true;
                            }
                            else if (period == 2)
                            {
                                CheckBox q2 = row.FindControl("CheckBox2") as CheckBox;
                                q2.Checked = true;
                            }
                            else if (period == 3)
                            {
                                CheckBox q3 = row.FindControl("CheckBox3") as CheckBox;
                                q3.Checked = true;
                            }
                            else if (period == 4)
                            {
                                CheckBox q4 = row.FindControl("CheckBox4") as CheckBox;
                                q4.Checked = true;
                            }
                            else if (period == 5)
                            {
                                CheckBox q5 = row.FindControl("CheckBox5") as CheckBox;
                                q5.Checked = true;
                            }
                            if (period == 6)
                            {
                                CheckBox q6 = row.FindControl("CheckBox6") as CheckBox;
                                q6.Checked = true;
                            }
                        }
                    }
                }
            }
        }

        string viewUniqueID = string.Empty;
        int viewEditIndex = -1;
        protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            //Start - Keep the selected child grids expanded
            foreach (GridViewRow row in GridView1.Rows)
            {
                if (row.RowType == DataControlRowType.DataRow)
                {
                    HiddenField IsExpanded = row.FindControl("IsExpanded") as HiddenField;
                    IsExpanded.Value = Request.Form[IsExpanded.UniqueID];
                }
            }
            //End - Keep the selected child grids expanded

            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                string partnerIndicatorID = GridView1.DataKeys[e.Row.RowIndex].Value.ToString();
                
                //=========================================================================
                GridView gvIndicatorPeriods = e.Row.FindControl("gvIndicatorPeriods") as GridView;

                if(gvIndicatorPeriods.UniqueID == viewUniqueID)
                {
                    gvIndicatorPeriods.EditIndex = viewEditIndex;
                }
                EntityDataSource2.WhereParameters["partner_indicator_id"].DefaultValue = partnerIndicatorID.ToString();
                gvIndicatorPeriods.DataSource = EntityDataSource2;
                gvIndicatorPeriods.DataBind();

                //==========================================================================
                GridView _gvIndicatorPeriods = e.Row.FindControl("Periods_GridView") as GridView;
                
                if (_gvIndicatorPeriods.UniqueID == viewUniqueID)
                {
                    _gvIndicatorPeriods.EditIndex = viewEditIndex;
                }
                BindNestedGrid(_gvIndicatorPeriods, int.Parse(partnerIndicatorID));
            }
        }
        
        protected void SavePeriods_Click(object sender, EventArgs e)
        {
            //Check if the indicator requires a number as a result/target
            int indID = Convert.ToInt32(HiddenPlanIndicatorID.Value.Trim());
            var indType = (from data in db.partner_indicators
                           where data.partner_indicator_id == indID
                           select data.indicator_type_id).FirstOrDefault();
            /*if (indType != null && indType == 1)
            {
                int number;
                if (!int.TryParse(TargetTextBox.Text.Trim(), out number))
                {
                    //this is false and requires a number
                    error.Visible = true;
                    return;
                }
                else
                {
                    error.Visible = false;
                }
            }*/

            var selectedPeriods = PeriodList.Items.Cast<ListItem>().Where(n => n.Selected).ToList();

            DataTable _dt = ViewState["prd"] as DataTable;
            foreach (var selectedPeriod in selectedPeriods)
            {
                var periods = from data in _dt.AsEnumerable()
                                where data.Field<string>("year_id") == YearList.SelectedValue.Trim()
                                && data.Field<string>("partner_indicator_id") == HiddenPlanIndicatorID.Value.Trim()
                                && data.Field<string>("report_period_id") == selectedPeriod.Value.Trim()
                                select data;

                if (!periods.Any())
                {
                    DataRow dr = _dt.NewRow();
                    dr[0] = int.Parse(HiddenPlanIndicatorID.Value.Trim());
                    dr[1] = int.Parse(selectedPeriod.Value.Trim());
                    dr[2] = int.Parse(YearList.SelectedValue.Trim());
                    dr[3] = int.Parse(YearList.SelectedItem.Text.Trim());
                    dr[4] = TargetTextBox.Text.Trim();
                    dr[5] = selectedPeriod.Text.Trim();

                    _dt.Rows.Add(dr);
                }
            }
            ViewState["prd"] = _dt;
            this.BindGrid();
        }

        protected void GridView2_RowEditing(object sender, GridViewEditEventArgs e)
        {
            GridView2.EditIndex = e.NewEditIndex;
            this.BindGrid();
        }

        protected void GridView2_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            GridView2.EditIndex = -1;
            this.BindGrid();
        }

        protected void GridView2_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            DataTable _dt = ViewState["prd"] as DataTable;

            GridViewRow row = GridView2.Rows[e.RowIndex];
            Label YrIdLabel = row.FindControl("YrIdLabel") as Label;
            int YrId = int.Parse(YrIdLabel.Text.Trim());

            var rowsToDelete = _dt.Select("year_id = " + YrId);
            foreach(var rowToDelete in rowsToDelete)
            {
                rowToDelete.Delete();
            }

            ViewState["prd"] = _dt;
            this.BindGrid();
        }

        protected void GridView2_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            DataTable _dt = ViewState["prd"] as DataTable;

            GridViewRow row = GridView2.Rows[e.RowIndex];
            Label YrIdLabel = row.FindControl("YrIdLabel") as Label;
            Label YrLabel = row.FindControl("YrLabel") as Label;

            int YrId = int.Parse(YrIdLabel.Text.Trim());
            string Yr = YrLabel.Text.Trim();
            //string Yr = "2016";
            int IndId = int.Parse(HiddenPlanIndicatorID.Value.Trim());

            CheckBox q1 = row.FindControl("CheckBox1") as CheckBox;
            var q1periods = (from data in _dt.AsEnumerable()
                           where data.Field<string>("year_id") == YrId.ToString()
                           && data.Field<string>("partner_indicator_id") == IndId.ToString()
                           && data.Field<string>("report_period_id") == "1"
                           select data);
            if (q1.Checked)
            {
                if (!q1periods.Any())
                {
                    //Add a new row
                    DataRow dr = _dt.NewRow();
                    dr[0] = IndId;
                    dr[1] = 1;
                    dr[2] = YrId;
                    dr[3] = Yr;

                    _dt.Rows.Add(dr);
                }
            }
            else if(!q1.Checked)
            {
                //Remove the row if it exists
                if (q1periods.Any())
                {
                    _dt.AsEnumerable().Where(data => data.Field<string>("year_id") == YrId.ToString()
                                  && data.Field<string>("partner_indicator_id") == IndId.ToString()
                                  && data.Field<string>("report_period_id") == "1").SingleOrDefault().Delete();
                }
            }
            CheckBox q2 = row.FindControl("CheckBox2") as CheckBox;
            var q2periods = from data in _dt.AsEnumerable()
                          where data.Field<string>("year_id") == YrId.ToString()
                          && data.Field<string>("partner_indicator_id") == IndId.ToString()
                          && data.Field<string>("report_period_id") == "2"
                          select data;
            if (q2.Checked)
            {
                if (q2periods.Count() <= 0)
                {
                    //Add a new row
                    DataRow dr = _dt.NewRow();
                    dr[0] = IndId;
                    dr[1] = 2;
                    dr[2] = YrId;
                    dr[3] = Yr;

                    _dt.Rows.Add(dr);
                }
            }
            else if(!q2.Checked)
            {
                //Remove the row if it exists
                if (q2periods.Any())
                {
                    _dt.AsEnumerable().Where(data => data.Field<string>("year_id") == YrId.ToString()
                                  && data.Field<string>("partner_indicator_id") == IndId.ToString()
                                  && data.Field<string>("report_period_id") == "2").SingleOrDefault().Delete();
                }
            }
            CheckBox q3 = row.FindControl("CheckBox3") as CheckBox;
            var q3periods = from data in _dt.AsEnumerable()
                          where data.Field<string>("year_id") == YrId.ToString()
                          && data.Field<string>("partner_indicator_id") == IndId.ToString()
                          && data.Field<string>("report_period_id") == "3"
                          select data;
            if (q3.Checked)
            {
                if (q3periods.Count() <= 0)
                {
                    //Add a new row
                    DataRow dr = _dt.NewRow();
                    dr[0] = IndId;
                    dr[1] = 3;
                    dr[2] = YrId;
                    dr[3] = Yr;

                    _dt.Rows.Add(dr);
                }
            }
            else if (!q3.Checked)
            {
                //Remove the row if any
                if (q3periods.Any())
                {
                    _dt.AsEnumerable().Where(data => data.Field<string>("year_id") == YrId.ToString()
                                  && data.Field<string>("partner_indicator_id") == IndId.ToString()
                                  && data.Field<string>("report_period_id") == "3").SingleOrDefault().Delete();
                }
            }
            CheckBox q4 = row.FindControl("CheckBox4") as CheckBox;
            var q4periods = from data in _dt.AsEnumerable()
                          where data.Field<string>("year_id") == YrId.ToString()
                          && data.Field<string>("partner_indicator_id") == IndId.ToString()
                          && data.Field<string>("report_period_id") == "4"
                          select data;
            if (q4.Checked)
            {
                if (q4periods.Count() <= 0)
                {
                    //Add a new row
                    DataRow dr = _dt.NewRow();
                    dr[0] = IndId;
                    dr[1] = 4;
                    dr[2] = YrId;
                    dr[3] = Yr;

                    _dt.Rows.Add(dr);
                }
            }
            else if (!q4.Checked)
            {
                //Remove the row if it exists
                if (q4periods.Any())
                {
                    _dt.AsEnumerable().Where(data => data.Field<string>("year_id") == YrId.ToString()
                                  && data.Field<string>("partner_indicator_id") == IndId.ToString()
                                  && data.Field<string>("report_period_id") == "4").SingleOrDefault().Delete();
                }
            }
            CheckBox q5 = row.FindControl("CheckBox5") as CheckBox;
            var q5periods = from data in _dt.AsEnumerable()
                          where data.Field<string>("year_id") == YrId.ToString()
                          && data.Field<string>("partner_indicator_id") == IndId.ToString()
                          && data.Field<string>("report_period_id") == "5"
                          select data;
            if (q5.Checked)
            {
                if (q5periods.Count() <= 0)
                {
                    //Add a new row
                    DataRow dr = _dt.NewRow();
                    dr[0] = IndId;
                    dr[1] = 5;
                    dr[2] = YrId;
                    dr[3] = Yr;

                    _dt.Rows.Add(dr);
                }
            }
            else if (!q5.Checked)
            {
                //Remove the row if it exists
                if (q5periods.Any())
                {
                    _dt.AsEnumerable().Where(data => data.Field<string>("year_id") == YrId.ToString()
                                  && data.Field<string>("partner_indicator_id") == IndId.ToString()
                                  && data.Field<string>("report_period_id") == "5").SingleOrDefault().Delete();
                }
            }
            CheckBox q6 = row.FindControl("CheckBox6") as CheckBox;
            var q6periods = from data in _dt.AsEnumerable()
                          where data.Field<string>("year_id") == YrId.ToString()
                          && data.Field<string>("partner_indicator_id") == IndId.ToString()
                          && data.Field<string>("report_period_id") == "6"
                          select data;
            if (q6.Checked)
            {
                if (q6periods.Count() <= 0)
                {
                    //Add a new row
                    DataRow dr = _dt.NewRow();
                    dr[0] = IndId;
                    dr[1] = 6;
                    dr[2] = YrId;
                    dr[3] = Yr;

                    _dt.Rows.Add(dr);
                }
            }
            else if (!q6.Checked)
            {
                //Remove the row if it exists
                if (q6periods.Any())
                {
                    _dt.AsEnumerable().Where(data => data.Field<string>("year_id") == YrId.ToString()
                                  && data.Field<string>("partner_indicator_id") == IndId.ToString()
                                  && data.Field<string>("report_period_id") == "6").SingleOrDefault().Delete();
                }
            }

            ViewState["prd"] = _dt;
            GridView2.EditIndex = -1;
            this.BindGrid();
        }

        protected void SavePeriodToDbBtn_Click(object sender, EventArgs e)
        {
            DataTable dt = ViewState["prd"] as DataTable;

            /*dt.Columns.AddRange(
            new DataColumn[4]
            {
                    new DataColumn("partner_indicator_id"),
                    new DataColumn("report_period_id"),
                    new DataColumn("year_id"),
                    new DataColumn("year1")
            });*/

            if(dt.Rows.Count > 0)
            {
                foreach(DataRow row in dt.Rows)
                {
                    int pid = int.Parse(row["partner_indicator_id"].ToString());
                    int rpid = int.Parse(row["report_period_id"].ToString());
                    int yid = int.Parse(row["year_id"].ToString());
                    string qtarget = row["target"].ToString();

                    //Check if such exists in the database first
                    var checkExist = from data in db.indicator_report_planner
                                     where data.partner_indicator_id == pid
                                     && data.report_period_id == rpid
                                     && data.year_id == yid
                                     select data;

                    if (!checkExist.Any())
                    {
                        indicator_report_planner planner = new indicator_report_planner();
                        planner.partner_indicator_id = int.Parse(row["partner_indicator_id"].ToString());
                        planner.year_id = int.Parse(row["year_id"].ToString());
                        planner.report_period_id = int.Parse(row["report_period_id"].ToString());
                        planner.q_target = qtarget.Trim();

                        db.indicator_report_planner.Add(planner);
                    }
                }
                try
                {
                    if(db.SaveChanges() > 0)
                    {
                        db.SaveChanges();
                    }
                }
                catch
                {
                    throw new Exception();
                }
                finally
                {
                    //open the alert modal with message
                    string rowCount = dt.Rows.Count.ToString();
                    MsgLabel.Text = rowCount+" indicators added to the database successfully!";

                    //close the plan modal
                    ScriptManager.RegisterStartupScript(
                    Page,
                    Page.GetType(),
                    "planModal", "$('#planModal').modal('hide');",
                    true);

                    ScriptManager.RegisterStartupScript(
                        Page,
                        Page.GetType(),
                        "alertModal", "$('#alertModal').modal('show');",
                        true);

                    //Clear everything
                    dt.Clear();
                    ViewState["prd"] = dt;
                    SavePeriodToDbBtn.Visible = false;
                    this.BindGrid();
                }
            }
        }

        protected void okButton_Click(object sender, EventArgs e)
        {
            int partnerIndicator = int.Parse(ProjectDropDownList.SelectedValue.Trim());

            if (partnerIndicator != 0)
            {
                EntityDataSource1.WhereParameters["project_id"].DefaultValue = partnerIndicator.ToString();
                GridView1.Visible = true;
                GridView1.DataBind();
            }
            else if (partnerIndicator == 0)
            {
                GridView1.Visible = false;
            }
        }

        protected void Periods_GridView_RowEditing(object sender, GridViewEditEventArgs e)
        {
            GridView view = sender as GridView;
            viewUniqueID = view.UniqueID;
            viewEditIndex = e.NewEditIndex;
            GridView1.DataBind();
        }

        protected void Periods_GridView_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            GridView view = sender as GridView;
            viewUniqueID = view.UniqueID;
            viewEditIndex = -1;
            GridView1.DataBind();
        }

        protected void Periods_GridView_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            //Do some updating

            //Reset EditIndex
            viewEditIndex = -1;
            GridView1.DataBind();
        }

        protected void GridView3_RowEditing(object sender, GridViewEditEventArgs e)
        {
            GridView3.EditIndex = e.NewEditIndex;
            this.BindGrid();
        }

        protected void GridView3_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            GridView3.EditIndex = -1;
            this.BindGrid();
        }

        protected void GridView3_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            DataTable _dt = ViewState["prd"] as DataTable;

            GridViewRow row = GridView3.Rows[e.RowIndex];

            Label PlannerLabel = row.FindControl("PlannerLabel") as Label;
            int PlannerId = int.Parse(PlannerLabel.Text.Trim());

            var rowsToDelete = _dt.Select("id = " + PlannerId);
            foreach (var rowToDelete in rowsToDelete)
            {
                rowToDelete.Delete();
            }

            ViewState["prd"] = _dt;
            this.BindGrid();
        }

        protected void GridView3_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            GridViewRow row = GridView3.Rows[e.RowIndex];
            DataTable _dt = ViewState["prd"] as DataTable;

            //Do some updating
            int ID = Convert.ToInt32(GridView3.DataKeys[e.RowIndex].Value);
            string qTarget = (row.FindControl("TargetTxBx") as TextBox).Text.Trim();

            var rowsToUpdate = _dt.Select(string.Format("id = {0}", ID));
            if(rowsToUpdate.Any() && rowsToUpdate.Count() == 1)
            {
                foreach(DataRow rowToUpdate in rowsToUpdate)
                {
                    rowToUpdate["target"] = qTarget;
                }
            }

            ViewState["prd"] = _dt;
            GridView3.EditIndex = -1;
            this.BindGrid();
        }

        protected void gvIndicatorPeriods_RowEditing(object sender, GridViewEditEventArgs e)
        {
            GridView view = sender as GridView;
            viewUniqueID = view.UniqueID;
            viewEditIndex = e.NewEditIndex;
            GridView1.DataBind();
        }

        protected void gvIndicatorPeriods_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            GridView view = sender as GridView;
            viewUniqueID = view.UniqueID;
            viewEditIndex = -1;
            GridView1.DataBind();
        }

        protected void gvIndicatorPeriods_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            //Do some deleting from the database
            GridView view = sender as GridView;

            GridViewRow row = view.Rows[e.RowIndex];

            int partner_indicator_id = Convert.ToInt32(view.DataKeys[e.RowIndex].Values["partner_indicator_id"]);
            int report_period_id = Convert.ToInt32(view.DataKeys[e.RowIndex].Values["report_period_id"]);
            int year_id = Convert.ToInt32(view.DataKeys[e.RowIndex].Values["year_id"]);

            //Query the DB for this row and delete
            var dbRow = (from data in db.indicator_report_planner
                         where data.partner_indicator_id == partner_indicator_id
                         && data.report_period_id == report_period_id
                         && data.year_id == year_id
                         select data).SingleOrDefault();

            if (dbRow.partner_indicator_results == null)
            {
                db.indicator_report_planner.Remove(dbRow);
            }
            else
            {
                foreach (var _dbRow in dbRow.partner_indicator_results.ToList())
                {
                    db.partner_indicator_results.Remove(_dbRow);
                }
                db.indicator_report_planner.Remove(dbRow);
            }
            db.SaveChanges();

            GridView1.DataBind();
        }

        protected void gvIndicatorPeriods_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            //Do Some updating on the database
            GridView view = sender as GridView;

            GridViewRow row = view.Rows[e.RowIndex];

            int partner_indicator_id = Convert.ToInt32(view.DataKeys[e.RowIndex].Values["partner_indicator_id"]);
            int report_period_id = Convert.ToInt32(view.DataKeys[e.RowIndex].Values["report_period_id"]);
            int year_id = Convert.ToInt32(view.DataKeys[e.RowIndex].Values["year_id"]);

            //=================Come back to this Only allow numbers where appropriate==================
            /*var indType = (from data in db.partner_indicators
                           where data.partner_indicator_id == partner_indicator_id
                           select data.indicator_type_id).FirstOrDefault();
            if (indType != null && indType == 1)
            {
                int number;
                Label err = row.FindControl("errorTarget") as Label;

                if (!int.TryParse(TargetTextBox.Text.Trim(), out number))
                {
                    //this is false and requires a number
                    err.Visible = true;
                    return;
                }
                else
                {
                    err.Visible = false;
                }
            }*/
            //==========Come back to this Only allow numbers where appropriate=========================

            string _q_target = (row.FindControl("TargetTextBox") as TextBox).Text.Trim();
            string q_target = _q_target.Substring(_q_target.LastIndexOf(",") + 1);

            //Query the DB for this row and update
            var dbRow = (from data in db.indicator_report_planner
                         where data.partner_indicator_id == partner_indicator_id
                         && data.report_period_id == report_period_id
                         && data.year_id == year_id
                         select data).SingleOrDefault();

            dbRow.q_target = q_target;
            db.SaveChanges();

            viewEditIndex = -1;
            GridView1.DataBind();
        }

        protected void DisaggragationView_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            // Give this message if there are no rows returned
            if (e.Row.RowType.Equals(DataControlRowType.EmptyDataRow))
            {
                Label lbl = e.Row.FindControl("EmptyDataLabel") as Label;
                if (lbl != null)
                {
                    lbl.Text = "The indicator '" + IndicatorLabel.Text + "' has no disaggregation levels defined.";
                }
            }
            else if(e.Row.RowType == DataControlRowType.DataRow)
            {
                Label lbl = (Label)e.Row.FindControl("Label10");
                int disaggregationId = int.Parse(lbl.Text);

                AddNewIndicator ind = new AddNewIndicator();
                lbl.Text = ind.displayDisaggregation(disaggregationId);
            }
        }

        protected void SaveDisaggregationButton_Click(object sender, EventArgs e)
        {
            try
            {
                if (IndicatorIDHiddenField.Value != null)
                {
                    if (Disaggregation3DropDown.SelectedItem != null)
                    {
                        if (Disaggregation3DropDown.SelectedItem.Value == "0"
                                || Disaggregation3DropDown.SelectedItem.Value == "new")
                        {
                            if (Disaggregation2DropDown.SelectedItem.Value == "0"
                                || Disaggregation2DropDown.SelectedItem.Value == "new")
                            {
                                if (Disaggregation1DropDown.SelectedItem.Value == "0"
                                    || Disaggregation1DropDown.SelectedItem.Value == "new")
                                {
                                    //Nothing to save
                                    return;
                                }
                                else
                                {
                                    //Save the first disaggre
                                    int projIndicatorId = int.Parse(IndicatorIDHiddenField.Value.Trim());
                                    int disagId = int.Parse(Disaggregation1DropDown.SelectedItem.Value.Trim());

                                    project_indicator_disaggregation newDisaggregation = new project_indicator_disaggregation();
                                    newDisaggregation.project_indicator_id = projIndicatorId;
                                    newDisaggregation.disaggregation_id = disagId;

                                    db.project_indicator_disaggregation.Add(newDisaggregation);
                                }
                            }
                            else
                            {
                                //Save the second disagr
                                int projIndicatorId = int.Parse(IndicatorIDHiddenField.Value.Trim());
                                int disagId = int.Parse(Disaggregation2DropDown.SelectedItem.Value.Trim());

                                project_indicator_disaggregation newDisaggregation = new project_indicator_disaggregation();
                                newDisaggregation.project_indicator_id = projIndicatorId;
                                newDisaggregation.disaggregation_id = disagId;

                                db.project_indicator_disaggregation.Add(newDisaggregation);
                            }
                        }
                        else
                        {
                            //Save the thrid disagrr
                            int projIndicatorId = int.Parse(IndicatorIDHiddenField.Value.Trim());
                            int disagId = int.Parse(Disaggregation3DropDown.SelectedItem.Value.Trim());

                            project_indicator_disaggregation newDisaggregation = new project_indicator_disaggregation();
                            newDisaggregation.project_indicator_id = projIndicatorId;
                            newDisaggregation.disaggregation_id = disagId;

                            db.project_indicator_disaggregation.Add(newDisaggregation);
                        }
                    }
                    else if(Disaggregation2DropDown.SelectedItem != null)
                    {
                        if (Disaggregation2DropDown.SelectedItem.Value == "0"
                                || Disaggregation2DropDown.SelectedItem.Value == "new")
                        {
                            if (Disaggregation1DropDown.SelectedItem.Value == "0"
                                || Disaggregation1DropDown.SelectedItem.Value == "new")
                            {
                                //Nothing to save
                                return;
                            }
                            else
                            {
                                //Save the first disaggre
                                int projIndicatorId = int.Parse(IndicatorIDHiddenField.Value.Trim());
                                int disagId = int.Parse(Disaggregation1DropDown.SelectedItem.Value.Trim());

                                project_indicator_disaggregation newDisaggregation = new project_indicator_disaggregation();
                                newDisaggregation.project_indicator_id = projIndicatorId;
                                newDisaggregation.disaggregation_id = disagId;

                                db.project_indicator_disaggregation.Add(newDisaggregation);
                            }
                        }
                        else
                        {
                            //Save the second disagr
                            int projIndicatorId = int.Parse(IndicatorIDHiddenField.Value.Trim());
                            int disagId = int.Parse(Disaggregation2DropDown.SelectedItem.Value.Trim());

                            project_indicator_disaggregation newDisaggregation = new project_indicator_disaggregation();
                            newDisaggregation.project_indicator_id = projIndicatorId;
                            newDisaggregation.disaggregation_id = disagId;

                            db.project_indicator_disaggregation.Add(newDisaggregation);
                        }
                    }
                    else if(Disaggregation1DropDown.SelectedItem != null)
                    {
                        if (Disaggregation1DropDown.SelectedItem.Value == "0"
                                || Disaggregation1DropDown.SelectedItem.Value == "new")
                        {
                            //Nothing to save
                            return;
                        }
                        else
                        {
                            //Save the first disaggre
                            int projIndicatorId = int.Parse(IndicatorIDHiddenField.Value.Trim());
                            int disagId = int.Parse(Disaggregation1DropDown.SelectedItem.Value.Trim());

                            project_indicator_disaggregation newDisaggregation = new project_indicator_disaggregation();
                            newDisaggregation.project_indicator_id = projIndicatorId;
                            newDisaggregation.disaggregation_id = disagId;

                            db.project_indicator_disaggregation.Add(newDisaggregation);
                        }
                    }
                }
            }
            catch(Exception ex)
            {
                throw new Exception(ex.Message);
            }
            finally
            {
                if (db.SaveChanges() > 0)
                {
                    db.SaveChanges();
                    DisaggragationView.DataBind();
                }
            }
            
        }

        protected void Disaggregation1DropDown_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (Disaggregation1DropDown.SelectedValue == "new")
            {
                NewDisagLvl1Btn.Visible = true;
                NewDisagLvl2Btn.Visible = false;
                NewDisagLvl3Btn.Visible = false;

                ScriptManager.RegisterStartupScript(
                        Page,
                        Page.GetType(),
                        "newDisaggModal", "$('#newDisaggModal').modal('show');",
                        true);

                lvl2.Visible = false;
                lvl3.Visible = false;
            }
            else if(Disaggregation1DropDown.SelectedItem.Value == "0")
            {
                lvl2.Visible = false;
                lvl3.Visible = false;
            }
            else if(int.Parse(Disaggregation1DropDown.SelectedItem.Value) > 0)
            {
                disaglvl1field.Value = Disaggregation1DropDown.SelectedItem.Value;

                LinqDataSource6.Where = string.Format("disaggregation_id == {0}",
                    Disaggregation1DropDown.SelectedItem.Value);

                Disaggregation2DropDown.DataBind();
                lvl2.Visible = true;
            }
        }

        protected void Disaggregation1DropDown_DataBound(object sender, EventArgs e)
        {
            ListItem li_1 = new ListItem("<Select>", "0", true);
            li_1.Selected = true;
            Disaggregation1DropDown.Items.Insert(0, li_1);

            ListItem li_2 = new ListItem("New Disaggregation", "new", true);
            Disaggregation1DropDown.Items.Insert(1, li_2);
        }

        protected void Disaggregation2DropDown_SelectedIndexChanged(object sender, EventArgs e)
        {
            if ((Disaggregation2DropDown.SelectedValue == "new") && (!string.IsNullOrEmpty(disaglvl1field.Value)))
            {
                NewDisagLvl1Btn.Visible = false;
                NewDisagLvl2Btn.Visible = true;
                NewDisagLvl3Btn.Visible = false;

                ScriptManager.RegisterStartupScript(
                        Page,
                        Page.GetType(),
                        "newDisaggModal", "$('#newDisaggModal').modal('show');",
                        true);
                lvl3.Visible = false;
            }
            else if (Disaggregation2DropDown.SelectedItem.Value == "0")
            {
                lvl3.Visible = false;
            }
            else if ((int.Parse(Disaggregation2DropDown.SelectedItem.Value) > 0) && (!string.IsNullOrEmpty(disaglvl1field.Value)))
            {
                disaglvl2field.Value = Disaggregation2DropDown.SelectedItem.Value;

                LinqDataSource7.Where = string.Format("disaggregation_id == {0}",
                    disaglvl2field.Value);

                Disaggregation3DropDown.DataBind();
                lvl3.Visible = true;
            }
        }

        protected void Disaggregation2DropDown_DataBound(object sender, EventArgs e)
        {
            ListItem li_1 = new ListItem("None", "0", true);
            li_1.Selected = true;
            Disaggregation2DropDown.Items.Insert(0, li_1);

            ListItem li_2 = new ListItem("New Disaggregation", "new", true);
            Disaggregation2DropDown.Items.Insert(1, li_2);
        }

        protected void Disaggregation3DropDown_SelectedIndexChanged(object sender, EventArgs e)
        {
            if ((Disaggregation3DropDown.SelectedValue == "new") &&
                (!string.IsNullOrEmpty(disaglvl2field.Value)))
            {
                NewDisagLvl1Btn.Visible = false;
                NewDisagLvl2Btn.Visible = false;
                NewDisagLvl3Btn.Visible = true;

                ScriptManager.RegisterStartupScript(
                        Page,
                        Page.GetType(),
                        "newDisaggModal", "$('#newDisaggModal').modal('show');",
                        true);
            }
            else if ((int.Parse(Disaggregation3DropDown.SelectedItem.Value) > 0)
               && (!string.IsNullOrEmpty(disaglvl2field.Value)))
            {
                disaglvl3field.Value = Disaggregation3DropDown.SelectedItem.Value;
            }
        }

        protected void Disaggregation3DropDown_DataBound(object sender, EventArgs e)
        {
            ListItem li_1 = new ListItem("None", "0", true);
            li_1.Selected = true;
            Disaggregation3DropDown.Items.Insert(0, li_1);

            ListItem li_2 = new ListItem("New Disaggregation", "new", true);
            Disaggregation3DropDown.Items.Insert(1, li_2);
        }

        protected void NewDisagLvl1Btn_Click(object sender, EventArgs e)
        {
            disaggregation newDisag = new disaggregation();
            newDisag.disaggregation_name = DisaggregationTxBx.Text.Trim();

            db.disaggregations.Add(newDisag);

            db.SaveChanges();

            ScriptManager.RegisterStartupScript(
                        Page,
                        Page.GetType(),
                        "newDisaggModal", "$('#newDisaggModal').modal('hide');",
                        true);

            //Disaggregation1DropDown.DataSourceID = "LinqDataSource4";
            Disaggregation1DropDown.DataBind();
            Disaggregation1DropDown.ClearSelection();
            Disaggregation1DropDown.Items.FindByValue(newDisag.id.ToString()).Selected = true;
            Disaggregation1DropDown_SelectedIndexChanged(this, EventArgs.Empty);
        }

        protected void NewDisagLvl2Btn_Click(object sender, EventArgs e)
        {
            disaggregation newDisag = new disaggregation();
            newDisag.disaggregation_id = int.Parse(disaglvl1field.Value.Trim());
            newDisag.disaggregation_name = DisaggregationTxBx.Text.Trim();

            db.disaggregations.Add(newDisag);

            db.SaveChanges();

            ScriptManager.RegisterStartupScript(
                        Page,
                        Page.GetType(),
                        "newDisaggModal", "$('#newDisaggModal').modal('hide');",
                        true);

            LinqDataSource6.Where = string.Format("disaggregation_id == {0}",
                    disaglvl1field.Value);

            //Disaggregation2DropDown.DataSourceID = "LinqDataSource5";
            Disaggregation2DropDown.DataBind();
            Disaggregation2DropDown.ClearSelection();
            Disaggregation2DropDown.Items.FindByValue(newDisag.id.ToString()).Selected = true;
            Disaggregation2DropDown_SelectedIndexChanged(this, EventArgs.Empty);
        }

        protected void NewDisagLvl3Btn_Click(object sender, EventArgs e)
        {
            disaggregation newDisag = new disaggregation();
            newDisag.disaggregation_id = int.Parse(disaglvl2field.Value.Trim());
            newDisag.disaggregation_name = DisaggregationTxBx.Text.Trim();

            db.disaggregations.Add(newDisag);

            db.SaveChanges();

            ScriptManager.RegisterStartupScript(
                        Page,
                        Page.GetType(),
                        "newDisaggModal", "$('#newDisaggModal').modal('hide');",
                        true);

            LinqDataSource7.Where = string.Format("disaggregation_id == {0}",
                    disaglvl2field.Value);

            //Disaggregation2DropDown.DataSourceID = "LinqDataSource5";
            Disaggregation3DropDown.DataBind();
            Disaggregation3DropDown.ClearSelection();
            Disaggregation3DropDown.Items.FindByValue(newDisag.id.ToString()).Selected = true;
            Disaggregation3DropDown_SelectedIndexChanged(this, EventArgs.Empty);
        }
    }
}