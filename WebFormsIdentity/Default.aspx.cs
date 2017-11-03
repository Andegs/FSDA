using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebFormsIdentity
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            ClaimsPrincipal claimsPrincipal = Page.User as ClaimsPrincipal;

            /*if (claimsPrincipal != null)
            {
                ClaimsGridView.DataSource = claimsPrincipal.Claims;
                ClaimsGridView.DataBind();
            }

            //This is a test for Claims Authorisation
            //Start
            if (claimsPrincipal.HasClaim(x => x.Type == "Implementing_Partner"
            && x.Value == "CMA-K"))
            {
                Label1.Text = "You work for CMA Kenya";
                Label1.Visible = true;
            }
            else
            {
                Label1.Text = "You don't work for CMA Kenya";
                Label1.Visible = true;
            }*/
            //End

        }
    }
}