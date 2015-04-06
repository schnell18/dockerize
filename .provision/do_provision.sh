function disable_selinux() {
    setenforce 0
    cat > /tmp/scr.sed <<EOF
/SELINUX=/{
a \
SELINUX=disabled
d
}
EOF
    sed -i -f /tmp/scr.sed /etc/sysconfig/selinux
    rm -f /tmp/scr.sed

}

function install_pre_requisite_warez() {
    yum install -y createrepo httpd docker
    yum update -y device-mapper
}

function setup_build_env() {
    systemctl enable httpd.service
    systemctl start httpd.service
    echo "Add devel to docker group..."
    getent group docker > /dev/null          \
      || sudo /usr/sbin/groupadd -r docker   \
                                 2>/dev/null \
      || :
    usermod -a -G docker devel
}

########## MAIN BLOCK ##########
echo "Make sure pre-requisite softwares are installed..."
install_pre_requisite_warez
echo "Disable selinux..."
disable_selinux
echo "Setting up build environment..."
setup_build_env

# vim: set ai nu nobk expandtab sw=4 tw=72 ts=4 syntax=sh :
