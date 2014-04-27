A web application that uses gesture as input to HTML5 based presentation framework.

# Development environment

* The code is developed and tested on Ubuntu 13.04 and Windows 7 64bit.
* ruby 2.0.0p247 ([tutorial](http://rb-tutorial.herokuapp.com/blog/2012/01/11/setting-up-ruby/) on how to set up ruby)
    * Install bundler
    ```
    gem install bundler
    ```

# Setup
Update gems
    
    bundle install

Shotgun is used to reload the application every time a new request comes in during 
development:

    bundle exec shotgun config.ru
    
Start the web server:

    nohup bundle exec unicorn config.ru > web.log &
