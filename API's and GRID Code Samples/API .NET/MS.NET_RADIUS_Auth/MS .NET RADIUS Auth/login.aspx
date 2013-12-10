<!-- **********************************************************
*********** START: DO NOT REMOVE OR ALTER THIS CODE ***********
************************************************************-->

<%@ Page aspcompat=true Language="VB"%>
<%@ Import Namespace="System.Web.Security" %>

<script  runat="server">
Sub submit(Source As Object, e As EventArgs)


dim authRes = ""

If IsNothing(Session("comAuth")) Then
	Session("comAuth") = Server.CreateObject("COMAUTH.ComAuthCtrl.1")
end if

authRes = Session("comAuth").Authenticate(txtID.Text, "", txtPwd.Text)

lblAuthResult2.Text = authRes

If authRes = "PIN_MUST_CHANGE" Then
	Session("logonForm") = 2
end if

If authRes = "SUCCESS" Then
	FormsAuthentication.RedirectFromLoginPage(txtID.Text, false)
end if

End Sub
</script>


<script  runat="server">
Sub changePIN(Source As Object, e As EventArgs)


If txtNewPIN.Text = txtNewPIN2.Text Then
	dim changeRes = ""
	changeRes = Session("comAuth").ChangePIN(txtOldPIN.Text, txtNewPIN.Text)
	lblChangeResult2.Text = changeRes
	
	If changeRes = "SUCCESS" Then
		Session("logonForm") = 1
		lblAuthResult2.Text = changeRes
		lblChangeResult2.Text = ""
		FormsAuthentication.RedirectFromLoginPage(txtID.Text, false)
	End if
	
else
	lblChangeResult2.Text = "New PINs do not match."
end if

End Sub
</script>


<!-- **********************************************************
*********** END: DO NOT REMOVE OR ALTER THIS CODE ***********
************************************************************-->









<!-- *************************************************************************
******************************************************************************
START: ALTER THIS CODE BELOW
******************************************************************************
***************************************************************************-->

<HTML>
	<HEAD>
		<title>CRYPTOCard .NET RADIUS Authentication</title>
		
<!-- *************************************************************************
START: THIS IS A LINK TO THE STYLE SHEET
***************************************************************************-->
        <LINK href="img/format.css" type="text/css" rel="stylesheet"></LINK>
<!-- ************************************************************************
END: THIS IS A LINK TO THE STYLE SHEET
**************************************************************************-->		
		
</HEAD>
	<body bgcolor="#FFFFFF" topmargin="0" bottommargin="0" marginheight="0"><br><br><br>
<!-- ***********************************************************************************************************************************
Change colour of the background "#FFFFFF (White)" or Change your Background Image to customize the look of your Login Page.
CHANGE WHAT IS IN QUOTES: background-color: "#FFFFFF"  or   background-image: url:(img/"cc_logo1.jpg")

NOTE: Background images provided are: cc_room.gif, cc_cryptocard.gif, cc_token.gif, cc_BWsilk.gif, cc_silk.gif, cryptomas_login_page.gif
*************************************************************************************************************************************-->
 
<table style="background-color:#FFFFFF; background-image: url(img/cc_logo1.jpg); background-position:top; background-repeat:no-repeat; width:100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td valign="top">
		

<!-- *************************************************************
******************************************************************
CODE STARTS HERE
******************************************************************
***************************************************************-->

<div align="center">
<!-- START: DO NOT ALTER -->

	<% If IsNothing(Session("logonForm")) Then
		Session("logonForm") = 1
	end if %>
	
	<% If Session("logonForm") = 1 Then %>
		<form id="Form1" method="post" runat="server">

<!-- END: DO NOT ALTER -->

