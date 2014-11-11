package puzzleboss;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.net.URLRequest;
import flash.Lib;
import motion.Actuate;

class SocialButtons extends Sprite {

    private static inline var JNI_PATH:String = "com/puzzleboss/core/Social";

    public static function facebook(pkg:String = "", name:String=""):Void {
        if(pkg == null || pkg == "") {
            pkg = Settings.PACKAGE;
        }

        var storelink = "http://puzzleboss.com/" + Settings.TYPE + "/" + pkg;
        var fallback = "http://www.facebook.com/sharer.php?u=" + StringTools.htmlEscape(storelink) + "&t=" + name;

        #if !android
        Lib.getURL(new URLRequest(fallback));
        #else
        var send = openfl.utils.JNI.createStaticMethod(JNI_PATH, "facebookShare", "(Ljava/lang/String;Ljava/lang/String;)V");
        send(storelink, fallback);
        #end

        Analytics.track("/SocialButtons/facebook/" + pkg);
    }

    public static function email(pkg:String = "", name:String = ""):Void {
        if(pkg == null || pkg == "") {
            pkg = Settings.PACKAGE;
        }

        var storelink = "http://puzzleboss.com/" + Settings.TYPE + "/" + pkg;

        #if !android
        Lib.getURL(new URLRequest(storelink));
        #else
        var send = openfl.utils.JNI.createStaticMethod(JNI_PATH, "emailShare", "(Ljava/lang/String;Ljava/lang/String;)V");
        send(storelink, name);
        #end

        Analytics.track("/SocialButtons/email/" + pkg);
    }

    public static function pinterest(pkg:String = "", name:String = ""):Void {
        if(pkg == null || pkg == "") {
            pkg = Settings.PACKAGE;
        }

        var storelink = "http://puzzleboss.com/"+  Settings.TYPE + "/" + pkg;
        var imageurl = Settings.SHARE_IMAGE;
        var fallback = "http://www.pinterest.com/pin/create/button/" +
                        "?url=" + StringTools.htmlEscape(storelink) +
                        "&media=" + StringTools.htmlEscape(imageurl) +
                        "&description=" + StringTools.htmlEscape(name);

        #if !android
        Lib.getURL(new URLRequest(fallback));
        #else

        var send = openfl.utils.JNI.createStaticMethod(JNI_PATH, "pinterestShare", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V");
        send(storelink, imageurl, name, fallback);
        #end

        Analytics.track("/SocialButtons/pinterest/" + pkg);
    }

    public static function googleplus(pkg:String = ""):Void {
        if(pkg == null || pkg == "") {
            pkg = Settings.PACKAGE;
        }

        var storelink = "http://puzzleboss.com/"+  Settings.TYPE + "/" + pkg;
        var fallback = "https://plus.google.com/share?url=" + StringTools.htmlEscape(storelink);

        #if !android
        Lib.getURL(new URLRequest(fallback));
        #else
        var send = openfl.utils.JNI.createStaticMethod(JNI_PATH, "googleShare", "(Ljava/lang/String;Ljava/lang/String;)V");
        send(storelink, fallback);
        #end

        Analytics.track("/SocialButtons/googleplus/" + pkg);
    }

    public static function twitter(pkg:String = ""):Void {
        if(pkg == null || pkg == "") {
            pkg = Settings.PACKAGE;
        }

        var storelink = "http://puzzleboss.com/"+  Settings.TYPE + "/" + pkg;
        var fallback = "https://twitter.com/intent/tweet?original_referer=&text=&url=" + StringTools.htmlEscape(storelink);

        #if !android
        Lib.getURL(new URLRequest(fallback));
        #else

        var send = openfl.utils.JNI.createStaticMethod(JNI_PATH, "twitterShare", "(Ljava/lang/String;Ljava/lang/String;)V");
        send(storelink, fallback);
        #end

        Analytics.track("/SocialButtons/twitter/" + pkg);
    }
}
