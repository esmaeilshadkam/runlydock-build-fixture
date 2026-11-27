FROM alpine@sha256:49340b346798875b5592e5d420241f2f9cfba5f47e62ebb1446a1b34734e898f

RUN apk add --no-cache busybox-extras \
    && /bin/busybox-extras --list | grep -qx httpd

RUN mkdir -p /www \
    && printf 'RunlyDock Git to Production\n' > /www/index.html \
    && chmod 755 /www \
    && chmod 644 /www/index.html

RUN set -eu; \
    /bin/busybox-extras httpd -f -p 127.0.0.1:18080 -h /www & \
    pid=$!; \
    trap 'kill "$pid" 2>/dev/null || true' EXIT; \
    sleep 1; \
    test "$(wget -qO- http://127.0.0.1:18080/)" = "RunlyDock Git to Production"

USER 65534:65534

EXPOSE 8080

CMD ["/bin/busybox-extras", "httpd", "-f", "-p", "8080", "-h", "/www"]
