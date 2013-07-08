<!---
ebay_additem.cfm

Example of how to use the eBay webservice to add an item to the site

Developer: John Ceci
Date: 2/13/2013

--->
<cfset endpoint="https://api.sandbox.ebay.com/wsapi">
<cfset AppID="<<Your APPID>>">
<cfset DevID="<<Your DEVID>>">
<cfset CertID="<<Your CertID>>">
<cfset eBayAuthToken="<<Your Auth Token>>">
<cfset version="723">
<cfset routing="default">
<cfset SiteID=0>
<cfset UUID = Replace(CreateUUID(),'-','','ALL') />

<cfoutput>#UUID#</cfoutput>

<cfsavecontent variable="ebayDesc">
<div align="center">
	<table style="font-family:Arial;font-size:14px;padding:10px;" width="600" cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td style="background-color:#FF0000;" colspan="3">LOGO HERE</td>
		</tr>
		<tr>
			<td style="background-color:#FF0000;width:4px;">&nbsp;</td>
			<td style="padding:10px;"><h1 style="font-size:16px;">Product Title HEre</h1></td>
			<td style="background-color:#FF0000;width:4px;">&nbsp;</td>
		</tr>
		<tr>
			<td style="background-color:#FF0000;width:4px;">&nbsp;</td>	
			<td align="center"><img src="http://<<product image here>>.jpg" /></td>
			<td style="background-color:#FF0000;width:4px;">&nbsp;</td>		
		</tr>
		<tr>
			<td style="background-color:#FF0000;width:4px;">&nbsp;</td>	
			<td style="padding:10px;">Condition: <strong>New In Package</strong></td>
			<td style="background-color:#FF0000;width:4px;">&nbsp;</td>		
		</tr>
		<tr>
			<td style="background-color:#FF0000;width:4px;">&nbsp;</td>	
			<td style="padding:10px;">Description: <<DESCRIPTION HERE >></td>
			<td style="background-color:#FF0000;width:4px;">&nbsp;</td>		
		</tr>
		<tr>
			<td style="background-color:#FF0000;width:4px;">&nbsp;</td>	
			<td style="padding:10px;">Ozzy customer friendly stuff here</td>
			<td style="background-color:#FF0000;width:4px;">&nbsp;</td>		
		</tr>
		<tr>
			<td style="background-color:#FF0000;" colspan="3">&nbsp;</td>
		</tr>	
	</table>
</div>
</cfsavecontent>

<cfset methodToCall = "VerifyAddItem">

<cfsavecontent variable="ebayBody">
<soap:Envelope
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:xsd="http://www.w3.org/2001/XMLSchema"
xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
<soap:Header>
<cfoutput>
<ebl:RequesterCredentials xmlns:ebl="urn:ebay:apis:eBLBaseComponents">
<ebl:eBayAuthToken>#variables.eBayAuthToken#</ebl:eBayAuthToken>
<ebl:Credentials>
<ebl:DevId>#variables.DevID#</ebl:DevId>
<ebl:AppId>#variables.AppID#</ebl:AppId>
<ebl:AuthCert>#variables.CertID#</ebl:AuthCert>
</ebl:Credentials>
</ebl:RequesterCredentials>
</soap:Header>
<soap:Body>
<VerifyAddItemRequest xmlns="urn:ebay:apis:eBLBaseComponents">
	<ErrorLanguage>en_US</ErrorLanguage>
	<WarningLevel>High</WarningLevel>
	<Version>#version#</Version>
	<Item>
		<Title>Product Title Here</Title>
		<Description>#HTMLEditFormat(ebayDesc)#</Description>
		<PrimaryCategory>
			<CategoryID>4004</CategoryID>
		</PrimaryCategory>
		<StartPrice>7.49</StartPrice>
		<BuyItNowPrice>10.99</BuyItNowPrice>
		<ConditionID>1000</ConditionID>
		<CategoryMappingAllowed>true</CategoryMappingAllowed>
		<Country>US</Country>
		<Currency>USD</Currency>
		<DispatchTimeMax>3</DispatchTimeMax>
		<ListingDuration>Days_7</ListingDuration>
		<ListingType>Chinese</ListingType>
		<PaymentMethods>PayPal</PaymentMethods>
		<PayPalEmailAddress>email@gmail.com</PayPalEmailAddress>
		<PictureDetails>
			<PictureURL>http://email.com/email.jpg</PictureURL>
		</PictureDetails>
		<PostalCode>08081</PostalCode>
		<Quantity>1</Quantity>
		
		<ReturnPolicy>
			<ReturnsAcceptedOption>ReturnsAccepted</ReturnsAcceptedOption>
			<RefundOption>MoneyBack</RefundOption>
			<ReturnsWithinOption>Days_30</ReturnsWithinOption>
			<Description>
				Returns are accepted for all unopened packages
			</Description>
			<ShippingCostPaidByOption>Buyer</ShippingCostPaidByOption>
		</ReturnPolicy>
		
		<ShippingDetails>
			<ShippingType>Flat</ShippingType>
			<ShippingServiceOptions>
				<ShippingServicePriority>1</ShippingServicePriority>
				<ShippingService>USPSMedia</ShippingService>
				<ShippingServiceCost>0.00</ShippingServiceCost>
			</ShippingServiceOptions>
		</ShippingDetails>

		<Site>US</Site>
		<UUID>#UUID#</UUID>
	</Item>
	<RequesterCredentials>
		<eBayAuthToken>#eBayAuthToken#</eBayAuthToken>
	</RequesterCredentials>
	<WarningLevel>High</WarningLevel>
</VerifyAddItemRequest>
</cfoutput>
</soap:Body>
</soap:Envelope>
</cfsavecontent>

<cfset ebayXMLBody = XMLParse(ebayBody) />

<cfhttp url="#endpoint#?callname=#methodToCall#&siteid=#SiteID#&appid=#AppID#&version=#version#&Routing=#routing#" method="post" result="httpResponse">
	<cfhttpparam type="header" name="SOAPAction" value="VerifyAddItem" />
	<cfhttpparam type="header" name="accept-encoding" value="no-compression" />
	<cfhttpparam type="xml" value="#Trim(ebayXMLBody)#" />
</cfhttp>

<cfdump var="#httpResponse#" />
<cfset soapResponse = xmlParse(httpResponse.fileContent) />
<cfdump var="#soapResponse#" />

<cfset responseNodes = XMLSearch(soapResponse,"//*[ local-name() = 'Ack' ]") />
<cfset result = responseNodes[1].XmlText />

<cfif result EQ "Success">

	<cfset methodToCall = "AddItem" />
	<!--- change the request packet from Verify to Add --->
	<cfset ebayBody = Replace(ebayBody,"VerifyAddItemRequest","AddItemRequest","ALL") />
	<cfset ebayXMLBody = XMLParse(ebayBody) />
	
	<cfhttp url="#endpoint#?callname=#methodToCall#&siteid=#SiteID#&appid=#AppID#&version=#version#&Routing=#routing#" method="post" result="httpResponse">
		<cfhttpparam type="header" name="SOAPAction" value="AddItem" />
		<cfhttpparam type="header" name="accept-encoding" value="no-compression" />
		<cfhttpparam type="xml" value="#Trim(ebayXMLBody)#" />
	</cfhttp>

	<cfdump var="#soapResponse#" />

<cfelse>

	Item did not verify properly!<br />
	
</cfif>


