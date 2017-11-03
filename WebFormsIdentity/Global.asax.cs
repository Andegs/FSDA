using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;

namespace WebFormsIdentity
{
    public class Global : System.Web.HttpApplication
    {

        protected void Application_Start(object sender, EventArgs e)
        {

        }

        protected void Session_Start(object sender, EventArgs e)
        {

        }

        protected void Application_BeginRequest(object sender, EventArgs e)
        {
            HttpApplication app = (HttpApplication)sender;
            HttpContext context = app.Context;

            // Attempt to peform first request initialization
            FirstRequestInitialization.Initialize(context);
        }

        protected void Application_AuthenticateRequest(object sender, EventArgs e)
        {

        }

        protected void Application_Error(object sender, EventArgs e)
        {

        }

        protected void Session_End(object sender, EventArgs e)
        {

        }

        protected void Application_End(object sender, EventArgs e)
        {

        }

        private class FirstRequestInitialization
        {
            private static bool s_InitializedAlready = false;
            private static Object s_lock = new Object();
            // Initialize only on the first request
            public static void Initialize(HttpContext context)
            {
                if (s_InitializedAlready)
                {
                    return;
                }
                lock (s_lock)
                {
                    if (s_InitializedAlready)
                    {
                        return;
                    }
                    // Perform first-request initialization here …
                    s_InitializedAlready = true;
                }
            }
        }
    }
}