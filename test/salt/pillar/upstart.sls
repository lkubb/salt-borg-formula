# -*- coding: utf-8 -*-
# vim: ft=yaml
---
borg:
  lookup:
    master: template-master
    # Just for testing purposes
    winner: lookup
    added_in_lookup: lookup_value
    group: borg
    home: /home/borg
    repos: /home/borg/repos
    shell: /usr/bin/bash
    user: borg
  client:
    key_bits: null
    key_type: ed25519
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
