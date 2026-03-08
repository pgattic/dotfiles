
# Family Home Server Setup

This module defines the Corless Family home server setup.

## Setup

There may be a couple of things you'd want to set up before building/applying this module in one shot. Here's a list of things I can think of, in no particular order:

- Nix doesn't declare ZFS partitions! But this config assumes it's been done. Set up external storage, ZFS pools, and mount point. Following are the entries found in `zfs list` at the time of writing:
```
tank
tank/appdata
tank/appdata/postgresql
tank/media
tank/media/audiobooks
tank/media/default
tank/media/home
tank/media/movies
tank/media/music
tank/media/roms
tank/secrets
tank/store
tank/store/cookbook
tank/store/pgattic
tank/store/roms
```

`/tank/media/roms` is where romM accesses roms (not currently in use), and `/tank/store/roms` is the ROMs file share in Copyparty

- For agenix, make sure to have the proper SSH key setup and files in place. See `/modules/features/agenix.nix` for their details.

