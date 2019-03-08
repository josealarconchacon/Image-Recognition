# Recongition & Reunification

## Overview

Recognition & Reunification is an app that is intended to assist refugees in reunification with their family members. While some organizations 
have attempted to solve this challenge 
<a href="https://www.nytimes.com/2017/10/04/opinion/a-better-way-to-trace-scattered-refugees.html">using a database of names and contact information</a>,
Recognition & Reunification provides an additional assist via the use of Artificial Intelligence.

Recognition & Reunification takes advantage of the Microsoft Cognitive Services APIs to compare a photo that a user uploads against 
a list of individuals seeking reunification. If a potential match is found, the user can add additional information, which is sent 
to the database so that a nonprofit employee can review and verify the match, and reach out to the user (if verified) to facilitate contact and the 
reunification process. 

To protect individual privacy, contact information is not passed directly from one individual to another via the app. 

## Process

After authenticating, the user is taken to a screen where they can upload a photo.

<img src="https://s3.us-east-2.amazonaws.com/app-screenshots-jose-alarcon-chacon/appimages/IMG_7604+2.PNG" alt="App Screenshot" width="250">

After adding a photo from their camera roll or via taking a photo directly, the user clicks the button to upload, which sends the photo 
to Firebase (for storage) and the Microsoft Cognition API for comparison against the stored list of individuals.

<img src="https://s3.us-east-2.amazonaws.com/app-screenshots-jose-alarcon-chacon/appimages/IMG_7605.PNG" alt="App Screenshot" width="250">

If a match is found, the user is instructed to provide more information so that a reunification coordinator can verify the match 
and reach back out if a match is verified. 

<img src="https://s3.us-east-2.amazonaws.com/app-screenshots-jose-alarcon-chacon/appimages/IMG_7608.PNG" alt="App Screenshot" width="250">

Name, age, and country of origin is requested. 

<img src="https://s3.us-east-2.amazonaws.com/app-screenshots-jose-alarcon-chacon/appimages/IMG_7607.PNG" alt="App Screenshot" width="250">

Lawyers and other users who might be reaching out on behalf of more than one individual can see a list of their requests via a list 
view accessible from the 'potential matches' tab. From here they can click into each row to see the photo initially uploaded and the 
details provided for each user.

<img src="https://s3.us-east-2.amazonaws.com/app-screenshots-jose-alarcon-chacon/appimages/IMG_7609.PNG" alt="App Screenshot" width="250">


## Technologies
### Firebase 
* Storage
* Authentication
### Microsoft Cognitive Services APIs
* Face Detect
* Add Face
* Find Similar

## Status

This app is intended as a proof of concept. 
