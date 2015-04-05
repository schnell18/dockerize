echo "############################################################"
echo ""
echo "                        ##        ."
echo "                  ## ## ##       =="
echo "               ## ## ## ##      ==="
echo "           /""""""""""""""""\___/ ==="
echo "      ~~~ {~~ ~~~~ ~~~ ~~~~ ~~ ~ /  ===- ~~~"
echo "           \______ o          __/"
echo "             \    \        __/"
echo "              \____\______/"
echo ""
echo "############################################################"

# create user/group to run docker registry
os_group=git
os_user=git
getent group ${os_group} > /dev/null        \
  || sudo /usr/sbin/groupadd -g 888         \
                             -r ${os_group} \
                             2>/dev/null    \
  || :
getent passwd ${os_user} > /dev/null                     \
  || sudo /usr/sbin/useradd -c "Owner of Git repos"      \
                       -o                                \
                       -u 888                            \
                       -g ${os_group}                    \
                       -s /bin/bash                      \
                       -r                                \
                       -d /var/lib/gitolite3             \
                       ${os_user} 2>/dev/null            \
  || :
# setup docker image storage diretories
sudo mkdir -p /var/lib/gitolite3
sudo chmod 755 /var/lib/gitolite3
sudo chown 888:888 /var/lib/gitolite3
