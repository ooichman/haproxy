#!/bin/bash

if [[ -z ${DST_PORT} ]]; then
	echo "DST_PORT not defined, exiting"
	exit 1
fi

if [[ -z ${DST_SERVER} ]]; then
	echo "DST_SERVER not defined, exiting"
	exit 1
fi

if [[ -z ${SRC_PORT} ]]; then
	echo "SRC_PORT not defined , using DST_PORT"
fi

cat > /opt/app-root/haproxy << EOF
# Global settings
#---------------------------------------------------------------------
global
    maxconn     20000
    log         stdout local0 debug
    pidfile     /tmp/haproxy.pid
    user        998
#    group       users
    daemon

# common defaults that all the 'listen' and 'backend' sections will
# use if not designated in their block
#---------------------------------------------------------------------
defaults
    mode                    tcp
    log                     global
    option                  tcplog
    option                  dontlognull
    option                  redispatch
    retries                 3
    timeout http-request    10s
    timeout queue           1m
    timeout connect         10s
    timeout client          300s
    timeout server          300s
    timeout http-keep-alive 10s
    timeout check           10s
    maxconn                 20000

frontend  haproxy-exporter
    bind *:${SRC_PORT}
    default_backend haproxy-exporter-be
    mode tcp
    option tcplog

backend haproxy-exporter-be
    balance source
    mode tcp
    server     external ${DST_SERVER}:${DST_PORT} check
EOF


/usr/sbin/haproxy -f /opt/app-root/haproxy.cfg
