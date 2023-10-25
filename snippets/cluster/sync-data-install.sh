#!/bin/bash

# upload bin dir
scp -r . root@$1:/root/bin > /dev/null

ssh root@$1 <<EOF
  cp /root/bin/sync-data.service /etc/systemd/system/
  systemctl daemon-reload
  systemctl start sync-data.service
  systemctl enable sync-data.service
EOF
> /dev/null
ssh root@$1 systemctl status sync-data.service
