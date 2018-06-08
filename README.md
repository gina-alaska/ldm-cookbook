# ldm cookbook

* Installs ldm from source code
* Configures ldmd.conf, scour.conf, and pqact.conf based on attributes
* Adds cronjobs based on attributes

# Requirements

* chef
* CentOS 6 or Centos 7

# Usage

* to stop the ldm from being started set `node['ldm']['auto-start'] = false`

# Attributes
sample attribute from node json:
```
    "override_attributes": {
      "ldm": {
        "requests": [
  
        ],
        "allows": [
          {
            "feedset": "ANY",
            "hostname": "(10.10.10.*)",
            "ok": ".*"
          }
        ],
        "accepts": [
  
        ],
        "scours": [
          {
            "directory": "/opt/ldm/data",
            "days_old": "3",
            "pattern": "*"
          }
        ],
        "pqacts": [
          {
            "feedtype": "EXP",
            "pattern": "^([0-9]*)_([0-9]*)_stuff_(this|that)\\.gz$",
            "action": "FILE",
            "options": "data/exp/\\1_\\2_stuff\\3.gz",
            "action_args": ""
          }
        ],
        "cronjobs": [
          {
            "name": "newlog",
            "minute": "0",
            "hour": "0",
            "day": "*",
            "month": "*",
            "weekday": "*",
            "user": "ldm",
            "command": "bash -l -c 'ldmadmin newlog' >/opt/ldm/var/logs/cron.ldmadmin.newlog.log 2>&1"
          },
          {
            "name": "scour",
            "minute": "30",
            "hour": "*/4",
            "day": "*",
            "month": "*",
            "weekday": "*",
            "user": "ldm",
            "command": "bash -l -c 'ldmadmin scour' >/opt/ldm/var/logs/cron.ldmadmin.scour.log 2>&1"
          }
        ]
      }
    } 
```

# Recipes

# Author

Scott Macfarlane
Author:: Scott Macfarlane (<scott@gina.alaska.edu>)

and UAF-GINA 
