#if (!html5 && !flash)
package puzzleboss;

import flash.display.Sprite;
import flash.display.Loader;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Rectangle;
import flash.geom.Point;
import flash.events.Event;
import flash.net.URLRequest;
import flash.Lib;

class Promotion extends Sprite
{
    private var oncancel:Event->Void;
    public var onclose:Event->Void;
    private var image:Loader;
    private var game:CrossPromotion;
    private var _init:Bool = false;

    private static function preload():Promotion {
        var games = CrossPromotion.getGames(1);

        if(games == null || games.length == 0) {
            return null;
        }

        return new Promotion(games[0]);
    }

    public static function create(ponclose:Event->Void):Promotion {
        var promo = preload();

        if(promo == null) {
            return null;
        }

        promo.oncancel = ponclose;
        promo.onclose = ponclose;
        return promo;
    }

    public function new(pgame:CrossPromotion, ponclose:Event->Void = null) {
        if(pgame == null) {
            return;
        }

        super();
        game = pgame;
        onclose = ponclose;
        visible = false;

        image = new Loader();
        image.contentLoaderInfo.addEventListener("progress", ignore);
        image.contentLoaderInfo.addEventListener("diskError", cancelImage);
        image.contentLoaderInfo.addEventListener("ioError", cancelImage);
        image.contentLoaderInfo.addEventListener("networkError", cancelImage);
        image.contentLoaderInfo.addEventListener("verifyError", cancelImage);
        image.contentLoaderInfo.addEventListener("networkError", cancelImage);
        image.contentLoaderInfo.addEventListener("verifyError", cancelImage);
        image.contentLoaderInfo.addEventListener("securityError", cancelImage);
        image.contentLoaderInfo.addEventListener("uncaughtError", cancelImage);
        image.contentLoaderInfo.addEventListener("httpStatus", ignore);
        image.contentLoaderInfo.addEventListener("complete", setImage);
        image.load(new URLRequest(game.imageurl));
        addChild(image);

        var closebutton = new IconButton("icon_close", close);
        addChild(closebutton);
        closebutton.x = Images.WIDTH - closebutton.width - 20;
        closebutton.y = 20;

        addEventListener(Event.ADDED_TO_STAGE, init);
        addEventListener(Event.REMOVED_FROM_STAGE, dispose);
    }

    private function init(e:Event):Void {
        removeEventListener(Event.ADDED_TO_STAGE, init);
        Events.addUp(Lib.current.stage, open, true);
    }

    private function cancelImage(e:Event):Void {
        if(image == null) {
            return;
        }

        image.contentLoaderInfo.removeEventListener("progress", ignore);
        image.contentLoaderInfo.removeEventListener("diskError", cancelImage);
        image.contentLoaderInfo.removeEventListener("ioError", cancelImage);
        image.contentLoaderInfo.removeEventListener("networkError", cancelImage);
        image.contentLoaderInfo.removeEventListener("verifyError", cancelImage);
        image.contentLoaderInfo.removeEventListener("networkError", cancelImage);
        image.contentLoaderInfo.removeEventListener("verifyError", cancelImage);
        image.contentLoaderInfo.removeEventListener("securityError", cancelImage);
        image.contentLoaderInfo.removeEventListener("uncaughtError", cancelImage);
        image.contentLoaderInfo.removeEventListener("httpStatus", ignore);
        image.contentLoaderInfo.removeEventListener("complete", setImage);
        image = null;
    }

    private function ignore(e:Event):Void {
        if(parent == null) {
            dispose(e);
            return;
        }
    }

    private function setImage(e:Event):Void {
        if(image == null || image.content == null) {
            cancelPromotion();
            return;
        }

        if(parent == null) {
            dispose(e);
            return;
        }

        image.width = Images.WIDTH;
        image.height = Images.HEIGHT;
        ready();
    }

    private function cancelPromotion():Void {
        cancelImage(null);

        if(oncancel != null)
        {
            oncancel(null);
            oncancel = null;
        }

        close();
    }

    private function ready():Void {
        visible = true;
    }

    public function close(e:Event = null):Void {
        if(onclose != null) {
            onclose(null);
            onclose = null;
        }

        oncancel = null;

        if(parent != null) {
            parent.removeChild(this);
        }

        dispose(e);
    }

    private function open(e:Event):Void {
        if(!visible || parent == null) {
            return;
        }

        var sx:Float = Reflect.getProperty(e, "stageX");
        var sy:Float = Reflect.getProperty(e, "stageY");

        // close if we hit the top right 20% corner
        if(sx > Images.WIDTH * 0.8 && sy < Images.HEIGHT * 0.2) {
            close(e);
            return;
        }

        if(game == null) {
            return;
        }

        if(game.hitarea != null && !game.hitarea.containsPoint(new Point(sx, sy))) {
            return;
        }

        Analytics.track("/Promotion/open/" + game.pkg);
        AppLink.open(game.shortname, game.ean);
    }

    public function dispose(e:Event):Void {
        removeEventListener(Event.REMOVED_FROM_STAGE, dispose);
        removeEventListener(Event.ADDED_TO_STAGE, init);
        Events.removeUp(Lib.current.stage, open, true);
        cancelImage(e);
        image = null;
        oncancel = null;
        onclose = null;
        game = null;
    }
}

#end
