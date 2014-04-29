WORKON_CONFIG_FILE=".workon"
WORKON_RESET_FUNC="workon_resetfunc"
WORKON_FUNC="workon_func"

function workon_reset {
  if [ $WORKON_CONFIG_FILE_PATH_CACHE ]
  then
    if [ -e $WORKON_CONFIG_FILE_PATH_CACHE ]
    then
      # すでにCONFIGが設定されていて、かつ、存在している場合は
      # そのCONFIGを読み込み、resetfuncを実行する。
      . $WORKON_CONFIG_FILE_PATH_CACHE
      type $WORKON_RESET_FUNC > /dev/null || return 1
      $WORKON_RESET_FUNC
      # 新しいCONFIGを登録するために
      # 現在のCONFIGの設定は削除する
      unset WORKON_CONFIG_FILE_PATH_CACHE
      # 関数を削除
      unset -f $WORKON_FUNC
      unset -f $WORKON_RESET_FUNC
    fi
  fi
}

function workon_workon {
  # ディレクトリが同じならすぐreturn（cdしてないということ）
  local pwd_path=`pwd`
  [ "$pwd_path" = "$WORKON_DIR_CACHE" ] && return 0

  # 現在のディレクトリを記憶
  export WORKON_DIR_CACHE=$pwd_path

  local search_target_path=$pwd_path
  until [ -z $search_target_path ]
  do
    if [ "`\ls -a $search_target_path | \grep $WORKON_CONFIG_FILE`" = "$WORKON_CONFIG_FILE" ]
    then
      # CONFIGが見つかったら記憶
      local found_config_file_path=$search_target_path/$WORKON_CONFIG_FILE
      break
    fi
    # Cut a tail of given full-path
    # give:"/dir1/dir2/dir3/dir4" --> take:"/dir1/dir2/dir3"
    search_target_path=`echo $search_target_path | sed -e "s/\/[^\/]*$//g"`
  done

  if [ $found_config_file_path ]
  then
    # CONFIGがすでに記憶しているやつと一緒ならすぐreturn
    [ "$found_config_file_path" = "$WORKON_CONFIG_FILE_PATH_CACHE" ] && return 0

    # Call reset-function
    workon_reset

    # Load new-config, and Call setting-function
    . $found_config_file_path
    type $WORKON_FUNC > /dev/null || return 1
    $WORKON_FUNC

    # Save current CONFIG
    export WORKON_CONFIG_FILE_PATH_CACHE=$found_config_file_path
  else
    # Call reset-function
    workon_reset
  fi
}
