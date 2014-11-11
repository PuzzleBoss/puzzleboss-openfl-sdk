package puzzleboss;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.events.Event;
import openfl.Assets;

class LoaderAnim extends Sprite
{
    private var bmp:Bitmap;

    public function new()
    {
        super();
        addEventListener(Event.ADDED_TO_STAGE, init);
        addEventListener(Event.REMOVED_FROM_STAGE, dispose);
    }

    private function init(e:Event):Void
    {
        removeEventListener(Event.ADDED_TO_STAGE, init);

        bmp = new Bitmap();
        bmp.bitmapData = Assets.getBitmapData("images/loader.png");
        bmp.x = -(bmp.width / 2);
        bmp.y = -(bmp.height / 2);
        addChild(bmp);

        addEventListener(Event.ENTER_FRAME, tick);
    }

    private function tick(e:Event):Void
    {
        rotation++;
    }

    private function dispose(e:Event):Void
    {
        removeEventListener(Event.ADDED_TO_STAGE, init);
        removeEventListener(Event.REMOVED_FROM_STAGE, dispose);
        removeEventListener(Event.ENTER_FRAME, tick);
        bmp.bitmapData = null;
    }
}
