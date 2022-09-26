The user can upload directly to Zenodo through the training catalogue.


Create Zenodo material on the catalogue                 |  Zenodo material created                   |  The material on Zenodo
:-------------------------:|:-------------------------:|:-------------------------:
![Creation Zenodo material](https://i.imgur.com/Z702A0X.png)  |  ![Zenodo material](https://i.imgur.com/0I1t2JI.png)  |  ![on Zenodo](https://i.imgur.com/E7qv7U5.png)


### Small todos:

- Fix a size limit for the file.  

- ~~Make it possible to upload multiple files at the same time, not just a single one.~~ Make it prettier and more intuitive now.

- ~~Add a disclaimer explaining that uploading through Zenodo will offer more fields. The Zenodo seamless upload feature is made for quick/fast uploads.~~

- ~~Indicate which fields are mandatory with an asterisk.~~

- ~~Add text explanations for some fields.~~

- ~~Add concerns checks for the newly created lists (see has_licence as an already existing example).~~

- ~~Indicate which fields zenodo takes into account with colours.~~

- ~~The second type for image and publication does not work if not manually selected, probably something to do with no default existing.~~

- ~~Change the "delete" button to "delete from training catalogue". Explain that it is not possible to delete a published material on Zenodo.~~

- ~~Make the file upload mandatory for certain actions(create,newversionupdate) and not for others(update).~~

- Tiny detail but the new version (pseudo)button slightly changes colour when the mouse hovers over it when disabled. Make it not.

- ~~Check the behaviour when the new version button is pressed once, then the user does not subsequently press update. If the user comes back to create a new version and presses again on the new version button, does everything work properly?~~ 

### Big todos:

- Check the text and the description before an upload to make sure it isn't spam.

- ~~Add editing~~.

- Take into account the success/failure codes zenodo's api sends back. Properly catch all the possible errors/failures. And in general try to catch other possible errors (when calling split on a potential nil(due to an error of some kind) value for example).

### In the near(ish) future:

- Create a slightly different system where the API key used is the user's. This is a more resilient system. This system can use most everything done here, but a slight tweak to add the user's api key instead of our own needs to be implemented. Both possible systems could co-exist at the same time and the user could chose which one he/she wants to use. 

- Rather than the above, perhaps using oauth authentication for the user could be the way to go.

### Refactorisation to do at a later date:

- Quite a lot of repetition in the code, make it DRYer.


