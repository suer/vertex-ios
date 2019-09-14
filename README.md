Vertex iOS Client
===========================

Build
---------------------------

### Required
* Xcode 7.2
* CocoaPods 0.39.0

### Preference

Copy plist:

    $ cp Vertex/preference.plist.example Vertex/preference.plist

and edit it.


### Build

    $ pod install

open Vertex.xcworkspace with XCode, and build.

### Build ipa using Fastlane

if you have not create certificates at Apple Developer Center,
you can generate by fastlane match:

```
$ bundle exec fastlane match adhoc
```

then, build:

```
$ export CODE_SIGN_IDENTITY='xxxx' # like 'iPhone Distribution: Full Name (Team ID)'
$ bundle exec fastlane beta
```
