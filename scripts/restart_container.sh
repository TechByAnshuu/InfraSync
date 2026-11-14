#!/bin/bash
# Usage: restart_container.sh <STATE> <STATETYPE> <CONTAINER>
# Example: restart_container.sh CRITICAL HARD web1

STATE="$1"
STATETYPE="$2"
NAME="$3"
FLAG="/etc/nagios4/remediation.enabled"

# If remediation killswitch flag file is not present, do nothing
[ -f "$FLAG" ] || exit 0

# Restrict allowed container names to enforce security boundary
case "$NAME" in
  web1|web2|web3) ;;
  *) 
    logger -t nagios-remediation "refused unknown container: $NAME"
    exit 1 
    ;;
esac

# Execute recovery action only when failure state is verified as HARD CRITICAL
if [ "$STATE" = "CRITICAL" ] && [ "$STATETYPE" = "HARD" ]; then
  logger -t nagios-remediation "restarting $NAME"
  sudo /usr/bin/docker start "$NAME"
fi

exit 0
