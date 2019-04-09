#!/bin/bash
yum update -y
cd /tmp
curl -L --remote-name https://github.com/PostgREST/postgrest/releases/download/v5.2.0/postgrest-v5.2.0-centos7.tar.xz
tar xfJ postgrest-v5.2.0-centos7.tar.xz
cp postgrest /usr/local/bin
yum install postgresql-libs -y
