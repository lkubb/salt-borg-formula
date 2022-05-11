# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as borg with context %}

{%- if borg.server.repos %}

Borg repositories are not served:
  ssh_auth.manage:
    - user: {{ borg.lookup.user }}
    - ssh_keys: []
{%- endif %}
