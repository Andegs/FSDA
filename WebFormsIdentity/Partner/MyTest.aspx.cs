﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebFormsIdentity.Partner
{
    public partial class MyTest : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void FileUploadComplete(object sender, EventArgs e)
        {
            string filename = System.IO.Path.GetFileName(AsyncFileUpload1.FileName);
            AsyncFileUpload1.SaveAs(Server.MapPath("Uploads/") + filename);
        }
    }
}