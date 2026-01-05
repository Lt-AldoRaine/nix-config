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

  # Helper function to create a blackbox exporter HTTP health check
  mkBlackboxHttpCheck = { jobName, port, path ? "/", labels ? {}, blackboxPort ? 9115 }:
    {
      job_name = jobName;
      metrics_path = "/probe";
      params = {
        module = [ "http_2xx" ];
      };
      static_configs = [{
        targets = [ "http://localhost:${toString port}${path}" ];
        inherit labels;
      }];
      relabel_configs = [
        {
          source_labels = [ "__address__" ];
          target_label = "__param_target";
        }
        {
          source_labels = [ "__param_target" ];
          target_label = "instance";
        }
        {
          target_label = "__address__";
          replacement = "localhost:${toString blackboxPort}";
        }
      ];
    };

  # Helper function to create Prometheus alerting rules
  mkServiceAlerts = { serviceName, jobName, port ? null, useBlackbox ? false }:
    let
      # Use probe_success for blackbox exporter, up for direct metrics
      downExpr = if useBlackbox then "probe_success{job=\"${jobName}\"} == 0" else "up{job=\"${jobName}\"} == 0";
      baseRules = [
        {
          alert = "${serviceName}_down";
          expr = downExpr;
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
      
      # Use blackbox exporter metrics if enabled, otherwise standard HTTP metrics
      responseTimeExpr = if useBlackbox then
        "probe_http_duration_seconds{job=\"${jobName}\"} > 1"
      else
        "histogram_quantile(0.95, rate(http_request_duration_seconds_bucket{job=\"${jobName}\"}[5m])) > 1";
      
      httpRules = lib.optionals (port != null) [
        {
          alert = "${serviceName}_high_response_time";
          expr = responseTimeExpr;
          for = "5m";
          labels = {
            severity = "warning";
          };
          annotations = {
            summary = "${serviceName} has high response time";
            description = "${serviceName} response time is above 1s for 5 minutes.";
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
  inherit mkPrometheusScrape mkServiceAlerts mkBlackboxHttpCheck;
}
