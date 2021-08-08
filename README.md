# LinkDownloader
Useful bash script to download files properly and at specific locations

---
/!\ Only in French /!\
## Features :
- Download in specific paths depending on file type
- Specific renaming of output file
- Resuming of aborted downloads
- Auto unzip/unrar of zip/rar files and moving extracted files to paths
- Rich output of processing task

> Change line 17 and line 42 to specify your paths

Please ensure you got `wget`, `unrar`, `unzip` and `transmission-cli` installed.
You can do this by typing `sudo apt install <package>` on your UNIX machine.

## TODO
- [ ] Auto retrieve info from input links
- [ ] Support series
- [ ] Get/improve download status
- [ ] Make it more generic (quote above) and English
