# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as borg with context %}
{%- set keyfile = salt["user.info"]("root").home | path_join(".ssh", "id_borg") %}
{%- set ssh_pki = "ssh_pki" in salt["saltutil.list_extmods"]()["modules"] %}

Root SSH dir is present:
  file.directory:
    - name: {{ salt["file.dirname"](keyfile) }}
    - user: root
    - group: {{ borg.lookup.rootgroup }}
    - mode: '0700'

Borg SSH client key is setup:
{%- if ssh_pki is false %}
  cmd.run:
    - name: >
        ssh-keygen -q -N ''
        -t '{{ borg.client.key_type }}'
        -f '{{ keyfile }}'
{%-   if borg.client.key_bits %}
        -b {{ borg.client.key_bits }}
{%   endif %}
    - creates: {{ keyfile }}
    - require:
      - Root SSH dir is present

{%- else %}
  ssh_pki.private_key_managed:
    - name: {{ keyfile }}
    - algo: {{ borg.client.key_type if borg.client.key_type != "ec" else "ecdsa" }}
    - keysize: {{ borg.client.key_bits | json }}
{%-   if borg.client.certs %}
    - new: true
{%-     if salt["file.file_exists"](keyfile) %}
    - prereq:
{%-       for cert_name in borg.client.certs %}
      - ssh_pki: {{ keyfile }}_{{ cert_name }}.crt
{%-       endfor %}
{%-     endif %}
{%-   endif %}

Borg SSH public key is setup:
  ssh_pki.public_key_managed:
    - name: {{ keyfile }}.pub
    - public_key_source: {{ keyfile }}
    - require:
      - ssh_pki: {{ keyfile }}

{%-   for cert_name, cert_config in borg.client.certs.items() %}

Borg SSH client cert {{ cert_name }} is present:
  ssh_pki.certificate_managed:
    - name: {{ keyfile }}_{{ cert_name }}.crt
    - cert_type: user
    - private_key: {{ keyfile }}
{%-     for param, val in borg.client.cert_params.items() %}
    - {{ param }}: {{ (cert_config[param] if param in cert_config else val) | json }}
{%-     endfor %}
{%-     if not salt["file.file_exists"](keyfile) %}
    - require:
      - ssh_pki: {{ keyfile }}
{%-     endif %}
    - require_in:
      - Borg SSH public key is removed from the mine
{%-   endfor %}

{%-   if borg.client.certs %}

Borg SSH public key is removed from the mine:
  module.run:
    - mine.delete:
      - fun: borg_pubkey
{%-   endif %}
{%- endif %}

{%- if ssh_pki is false or not borg.client.certs %}

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
{%- endif %}
