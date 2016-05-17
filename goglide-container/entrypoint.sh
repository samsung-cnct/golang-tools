#!/bin/bash
#
# Determine uid gid based on a given mount
#
echo "000000000000000000"
pwd
TARGET_UID=$(stat -c "%u" .)
TARGET_GID=$(stat -c "%g" .)
echo "filesystem UID: $TARGET_UID : $TARGET_GID"
echo "!!!!!!!!!!!!!!!!!!"

# Add local user 
#
#USER_ID=${LOCAL_USER_ID:-9001}
USER_ID=${LOCAL_USER_ID:-$TARGET_UID}
USER_NM=${LOCAL_USER:-user}
#GRP_ID=${LOCAL_GRP_ID:-staff}
GRP_ID=${LOCAL_GRP_ID:-$TARGET_GID}

echo "Starting with $USER_NM UID: $USER_ID"
useradd --shell /bin/bash -u $USER_ID -o -c "" -m $USER_NM -g $GRP_ID
export HOME=/home/$USER_NM

exec /usr/local/bin/gosu $USER_NM "$@"
