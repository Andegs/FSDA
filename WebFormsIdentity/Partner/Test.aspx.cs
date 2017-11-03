using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using WebFormsIdentity.Report_Control;
using WebFormsIdentity.Data_Access;
using System.Data;

namespace WebFormsIdentity.Partner
{
    public partial class Test : System.Web.UI.Page
    {
        WebFormsIdentityDatabaseEntities db = new WebFormsIdentityDatabaseEntities();

        protected void Page_Load(object sender, EventArgs e)
        {
            /*myUC.RefImplementingPartner = 1;
            myUC.RefReportPeriod = 22;
            myUC.RefYear = 3;*/

            /*ReportControl savedReport = new ReportControl();
            savedReport.ReportId = int.Parse(Request.QueryString["reportID"]);*/

            //myUC.ReportId = int.Parse(Request.QueryString["reportID"]);
            if (!IsPostBack)
            {
                List<disaggregation> _disagData = (from data in db.disaggregations
                                                   where data.disaggregation_id == null
                                                   select data).ToList();

                this.PopulateTreeView(_disagData, null, null);

                Label1.Text = display(13);
            }
        }

        private void PopulateTreeView(List<disaggregation> parentList, int? parentId, TreeNode treeNode)
        {
            foreach (var disagData in parentList)
            {
                TreeNode child = new TreeNode
                {
                    Text = disagData.disaggregation_name,
                    Value = disagData.id.ToString(),
                    ToolTip = disagData.id.ToString()
                };

                var _data2 = (from data in db.disaggregations
                              where data.disaggregation_id == disagData.id
                              select data).ToList();

                if (parentId == null)
                {
                    TreeView1.Nodes.Add(child);

                    PopulateTreeView(_data2, disagData.id, child);

                }
                else
                {
                    treeNode.ChildNodes.Add(child);

                    foreach (var myData in _data2)
                    {
                        TreeNode myChild = new TreeNode
                        {
                            Text = myData.disaggregation_name,
                            Value = myData.id.ToString(),
                            ToolTip = "3rd level " + myData.id.ToString()
                        };

                        var _data3 = (from data in db.disaggregations
                                      where data.disaggregation_id == myData.id
                                      select data).ToList();

                        PopulateTreeView(_data3, myData.id, myChild);

                        child.ChildNodes.Add(myChild);
                    }
                }
            }
        }

        private string display(int indicator_id)
        {
            var _indi = from data in db.project_indicator_disaggregation
                        where data.project_indicator_id == indicator_id
                        select data;


            string text = string.Empty;
            int res = 0;

            foreach (var indi in _indi)
            {
                //Check if there are any results
                var results = (from data in db.project_indicator_disaggregation_result
                               where data.project_indicator_disaggregation_id == indi.id
                               select data);
                if (results != null)
                {
                    foreach (var result in results)
                    {
                        var _dat = (from data in db.disaggregations
                                    where data.id == result.project_indicator_disaggregation.disaggregation_id
                                    select data).Single();
                        
                        System.Text.StringBuilder sData = new System.Text.StringBuilder();
                        int? myId = _dat.disaggregation_id;
                        //res = int.Parse(result.disaggregation_result);

                        sData.Insert(0, _dat.disaggregation_name);

                        //If this is not the parent, loop
                        while (myId != null)
                        {
                            var _datq = (from data in db.disaggregations
                                         where data.id == myId
                                         select data).Single();

                            myId = _datq.disaggregation_id;
                            res += int.Parse(result.disaggregation_result);
                            sData.Insert(0, _datq.disaggregation_name + " > ");
                        }
                        //sData.AppendLine().Append(" || ").AppendLine();
                        text += sData + " || ";
                    }
                }
            }

            return text;
        }

        /*private void PopulateTreeView(List<disaggregation> parentList, int? parentId, TreeNode treeNode)
        {
            foreach(var disagData in parentList)
            {
                TreeNode child = new TreeNode
                {
                    Text = disagData.disaggregation_name,
                    Value = disagData.id.ToString(),
                    ToolTip = disagData.id.ToString()
                };

                var _data2 = (from data in db.disaggregations
                              where data.disaggregation_id == disagData.id
                              select data).ToList();

                if (parentId == null)
                {
                    TreeView1.Nodes.Add(child);
                    
                    PopulateTreeView(_data2, disagData.id, child);
                    
                }
                else
                {
                    treeNode.ChildNodes.Add(child);

                    foreach (var myData in _data2)
                    {
                        TreeNode myChild = new TreeNode
                        {
                            Text = myData.disaggregation_name,
                            Value = myData.id.ToString(),
                            ToolTip = "3rd level " + myData.id.ToString()
                        };
                        
                        var _data3 = (from data in db.disaggregations
                                      where data.disaggregation_id == myData.id
                                      select data).ToList();

                        PopulateTreeView(_data3, myData.id, myChild);
                        
                        child.ChildNodes.Add(myChild);
                    }
                }
            }
        }*/

        /*private string display(int indicator_id)
        {
            var _indi = from data in db.project_indicator_disaggregation
                       where data.project_indicator_id == indicator_id
                       select data;

            
            string text = string.Empty;

            foreach (var indi in _indi)
            {
                var _dat = (from data in db.disaggregations
                           where data.id == indi.disaggregation_id
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
                //sData.AppendLine().Append(" || ").AppendLine();
                text += sData + " || ";
            }

            return text;
        }*/

        protected void FSUpload_UploadedComplete(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e)
        {
            string fileName = System.IO.Path.GetFileName(FSUpload.FileName);
            FSUpload.SaveAs(Server.MapPath("ReportUploads/") + fileName);
        }
    }
}