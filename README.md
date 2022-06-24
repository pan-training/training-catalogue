## Changes (ongoing)

Changes are ongoing, mainly: 
like button, share button, 404 url checker fixed, tess bug where stars dont get deleted if the material gets deleted and misc.

### Likes

Likes implemented. 

### Share button

Share button implemented. Still needs to be tested on the respective social platforms.

### Star bug fix

When a user starred a material (or other), and then deleted that material, and went to see his starred materials nothing would appear.
The dependent destroy relationship did not work. When one material was deleted, it's likes weren't deleted too. 
Now it is fixed.

The rest will be done progressively and this README will be updated.

Another different branch will be created for the zenodo seamless upload at a later date.
