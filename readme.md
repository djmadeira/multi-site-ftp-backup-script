# FTP Backup Script
This is a simple utility for backing up a lot of S/FTP sites quickly and with minimum effot. It uses a CSV file for configuration, and can be configured to run as a daemon/agent using the included plist file.

It uses LFTP's mirror command for the FTP transaction, so it can run as often as you want without taking up very much of bandwidth.

It will gzip the files after downloading, and delete previous archives that exceed X total backups (configurable per-site in the CSV.) The idea is that you can schedule the script to run however often you want using launcd, and configure it to keep X backups at a time.

## Installation
Install [csvr](https://github.com/djmadeira/csvr), a wrapper utility for the libcsv C library.

Install [LFTP](http://lftp.yar.ru).

Add execute permissions to the backup script:

    $ chmod +x backup.sh

## Usage
Create your configuration CSV file with the following fields:

NAME,USER,PASSWORD,PROTOCOL,HOST,DIR,KEEP

(Having a header row in the CSV file that looks like the line above is required; see example.csv)

### NAME
This is the directory name of the entry. It will be refered to by this name in the output, and placed in a corresponding subdirectory.

### USER, PASSWORD
This is the FTP login that LFTP will use to connect.

### PROTOCOL
The protocol with which to connect. Can be anything LFTP supports.

### HOST
The host to connect to. Can be anything that LFTP supports.

### DIR
The directory to download on the remote FTP server. Example: /data/domains/example.com/public

### KEEP
The number of backups to keep. How often you run the script is up to you, but the number of zips that the script should keep is configurable on a per-site basis. Set to 0 to disable zips entirely.

With your config CSV created up, run:

    $ ./backup.sh <path/to/config.csv> <path/to/backup/folder>

backup.sh will create all the requisite folders automatically.

## Changelog

### 1.1
* Complete rewrite
  * Changed file format to CSV
  * Separated out csv parser
  * Added file zipping