/*
 * Copyright (C) 2019 The LineageOS Project
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

package org.lineageos.settings.device;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.provider.Settings;
import android.view.KeyEvent;

import com.android.internal.os.DeviceKeyHandler;

public class KeyHandler implements DeviceKeyHandler {

    private final Context mContext;
    private boolean mFingerprintGesturesEnabled = false;

    public KeyHandler(Context context) {
        mContext = context;

        IntentFilter fingerprintGesturesFilter =
                new IntentFilter(Constants.FINGERPRINT_GESTURES_INTENT);
        mContext.registerReceiver(mFingerprintGesturesReceiver, fingerprintGesturesFilter);
    }

    @Override
    public KeyEvent handleKeyEvent(KeyEvent event) {
        if (!hasSetupCompleted()) {
            return event;
        }

        if ((event.getKeyCode() == KeyEvent.KEYCODE_BACK && event.getScanCode() == 562 ||
                event.getKeyCode() == KeyEvent.KEYCODE_APP_SWITCH && event.getScanCode() == 563)) {
            /* Consume the fingerprint gestures key events if not enabled */
            return !mFingerprintGesturesEnabled ? null : event;
        }

        return event;
    }

    private boolean hasSetupCompleted() {
        return Settings.Secure.getInt(mContext.getContentResolver(),
                Settings.Secure.USER_SETUP_COMPLETE, 0) != 0;
    }

    private BroadcastReceiver mFingerprintGesturesReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            mFingerprintGesturesEnabled =
                    intent.getBooleanExtra(Constants.FINGERPRINT_GESTURES_INTENT_ENABLED, false);
        }
    };
}
