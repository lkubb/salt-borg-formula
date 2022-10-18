# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as borg with context %}
{%- set keyfile = salt["user.info"]("root").home | path_join(".ssh", "id_borg") %}

Root SSH dir is present:
  file.directory:
    - name: {{ salt["file.dirname"](keyfile) }}
    - user: root
    - group: {{ borg.lookup.rootgroup }}
    - mode: '0700'

Borg SSH client key is setup:
  cmd.run:
    - name: >
        ssh-keygen -q -N ''
        -t '{{ borg.client.key_type }}'
        -f '{{ keyfile }}'
{%- if borg.client.key_bits %}
        -b {{ borg.client.key_bits }}
{% endif %}
    - creates: {{ keyfile }}
    - require:
      - Root SSH dir is present

Borg SSH client key is default:
  file.prepend:
    - name: {{ salt["file.dirname"](keyfile) | path_join("config") }}
    - text: IdentityFile ~/.ssh/id_borg
    - require:
      - Borg SSH client key is setup

Borg SSH public key is sent to the mine:
  module.run:
    - mine.send:
      - name: borg_pubkey
      - mine_function: file.read
      - allow_tgt: 'borg_role:server'
      - allow_tgt_type: pillar
      - path: {{ keyfile }}.pub
      - binary: false
    - require:
      - Borg SSH client key is setup
