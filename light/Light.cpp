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

#define LOG_TAG "LightService"

#include "Light.h"

#include <android-base/logging.h>
#include <android-base/stringprintf.h>
#include <fstream>

/*
 * Write value to path and close file.
 */
template <typename T>
static void set(const std::string& path, const T& value) {
    std::ofstream file(path);
    file << value;
}

template <typename T>
static T get(const std::string& path, const T& def) {
    std::ifstream file(path);
    T result;

    file >> result;
    return file.fail() ? def : result;
}

namespace {

using android::hardware::light::V2_0::LightState;

static constexpr int DEFAULT_MAX_BRIGHTNESS = 255;

static uint32_t rgbToBrightness(const LightState& state) {
    uint32_t color = state.color & 0x00ffffff;
    return ((77 * ((color >> 16) & 0xff)) + (150 * ((color >> 8) & 0xff)) +
            (29 * (color & 0xff))) >> 8;
}

static bool isLit(const LightState& state) {
    return (state.color & 0x00ffffff);
}

}  // anonymous namespace

namespace android {
namespace hardware {
namespace light {
namespace V2_0 {
namespace implementation {

Light::Light(std::pair<std::ofstream, uint32_t>&& lcd_backlight,
             std::ofstream&& rgb_led, std::ofstream&& rgb_blink)
    : mLcdBacklight(std::move(lcd_backlight)),
      mRgbLed(std::move(rgb_led)),
      mRgbBlink(std::move(rgb_blink)) {
    auto attnFn(std::bind(&Light::setAttentionLight, this, std::placeholders::_1));
    auto backlightFn(std::bind(&Light::setLcdBacklight, this, std::placeholders::_1));
    auto batteryFn(std::bind(&Light::setBatteryLight, this, std::placeholders::_1));
    auto notifFn(std::bind(&Light::setNotificationLight, this, std::placeholders::_1));
//    auto buttonsFn(std::bind(&Light::setButtonsLight, this, std::placeholders::_1));
    mLights.emplace(std::make_pair(Type::ATTENTION, attnFn));
    mLights.emplace(std::make_pair(Type::BACKLIGHT, backlightFn));
    mLights.emplace(std::make_pair(Type::BATTERY, batteryFn));
    mLights.emplace(std::make_pair(Type::NOTIFICATIONS, notifFn));
//    mLights.emplace(std::make_pair(Type::BUTTONS,buttonsFn));
    mLights.emplace(Type::BUTTONS,
            [](const LightState& state) { set("/sys/class/leds/button-backlight/brightness", rgbToBrightness(state)); });
}

// Methods from ::android::hardware::light::V2_0::ILight follow.
Return<Status> Light::setLight(Type type, const LightState& state) {
    auto it = mLights.find(type);

    if (it == mLights.end()) {
        return Status::LIGHT_NOT_SUPPORTED;
    }

    it->second(state);

    return Status::SUCCESS;
}

Return<void> Light::getSupportedTypes(getSupportedTypes_cb _hidl_cb) {
    std::vector<Type> types;

    for (auto const& light : mLights) {
        types.push_back(light.first);
    }

    _hidl_cb(types);

    return Void();
}

void Light::setAttentionLight(const LightState& state) {
    std::lock_guard<std::mutex> lock(mLock);
    mAttentionState = state;
    setSpeakerBatteryLightLocked();
}

void Light::setLcdBacklight(const LightState& state) {
    std::lock_guard<std::mutex> lock(mLock);

    uint32_t brightness = rgbToBrightness(state);

    // If max panel brightness is not the default (255),
    // apply linear scaling across the accepted range.
    if (mLcdBacklight.second != DEFAULT_MAX_BRIGHTNESS) {
        int old_brightness = brightness;
        brightness = brightness * mLcdBacklight.second / DEFAULT_MAX_BRIGHTNESS;
        LOG(VERBOSE) << "scaling brightness " << old_brightness << " => " << brightness;
    }
    mLcdBacklight.first << brightness << std::endl;
}

void Light::setBatteryLight(const LightState& state) {
    std::lock_guard<std::mutex> lock(mLock);
    mBatteryState = state;
    setSpeakerBatteryLightLocked();
}

void Light::setNotificationLight(const LightState& state) {
    std::lock_guard<std::mutex> lock(mLock);
    mNotificationState = state;
    setSpeakerBatteryLightLocked();
}

void Light::setSpeakerBatteryLightLocked() {
    if (isLit(mNotificationState)) {
        setSpeakerLightLocked(mNotificationState);
        set("/sys/class/leds/rgbled/delay_on", 306483492);
        set("/sys/class/leds/rgbled/delay_off", 197379);
    } else if (isLit(mAttentionState)) {
        setSpeakerLightLocked(mAttentionState);
        set("/sys/class/leds/rgbled/delay_on", 306483492);
        set("/sys/class/leds/rgbled/delay_off", 197379);
    } else if (isLit(mBatteryState)) {
        setSpeakerLightLocked(mBatteryState);
    } else {
        // Lights off
        mRgbLed << 0 << std::endl;
//        mRgbBlink << 0 << std::endl;
        set("/sys/class/leds/rgbled/trigger", "none");
    }
}

void Light::setSpeakerLightLocked(const LightState& state) {
    int rgb, blink;
    int onMs, offMs;
    uint32_t colorRGB = state.color;
    int red, blue, on_time, off_time;

    switch (state.flashMode) {
        case Flash::TIMED:
            onMs = state.flashOnMs;
            offMs = state.flashOffMs;
            break;
        case Flash::NONE:
        default:
            onMs = 0;
            offMs = 0;
            break;
    }

    rgb = colorRGB & 0xFFFFFF;
    red = (colorRGB >> 16) & 0xFF;
    blue = ((colorRGB & 0xFF) << 8) & 0xFF00;

    blink = onMs > 0 && offMs > 0;


    if (  200 >= offMs > 0   )  off_time=197379; 
    if (  400 >= offMs > 200 )  off_time=394758; 
    if (  600 >= offMs > 400 )  off_time=592137; 
    if (  800 >= offMs > 600 )  off_time=723723; 
    if (  1000 >= offMs > 800)  off_time=986895; 

    if (  200 >= onMs > 0   )  on_time=306483492; 
    if (  400 >= onMs > 200 )  on_time=508006884; 
    if (  600 >= onMs > 400 )  on_time=642355812; 
    if (  800 >= onMs > 600 )  on_time=843879204; 
    if (  1000 >= onMs > 800)  on_time=1045402596; 


    // Disable all blinking to start
//      mRgbLed << 0 << std::endl;
//      mRgbBlink << 0 << std::endl;
      set("/sys/class/leds/rgbled/trigger", "timer");
      set("/sys/class/leds/rgbled/delay_on", on_time);
      set("/sys/class/leds/rgbled/delay_off", off_time);

    if (blink) {
        mRgbLed << (red+blue) << std::endl;
//        mRgbBlink << rgb << std::endl;
    } else {
       mRgbLed << (red+blue) << std::endl;
    }
}

}  // namespace implementation
}  // namespace V2_0
}  // namespace light
}  // namespace hardware
}  // namespace android
