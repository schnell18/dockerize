#!/bin/sh
#
# CGI wrapper for gitolite-shell.
# It sets necessary environment variables which can not be done
# by the Apache's SetEnv directive as a result of using Suexec.
# Suexec disregard SetEnv directive.
# GIT_PROJECT_ROOT and GITOLITE_HTTP_HOME are required by gitolite

export GIT_PROJECT_ROOT="/var/lib/gitolite3/repositories"
export GITOLITE_HTTP_HOME="/var/lib/gitolite3"
unset SSH_CONNECTION

exec /usr/bin/gitolite-shell
