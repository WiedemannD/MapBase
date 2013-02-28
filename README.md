MapBase
=======


**iOS native app starting point for map apps**

The app is similar to what Magnus showed with his Flash variant: you can set hot spots on a map with a certain activity radius (currently the radius is not visual). If your position comes into the active space around a host spot a specified sound will play once.

Currently you can just configure the app with two plist files (actually that's just XML) in the Resources directory.

sounds.plist:
- In this array plist you have to register all different sound files you want to use, by putting in the filenames.

hotSpots.plist:
- In here you set the startUpSetting of the map (to what position it should focus on and how big the region around it should be).
- You also define the hot spots, with filling in the position (lat, lon coordinates), radius, title, subtitle and soundId (the id specified by the position of the filename in sounds.plist).

Two classes were created:
- AudioPlayer: which is what it says it is.
- MapAnnotation: a class to hold the different properties defined in hotSpots.plist

Main functions are in ViewController.m.