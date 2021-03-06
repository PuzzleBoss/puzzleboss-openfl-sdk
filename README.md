# PuzzleBoss Haxe/OpenFL SDK

## Purpose

This SDK is designed to give PuzzleBoss games a consistent set of features
including customer support, social media tools, crosspromotion and analytics.

## License
This SDK is MIT licensed, you should feel free to adapt it to your specific
requirements with no branding, linking or attribution required in your games.

Parts of it (such as the Pinterest SDK) carry their own licenses.

## Setting up your project

Embed the images, font and java in your project.xml

    <java path="java/pinit-sdk-1.0.jar" if="android" />
    <template path="java/Social.java" rename="src/com/puzzleboss/core/Social.java" if="android" />
    <template path="java/Support.java" rename="src/com/puzzleboss/core/Support.java" if="android" />
    <template path="java/NookStore.java" rename="src/com/puzzleboss/core/NookStore.java" if="android" />
    <template path="java/Path.java" rename="src/com/puzzleboss/core/Path.java" if="android" />
    <template path="java/ExitApp.java" rename="src/com/puzzleboss/core/ExitApp.java" if="android" />
    <assets path="images" rename="images" type="image" if="android" />
    <assets path="fonts" rename="fonts" include="DroidSansBold.ttf" if="android" />
    <haxelib name="haxe-ga" if="android" />
    <haxelib name="actuate" if="android" />
    <haxeflag name="-D nook" if="change_to_android_for_nook_linking" />

In your [AndroidManifest.xml](http://labe.me/en/blog/posts/2013-06-28-OpenFL-AndroidManifest.xml-and-greater-Android-SDK-version.html#.Uovh58SfhKc) you need to include these permissions

    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.STORAGE" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />

Enter your game information in the Settings.hx file, this information is used in the analytics requests and as the default info for using the AppLink class to open whatever appstore.

Create a 'share' image for your game when it is shared on eg Pinterest and upload it somewhere

Initialize classes

    CrossPromotion.initialize();
    Images.initialize();
    Analytics.initialize();

## Analytics
You will need to install "haxe-ga" which is Google Analytics via `haxelib install haxe-ga`.  To log
anything you wish to know you call `Analytics.track` with whatever information starting with a '/'.

	Analytics.track(action);

The path will prepend information from your Settings.hx file in the format:

	/*action*/Settings.TYPE/Settings.PACKAGE/Settings.VENDOR/Settings.VERSION

## App exiting

    AppExit.enable(); // listen for back press
    AppExit.disable(); // stop listening
    AppExit.exit(); // exit yourself

## App links
When you are linking to an app the AppLink class will help ensure the right structure is
used to open the appstore and record the event in the Analytics.

To open your game in the appstore:

    AppLink.open(); // uses Settings.hx info

To open a game on the appstore you're publishing to:

    AppLink.open("package", "ean");

To open a game to a particular appstore:

    AppLink.nook("the_ean", "http://link"); // will deeplink nook appstore on nook tablets
    AppLink.google("the_package");
    AppLink.amazon("the_pachage");

To open a link:

    AppLink.link("http://...");

## Rating prompt
The rating prompt provides players with a dialogue asking them to rate the game.  It is best
used after a positive moment like a win where there is a natural pause + good will.  To
activate the prompt just call something like:

	if(wins == 1) {
        var r = Rating.create(parent_display_object, my_close_method);
		if(r != null) {
			// we have a prompt now
		} else {
			// continue doing something else
		}
	}

Rating.prompt returns false if it is unable to attach the prompt, eg the player has said 'never'
or already rated the game.

## Social media
The SocialButtons.hx provides methods for you to easily allow sharing on Facebook, Twitter,
Pinterest, Google Plus and by email.

We provide the graphics and methods you can use to open the social media sites, you will need
to decide where and how to integrate in your game.

To open a social media url, as with the AppLink, you can default to your own game with no parameters
or specify a game.

	SocialButtons.twitter(pkg);
	SocialButtons.facebook(pkg, name);
	SocialButtons.pinterest(pkg, name);
	SocialButtons.email(pkg, name);
	socialButtons.googleplus(pkg);

We have included assets and an IconButton class that can help you create these:

	addChild(new IconButton("facebook", openFacebook);

	private function openFacebook(e:Event):Void {
		SocialButtons.facebook();
	}

## Support
The support screen allows customers to email PuzzleBoss with some device information included which
is helpful debugging different store versions and tablets.

To create the support screen you need a button with text like 'Help & support' and when it is clicked
create a `new Support(my_close_method);` and add it to your display.

Your close method takes one parameter, an Event, and will need to remove the support and then do whatever
follows in your game, eg:

    private function closeSupport(e:Event):Void {
        removeChild(support);
        // then go to the homescreen or whatever
    }

## Cross promotion
The crosspromotion downloads JSON advertisements for games in the puzzleboss catalog.  It can be used in
two ways, via the "More games" which is a full-screen and allows multiple Promotion's to be browsed, or to
create a single Promotion that can be shown at any point like an interstitial ad.

To create a "More games" screen:

    var m = MoreGames.create(parent, my_close_method);

    if (m != null) {
        // enjoy
    } else {
        // crosspromotions aren't ready yet
    }

To create a single Promotion:

    var p = Promotion.create(parent, my_close_method);

    if(p != null) {
        // enjoy
    } else {
        // not ready
    }

If you are going to use your own JSON you will need to modify CrossPromotion.hx to fetch it from your URL.

The cross-promotion allows you to specify an image and define hitareas to link to various appstores.  You
can exclude any hitareas you don't want.  The rectangle is (x, y, width, height).

    {
        "amazon": [ {
            "imageurl": "http://files2.puzzleboss.com/promotions/farmanimals-halfprice.jpg",
            "hitareas": {
                "amazon": {
                    "rect": "998,1031,566,269",
                    "pkg":"com.your.game"
                },
                "google": {
                    "rect": "998,1031,566,269",
                    "pkg":"com.your.game"
                },
                "nook": {
                    "rect": "998,1031,566,269",
                    "ean":"n1234567890",
                },
                "iTunes": {
                    "rect": "998,1031,566,269",
                    "url":"http:/...."
                },
                "url": {
                    "rect": "123,123,123,123",
                    "url": "https://www.google.com...."
                }
            }
        }],
    }
