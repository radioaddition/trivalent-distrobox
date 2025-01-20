#!/bin/bash
set -euo pipefail

# assign variables for author, reponame and releaseversion
author="$(echo "$2" | cut -d '/' -f1)"
reponame="$(echo "$2" | cut -d '/' -f2)"
releasever="$(rpm -E %fedora)"
repofile="/etc/yum.repos.d/_copr_$author-$reponame.repo"
repofilebak="$HOME/COPR/_copr_$author-$reponame.repo"

# the helptext
helptext=$(
        cat <<EOF

====== Experimental COPR Command in non-DNF Fedora Distributions ======

This Tool is not made or supported by the Fedora Project,
but aims to reproduce the "dnf copr" functionalities for easily adding COPRs.

Usage: copr [OPTION] [ARGUMENT]

Options:
  enable    Add COPR repository
  disable   Keep a repo but disable it
  remove    Remove COPR repository after backing it up
  list      List all COPR repositories in your repo folder
  search    Search for a COPR repository by name (in your Browser)
  help      Display this help text

Argument:
  Name of the COPR repository (for search) or "author/repo" (for install and remove)

Examples:
  copr enable kdesig/kde-nightly-qt6
  copr remove kdesig/kde-nightly-qt6
  copr list
  copr search bubblejail

For help, write me here: https://discussion.fedoraproject.org/u/boredsquirrel/

EOF
)

##### SECURE REPO FILES #####
# changing unix permissions to make them root-owned and read-only by world
# chang SELinux labels to "system_u:object_r:system_conf_t:s0" like the default Fedora repos

secure-files () {
        echo "Securing the repo files against manipulation. Please enter your password one last time."
        run0 sh -c "
        chown root:root /etc/yum.repos.d/* && \
        chmod 744 /etc/yum.repos.d/* && \
        chcon -R system_u:object_r:system_conf_t:s0 /etc/yum.repos.d/
        " || {
                echo "Failed to secure the repo files!"
                exit 1
        }
}

move-repo () {
        # check if backup dir exists, create it when needed
        [ ! -d "$HOME/COPR" ] && mkdir -p "$HOME/COPR"

        run0 sh -c '
                mv "$result" "$repofilebak" &&\
                chown "$USER" "$repofilebak" &&\
                echo 'COPR Repository "$reponame" removed.' ||\
                echo "ERROR removing COPR repository."
        '
}

# Main loop

if [[ "$1" == "enable" ]]; then
        while true; do
		# test if the repo file already exists
		if [[ -e "$repofile" ]]; then
			# set the repo to active
			run0 sed -i 's/enabled=0/enabled=1/g' "$repofile" && echo "Repository $author/$reponame enabled" || echo "Already enabled or repo not found."
		else
			# download the repofile
			echo "downloading repo '$reponame' from '$author' for Fedora '$releasever'..."
			curl -fsSL "https://copr.fedorainfracloud.org/coprs/$author/$reponame/repo/fedora-$releasever/$author-$reponame-fedora.repo" | run0 tee "$repofile" >/dev/null
			secure-files
		fi
		break
		;;
        done

# display the helptext
elif [[ "$1" == "" || "$1" == "-h" || "$1" == "--h" || "$1" == "-help" || "$1" == "--help" || "$1" == "help" ]]; then
        echo "$helptext"
fi
