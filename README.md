# Spelunker 
Application to add email alerting and reporting capabilities to Splunk Free Edition.



## Configuration

Within the preferences window you can configure:
* **Splunk** - These are the settings related to specifying the endpoint, username and password for the Splunk instance (splunkd) to be accessed.
* **SMTP** - Here you configure the SMTP server to be used for the alerts including the server/username/password as well as the to and from email addresses.

## Main Window

The main window allows for the creation and management of alerts. You set an alert name, the splunk search string to use and the alert type. There are two possible types:
* **Scheduled** - This alert will fire at a specified time and interval. For instance, if you would like a report sent every 6 hours starting at 8AM you would set the timepicker to 8AM and the interval to 6. An email will still be sent even if there are no results. Kind of does what it says on the tin.
* **Polling** - More appropriate for realtime monitoring, this alert type will poll with the search string every 2 minutes and if results are returned, the alert will be sent.

## Log Viewer
This window views the logs being generated as the application is running. When built in 'debug' mode, debug logs will be included. 'Release' mode will only log from info on. Logs are also written to the console as well as to disk with a 7 day rolling window.

## Thirdparty Libraries
This application leverages some terrific thirdparty libraries:
* [JSONModel](https://github.com/jsonmodel/jsonmodel)
* [MailCore2](https://github.com/mailcore/mailcore2)
* [SAMKeychain](https://github.com/soffes/SAMKeychain)

## Licensing et al. 
*Spelunker is not endorsed by or in any way affiliated with Splunk, Inc.*

Spelunker is released under the MIT license:

> The MIT License (MIT)
> Copyright (c) 2017 Renaud Holcombe

> Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

> The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
