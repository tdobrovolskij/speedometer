Speedometer
===========

Simple library used to track,calculate and display upload speed of an application.

It's used in my other project - https://github.com/tdobrovolskij/sanguinews

INSTALLATION
============
Simply invoke gem install:

    gem install speedometer

How to use
==========
Methods:
* new - accepts units in KB/MB/GB(MB - default)
* start - starts displaying upload rate
* stop - stop displaying upload rate
* display - displays upload speed
* log(message) - you need to use this instead of puts

HISTORY
=======
* 0.0.5 - Improved logic. Start possible only once.
* 0.0.4 - Added start/stop methods
* 0.0.3 - Basic thread safety added
* 0.0.2 - Forcing STDOUT.flush after every action
* 0.0.1 - Initial public release
