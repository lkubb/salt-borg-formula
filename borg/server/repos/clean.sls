# vim: ft=sls

{#-
    Ensures there are **no** authorized keys in the ``borg`` user's
    ``authorized_keys`` file.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as borg with context %}

Borg repositories are not served:
  ssh_auth.manage:
    - user: {{ borg.lookup.user }}
    - ssh_keys: []
