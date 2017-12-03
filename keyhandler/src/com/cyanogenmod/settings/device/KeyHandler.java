/*
 * Copyright (C) 2017 The LineageOS Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.cyanogenmod.settings.device;

import android.content.Context;
import android.os.PowerManager;
import android.os.PowerManager.WakeLock;
import android.os.SystemClock;
import android.provider.Settings;
import android.view.KeyEvent;

import com.android.internal.os.DeviceKeyHandler;

public class KeyHandler implements DeviceKeyHandler {
    private static final String TAG = KeyHandler.class.getSimpleName();

    private static final int KEY_LOW_POWER_SWITCH = 249;

    private static int lastAction = -1;

    private final Context mContext;
    private final PowerManager mPowerManager;
    private final WakeLock mSwitchWakeLock;

    public KeyHandler(Context context) {
        mContext = context;
        mPowerManager = (PowerManager) mContext.getSystemService(Context.POWER_SERVICE);
        mSwitchWakeLock = mPowerManager.newWakeLock(
                PowerManager.PARTIAL_WAKE_LOCK, "SwitchWakeLock");
    }

    private boolean hasSetupCompleted() {
        return Settings.Secure.getInt(mContext.getContentResolver(),
                Settings.Secure.USER_SETUP_COMPLETE, 0) != 0;
    }

    public KeyEvent handleKeyEvent(KeyEvent event) {
        int scanCode = event.getScanCode();
        int action = event.getAction();
        boolean isPowerSaveEnabled = mPowerManager.isPowerSaveMode();

        if (!hasSetupCompleted()) {
            return event;
        }

        if (scanCode == KEY_LOW_POWER_SWITCH && action != lastAction) {
            mSwitchWakeLock.acquire(3000);
            mPowerManager.wakeUp(SystemClock.uptimeMillis(), "switch-wakeup");
            if (action == KeyEvent.ACTION_DOWN) {
                // Switch turned on
                if (!isPowerSaveEnabled) {
                    mPowerManager.setPowerSaveMode(true);
                }
            } else if (action == KeyEvent.ACTION_UP) {
                // Switch turned off
                if (isPowerSaveEnabled) {
                    mPowerManager.setPowerSaveMode(false);
                }
            }

            lastAction = action;

            return null;
        }

        return event;
    }
}
