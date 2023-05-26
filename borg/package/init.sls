# vim: ft=sls

{#-
    Installs the borg package only.

    If ``borg:install:method`` == ``bin``, also ensures the release signing key
    is present in the root keychain and verifies the release signature
    by default before installing from GitHub releases.

    Mind that for the binary method to succeed, it requires my patched ``gpg``
    and ``file`` modules currently (might land in master eventually, PR pending).
    When using ``latest`` as version, this requires my custom ``github_releases`` module as well.
#}

include:
  - .install
