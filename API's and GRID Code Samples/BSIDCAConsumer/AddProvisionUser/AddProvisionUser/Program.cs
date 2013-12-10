using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AddProvisionUser.spedemoSAS;
using System.Net;

namespace AddProvisionUser
{
    class Program
    {
        static void Main(string[] args)
        {
            ServicePointManager.ServerCertificateValidationCallback = new System.Net.Security.RemoteCertificateValidationCallback(AcceptAllCertifications);

            string challenge;

            BSIDCA ca = new BSIDCA();

            // url for SAS where user needs to be inserted. Please change the URL to point to your SAS server.
            ca.Url = "https://spedemo.cryptocard.com/BSIDCA/BSIDCA.asmx";
            ca.UseDefaultCredentials = true;
            ca.PreAuthenticate = true;
            ca.AllowAutoRedirect = true;
            ca.CookieContainer = new System.Net.CookieContainer();

            try
            {
                //connect using operator
                if (ca.Connect("operator@me.com", "Password123$", null, out challenge) == ReturnCode.AUTH_SUCCESS)
                {
                    string org = "sas_demo_company";
                    User u = new User();
                    u.UserName = "testu";
                    u.FirstName = "test";
                    u.Lastname = "user";
                    u.Email = "stephen.allen@safenet-inc.com";
                    //code to add user
                    bool b = ca.AddUser(u, org);
                    if (b)
                    {
                        Console.WriteLine("user added");

                        //specify the serail number of the MP token here
                        String serial = "1000025356";
                        ca.AssignToken(u.UserName, serial, org);
                        Console.WriteLine("token assigned to user");

                        //code to provision user
                        string[] userstoProv = { "testu" };
                        ca.ProvisionUsers(userstoProv, TokenOption.Software,"description11",org);
                        Console.WriteLine("User provisioned");
                    }
                    else
                    {
                        Console.WriteLine("user not added");
                    }


                }
                else
                {
                    Console.WriteLine("Authentication unsuccessfull for operator");

                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
        }

        public static bool AcceptAllCertifications(object sender, System.Security.Cryptography.X509Certificates.X509Certificate certification, System.Security.Cryptography.X509Certificates.X509Chain chain, System.Net.Security.SslPolicyErrors sslPolicyErrors)
        {
            return true;
        }
    }
}
