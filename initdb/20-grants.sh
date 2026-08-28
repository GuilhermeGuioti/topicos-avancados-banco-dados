#!/bin/bash
# ---------------------------------------------------------------------------
# O entrypoint oficial cria MYSQL_USER com privilégios apenas sobre
# MYSQL_DATABASE. Como a aula usa DOIS bancos (aula_views e aula_exercicios),
# estendemos a concessão aqui.
#
# Executado por último na primeira subida (prefixo 20-).
# ---------------------------------------------------------------------------
set -euo pipefail

: "${MYSQL_USER:=}"

if [ -z "$MYSQL_USER" ]; then
  echo "[aula] MYSQL_USER não definido — nada a conceder."
  exit 0
fi

echo "[aula] Concedendo a '${MYSQL_USER}' acesso a aula_views e aula_exercicios..."

sql=$(cat <<EOSQL
GRANT ALL PRIVILEGES ON aula_views.*      TO '${MYSQL_USER}'@'%';
GRANT ALL PRIVILEGES ON aula_exercicios.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOSQL
)

if declare -F docker_process_sql >/dev/null 2>&1; then
  docker_process_sql --database=mysql <<<"$sql"
else
  mysql --protocol=socket -uroot -p"${MYSQL_ROOT_PASSWORD}" --database=mysql <<<"$sql"
fi

echo "[aula] Privilégios concedidos."
