#!/vendor/bin/sh
# Copyright (c) 2012-2013, 2016-2018, The Linux Foundation. All rights reserved.
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

echo 0 > /proc/sys/kernel/sched_boost

# Scheduler settings
echo 3 > /proc/sys/kernel/sched_window_stats_policy
echo 3 > /proc/sys/kernel/sched_ravg_hist_size

# Task packing settings
echo 0 > /sys/devices/system/cpu/cpu0/sched_static_cpu_pwr_cost
echo 0 > /sys/devices/system/cpu/cpu1/sched_static_cpu_pwr_cost
echo 0 > /sys/devices/system/cpu/cpu2/sched_static_cpu_pwr_cost
echo 0 > /sys/devices/system/cpu/cpu3/sched_static_cpu_pwr_cost
echo 0 > /sys/devices/system/cpu/cpu4/sched_static_cpu_pwr_cost
echo 0 > /sys/devices/system/cpu/cpu5/sched_static_cpu_pwr_cost
echo 0 > /sys/devices/system/cpu/cpu6/sched_static_cpu_pwr_cost
echo 0 > /sys/devices/system/cpu/cpu7/sched_static_cpu_pwr_cost

# Init task load, restrict wakeups to preferred cluster
echo 15 > /proc/sys/kernel/sched_init_task_load

# Spill load is set to 100% by default in the kernel
echo 3 > /proc/sys/kernel/sched_spill_nr_run

# Apply inter-cluster load balancer restrictions
echo 1 > /proc/sys/kernel/sched_restrict_cluster_spill

# Set sync wakee policy tunable
echo 1 > /proc/sys/kernel/sched_prefer_sync_wakee_to_waker

for devfreq_gov in /sys/class/devfreq/qcom,mincpubw*/governor
do
    echo "cpufreq" > $devfreq_gov
done

for devfreq_gov in /sys/class/devfreq/soc:qcom,cpubw/governor
do
    echo "bw_hwmon" > $devfreq_gov
    for cpu_io_percent in /sys/class/devfreq/soc:qcom,cpubw/bw_hwmon/io_percent
    do
        echo 34 > $cpu_io_percent
    done
    for cpu_guard_band in /sys/class/devfreq/soc:qcom,cpubw/bw_hwmon/guard_band_mbps
    do
        echo 0 > $cpu_guard_band
    done
    for cpu_hist_memory in /sys/class/devfreq/soc:qcom,cpubw/bw_hwmon/hist_memory
    do
        echo 20 > $cpu_hist_memory
    done
    for cpu_hyst_length in /sys/class/devfreq/soc:qcom,cpubw/bw_hwmon/hyst_length
    do
        echo 10 > $cpu_hyst_length
    done
    for cpu_idle_mbps in /sys/class/devfreq/soc:qcom,cpubw/bw_hwmon/idle_mbps
    do
        echo 1600 > $cpu_idle_mbps
    done
    for cpu_low_power_delay in /sys/class/devfreq/soc:qcom,cpubw/bw_hwmon/low_power_delay
    do
        echo 20 > $cpu_low_power_delay
    done
    for cpu_low_power_io_percent in /sys/class/devfreq/soc:qcom,cpubw/bw_hwmon/low_power_io_percent
    do
        echo 34 > $cpu_low_power_io_percent
    done
    for cpu_mbps_zones in /sys/class/devfreq/soc:qcom,cpubw/bw_hwmon/mbps_zones
    do
        echo "1611 3221 5859 6445 7104" > $cpu_mbps_zones
    done
    for cpu_sample_ms in /sys/class/devfreq/soc:qcom,cpubw/bw_hwmon/sample_ms
    do
        echo 4 > $cpu_sample_ms
    done
    for cpu_up_scale in /sys/class/devfreq/soc:qcom,cpubw/bw_hwmon/up_scale
    do
        echo 250 > $cpu_up_scale
    done
    for cpu_min_freq in /sys/class/devfreq/soc:qcom,cpubw/min_freq
    do
        echo 1611 > $cpu_min_freq
    done
done

for gpu_bimc_io_percent in /sys/class/devfreq/soc:qcom,gpubw/bw_hwmon/io_percent
do
    echo 40 > $gpu_bimc_io_percent
done

# Disable thermal & BCL core_control to update interactive gov settings
echo 0 > /sys/module/msm_thermal/core_control/enabled
for mode in /sys/devices/soc.0/qcom,bcl.*/mode
do
    echo -n disable > $mode
done
for hotplug_mask in /sys/devices/soc.0/qcom,bcl.*/hotplug_mask
do
    bcl_hotplug_mask=`cat $hotplug_mask`
    echo 0 > $hotplug_mask
done
for hotplug_soc_mask in /sys/devices/soc.0/qcom,bcl.*/hotplug_soc_mask
do
    bcl_soc_hotplug_mask=`cat $hotplug_soc_mask`
    echo 0 > $hotplug_soc_mask
done
for mode in /sys/devices/soc.0/qcom,bcl.*/mode
do
    echo -n enable > $mode
done

