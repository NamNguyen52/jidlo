jidlo
=====

Making group dining decisions easier.

This project utilizes the Foursqaure API to construct a group survey to find restaurants that closely matches everyone's responses. The entire survey is split into two parts: (1) restaurant preferences and (2) restaurant voting. 

The first survey (restaurant preferences) will ask three questions: (1) cuisine, (2) distance, (3) price tier. From there the answers will be collected and analyzed for trends in the responses. The dominating trend for each question will be set as search parameters for the Foursquare API. The search parameters are then sent to the Foursquare API and JSON data for the top 20 matches will return. Of those 20 responses, we will pull the top three best matches.

The three top matches will then be used to construct the second survey (restaurant voting). The same party will be able for one of the top three restaurants. 

Once all response have been collected the restaurant with the most votes wins and will be displayed on everyone's page.



