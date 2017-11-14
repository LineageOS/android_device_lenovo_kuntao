#!/system/bin/sh
# Copyright (c) 2012-2013,2016 The Linux Foundation. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of The Linux Foundation nor
#       the names of its contributors may be used to endorse or promote
#       products derived from this software without specific prior written
#       permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NON-INFRINGEMENT ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

export PATH=/system/bin

target=`getprop ro.board.platform`
case "$target" in
    "msm8953")
        cap_ver=`cat /sys/devices/soc/1d00000.qcom,vidc/capability_version` 2> /dev/null
        if [ $cap_ver -eq 1 ]; then
            setprop media.msm8953.version 1
            setprop media.settings.xml /etc/media_profiles_8953_v1.xml
        fi
        ;;
esac

# Setup display nodes & permissions
function set_perms() {
    #Usage set_perms <filename> <ownership> <permission>
    chown -h $2 $1
    chmod $3 $1
}

file=/sys/class/graphics/fb0
if [ -d "$file" ]
then
        set_perms $file/idle_time system.graphics 0664
        set_perms $file/dynamic_fps system.graphics 0664
        set_perms $file/dyn_pu system.graphics 0664
        set_perms $file/modes system.graphics 0664
        set_perms $file/mode system.graphics 0664
        set_perms $file/msm_cmd_autorefresh_en system.graphics 0664
fi

# set lineptr permissions for all displays
for fb_cnt in 0 1 2 3
do
    file=/sys/class/graphics/fb$fb_cnt/lineptr_value
    if [ -f "$file" ]; then
        set_perms $file system.graphics 0664
    fi
done

# copy GPU frequencies to system property
if [ -f /sys/class/kgsl/kgsl-3d0/gpu_available_frequencies ]; then
    gpu_freq=`cat /sys/class/kgsl/kgsl-3d0/gpu_available_frequencies` 2> /dev/null
    setprop ro.gpu.available_frequencies "$gpu_freq"
fi
