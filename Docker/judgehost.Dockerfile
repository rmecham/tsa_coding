FROM "domjudge/judgehost:latest"

ADD wait-for-it.sh /usr/bin/wait-for-it.sh
RUN chmod +x /usr/bin/wait-for-it.sh

ENTRYPOINT ["/usr/bin/wait-for-it.sh", "domserver:80", "-t", "120", "--"]
CMD ["/scripts/start.sh"]
