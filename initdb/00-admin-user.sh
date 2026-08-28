#!/bin/bash
# ---------------------------------------------------------------------------
# Cria o usuário administrador informado no .env.
#
# Por que este script existe: no MySQL o superusuário nativo chama-se SEMPRE
# "root" — o nome não é configurável. Para atender ao pedido de "usuário e senha
# de root via .env", criamos aqui um segundo usuário com TODOS os privilégios,
# com o nome que você escolher em DB_ADMIN_USER. A senha do root nativo continua
# vindo de MYSQL_ROOT_PASSWORD.
#
# Executado uma única vez, na primeira subida do container.
# ---------------------------------------------------------------------------
set -euo pipefail

: "${DB_ADMIN_USER:=}"
: "${DB_ADMIN_PASSWORD:=}"

if [ -z "$DB_ADMIN_USER" ] || [ -z "$DB_ADMIN_PASSWORD" ]; then
  echo "[aula] DB_ADMIN_USER/DB_ADMIN_PASSWORD não definidos — usando apenas o root nativo."
  exit 0
fi

if [ "$DB_ADMIN_USER" = "root" ]; then
  echo "[aula] DB_ADMIN_USER='root' já existe por padrão — nada a fazer."
  exit 0
fi

echo "[aula] Criando usuário administrador '${DB_ADMIN_USER}'..."

sql=$(cat <<EOSQL
CREATE USER IF NOT EXISTS '${DB_ADMIN_USER}'@'%'
  IDENTIFIED WITH caching_sha2_password BY '${DB_ADMIN_PASSWORD}';
GRANT ALL PRIVILEGES ON *.* TO '${DB_ADMIN_USER}'@'%' WITH GRANT OPTION;
GRANT SYSTEM_USER ON *.* TO '${DB_ADMIN_USER}'@'%';
FLUSH PRIVILEGES;
EOSQL
)

# A função docker_process_sql existe quando o entrypoint oficial "sourceia" este
# script; o fallback cobre o caso de o arquivo estar marcado como executável.
if declare -F docker_process_sql >/dev/null 2>&1; then
  docker_process_sql --database=mysql <<<"$sql"
else
  mysql --protocol=socket -uroot -p"${MYSQL_ROOT_PASSWORD}" --database=mysql <<<"$sql"
fi

echo "[aula] Usuário '${DB_ADMIN_USER}' criado com privilégios totais."
