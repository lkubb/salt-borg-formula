# -*- coding: utf-8 -*-
# vim: ft=sls

include:
{%- if borg.server.enable %}
  - .server.clean
{%- endif %}
  - .package.clean
