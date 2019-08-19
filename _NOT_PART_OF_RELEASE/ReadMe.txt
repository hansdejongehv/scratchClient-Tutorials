In this folder material will be put that belongs to the project, but which is to be excluded from releases that users install. 

When creating installers for release run the script in the folder MakeRelease.
Run on Raspberry Pi.
Those scripts will take the entire local copy of the Github project and
- Copy the whole local copy and from that copy:
- Delete the .git folder (which contains old commits and the Github administration)
- Delete the docs folder (which contians Github pages)
- Delete the _NOT_PART_OF_RELEASE folder
- Delete specific files that are not required for users of the project 
  (e.g. if delete the .pptx files of the presentations, because the user uses the .pdf files)
  
Note that those scripts make an assuption about the location of the local copy of the Github project.
If you make the release in a different context then you must adapt the variables in the beginnning of each of the scripts.

Author: Hans de Jong
Date: 2 April 2018