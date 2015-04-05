docker run                                       \
    -it                                          \
    --rm                                         \
    -e GIT_ADMIN_USER_NAME=adm                   \
    -e GIT_ADMIN_USER_EMAIL=adm@jk.com           \
    -u git                                       \
    -p 192.168.33.30:5001:8080                   \
    -v /var/lib/repos/server1:/var/lib/gitolite3 \
    schnell18/gitserver                          \
    /bin/bash
