# Handle completions insecurities (i.e., completion-dependent directories with
# insecure ownership or permissions) by:
#
# * Human-readably notifying the user of these insecurities.
function handle_completion_insecurities() {
  # List of the absolute paths of all unique insecure directories, split on
  # newline from compaudit()'s output resembling:
  #
  #     There are insecure directories:
  #     /usr/share/zsh/site-functions
  #     /usr/share/zsh/5.0.6/functions
  #     /usr/share/zsh
  #     /usr/share/zsh/5.0.6
  #
  # Since the ignorable first line is printed to stderr and thus not captured,
  # stderr is squelched to prevent this output from leaking to the user.
  local -aU insecure_dirs
  insecure_dirs=( ${(f@):-"$(compaudit 2>/dev/null)"} )

  # If no such directories exist, get us out of here.
  [[ -z "${insecure_dirs}" ]] && return

  # List ownership and permissions of all insecure directories.
  print "[ry-zsh] Insecure completion-dependent directories detected:"
  ls -ld "${(@)insecure_dirs}"

  cat <<EOD

[ry-zsh] For safety, we will not load completions from these directories until
[ry-zsh] you fix their permissions and ownership and restart zsh.
[ry-zsh] See the above list for directories with group or other writability.

[ry-zsh] To fix your permissions you can do so by disabling
[ry-zsh] the write permission of "group" and "others" and making sure that the
[ry-zsh] owner of these directories is either root or your current user.
[ry-zsh] The following command may help:
[ry-zsh]     compaudit | xargs chmod g-w,o-w

[ry-zsh] If the above didn't help or you want to skip the verification of
[ry-zsh] insecure directories you can set the variable ZSH_DISABLE_COMPFIX to
[ry-zsh] "true" before ry-zsh is sourced in your zshrc file.

EOD
}
