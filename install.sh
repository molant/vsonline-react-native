#/bin/bash

SDK_VERSION=sdk-tools-linux-4333796.zip
ANDROID_BUILD_VERSION=29
ANDROID_TOOLS_VERSION=29.0.2
BUCK_VERSION=2019.10.17.01
NDK_VERSION=20

ADB_INSTALL_TIMEOUT=10
export ANDROID_HOME=/home/vsonline/android
export ANDROID_SDK_HOME=${ANDROID_HOME}
export ANDROID_NDK=/home/vsonline/ndk/android-ndk-r$NDK_VERSION

export PATH=${ANDROID_NDK}:${ANDROID_HOME}/emulator:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools:/opt/buck/bin/:${PATH}

cat .bashrc_env >> ~/.bashrc

mv .bashrc_aliases ~

curl -sS https://dl.google.com/android/repository/android-ndk-r$NDK_VERSION-linux-x86_64.zip -o /tmp/ndk.zip \
	&& mkdir /home/vsonline/ndk \
	&& unzip -q -d /home/vsonline/ndk /tmp/ndk.zip	

sudo curl -sS -L https://github.com/facebook/buck/releases/download/v${BUCK_VERSION}/buck.${BUCK_VERSION}_all.deb -o /tmp/buck.deb \
	&& sudo dpkg -i /tmp/buck.deb

curl -sS https://dl.google.com/android/repository/${SDK_VERSION} -o /tmp/sdk.zip \
	&& mkdir ${ANDROID_HOME} \
	&& mkdir ${ANDROID_HOME}/.android \
	&& touch ${ANDROID_HOME}/.android/repositories.cfg \
	&& unzip -q -d ${ANDROID_HOME} /tmp/sdk.zip \
	&& yes | sdkmanager --licenses \
	&& yes | sdkmanager "platform-tools" \
	"emulator" \
	"platforms;android-28" \
	"platforms;android-$ANDROID_BUILD_VERSION" \
	"build-tools;28.0.3" \
	"build-tools;$ANDROID_TOOLS_VERSION" \
	"add-ons;addon-google_apis-google-23" \
	"system-images;android-19;google_apis;armeabi-v7a" \
	"extras;android;m2repository"

echo "no" | avdmanager --verbose create avd --force --name "pixel_9.0" --device "pixel" --package "system-images;android-19;google_apis;armeabi-v7a" --tag "google_apis"

chown -R vsonline:vsonline /home/vsonline/android
