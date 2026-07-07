function brew --wraps brew --description 'brew, plus a Brewfile sync nudge after install/uninstall'
    command brew $argv
    set -l st $status
    if contains -- $argv[1] install uninstall autoremove
        if not command brew bundle check --global >/dev/null 2>&1
            echo (set_color yellow)"⚠ Brewfile is out of sync — update ~/.Brewfile (see MAINTENANCE.md)"(set_color normal)
        end
    end
    return $st
end
