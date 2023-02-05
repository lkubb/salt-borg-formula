# vim: ft=sls

{#-
    Creates an SSH key and sends it to the mine as ``borg_pubkey``
    in order for the server to allow syncing to a repo
    with its associated private key.
#}

include:
  - .ssh
