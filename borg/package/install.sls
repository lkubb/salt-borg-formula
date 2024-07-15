# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as borg with context %}

{%- if borg.install.method == "repo" %}

BorgBackup is installed:
  pkg.installed:
    - name: {{ borg.lookup.pkg.name }}

{%- else %}
{%-   set version = borg.install.version %}
{%-   if version == "latest" %}
{%-     set disallow = [] %}
{%-     if not borg.install.allow_alpha %}
{%-       do disallow.append("a") %}
{%-     endif %}
{%-     if not borg.install.allow_beta %}
{%-       do disallow.append("b") %}
{%-     endif %}
{%-     if not borg.install.allow_rc %}
{%-       do disallow.append("rc") %}
{%-     endif %}
{%-     set version = salt["github_releases.latest_version"](borg.lookup.gh_repo, borg.install.version_major, disallow=disallow) %}
{%-   endif %}

{%-   set osname = borg.lookup.bin.os_name %}
{%-   set version_float = version[:3] | float %}
{%-   if version_float >= 1.4 and version_float < 2 %}
{%-     if borg.install.glibc %}
{%-       set glibc = "-glibc{}".format(borg.install.glibc) %}
{%-     else %}
{%-       set glibc = "-glibc228" %}
{%-     endif %}
{%-   else %}
{%-     set glibc = "" %}
{%-     set osname = osname ~ "64" %}
{%-   endif %}


Borg release GPG key is present:
  gpg.present:
    - name: {{ borg.lookup.gpg.fingerprint[-16:] }}
    - keyserver: {{ borg.lookup.gpg.keyserver }}

Borg user/group is present:
  user.present:
    - name: {{ borg.lookup.user }}
    - system: true
    - usergroup: {{ borg.lookup.group == borg.lookup.user }}
{%- if borg.lookup.group != borg.lookup.user %}
    - gid: {{ borg.lookup.group }}
    - require:
      - group: {{ borg.lookup.group }}
  group.present:
    - name: {{ borg.lookup.group }}
    - system: true
{%- endif %}

Borg binary is installed:
  file.managed:
    - name: {{ borg.lookup.bin.target }}
    - source:
{%-   set sources = borg.lookup.bin.source %}
{%-   if not sources | is_list %}
{%-     set sources = [sources] %}
{%-   endif %}
{%-   for src in sources %}
      - {{ src.format(version=version, glibc=glibc, os=osname) }}
{%-   endfor %}
    - signature: {{ borg.lookup.bin.signature.format(version=version, glibc=glibc, os=osname) if borg.lookup.bin.signature else "null" }}
    - source_hash: {{ borg.lookup.bin.source_hash.format(version=version, glibc=glibc, os=osname) if borg.lookup.bin.source_hash else "null" }}
    - source_hash_sig: {{ borg.lookup.bin.source_hash_sig.format(version=version, glibc=glibc, os=osname) if borg.lookup.bin.source_hash_sig else "null" }}
    - skip_verify: {{ not borg.lookup.bin.source_hash | to_bool }}  # The GitHub releases do not contain hashsum files
    - signed_by_any: {{ borg.lookup.bin.signed_by_any | json }}
    - signed_by_all: {{ borg.lookup.bin.signed_by_all | json }}
    - user: {{ borg.lookup.user }}
    - group: {{ borg.lookup.group }}
    - mode: '0755'
    - makedirs: true
    - require:
      - Borg release GPG key is present
      - Borg user/group is present
{%- if not not borg.lookup.bin.source_hash %}
{#-   Avoid redownloading the binary during each highstate #}
    - unless:
      - command -v borg >/dev/null && borg --version | grep -qe '{{ version }}$'
{%- endif %}

Borg is symlinked:
  file.symlink:
    - name: {{ borg.lookup.bin.symlink }}
    - target: {{ borg.lookup.bin.target }}
    - require:
      - Borg binary is installed
{%- endif %}
