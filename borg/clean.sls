# vim: ft=sls

{#-
    *Meta-state*.

    Undoes everything performed in the ``borg`` meta-state
    in reverse order, i.e.
    uninstalls the package
    and includes `borg.client.clean`_ or `borg.server.clean`_,
    depending on the pillar value of ``borg_role``.
#}


include:
{%- if "server" == pillar.get("borg_role") %}
  - .server.clean
{%- elif "client" == pillar.get("borg_role") %}
  - .client.clean
{%- endif %}
  - .package.clean
