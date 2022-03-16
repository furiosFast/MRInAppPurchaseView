#!/bin/sh
set -x


#1
xcodebuild archive \
-scheme MRPurchaseButton \
-configuration Release \
-destination 'generic/platform=iOS' \
-archivePath './build/MRPurchaseButton.framework-iphoneos.xcarchive' \
SKIP_INSTALL=NO \
BUILD_LIBRARIES_FOR_DISTRIBUTION=YES



#2
xcodebuild archive \
-scheme MRPurchaseButton \
-configuration Release \
-destination 'generic/platform=iOS Simulator' \
-archivePath './build/MRPurchaseButton.framework-iphonesimulator.xcarchive' \
SKIP_INSTALL=NO \
BUILD_LIBRARIES_FOR_DISTRIBUTION=YES


#3
xcodebuild -create-xcframework \
-framework './build/MRPurchaseButton.framework-iphonesimulator.xcarchive/Products/Library/Frameworks/MRPurchaseButton.framework' \
-framework './build/MRPurchaseButton.framework-iphoneos.xcarchive/Products/Library/Frameworks/MRPurchaseButton.framework' \
-output './build/MRPurchaseButton.xcframework'
