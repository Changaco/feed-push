feed-push is a daemon that watches local RSS/Atom files for changes and executes
commands when new articles appear.

It can replace scripts such as rss2email and rss2xmpp, using tools like sendmail
and sendxmpp.py (http://changaco.net/code/sendxmpp-py).

Dependencies:

- gamin and its python2 bindings
- python2-feedparser

Compatibility: gamin only works on Linux and FreeBSD as of April 2012

Installation/Removal/Update: ./setup install|uninstall|update

A systemd .service file is provided. If you don't use systemd take a look at the
bash startup script in the init/ folder.

Configuration: see examples/
Note: globbing (i.e. using wildcards like in "*.atom") only works on startup, it
won't detect files created after that.
