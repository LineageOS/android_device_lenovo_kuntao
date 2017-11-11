/*
 * Copyright (C) 2014 The CyanogenMod Project
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

package org.cyanogenmod.hardware;

import android.util.Log;
import com.synaptics.fingerprint.Fingerprint;
/*
 * Disable fingerprint gestures
 */

public class KeyDisabler {

    public static final String TAG = "KeyDisabler";

    private static boolean initOk = false;
    private static Fingerprint mFingerprint = new Fingerprint(null);


    /*
     * Return true only if jni load didn't fail
     */

    public static boolean isSupported() {
        Log.i(TAG, "isSupported return: " + true);
        return true;
    }

    /*
     * Are the fingerprint gestures currently disabled?
     */

    public static boolean isActive() {
        Log.i(TAG, "isActive return: " + Fingerprint.isNavEnabled());
        return Fingerprint.isNavEnabled();
    }

    /*
     * Disable fingerprint gestures
     */

    public static boolean setActive(boolean state) {
        Log.i(TAG, "setActive: " + !state);
        int enableRet = Fingerprint.enableNav(!state);
        Log.i(TAG, "enableNav ret: " + enableRet);
        return  enableRet == 0;
    }

}
