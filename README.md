A web application that uses gesture as input to HTML5 based presentation framework.

# Development environment

* The code is developed and tested on Ubuntu 13.04 and Windows 7 64bit.
* ruby 2.0.0p247

# Setup

Shotgun is used to reload the application every time a new request comes in during 
development:

    bundle exec shotgun config.ru
    
Start the web server:

    nohup bundle exec unicorn config.ru > web.log &
