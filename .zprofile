# Honor system-wide environment variables
GUIX_EXTRA_PROFILES=$HOME/.guix-extra-profiles
for i in $GUIX_EXTRA_PROFILES/*; do
  profile=$i/$(basename "$i")
  if [ -f "$profile"/etc/profile ]; then
    GUIX_PROFILE="$profile"
    . "$GUIX_PROFILE"/etc/profile
  fi
  unset profile
done
source /etc/profile

GUIX_PROFILE="/home/m/.guix-profile"
. "$GUIX_PROFILE/etc/profile"

if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
    # XDG_DATA_DIRS=/var/lib/flatpak/exports/share:/home/joshua/.local/share/flatpak/exports/share:$XDG_DATA_DIRS
    echo shepherd $(date) >> ~/test.zprofile
    shepherd &
fi

# if [[ -z $(ps | rg shepherd) ]]; then
#     echo psshepherd $(date) >> test.zprofile
#     shepherd &
# fi

if [[ ! -S ${XDG_RUNTIME_DIR-$HOME/.cache}/shepherd/socket ]]; then
    shepherd &
    echo sth $(date) >> ~/test.zprofile
fi
