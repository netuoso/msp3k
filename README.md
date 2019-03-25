# README

### MSP3K

MSP3K is a User Management application for handling multiple users and bot accounts on the Steem blockchain. The application allows the admin to add users and bots, as well as individual permissions for each user+bot. Through the interface, users are able to use the bots they have been allowed access to and perform actions on the Steem blockchain such as voting, esteeming, or commenting.

### System Requirements:
- 1-2 GB RAM
- i5+ CPU

### Main Libraries:
- Ruby on Rails
- SuckerPunch
- Radiator
- Steem-Api

### To Setup:
- `bundle update`
- `bundle install`
- `rails db:setup`
- `rails server`

### To Access:
- http://localhost:3000

### Admin Info:
- username: admin
- password: welcome
- url: http://localhost:3000/admin

### Troubleshooting:
- restart application if necessary after adding new bot accounts via admin

### License:
WTFPL
