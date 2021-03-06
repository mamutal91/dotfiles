#!/usr/bin/env bash

source $HOME/.Xcolors &> /dev/null
source $HOME/.mytokens/.myTokens &> /dev/null

if [[ ! -f $HOME/.jenkins-cli.jar ]]; then
  cd $HOME
  wget https://ci.aospk.org/jnlpJars/jenkins-cli.jar
  mv jenkins-cli.jar .jenkins-cli.jar
fi

cli="java -jar $HOME/.jenkins-cli.jar -s http://86.109.7.111:8080 -auth ${myUserCI}:${ciKrakenToken} -webSocket"

JOB=KrakenDev
codename=lmi
codenameRandom=vayu

build="$cli build $JOB -p codename=${codename}"
buildRandom="$cli build $JOB -p codename=${codenameRandom}"
buildSync="$cli build $JOB -p codename=${codename} -p sync=true"
buildSyncClean="$cli build $JOB -p codename=${codename} -p sync=true -p mka_clean=true"
buildSyncInstallclean="$cli build $JOB -p codename=${codename} -p sync=true -p mka_installclean=true"
makeClean="$cli build $JOB -p build=false -p sync=false -p mka_clean=true -p mka_installclean=false -p publish_build=false"
onlySync="$cli build $JOB -p build=false -p sync=true -p mka_clean=false -p mka_installclean=false -p publish_build=false"
stop="$cli stop-builds"
clear="$cli clear-queue"
console="$cli console $JOB -f"
disable="$cli disable-job"
enable="$cli enable-job"
package="$cli build $JOB -p build=true -p sync=false -p mka_clean=false -p mka_installclean=false -p publish_build=false"

if [[ ${1} == package ]]; then
  echo "${BOL_BLU}Select the task to build${END}"
  echo "  1) recoveryimage"
  echo "  2) bootimage"
  echo "  3) SystemUI"
  echo "  4) Settings"
  echo "  5) Launcher3QuickStep"
  echo "  6) CustomParts"
  package="$cli build $JOB -p build=true -p sync=false -p mka_clean=false -p mka_installclean=false -p publish_build=false"
  read n
  case $n in
    1) $stop $JOB && $package -p task=recoveryimage && package=recoveryimage ;;
    2) $stop $JOB && $package -p task=bootimage && package=bootimage ;;
    3) $stop $JOB && $package -p task=SystemUI && package=SystemUI ;;
    4) $stop $JOB && $package -p task=Settings && package=Settings ;;
    5) $stop $JOB && $package -p task=Launcher3QuickStep && package=Launcher3QuickStep ;;
    6) $stop $JOB && $package -p task=CustomParts && package=CustomParts ;;
    *) echo "Invalid option" ;;
  esac
  echo -e "Building package ${YEL}${package}...${RED}"
  sleep 1
  exit
fi

echo -e "${BOL_BLU}Executing command via ci-cli...\n${END}${GRE}"

[ ${1} = build ] && echo -e "Building dirty for ${BLU}lmi${END}...${RED}" && $build
[ ${1} = buildRandom ] && echo -e "Building dirty for ${BLU}${codenameRandom}${END}...${RED}" && $buildRandom
[ ${1} = buildSync ] && echo -e "Synchronizing source to build dirty...${RED}" && $buildSync
[ ${1} = buildSyncClean ] && echo -e "Cleaning build to build...${RED}" && $buildSyncClean
[ ${1} = buildSyncInstallclean ] && echo -e "Cleaning apps to build...${RED}" && $buildSyncInstallclean
[ ${1} = makeClean ] && echo -e "Make clean...${RED}" && $makeClean
[ ${1} = stopOnlySync ] && echo -e "Stopping jobs and synchronizing source...${RED}" && $stop $JOB && $onlySync
[ ${1} = stopJobs ] && echo -e "Stopping $JOB job running...${RED}" && $stop $JOB
[ ${1} = stopClear ] && echo -e "Stopping jobs and clearing jobs from the queue...${RED}" && $clear
[ ${1} = enableJobs ] && echo -e "Enabling jobs...${RED}" && $enable KrakenMaintainers && $enable PA
[ ${1} = disableJobs ] && echo -e "Disabling jobs...${RED}" && $disable KrakenMaintainers && $disable PA

echo -e "\n${BOL_BLU}Exiting..."
sleep 1
