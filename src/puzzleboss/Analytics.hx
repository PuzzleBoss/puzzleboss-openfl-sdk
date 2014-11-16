package puzzleboss;

import flash.net.SharedObject;
import googleAnalytics.Page;
import googleAnalytics.Visitor;
import googleAnalytics.Session;
import googleAnalytics.Tracker;
import googleAnalytics.Event;
import googleAnalytics.CustomVariable;

#if (!html5 && !flash)
import sys.io.File;
import sys.io.FileOutput;
import sys.io.FileInput;
import sys.FileSystem;
#end

class Analytics {

    private static var visitor:Visitor;
    private static var session:Session;
    private static var tracker:Tracker;

    /**
     * initialize prepares the analytics package with your tracking
     * code and player id
     */
    public static function initialize():Void {

        visitor = new Visitor();
        session = new Session();
        tracker = new Tracker("UA-42445367-2", "puzzleboss.com");
    }

    /**
     * track will send a pageview to google analytics prefixed with
     * your 'action'.  It will append the information from your Settings.hx
     * to the url so you can segregate based on version, appstore etc.
     *
     * @param action your action, eg '/opened'
     */
    public static function track(action:String):Void {
        if(tracker == null) {
            return;
        }

        action = "/" + action + "/";
        action = StringTools.replace(action, "//", "/");

        var page = new Page(action + Settings.TYPE + "/" + Settings.PACKAGE + "/" + Settings.VENDOR + "/" + Settings.VERSION);
        page.setTitle(Settings.PACKAGE + " (" + Settings.VENDOR + " v" + Settings.VERSION + ")");

        tracker.trackPageview(page, session, visitor);
    }
}
