#if (!html5 && !flash)
package puzzleboss;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Loader;
import flash.events.Event;
import flash.events.ProgressEvent;
import flash.geom.Rectangle;
import flash.net.URLLoader;
import flash.net.URLRequest;
import haxe.Timer;
import sys.io.File;
import sys.io.FileOutput;
import sys.io.FileInput;
import sys.FileSystem;
import haxe.ds.ArraySort;

class CrossPromotion
{
    public static var GAMES:Array<CrossPromotion>;
    public static var READY:Bool = false;

    public var name:String;
    public var shortname:String;
    public var ean:String;
    public var pkg:String;
    public var comp:Bool;
    public var free:Bool;
    public var overlay:String;
    public var hitarea:Rectangle;
    public var imageurl:String;

    public function new() { }

    public static function initialize(preserve:Bool = false)
    {
        trace("initialize");
        if(!preserve)
        {
            GAMES = new Array<CrossPromotion>();
        }

        // load promotion games
        var path = Path.path();
        var cachefile = path + ".jigsawpromotions.json";
        var url = "http://files2.puzzleboss.com/jigsawpromotions.json?" + Math.random();
        var loader = new URLLoader();
        var path = Path.path();

        function complete(e:Event)
        {
            var json:Dynamic = null;

            try
            {
                json = haxe.Json.parse(loader.data);
            }
            catch(s:String)
            {
                return;
            }

            if(json == null)
            {
                return;
            }

            var games:Array<Dynamic> = Reflect.getProperty(json, Settings.VENDOR);
            var hitareas:Dynamic = Reflect.getProperty(json, "hitareas");
            var hitoverlays:Map<String, Rectangle> = null;

            #if nook
            var res = "1920x1200";
            var adjustx = Images.WIDTH / 1920;
            var adjusty = Images.HEIGHT / 1200;
            #else
            var res = "2560x1600";
            var adjustx = Images.SCALEX;//;Images.WIDTH / 2560;
            var adjusty = Images.SCALEY;//;Images.HEIGHT / 1600;
            #end

            if(Reflect.hasField(json, "hitareas"))
            {
                var resolution:Dynamic = Reflect.getProperty(json.hitareas, res);
                hitoverlays = new Map<String, Rectangle>();

                for(f in Reflect.fields(resolution))
                {
                    var obj = Reflect.getProperty(resolution, f);
                    var free = Reflect.getProperty(obj, "free").split(",");
                    var buy = Reflect.getProperty(obj, "buy").split(",");

                    var free = new Rectangle(free[0], free[1], free[2], free[3]);
                    free.x *= adjustx;
                    free.y *= adjusty;
                    free.width *= adjustx;
                    free.height *= adjusty;

                    var buy = new Rectangle(buy[0], buy[1], buy[2], buy[3]);
                    buy.x *= adjustx;
                    buy.y *= adjusty;
                    buy.width *= adjustx;
                    buy.height *= adjusty;

                    hitoverlays[f + "_free"] = free;
                    hitoverlays[f + "_buy"] = buy;
                }
            }

            GAMES = new Array<CrossPromotion>();

            for(gdata in games)
            {
                var cp = new CrossPromotion();
                cp.name = Reflect.getProperty(gdata, "name");
                cp.shortname = Reflect.getProperty(gdata, "shortname");

                #if nook
                cp.ean = Reflect.getProperty(gdata, "ean");
                #end

                cp.pkg = Reflect.getProperty(gdata, "package");
                cp.comp = Reflect.hasField(gdata, "comp") ? Reflect.getProperty(gdata, "comp") : false;
                cp.free = Reflect.hasField(gdata, "free") ? Reflect.getProperty(gdata, "free") : false;
                cp.overlay = Reflect.hasField(gdata, "overlay") ? Reflect.getProperty(gdata, "overlay") : null;
                cp.imageurl = Reflect.hasField(gdata, "imageurl") ? Reflect.getProperty(gdata, "imageurl") : null;

                trace(cp.imageurl);

                if(hitoverlays != null)
                {
                    cp.hitarea = hitoverlays[cp.overlay + (cp.free ? "_free" : "_buy")];
                }

                if(cp.imageurl != null)
                {
                    GAMES.push(cp);
                }
            }

            READY = true;
        }

        #if !flash
        if(FileSystem.exists(cachefile))
        {
            var cached = File.getContent(cachefile);
            var json = haxe.Json.parse(cached);
            var cdate = json.cached;
            var cnow = Timer.stamp();

            // cache for 3 days
            var diff = cnow - cdate;

            if(diff < 3 * 24 * 60 * 60)
            {
                loader.data = cached;
                complete(null);
                return;
            }
            else
            {
                FileSystem.deleteFile(cachefile);
            }
        }
        #end

        loader.addEventListener("diskError", ignore);
        loader.addEventListener("ioError", ignore);
        loader.addEventListener("networkError", ignore);
        loader.addEventListener("verifyError", ignore);
        loader.addEventListener("networkError", ignore);
        loader.addEventListener("verifyError", ignore);
        loader.addEventListener("securityError", ignore);
        loader.addEventListener("uncaughtError", ignore);
        loader.addEventListener("httpStatus", ignore);
        loader.addEventListener("complete", complete);
        loader.addEventListener("progress", progress);

        try
        {
            loader.load(new URLRequest(url));
        }
        catch(s:String)
        {
        }
    }

    private static function ignore(e:Event)
    {
    }

    private static function progress(e:ProgressEvent)
    {
    }

    public static function getGames(num:Int):Array<CrossPromotion>
    {
        trace("getGames", GAMES);

        if(GAMES == null || GAMES.length == 0)
        {
            return null;
        }

        var results = new Array<CrossPromotion>();

        shuffleArray();

        for(game in GAMES)
        {
            results.push(game);

            if(results.length == num)
            {
                return results;
            }
        }

        return results;
    }

    private static function finalizeResultArray(results:Array<CrossPromotion>, num:Int):Array<CrossPromotion>
    {
        // remove exccess
        while(results.length < num)
        {
            var first = results[Math.floor((Math.random() * results.length))];
            var second = results[Math.floor((Math.random() * results.length))];

            if(first == second)
            {
                continue;
            }

            results.remove(Math.random() < 0.5 ? first : second);
        }

        return results;
    }

    private static function shuffleArray()
    {
        ArraySort.sort(GAMES, function(a:CrossPromotion, b:CrossPromotion):Int
        {
            return Math.random() < 0.5 ? -1 : 1;
        });
    }
}
#end
