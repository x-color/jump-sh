function _usage_jump {
  echo "Usage:"
  echo "  jump [-a TAG] [-d TAG] [-l] [-h] TAG"
  echo ""
  echo "Description:"
  echo "  Jump to tagging directory"
  echo ""
  echo "Options:"
  echo "  -a    add tag for current directory"
  echo "  -d    delete tag"
  echo "  -l    list up tags"
  echo "  -h    print this help"
}

function jump {
  local OPTIND OPTARG OPT
  local _flg_add _flg_del _flg_lst _tag_add _tag_del

  # Options parser
  while getopts a:d:lh OPT
  do
    case $OPT in
      "a" ) _flg_add="TRUE"
            _tag_add="$OPTARG" ;;
      "d" ) _flg_del="TRUE"
            _tag_del="$OPTARG" ;;
      "l" ) _flg_lst="TRUE" ;;
      "h" ) _usage_jump
            return 1 ;;
        * ) _usage_jump
            return 1 ;;
    esac
  done

  # Delete bookmark
  if [ "$_flg_del" = "TRUE" ]
  then
    # Delete
    sed -i -e '/^'$_tag_del',/d' ~/.jump_tags
  fi

  # Add tag
  if [ "$_flg_add" = "TRUE" ]
  then
    local dic_path=`pwd`
    local _check=`grep -e '^'$_tag_add',' ~/.jump_tags`
    if [ "$_check" != "" ]
    then
      # Error : tag is already resistered in .jump_tags
      echo -e "[$_tag_add] is already registered in tags." 1>&2
      return 1
    else
      # Add
      echo "$_tag_add,$dic_path" >> ~/.jump_tags
    fi
  fi

  # List up tags
  if [ "$_flg_lst" = "TRUE" ]
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
    local _dir_path=`grep -w -E "^$1" ~/.jump_tags | cut -d , -f2`
    if [ "$_dir_path" = "" ]
    then
      # Error : cannot find tag in .jump_tags
      echo "[$1] can not find in tags." 1>&2
      return 1
    else
      # Jump
      cd $_dir_path
    fi
  elif [ "$OPTIND" = "1" ]
  then
    # No option and no argument
    _usage_jump
  fi
}

# Completion
function _jump {
  local cur=${COMP_WORDS[COMP_CWORD]}
  COMPREPLY=( $(compgen -W "$(cat ~/.jump_tags | cut -d "," -f1)" -- $cur) )
}

complete -F _jump jump
