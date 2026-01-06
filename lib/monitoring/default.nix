{ lib, ... }:
let
  # Helper function to create a Prometheus scrape config
  mkPrometheusScrape = { jobName, port, path ? "/metrics", labels ? {} }:
    {
      job_name = jobName;
      static_configs = [{
        targets = [ "localhost:${toString port}" ];
        inherit labels;
      }];
      metrics_path = path;
    };

  # Helper function to create Prometheus alerting rules
  mkServiceAlerts = { serviceName, jobName, port ? null }:
    let
      baseRules = [
        {
          alert = "${serviceName}_down";
          expr = "up{job=\"${jobName}\"} == 0";
          for = "1m";
          labels = {
            severity = "critical";
          };
          annotations = {
            summary = "${serviceName} is down";
            description = "${serviceName} has been down for more than 1 minute.";
          };
        }
      ];
      
      httpRules = lib.optionals (port != null) [
        {
          alert = "${serviceName}_high_response_time";
          expr = "histogram_quantile(0.95, rate(http_request_duration_seconds_bucket{job=\"${jobName}\"}[5m])) > 1";
          for = "5m";
          labels = {
            severity = "warning";
          };
          annotations = {
            summary = "${serviceName} has high response time";
            description = "${serviceName} 95th percentile response time is above 1s for 5 minutes.";
          };
        }
        {
          alert = "${serviceName}_high_error_rate";
          expr = "rate(http_requests_total{job=\"${jobName}\",status=~\"5..\"}[5m]) > 0.05";
          for = "5m";
          labels = {
            severity = "warning";
          };
          annotations = {
            summary = "${serviceName} has high error rate";
            description = "${serviceName} error rate is above 5% for 5 minutes.";
          };
        }
      ];
    in
    {
      groups = [
        {
          name = "${serviceName}_alerts";
          interval = "30s";
          rules = baseRules ++ httpRules;
        }
      ];
    };
in
{
  inherit mkPrometheusScrape mkServiceAlerts;
}
