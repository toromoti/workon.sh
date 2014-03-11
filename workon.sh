WORKON_CONFIG_FILE=".workon"
WORKON_RESET_FUNC="workon_resetfunc"
WORKON_FUNC="workon_func"

function workon_reset {
  if [ $WORKON_CONFIG_FILE_CACHE ]
  then
    if [ -e $WORKON_CONFIG_FILE_CACHE ]
    then
      # すでにCONFIGが設定されていて、かつ、存在している場合は
      # そのCONFIGを読み込み、resetfuncを実行する。
      . $WORKON_CONFIG_FILE_CACHE
      type $WORKON_RESET_FUNC > /dev/null || return 1
      $WORKON_RESET_FUNC
      # 新しいCONFIGを登録するために
      # 現在のCONFIGの設定は削除する
      unset WORKON_CONFIG_FILE_CACHE
      # 関数を削除
      unset -f $WORKON_FUNC
      unset -f $WORKON_RESET_FUNC
    fi
  fi
}

function workon_workon {
  # ディレクトリが同じならすぐreturn（cdしてないということ）
  local current_dir=`pwd`
  [ "$current_dir" = "$WORKON_DIR_CACHE" ] && return 0

  # 現在のディレクトリを記憶
  export WORKON_DIR_CACHE=$current_dir

  local search_dir=$current_dir
  until [ -z $search_dir ]
  do
    if [ "`\ls -a $search_dir | \grep $WORKON_CONFIG_FILE`" = "$WORKON_CONFIG_FILE" ]
    then
      # CONFIGが見つかったら記憶
      local found_config_file=$search_dir/$WORKON_CONFIG_FILE
      break
    fi
    # Cut a tail of given full-path
    # give:"/dir1/dir2/dir3/dir4" --> take:"/dir1/dir2/dir3"
    search_dir=`echo $search_dir | sed -e "s/\/[^\/]*$//g"`
  done

  if [ $found_config_file ]
  then
    # CONFIGがすでに記憶しているやつと一緒ならすぐreturn
    [ "$found_config_file" = "$WORKON_CONFIG_FILE_CACHE" ] && return 0

    # Call reset-function
    workon_reset

    # Load new-config, and Call setting-function
    . $found_config_file
    type $WORKON_FUNC > /dev/null || return 1
    $WORKON_FUNC

    # Save current CONFIG
    export WORKON_CONFIG_FILE_CACHE=$found_config_file
  else
    # Call reset-function
    workon_reset
  fi
}
