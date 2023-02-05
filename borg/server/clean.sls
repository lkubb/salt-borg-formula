# vim: ft=sls


{#-
    Undoes most of the things `borg.server`_ configures.

    Includes `borg.server.package.clean`_ and `borg.server.repos.clean`_.
#}

include:
  - .repos.clean
  - .package.clean
