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

#ifndef _BDROID_BUILDCFG_H
#define _BDROID_BUILDCFG_H

#define BTM_DEF_LOCAL_NAME             "Lenovo P2a42"

#define BLE_VND_INCLUDED               TRUE
#define BTM_SCO_ENHANCED_SYNC_ENABLED  FALSE
#define MAX_ACL_CONNECTIONS            16
#define MAX_L2CAP_CHANNELS             32
#define GATT_MAX_PHY_CHANNEL           10

/* Increasing SEPs to 35 from 6 to support SHO/MCast i.e. two streams per codec */
#define AVDT_NUM_SEPS                  35

#endif
