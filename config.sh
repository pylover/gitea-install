gitea_config_create () {
  local LFS_JWT_SECRET=`gitea generate secret LFS_JWT_SECRET`
  local JWT_SECRET=`gitea generate secret JWT_SECRET`
  local INTERNAL_TOKEN=`gitea generate secret INTERNAL_TOKEN`

  while [ -z "${APP_NAME}" ]; do
    read -p "Please enter title for the website: "  APP_NAME
  done

  echo "\
APP_NAME = ${APP_NAME}
RUN_USER = ${GITEA_USER}
WORK_PATH = ${GITEA_WORKINGDIR}
RUN_MODE = prod

[database]
DB_TYPE = postgres
HOST = /run/postgresql/
NAME = gitea
USER = ${GITEA_USER}
PASSWD = ${GITEA_DBPASS}
SCHEMA = 
SSL_MODE = disable
PATH = ${GITEA_WORKINGDIR}/data/gitea.db
LOG_SQL = false

[repository]
ROOT = ${GITEA_WORKINGDIR}/data/gitea-repositories

[server]
PROTOCOL = http+unix
UNIX_SOCKET_PERMISSION = 666
HTTP_ADDR=/run/gitea/gitea.sock
SSH_DOMAIN = ${GITEA_DOMAIN}
DOMAIN = ${GITEA_DOMAIN}
ROOT_URL = https://${GITEA_DOMAIN}/
APP_DATA_PATH = ${GITEA_WORKINGDIR}/data
DISABLE_SSH = false
SSH_PORT = 22
LFS_START_SERVER = true
LFS_JWT_SECRET = ${LFS_JWT_SECRET}
OFFLINE_MODE = true

[lfs]
PATH = ${GITEA_WORKINGDIR}/data/lfs

[mailer]
ENABLED = false

[service]
REGISTER_EMAIL_CONFIRM = false
ENABLE_NOTIFY_MAIL = false
DISABLE_REGISTRATION = false
ALLOW_ONLY_EXTERNAL_REGISTRATION = false
ENABLE_CAPTCHA = true
REQUIRE_SIGNIN_VIEW = true
DEFAULT_KEEP_EMAIL_PRIVATE = false
DEFAULT_ALLOW_CREATE_ORGANIZATION = false
DEFAULT_ENABLE_TIMETRACKING = true
NO_REPLY_ADDRESS = noreply.localhost

[openid]
ENABLE_OPENID_SIGNIN = false
ENABLE_OPENID_SIGNUP = false

[cron.update_checker]
ENABLED = false

[session]
PROVIDER = file

[log]
MODE = console
LEVEL = warn
ROOT_PATH = ${GITEA_WORKINGDIR}/log

[repository.pull-request]
DEFAULT_MERGE_STYLE = rebase

[repository.signing]
DEFAULT_TRUST_MODEL = committer

[security]
INSTALL_LOCK = true
INTERNAL_TOKEN = ${INTERNAL_TOKEN}
PASSWORD_HASH_ALGO = pbkdf2

[oauth2]
JWT_SECRET = ${JWT_SECRET}
" > ${GITEA_CONFIGDIR}/app.ini
}
