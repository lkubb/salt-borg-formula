# -*- coding: utf-8 -*-
# vim: ft=sls

include:
{%- if "server" == pillar.get("borg_role") %}
  - .server.clean
{%- elif "client" == pillar.get("borg_role") %}
  - .client.clean
{%- endif %}
  - .package.clean
