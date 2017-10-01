#!/system/bin/sh
# Copyright (c) 2012, Code Aurora Forum. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above
#       copyright notice, this list of conditions and the following
#       disclaimer in the documentation and/or other materials provided
#       with the distribution.
#     * Neither the name of Code Aurora Forum, Inc. nor the names of its
#       contributors may be used to endorse or promote products derived
#      from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
# ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
#
# Allow unique persistent serial numbers for devices connected via usb
# User needs to set unique usb serial number to persist.usb.serialno and
# if persistent serial number is not set then Update USB serial number if
# passed from command line
#

#wait for phone is decrypt and need add some delay
if [ $(getprop ro.crypto.state) = encrypted ]; then
	while [ 1 ]
	do
		if [ $(getprop vold.decrypt) = trigger_restart_framework ]; then
			break;
		fi
		sleep 1
	done
fi

target=`getprop ro.board.platform`
usb_action=`getprop usb.mmi-usb-sh.action`
echo "mmi-usb-sh: action = \"$usb_action\""
sys_usb_config=`getprop sys.usb.config`

tcmd_ctrl_adb ()
{
    ctrl_adb=`getprop tcmd.ctrl_adb`
    echo "mmi-usb-sh: tcmd.ctrl_adb = $ctrl_adb"
    case "$ctrl_adb" in
        "0")
            if [[ "$sys_usb_config" == *adb* ]]
            then
                # *** ALWAYS expecting adb at the end ***
                new_usb_config=${sys_usb_config/,adb/}
                echo "mmi-usb-sh: disabling adb ($new_usb_config)"
                setprop persist.sys.usb.config $new_usb_config
                setprop persist.factory.allow_adb 0
            fi
        ;;
        "1")
            if [[ "$sys_usb_config" != *adb* ]]
            then
                # *** ALWAYS expecting adb at the end ***
                new_usb_config="$sys_usb_config,adb"
                echo "mmi-usb-sh: enabling adb ($new_usb_config)"
                setprop persist.sys.usb.config $new_usb_config
                setprop persist.factory.allow_adb 1
            fi
        ;;
    esac

    exit 0
}

case "$usb_action" in
    "")
    ;;
    "tcmd.ctrl_adb")
        tcmd_ctrl_adb
    ;;
esac

case "$target" in
    "msm8953")
        #Set RPS Mask for Tethering to CPU4
        setprop sys.usb.rps_mask 10
        qcom_usb_config="diag,serial_smd,serial_tty,rmnet_bam,mass_storage"
        qcom_adb_usb_config="diag,serial_smd,serial_tty,rmnet_bam,mass_storage,adb"
        #bpt_usb_config="diag,serial_smd,serial_tty,rmnet"
        #bpt_adb_usb_config="diag,serial_smd,serial_tty,rmnet,adb"
	#lenovo yexh1, change usb setting for bp-tools as qcom
        bpt_usb_config=$qcom_usb_config
        bpt_adb_usb_config=$qcom_adb_usb_config
    ;;
    "msm8996")
        #Set RPS Mask for Tethering to CPU2
        setprop sys.usb.rps_mask 2
        qcom_usb_config="diag,serial_cdev,serial_tty,rmnet_bam,mass_storage"
        qcom_adb_usb_config="diag,serial_cdev,serial_tty,rmnet_bam,mass_storage,adb"
        bpt_usb_config="diag,serial_cdev,serial_tty,rmnet"
        bpt_adb_usb_config="diag,serial_cdev,serial_tty,rmnet,adb"
    ;;
esac

serialno=`getprop persist.usb.serialno`
case "$serialno" in
    "")
    serialnum=`getprop ro.serialno`
    echo "$serialnum" > /sys/class/android_usb/android0/iSerial
    ;;
    * )
    echo "$serialno" > /sys/class/android_usb/android0/iSerial
esac

#
# Allow USB enumeration with default PID/VID
#
echo 1  > /sys/class/android_usb/f_mass_storage/lun/nofua
usb_config=`getprop persist.sys.usb.config`
mot_usb_config=`getprop persist.mot.usb.config`
bootmode=`getprop ro.bootmode`
buildtype=`getprop ro.build.type`
securehw=`getprop ro.boot.secure_hardware`