# Governor settings
echo 1 > /sys/devices/system/cpu/cpu0/online
echo "interactive" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo "19000 1401600:39000" > /sys/devices/system/cpu/cpufreq/interactive/above_hispeed_delay
echo 85 > /sys/devices/system/cpu/cpufreq/interactive/go_hispeed_load
echo 20000 > /sys/devices/system/cpu/cpufreq/interactive/timer_rate
echo 1401600 > /sys/devices/system/cpu/cpufreq/interactive/hispeed_freq
echo 0 > /sys/devices/system/cpu/cpufreq/interactive/io_is_busy
echo "85 1401600:80" > /sys/devices/system/cpu/cpufreq/interactive/target_loads
echo 39000 > /sys/devices/system/cpu/cpufreq/interactive/min_sample_time
echo 40000 > /sys/devices/system/cpu/cpufreq/interactive/sampling_down_factor
echo 652800 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq

# Bring up all cores online
echo 1 > /sys/devices/system/cpu/cpu1/online
echo 1 > /sys/devices/system/cpu/cpu2/online
echo 1 > /sys/devices/system/cpu/cpu3/online
echo 1 > /sys/devices/system/cpu/cpu4/online
echo 1 > /sys/devices/system/cpu/cpu5/online
echo 1 > /sys/devices/system/cpu/cpu6/online
echo 1 > /sys/devices/system/cpu/cpu7/online

# Enable low power modes
echo 0 > /sys/module/lpm_levels/parameters/sleep_disabled

# Re-enable thermal & BCL core_control now
echo 1 > /sys/module/msm_thermal/core_control/enabled
for mode in /sys/devices/soc.0/qcom,bcl.*/mode
do
    echo -n disable > $mode
done
for hotplug_mask in /sys/devices/soc.0/qcom,bcl.*/hotplug_mask
do
    echo $bcl_hotplug_mask > $hotplug_mask
done
for hotplug_soc_mask in /sys/devices/soc.0/qcom,bcl.*/hotplug_soc_mask
do
    echo $bcl_soc_hotplug_mask > $hotplug_soc_mask
done
for mode in /sys/devices/soc.0/qcom,bcl.*/mode
do
    echo -n enable > $mode
done

# SMP scheduler
echo 85 > /proc/sys/kernel/sched_upmigrate
echo 85 > /proc/sys/kernel/sched_downmigrate
echo 19 > /proc/sys/kernel/sched_upmigrate_min_nice

# Enable sched guided freq control
echo 1 > /sys/devices/system/cpu/cpufreq/interactive/use_sched_load
echo 1 > /sys/devices/system/cpu/cpufreq/interactive/use_migration_notif
echo 200000 > /proc/sys/kernel/sched_freq_inc_notify
echo 200000 > /proc/sys/kernel/sched_freq_dec_notify

# Set Memory parameters
#
# Read adj series and set adj threshold for PPR and ALMK.
# This is required since adj values change from framework to framework.
adj_series=`cat /sys/module/lowmemorykiller/parameters/adj`
adj_1="${adj_series#*,}"
set_almk_ppr_adj="${adj_1%%,*}"
# PPR and ALMK should not act on HOME adj and below.
# Normalized ADJ for HOME is 6. Hence multiply by 6
# ADJ score represented as INT in LMK params, actual score can be in decimal
# Hence add 6 considering a worst case of 0.9 conversion to INT (0.9*6).
set_almk_ppr_adj=$(((set_almk_ppr_adj * 6) + 6))
echo $set_almk_ppr_adj > /sys/module/lowmemorykiller/parameters/adj_max_shift
echo $set_almk_ppr_adj > /sys/module/process_reclaim/parameters/min_score_adj
echo 0 > /sys/module/process_reclaim/parameters/enable_process_reclaim
echo 70 > /sys/module/process_reclaim/parameters/pressure_max
echo 30 > /sys/module/process_reclaim/parameters/swap_opt_eff
echo 0 > /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk
echo 10 > /sys/module/process_reclaim/parameters/pressure_min
echo 1024 > /sys/module/process_reclaim/parameters/per_swap_size
echo "18432,23040,27648,32256,55296,80640" > /sys/module/lowmemorykiller/parameters/minfree
# For 64-bit arch, vmpressure_file_min = LMK minfree's last bin value
echo 80640 > /sys/module/lowmemorykiller/parameters/vmpressure_file_min

# Set 512 for > 3GB
echo 512 > /sys/block/mmcblk0/bdi/read_ahead_kb
echo 512 > /sys/block/mmcblk0/queue/read_ahead_kb
echo 512 > /sys/block/mmcblk0rpmb/bdi/read_ahead_kb
echo 512 > /sys/block/mmcblk0rpmb/queue/read_ahead_kb
echo 512 > /sys/block/dm-0/queue/read_ahead_kb
echo 512 > /sys/block/dm-1/queue/read_ahead_kb

setprop vendor.post_boot.parsed 1

# Let kernel know our image version/variant/crm_version
if [ -f /sys/devices/soc0/select_image ]; then
    image_version="10:"
    image_version+=`getprop ro.build.id`
    image_version+=":"
    image_version+=`getprop ro.build.version.incremental`
    image_variant=`getprop ro.product.name`
    image_variant+="-"
    image_variant+=`getprop ro.build.type`
    oem_version=`getprop ro.build.version.codename`
    echo 10 > /sys/devices/soc0/select_image
    echo $image_version > /sys/devices/soc0/image_version
    echo $image_variant > /sys/devices/soc0/image_variant
    echo $oem_version > /sys/devices/soc0/image_crm_version
fi
