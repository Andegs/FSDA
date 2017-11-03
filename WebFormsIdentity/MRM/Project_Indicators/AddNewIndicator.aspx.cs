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
    public partial class AddNewIndicator : System.Web.UI.Page
    {
        WebFormsIdentityDatabaseEntities db = new WebFormsIdentityDatabaseEntities();
        DataTable dt = new DataTable();
        DataTable disag_dt = new DataTable();

        DataTable temp = new DataTable();

        protected void Page_Load(object sender, EventArgs e)
        {
            //Add columns to DataTable.
            dt.Columns.AddRange(
                new DataColumn[9]
                {
                        new DataColumn("project"),
                        new DataColumn("project_id"),
                        new DataColumn("indicator_type"),
                        new DataColumn("indicator_type_id"),
                        new DataColumn("indicator"),
                        new DataColumn("target"),
                        new DataColumn("fsda_indicator_code_id"),
                        new DataColumn("fsda_indicator_code"),
                        new DataColumn("id")
                    });
            //Set AutoIncrement True for the First Column.
            dt.Columns["id"].AutoIncrement = true;

            //Set the Starting or Seed value.
            dt.Columns["id"].AutoIncrementSeed = 1;

            //Set the Increment value.
            dt.Columns["id"].AutoIncrementStep = 1;

            disag_dt.Columns.AddRange(
                new DataColumn[3]
                {
                    new DataColumn("disaggregation_id"),
                    //new DataColumn("disaggregation"),
                    new DataColumn("foreign_id"),
                    new DataColumn("id")
                });
            disag_dt.Columns["id"].AutoIncrement = true;
            disag_dt.Columns["id"].AutoIncrementSeed = 1;
            disag_dt.Columns["id"].AutoIncrementStep = 1;

            /*temp.Columns.AddRange(
                new DataColumn[2]
                {
                    new DataColumn("disaggregation"),
                    new DataColumn("foreign_id")
                });*/

            temp.Columns.AddRange(
                new DataColumn[2]
                {
                    new DataColumn("disaggregation_id"),
                    new DataColumn("foreign_id")
                });

            if (!IsPostBack)
            {
                ViewState["dt"] = dt;

                ViewState["disag_dt"] = disag_dt;

                temp.Clear();
                ViewState["temp"] = temp;

                this.BindGrid();

                EntityDataSource1.WhereParameters.Clear();
                EntityDataSource1.WhereParameters.Add("project_indicator_id", TypeCode.Int32, HiddenProjectIndicatorID.Value.Trim());
                GridView3.DataBind();
            }
        }
        
        protected void BindGrid()
        {
            /*DataTable _disag_dt = ViewState["disag_dt"] as DataTable;

            DataTable myDt = _disag_dt.Clone();

            DataRow[] dr = _disag_dt.Select(string.Format("id = {0}", id));

            foreach(DataRow row in dr)
            {
                myDt.ImportRow(row);
            }

            view.DataSource = myDt;
            view.DataBind(); 
             */

            DataTable newDT = ViewState["dt"] as DataTable;

            DataTable theDT = newDT.Clone();

            DataRow[] dr = newDT.Select();

            foreach(DataRow row in dr)
            {
                theDT.ImportRow(row);
            }

            if (theDT.Rows.Count <= 0)
            {
                indicatorsDatatableDiv.Visible = false;
            }
            else
            {
                indicatorsDatatableDiv.Visible = true;
            }

            GridView1.DataSource = theDT;
            GridView1.DataBind();


            /*DataTable newDT = ViewState["dt"] as DataTable;
            if (newDT.Rows.Count <= 0)
            {
                indicatorsDatatableDiv.Visible = false;
            }
            else
            {
                indicatorsDatatableDiv.Visible = true;
            }
            GridView1.DataSource = newDT;
            GridView1.DataBind();*/
        }

        protected void addIndicator_Click(object sender, EventArgs e)
        {
            int projectId = int.Parse(implementingPartner.SelectedValue.Trim());
            int indicatorTypeId = int.Parse(indicatorType.SelectedValue.Trim());
            int fsdaIndicatorCodeId = int.Parse(fsdaIndicatorList.SelectedValue.Trim());
            string indicator = indicator_text.Value.Trim();
            string target = indicator_target.Value.Trim();

            //partner_indicators newIndicator = new partner_indicators();
            //newIndicator.implementing_partner_id = projectId;
            //newIndicator.indicator_type_id = indicatorTypeId;
            //newIndicator.indicator = indicator;

            //db.partner_indicators.Add(newIndicator);
            //db.SaveChanges();

            DataTable _dt = ViewState["dt"] as DataTable;
            DataRow dr = _dt.NewRow();

            dr[0] = implementingPartner.SelectedItem.Text.Trim();
            dr[1] = projectId;
            dr[2] = indicatorType.SelectedItem.Text.Trim();
            dr[3] = indicatorTypeId;
            dr[4] = indicator;
            dr[5] = target;
            dr[6] = fsdaIndicatorCodeId;
            dr[7] = fsdaIndicatorList.SelectedItem.Text.Trim();

            _dt.Rows.Add(dr);
            ViewState["dt"] = _dt;

            this.BindGrid();
        }

        protected void GridView1_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            DataTable _dt = ViewState["dt"] as DataTable;
            _dt.Rows.RemoveAt(e.RowIndex);
            ViewState["dt"] = _dt;
            this.BindGrid();
        }

        protected void saveUpdateIndicatorsBtn_Click(object sender, EventArgs e)
        {
            //Simple test to check loading progress in any delay
            //System.Threading.Thread.Sleep(5000);

            //Save the datatable to the database
            DataTable _dt = ViewState["dt"] as DataTable;

            DataTable _disag_dt = ViewState["disag_dt"] as DataTable;

            if (_dt.Rows.Count > 0)
            {
                foreach (DataRow row in _dt.Rows)
                {
                    partner_indicators newIndicator = new partner_indicators();
                    newIndicator.project_id = int.Parse(row["project_id"].ToString());
                    newIndicator.indicator_type_id = int.Parse(row["indicator_type_id"].ToString());
                    newIndicator.indicator = row["indicator"].ToString();
                    newIndicator.target = row["target"].ToString();
                    if (int.Parse(row["fsda_indicator_code_id"].ToString()) != 0)
                    {
                        newIndicator.fsda_indicator_id = int.Parse(row["fsda_indicator_code_id"].ToString());
                    }

                    db.partner_indicators.Add(newIndicator);
                    
                    if (_disag_dt.Rows.Count > 0)
                    {
                        foreach (DataRow disagRow in _disag_dt.Rows)
                        {
                            /*indicator_disaggregation newDisaggregation = new indicator_disaggregation();
                            newDisaggregation.partner_indicators = newIndicator;
                            newDisaggregation.disaggregation = disagRow["disaggregation"].ToString();

                            db.indicator_disaggregation.Add(newDisaggregation);*/

                            if (disagRow["foreign_id"].ToString() == row["id"].ToString())
                            {
                                project_indicator_disaggregation newDisaggregation = new project_indicator_disaggregation();
                                newDisaggregation.partner_indicators = newIndicator;
                                newDisaggregation.disaggregation_id = int.Parse(disagRow["disaggregation_id"].ToString());

                                db.project_indicator_disaggregation.Add(newDisaggregation);
                            }
                        }
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
                    AlertLabel.Text = _dt.Rows.Count.ToString() + " indicator(s) and " +
                        _disag_dt.Rows.Count + " disaggratation(s) added to the database successfully!";
                    
                    ScriptManager.RegisterStartupScript(
                        Page,
                        Page.GetType(),
                        "alertModal", "$('#alertModal').modal('show');",
                        true);
                }
            }
        }

        protected void GridView1_RowEditing(object sender, GridViewEditEventArgs e)
        {
            GridView1.EditIndex = e.NewEditIndex;
            this.BindGrid();
        }

        protected void GridView1_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            GridViewRow row = GridView1.Rows[e.RowIndex];

            int projectId = int.Parse((row.FindControl("_implementingPartner") as DropDownList).SelectedValue.Trim());
            int indicatorTypeId = int.Parse((row.FindControl("_indicatorType") as DropDownList).SelectedValue.Trim());
            int fsdaIndicatorCodeId = int.Parse((row.FindControl("_fsdaIndicatorList") as DropDownList).SelectedValue.Trim());
            string indicator = (row.FindControl("_indicator_text") as TextBox).Text.Trim();
            string target = (row.FindControl("_indicator_target") as TextBox).Text.Trim();

            DataTable _dt = ViewState["dt"] as DataTable;
            _dt.Rows[row.RowIndex]["project"] = (row.FindControl("_implementingPartner") as DropDownList).SelectedItem.Text.Trim();
            _dt.Rows[row.RowIndex]["project_id"] = projectId;
            _dt.Rows[row.RowIndex]["indicator_type"] = (row.FindControl("_indicatorType") as DropDownList).SelectedItem.Text.Trim();
            _dt.Rows[row.RowIndex]["indicator_type_id"] = indicatorTypeId;
            _dt.Rows[row.RowIndex]["indicator"] = indicator;
            _dt.Rows[row.RowIndex]["target"] = target;
            _dt.Rows[row.RowIndex]["fsda_indicator_code_id"] = fsdaIndicatorCodeId;
            _dt.Rows[row.RowIndex]["fsda_indicator_code"] = (row.FindControl("_fsdaIndicatorList") as DropDownList).SelectedItem.Text.Trim();

            ViewState["dt"] = _dt;
            GridView1.EditIndex = -1;
            this.BindGrid();
        }

        protected void okButton_Click(object sender, EventArgs e)
        {
            ViewState["dt"] = null;
            Response.Redirect(Request.RawUrl);
        }

        protected void GridView1_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            GridView1.EditIndex = -1;
            this.BindGrid();
        }

        protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            //Get the selected Row index
            int currentRowIndex = Convert.ToInt32(e.CommandArgument);
            //Get the selected Row
            //GridViewRow row = GridView1.Rows[currentRowIndex];

            if(e.CommandName == "disaggregate")
            {
                DataTable _dt = ViewState["dt"] as DataTable;

                ModalHeaderLabel.Text = _dt.Rows[currentRowIndex]["indicator"].ToString();
                HiddenProjectIndicatorID.Value = _dt.Rows[currentRowIndex]["id"].ToString();

                GridView3.DataBind();

                ScriptManager.RegisterStartupScript(
                    Page,
                    Page.GetType(),
                    "disaggragateModal", "$('#disaggragateModal').modal('show');",
                    true);
            }
        }

        string viewUniqueID = string.Empty;
        int viewEditIndex = -1;
        protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            //For Re Exapnding the expanded rows
            foreach (GridViewRow row in GridView1.Rows)
            {
                if (row.RowType == DataControlRowType.DataRow)
                {
                    HiddenField IsExpanded = row.FindControl("IsExpanded") as HiddenField;
                    IsExpanded.Value = Request.Form[IsExpanded.UniqueID];
                }
            }

            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                string F_ID = GridView1.DataKeys[e.Row.RowIndex].Value.ToString();
                GridView view = new GridView();
                view = e.Row.FindControl("GridView2") as GridView;
                //UpdatePanel myPanel = e.Row.FindControl("UpdatePanel2") as UpdatePanel;
                
                if (view.UniqueID == viewUniqueID)
                {
                    view.EditIndex = viewEditIndex;
                }

                if (view != null)
                {
                    BindNestedGrid(view, int.Parse(F_ID));
                    //myPanel.Update();
                }
            }
        }

        protected void BindNestedGrid(GridView view, int id)
        {
            DataTable _disag_dt = ViewState["disag_dt"] as DataTable;

            DataTable myDt = _disag_dt.Clone();

            DataRow[] dr = _disag_dt.Select(string.Format("foreign_id = {0}", id));

            if (dr.Any())
            {
                foreach (DataRow row in dr)
                {
                    myDt.ImportRow(row);
                }

                if (myDt != null)
                {
                    view.DataSource = myDt;
                    view.DataBind();
                }
            }
        }

        /*protected void OkBtn_Click(object sender, EventArgs e)
        {
            try
            {
                DataTable myDt = ViewState["temp"] as DataTable;

                DataRow dr = myDt.NewRow();

                dr[0] = DisaggregationTextBox.Text.Trim();
                dr[1] = HiddenProjectIndicatorID.Value;

                myDt.Rows.Add(dr);

                ViewState["temp"] = myDt;
                GridView3.DataSource = myDt;
                GridView3.DataBind();
            }
            catch
            {
                throw new Exception();
            }
            finally
            {
                SaveDisaggregationBtn.Visible = true;
                DisaggregationTextBox.Text = string.Empty;
            }
        }*/
        
        /*protected void SaveDisaggregationBtn_Click(object sender, EventArgs e)
        {
            DataTable _disag_dt = ViewState["disag_dt"] as DataTable;

            DataTable myDt = ViewState["temp"] as DataTable;
            if (myDt.Rows.Count > 0)
            {
                foreach (DataRow row in myDt.Rows)
                {
                    _disag_dt.ImportRow(row);
                }

                ViewState["disag_dt"] = _disag_dt;
                this.BindGrid();

                //Clear Evrything
                myDt.Clear();
                ViewState["temp"] = myDt;

                //Clear the modal gridview datasource
                GridView3.DataSource = myDt;
                GridView3.DataBind();


                SaveDisaggregationBtn.Visible = false;

                //test code
                foreach (GridViewRow row in GridView1.Rows)
                {
                    GridView1.DataBind();
                    GridView view = row.FindControl("GridView2") as GridView;
                    view.DataBind();
                }
            }
        }*/

        protected void GridView2_RowEditing(object sender, GridViewEditEventArgs e)
        {
            GridView view = sender as GridView;
            viewUniqueID = view.UniqueID;
            viewEditIndex = e.NewEditIndex;
            this.BindGrid();
        }

        protected void GridView2_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            GridView view = sender as GridView;
            viewUniqueID = view.UniqueID;
            viewEditIndex = -1;
            this.BindGrid();
        }

        protected void GridView2_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            //DO some updating
            GridView view = sender as GridView;

            GridViewRow row = view.Rows[e.RowIndex];

            int ID = Convert.ToInt32(view.DataKeys[e.RowIndex].Value);

            string _disaggregation = (row.FindControl("_disaggregation") as TextBox).Text.Trim();
            string disaggregation = _disaggregation.Substring(_disaggregation.LastIndexOf(",") + 1);

            DataTable _dt = ViewState["disag_dt"] as DataTable;
            DataRow[] dr = _dt.Select(string.Format("id = {0}", ID));
            if(dr.Any() && dr.Count() == 1)
            {
                foreach(DataRow _row in dr)
                {
                    _row["disaggregation"] = disaggregation;
                }
            }

            ViewState["disag_dt"] = _dt;

            //Reset EditIndex
            viewEditIndex = -1;
            this.BindGrid();
        }

        protected void GridView2_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            //Do some deleting
            GridView view = sender as GridView;

            GridViewRow row = view.Rows[e.RowIndex];

            int ID = Convert.ToInt32(view.DataKeys[e.RowIndex].Value);

            DataTable _dt = ViewState["disag_dt"] as DataTable;
            DataRow[] dr = _dt.Select(string.Format("id = {0}", ID));
            if (dr.Any() && dr.Count() == 1)
            {
                foreach (DataRow _row in dr)
                {
                    _row.Delete();
                }
            }

            ViewState["disag_dt"] = _dt;

            this.BindGrid();
        }

        protected void indicatorType_SelectedIndexChanged(object sender, EventArgs e)
        {
            if(indicatorType.SelectedValue.ToString() == "1")
            {
                NumberResultValidator.Enabled = true;
            }
            else
            {
                NumberResultValidator.Enabled = false;
            }
        }

        protected void GridView3_RowEditing(object sender, GridViewEditEventArgs e)
        {
            GridView3.EditIndex = e.NewEditIndex;

            GridView3.DataSource = ViewState["temp"];
            GridView3.DataBind();
        }

        protected void GridView3_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            GridView3.EditIndex = -1;

            GridView3.DataSource = ViewState["temp"];
            GridView3.DataBind();
        }

        protected void GridView3_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            GridViewRow row = GridView3.Rows[e.RowIndex];
            
            string disaggregation = (row.FindControl("TextBox1") as TextBox).Text.Trim();

            DataTable myDt = ViewState["temp"] as DataTable;
            myDt.Rows[row.RowIndex]["disaggregation"] = disaggregation;

            ViewState["temp"] = myDt;
            GridView3.EditIndex = -1;
            GridView3.DataSource = ViewState["temp"];
            GridView3.DataBind();
        }

        protected void GridView3_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            DataTable theDt = ViewState["temp"] as DataTable;
            theDt.Rows.RemoveAt(e.RowIndex);
            ViewState["temp"] = theDt;

            GridView3.DataSource = ViewState["temp"];
            GridView3.DataBind();

            if((ViewState["temp"] as DataTable).Rows.Count == 0)
            {
                SaveDisaggregationBtn.Visible = false;
            }
        }


        //=============================Begin Section Test================================
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
                
                LinqDataSource5.Where = string.Format("disaggregation_id == {0}",
                    Disaggregation1DropDown.SelectedItem.Value);

                Disaggregation2DropDown.DataBind();
                lvl2.Visible = true;
            }
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
                
                LinqDataSource6.Where = string.Format("disaggregation_id == {0}",
                    disaglvl2field.Value);

                Disaggregation3DropDown.DataBind();
                lvl3.Visible = true;
            }
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

            LinqDataSource5.Where = string.Format("disaggregation_id == {0}",
                    disaglvl1field.Value);

            //Disaggregation2DropDown.DataSourceID = "LinqDataSource5";
            Disaggregation2DropDown.DataBind();
            Disaggregation2DropDown.ClearSelection();
            Disaggregation2DropDown.Items.FindByValue(newDisag.id.ToString()).Selected = true;
            Disaggregation2DropDown_SelectedIndexChanged(this, EventArgs.Empty);
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

            LinqDataSource6.Where = string.Format("disaggregation_id == {0}",
                    disaglvl2field.Value);

            //Disaggregation2DropDown.DataSourceID = "LinqDataSource5";
            Disaggregation3DropDown.DataBind();
            Disaggregation3DropDown.ClearSelection();
            Disaggregation3DropDown.Items.FindByValue(newDisag.id.ToString()).Selected = true;
            Disaggregation3DropDown_SelectedIndexChanged(this, EventArgs.Empty);
        }

        protected void OkBtn_Click(object sender, EventArgs e)
        {
            try
            {
                if (Disaggregation3DropDown.SelectedItem.Value == "0" 
                    || Disaggregation3DropDown.SelectedItem.Value == "new")
                {
                    if(Disaggregation2DropDown.SelectedItem.Value == "0"
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
                            int projIndicatorId = int.Parse(HiddenProjectIndicatorID.Value.Trim());
                            int disagId = int.Parse(Disaggregation1DropDown.SelectedItem.Value.Trim());
                            /*var tData = from data in db.project_indicator_disaggregation
                                        where data.project_indicator_id == projIndicatorId
                                        && data.disaggregation_id == disagId
                                        select data;
                            if (tData.Count() == 0)
                            {
                                project_indicator_disaggregation newDis = new project_indicator_disaggregation();
                                newDis.project_indicator_id = int.Parse(HiddenProjectIndicatorID.Value.Trim());
                                newDis.disaggregation_id = int.Parse(Disaggregation1DropDown.SelectedItem.Value.Trim());
                                db.project_indicator_disaggregation.Add(newDis);
                            }*/

                            DataTable myDt = ViewState["temp"] as DataTable;

                            DataRow dr = myDt.NewRow();

                            dr[0] = disagId;
                            dr[1] = projIndicatorId;

                            myDt.Rows.Add(dr);

                            ViewState["temp"] = myDt;
                            GridView3.DataSource = myDt;
                            GridView3.DataBind();
                        }
                    }
                    else
                    {
                        //Save the second disagr
                        int projIndicatorId = int.Parse(HiddenProjectIndicatorID.Value.Trim());
                        int disagId = int.Parse(Disaggregation2DropDown.SelectedItem.Value.Trim());
                        /*var tData = from data in db.project_indicator_disaggregation
                                    where data.project_indicator_id == projIndicatorId
                                    && data.disaggregation_id == disagId
                                    select data;
                        if (tData.Count() == 0)
                        {
                            project_indicator_disaggregation newDis = new project_indicator_disaggregation();
                            newDis.project_indicator_id = int.Parse(HiddenProjectIndicatorID.Value.Trim());
                            newDis.disaggregation_id = int.Parse(Disaggregation2DropDown.SelectedItem.Value.Trim());
                            db.project_indicator_disaggregation.Add(newDis);
                        }*/

                        DataTable myDt = ViewState["temp"] as DataTable;

                        DataRow dr = myDt.NewRow();

                        dr[0] = disagId;
                        dr[1] = projIndicatorId;

                        myDt.Rows.Add(dr);

                        ViewState["temp"] = myDt;
                        GridView3.DataSource = myDt;
                        GridView3.DataBind();
                    }
                }
                else
                {
                    //Save the thrid disagrr
                    int projIndicatorId = int.Parse(HiddenProjectIndicatorID.Value.Trim());
                    int disagId = int.Parse(Disaggregation3DropDown.SelectedItem.Value.Trim());
                    /*var tData = from data in db.project_indicator_disaggregation
                                where data.project_indicator_id == projIndicatorId
                                && data.disaggregation_id == disagId
                                select data;
                    if (tData.Count() == 0)
                    {
                        project_indicator_disaggregation newDis = new project_indicator_disaggregation();
                        newDis.project_indicator_id = int.Parse(HiddenProjectIndicatorID.Value.Trim());
                        newDis.disaggregation_id = int.Parse(Disaggregation3DropDown.SelectedItem.Value.Trim());
                        db.project_indicator_disaggregation.Add(newDis);
                    }*/

                    DataTable myDt = ViewState["temp"] as DataTable;

                    DataRow dr = myDt.NewRow();

                    dr[0] = disagId;
                    dr[1] = projIndicatorId;

                    myDt.Rows.Add(dr);

                    ViewState["temp"] = myDt;
                    GridView3.DataSource = myDt;
                    GridView3.DataBind();
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
            finally
            {
                /*if(db.SaveChanges() > 0)
                {
                    db.SaveChanges();

                    EntityDataSource1.WhereParameters.Clear();
                    EntityDataSource1.WhereParameters.Add("project_indicator_id", TypeCode.Int32, HiddenProjectIndicatorID.Value.Trim());
                    GridView3.DataBind();
                }*/

                SaveDisaggregationBtn.Visible = true;
            }
        }

        protected void SaveDisaggregationBtn_Click(object sender, EventArgs e)
        {
            DataTable _disag_dt = ViewState["disag_dt"] as DataTable;

            DataTable myDt = ViewState["temp"] as DataTable;
            if (myDt.Rows.Count > 0)
            {
                foreach (DataRow row in myDt.Rows)
                {
                    _disag_dt.ImportRow(row);
                }

                ViewState["disag_dt"] = _disag_dt;
                this.BindGrid();

                //Clear Evrything
                myDt.Clear();
                ViewState["temp"] = myDt;

                //Clear the modal gridview datasource
                GridView3.DataSource = myDt;
                GridView3.DataBind();


                SaveDisaggregationBtn.Visible = false;

                //test code
                foreach (GridViewRow row in GridView1.Rows)
                {
                    GridView1.DataBind();
                    GridView view = row.FindControl("GridView2") as GridView;
                    view.DataBind();
                }
            }
        }

        protected void GridView3_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if(e.Row.RowType == DataControlRowType.DataRow)
            {
                if (!string.IsNullOrEmpty(HiddenProjectIndicatorID.Value))
                {
                    Label lbl = (Label)e.Row.FindControl("Label6");
                    int disaggregationId = int.Parse(((Label)e.Row.FindControl("Label5")).Text);
                    lbl.Text = displayDisaggregation(disaggregationId);
                }
            }
        }

        public string displayDisaggregation(int disaggregationId)
        {
            /*var indi = (from data in db.project_indicator_disaggregation
                        where data.project_indicator_id == indicator_id
                        && data.id == id
                        select data).Single();*/


            string text = string.Empty;

            var _dat = (from data in db.disaggregations
                    where data.id == disaggregationId
                    select data).Single();

            
            System.Text.StringBuilder sData = new System.Text.StringBuilder();
            int? myId = _dat.disaggregation_id;

            sData.Insert(0, _dat.disaggregation_name);

            while (myId != null)
            {
                var _datq = (from data in db.disaggregations
                             where data.id == myId
                             select data).Single();

                myId = _datq.disaggregation_id;
                sData.Insert(0, _datq.disaggregation_name + " > ");
            }
            text += sData;
            return text;
        }

        protected void GridView2_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                Label lbl = (Label)e.Row.FindControl("Label6");
                int disaggregationId = int.Parse(lbl.Text);
                lbl.Text = displayDisaggregation(disaggregationId);
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

        protected void Disaggregation2DropDown_DataBound(object sender, EventArgs e)
        {
            ListItem li_1 = new ListItem("None", "0", true);
            li_1.Selected = true;
            Disaggregation2DropDown.Items.Insert(0, li_1);

            ListItem li_2 = new ListItem("New Disaggregation", "new", true);
            Disaggregation2DropDown.Items.Insert(1, li_2);
        }

        protected void Disaggregation3DropDown_DataBound(object sender, EventArgs e)
        {
            ListItem li_1 = new ListItem("None", "0", true);
            li_1.Selected = true;
            Disaggregation3DropDown.Items.Insert(0, li_1);

            ListItem li_2 = new ListItem("New Disaggregation", "new", true);
            Disaggregation3DropDown.Items.Insert(1, li_2);
        }
    }
}