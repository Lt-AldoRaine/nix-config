{
  services.fail2ban = {
    enable = true;
    # Ban IP after 5 failures
    maxretry = 2;
    ignoreIP = [
      # Whitelist some subnets
      "10.0.0.0/8"
      "192.168.0.0/16"
    ];
    bantime = "24h"; # Ban IPs for one day on the first ban
    bantime-increment = {
      enable = true; # Enable increment of bantime after each violation
      formula =
        "ban.Time * math.exp(float(ban.Count+1)*banFactor)/math.exp(1*banFactor)";
      maxtime = "168h"; # Do not ban for more than 1 week
      overalljails = true; # Calculate the bantime based on all the violations
    };
  };
}
