# This script is based on Jacob Van Order's answer on apple dev forums https://devforums.apple.com/message/971277
# See also http://spin.atomicobject.com/2011/12/13/building-a-universal-framework-for-ios/ for the start


# To get this to work with a Xcode 6 Cocoa Touch Framework, create Framework
# Then create a new Aggregate Target. Throw this script into a Build Script Phrase on the Aggregate


######################
# Options
######################

usage()
{
cat << EOF
usage: $0 options

This script run the test1 or test2 over a machine.

OPTIONS:
   -target      Target within project. Required parameter
   -t      Test type, can be ‘test1’ or ‘test2’
   -r      Server address
   -p      Server root password
   -v      Verbose
EOF
}

TARGET_NAME="${PROJECT_NAME}"
REVEAL_ARCHIVE_IN_FINDER=true

while getopts “target:reveal” OPTION
do
     case $OPTION in
         target)
             TARGET_NAME=$OPTARG
             ;;
         reveal)
             REVEAL_ARCHIVE_IN_FINDER=$OPTARG
             ;;
     esac
done

if [[ -z $TARGET_NAME ]]
then
	usage
	exit 1
fi

FRAMEWORK_NAME=${TARGET_NAME}

SIMULATOR_LIBRARY_PATH="${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${FRAMEWORK_NAME}.framework"

DEVICE_LIBRARY_PATH="${BUILD_DIR}/${CONFIGURATION}-iphoneos/${FRAMEWORK_NAME}.framework"

UNIVERSAL_LIBRARY_DIR="${BUILD_DIR}/${CONFIGURATION}-iphoneuniversal"

FRAMEWORK="${UNIVERSAL_LIBRARY_DIR}/${FRAMEWORK_NAME}.framework"


######################
# Build Frameworks
######################

xcodebuild -project ${PROJECT_NAME}.xcodeproj -sdk iphonesimulator -target ${TARGET_NAME} -configuration ${CONFIGURATION} clean build CONFIGURATION_BUILD_DIR=${BUILD_DIR}/${CONFIGURATION}-iphonesimulator | echo

xcodebuild -project ${PROJECT_NAME}.xcodeproj -sdk iphoneos -target ${TARGET_NAME} -configuration ${CONFIGURATION} clean build CONFIGURATION_BUILD_DIR=${BUILD_DIR}/${CONFIGURATION}-iphoneos | echo

#xcodebuild -target ${PROJECT_NAME} ONLY_ACTIVE_ARCH=NO -configuration ${CONFIGURATION} -sdk iphoneos  BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" | echo

#xcodebuild -target ${PROJECT_NAME} ONLY_ACTIVE_ARCH=NO -configuration ${CONFIGURATION} -sdk iphonesimulator  BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" | echo


######################
# Create directory for universal
######################

rm -rf "${UNIVERSAL_LIBRARY_DIR}"

mkdir "${UNIVERSAL_LIBRARY_DIR}"

mkdir "${FRAMEWORK}"


######################
# Copy files Framework
######################

cp -r "${DEVICE_LIBRARY_PATH}/." "${FRAMEWORK}"


######################
# Make fat universal binary
######################

lipo "${SIMULATOR_LIBRARY_PATH}/${FRAMEWORK_NAME}" "${DEVICE_LIBRARY_PATH}/${FRAMEWORK_NAME}" -create -output "${FRAMEWORK}/${FRAMEWORK_NAME}" | echo


######################
# On Release, copy the result to desktop folder
######################

if [ "${CONFIGURATION}" == "Release" ]; then
mkdir "${HOME}/Desktop/${FRAMEWORK_NAME}-${CONFIGURATION}-iphoneuniversal/"
cp -r "${FRAMEWORK}" "${HOME}/Desktop/${FRAMEWORK_NAME}-${CONFIGURATION}-iphoneuniversal/"
fi


######################
# If needed, open the Framework folder
######################

if [ ${REVEAL_ARCHIVE_IN_FINDER} = true ]; then
if [ "${CONFIGURATION}" == "Release" ]; then
open "${HOME}/Desktop/${FRAMEWORK_NAME}-${CONFIGURATION}-iphoneuniversal/"
else
open "${UNIVERSAL_LIBRARY_DIR}/"
fi
fi