<img src="img/spacer.gif" width="100%" height="100px"> <!-- NOTE: ADJUST THE HEIGHT OF THE TABLE ON THE PAGE BY REDUCING OR INCREASING THE HEIGHT OF THE SPACER.GIF IMAGE -->
		<p align="center" class="txtstyle3"><asp:Label>.NET RADIUS Web Authentication</asp:Label></p>

		<table align="center">
			<tr>
			  	<td class="txtstyle">&nbsp;</td>
			  	<td>&nbsp;</td>
		 		<td>&nbsp;</td>
		     		<td>&nbsp;</td>
		 	</tr>
			<tr>
				<td class="txtstyle"><asp:Label id="lblID" runat="server">Username:</asp:Label></td><!-- CHANGE "Username" name -->
			</tr>
			<tr>
				<td><asp:TextBox id="txtID" runat="server" CssClass="enterstyle"></asp:TextBox></td>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td class="txtstyle"><asp:Label id="lblPwd" runat="server">PIN &amp; Passcode:</asp:Label></td><!-- CHANGE "PIN & Passcode" name -->
			</tr>
			<tr>
				<td><asp:TextBox id="txtPwd" runat="server" TextMode="Password" CssClass="enterstyle"></asp:TextBox></td>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td><br></td>
			<tr>
				<td class="txtstyle" height="20px"><asp:Label id="lblAuthResult1" runat="server">Authentication Result:</asp:Label></td><!-- CHANGE "Authentication Result" name -->
			</tr>
			<tr align="center">
				<td><asp:Label id="lblAuthResult2" runat="server" CssClass="txtstyle2"></asp:Label></td>
				<td height="12"><img src="img/spacer.gif" width="5" height="12"></td>
			</tr>
			<tr>
				<td colspan="4" align="center" height="30px"><asp:Button id="btnLogin" OnClick="submit" runat="server" Text="Login"></asp:Button>&nbsp;&nbsp;</td>
			</tr>
			<tr>
				<td height="12"><img src="img/spacer.gif" width="5" height="12"></td>
			</tr>
		</table>
	</form>
		
		
		
	 <% else %>

<!-- ****************************************************************************************************************************
*********************************************************************************************************************************
START: When the system recognizes a new PIN that is provided to a user, this form below will show itself to the new user and request that
they change their PIN.
*********************************************************************************************************************************
******************************************************************************************************************************-->

		<form id="Form2" method="post" runat="server">
		<img src="img/spacer.gif" width="100%" height="100px">
			<table>				
				<tr>
				<td class="txtstyle">Please select a new PIN:<br><br></td>
				</tr>
				<tr>
					<td class="txtstyle"><asp:Label id="lblOldPIN" runat="server">Old PIN:</asp:Label></td>
					<td><asp:TextBox id="txtOldPIN" TextMode="Password" runat="server"></asp:TextBox></td>
				</tr>
				<tr>
					<td class="txtstyle"><asp:Label id="lblNewPIN" runat="server">New PIN:</asp:Label></td>
					<td><asp:TextBox id="txtNewPIN" runat="server" TextMode="Password"></asp:TextBox></td>
				</tr>
				<tr>
					<td class="txtstyle"><asp:Label id="lblNewPIN2" runat="server">Confirm New PIN:</asp:Label></td>
					<td><asp:TextBox id="txtNewPIN2" runat="server" TextMode="Password"></asp:TextBox></td>
				</tr>
				<tr>
					<td class="txtstyle"><asp:Label id="lblChangeResult1" runat="server">PIN Change Result:</asp:Label></td>
					<td class="txtstyle"><asp:Label id="lblChangeResult2" runat="server"></asp:Label><br><br></td>
				</tr>
				<td><br><br></td>
				<tr>
					<td colspan="2" align="center"><asp:Button id="btnChangePIN" OnClick="changePIN" runat="server" Text="Submit"></asp:Button>&nbsp;&nbsp;</td>
				</tr>
				
			</table>
		</form>
		
<!-- ****************************************************************************************************************************
*********************************************************************************************************************************
END: When the system recognizes a new PIN that is provided to a user, this form below will show itself to the new user and request that
they change their PIN.
*********************************************************************************************************************************
******************************************************************************************************************************-->
		
	<% end if %> <!-- DO NOT REMOVE -->

</div>	


		</td>
	</tr>
</table>


</body>
	
</HTML>

<!-- ****************************************************************************************************************************
*********************************************************************************************************************************
END: ALTER THIS CODE ABOVE
*********************************************************************************************************************************
******************************************************************************************************************************-->


