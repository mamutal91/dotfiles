#!/usr/bin/env bash

source $HOME/.colors &> /dev/null

[ $(cat /etc/hostname) = mamutal91-v2 ] && HOME=/home/mamutal91

fu() {
  if [[ -z ${1} ]]; then
    echo -e "${BLU}Usage:\n"
    echo "${CYA}  fu ${GRE}<function>${END}${YEL}"
    echo "              lmi"
    echo "              gerrit"
    echo "              down"
    echo "              manifest"
    echo "              sync_repos"
    echo "${END}"
  else
    [ ${1} == lmi ] && ssh mamutal91@86.109.7.111 "bash $HOME/.config/scripts/kraken/lmi.sh ${1}"
    [ ${1} == gerrit ] && ssh mamutal91@86.109.7.111 "cd /mnt/roms/sites/docker/docker-files/gerrit && sudo ./repl.sh"
    [ ${1} == down ] && rm -rf /mnt/roms/sites/private/builds/**/*.zip &> /dev/null
    [ ${1} == manifest ] && ssh mamutal91@86.109.7.111 "cd $HOME && git clone ssh://git@github.com/AOSPK/manifest && cd $HOME/manifest && git push ssh://git@github.com/AOSPK-DEV/manifest HEAD:refs/heads/eleven --force"
    [ ${1} == sync_repos ] && ssh mamutal91@86.109.7.111 "bash $HOME/.config/scripts/kraken/sync_repos.sh"
  fi
}

push() {
  if [[ $(pwd | cut -c1-15) == /mnt/roms/jobs/ ]]; then
    repo=$(pwd | sed "s/\/mnt\/roms\/jobs\///; s/\//_/g" | sed "s/KrakenDev_/_/g" | sed "s/Kraken_/_/g" | sed 's/.//')
  else
    repo=$(basename "$(pwd)")
  fi
  github=github
  org=AOSPK-DEV
  branch=eleven

  [ $repo = build_make ] && repo=build
  [ $repo = packages_apps_PermissionController ] && repo=packages_apps_PackageInstaller
  [ $repo = vendor_qcom_opensource_commonsys-intf_bluetooth ] && repo=vendor_qcom_opensource_bluetooth-commonsys-intf
  [ $repo = vendor_qcom_opensource_commonsys-intf_display ] && repo=vendor_qcom_opensource_display-commonsys-intf
  [ $repo = vendor_qcom_opensource_commonsys_bluetooth_ext ] && repo=vendor_qcom_opensource_bluetooth_ext
  [ $repo = vendor_qcom_opensource_commonsys_packages_apps_Bluetooth ] && repo=vendor_qcom_opensource_packages_apps_Bluetooth
  [ $repo = vendor_qcom_opensource_commonsys_system_bt ] && repo=vendor_qcom_opensource_system_bt
  [ $repo = vendor_gapps ] && github=gitlab && org=AOSPK

  [ $repo = device_xiaomi_lmi ] && org=AOSPK-Devices
  [ $repo = device_xiaomi_sm8250-common ] && org=AOSPK-Devices
  [ $repo = kernel_xiaomi_sm8250 ] && org=AOSPK-Devices
  [ $repo = vendor_xiaomi_lmi ] && org=AOSPK-Devices
  [ $repo = vendor_xiaomi_sm8250-common ] && org=AOSPK-Devices

  [ $repo = official_devices ] && branch=master
  [ $repo = www ] && branch=master
  [ $repo = downloadcenter ] && branch=master

  # To Gerrit
  if [[ ${1} == gerrit ]]; then
    topic=${3}

    if [[ -z ${2} ]]; then
      echo -e "${BLU}Usage:\n"
      echo "${CYA}  push gerrit ${RED}-?${END} ${GRE}<topic>${END}${YEL}"
      echo "              -s [Submit automatic]"
      echo "              -v [Verified]"
      echo "              -n [Normal]"
      echo "${END}"
    else
      [ ${2} == -s ] && gerritPush="HEAD:refs/for/${branch}%submit"
      [ ${2} == -v ] && gerritPush="HEAD:refs/for/${branch}%l=Verified+1,l=Code-Review+2"
      [ ${2} == -n ] && gerritPush="HEAD:refs/for/${branch}"

      if [[ ! -d .git ]]; then
        echo "${BOL_RED}You are not in a .git repository${END}"
      else
        echo "${BOL_BLU}Pushing to ${BOL_YEL}gerrit.aospk.org/${MAG}${repo}${END} ${CYA}${branch}${END}"
        export gitdir=$(git rev-parse --git-dir)
        scp -p -P 29418 mamutal91@gerrit.aospk.org:hooks/commit-msg ${gitdir}/hooks/ &> /dev/null
        git commit --amend --no-edit &> /dev/null
        git push ssh://mamutal91@gerrit.aospk.org:29418/${repo} $gerritPush,topic=${topic}
      fi

      [ $repo = manifest ] && echo ${BOL_RED}Pushing manifest to ORG DEV${END} && git push ssh://git@github.com/AOSPK-DEV/manifest HEAD:refs/heads/eleven --force
    fi
  fi

  # To GitHub/GitLab
  if [[ ${1} == -f ]]; then
    echo "${BOL_BLU}Pushing to ${BOL_YEL}github.com/${BOL_RED}${org}/${MAG}${repo}${END} ${CYA}${branch}${END}"
    gh repo create AOSPK-DEV/${repo} --private --confirm &> /dev/null
    git push ssh://git@${github}.com/AOSPK-DEV/${repo} HEAD:refs/heads/${branch} --force
  fi
}

