# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as borg with context %}

borg-package-install-pkg-installed:
  pkg.installed:
    - name: {{ borg.lookup.pkg.name }}
