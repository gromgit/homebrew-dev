#!/usr/bin/env bash
funcs_dir=$(dirname "$(realpath "${BASH_SOURCE[0]}")")
# string formatters
# Ref: console_codes(4) man page
if [[ -t 1 ]]; then
  # Csi_escape <param> - ECMA-48 CSI sequence
  Csi_escape() { printf "\033[%s" "$1"; }
else
  Csi_escape() { :; }
fi
# Sgr_escape <param> - ECMA-48 Set Graphics Rendition
Sgr_escape() { Csi_escape "${1}m"; }
Tty_mkbold() { Sgr_escape "1;${1:-39}"; }
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
Tty_underscore=$(Sgr_escape 38)
# shellcheck disable=SC2034 # it's not used in here, but other scripts may use it
Tty_bold=$(Tty_mkbold 39)
Tty_reset=$(Sgr_escape 0)
# shellcheck disable=SC2034 # it's not used in here, but other scripts may use it
Tty_clear_to_eol=$(Csi_escape K)
# shellcheck disable=SC2034 # it's not used in here, but other scripts may use it
Tty_clear_line=$(Csi_escape 2K)

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
export cache_root
[[ $(uname -s) == "Darwin" ]] && GNU_PREFIX=g

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

declare -A darwin_versions=(
  [monterey]=120000
  [big_sur]=110000
  [catalina]=101500
  [mojave]=101400
  [high_sierra]=101300
  [sierra]=101200
  [el_capitan]=101100
  [yosemite]=101000
  [mavericks]=100900
  [mountain_lion]=100800
  [lion]=100700
  [snow_leopard]=100600
)
# Ref: https://xcodereleases.com/
declare -A max_xcode_versions=(
  [big_sur]=130299
  [catalina]=120499
  [mojave]=110399
  [high_sierra]=100199
  [sierra]=090299
  [el_capitan]=080299
  [yosemite]=070299
  [mavericks]=060299
  [mountain_lion]=050199
  [lion]=040699
  [snow_leopard]=040299
)

# Generate integer version number
# USAGE: int_ver X.Y...
int_ver() {
  if [[ $1 =~ ([0-9]+)\.([0-9]+)\.([0-9]+) ]]; then
    printf '%d%02d%02d' "${BASH_REMATCH[1]##0}" "${BASH_REMATCH[2]##0}" "${BASH_REMATCH[3]##0}"
  elif [[ $1 =~ ([0-9]+)\.([0-9]+) ]]; then
    printf '%d%02d00' "${BASH_REMATCH[1]##0}" "${BASH_REMATCH[2]##0}"
  elif [[ $1 =~ ([0-9]+) ]]; then
    printf '%d0000' "${BASH_REMATCH[1]##0}"
  fi
}

os_ver() {
  local v=${darwin_versions["$1"]}
  echo "${v:-999999}"
}

max_xcode_ver() {
  local v=${max_xcode_versions["$1"]}
  echo "${v:-999999}"
}

# os_name: Print Homebrew name of OS
# USAGE: os_name
os_name() {
  case "$(uname -s)" in
    Darwin)
      case "$(sw_vers -productVersion)" in
        13.*) echo "ventura";;
        12.*) echo "monterey";;
        11.*) echo "big_sur";;
        10.15.*) echo "catalina";;
        10.14.*) echo "mojave";;
        10.13.*) echo "high_sierra";;
        10.12.*) echo "sierra";;
        10.11.*) echo "el_capitan";;
        *) fatal "Your macOS is too old to support Homebrew"
      esac
    ;;
    Linux)
      echo "$(uname -m)_linux"
    ;;
    *)
      fatal "Homebrew only supported on macOS and Linux"
    ;;
  esac
}

my_os=$(os_name)
my_os_sha256=$(os_name | shasum -a 256 | awk '{print $1}')
my_ver=$(os_ver "$my_os")
my_xcode_ver=$(max_xcode_ver "$my_os")

