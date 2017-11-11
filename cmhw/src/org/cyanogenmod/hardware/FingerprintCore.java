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
import android.util.Log;

public class FingerprintCore {
    protected static final String TAG = "Fingerprint";
    protected Context mContext = null;

    private native int jniCancelOp();

    private native int jniCleanupVcs();

    private native int jniGetEnrolledFingerList(String str, VcsInt vcsInt);

    private native int jniGetFingerprintImage();

    private native Object[] jniGetUserList(VcsInt vcsInt);

    private native String jniGetVersion();

    private native int jniIdentify(String str);

    private native int jniIdentifyEx(String str, Object obj);

    private native int jniInitVcs(FingerprintCore fingerprintCore);

    public FingerprintCore(Context context) {
        this.mContext = context;
        int jniInitVcs = jniInitVcs(this);
        if (jniInitVcs != 0) {
            Log.e(TAG, "Initialization failed, result:" + jniInitVcs);
        }
    }

    public synchronized void FingerprintEventCallback(FingerprintEvent fingerprintEvent) {
    }

    static {
        try {
            System.loadLibrary("vcsfp");
        } catch (Throwable th) {
            Log.e(TAG, "Error loading library libvcsfp: " + th);
        }
    }
}
