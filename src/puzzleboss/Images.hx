package puzzleboss;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.geom.Rectangle;
import flash.geom.Matrix;
import flash.events.Event;
import openfl.Assets;
import flash.Lib;
import Lambda;

class Images {
    private static var CACHE:Map<String, BitmapData> = null;
    public static var WIDTH:Int;
    public static var HEIGHT:Int;
    public static var SCALEX:Float;
    public static var SCALEY:Float;
    private static var TARGETWIDTH:Int = 2560;
    private static var TARGETHEIGHT:Int = 1600;

    public static function initialize():Void {

        if(CACHE == null) {
            CACHE = new Map<String, BitmapData>();
        }

        WIDTH = Lib.current.stage.stageWidth;
        HEIGHT = Lib.current.stage.stageHeight;
        SCALEX = WIDTH / TARGETWIDTH;
        SCALEY = HEIGHT / TARGETHEIGHT;
    }

    public static function loadBitmap(image:String, parent:DisplayObject, flipped:Bool = false):Void {
        var img = load(image);

        if(flipped) {
            img = flip(img);
        }

        if(Std.is(parent, Bitmap)) {
            cast(parent, Bitmap).bitmapData = img;
        }
        else if(Std.is(parent, Sprite)) {
            cast(parent, Sprite).addChild(new Bitmap(img));
        }
    }

    public static function load(image:String):BitmapData {
        var key = "images." + image;

        if(image.indexOf(".") == -1) {
            image += ".png";
        }

        if(CACHE[key] == null) {
            var bmp = Assets.getBitmapData("images/" + image, false);

            if(image != "playstore" && image != "amazonstore" && (SCALEX != 1 || SCALEY != 1)) {
                bmp = resize(bmp, SCALEX);
            }

            CACHE[key] = bmp;
        }

        return CACHE[key];
    }

    static function resize(pic:BitmapData, scale:Float = 0, width:Int = 0, height:Int = 0, basewidth:Int = 0, baseheight:Int = 0):BitmapData {
        var scaled:BitmapData;

        // just cropping off the bottom or right
        if(width == pic.width || height == pic.height) {
            return pic;
        }

        if(basewidth == 0) {
            basewidth = scale > 0 ? Std.int(pic.width * scale) : pic.width;
        }

        if(baseheight == 0) {
            baseheight = scale > 0 ? Std.int(pic.height * scale) : pic.height;
        }

        // resizing
        var matrix = new Matrix();

        if(scale == 0) {
            matrix.scale(width / basewidth, height / baseheight);
        }
        else {
            matrix.scale(scale, scale);
        }

        if(basewidth == 0) {
            basewidth = WIDTH;
        }

        if(baseheight == 0) {
            baseheight = HEIGHT;
        }

        var pw:Int = Std.int(Math.ceil(pic.width * matrix.a));
        var ph:Int = Std.int(Math.ceil(pic.height * matrix.d));

        if(width > 0 && width != pw) {
            pw = width;
        }

        if(height > 0 && height != ph) {
            ph = height;
        }

        matrix.identity();
        matrix.scale(pw / pic.width, ph / pic.height);

        scaled = new BitmapData(pw, ph, true, 0x00000000);
        scaled.draw(pic, matrix);

        if(width == 0 && height == 0) {
            return scaled;
        }

        // cropping
        if(width > 0 && scaled.width > width) {
            return crop(scaled, new Rectangle(Math.ceil((scaled.width - width) / 2), 0, width, scaled.height));
        }

        if(height > 0 && scaled.height > height) {
            return crop(scaled, new Rectangle(0, Math.ceil((scaled.height - height) / 2), scaled.width, height));
        }

        return scaled;
    }

    private static function crop(pic:BitmapData, rect:Rectangle):BitmapData {
        var cropped = new BitmapData(Std.int(rect.width), Std.int(rect.height));
        cropped.draw(pic);
        return cropped;
    }

    private static function flip(b:BitmapData):BitmapData {
        var m = new Matrix( -1, 0, 0, 1, b.width, 0);
        var b2 = new BitmapData(b.width, b.height, true, 0x00000000);
        b2.draw(b, m);
        return b2;
    }
}