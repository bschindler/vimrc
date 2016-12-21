function __git_info {
  local status dirty branch
  status=$(git status 2> /dev/null)
  test -z "$status" && return
  [[ "$status" =~ "working tree clean" ]] || dirty="*"
  if [[ "$status" =~ "Not currently on any branch" ]]; then
    branch="NO BRANCH";
  else
    branch=$(sed '1{s/.*branch \(.*\).*/\1/g;q}' <<<"$status")
  fi
  echo " [$branch$dirty]"
}
# append git info to the current prompt
export PS1=`echo "$PS1"|sed 's/\\\\w/\\\\w$(__git_info)/g'` 

EDITOR=`which vim`
export PV_PLUGIN_PATH=/home/benjamin/Software/gradient/build:/home/benjamin/Software/paraview/ParaView3_build/bin:/home/benjamin/Software/pv-bingrid/build
PATH=$PATH:~/env/bin/:~/Software/paraview/ParaView3_build/bin:~/Software/air-sdk/bin:/usr/src/linux/tools/perf
export LD_LIBRARY_PATH=/home/benjamin/env/lib:/home/benjamin/env/lib64:${LD_LIBRARY_PATH}
export KDEDIRS=${HOME}/env:/usr
export FLEX_SDK_HOME=~/Software/flex-sdk-4.5	
