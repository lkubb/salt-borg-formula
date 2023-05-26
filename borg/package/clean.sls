# vim: ft=sls

{#-
    Removes the borg package.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_config_clean = tplroot ~ ".config.clean" %}
{%- from tplroot ~ "/map.jinja" import mapdata as borg with context %}

include:
  - {{ sls_config_clean }}

{%- if borg.install == "repo" %}

BorgBackup is removed:
  pkg.removed:
    - name: {{ borg.lookup.pkg.name }}
    - require:
      - sls: {{ sls_config_clean }}
{%- else %}

BorgBackup is removed:
  file.absent:
    - names:
      - {{ borg.lookup.bin.target }}
      - {{ borg.lookup.bin.symlink }}
  user.absent:
    - name: {{ borg.lookup.user }}
  group.absent:
    - name: {{ borg.lookup.group }}
{%- endif %}
