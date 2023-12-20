#!/bin/bash

set -e

if [ -z "${INPUT_URL}" ]; then
  echo 'required url parameter'
  exit 1
fi

if [ -z "${INPUT_ACTOR}" ]; then
  echo 'required actor parameter'
  exit 1
fi

if [ -z "${INPUT_REPO}" ]; then
  echo 'required repo parameter'
  exit 1
fi
git config --global --add safe.directory $PWD
# git
git config --global http.postBuffer 524288000
git config --global http.maxRequestBuffer 200M
git config --global http.core.compression 0
git config --global user.name 'download-action[bot]'
git config --global user.email 'download-action-bot@example.com'
git remote set-url origin https://${INPUT_ACTOR}:${GITHUB_TOKEN}@github.com/${INPUT_REPO}.git
git pull --rebase

target='target'
urls=(${INPUT_URL})

if [ ! -d ${target} ];then
  mkdir ${target}
fi

cd ${target}
start=`ls -l |grep "^d"|wc -l`
i=1

for each in ${urls[@]}
do
    # unset IFS
    mkdir -p ${start} && cd ${start}
    echo "downloading ${each}"
    if [[ ${each} == http* ]]; then
        echo "wget -nv ${each}"
        wget -nv ${each} -o log
        filename=`cat log |awk -F \" '{print $2}'`
        size=`ls -l ${filename} | awk '{print $5}'`
        echo 'filename: '${filename}' size: '${size}
        if [ ${size} -gt 104857600 ]; then
          if [ -z "${INPUT_USEGITLFS}" ]; then
            zip -r ${filename}.zip ${filename}
            zip -s 100m ${filename}.zip --out output-${filename}.zip
            rm ${filename}*
          else
            git lfs track ${filename}
          fi
        fi
        rm log
        i=$(($i+1))
        start=$(($start+1))
    elif [[ ${each} == magnet* ]]; then
        echo "torrent download ${each}"
        torrent download ${each}
        for item in `ls`
        do
            size=`ls -l ${item} | awk '{print $5}'`
            if [ $size -gt 104857600 ]; then
              if [ -z "${INPUT_USEGITLFS}" ]; then
                zip -r ${item}.zip ${item}
                zip -s 100m ${item}.zip --out output-${item}.zip
                rm ${item}*
              else
                git lfs track ${item}
              fi
            fi
        done
        i=$(($i+1))
        start=$(($start+1))
    else 
        echo "not support: ${each}"
    fi
    cd ..
done

cd ..

git add .
git commit -m "upload"
git push

echo 'download successfully.'
