The user can interact with Zenodo through the training catalogue. For example he can upload content as shown below.  


Create Zenodo material on the catalogue                 |  Zenodo material created                   |  The material on Zenodo
:-------------------------:|:-------------------------:|:-------------------------:
![Creation Zenodo material](https://i.imgur.com/Z702A0X.png)  |  ![Zenodo material](https://i.imgur.com/0I1t2JI.png)  |  ![on Zenodo](https://i.imgur.com/E7qv7U5.png)


### todos :

- Take into account the success/failure codes zenodo's api sends back. Properly catch all the possible errors/failures. And in general try to catch other possible errors (when calling split on a potential nil(due to an error of some kind) value for example).

- Finish PaNET ontology integration.  

### todos in the future:

- Continue the refresh token logic in the oauth2 implementation. We will store the encrypted refresh token in the db.

- Quite a lot of repetition in the code, refactor it, make it DRYer.



