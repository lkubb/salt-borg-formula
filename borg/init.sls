# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as borg with context %}

include:
  - .package
{%- if "server" == pillar.get("borg_role") %}
  - .server
{%- elif "client" == pillar.get("borg_role") %}
  - .client
{%- endif %}
