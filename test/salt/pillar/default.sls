# vim: ft=yaml
---
borg:
  lookup:
    master: template-master
    # Just for testing purposes
    winner: lookup
    added_in_lookup: lookup_value
    pkg:
      name: borgbackup
    bin:
      signature: https://github.com/borgbackup/borg/releases/download/{version}/borg-linux64.asc
      signed_by_all: null
      signed_by_any:
        - 6D5BEF9ADD2075805747B70F9F88FB52FAF7B393
      source: https://github.com/borgbackup/borg/releases/download/{version}/borg-linux64
      source_hash: null
      source_hash_sig: null
      symlink: /usr/local/bin/borg
      target: /opt/borgbackup/borg
    gh_repo: borgbackup/borg
    gpg:
      fingerprint: 6D5BEF9ADD2075805747B70F9F88FB52FAF7B393
      keyserver: keys.openpgp.org
      lib:
        pip: python-gnupg
        pkg: python3-gnupg
      pkg: gpg
    group: borg
    home: /home/borg
    repos: /home/borg/repos
    shell: /usr/bin/bash
    user: borg
  client:
    cert_params:
      all_principals: false
      backend: null
      backend_args: null
      ca_server: null
      signing_policy: null
      ttl: null
      ttl_remaining: null
      valid_principals: null
    certs: {}
    key_bits: null
    key_type: ed25519
  install:
    allow_alpha: false
    allow_beta: false
    method: repo
    version: latest
    version_major: 1
  server:
    repos: []
    repos_mine:
      default:
        append_only: false
        quota: false
    symlink_repos: false

  tofs:
    # The files_switch key serves as a selector for alternative
    # directories under the formula files directory. See TOFS pattern
    # doc for more info.
    # Note: Any value not evaluated by `config.get` will be used literally.
    # This can be used to set custom paths, as many levels deep as required.
    files_switch:
      - any/path/can/be/used/here
      - id
      - roles
      - osfinger
      - os
      - os_family
    # All aspects of path/file resolution are customisable using the options below.
    # This is unnecessary in most cases; there are sensible defaults.
    # Default path: salt://< path_prefix >/< dirs.files >/< dirs.default >
    #         I.e.: salt://borg/files/default
    # path_prefix: template_alt
    # dirs:
    #   files: files_alt
    #   default: default_alt
    # The entries under `source_files` are prepended to the default source files
    # given for the state
    # source_files:
    #   borg-config-file-file-managed:
    #     - 'example_alt.tmpl'
    #     - 'example_alt.tmpl.jinja'

    # For testing purposes
    source_files:
      borg-config-file-file-managed:
        - 'example.tmpl.jinja'

  # Just for testing purposes
  winner: pillar
  added_in_pillar: pillar_value
