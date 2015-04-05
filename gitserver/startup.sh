#!/bin/sh

# Customize gitolite to work with cgit
function fix_gitolite_rc() {
     cat > /tmp/scr.sed <<EOF
/GIT_CONFIG_KEYS/{
a \
    GIT_CONFIG_KEYS                 =>  'gitweb\\..*',
d
}

/\$rc{GL_ADMIN_BASE}\/local/{
a \
        LOCAL_CODE                  =>  "\$rc{GL_ADMIN_BASE}/local",
d
}
EOF
     sed -i -f /tmp/scr.sed /var/lib/gitolite3/.gitolite.rc
     rm -f /tmp/scr.sed
}

# Setup gitolite-admin repository with default 'admin' user
# and make gitolite-admin accessiable via HTTP
if [ ! -d /var/lib/gitolite3/repositories/gitolite-admin.git ]; then
     umask 0077
     git config --global user.name $GIT_ADMIN_USER_NAME
     git config --global user.email $GIT_ADMIN_USER_EMAIL
     gitolite setup --admin admin
     htpasswd -bc /var/lib/gitolite3/git_passwd admin admin
     touch /var/lib/gitolite3/repositories/gitolite-admin.git/git-daemon-export-ok
     mkdir -p /var/lib/gitolite3/logs
     fix_gitolite_rc
fi

# run Apache in foreground
exec httpd                           \
   -f /etc/httpd/conf/httpd_git.conf \
   -DFOREGROUND                      \
   -c "ServerName $GIT_SERVER_NAME"  \
   -k start
