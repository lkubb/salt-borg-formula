# vim: ft=sls

{#-
    Creates a ``borg`` user and a directory to host
    repositories in.
#}

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as borg with context %}

Borg user is setup:
  user.present:
    - name: {{ borg.lookup.user }}
    - home: {{ borg.lookup.home }}
    - shell: {{ borg.lookup.shell }}
    - createhome: true
{%- if borg.lookup.user != borg.lookup.group %}
    - gid: {{ borg.lookup.group }}
    - require:
      - group: {{ borg.lookup.group }}
  group.present:
    - name: {{ borg.lookup.group }}
{%- endif %}

# Symlinks are helpful when the repositories are
# located outside the user home, e.g. NFS mounts in /mnt.
Borg repository dir is present:
{%- if borg.server.symlink_repos %}
  file.symlink:
    - target: {{ borg.server.symlink_repos }}
{%- else %}
  file.directory:
{%- endif %}
    - name: {{ borg.lookup.repos }}
    - user: {{ borg.lookup.user }}
    - group: {{ borg.lookup.group }}
    - mode: '0700'