m() {
  git add . && git commit --amend --no-edit
  sleep 2

  pwd=$(pwd)
  cd .git
  sudo rm -rf /tmp/COMMIT_EDITMSG
  sudo cp -rf COMMIT_EDITMSG /tmp/
  cd $pwd

  pathRepo=$(pwd | cut -c26-)

  msgMerge="Merge tag 'android-11.0.0_r38' of https://android.googlesource.com/platform/${pathRepo} into HEAD"

  echo $msgMerge > /tmp/NEW_COMMITMSG
  cat /tmp/NEW_COMMITMSG

  sudo sed -i '1d' /tmp/COMMIT_EDITMSG
  sed -i "s/haggertk/AOSPK-DEV/g" /tmp/COMMIT_EDITMSG
  sed -i "s/android_//g" /tmp/COMMIT_EDITMSG
  sed -i "s/lineage-18.1/eleven/g" /tmp/COMMIT_EDITMSG
  cat /tmp/COMMIT_EDITMSG >> /tmp/NEW_COMMITMSG

  echo -e "\n\nCONTEÚDO:\n$(cat /tmp/NEW_COMMITMSG)"

  msg=$(cat /tmp/NEW_COMMITMSG)

  git add . && git commit --message "${msg}" --amend --author "Alexandre Rangel <mamutal91@gmail.com>" --date "$(date)"
  push gerrit android-11.0.0_r38
  sleep 3 && clear
}

upstream() {
  workingDir=$(mktemp -d) && cd $workingDir
  [ ${2} = lineage-18.1 ] && branch=eleven
  git clone https://github.com/LineageOS/android_${1} -b ${2} ${1}
  cd ${1}
  gh repo create AOSPK/${1} --public --confirm
  gh repo create AOSPK-DEV/${1} --private --confirm
  git push ssh://git@github.com/AOSPK/${1} HEAD:refs/heads/${branch} --force
  git push ssh://git@github.com/AOSPK-DEV/${1} HEAD:refs/heads/${branch} --force
  rm -rf $workingDir
}

up() {
  upstream ${1} lineage-18.1 eleven
  #  upstream ${1} lineage-17.1 ten
  #  upstream ${1} lineage-16.0 pie
  #  upstream ${1} lineage-15.1 oreo-mr1
  #  upstream ${1} cm-14.1 nougat
}

hals() {
  if [[ $(cat /etc/hostname) == mamutal91-v2 ]]; then
    pwd=$(pwd)
    branch=(
      apq8084
      msm8960
      msm8952
      msm8916
      msm8974
      msm8994
      msm8996
      msm8998
      sdm845
      sm8150
      sm8250
      sm8350
    )

    for i in "${branch[@]}"; do
      $HOME/.config/scripts/kraken/hal/hal.sh ${i}
    done

    $HOME/.config/scripts/kraken/hal/caf.sh
    $HOME/.config/scripts/kraken/hal/chromium.sh
    $HOME/.config/scripts/kraken/hal/faceunlock.sh
    $HOME/.config/scripts/kraken/hal/sepolicy.sh
    $HOME/.config/scripts/kraken/hal/fixes.sh

    cd $pwd
  else
    ssh mamutal91@86.109.7.111 "source $HOME/.zshrc && hals"
  fi
}

www() {
  if [[ $(cat /etc/hostname) == mamutal91-v2 ]]; then
    cd $HOME && rm -rf downloadcenter
    git clone ssh://git@github.com/AOSPK/downloadcenter -b master downloadcenter
    sudo rm -rf /mnt/roms/sites/downloadcenter
    sudo cp -rf downloadcenter /mnt/roms/sites
    cd /mnt/roms/sites/downloadcenter
    sudo npm i && sudo npm run build
    cd $HOME
  else
    ssh mamutal91@86.109.7.111 "source $HOME/.zshrc && www"
  fi
}
