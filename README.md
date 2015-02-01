wxyc-iphone-app
===============

![](https://raw.github.com/jakebromberg/wxyc-iphone-app/master/Resources/mockups/xyc%20listening%20view.png)

This is the official iPhone app for [WXYC](http://wxyc.org/), the community radio station at UNC-Chapel Hill where I used to run the IT Department. WXYC is a non-commercial, free format radio station. It plays an ecclectic mix of music, putting together seemingly disparate forms to highlight unsuspecting similarities.

The app basically boosts our broadcast radius to the planet. Listen to us anywhere. View the live playlist. Check out station updates. Download if from the [App Store](https://itunes.apple.com/us/app/wxyc-radio/id353182815?mt=8).

In terms of goals, there's three broad strokes I'd like to apply to the project right now:

1. Polish off the UI. I want animated transitions and improved esthetics that will carry the app with a fresh look for at least the next five years with little to no alterations.
2. Augment the data per playcut. There's several sub-goals under this one. One includes writing a new backend server to fetch better metadata from online APIs. Another is restructuring the way metadata like album images are fetched (currently that's tied to the album view itself, a really poor choice). Yet another is offering up better sharing options.
3. Extricate almost all third party dependencies. These libraries were introduced at a time when the Cocoa Touch platform left some functionality to be desired. Apple has done a satisfying job of supplying these features in the intervening years.
