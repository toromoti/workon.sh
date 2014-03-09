WORKON_CONFIG_FILE=".workon"
WORKON_RESET_FUNC="workonresetfunc"
WORKON_FUNC="workonfunc"

function workon_reset {
  if [ $WORKON_CONFIG_FILE_CACHE ]
  then
    if [ -e $WORKON_CONFIG_FILE_CACHE ]
    then
      # すでにCONFIGが設定されていて、かつ、存在している場合は
      # そのCONFIGを読み込み、resetfuncを実行する。
      . $WORKON_CONFIG_FILE_CACHE
      $WORKON_RESET_FUNC
      # 新しいCONFIGを登録するために
      # 現在のCONFIGの設定は削除する
      unset WORKON_CONFIG_FILE_CACHE
    fi
  fi
}

function workon_workon {
  # ディレクトリが同じならすぐreturn（cdしてないということ）
  local current_dir=`pwd`
  [ "$current_dir" = "$WORKON_DIR_CACHE" ] && return

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
    [ "$found_config_file" = "$WORKON_CONFIG_FILE_CACHE" ] && return

    # Call reset-function
    workon_reset

    # Load new-config, and Call setting-function
    . $found_config_file && $WORKON_FUNC

    # Save current CONFIG
    export WORKON_CONFIG_FILE_CACHE=$found_config_file
  else
    # Call reset-function
    workon_reset
  fi
}
