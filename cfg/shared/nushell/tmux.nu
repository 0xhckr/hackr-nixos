# Comprehensive tmux auto-start with session management and safety checks
def start-tmux [] {
    # Safety checks - don't start tmux if:
    # - Already inside tmux
    # - Connected via SSH
    # - Inside VS Code terminal
    # - Not a real TTY
    # - NOTMUX environment variable is set (escape hatch)
    if ($env.NOTMUX? != null or
       $env.TMUX? != null or 
       $env.SSH_TTY? != null or 
       $env.VSCODE_TERMINAL? != null or
       (tty | complete | get exit_code) != 0) {
        return
    }
    
    # Check if tmux is available
    if (which tmux | is-empty) {
        print "tmux not found, skipping auto-start"
        return
    }
    
    # Session management logic
    try {
        # Get list of existing sessions
        let sessions_result = (^tmux list-sessions -F "#{session_name}" | complete)
        
        if $sessions_result.exit_code == 0 {
            # Sessions exist - let's be smart about which one to attach to
            let sessions = ($sessions_result.stdout | lines | where { |it| $it != "" })
            
            if ($sessions | length) > 0 {
                # Check if 'main' session exists
                if ("main" in $sessions) {
                    print "Attaching to existing 'main' session..."
                    ^tmux attach-session -t main
                } else {
                    # Attach to the first available session
                    let first_session = ($sessions | first)
                    print $"Attaching to session '($first_session)'..."
                    ^tmux attach-session -t $first_session
                }
            } else {
                # Sessions command succeeded but no sessions found
                print "Creating new 'main' session..."
                ^tmux new-session -s main
            }
        } else {
            # No sessions exist (tmux server not running)
            print "Starting new tmux server with 'main' session..."
            ^tmux new-session -s main
        }
    } catch {
        # Fallback - something went wrong, just try to create a new session
        print "Tmux session management failed, creating new session..."
        try {
            ^tmux new-session -s main
        } catch {
            print "Failed to start tmux"
        }
    }
}

# Optional: Add a helper command to bypass tmux
def --env skip-tmux [] {
    $env.NOTMUX = "1"
}

# Optional: Add a helper to kill all tmux sessions and restart
def restart-tmux [] {
    if ($env.TMUX? != null) {
        print "Cannot restart tmux from within tmux session"
        return
    }
    
    try {
        ^tmux kill-server
        print "Killed tmux server, starting fresh..."
        ^tmux new-session -s main
    } catch {
        print "Failed to restart tmux"
    }
}
