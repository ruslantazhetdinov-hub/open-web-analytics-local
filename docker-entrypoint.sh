#!/bin/sh
set -eu

if [ "${OWA_SKIP_INSTALL:-0}" != "1" ]; then
  echo "Waiting for the OWA database..."
  until php -r '
    mysqli_report(MYSQLI_REPORT_OFF);
    $db = @new mysqli(getenv("OWA_DB_HOST"), getenv("OWA_DB_USER"), getenv("OWA_DB_PASSWORD"), getenv("OWA_DB_NAME"));
    exit($db->connect_errno ? 1 : 0);
  '; do
    sleep 2
  done

  installed="$(php -r '
    mysqli_report(MYSQLI_REPORT_OFF);
    $db = @new mysqli(getenv("OWA_DB_HOST"), getenv("OWA_DB_USER"), getenv("OWA_DB_PASSWORD"), getenv("OWA_DB_NAME"));
    $result = $db->query("SHOW TABLES LIKE \"owa_configuration\"");
    echo ($result && $result->num_rows > 0) ? "yes" : "no";
  ')"

  if [ "$installed" != "yes" ]; then
    echo "Installing Open Web Analytics..."
    php cli.php cmd=install \
      user_id="${OWA_ADMIN_USER:-admin}" \
      email_address="${OWA_ADMIN_EMAIL:-admin@localhost}" \
      domain="${OWA_TRACKED_DOMAIN:-localhost:8081}" \
      description="Local OWA demo site"
  fi
fi

exec "$@"

