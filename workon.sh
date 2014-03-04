WORKON_CONFIG_FILE=".workon"
WORKON_RESET_FUNC="workonresetfunc"
WORKON_FUNC="workonfunc"

function workon_workon {
  CURRENT_DIR=`pwd`
  [ "$CURRENT_DIR" = "$WORKON_DIR_CACHE" ] && return
  export WORKON_DIR_CACHE=$CURRENT_DIR

  if [ $WORKON_CONFIG_FILE_CACHE ]
  then
    if [ -e $WORKON_CONFIG_FILE_CACHE ]
    then
      . $WORKON_CONFIG_FILE_CACHE
      $WORKON_RESET_FUNC
      unset WORKON_CONFIG_FILE_CACHE
    fi
  fi

  SEARCH_DIR=$CURRENT_DIR
  until [ -z $SEARCH_DIR ]
  do
    if [ "`\ls -a $SEARCH_DIR | \grep $WORKON_CONFIG_FILE`" = "$WORKON_CONFIG_FILE" ]
    then
      . $SEARCH_DIR/$WORKON_CONFIG_FILE
      $WORKON_FUNC
      export WORKON_CONFIG_FILE_CACHE=$SEARCH_DIR/$WORKON_CONFIG_FILE
      break
    fi
    SEARCH_DIR=`echo $SEARCH_DIR | sed -e "s/\/[^\/]*$//g"`
  done
}

PROMPT_COMMAND=workon_workon
