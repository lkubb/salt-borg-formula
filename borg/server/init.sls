# vim: ft=sls

{#-
    Handles system setup and repository management
    specific to a borg server.

    Includes `borg.server.package`_ and `borg.server.repos`_.
#}

include:
  - .package
  - .repos
