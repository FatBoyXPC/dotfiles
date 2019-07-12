function needSudo() {
    if [ $EUID != 0 ]; then
        sudo -E "$0" "$@"
        exit $?
    fi
}

function terminalOn() {
  CMD="$1"
  WORKSPACE="$2-window"

  unsudo termite -r "$WORKSPACE" -e "shtuff new \"$CMD\"" &
  sleep 0.1 # force windows to be created in order
}

function unsudo() {
    if [ $EUID != 0 ]; then
        "$@"
    else
        sudo -u "$SUDO_USER" "$@"
    fi
}

function setupDevWorkspace() {
  terminalOn "artisan tinker" dev
  terminalOn "shtuff as devrunner" dev
  terminalOn "vim --servername dev" dev
}

function setupServerWorkspace() {
  terminalOn "artisan serve" server
  terminalOn "less +F storage/logs/laravel.log" server
}

function startAndConnectMysql() {
  sudo systemctl start mariadb.service
  terminalOn "mycli -u root $1" server
}

function startAndConnectPostgres() {
  sudo systemctl start postgresql.service
  terminalOn "pgcli -U admin $1" server
}
