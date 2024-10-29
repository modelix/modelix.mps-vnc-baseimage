# modelix.mps-vnc-baseimage
Docker image that runs MPS and makes the UI available to the browser

# API
These are the files and folders that are considered to be the public API of this image. 

| File/Folder           | Description                                                                                                                                                                                                                    |
|-----------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `/mps-plugins`        | MPS plugins can be copied into this directory in any shape. ZIP-files are extracted. Subfolders are searched for plugins and copied to the correct plugin folder of MPS. Call `/install-plugins.sh` after filling this folder. |
| `/install-plugins.sh` | See above                                                                                                                                                                                                                      |
| `/mps-languages`      | This path is configured as a global library in MPS. Copy any MPS modules into this folder to load them in addition to the projects.                                                                                            |
| `/mps`                | MPS home directory.                                                                                                                                                                                                            |
| `/mps-config`         | Configuration files of MPS. They are usually create automatically after the first start, but pre-configuring MPS improves the user experience.                                                                                 |
| `/mps-user-home`      | Home directory of the user used to run MPS.                                                                                                                                                                                    |
| `/mps-projects`       | All sub-folders are opened as MPS projects automatically at startup. It already contains an empty default project that can be deleted when an actual project is provided.                                                      |
