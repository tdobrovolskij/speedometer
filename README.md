Speedometer
===========
[![Gem Version](https://badge.fury.io/rb/speedometer.svg)](http://badge.fury.io/rb/speedometer)

Simple library used to track,calculate and display upload speed of an application.

It's used in my other project - https://github.com/tdobrovolskij/sanguinews

INSTALLATION
============
Simply invoke gem install:

    gem install speedometer

How to use
==========
Methods:
* new - accepts hash with: units in KB/MB(default)/GB; progressbar - bool
* start - starts displaying upload rate
* stop - stop displaying upload rate
* done(bytesize) - increments uploaded byte counter for progressbar
* log(message) - you need to use this instead of puts

CREDITS
=======
* [Zachary "Zrp200" Perlmutter](https://github.com/Zrp200) for his [patch](https://github.com/tdobrovolskij/speedometer/pull/1).

HISTORY
=======
* 0.1.3 - Less CPU will be consumed now.
* 0.1.2 - Log method supports stderr output now.
* 0.1.1 - Specified ruby version.
* 0.1.0 - Added progressbar feature. Be careful: upgrade can break code.
* 0.0.5 - Improved logic. Start possible only once.
* 0.0.4 - Added start/stop methods
* 0.0.3 - Basic thread safety added
* 0.0.2 - Forcing STDOUT.flush after every action
* 0.0.1 - Initial public release
