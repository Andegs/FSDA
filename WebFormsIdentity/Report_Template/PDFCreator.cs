using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

using WebFormsIdentity.Data_Access;
using Microsoft.Reporting.WebForms;
using System.Data;

namespace WebFormsIdentity.Report_Template
{
    public partial class PDFCreator : System.Web.UI.Page
    {
        WebFormsIdentityDatabaseEntities db = new WebFormsIdentityDatabaseEntities();
        ReportData_DataSet rdb = new ReportData_DataSet();

        public void createPDF(int partnerReportID)
        {
            /*var tst = from data in rdb.DataTable_ReportData
                      where data.partner_report_id == partnerReportID
                      select data;*/

            var reportData = from data in db.Report_Data_View
                             where data.partner_report_id == partnerReportID
                             select data;

            /*var reportAchievements = from data in db.partner_reports
                                     where data.partner_report_id == partnerReportID
                                     select data;*/

            var reportChallenges = from data in db.partner_challenges
                                   where data.partner_report_id == partnerReportID
                                   select data;

            var reportConclusion = from data in db.project_overall_rating
                                   where data.partner_report_id == partnerReportID
                                   select new
                                   {
                                       data.comment,
                                       data.project_rating.rating,
                                       data.project_rating.rating_id
                                   };

            //ReportData_DataSet testSet = new ReportData_DataSet();
            ReportData_DataSetTableAdapters.DataTable2TableAdapter testAdapter =
                new ReportData_DataSetTableAdapters.DataTable2TableAdapter();
            DataTable dt = new DataTable();
            dt = testAdapter.GetDataByPartnerReportId(partnerReportID);

            ReportData_DataSetTableAdapters.DataTable3TableAdapter riskAdapter =
                new ReportData_DataSetTableAdapters.DataTable3TableAdapter();
            DataTable riskDt = new DataTable();
            riskDt = riskAdapter.GetDataByPartnerReportId(partnerReportID);

            ReportData_DataSetTableAdapters.partner_reportsTableAdapter narrativeReportAdapter =
                new ReportData_DataSetTableAdapters.partner_reportsTableAdapter();
            DataTable reportAchievementsDt = new DataTable();
            reportAchievementsDt = narrativeReportAdapter.GetDataByPartnerReportId(partnerReportID);

            ReportViewer viewer = new ReportViewer();
            ReportDataSource datasource1 = new ReportDataSource("DataSet_ReportData", reportData);
            ReportDataSource dataSource2 = new ReportDataSource("DataSet1", reportAchievementsDt);
            ReportDataSource datasource3 = new ReportDataSource("DataSet2", reportChallenges);
            ReportDataSource datasource4 = new ReportDataSource("ProjectRating_DataSet", reportConclusion);
            ReportDataSource dataSource5 = new ReportDataSource("DataSet4", dt);
            ReportDataSource dataSource6 = new ReportDataSource("RiskDataSet", riskDt);
            viewer.LocalReport.DataSources.Add(datasource1);
            viewer.LocalReport.DataSources.Add(dataSource2);
            viewer.LocalReport.DataSources.Add(datasource3);
            viewer.LocalReport.DataSources.Add(datasource4);
            viewer.LocalReport.DataSources.Add(dataSource5);
            viewer.LocalReport.DataSources.Add(dataSource6);
            viewer.LocalReport.ReportPath = "Report_Template/Q_Report.rdlc";
            viewer.LocalReport.EnableHyperlinks = true;

            Warning[] warnings;
            string[] streamIds;
            string mimeType = string.Empty;
            string encoding = string.Empty;
            string extension = "pdf";
            string fileName = "Example";

            byte[] bytes = viewer.LocalReport.Render("PDF", null, out mimeType, out encoding, out extension, out streamIds, out warnings);

            //After getting the bytes representing the PDF report, buffer it and send it to the client.
            HttpContext.Current.Response.Buffer = true;
            HttpContext.Current.Response.Clear();
            HttpContext.Current.Response.ClearContent();
            HttpContext.Current.Response.ClearHeaders();
            HttpContext.Current.Response.AppendHeader("Content-Length", bytes.Length.ToString());
            HttpContext.Current.Response.ContentType = mimeType;
            HttpContext.Current.Response.AddHeader("content-disposition", "attachment;filename=" + fileName + "." + extension);
            HttpContext.Current.Response.BinaryWrite(bytes); //Create the file
            HttpContext.Current.Response.End();
            HttpContext.Current.Response.Close();
            HttpContext.Current.Response.Flush(); //Send to client for download
        }
    }
}