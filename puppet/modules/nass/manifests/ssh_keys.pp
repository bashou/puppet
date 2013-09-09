class nass::ssh_keys {
  ssh_authorized_key { "Perso":
    type => 'ssh-rsa',
    key => 'AAAAB3NzaC1yc2EAAAADAQABAAACAQDwfjDtx4rzoF5cnkB2qbKM/7RJHKrMxMvix3rNOqj6hRk1HO/RPcNuCo/JWUTPSyTRSdCJcS6G56qh9qkK/vdZkXWkj5hQ9vPOAP/mFseb1DLGHJ5DcGn8L+VmNdfxHIgrApBUIPJxIFv/Au+txN15FlawQcOutTHdzHjnsRK8SgSIcRkIJ47d25AOlhjHThlRi6r++HMkUYJY5jb9+ET0hPVs8lyLCZd4e1e6wxDuC8q7A7Hllw/C/OtMeyWDS1gvJDb5TGcG73mb4g4kofkCdt3qwQWSlYtOLdGXLrECmq0XLgz6tCcyDh3njOxpX6SP8XMzZlxciGyf1C4w8QmgXzcE+Ju1orvmSgcKkyx+GcR6Tnei1RGo1zQvVl2W/obLPtOKxKq9RroJ214NpcrMg1YYH5DkX780C9Ob3v91tc2JsSn61+Exw5Bmp5CE3d82d4uub7iQeqxkiiM47N7nqCciuV3bw5pTIXLbzvIOePxRoJlWMLH4sQej+2KtxOdJBYV6io1M1vv6CsjjwviCc48IxvOdANOGF852l4bYuwlxT1p+krnUEg3J/8i0YkYXunnKTDaMuA55uFf4dYVaQ8vcGd6ujxK722Nupp3jPGdNnaVo9Eph7cuejwN5Ye8PcMOxi8Hhr9uqVFvk2uKCEMPvcTJbn7zZnjOUVWPl2w==',
    ensure => present,
    user => 'dosu',
  }
}

class nass::ssh_keys::perso inherits nass::ssh_keys {
  Ssh_authorized_key["Perso"]        { ensure => present }
}
