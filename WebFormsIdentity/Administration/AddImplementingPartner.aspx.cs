using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebFormsIdentity.Data_Access;

namespace WebFormsIdentity.Administration
{
    public partial class AddImplementingPartner : System.Web.UI.Page
    {
        WebFormsIdentityDatabaseEntities db = new WebFormsIdentityDatabaseEntities();
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void RegImplementingPartner_Click(object sender, EventArgs e)
        {
            project partner = new project();
            partner.status_id = 1;//Open
            partner.pillar_id = Int16.Parse(PillarDropDownList.SelectedValue);
            partner.project_name = PartnerName.Text.Trim();
            partner.acronym = Acronym.Text.Trim();
            partner.project_objectives = Objectives.Text;
            partner.implementing_partner = IPName.Text.Trim();
            partner.partnership_reference_number = PartnershipRefNo.Text.Trim();
            partner.expected_outcomes = Outcomes.Text;
            partner.budget = decimal.Parse(Budget.Text.Trim());

            db.projects.Add(partner);

            //SaveChanges() returns the number of items persisted to the database
            if (db.SaveChanges() > 0)
            {
                db.SaveChanges();

                Response.Redirect(Request.RawUrl);

                ScriptManager.RegisterStartupScript(
                    Page,
                    Page.GetType(),
                    "successModal", "$('#successModal').modal('show');",
                    true);
            }
        }

        protected void RegPillar_Click(object sender, EventArgs e)
        {
            pillar newPillar = new pillar();
            newPillar.name = PillarTextBox.Text.Trim();

            db.pillars.Add(newPillar);

            if(db.SaveChanges() > 0)
            {
                db.SaveChanges();

                Response.Redirect(Request.RawUrl);

                ScriptManager.RegisterStartupScript(
                    Page,
                    Page.GetType(),
                    "successModal", "$('#successModal').modal('show');",
                    true);
            }
        }
    }
}