#!/bin/sh
sudo dev_appserver.rb -p 80 --jvm_flag=-Xmx1024m -a 0.0.0.0 .
