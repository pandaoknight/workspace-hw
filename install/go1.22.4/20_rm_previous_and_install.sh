#!/usr/bin/bash

rm -rf /usr/local/go && tar -C /usr/local -xzf go1.22.4.linux-amd64.tar.gz

echo 'Add to /etc/profile:'
echo 'export PATH=$PATH:/usr/local/go/bin'
echo ''

echo '' >> /etc/profile
echo 'export PATH=$PATH:/usr/local/go/bin' >> /etc/profile
echo '' >> /etc/profile

echo 'tail:'
tail /etc/profile
echo ''
echo 'Done.'
