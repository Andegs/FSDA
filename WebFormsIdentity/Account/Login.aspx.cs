using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using Microsoft.Owin.Security;

using System.Security.Claims;

namespace WebFormsIdentity.Account
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (User.Identity.IsAuthenticated)
                {
                    StatusText.Text = string.Format("Hello {0}!!", User.Identity.GetUserName());
                    LoginStatus.Visible = true;
                    LogoutButton.Visible = true;

                    Response.Redirect("~/Default.aspx");
                }
                else
                {
                    LoginForm.Visible = true;
                }
            }
        }

        protected void SignIn(object sender, EventArgs e)
        {
            var userStore = new UserStore<IdentityUser>();
            var userManager = new UserManager<IdentityUser>(userStore);
            var user = userManager.Find(UserName.Text, Password.Text);

            if (user != null)
            {
                var authenticationManager = HttpContext.Current.GetOwinContext().Authentication;
                var userIdentity = userManager.CreateIdentity(user, DefaultAuthenticationTypes.ApplicationCookie);

                // Add custom user claims here this should be done before LOGON!

                /*var claimsIdentity = User.Identity as ClaimsIdentity;
                IEnumerable<Claim> claims = claimsIdentity.Claims;
                userIdentity.AddClaims(claims);*/


                /*userIdentity.AddClaims(new[] {
                new Claim("MyClaimName1", "MyClaimValue1"),
                new Claim("MyClaimName2", "MyClaimValue2")
                });*/

                /*// Now since we have injected our claims while signing in, 
                 * we have access to claims wherever we want through this:
                ((ClaimsIdentity)User.Identity).FindFirst("MyClaimName");*/

                authenticationManager.SignIn(new AuthenticationProperties()
                {
                    IsPersistent = false
                },
                userIdentity);

                var returnUrl = Request.QueryString["ReturnURL"];
                if (string.IsNullOrEmpty(returnUrl))
                {
                    returnUrl = "~/Default.aspx";
                }
                Response.Redirect(returnUrl);
            }
            else
            {
                StatusText.Text = "Invalid username or password.";
                LoginStatus.Visible = true;
            }
        }

        protected void SignOut(object sender, EventArgs e)
        {
            var authenticationManager = HttpContext.Current.GetOwinContext().Authentication;
            authenticationManager.SignOut();
            Response.Redirect("~/Account/Login.aspx");
        }
    }
}