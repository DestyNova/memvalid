#!/usr/bin/env bash
# This only exists because I can't figure out how to get Ur/Web to just serve the CSS file. It probably can.

ruby -run -ehttpd css -p 8086
