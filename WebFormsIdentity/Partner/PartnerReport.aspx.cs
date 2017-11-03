using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Net.Security;
using System.Security;
using System.Security.Claims;
using System.Security.Cryptography.X509Certificates;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using WebFormsIdentity.Data_Access;
using WebFormsIdentity.Report_Control;

namespace WebFormsIdentity.Partner
{
    public partial class PartnerReport : System.Web.UI.Page
    {
        WebFormsIdentityDatabaseEntities db = new WebFormsIdentityDatabaseEntities();

        int reportID;
        protected void Page_Load(object sender, EventArgs e)
        {
            reportID = int.Parse(Request.QueryString["reportID"]);
            var headerData = (from data
                             in db.partner_reports
                              where data.partner_report_id == reportID
                              && data.saved == true
                              select new
                              {
                                  data.project.project_name,
                                  data.report_periods.period,
                                  data.year.year1
                              }).FirstOrDefault();

            if (headerData != null)
            {
                HeaderLabel.Text = headerData.project_name + " report for the period - (" + headerData.period + ") - " + headerData.year1;

                //Pass this ID to the user control
                myUC.ReportId = reportID;

                myUC.sendCount += delegate (int myCount)
                {
                    NumberOfSectionsFilled.Value = myCount.ToString();
                };
                
            }
            else
            {
                Response.Redirect("~/Partner/CreatedPartnerReports.aspx", true);
            }
            
        }

        protected void SubmitPartnerReportBtn_Click(object sender, EventArgs e)
        {
            if(int.Parse(NumberOfSectionsFilled.Value) == 7)
            {
                //Submit the report and and go back to the reports list
                try
                {
                    partner_reports report = db.partner_reports.SingleOrDefault(
                        data => data.partner_report_id == reportID);

                    report.saved = false;
                    report.submitted = true;

                    //Send and Email here. Pick overall assessment and conclusion
                    //as email body.
                    /*
                     1. Check the user project
                     2. Check for the pillar for the project
                     3. Check all the users under that pillar
                     4. Create email body and content
                     5. Send report submission email to pillar users
                     */
                    var userIds = from data in db.AspNetUserClaims
                                  where data.ClaimValue == report.project.pillar_id.ToString()
                                  && data.ClaimType == "Pillar"
                                  select data.UserId;

                    UserManager<IdentityUser> manager = new UserManager<IdentityUser>(
                        new UserStore<IdentityUser>());

                    foreach (var userId in userIds)
                    {
                        IdentityUser user = manager.FindById(userId);
                        if(user.Email != null || !(string.IsNullOrEmpty(user.Email)))
                        {
                            //===============================
                            //          send email          |
                            //===============================

                            //Create the mail message
                            MailMessage mail = new MailMessage();

                            //Add the Addresses
                            mail.To.Add(user.Email.Trim());

                            //Set the content
                            mail.Subject = "MRM: Quarterly Report Submitted";

                            System.Text.StringBuilder sBuilder = new System.Text.StringBuilder();
                            sBuilder.Append("Dear " + report.project.pillar.name + " Team,")
                                .AppendLine().AppendLine();
                            sBuilder.Append("Note that the ");
                            sBuilder.Append(report.project.implementing_partner.Trim() + " " +
                                report.report_periods.period_name.Trim() + " " +
                                report.year.year1.ToString());
                            sBuilder.Append(" quarterly report has been submitted to you for review and approval.")
                                .AppendLine().AppendLine();

                            var overallAss = (from data in db.project_overall_rating
                                              where data.partner_report_id == report.partner_report_id
                                              select new
                                              {
                                                  data.project_rating.rating,
                                                  data.comment
                                              }).SingleOrDefault();
                            if(overallAss != null)
                            {
                                sBuilder.Append("Project Rating : " + overallAss.rating).AppendLine();
                                sBuilder.Append("Commentary: " + overallAss.comment).AppendLine().AppendLine();
                            }
                            sBuilder.Append("You can access the report here: http://results.fsdafrica.org ").AppendLine().AppendLine();
                            sBuilder.Append("*This email is automatically generated - please do not reply").AppendLine();

                            mail.Body = sBuilder.ToString();

                            //Preparation to send the message
                            SmtpClient smtp = new SmtpClient();
                            /****SMTP Client should be defined in the Web.Config File****/

                            ServicePointManager.ServerCertificateValidationCallback = delegate (
                                  object s, X509Certificate certificate, X509Chain chain,
                                  SslPolicyErrors sslPolicyErrors)
                              { return true; }; //Always Accept
                            try
                            {
                                //Send the message
                                smtp.Send(mail);
                            }
                            catch(Exception ex)
                            {
                                AlertLabel.Text = "Notification Mail not sent " + ex.Message;

                                ScriptManager.RegisterStartupScript(
                                        Page,
                                        Page.GetType(),
                                        "alertModal", "$('#alertModal').modal('show');",
                                        true);

                                return;
                            }
                        }
                    }

                    if (db.SaveChanges() > 0)
                    {
                        db.SaveChanges();
                    }

                    //Redirect
                    Response.Redirect("~/Partner/CreatedPartnerReports.aspx", true);

                }
                catch (Exception ex)
                {
                    //throw new Exception();
                    AlertLabel.Text = ex.Message +" : "+ ex.InnerException;

                    ScriptManager.RegisterStartupScript(
                        Page,
                        Page.GetType(),
                        "alertModal", "$('#alertModal').modal('show');",
                        true);
                }
            }
            else
            {
                AlertLabel.Text = "You cannot Submit this report. It is incomplete";

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