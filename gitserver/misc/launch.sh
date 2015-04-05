docker run                                       \
    -u git                                       \
    -p 192.168.33.30:5001:8080                   \
    -v /var/lib/gitolite3:/var/lib/gitolite3     \
    schnell18/gitserver
