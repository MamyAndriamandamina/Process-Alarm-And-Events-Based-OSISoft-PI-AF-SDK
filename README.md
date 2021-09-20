<h1>Output</h1>
<p>This repository aims to provide the complete package for running any Industrial Alarm and Events Reporting using OSISoft PI-AF SDK and Microsoft SQL Server.</p>
<p>If the implementation is successuful, then this repository should return an email notification to 2 different group of users on a daily baisis for all different plant areas.</p>
<p>The email notification will contain the top 10 highest alarm and events occurence for each plant areas.</p>
<p>The output is an email notification with a subject, a title, a time frame reporting, some statistical tables under HTML format as e-mail body.</p>

<h1>Other Dependencies</h1>
<p>We assume that the users running this application use OSISoft PI System to capture their alarm and events tags.</p>
<p>And the structure of the alarm and events tags value is a simple string concatenation separated by a pipe and as followed:</p>
<p>[Source]|[EventCategory]|[Condition]|[SubCondition]|[Severity]|[Message]|[ActorID]|[Enabled]|[Active]|[Ackd]|[AckReqd]|[Quality]</p>

<h1>Implementation</h1>
<p>Open the solution named AlarmEvents.sln using Microsoft Visual Studio and perform all required change to fit your case such as:</p>
<p>Name of SQL Server instance, your sa password, OSISoft PI server connection if you are not using the default PI server...</p>
<p>Then publish your standalone project into your desired location.</p>
<p>Run all SQL Queries found in SQL Folder to configure your Jobs, Stored Procedures, SQL Tables and your SQL Views.</p>
<p>Please feel free to edit the SQL queries to match with your case (Job schedule, Plant area name, Field to skip as object excursion, Email users,...)</p>
<p>That's it! good luck :)</p>

<h1>Guarantee</h1>
<p>This project is expected to run on a daily basis to send an email notification to a certain group of users.</p>
<p>(Process Engineers, Instrumentation Engineers, Process Safety Team...) regarding the Top 10 Alarm and Events Hit List retreived from an Industrial Metal Extraction Plant.</p>
<p>This project runs for more than 1 year without any interruption nor Human action to run in our environment.</p>
<p>There is, unfortunately, no guarantee that it will work in your environment.</p>
<p>So kindly, feel free to commit and/or send your contribution.</p> 

<p>Mamy.</p>