#!/bin/bash

touch /tmp/haproxy.log

/usr/sbin/haproxy -f /opt/app-root/haproxy.cfg
