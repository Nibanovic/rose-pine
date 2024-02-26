#!/usr/bin/env bash
#
# Rosé Pine - tmux theme
#
# Almost done, any bug found file a PR to rose-pine/tmux
#
# Inspired by dracula/tmux, catppucin/tmux & challenger-deep-theme/tmux
#
#
export TMUX_ROSEPINE_DIR="$( cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)"

get_tmux_option() {
    local option value default
    option="$1"
    default="$2"
    value="$(tmux show-option -gqv "$option")"

    if [ -n "$value" ]; then
        echo "$value"
    else
        echo "$default"
    fi
}

set() {
    local option=$1
    local value=$2
    tmux_commands+=(set-option -gq "$option" "$value" ";")
}

setw() {
    local option=$1
    local value=$2
    tmux_commands+=(set-window-option -gq "$option" "$value" ";")
}

unset_option() {
    local option=$1
    local value=$2
    tmux_commands+=(set-option -gu "$option" ";")
}


main() {
    local theme
    theme="$(get_tmux_option "@rose_pine_variant" "")"

    # INFO: Not removing the thm_hl_low and thm_hl_med colors for posible features
    # INFO: If some variables appear unused, they are being used either externally
    # or in the plugin's features
    if [[ $theme == main ]]; then

        thm_base="#191724";
        thm_surface="#1f1d2e";
        thm_overlay="#26233a";
        thm_muted="#6e6a86";
        thm_subtle="#908caa";
        thm_text="#e0def4";
        thm_love="#eb6f92";
        thm_gold="#f6c177";
        thm_rose="#ebbcba";
        thm_pine="#31748f";
        thm_foam="#9ccfd8";
        thm_iris="#c4a7e7";
        thm_hl_low="#21202e";
        thm_hl_med="#403d52";
        thm_hl_high="#524f67";

    elif [[ $theme == dawn ]]; then

        thm_base="#faf4ed";
        thm_surface="#fffaf3";
        thm_overlay="#f2e9e1";
        thm_muted="#9893a5";
        thm_subtle="#797593";
        thm_text="#575279";
        thm_love="#b4367a";
        thm_gold="#ea9d34";
        thm_rose="#d7827e";
        thm_pine="#286983";
        thm_foam="#56949f";
        thm_iris="#907aa9";
        thm_hl_low="#f4ede8";
        thm_hl_med="#dfdad9";
        thm_hl_high="#cecacd";

    elif [[ $theme == moon ]]; then

        thm_base="#232136";
        thm_surface="#2a273f";
        thm_overlay="#393552";
        thm_muted="#6e6a86";
        thm_subtle="#908caa";
        thm_text="#e0def4";
        thm_love="#eb6f92";
        thm_gold="#f6c177";
        thm_rose="#ea9a97";
        thm_pine="#3e8fb0";
        thm_foam="#9ccfd8";
        thm_iris="#c4a7e7";
        thm_hl_low="#2a283e";
        thm_hl_med="#44415a";
        thm_hl_high="#56526e";

    fi

    # Aggregating all commands into a single array
    local tmux_commands=()

    # Status bar
    set "status" "on"
    set status-style "fg=$thm_pine,bg=$thm_base"
    # set monitor-activity "on"
    # Leave justify option to user
    # set status-justify "left"
    set status-left-length "300"
    set status-right-length "200"


    # Theoretically messages (need to figure out color placement)
    set message-style "fg=$thm_muted,bg=$thm_base"
    set message-command-style "fg=$thm_base,bg=$thm_gold"

    # Pane styling
    set pane-border-style "fg=$thm_hl_high"
    set pane-active-border-style "fg=$thm_gold"
    set display-panes-active-colour "${thm_text}"
    set display-panes-colour "${thm_gold}"

    # Windows
    setw window-status-style "fg=${thm_overlay},bg=${thm_base}"
    setw window-status-activity-style "fg=${thm_base},bg=${thm_rose}"
    setw window-status-current-style "fg=${thm_gold},bg=${thm_base}"

    # Statusline base command configuration: No need to touch anything here
    # Placement is handled below

    # Shows username of the user the tmux session is run by
    local user
    user="$(get_tmux_option "@rose_pine_user" "")"

    # Shows hostname of the computer the tmux session is run on
    local host
    host="$(get_tmux_option "@rose_pine_host" "")"
   
    # Settings that allow user to choose their own icons and status bar behaviour
    # START
    
    local current_session_icon
    current_session_icon="$(get_tmux_option "@rose_pine_session_icon" "")"

    local username_icon
    username_icon="$(get_tmux_option "@rose_pine_username_icon" "")"

    local hostname_icon
    hostname_icon="$(get_tmux_option "@rose_pine_hostname_icon" "󰒋")"

    # Changes the icon / character that goes between each window's name in the bar
    local window_status_separator
    window_status_separator="$(get_tmux_option "@rose_pine_window_status_separator" "  ")"
    setw window-status-separator "$window_status_separator"
    
    local right_separator
    right_separator="$(get_tmux_option "@rose_pine_right_separator" " ")"

    local left_separator
    left_separator="$(get_tmux_option "@rose_pine_left_separator" "  ")"

    local field_separator
    # NOTE: Don't remove
    field_separator="$(get_tmux_option "@rose_pine_field_separator" " | " )"

    # END

    setw mode-style "fg=${thm_gold}"
    
    # ######### DEFAULTS #############

    local spacer
    spacer=" "
    # I know, stupid, right? For some reason, spaces aren't consistent

    # These variables are the defaults so that the setw and set calls are easier to parse

    local show_window
    readonly show_window=" #[fg=$thm_subtle]$current_window_icon #[fg=$thm_rose]#W$spacer"

    local show_window_in_window_status
    show_window_in_window_status="#[fg=$thm_iris]#I#[fg=$thm_iris,]$left_separator#[fg=$thm_iris]#W"

    local show_window_in_window_status_current
    show_window_in_window_status_current="#I#[fg=$thm_gold,bg=""]$left_separator#[fg=$thm_gold,bg=""]#W"

    local show_session
    readonly show_session=" #[fg=$thm_text]$current_session_icon #[fg=$thm_text]#S "

    local show_user
    readonly show_user="#[fg=$thm_iris]#(whoami)#[fg=$thm_subtle]$right_separator#[fg=$thm_subtle]$username_icon"

    local show_host
    readonly show_host="$spacer#[fg=$thm_text]#H#[fg=$thm_subtle]$right_separator#[fg=$thm_subtle]$hostname_icon"


    # ######### ASSEMBLY #############

    local sep cap_left cap_right name_number_separator
    sep="█"
    cap_left=""
    cap_right=""
    name_number_separator=""
    local window_status_current_format="#[fg=$thm_overlay,bg=$thm_base]$cap_left#[fg=$thm_gold,bg=$thm_overlay]#I$name_number_separator#[fg=$thm_gold,bg=$thm_overlay]#W#[fg=$thm_overlay,bg=$thm_base]$cap_right"


    local window_status_format=$show_window
    setw window-status-format "$window_status_format"
    setw window-status-current-format "$window_status_current_format"

    ## LEFT COLUMN
    local left_column
    left_column=$show_session

    ## RIGHT COLUMN
    local right_column
    if [[ "$user" == "on" ]]; then
        right_column=$right_column$show_user
    fi

    if [[ "$host" == "on" ]]; then
        right_column=$right_column$show_host
    fi



    # We set the sections
    set status-left "$left_column"
    set status-right "$right_column"





    # ######### WINDOW PRIORITIZATION #############
    #
    ## This setting does nothing by itself, it enables the 2 below it to toggle the simplified bar
    # local prioritize_windows
    # prioritize_windows="$(get_tmux_option "@rose_pine_prioritize_windows" "")"

    # # Allows the user to set a min width at which most of the bar elements hide, or
    # local user_window_width
    # user_window_width="$(get_tmux_option "@rose_pine_width_to_hide" "")"

    # A number of windows, when over it, the bar gets simplified
    # local user_window_count
    # user_window_count="$(get_tmux_option "@rose_pine_window_count" "")"


    # Variable logic for the window prioritization
    # local current_window_count
    # local current_window_width

    # current_window_count=$(tmux list-windows | wc -l)
    # current_window_width=$(tmux display -p "#{window_width}")

    # NOTE: Can possibly integrate the $only_windows mode into this
    # if [[ "$prioritize_windows" == "on" ]]; then
        # if [[ "$current_window_count" -gt "$user_window_count" || "$current_window_width" -lt "$user_window_width" ]]; then
            # set status-left "$left_column$show_directory"
            # # set status-right "$show_directory"
            # set status-right ""
        # fi
    # else
        # set status-right "$right_column"
    # fi


    # Call everything to action
    tmux "${tmux_commands[@]}"

}

main "$@"
