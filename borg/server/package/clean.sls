# vim: ft=sls

{#-
    Removes the ``borg`` user and, if the repository directory
    is managed as a symlink only, will also remove the symlink.

    Does not delete the actual directory containing the repositories
    to prevent accidental data loss.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as borg with context %}

Borg user is absent:
  user.absent:
    - name: {{ borg.lookup.user }}
{%- if borg.lookup.user != borg.lookup.group %}
  group.absent:
    - name: {{ borg.lookup.group }}
{%- endif %}

# Only remove the repositories if the data is located somewhere else.
# This is intended to prevent accidental data loss.
{%- if borg.server.symlink_repos %}

Borg repository dir is absent:
  file.absent:
    - name: {{ borg.lookup.repos }}
{%- endif %}
