#!/usr/bin/env bash

# The script checks that all needed tools are installed and sets OS_NAME and WGET variables

if [[ "$OSTYPE" == "linux"* ]] ; then
  OS_NAME="linux"
elif [[ "$OSTYPE" == "darwin"* ]] ; then
  OS_NAME="mac"
elif [[ "$OSTYPE" == "msys" ]] ; then
  OS_NAME="win"
else
  echo "Error: this script supports only Bash shell on Linux, macOS, or Windows."
  exit 1
fi

if which wget >/dev/null 2>&1 ; then
  WGET="wget -q"
elif which curl >/dev/null 2>&1 ; then
  WGET="curl -sfLO"
else
  echo "Error: this script requires either curl or wget tool installed."
  exit 1
fi

for TOOL_NAME in cmake gperf jar javadoc make perl php sed tar yes unzip ; do
  if ! which "$TOOL_NAME" >/dev/null 2>&1 ; then
    echo "Error: this script requires $TOOL_NAME tool installed."
    exit 1
  fi
done

if [[ $(which make) = *" "* ]] ; then
  echo "Error: OpenSSL expects that full path to make tool doesn't contain spaces. Move it to some other place."
fi

if ! perl -MExtUtils::MakeMaker -MLocale::Maketext::Simple -MPod::Usage -e '' >/dev/null 2>&1 ; then
  echo "Error: Perl installation is broken."
  if [[ "$OSTYPE" == "msys" ]] ; then
    echo "For Git Bash you need to manually copy ExtUtils, Locale and Pod modules to /usr/share/perl5/core_perl from any compatible Perl installation."
  fi
  exit 1
fi