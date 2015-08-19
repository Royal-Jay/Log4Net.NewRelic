using System;
using System.Collections.Generic;
using log4net.Appender;
using log4net.Core;

namespace RoyalJay.Log4Net.NewRelic
{
    public class NewRelicAppender : AppenderSkeleton
    {
        //https://docs.newrelic.com/docs/agents/net-agent/features/new-relic-net-status-monitor
        //https://docs.newrelic.com/docs/agents/net-agent/features/net-agent-api
        //nuget pack Log4Net.NewRelic.csproj -Prop Configuration=Release
        //Install-Package Log4Net.NewRelic.1.0

        protected override void Append(LoggingEvent loggingEvent)
        {
            IDictionary<string, string> parameters = new Dictionary<string, string>();

            parameters.Add("Level", loggingEvent.Level.ToString());
            parameters.Add("LoggerName", loggingEvent.LoggerName);
            parameters.Add("ThreadName", loggingEvent.ThreadName);
            parameters.Add("Machine", Environment.MachineName);
            parameters.Add("Identity", loggingEvent.Identity);

            global::NewRelic.Api.Agent.NewRelic.NoticeError(loggingEvent.MessageObject.ToString(), parameters);
        }
    }
}
