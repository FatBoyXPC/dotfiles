if [ $EUID != 0 ]; then
  sudo -E "$0" "$@"
  exit $?
fi

function terminalOn() {
  CMD=$1
  WORKSPACE="$2-window"

  sudo -u $SUDO_USER termite -r $WORKSPACE -e "zsh -ic '$CMD; zsh -i'" &
  sleep 0.1 # force windows to be created in order
}

function setupDevWorkspace() {
  terminalOn "tmux attach -t $1 || tmux new -s $1" dev
  terminalOn nvim dev
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
