using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebFormsIdentity.Data_Access;

namespace WebFormsIdentity.Account
{
    public partial class Users : System.Web.UI.Page
    {
        WebFormsIdentityDatabaseEntities db = new WebFormsIdentityDatabaseEntities();

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void EditClaims_Click(object sender, EventArgs e)
        {
            LinkButton btn = sender as LinkButton;
            UpdateClaims.CommandArgument = btn.CommandArgument;

            var userStore = new UserStore<IdentityUser>();
            var manager = new UserManager<IdentityUser>(userStore);

            var editUser = manager.FindById(btn.CommandArgument);
            ModalHeaderLabel1.Text = "Editing User Claims for \"" + editUser.UserName+"\"";

            ScriptManager.RegisterStartupScript(Page, Page.GetType(), "updateClaimsModal", "$('#updateClaimsModal').modal();", true);
            UpdatePanel1.Update();

            var role = (from data
                       in db.AspNetUserRolesViews
                        where data.UserId == editUser.Id
                        select new { data.RoleId }).SingleOrDefault();
            if (role != null)
            {
                //Pillar
                if(role.RoleId.Trim() == "2")
                {
                    Pill.Visible = true;
                    Pillar_List.DataBind();
                    Proj.Visible = false;
                    UpdateClaims.Visible = true;

                    var pillarClaims = manager.GetClaims(editUser.Id);
                    foreach(var pillarClaim in pillarClaims)
                    {
                        if (pillarClaim.Type == "Pillar")
                        {
                            Pillar_List.Items.FindByValue(pillarClaim.Value).Selected = true;
                        }
                    }
                }
                //Project
                else if(role.RoleId.Trim() == "3")
                {
                    Proj.Visible = true;
                    Implementing_Partner_List.DataBind();
                    Pill.Visible = false;
                    UpdateClaims.Visible = true;

                    var projectClaims = manager.GetClaims(editUser.Id);
                    foreach(var projectClaim in projectClaims)
                    {
                        if (projectClaim.Type == "Project")
                        {
                            Implementing_Partner_List.Items.FindByValue(projectClaim.Value).Selected = true;
                        }
                    }
                }
                else
                {
                    ModalHeaderLabel1.Text = "\"" + editUser.UserName + "\" is an Administrator.";
                    UpdateClaims.Visible = false;
                    Proj.Visible = false;
                    Pill.Visible = false;
                }
            }
            else
            {
                ModalHeaderLabel1.Text = "You Must first give \"" + editUser.UserName + "\" a role.";
                UpdateClaims.Visible = false;
                Proj.Visible = false;
                Pill.Visible = false;
            }

            //Response.Redirect(String.Format("~/Account/Register.aspx?user={0}", btn.CommandArgument));
        }

        protected void EditRoles_Click(object sender, EventArgs e)
        {
            LinkButton btn = sender as LinkButton;
            UpdateRoles.CommandArgument = btn.CommandArgument;

            var userStore = new UserStore<IdentityUser>();
            var manager = new UserManager<IdentityUser>(userStore);

            var editUser = manager.FindById(btn.CommandArgument);
            ModalHeaderLabel2.Text = "Editing User Roles for \"" + editUser.UserName + "\"";

            ScriptManager.RegisterStartupScript(Page, Page.GetType(), "updateRolesModal", "$('#updateRolesModal').modal();", true);
            UpdatePanel2.Update();
            Roles_List.DataBind();

            var role = (from data 
                       in db.AspNetUserRolesViews
                       where data.UserId == editUser.Id
                       select new { data.RoleId }).SingleOrDefault();
            if (role != null)
            {
                Roles_List.SelectedValue = role.RoleId;
            }
        }

        protected void UpdateClaims_Click(object sender, EventArgs e)
        {
            Button btn = sender as Button;

            var userStore = new UserStore<IdentityUser>();
            var manager = new UserManager<IdentityUser>(userStore);

            var updateUser = manager.FindById(btn.CommandArgument);

            var claims = manager.GetClaims(updateUser.Id);

            if (manager.IsInRole(updateUser.Id, "Pillar"))
            {
                foreach (var claim in claims)
                {
                    manager.RemoveClaim(updateUser.Id, claim);
                }

                var selectedClaims = Pillar_List.Items
                    .Cast<ListItem>()
                    .Where(n => n.Selected)
                    .ToList();

                if (selectedClaims.Count == 0)
                {
                    ScriptManager.RegisterStartupScript(Page, Page.GetType(), "infoModal", "$('#infoModal').modal();", true);
                }
                else
                {
                    foreach (var selectedClaim in selectedClaims)
                    {
                        manager.AddClaim(updateUser.Id, new Claim("Pillar", selectedClaim.Value));
                    }
                }
            }
            else if(manager.IsInRole(updateUser.Id, "Partner"))
            {
                foreach (var claim in claims)
                {
                    manager.RemoveClaim(updateUser.Id, claim);
                }

                var selectedClaims = Implementing_Partner_List.Items
                    .Cast<ListItem>()
                    .Where(n => n.Selected)
                    .ToList();

                if (selectedClaims.Count == 0)
                {
                    ScriptManager.RegisterStartupScript(Page, Page.GetType(), "infoModal", "$('#infoModal').modal();", true);
                }
                else
                {
                    foreach (var selectedClaim in selectedClaims)
                    {
                        manager.AddClaim(updateUser.Id, new Claim("Project", selectedClaim.Value));
                        //To update the User (Not Needed though)
                        //manager.Update(updateUser);
                    }
                }
            }
            ScriptManager.RegisterStartupScript(Page, Page.GetType(), "updateClaimsModal", "$('#updateClaimsModal').modal('hide');", true);
        }

        protected void UpdateRoles_Click(object sender, EventArgs e)
        {
            Button btn = sender as Button;

            var userStore = new UserStore<IdentityUser>();
            var manager = new UserManager<IdentityUser>(userStore);

            var updateUser = manager.FindById(btn.CommandArgument);

            //Remove the user from the currently selected role
            var roles = manager.GetRoles(updateUser.Id);
            if (roles.Count > 0)
            {
                foreach (var role in roles)
                {
                    manager.RemoveFromRole(updateUser.Id, role);
                }

                var claims = manager.GetClaims(updateUser.Id);
                foreach (var claim in claims)
                {
                    manager.RemoveClaim(updateUser.Id, claim);
                }
            }

            var selectedRoles = Roles_List.Items
                    .Cast<ListItem>()
                    .Where(n => n.Selected)
                    .ToList();

            if(selectedRoles.Count > 0)
            {
                foreach(var selectedRole in selectedRoles)
                {
                    manager.AddToRole(updateUser.Id, selectedRole.Text.Trim());
                }
            }
            ScriptManager.RegisterStartupScript(Page, Page.GetType(), "updateRolesModal", "$('#updateRolesModal').modal('hide');", true);
        }
    }
}