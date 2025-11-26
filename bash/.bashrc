# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source ~/.local/share/omarchy/default/bash/rc

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'

alias vi="nvim"
alias cdp="cd ~/Projects/"

export MANPAGER="nvim +Man!"
export BAT_PAGER="nvim +Man!"

# uv tools
export PATH="/home/yeonuk/.local/bin:$PATH"

# Alias
eval "$(alman init bash)"

# Pomodoro Options
declare -A pomo_options
pomo_options["work"]="45m"
pomo_options["break"]="10m"

pomodoro () {
  if [ -n "$1" -a -n "${pomo_options["$1"]}" ]; then
    local session_name=$1
    local duration_str=${2:-${pomo_options["$session_name"]}} 
    
    local duration_min=${duration_str%m} 
    local total_seconds=$((duration_min * 60))
    local status_file="/tmp/waybar_pomo.json"
    local pid_file="/tmp/waybar_pomo.pid"

    echo "Starting $session_name for $duration_str" | lolcat

    # [핵심 수정] 서브쉘 격리 기법
    # ( ) 괄호 안에서 set +m을 하고 백그라운드를 실행하면
    # 메인 쉘은 이 작업의 존재를 전혀 모릅니다 (메시지 출력 불가)
    (
        set +m
        (
            start_time=$(date +%s)
            end_time=$((start_time + total_seconds))
            
            while [ $(date +%s) -lt $end_time ]; do
                current_sec=$(date +%s)
                remaining=$((end_time - current_sec))
                
                min=$((remaining / 60))
                sec=$((remaining % 60))
                time_str=$(printf "%02d:%02d" $min $sec)
                
                echo "{\"text\": \"$session_name $time_str\", \"tooltip\": \"Running $session_name\", \"class\": \"$session_name\"}" > "$status_file"
                sleep 1
            done
        ) &
        # 백그라운드 PID를 파일에 몰래 적어두고 나갑니다
        echo $! > "$pid_file"
    )

    # PID 파일에서 프로세스 번호 가져오기
    local bg_pid=$(cat "$pid_file")

    cleanup() {
        # 메인 쉘이 추적하지 않는 프로세스라 kill해도 'Terminated' 메시지가 안 뜹니다
        kill $bg_pid 2>/dev/null
        echo "" > "$status_file"
        rm -f "$pid_file"
    }
    trap cleanup EXIT INT TERM

    # timer 실행 (에러 필터링 유지)
    timer "$duration_str" 2> >(grep -v "interrupted" >&2)

    cleanup
    
    current_time=$(date '+%H:%M')
    notify-send -u critical "🍅 Pomodoro" "$session_name session done at $current_time"
    
    trap - EXIT INT TERM
  else
    echo "Usage: wo (work) or br (break)"
  fi
}

alias wo="pomodoro 'work'"
alias br="pomodoro 'break'"
