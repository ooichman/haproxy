FROM ubi8

RUN dnf install -y haproxy && \
    dnf clean all && \
    mkdir /opt/app-root/ && \
    chown 998:root /opt/app-root/ && \
    chmod u+rwx /opt/app-root/

COPY run.sh /usr/sbin/

USER 998

ENTRYPOINT ["/usr/sbin/run.sh"]
CMD ["/usr/sbin/run.sh"]
