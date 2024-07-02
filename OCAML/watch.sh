# set to `true` to echo all file changes

DEBUG=false
BASE=OCAML/prompts
FILE_CHANGE_BATCH_MARKER='--file-change-batch-end--'
APP="000"
ARG=""
if [ -n "$1" ]; then
  APP=$1
  if [ -n "$2" ]; then
    ARG=" $2"
  fi
fi

p() {
  now="$(date +'%r')"
  printf "$(tput setaf 3)%s$(tput sgr0) | $(tput bold)$1$(tput sgr0)\n" "$now"
}

stop_app() {
  # Find pids (the space and number before "$APP" is to match only the executable)
  # We use [/] trick so that the grep cmd is not seen and we add bin to avoid killing the flutter app of the same name (if any).
  pids=$(ps -ef | grep -E "[/]bin/$APP" | grep -v grep | awk '{print $2}')

  # Kill previous app
  if [ -n "$pids" ]; then
    p "Stop app"
    kill -INT $pids &>/dev/null
  fi

  # Restart ocamllsp (WHY DOESN'T THIS WORK ??)
  # pids=$(ps -ef | grep -E "[o]camllsp" | grep -v grep | awk '{print $2}')
  # if [ -n "$pids" ]; then
  #   p "Restart ocamllsp"
  #   kill -QUIT $pids &>/dev/null
  # fi
}

start_app() {
  p ""
  p "$APP Start"
  ocaml $BASE/prompt$APP.ml
  p "$APP End"
}

trap stop_app SIGINT SIGTERM

stop_app && start_app

fswatch --batch-marker="${FILE_CHANGE_BATCH_MARKER}" -0 . -e _build | xargs -0 -n 1 -I {} echo {} | while read file_path; do
  if $DEBUG; then
    p $file_path
  fi

  # run block if file change batch marker is output
  if [ "$file_path" = "$FILE_CHANGE_BATCH_MARKER" ]; then
    # bug in ocamllsp: needs to be killed too
    stop_app && start_app
  fi
done
