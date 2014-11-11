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

    public static function init():Void {

        var realfirst = realFirst();
        var gamefirst = gameFirst();

        visitor = new Visitor();
        visitor.setUniqueId(getPlayerId());
        visitor.setScreenResolution(Images.WIDTH + "x" + Images.HEIGHT);

        session = new Session();

        tracker = new Tracker("UA-42445367-2", "puzzleboss.com");
        tracker.addCustomVariable(new CustomVariable(0, "package", Settings.PACKAGE, 1));
        tracker.addCustomVariable(new CustomVariable(0, "vendor", Settings.VENDOR, 1));
        tracker.addCustomVariable(new CustomVariable(0, "version", Settings.VERSION, 2));
    }

    public static function track(action:String):Void {
        if(tracker == null) {
            return;
        }

        action += "/";
        action = StringTools.replace(action, "//", "/");

        var page = new Page(action + Settings.TYPE + "/" + Settings.PACKAGE + "/" + Settings.VENDOR + "/" + Settings.VERSION);
        page.setTitle(Settings.PACKAGE + " (" + Settings.VENDOR + " v" + Settings.VERSION + ")");

        tracker.trackPageview(page, session, visitor);
    }

    private static function realFirst():Bool {
        #if (flash || html5)
        return gameFirst();
        #else
        return hasPlayerId();
        #end
    }

    private static function gameFirst():Bool {
        #if (flash || html5)

        var so = SharedObject.getLocal("analytics");
        var first = !Reflect.hasField(so.data, "first");
        so.data.first = false;
        so.flush();
        return first;

        #else

        var path = Path.path() + "." + Settings.PACKAGE;

        if(FileSystem.exists(path)) {
            return false;
        }

        var fout = File.write(path);
        fout.writeString(Settings.PACKAGE);
        fout.close();

        return true;

        #end
    }

    private static function hasPlayerId():Bool {
        #if (flash || html5)
        return false;
        #else
        var path = Path.path();
        return FileSystem.exists(path + ".playerid");
        #end
    }

    private static function getPlayerId():Int {
        #if (flash || html5)
        return 0;
        #else

        var path = Path.path();

        if(FileSystem.exists(path + ".playerid")) {
            return Std.parseInt(File.getContent(path + ".playerid"));
        }

        var playerid:Int = Std.int(Math.random() * 0x7fffffff);

        var fout = File.write(path + ".playerid");
        fout.writeString(playerid + "");
        fout.close();

        return playerid;
        #end
    }
}