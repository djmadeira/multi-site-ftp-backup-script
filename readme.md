# Multi-site LFTP Backup Script
This script is designed to make it easy to back up lots of FTP directories (such as a lot of websites with separate FTP connection details) really quickly using only FTP. It uses a CSV file for configuration, and uses LFTP's mirror command for the FTP transaction, meaning it only downloads changed files, saving a ton of bandwidth.

The script can make a gzip of the files after downloading, and delete previous archives that exceed X total backups (configurable with the KEEP field in the CSV.) The idea being that if you scheduled the script to run daily, you can configure it to keep 10 day's worth of backups.

The script can be configured to run as a daemon/agent on systems with launchd (such as OS X) using the included plist file. See [launchd.info](http://launchd.info).

## Installation
Install [csvr](https://github.com/djmadeira/csvr), a wrapper utility for the libcsv C library.

Install [LFTP](http://lftp.yar.ru). (With [Homebrew](http://brew.sh): `$ brew install lftp`

Add execute permissions to the backup script:

    $ chmod +x backup.sh

## Configuration Options
Create your configuration CSV file with the following fields:

NAME,USER,PASSWORD,PROTOCOL,HOST,DIR,KEEP,FLAGS

(Having a header row in the CSV file that looks like the line above is required; see example.csv)

If you have a comma in a field, make sure you wrap the field in double quotes, and if you have double quoted a field, make sure to escape any double quotes with an extra " (I didn't write the spec); see example.csv.

### NAME
This is the directory name of the entry. It will be refered to by this name in the output, and placed in a corresponding subdirectory.

### USER, PASSWORD
This is the FTP login that LFTP will use to connect.

### PROTOCOL
The protocol to use. Can be anything LFTP supports (ftp, sftp, etc.).

### HOST
The host to connect to, e.g. ftp.example.com:22. Can be anything that LFTP supports.

### DIR
The directory to download on the remote FTP server. Example: /data/domains/example.com/public_html

### KEEP
The number of gziped backups to keep. Set to 0 to disable zips entirely.

### FLAGS
Flags to pass to LFTP's mirror command, e.g. --exclude. See the mirror section of [LFTP's man page](http://lftp.yar.ru/lftp-man.html)

## Usage

    $ ./backup.sh <path/to/config.csv> <path/to/backup/folder>

## Changelog

### 1.2.1
* Fixed a bug where new zips were deleted and old ones were kept
* Added the date to the output log for easier debugging

### 1.2
* Fixed script endlessly retrying a bad connection
* Added "FLAGS" field to allow options to be passed to the mirror command on a site-by-site basis

### 1.1
* Complete rewrite
  * Changed file format to CSV
  * Separated out csv parser
  * Added file zipping