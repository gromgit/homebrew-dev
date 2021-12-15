#!/usr/bin/env bash
# string formatters
if [[ -t 1 ]]; then
  Tty_escape() { printf "\033[%sm" "$1"; }
else
  Tty_escape() { :; }
fi
Tty_mkbold() { Tty_escape "1;${1:-39}"; }
Tty_red=$(Tty_mkbold 31)
Tty_green=$(Tty_mkbold 32)
# shellcheck disable=SC2034 # it's not used in here, but other scripts may use it
Tty_brown=$(Tty_mkbold 33)
Tty_blue=$(Tty_mkbold 34)
# shellcheck disable=SC2034 # it's not used in here, but other scripts may use it
Tty_magenta=$(Tty_mkbold 35)
Tty_cyan=$(Tty_mkbold 36)
# shellcheck disable=SC2034 # it's not used in here, but other scripts may use it
Tty_white=$(Tty_mkbold 37)
# shellcheck disable=SC2034 # it's not used in here, but other scripts may use it
Tty_underscore=$(Tty_escape 38)
# shellcheck disable=SC2034 # it's not used in here, but other scripts may use it
Tty_bold=$(Tty_mkbold 39)
Tty_reset=$(Tty_escape 0)

# XDG Base Directory Specifications
# REF: https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
export XDG_DATA_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-${HOME}/.local/state}"
export XDG_DATA_DIRS="${XDG_DATA_DIRS:-/usr/local/share/:/usr/share/}"
export XDG_CONFIG_DIRS="${XDG_CONFIG_DIRS:-/etc/xdg}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

# Derive some important vars
cache_root=$(dirname "$(realpath -e "$(brew --cache)")")

# fatal: Report fatal error
# USAGE: fatal <msg> ...
fatal() {
  # shellcheck disable=SC2154 # msg_prefix is set externally
  echo "${Tty_red}${msg_prefix}FATAL ERROR:${Tty_reset} $*" >&2
  exit 1
}

# error: Report error
# USAGE: error <msg> ...
error() {
  echo "${Tty_red}${msg_prefix}ERROR:${Tty_reset} $*" >&2
}

# warn: Report warning
# USAGE: warn <msg> ...
warn() {
  echo "${Tty_blue}${msg_prefix}Warning:${Tty_reset} $*" >&2
}

# info: Informational message
# USAGE: info <msg> ...
info() {
  echo "${Tty_green}${msg_prefix}Info:${Tty_reset} $*" >&2
}

# need_progs: Checks for command dependencies
# USAGE: need_progs <cmd> ...
need_progs() {
  local missing=()
  local i
  for i in "$@"; do
    type -P "$i" &>/dev/null || missing+=("$i")
  done
  if [[ ${#missing[@]} -gt 0 ]]; then
    fatal "Commands missing: ${missing[*]}"
    exit 1
  fi
}

# deurlify: %-decode input strings
# REF: https://en.wikipedia.org/wiki/Percent-encoding
# USAGE: deurlify <str> ...
deurlify() {
  local s
  for s in "$@"; do
    s=${s//%21/\!}
    s=${s//%23/\#}
    s=${s//%24/\$}
    s=${s//%25/\%}
    s=${s//%26/\&}
    s=${s//%27/\'}
    s=${s//%28/\(}
    s=${s//%29/\)}
    s=${s//%2[aA]/\*}
    s=${s//%2[bB]/\+}
    s=${s//%2[cC]/\,}
    s=${s//%2[fF]/\/}
    s=${s//%3[aA]/\:}
    s=${s//%3[bB]/\;}
    s=${s//%3[dD]/\=}
    s=${s//%3[fF]/\?}
    s=${s//%40/\@}
    s=${s//%5[bB]/\[}
    s=${s//%5[dD]/\]}
    echo "$s"
  done
}

# os_name: Print Homebrew name of OS
# USAGE: os_name
os_name() {
  if [[ $(uname -s) == "Darwin" ]]; then
    case "$(sw_vers -productVersion)" in
      12.*) echo "monterey";;
      11.*) echo "big_sur";;
      10.15.*) echo "catalina";;
      10.14.*) echo "mojave";;
      10.13.*) echo "high_sierra";;
      10.12.*) echo "sierra";;
      10.11.*) echo "el_capitan";;
      10.10.*) echo "yosemite";;
      10.9.*) echo "mavericks";;
      10.8.*) echo "mountain_lion";;
      10.7.*) echo "lion";;
      10.6.*) echo "snow_leopard";;
      *) echo "unknown";;
    esac
  else  # Linux
    if [[ $(uname -m) == "aarch64" ]]; then
      echo "aarch64_linux"
    else
      fatal "Homebrew only works on 64-bit Linux"
    fi
  fi
}

# cmd: Show command being run
# USAGE: cmd <cmd> ...
cmd() {
  echo "${Tty_cyan}>>> $*${Tty_reset}" >&2
  command "$@"
}

# git_in: Run Git command in repo
# USAGE: git_in <repo> <cmd> ...
git_in() {
  local repo=$1; shift
  pushd "$repo" >/dev/null || fatal "Can't cd to '$repo'"
  cmd git "$@"
  popd >/dev/null || fatal "Can't popd"
}