# Memoization for can_build()
declare -A b_cache=()
shopt -s lastpipe

# can_build <formula.rb>
can_build() {
  [[ -f $1 ]] || { warn "can_build: $1 not a file"; b_cache+=(["$name"]=1); return 1; }
  local drop f1 f2 name
  local metajson=${repo}/.meta/formula.json
  name=$(basename "$1" .rb)

  # First check cache
  [[ -n ${b_cache["$name"]} ]] && return "${b_cache["$name"]}"

  # First check for explicit block
  grep -E "^$name"$'\t' "$repo/.settings/blocked" 2>/dev/null | while read -r _ drop; do
    warn "Skipping $name because $drop"
    b_cache+=(["$name"]=1); return 1
  done

  # Then check for disabled!
  grep 'disable!' "$1" | while read -r _ f1 f2 _; do
    if [[ $f1 == "date:" && ${f2//[\",]} < $(date +%Y-%m-d) ]]; then
      warn "Skipping $name because :disabled"
      b_cache+=(["$name"]=1); return 1
    fi
  done

  # Then check for OS building
  case "$(uname -s)" in
    Darwin)

      local os_dep=$(jq '.[]|select(.name=="'"$name"'" and .requirements[].name=="linux")' "$metajson")
      if [[ -n $os_dep ]]; then
        warn "Skipping $name because depends_on :linux"
        b_cache+=(["$name"]=1); return 1
      fi

      local min_os; min_os=$(grep "depends_on macos: :" "$1" 2>/dev/null)
      if [[ $min_os =~ .*macos:\ :([^ ]*) && $(os_ver "${BASH_REMATCH[1]}") -gt $my_ver ]]; then
        warn "Skipping $name because ${BASH_REMATCH[0]}"
        b_cache+=(["$name"]=1); return 1
      fi

      local min_xcode; min_xcode=$(grep "depends_on xcode:" "$1" 2>/dev/null)
      if [[ $min_xcode =~ .*xcode:\ [^\"]*\"([^\"]+)\".* && $(int_ver "${BASH_REMATCH[1]}") -gt $my_xcode_ver ]]; then
        warn "Skipping $name because ${BASH_REMATCH[0]}"
        b_cache+=(["$name"]=1); return 1
      fi

    ;;
    Linux)
      local os_dep=$(jq 'map(select(.name=="'"$name"'"))|.[].requirements[]|select(.name=="macos" and .version==null)' "$metajson")
      if [[ -n $os_dep ]]; then
        warn "Skipping $name because depends_on :macos"
        b_cache+=(["$name"]=1); return 1
      fi
    ;;
    *)
      warn "Skipping $name because unknown OS"
      b_cache+=(["$name"]=1); return 1
    ;;
  esac

  # Then see if it's dependency-blocked
  # shellcheck disable=SC2154
  for drop in "${block_depends[@]}"; do
    if grep -Eq "depends_on $drop" "$1"; then
      warn "Skipping $name because $drop"
      b_cache+=(["$name"]=1); return 1
    fi
  done

  b_cache+=(["$name"]=0); return 0
}

# cmd: Show command being run
# USAGE: cmd <cmd> ...
cmd() {
  echo "${Tty_cyan}>>> $*${Tty_reset}" >&2
  command "$@"
}

# Check if formula needs rebottling
needs_rebottling() {
  # If no ${my_os}: or all: bottle spec...
  ! grep -Eq "sha256 .*(${my_os}|all):" "$@" ||
  # or it has a fake ${my_os} spec
  grep -Eq "sha256 .*${my_os}:.*\"${my_os_sha256}\"" "$@"
}

list_rebottling() {
  local f; for f in "$@"; do
    needs_rebottling "$f" && echo "$f"
  done
}

# remove_bottle_filter: Drop bottle block from stdin
remove_bottle_filter() {
  ${GNU_PREFIX}sed '/^  end/N; /^  bottle do/,/^  end/d'
}

# remove_bottle_block: Remove bottle block from formulae
remove_bottle_block() {
  local f
  for f in "$@"; do
    info "Debottling $f"
    remove_bottle_filter < "$f" > "$HOMEBREW_TEMP"/temp.rb && mv "$HOMEBREW_TEMP"/temp.rb "$f"
  done
}

# Replace existing bottle block with fake ${my_os} one
# This is a hack to force `brew test-bot` to fail properly
fake_bottle_filter() {
  "${funcs_dir}"/reset-bottle OS="${my_os}" SHA="${my_os_sha256}" COMMENT="fake ${my_os}"
}

# fake_bottle_block: Reset bottle block to fake one
fake_bottle_block() {
  local f
  for f in "$@"; do
    [[ -s $f ]] || continue
    info "Fake-bottling $f"
    fake_bottle_filter < "$f" > "$HOMEBREW_TEMP"/temp.rb && mv "$HOMEBREW_TEMP"/temp.rb "$f"
  done
}

# git_in: Run Git command in repo
# USAGE: git_in <repo> <cmd> ...
git_in() {
  local repo=$1; shift
  pushd "$repo" >/dev/null || fatal "Can't cd to '$repo'"
  cmd git "$@"
  popd >/dev/null || fatal "Can't popd"
}

# faketty: Run command with fake tty
# USAGE: faketty <cmd> ...
faketty () {
  # Create a temporary file for storing the status code
  local tmp cmd err
  tmp=$(mktemp)

  # Ensure it worked or fail with status 99
  [[ $tmp ]] || return 99

  # Produce a script that runs the command provided to faketty as
  # arguments and stores the status code in the temporary file
  cmd="$(printf '%q ' "$@")"'; echo $? > '"$tmp"

  # Run the script through /bin/sh with fake tty
  if [[ $(uname) == "Darwin" ]]; then
    # MacOS
    SHELL=/bin/sh script -qF /dev/null /bin/sh -c "$cmd"
  else
    SHELL=/bin/sh script -qfc "/bin/sh -c $(printf "%q " "$cmd")" /dev/null
  fi

  # Ensure that the status code was written to the temporary file or
  # fail with status 99
  [[ -s $tmp ]] || return 99

  # Collect the status code from the temporary file
  err=$(cat "$tmp")

  # Remove the temporary file
  rm -f "$tmp"

  # Return the status code
  return "$err"
}

# append_unique: Append elements to array if they don't already exist
# USAGE: append_unique <array_name> <element>...
append_unique() {
  local -n a=$1; shift
  local i n; for i in "$@"; do
    for n in "${a[@]}"; do
      [[ $n == "$i" ]] && return 0
    done
    a+=("$i")
  done
}

export HOMEBREW_CACHE=${HOMEBREW_CACHE:-$(readlink "$(brew --cache)")}

for myvar in GITHUB_API_TOKEN GITHUB_PACKAGES_TOKEN GITHUB_PACKAGES_USER GITHUB_UPSTREAM GIT_EMAIL GIT_NAME GH_TOKEN; do
  mynewvar=HOMEBREW_${myvar}
  [[ -n ${!mynewvar} ]] && export ${myvar}=${!mynewvar}
done
unset myvar mynewvar

need_progs ${GNU_PREFIX}sed

# Run this script to get the necessary source instructions
# Ref: https://stackoverflow.com/a/28776166
(return 0 2>/dev/null) || {
#U USAGE: $0 [`-sh`]
#U   Development standard bash library (when sourced)
#U   Output library `source` instructions (when run)
#U   `-sh` = Add bash shebang to instructions
  src_lib=../lib/funcs.sh
  case "$1" in
    -h|--help) usage 0;;
    -sh) echo "#!/usr/bin/env bash";;
  esac
  cat <<-EOF
	# Load dev standard shell library
	# shellcheck source=$src_lib
	. "\$(dirname "\$0")/${src_lib}"
	EOF
}
