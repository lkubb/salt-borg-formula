# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as borg with context %}

BorgBackup is installed:
  pkg.installed:
    - name: {{ borg.lookup.pkg.name }}
