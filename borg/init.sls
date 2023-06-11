# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as borg with context %}

{#-
    *Meta-state*.

    This installs the borg package
    and includes `borg.client`_ or `borg.server`_,
    depending on the pillar value of ``borg_role``.

#}

include:
  - .package
{%- if "server" == pillar.get("borg_role") %}
  - .server
{%- elif "client" == pillar.get("borg_role") %}
  - .client
{%- endif %}
