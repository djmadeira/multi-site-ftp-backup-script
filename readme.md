This is a simple backup & uptime monitoring utility written in C and bash. It's basically a text parser and bash script that automatically runs lftp's `mirror` command on sites in the `sites_conf` file.

You'll need to install lftp (on OS X, you can use [macports](https://www.macports.org/): `sudo port install lftp`).

The only configuration is a text file, sites_conf, which contains the directory name, SFTP login, and host for your sites. Then the bash script cycles through and runs a backup for each one.

# Usage
1. Add your site to the sites file in this format: `<name> <username>,<password> <host>` (1 site per line)
2. `$ sh ./backup.sh`
3. (If you also want uptime monitoring) In a new shell session, `$ sh ./ping.sh`

# Todo
* Add configuration options for protocols other than SFTP
* Add support for specifiying the config file path from the command line

# Bug/undesired behavior list
* A failed connection will retry endlessly.