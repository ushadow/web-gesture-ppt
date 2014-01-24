A web application that uses gesture as input on a tabletop.

# OS

The code is developed and tested on Ubuntu 13.04 and Windows 7.

# Setup

## Start up the web server.

For reloading the application every time a new request comes in during 
development:

    bundle exec shotgun config.ru
    nohup bundle exec unicorn config.ru > web.log &
