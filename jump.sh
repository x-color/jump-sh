# Jump to bookmarking directory

# $ jump [-d TAG] [-l] [-h] [-t TAG] TAG
# $ jump TAG    : go to directory of TAG
# $ jump -d TAG : Delete TAG in tag list
# $ jump -l     : List up tags
# $ jump -h     : Show help
# $ jump -t TAG : Add TAG to tag list

function _jump_help {
  echo -e "jump [-d TAG] [-l] [-h] [-t TAG] TAG\n"
  echo "  jump TAG    : go to directory of TAG"
  echo "  jump -d TAG : Delete TAG in tag list"
  echo "  jump -l     : List up tags"
  echo "  jump -h     : Show help"
  echo "  jump -t TAG : Add TAG to tag list"
}

function jump {
  local OPTIND OPTARG OPT
  local FLG_ADD FLG_DEL FLG_LST TAG_ADD TAG_DEL

  # Options parser
  while getopts d:lht: OPT
  do
    case $OPT in
      "d" ) FLG_DEL="TRUE" ; TAG_DEL="$OPTARG" ;;
      "l" ) FLG_LST="TRUE" ;;
      "h" ) _jump_help
            return 1 ;;
      "t" ) FLG_ADD="TRUE" ; TAG_ADD="$OPTARG" ;;
        * ) echo "Usage: jump [-d TAG] [-l] [-h] [-t TAG] TAG" >&2
            return 1 ;;
    esac
  done

  # Delete bookmark
  if [ "$FLG_DEL" = "TRUE" ]
  then
    # Delete
    sed -i -e '/^'$TAG_DEL',/d' ~/.jump_tags
  fi

  # Add tag
  if [ "$FLG_ADD" = "TRUE" ]
  then
    local DIC_PATH=`pwd`
    local CHECK=`grep -e '^'$TAG_ADD',' ~/.jump_tags`
    if [ "$CHECK" != "" ]
    then
      # Error : tag is already resistered in .jump_tags
      echo -e "[$TAG_ADD] is already registered." >&2
      return 1
    else
      # Add
      echo "$TAG_ADD,$DIC_PATH" >> ~/.jump_tags
    fi
  fi

  # List up tags
  if [ "$FLG_LST" = "TRUE" ]
  then
    # List up
    cat ~/.jump_tags | sort | column -t -s,
  fi

  # Delete options
  shift `expr $OPTIND - 1`

  # Check arguments
  if [ "$#" != "0" ]
    then
    # Jump to tag
    local DIR_PATH=`grep -w -E "^$1" ~/.jump_tags | cut -d , -f2`
    if [ "$DIR_PATH" = "" ]
    then
      # Error : cannot find tag in .jump_tags
      echo "[$1] can not find." >&2
      return 1
    else
      # Jump
      cd $DIR_PATH
    fi
  fi
}

# Completion
function _jump {
  local cur=${COMP_WORDS[COMP_CWORD]}
  COMPREPLY=( $(compgen -W "$(cat ~/.jump_tags | cut -d "," -f1)" -- $cur) )
}

complete -F _jump jump
