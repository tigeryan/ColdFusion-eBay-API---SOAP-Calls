<!---
ebay_getcategories.cfm

Example of how to use the eBay webservice to get a list of categories

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
<cfset methodToCall = "getCategories">

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
<GetCategoriesRequest xmlns="urn:ebay:apis:eBLBaseComponents">
  <DetailLevel>ReturnAll</DetailLevel>
  <Version>#variables.version#</Version>
  <WarningLevel>High</WarningLevel>
  <!--- remove categoryparent to return all categories --->
  <CategoryParent>4707</CategoryParent>
</GetCategoriesRequest>
</cfoutput>
</soap:Body>
</soap:Envelope>
</cfsavecontent>

<cfset ebayXMLBody = xmlparse(ebayBody)>

<cfhttp url="#variables.endpoint#?callname=#variables.methodToCall#&siteid=#variables.SiteID#&appid=#variables.AppID#&version=#variables.version#&Routing=#variables.routing#" 
	method="post" result="httpResponse">
	<cfhttpparam type="header" name="SOAPAction" value="#variables.methodToCall#"/>
	<cfhttpparam type="header" name="accept-encoding" value="no-compression" />
	<cfhttpparam type="xml" value="#trim(variables.ebayXMLBody)#" />
</cfhttp>

<cfset soapResponse = xmlParse(httpResponse.fileContent) />
<!--- <cfdump var="#soapResponse#"> --->
<cfset responseNodes = xmlSearch(soapResponse,"//*[ local-name() = 'Category' ]") />
<cfdump var="#responseNodes#">

