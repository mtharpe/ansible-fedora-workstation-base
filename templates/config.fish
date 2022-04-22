# {{ ansible_managed }}

if status is-interactive
  set --export GOROOT "$HOME/go"
  set --export PATH "$HOME/.local/bin:$PATH"
  set --export EDITOR "nvim"
  source ~/.bash_aliases

  function sudo --description "Replacement for Bash 'sudo !!' command to run last command using sudo."
    if test "$argv" = !!
      eval command sudo $history[1]
    else
      command sudo $argv
    end
  end

  function dnf
    sudo dnf -y $argv
  end
end
