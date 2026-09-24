. "$HOME/.cargo/env"

# Use the GCR SSH agent for local sessions; preserve forwarded SSH agents.
if [[ -n "$XDG_RUNTIME_DIR" && -z "$SSH_CONNECTION" ]]; then
    export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gcr/ssh"
fi
