# vim: ft=sls

{#-
    Creates an entry in the ``borg`` user's ``authorized_keys`` file
    for each minion that has sent a public key to the mine.

    Only minions that have the pillar value ``borg_role`` == ``client``
    are included.
#}

{%- macro render_repo(repo) -%}
command="borg serve --restrict-to-repository '{{ borg.lookup.repos | path_join(repo.name) }}'
{%- if repo.get("append_only", false) %} --append-only{%- endif -%}
{%- if repo.get("quota", false) %} --storage-quota {{ repo.quota }}{%- endif -%}
",restrict {{ repo.key }}
{%- endmacro %}

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as borg with context %}
{%- set mine_repos = salt["mine.get"]("borg_role:client", "borg_pubkey", tgt_type="pillar") %}

{%- if mine_repos or borg.server.repos %}

Borg repositories are served:
  ssh_auth.manage:
    - user: {{ borg.lookup.user }}
    - ssh_keys:
{%-   for minion, pubkey in mine_repos.items() %}
{%-     set repo_config = salt["defaults.deepcopy"](borg.server.repos_mine.get("default", {})) %}
{%-     do repo_config.update({"key": pubkey, "name": minion}) %}
{%-     do repo_config.update(borg.server.repos_mine.get(minion, {})) %}
      - {{ render_repo(repo_config) }}
{%-   endfor %}
{%-   for repo in borg.server.repos %}
      - {{ render_repo(repo) }}
{%-   endfor %}
{%- endif %}