echo "mmi-usb-sh: persist usb configs = \"$usb_config\", \"$mot_usb_config\""

phonelock_type=`getprop persist.sys.phonelock.mode`
usb_restricted=`getprop persist.sys.usb.policylocked`
if [ "$securehw" == "1" ] && [ "$buildtype" == "user" ]
then
    if [ "$usb_restricted" == "1" ]
    then
        echo 1 > /sys/class/android_usb/android0/secure
    else
        case "$phonelock_type" in
            "1" )
                echo 1 > /sys/class/android_usb/android0/secure
            ;;
            * )
                echo 0 > /sys/class/android_usb/android0/secure
            ;;
        esac
    fi
fi

case "$bootmode" in
    "bp-tools" )
        case "$usb_config" in
            "$bpt_usb_config" | "$bpt_adb_usb_config" )
            ;;
            * )
		case "$securehw" in
		    "1" )
			setprop persist.sys.usb.config $bpt_usb_config
		    ;;
		    *)
			setprop persist.sys.usb.config $bpt_adb_usb_config
		    ;;
		esac
            ;;
        esac
    ;;
    "mot-factory" )
        allow_adb=`getprop persist.factory.allow_adb`
        case "$allow_adb" in
            "1")
                if [ "$usb_config" != "usbnet,adb" ]
                then
                    setprop persist.sys.usb.config usbnet,adb
                fi
            ;;
            *)
                if [ "$usb_config" != "usbnet" ]
                then
                    setprop persist.sys.usb.config usbnet
                fi
            ;;
        esac
    ;;
    "qcom" )
        case "$usb_config" in
            "$qcom_usb_config" | "$qcom_adb_usb_config" )
            ;;
            * )
		case "$securehw" in
		    "1" )
			setprop persist.sys.usb.config $qcom_usb_config
		    ;;
		    *)
			setprop persist.sys.usb.config $qcom_adb_usb_config
		    ;;
		esac
            ;;
        esac
    ;;
    * )
        if [ "$buildtype" == "user" ] && [ "$phonelock_type" != "1" ] && [ "$usb_restricted" != "1" ]
        then
            echo 1 > /sys/class/android_usb/android0/secure
            echo "Disabling enumeration until bootup!"
        fi
                echo "dvusb set"

        case "$mot_usb_config" in
            "mtp,adb" | "mtp" )
		setprop persist.sys.usb.config $mot_usb_config
                echo "dvusb mtp"
            ;;
            "ptp,adb" | "ptp" )
		setprop persist.sys.usb.config $mot_usb_config
                echo "dvusb ptp"
            ;;
            "midi,adb" | "midi" )
		setprop persist.sys.usb.config $mot_usb_config
                echo "dvusb midi"
            ;;
	    #for lenovo internal test setting in ####33284#, keep usb config after reboot
            "mass_storage,adb" | "diag,serial_cdev,serial_tty,rmnet_bam,mass_storage,adb" )
		setprop persist.sys.usb.config $mot_usb_config
            ;;
            *)
		if [ "$buildtype" == "user" ]
		then
			setprop persist.sys.usb.config mtp
		else
			setprop persist.sys.usb.config mtp,adb
                        echo "dvusb default"
		fi
            ;;
        esac

        if [ "$buildtype" == "user" ] && [ "$phonelock_type" != "1" ] && [ "$usb_restricted" != "1" ]
        then
            count=0
            bootcomplete=`getprop sys.boot_completed`
            echo "mmi-usb-sh - bootcomplete = $booted"
            while [ "$bootcomplete" != "1" ]; do
                echo "Sleeping till bootup!"
                sleep 1
                count=$((count+1))
                if [ $count -gt 90 ]
                then
                    echo "mmi-usb-sh - Timed out waiting for bootup"
                    break
                fi
                bootcomplete=`getprop sys.boot_completed`
            done
            echo 0 > /sys/class/android_usb/android0/secure
            echo "Enabling enumeration after bootup, count =  $count !"
        fi
    ;;
esac
