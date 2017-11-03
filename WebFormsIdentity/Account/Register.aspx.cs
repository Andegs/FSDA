using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using Microsoft.Owin.Security;
using WebFormsIdentity.Data_Access;
using System.Security.Claims;
using System.Net.Mail;
using System.Net;
using System.Security.Cryptography.X509Certificates;
using System.Net.Security;

namespace WebFormsIdentity.Account
{
    public partial class Register : System.Web.UI.Page
    {
        WebFormsIdentityDatabaseEntities db = new WebFormsIdentityDatabaseEntities();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                var _roles = (from data in db.AspNetRoles select data).OrderBy(x => x.Id);
                var rolesList = new List<ListItem>();
                foreach (var _role in _roles)
                {
                    var newItem = new ListItem()
                    {
                        Value = _role.Id,
                        Text = _role.Name
                    };
                    rolesList.Add(newItem);
                }
                RolesList.DataSource = rolesList;
                RolesList.DataBind();
                RolesList.AutoPostBack = true;
                RolesList.SelectedIndexChanged += new EventHandler(RolesList_SelectedIndexChanged);
            }
        }

        protected void CreateUser_Click(object sender, EventArgs e)
        {
            // Default UserStore constructor uses the default connection 
            // string named: DefaultConnection
            var userStore = new UserStore<IdentityUser>();
            var manager = new UserManager<IdentityUser>(userStore);

            var user = new IdentityUser()
            {
                UserName = UserName.Text.Trim(),
                Email = Email.Text.Trim()
            };
            IdentityResult result = manager.Create(user, Password.Text.Trim());
            
            if (result.Succeeded)
            {
                //Add the created user to the selected role
                var currentUser = manager.FindByName(user.UserName);
                var roleResult = manager.AddToRole(currentUser.Id, RolesList.SelectedItem.Text);

                //Add the created user to the selected claims/projects
                foreach(ListItem item in Implementing_Partner_List.Items)
                {
                    if(item.Selected)
                    {
                        manager.AddClaim(currentUser.Id, new Claim("Project", item.Value));
                    }
                }
                foreach(ListItem item in Pillars_List.Items)
                {
                    if(item.Selected)
                    {
                        manager.AddClaim(currentUser.Id, new Claim("Pillar", item.Value));
                    }
                }

                //Sign in the created user
                /*var authenticationManager = HttpContext.Current.GetOwinContext().Authentication;
                var userIdentity = manager.CreateIdentity(user, DefaultAuthenticationTypes.ApplicationCookie);
                authenticationManager.SignIn(new AuthenticationProperties() { }, userIdentity);
                Response.Redirect("~/Account/Login.aspx");*/

                //====================================================+
                //  Send Email Message to Welcome Registered user     |
                //====================================================+

                //Create the mail message
                MailMessage mail = new MailMessage();

                //Add multiple addresses
                mail.To.Add(new MailAddress(user.Email, user.UserName));

                //Set the content
                mail.Subject = "Welcome to the FSD Africa MRM Reporting System";

                System.Text.StringBuilder sbuilder = new System.Text.StringBuilder();
                //sbuilder.Append("Hello " + currentUser.UserName + ",").AppendLine().AppendLine();
                sbuilder.Append("You have recently been registered on the " +
                    "‘FSD Africa MRM Reporting System’.").AppendLine().AppendLine();
                sbuilder.Append("Your current login details are:").AppendLine().AppendLine();
                sbuilder.Append("Username: " + Email.Text.Trim()).AppendLine();
                sbuilder.Append("Default Password: " + Password.Text.Trim()).AppendLine().AppendLine();
                sbuilder.AppendLine().AppendLine().AppendLine();
                sbuilder.Append("You can access the system here: http://results.fsdafrica.org ").AppendLine().AppendLine();
                sbuilder.Append("Thank you").AppendLine().AppendLine();
                sbuilder.Append("MRM team").AppendLine().AppendLine().AppendLine();
                sbuilder.Append("*This email is automatically generated - please do not reply").AppendLine();

                mail.Body = sbuilder.ToString();

                //Send the message
                SmtpClient smtp = new SmtpClient();
                /****SMTP Client is defined in the Web.Config File****/

                ServicePointManager.ServerCertificateValidationCallback = delegate (
                        object s, X509Certificate certificate, X509Chain chain, 
                        SslPolicyErrors sslPolicyErrors)
                { return true; }; //Always accept

                try
                {
                    smtp.Send(mail);
                    ScriptManager.RegisterStartupScript(Page, Page.GetType(), "infoModal", "$('#infoModal').modal();", true);
                    SuccessLbl.Text = currentUser.UserName + " Has been Successfully Registered";
                }
                catch(Exception ex)
                {
                    StatusMessage.Text = "MESSAGE NOT SENT " + ex.Message + "br />" + ex.StackTrace;
                }
                //=============================================+
                //                  END SEND MAIL              |
                //=============================================+
            }
            else
            {
                StatusMessage.Text = result.Errors.FirstOrDefault();
            }
        }

        protected void RolesList_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (RolesList.SelectedIndex == 1)
            {
                var pillars = (from data in db.pillars
                               select data).ToList();

                Pillars_List.DataSource = pillars;

                Pillars_List.Attributes.Add("onclick", "radioMe(event);");

                Pillars_List.DataBind();

                pillar.Visible = true;

                project.Visible = false;
                Implementing_Partner_List.ClearSelection();
            }
            else if (RolesList.SelectedIndex == 2)
            {
                var projects = (from data in db.projects
                                where data.status_id == 1
                                select new
                                {
                                    data.project_id,
                                    data.project_name
                                }).ToList();

                Implementing_Partner_List.DataSource = projects;

                Implementing_Partner_List.Attributes.Add("onclick", "radioMe(event);");
                
                Implementing_Partner_List.DataBind();

                project.Visible = true;

                pillar.Visible = false;
                Pillars_List.ClearSelection();
            }
            else
            {
                pillar.Visible = false;
                project.Visible = false;
            }
        }
    }
}