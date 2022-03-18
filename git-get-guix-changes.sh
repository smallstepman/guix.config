export SSDIR=~/State/system
export CONT=~/State/system/contents-of-dirs-in-PATH 

echo > $CONT
for p in ${PATH//:/ }; do echo >> $CONT ; echo $p >> $CONT ; sudo ls $p >> $CONT ; done 
env > $SSDIR/contents-of-envvars
cat /etc/profile > ~/State/system/contents-of-etc-profile
cat /etc/bashrc > ~/State/system/contents-of-etc-bashrc
cat /etc/channels.scm > ~/State/system/contents-of-etc-channels.scm
cat /etc/config.scm > ~/State/system/contents-of-etc-config.scm
cat /etc/environment > ~/State/system/contents-of-etc-environment

guix package --list-installed > ~/State/system/guix-package-list-installed
guix package --list-profiles > ~/State/system/guix-package-list-profiles
guix package --list-generations > ~/State/system/guix-package-list-generations
guix describe > ~/State/system/guix-describe
guix system describe > ~/State/system/guix-describe
guix system list-generations > ~/State/system/guix-describe
 
guix graph -t package > $SSDIR/guix-graph-package 
guix graph -t reverse-package > $SSDIR/guix-graph-reverse-package
guix graph -t bag > $SSDIR/guix-graph-bag
guix graph -t bag-with-origins > $SSDIR/guix-graph-bag-with-origins
guix graph -t bag-emerged > $SSDIR/guix-graph-bag-emerged
guix graph -t reverse-bag > $SSDIR/guix-graph-reverse-bag
guix graph -t derivation > $SSDIR/guix-graph-derivation
guix graph -t references > $SSDIR/guix-graph-references
guix graph -t referrers > $SSDIR/guix-graph-referrers
guix graph -t module > $SSDIR/guix-graph-module

guix package --list-profiles > $SSDIR/guix-package-list-profiles
#print_profiles () {
#
#  echo $1
#  guix describe -p $1
#}
#guix package --list-profiles | xargs -I{} print_profiles {}


