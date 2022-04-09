#!/bin/sh
set -x


#1
xcodebuild archive \
-scheme MRInAppPurchaseButton \
-configuration Release \
-destination 'generic/platform=iOS' \
-archivePath './build/MRInAppPurchaseButton.framework-iphoneos.xcarchive' \
SKIP_INSTALL=NO \
BUILD_LIBRARIES_FOR_DISTRIBUTION=YES



#2
xcodebuild archive \
-scheme MRInAppPurchaseButton \
-configuration Release \
-destination 'generic/platform=iOS Simulator' \
-archivePath './build/MRInAppPurchaseButton.framework-iphonesimulator.xcarchive' \
SKIP_INSTALL=NO \
BUILD_LIBRARIES_FOR_DISTRIBUTION=YES


#3
xcodebuild -create-xcframework \
-framework './build/MRInAppPurchaseButton.framework-iphonesimulator.xcarchive/Products/Library/Frameworks/MRInAppPurchaseButton.framework' \
-framework './build/MRInAppPurchaseButton.framework-iphoneos.xcarchive/Products/Library/Frameworks/MRInAppPurchaseButton.framework' \
-output './build/MRInAppPurchaseButton.xcframework'
