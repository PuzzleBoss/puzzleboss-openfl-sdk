package puzzleboss;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.Lib;

/**
* ...
* @author Ben Lowry
*/
class ImageButton extends Sprite
{
	public var upimg:Bitmap;
	public var overimg:Bitmap;
	public var onclick:Event->Void;

	public function new(pup:String, pover:String, ponclick:Event->Void) {
		super();

		onclick = ponclick;
		mouseChildren = false;
		useHandCursor = true;
		buttonMode = true;

		if(pup != null) {
			upimg = new Bitmap();
			Images.loadBitmap(pup, upimg);
			upimg.smoothing = true;
			addChild(upimg);
		}

		if(pover != null) {
			overimg = new Bitmap();
			Images.loadBitmap(pover, overimg);
			overimg.visible = false;
			overimg.smoothing = true;
			addChild(overimg);
		}

		Events.addUp(this, click, true);
		Events.addDown(this, over);
		addEventListener(Event.REMOVED_FROM_STAGE, dispose, false);
	}

	private function over(e:Event):Void {
		if(upimg == null) {
			return;
		}

		upimg.visible = false;
		overimg.visible = true;
		Events.addUp(Lib.current.stage, out, false);
	}

	private function out(e:Event):Void {
		if(upimg == null) {
			return;
		}

		upimg.visible = true;
		overimg.visible = false;
		Events.removeUp(Lib.current.stage, out, false);
	}

	private function click(e:Event):Void {
		onclick(e);
	}

	private function dispose(e:Event):Void {
		removeEventListener(Event.REMOVED_FROM_STAGE, dispose);
		Events.removeUp(this, click, true);
		Events.removeOver(this, over);
		Events.removeOut(this, out);
		Events.removeDown(this, over);
		Events.removeUp(Lib.current.stage, out, false);
		onclick = null;
	}
}
