The user can upload directly to Zenodo through the training catalogue.


Create Zenodo material on the catalogue                 |  Zenodo material created                   |  The material on Zenodo
:-------------------------:|:-------------------------:|:-------------------------:
![Creation Zenodo material](https://i.imgur.com/Z702A0X.png)  |  ![Zenodo material](https://i.imgur.com/0I1t2JI.png)  |  ![on Zenodo](https://i.imgur.com/E7qv7U5.png)


### Small todos:

- Fix a size limit for the file.  

- Tiny detail but the new version (pseudo)button slightly changes colour when the mouse hovers over it when disabled. Make it not.


### Big todos:

- Check the text and the description before an upload to make sure it isn't spam.

- Take into account the success/failure codes zenodo's api sends back. Properly catch all the possible errors/failures. And in general try to catch other possible errors (when calling split on a potential nil(due to an error of some kind) value for example).

### In the near(ish) future:

- Finish oauth2 implementation.

### Refactorisation to do at a later date:

- Quite a lot of repetition in the code, make it DRYer.


