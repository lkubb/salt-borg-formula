# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as borg with context %}

Borg SSH client key is removed:
  file.absent:
    - name: {{ salt["user.info"]("root").home | path_join(".ssh", "id_borg") }}

Borg SSH public key is removed from the mine:
  module.run:
    - mine.delete:
      - name: borg_pubkey
