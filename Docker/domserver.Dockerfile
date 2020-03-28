FROM "domjudge/domserver:latest"

ADD wait-for-it.sh /usr/bin/wait-for-it.sh
RUN chmod +x /usr/bin/wait-for-it.sh

ENTRYPOINT ["/usr/bin/wait-for-it.sh", "db:3306", "-t", "120", "--"]
CMD ["/scripts/start.sh"]
