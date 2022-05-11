# -*- coding: utf-8 -*-
# vim: ft=sls

{%- macro render_repo(repo) -%}
command="borg serve --restrict-to-repository '{{ borg.lookup.repos | path_join(repo.name) }}'
{%- if repo.get("append_only", false) %} --append-only{%- endif -%}
{%- if repo.get("quota", false) %} --storage-quota {{ repo.quota }}{%- endif -%}
",restrict {{ repo.key }}
{%- endmacro %}

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as borg with context %}

{%- if borg.server.repos %}

Borg repositories are served:
  ssh_auth.manage:
    - user: {{ borg.lookup.user }}
    - ssh_keys:
{%-   for repo in borg.server.repos %}
      - {{ render_repo(repo) }}
{%-   endfor %}
{%- endif %}
