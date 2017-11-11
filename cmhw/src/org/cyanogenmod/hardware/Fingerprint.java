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

package com.synaptics.fingerprint;

import android.content.Context;

public class Fingerprint extends FingerprintCore {
    // Dummy jni functions to suppress errors
    private native int jniEnableSensorDevice(int i);

    private native int jniEnrollUser(Object obj);

    private native int jniGetTUIDList(Object obj, Object obj2);

    private native int jniNavGetConfig(Object obj);

    private native int jniNavSetConfig(Object obj);

    private native int jniNotify(int i, Object obj);

    private native int jniRemoveEnrolledFinger(Object obj);

    private native int jniRequest(int i, Object obj);

    // Actually used jni functions (redeclared to static)
    private static native int jniEnableNav(boolean z);

    private static native boolean jniIsNavEnabled();

    public Fingerprint(Context context) {
        super(context);
    }

    public static int enableNav(boolean z) {
        return jniEnableNav(z);
    }

    public static boolean isNavEnabled() {
        return jniIsNavEnabled();
    }
}
