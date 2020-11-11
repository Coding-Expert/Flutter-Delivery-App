//
//Required API list
//
//•	Phone Number Authentication
//
//API SENDING OTP TO DRIVER's NUMBER
//
//https://www.itruckdispatch.com/api/sendotpviaphone?phone=phone&apikey=apikey
//
//where
//phone – phone number of the driver
//apikey – valid apikey
//
//API FOR LOGIN:
//
//https://www.itruckdispatch.com/api/login?phone=phone&otpflag=otpflag&apikey=apikey
//
//Where
//phone – phone number of the driver
//otpflag – 0 : if the OTP doesnot match and 1 : if the OTP matches
//apikey – valid apikey
//
//
//
//•	User data
//
//API FOR PROFILE SCREEN
//
//https://www.itruckdispatch.com/api/profile?phone=phone&apikey=apikey
//
//where
//phone – phone number of the driver
//apikey – valid apikey
//
//
//API FOR DASHBOARD SCREEN
//
//https://www.itruckdispatch.com/api/dashboard?phone=phone&apikey=apikey
//
//where
//phone – phone number of the driver
//apikey – valid apikey
//
//Response:
//
//List having number of loads and completed loads will be returned.
//1st  element - all loads
//2nd  element – completed loads
//
//
//
//
//
//
//•	Loads Request all
//
//API FOR ALL LOADS FOR DRIVER
//
//https://www.itruckdispatch.com/api/loadsfordriver?phone=phone&apikey=apikey
//
//where
//phone – phone number of the driver
//apikey – valid apikey
//
//Columns for displaying the loads:
//
//All the address and details for shipper and consignee are available under the Shippers and consignees column and the records are separated using @@ and the details for each record are separated by
//##Example : test##Yellowstone National Park, United States##Aug 10,2020##00:00##NA##NA##NA##NA##No##NA##NA##NA##NA##NA##NA##NA##40.758701##-111.876183##Gunjan##8591162012@@test##Yellowstone National Park, United States##Aug 10,2020##00:00##NA##NA##NA##NA##No##NA##NA##NA##NA##NA##NA##NA##39.419220##-111.950684##Gunjan##8591162012
//
//
//Shipper columns :
//shippername
//shipperaddress
//shippingdate
//shippingtime
//shippingquantity
//shippingweight
//purchaseorder
//shipmjrintersection
//shipappointment
//shipdescription
//shipunits
//shippallets
//shipboxes
//shippickref
//shippicknumber
//shipapptime
//shipaddresslat
//shipaddresslng
//shipcontactpersonname
//shipcontactpersonphone
//
//Consignee columns :
//consigneename
//consigneeaddress
//consigneedate
//consigneetime
//consigneequantity
//consigneeweight
//consigneepurchaseorder
//cmjrintersection
//cappointment
//cdescription
//consigneeunits
//consigneepallets
//consigneeboxes
//consigneedeliveryref
//consigneedeliverynumber
//conapptime
//conaddresslat
//conaddresslng
//concpn
//concpp
//
//
//
//•	Check in
//
//https://www.itruckdispatch.com/api/checkin?loadid=loadid&innumber=innumber&location=location&intime=intime&currentlat=&currentlat&currentlng=currentlng&apikey=apikey
//
//
//loaded -loadnumber  of the load being delivered
//innumber – as there are multiple pickup option, please mention which pickup did the user picked.
//location – location from where the pickup was done
//checkintime – time when the load was picked from the location
//apikey – valid apikey
//
//•	Check out
//
//https://www.itruckdispatch.com/api/checkout?loadid=loadid&outnumber=outnumber&location=location&outtime=outime&currentlat=&currentlat&currentlng=currentlng &apikey=apikey
//
//loadid -loadnumber  of the load being delivered
//outnumber – as there are multiple delivery option, please mention which did the user deliver
//location – location from where the pickup was done
//checkouttime – time when the load was deliver to the location
//apikey – valid apikey
//
//
//
//
//Notification
//•	Acceptload
//
//https://www.itruckdispatch.com/api/acceptload?loadid=loadid& acceptstatus=acceptstatus &currentlat=&currentlat&currentlng=currentlng &apikey=apikey
//
//loadid -loadnumber  of the load being delivered
//acceptstatus = if the driver accepts send status 1
//currentlat = latitude for current location
//currentlng = longitude for current location
//apikey – valid apikey
//
//•	Current Location
//
//https://www.itruckdispatch.com/api/currentlocation?loadid=loadid& &currentlat=&currentlat&currentlng=currentlng &apikey=apikey
//
//loadid -loadnumber  of the load being delivered
//currentlat = latitude for current location
//currentlng = longitude for current location
//apikey – valid apikey
//
//
//•	API for yet to accept loads
//
//https://www.itruckdispatch.com/api/acceptloadsfordriver?phone=phone&apikey=apikey
//
//where
//phone – phone number of the driver
//apikey – valid apikey
//
//•	Upload Edoc
//
//https://www.itruckdispatch.com/api/eDocUpload?phone=phone&apikey=apikey&file=file
//
//where
//phone – phone number of the driver
//apikey – valid apikey
//file --- MulripartFile to be uploaded
//
//
//•	Loads between from and To //search and filter
//
//https://www.itruckdispatch.com/api/loadsbetween?phone=phone&apikey=apikey&from=from&to=to
//
//where
//phone – phone number of the driver
//apikey – valid apikey
//from -- start date for search
//to --  to date for search
//
//•	Upload profile pic
//
//https://www.itruckdispatch.com/api/profilepicupdate?driverid=driverid&apikey=apikey&file=file
//
//where
//driverid – driver id for the logged in driver
//apikey – valid apikey
//file --- MulripartFile to be uploaded
//
//
//
//
//
//
//
//
//
//
//
//
//
//Notify my app when someone request a deliver.
//When some send message I will send
//1- User id
//
//Asking for notifications for page number 13. Waiting for all notification of the user.
//
//
//Required API list
//
//•	Phone Number Authentication
//
//API SENDING OTP TO DRIVER's NUMBER
//
//https://www.itruckdispatch.com/api/sendotpviaphone?phone=phone&apikey=apikey
//
//where
//phone – phone number of the driver
//apikey – valid apikey
//
//API FOR LOGIN:
//
//https://www.itruckdispatch.com/api/login?phone=phone&otpflag=otpflag&apikey=apikey
//
//Where
//phone – phone number of the driver
//otpflag – 0 : if the OTP doesnot match and 1 : if the OTP matches
//apikey – valid apikey
//
//
//
//•	User data
//
//API FOR PROFILE SCREEN
//
//https://www.itruckdispatch.com/api/profile?phone=phone&apikey=apikey
//
//where
//phone – phone number of the driver
//apikey – valid apikey
//
//
//API FOR DASHBOARD SCREEN
//
//https://www.itruckdispatch.com/api/dashboard?phone=phone&apikey=apikey
//
//where
//phone – phone number of the driver
//apikey – valid apikey
//
//Response:
//
//List having number of loads and completed loads will be returned.
//1st  element - all loads
//2nd  element – completed loads
//
//
//
//
//
//
//•	Loads Request all
//
//API FOR ALL LOADS FOR DRIVER
//
//https://www.itruckdispatch.com/api/loadsfordriver?phone=phone&apikey=apikey
//
//where
//phone – phone number of the driver
//apikey – valid apikey
//
//Columns for displaying the loads:
//
//All the address and details for shipper and consignee are available under the Shippers and consignees column and the records are separated using @@ and the details for each record are separated by
//##Example : test##Yellowstone National Park, United States##Aug 10,2020##00:00##NA##NA##NA##NA##No##NA##NA##NA##NA##NA##NA##NA##40.758701##-111.876183##Gunjan##8591162012@@test##Yellowstone National Park, United States##Aug 10,2020##00:00##NA##NA##NA##NA##No##NA##NA##NA##NA##NA##NA##NA##39.419220##-111.950684##Gunjan##8591162012
//
//
//Shipper columns :
//shippername
//shipperaddress
//shippingdate
//shippingtime
//shippingquantity
//shippingweight
//purchaseorder
//shipmjrintersection
//shipappointment
//shipdescription
//shipunits
//shippallets
//shipboxes
//shippickref
//shippicknumber
//shipapptime
//shipaddresslat
//shipaddresslng
//shipcontactpersonname
//shipcontactpersonphone
//
//Consignee columns :
//consigneename
//consigneeaddress
//consigneedate
//consigneetime
//consigneequantity
//consigneeweight
//consigneepurchaseorder
//cmjrintersection
//cappointment
//cdescription
//consigneeunits
//consigneepallets
//consigneeboxes
//consigneedeliveryref
//consigneedeliverynumber
//conapptime
//conaddresslat
//conaddresslng
//concpn
//concpp
//
//
//
//•	Check in
//
//https://www.itruckdispatch.com/api/checkin?loadid=loadid&innumber=innumber&location=location&intime=intime&currentlat=&currentlat&currentlng=currentlng&apikey=apikey
//
//
//loaded -loadnumber  of the load being delivered
//innumber – as there are multiple pickup option, please mention which pickup did the user picked.
//location – location from where the pickup was done
//checkintime – time when the load was picked from the location
//apikey – valid apikey
//
//•	Check out
//
//https://www.itruckdispatch.com/api/checkout?loadid=loadid&outnumber=outnumber&location=location&outtime=outime&currentlat=&currentlat&currentlng=currentlng &apikey=apikey
//
//loadid -loadnumber  of the load being delivered
//outnumber – as there are multiple delivery option, please mention which did the user deliver
//location – location from where the pickup was done
//checkouttime – time when the load was deliver to the location
//apikey – valid apikey
//
//
//
//
//Notification
//•	Acceptload
//
//https://www.itruckdispatch.com/api/acceptload?loadid=loadid& acceptstatus=acceptstatus &currentlat=&currentlat&currentlng=currentlng &apikey=apikey
//
//loadid -loadnumber  of the load being delivered
//acceptstatus = if the driver accepts send status 1
//currentlat = latitude for current location
//currentlng = longitude for current location
//apikey – valid apikey
//
//•	Current Location
//
//https://www.itruckdispatch.com/api/currentlocation?loadid=loadid& &currentlat=&currentlat&currentlng=currentlng &apikey=apikey
//
//loadid -loadnumber  of the load being delivered
//currentlat = latitude for current location
//currentlng = longitude for current location
//apikey – valid apikey
//
//
//•	API for yet to accept loads
//
//https://www.itruckdispatch.com/api/acceptloadsfordriver?phone=phone&apikey=apikey
//
//where
//phone – phone number of the driver
//apikey – valid apikey
//
//•	Upload Edoc
//
//https://www.itruckdispatch.com/api/eDocUpload?phone=phone&apikey=apikey&file=file
//
//where
//phone – phone number of the driver
//apikey – valid apikey
//file --- MulripartFile to be uploaded
//
//
//•	Loads between from and To //search and filter
//
//https://www.itruckdispatch.com/api/loadsbetween?phone=phone&apikey=apikey&from=from&to=to
//
//where
//phone – phone number of the driver
//apikey – valid apikey
//from -- start date for search
//to --  to date for search
//
//•	Upload profile pic
//
//https://www.itruckdispatch.com/api/profilepicupdate?driverid=driverid&apikey=apikey&file=file
//
//where
//driverid – driver id for the logged in driver
//apikey – valid apikey
//file --- MulripartFile to be uploaded
//
//
//
//
//
//
//
//
//
//
//
//
//
//Notify my app when someone request a deliver.
//When some send message I will send
//1- User id
//
//Asking for notifications for page number 13. Waiting for all notification of the user.
//

//new search
//
//Search API (this is for all loads)
//https://www.itruckdispatch.com/api/search?content=content&apikey=apikey
//where
//content – content to be searched
//apikey – valid apikey
//
//
//Search API( for particualr driver loads)
//https://www.itruckdispatch.com/api/search?content=content&apikey=apikey&phone=phone
