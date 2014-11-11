# PuzzleBoss Haxe/OpenFL SDK

## Purpose

This SDK is designed to give PuzzleBoss games a consistent set of features
including customer support, social media tools, crosspromotion and analytics.

## Setting up your project

You need to embed the images, font and java in your project.xml.  Exact paths may vary.

    <java path="java/pinit-sdk-1.0.jar" if="android" />
    <template path="java/Social.java" rename="src/com/puzzleboss/core/Social.java" if="android" />
    <template path="java/Support.java" rename="src/com/puzzleboss/core/Support.java" if="android" />
    <template path="java/NookStore.java" rename="src/com/puzzleboss/core/NookStore.java" if="android" />
    <assets path="images" rename="images" type="image" if="android" />
    <assets path="fonts" rename="fonts" include="DroidSansBold.ttf" if="android" />
    <haxelib name="haxe-ga" if="android" />
    <haxelib name="actuate" if="android" />

You also need to enter your game information in the Settings.hx file, this information is
used in the analytics requests.

You also need to create a 'share' image for your game when it is shared on eg Pinterest.

You also need to `Images.initialize();` and `Analytics.initialize();` to get things ready.

## Analytics
You will need to install "haxe-ga" which is Google Analytics via `haxelib install haxe-ga`.

To log anything you wish to know you call:

    Analytics.track(action);

The path will prepend information from your Settings.hx file in the format:

    *action*/Settings.TYPE/Settings.PACKAGE/Settings.VENDOR/Settings.VERSION

## App links
When you are linking to an app the AppLink class will help ensure the right structure is
used to open the appstore and record the event in the Analytics.

To open your game in the appstore:

    AppLink.open();

To open any game in the appstore:

    AppLink.open("the_package_name");

To open any game in the appstore including the NOOK store:

    AppLink.open("the_package_name", "the_ean");

## Rating prompt
The rating prompt provides players with a dialogue asking them to rate the game.  It is best
used after a positive moment like a win where there is a natural pause + good will.  To
activate the prompt just call something like:

    if(wins == 1) {
        if(Rating.prompt(parent_display_object)) {
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

To create a "More games" screen, as with Support, `new MoreGames(my_close_method);`

To create a single Promotion, `Promotion.create(my_close_method);`
