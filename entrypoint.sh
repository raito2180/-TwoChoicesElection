#!/bin/bash
set -e

bundle exec whenever --update-crontab
service cron start
crontab  -l
bundle exec rake reset_api:request_limit_count

# Remove a potentially pre-existing server.pid for Rails.
rm -f /app/tmp/pids/server.pid

bin/rails db:migrate
bin/rails assets:precompile

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
