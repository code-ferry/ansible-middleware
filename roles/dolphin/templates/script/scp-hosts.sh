workDir=`dirname $0`
workDir=`cd ${workDir};pwd`
set -a
source $workDir/../conf/config/install_config.conf
set +a

txt=""
if [[ "$OSTYPE" == "darwin"* ]]; then
    # Mac OSX
    txt="''"
fi

# declear -A其中的含义是什么
declare -A workersGroupMap=()

# 形成数组？
workersGroup=(${workers//,/ })
# shellcheck disable=SC2068
for workerGroup in ${workersGroup[@]}
do
  worker=`echo $workerGroup|awk -F':' '{print $1}'`
  groupName=`echo $workerGroup|awk -F':' '{print $2}'`
  if [ -z ${workersGroupMap[$worker]} ];then
      workersGroupMap+=([$worker]=$groupName)
  else
      finalGroupName="${workersGroupMap[$worker]},$groupName"
      workersGroupMap[$worker]=$finalGroupName
  fi
done


hostsArr=(${ips//,/ })
# shellcheck disable=SC2068
for host in ${hostsArr[@]}
do
  # 创建目录，if判断语句中的含义。
  if ! ssh -p $sshPort $host test -e $installPath; then
    ssh -p $sshPort $host "sudo mkdir -p $installPath; sudo chown -R $deployUser:$deployUser $installPath"
  fi

  # 删除部署机的目录
  echo "scp dirs to $host/$installPath starting"
  ssh -p $sshPort $host  "cd $installPath/; rm -rf bin/ conf/ lib/ script/ sql/ ui/"

  # 复制下面的每个目录。
  for dsDir in bin conf lib script sql ui install.sh
  do
    # 复制worker的配置文件
    # if worker in workersGroupMap
    if [[ "${workersGroupMap[${host}]}" ]] && [[ "${dsDir}" == "conf" ]]; then
      # 修改worker.groups配置，代码看的不是很懂。
      sed -i ${txt} "s@^#\?worker.groups=.*@worker.groups=${workersGroupMap[${host}]}@g" ${dsDir}/worker.properties
    fi

    #
    echo "start to scp $dsDir to $host/$installPath"
    # Use quiet mode to reduce command line output
    scp -q -P $sshPort -r $workDir/../$dsDir  $host:$installPath
  done

  echo "scp dirs to $host/$installPath complete"
done
