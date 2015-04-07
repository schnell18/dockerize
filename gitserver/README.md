# Introduction
Dockerize gitolite, cgit and Apache to hosting massive Git repositories.
The container is expected to mount the volume to store repositories,
config and logs on host directory. The volume name in the container is
/var/lib/gitolite3. The published image can be found [here][4].

# Pre-requisite
This image installs custom-made [gitolite3][1], [git][2] and [cgit][3]
RPM to reduce overall image size.

# Build
The instruction to build the docker image is as follows:
~~~~bash
docker build --no-cache=true -t schnell18/gitserver .
~~~~

# Setup
This image requires the following setup on the host prior to running
the container:
~~~~bash
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
~~~~

# Run
The instruction to run the docker image is as follows:
~~~~bash
docker run                                       \
    -u git                                       \
    -p 192.168.33.30:5001:8080                   \
    -v /var/lib/gitolite3:/var/lib/gitolite3     \
    schnell18/gitserver
~~~~

# Diagnose
The instruction to diagnose the docker image is as follows:
~~~~bash
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
~~~~

# Container interface
## Environment variables
| Name                 | Description                 | Default                |
| -------------------- | --------------------------- | ---------------------- |
| GIT_SERVER_NAME      | Apache server name          | gitserver              |
| GIT_ADMIN_USER_NAME  | user name for admin commit  | admin                  |
| GIT_ADMIN_USER_EMAIL | user email for admin commit | admin@container.docker |

## Volumes
| Name                 | Description                            |
| -------------------- | -------------------------------------- |
| /var/lib/gitolite3   | Storage for Git repos, config and logs |

The host directory to mount to this volume must be owned by uid 888 and
gid 888.

## Ports
| Port                 | Description                            |
| -------------------- | -------------------------------------- |
| 8080                 | Apache run on non-privileged 8080      |

[1]: https://github.com/schnell18/packaging/tree/master/gitolite
[2]: https://github.com/schnell18/packaging/tree/master/git
[3]: https://github.com/schnell18/packaging/tree/master/cgit
[4]: https://registry.hub.docker.com/u/schnell18/gitserver/
