using System.Text;
using System.Threading.Tasks;
using System.Diagnostics;
using System.Runtime.InteropServices;
using System.IO.Ports;
using System.IO;
using System.Data.SqlClient;
using OSIsoft.AF;
using OSIsoft.AF.PI;
using OSIsoft.AF.Time;
using OSIsoft.AF.Asset;
using System.Globalization;
using System.Net;
using System.Collections.Generic;
using System;
using System.Net.Mail;

namespace SMS
{
    class Program
    {
        public string pipointlist = null;
        static void Main(string[] args)
        {
            if (args[0] == "ReadSQLTable")
            {
                ClearSQLTable();
                ReadSQLTable();
                return;
            }
        }
        static void ReadSQLTable()
        {
            string connectionString = null;
            SqlConnection connection;
            SqlCommand command;
            SqlDataReader sReader;
            string sql = null;

            connectionString = "Data Source=<YourSQLServerInstance>;Initial Catalog=master;User ID=sa;Password=<Your_sa_Passoword>";
            sql = "USE [DCS] SELECT PIPOINTS FROM [DCS].dbo.tbl_DCS_Alarm_Events_Tags";
            connection = new SqlConnection(connectionString);

            try
            {
                connection.Open();
                command = new SqlCommand(sql, connection);
                sReader = command.ExecuteReader();
                //string[] mytags = null;
                var i = 0;
                List<string> list = new List<string>();
                while (sReader.Read())
                {
                    list.Add(String.Format("{0}", sReader[0]));
                    i = i + 1;
                }
                String[] str = list.ToArray();
                Readpipoints(str);
                command.Dispose();
                connection.Close();
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Data);
            }
        }
        static void Readpipoints(string[] tags)
        {
            //This Static method is basically used to read Alarm and Events tags from PI Points using PI SDK.
            try
            {
                // piservs is a variable that we use to store all piservers collectives
                PIServers piservs = new PIServers();
                // piserv is a particular server that is pulled among the piservs collectives and which is its default server.
                PIServer piserv = piservs.DefaultPIServer;
                // Now we are going to initiate our first connection to this server through the method Connect.
                piserv.Connect();
                AFTimeRange myTimeRange = new AFTimeRange();
                myTimeRange.StartTime = new AFTime("t+5h");
                myTimeRange.EndTime = new AFTime("y+5h");

                foreach (var tag in tags)
                {
                    var mytag = PIPoint.FindPIPoint(piserv, tag);
                    var mytagvalues = mytag.RecordedValues(myTimeRange, OSIsoft.AF.Data.AFBoundaryType.Inside, "", false, 0);
                    String[] str;
                    List<string> list = new List<string>();
                    foreach (AFValue mytagval in mytagvalues)
                    {
                        list.Add(String.Format("{0}", mytagval.Timestamp.LocalTime.ToString() + "|" + mytagval.ToString()));
                    }
                    str = list.ToArray();
                    InsertIntoDCSTable(str);
                }
                piserv.Disconnect();
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.ToString());
            }
        }
        static void InsertIntoDCSTable(string[] str)
        {
            string connectionString = null;
            SqlConnection connection;
            SqlCommand command;
            string sql = null;
            string[] Alarm_Events;
            connectionString = "Data Source=<YourSQLServerInstance>;Initial Catalog=master;User ID=sa;Password=<Your_sa_Passoword>";
            connection = new SqlConnection(connectionString);
            var i = 0;
            try
            {
                connection.Open();
                foreach (var pistringval in str)
                {
                    Alarm_Events = pistringval.Split('|');

                    sql = "USE [DCS] INSERT INTO [dbo].[tbl_DCS_Alarm_Events]([Timestamp],[Source],[EventCategory],[Condition],[SubCondition],[Severity],[Message],[ActorID],[Enabled],[Active],[Ackd],[AckReqd],[Quality])VALUES('" + Alarm_Events[0] + "','" + Alarm_Events[1] + "','" + Alarm_Events[2] + "','" + Alarm_Events[3] + "','" + Alarm_Events[4] + "','" + Alarm_Events[5] + "','" + Alarm_Events[6].Replace("'", "_") + "','" + Alarm_Events[7] + "','" + Alarm_Events[8] + "','" + Alarm_Events[9] + "','" + Alarm_Events[10] + "','" + Alarm_Events[11] + "','" + Alarm_Events[12] + "')";
                    command = new SqlCommand(sql, connection);
                    command.ExecuteNonQuery();
                    command.Dispose();
                    i = i + 1;
                }
                connection.Close();
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Data);
            }
        }
        static void ClearSQLTable()
        {
            string connectionString = null;
            SqlConnection connection;
            SqlCommand command;
            string sql = null;
            connectionString = "Data Source=<YourSQLServerInstance>;Initial Catalog=master;User ID=sa;Password=<Your_sa_Passoword>";
            sql = "USE [DCS] DROP TABLE DCS.dbo.tbl_DCS_Alarm_Events CREATE TABLE [dbo].[tbl_DCS_Alarm_Events]" + System.Environment.NewLine +
                    "([Timestamp][nvarchar](max) NULL," + System.Environment.NewLine +
                    "[Source][nvarchar](max) NULL," + System.Environment.NewLine +
                    "[EventCategory][nvarchar](max) NULL," + System.Environment.NewLine +
                    "[Condition][nvarchar](max) NULL," + System.Environment.NewLine +
                    "[SubCondition][nvarchar](max) NULL," + System.Environment.NewLine +
                    "[Severity][nvarchar](max) NULL," + System.Environment.NewLine +
                    "[Message][nvarchar](max) NULL," + System.Environment.NewLine +
                    "[ActorID][nvarchar](max) NULL," + System.Environment.NewLine +
                    "[Enabled][nvarchar](max) NULL," + System.Environment.NewLine +
                    "[Active][nvarchar](max) NULL," + System.Environment.NewLine +
                    "[Ackd][nvarchar](max) NULL," + System.Environment.NewLine +
                    "[AckReqd][nvarchar](max) NULL," + System.Environment.NewLine +
                    "[Quality][nvarchar](max) NULL," + System.Environment.NewLine +
                    ") ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]";
            connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                command = new SqlCommand(sql, connection);
                command.ExecuteNonQuery();
                command.Dispose();
                connection.Close();
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Data);
            }
        }
        static void ReadAlarmEventsTable(string Area)
        {
            string connectionString = null;
            SqlConnection connection;
            SqlCommand command;
            SqlDataReader sReader;
            string sql = null;
            connectionString = "Data Source=<YourSQLServerInstance>;Initial Catalog=master;User ID=sa;Password=<Your_sa_Passoword>";
            sql = "USE [DCS] select top 20 [Source],[Message],[EventCategory], count([Source]) as [Occurence] from tbl_DCS_Alarm_Events where [Source] like '"+Area+"::%' group by [Source],[Message],[EventCategory] order by [Occurence] desc";
            connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                command = new SqlCommand(sql, connection);
                sReader = command.ExecuteReader();
                while (sReader.Read())
                {
                    Console.WriteLine(sReader[0] +"|"+ sReader[1] + "|" + sReader[2] + "|" + sReader[3]);
                }
                command.Dispose();
                connection.Close();

            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Data);
            }
        }       
    }
}
