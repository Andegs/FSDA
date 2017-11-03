using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebFormsIdentity
{
    public partial class downloading : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string fileName = Request["file"].ToString();
            fileDownload(fileName, Server.MapPath("~/Attachments/" + fileName));
        }

        private void fileDownload(string fileName, string fileUrl)
        {
            Page.Response.Clear();
            bool success = ResponseFile(Page.Request, Page.Response, fileName, fileUrl, 1024000);
            if(!success)
            {
                Response.Write("Downloading Error!");
            }
            Page.Response.End();
        }

        public static bool ResponseFile(HttpRequest request, HttpResponse response, string fileName, string fileUrl, long _speed)
        {
            try
            {
                FileStream myFile = new FileStream(fileUrl, FileMode.Open, FileAccess.Read, FileShare.ReadWrite);
                BinaryReader br = new BinaryReader(myFile);
                try
                {
                    response.AddHeader("Accept-Ranges", "bytes");
                    response.Buffer = false;
                    long fileLength = myFile.Length;
                    long startBytes = 0;

                    int pack = 10240; //10k bytes
                    int sleep = (int)Math.Floor((double)(1000 * pack / _speed)) + 1;
                    if(request.Headers["Range"] != null)
                    {
                        response.StatusCode = 206;
                        string[] range = request.Headers["Range"].Split(new char[] { '=', '-' });
                        startBytes = Convert.ToInt64(range[1]);
                    }
                    response.AddHeader("Content-Length", (fileLength - startBytes).ToString());
                    if(startBytes != 0)
                    {
                        response.AddHeader("Content-Range", string.Format(" bytes {0}-{1}/{2}", startBytes, fileLength - 1, fileLength));
                    }
                    response.AddHeader("Connection", "Keep-Alive");
                    response.ContentType = "application/octet-stream";
                    response.AddHeader("Content-Disposition", "attachment;filename=" 
                        + HttpUtility.UrlEncode(fileName, System.Text.Encoding.UTF8));

                    br.BaseStream.Seek(startBytes, SeekOrigin.Begin);
                    int maxCount = (int)Math.Floor((double)((fileLength - startBytes) / pack)) + 1;

                    for(int i=0;i<maxCount; i++)
                    {
                        if(response.IsClientConnected)
                        {
                            response.BinaryWrite(br.ReadBytes(pack));
                            Thread.Sleep(sleep);
                        }
                        else
                        {
                            i = maxCount;
                        }
                    }
                }
                catch
                {
                    return false;
                }
                finally
                {
                    br.Close();
                    myFile.Close();
                }
            }
            catch
            {
                return false;
            }
            return true;
        }
    }
}