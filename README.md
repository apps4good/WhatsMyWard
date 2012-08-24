# What's My Ward? #

What’s My Ward is an app to help find what ward you live in, and provide contact information for your municipal representative.

The app is designed to be whitelabeled for re-use, simply change color codes, replace icons and update KML files.

### Whitelabel ###
* In XCode, duplicate the Saskatoon target with the name of your city (ex Regina)
* Right-click on your new target (ex Regina) select Get Info > Build tab > rename Product Name to name of city without spaces (ex Regina)
* Duplicate the /Themes/Saskatoon folder with the name of your city as folder name (ex /Themes/Regina)
* Replace each image in the folder with your own custom graphic, maintaining the image dimensions and filenames
* In XCode, on your new theme folder (ex /Themes/Regina) Right-Click > Get Info > Targets tab, uncheck Saskatoon and check your new target (ex Regina)
* You can now customize your app by editing the following properties in Info.plist in your new Themes folder

##### Description #####
* CFBundleIdentifier: unique identifier of your app (ex ca.apps4good.whatsmyward.saskatoon)
* CFBundleName: title of your application (ex Regina)
* CFBundleDisplayName: name of your application (ex Regina)
* A4GAppText: description text of the app
* A4GAppURL: url for App Store to download the app

##### KML #####
Replace all KML files with regions and points you would like to display on the map. 

You can update the <description> for Placemark Polygon will in the KML with JSON block you would like to display for that region. For example, the follow will display four table sections: Name, Description, Email and Website with the related information.

{"Name":"Apps4Good",
 "Description":"We build apps :)",
 "Email":"contact@apps4good.ca",
 "Website":"http://apps4good.ca"}
               
##### Apps4Good #####
* A4GAboutText: description text of Apps4Good
* A4GAboutEmail: contact email for Apps4Good website
* A4GAboutURL: url for Apps4Good website

##### Colors #####
* A4GNavBarColor: color for the navigation bar 
* A4GButtonDoneColor: color for done buttons
* A4GTablePlainBackColor: color of table background for plain tables
* A4GTablePlainTextColor: color of text for plain tables
* A4GTablePlainRowOddColor: color of background for odd rows
* A4GTablePlainRowEvenColor: color of background for even rows
* A4GTablePlainHeaderBackColor: color of header background for plain tables
* A4GTablePlainHeaderTextColor: color of header text for plain tables
* A4GTableGroupedBackColor: color for table background for grouped tables
* A4GTableGroupedTextColor: color for table text for grouped tables
* A4GTableGroupedHeaderTextColor: color for table header text for grouped tables

### Questions ###
Please email contact@apps4good.ca with any questions about re-use of the source code.

### License ###
Copyright (c) 2012, Apps4Good. All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
* Neither the name of the Apps4Good nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.