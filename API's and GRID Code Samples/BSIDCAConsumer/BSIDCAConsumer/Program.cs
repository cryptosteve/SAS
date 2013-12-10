using System;
using System.Collections.Generic;
using System.Text;
using BSIDCAConsumer.BlackShield;
using System.Data;

namespace BSIDCAConsumer
{
    class Program
    {
        static void Main(string[] args)
        {
            BSIDCA ca = new BSIDCA();
            ca.Url = "https://sastest.safenet-inc.com/BSIDCA/BSIDCA.asmx";
            ca.UseDefaultCredentials = true;
            ca.PreAuthenticate = true;
            ca.AllowAutoRedirect = true;
            ca.CookieContainer = new System.Net.CookieContainer();
            String challenge;
            if (ca.Connect("stephen.allen@safenet-inc.com", "7#SjyB2&?6zZEg*", null, out challenge) == ReturnCode.AUTH_SUCCESS)
            {
                DataTable dt;

                // Tests assume the operator's account is "1" and that the MP token with serial "1000000001" is available
                String organization = "1";
                String serial = "1000000001";
                
                User u = new User();
                u.UserName = "BSIDCA";
                ca.AddUser(u, organization);

                ca.AssignToken(u.UserName, serial, organization);

                ca.SuspendToken(serial, suspendSelection.No_Static_Password, null, null, false, organization, 15);
                
                ca.ActivateToken(serial, true, "123", organization);
                
                int provTotal = ca.GetProvisioningTaskCount(organization);
                if (provTotal > 0)
                {
                    dt = ca.GetProvisioningTasks(organization, 0, provTotal);
                    dt = ca.GetProvisioningTaskDetails(Convert.ToInt32(dt.Rows[0][0].ToString()), organization);
                }

                int[] simpleMetrics = ca.GetSimpleAuthMetrics(u.UserName, null, organization);
                Token t = ca.GetToken(serial, organization);
                TokenTemplate tokenTemplate = ca.GetTokenTemplateForToken(serial, organization);
                
                String state;
                challenge = ca.GetTokenChallenge(serial, u.UserName, organization, out state);

                String fileName;
                byte[] tokenFile = ca.GetTokenFile(serial, organization, out fileName);

                dt = ca.GetTokens(null, null, null, null, organization, 0, 100);

                String[] userTokens = ca.GetTokensByOwner(u.UserName, organization);

                u = ca.GetUser(u.UserName, organization);


                bool result = ca.AddContainer("Test", "Description", organization);
                result = ca.AddGroup("Test Group", "Description", organization);

                String[] vendors = ca.GetRADIUSVendors();
                String[] attributes = ca.GetRADIUSAttributeForVendor(vendors[10]);
                RadiusAttribute rat = ca.GetRADIUSAttribute(vendors[10], attributes[2]);
                rat.Value = Encoding.UTF8.GetBytes("Test");
                result = ca.AddRADIUSAttributeToGroup(rat, "Test Group", organization);
                result = ca.AddRADIUSAttributeToUser(rat, u.UserName, organization);

                dt = ca.GetTokens(null, TokenType.CUSTOM, null, null, organization, 0, 1);
                String[] serials = new string[]{dt.Rows[0][0].ToString()};

                // Allocation tests assume a sub account called "1.1"
                ca.AllocateGrIDsure(serials, BillingStyle.Allocation, true, false, "1.1");
                ca.AllocateSMSCredits(10, BillingStyle.Allocation, "1.1");
                ca.AllocateSoftware(1, BillingStyle.Allocation, true, false, "1.1");

                dt = ca.GetAvailableReports(ReportLevel.Subscriber, null, 0, 100, organization);
                Report r = ca.GetAvailableReport(ReportLevel.Subscriber, dt.Rows[0][0].ToString(), organization);
                string[] operators = ca.GetOperators(organization);
                r.AllowedOperators = operators;
                r.Filters[0].Value = DateTime.Now.ToString();
                ca.SaveReport(r, organization);
                ScheduledReport sr = new ScheduledReport();
                sr.report = r;
                sr.organization = organization;
                ca.ScheduleReportToRunNow(sr, organization);
            }
        }
    }
}
