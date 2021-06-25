# string formatters
if [[ -t 1 ]]; then
  Tty_escape() { printf "\033[%sm" "$1"; }
else
  Tty_escape() { :; }
fi
Tty_mkbold() { Tty_escape "1;${1:-39}"; }
Tty_red=$(Tty_mkbold 31)
Tty_cyan=$(Tty_mkbold 36)
Tty_reset=$(Tty_escape 0)

fatal() {
  echo "${Tty_red}FATAL ERROR:${Tty_reset} $*" >&2
  exit 1
}

error() {
  echo "${Tty_red}${msg_prefix}ERROR:${Tty_reset} $*" >&2
}

info() {
  echo "${Tty_cyan}${msg_prefix}Info:${Tty_reset} $*" >&2
}
