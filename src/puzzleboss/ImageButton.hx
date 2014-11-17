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
	public var _onClick:Event->Void;

	public function new(pup:String, pover:String, ponclick:Event->Void) {
		super();

		onclick = ponclick;
		mouseChildren = false;
		useHandCursor = true;
		buttonMode = true;

		if (pup != null) {
			upimg = new Bitmap();
			Images.loadBitmap(pup, upimg);
			upimg.smoothing = true;
			addChild(upimg);
		}

		if (pover != null) {
			overimg = new Bitmap();
			Images.loadBitmap(pover, overimg);
			overimg.visible = false;
			overimg.smoothing = true;
			addChild(overimg);
		}

		Events.addUp(this, _onClick, true);
		Events.addDown(this, _onOver);
		addEventListener(Event.REMOVED_FROM_STAGE, _onDispose, false);
	}

	private function _onOver(e:Event) {
		if (upimg == null) {
			return;
		}

		upimg.visible = false;
		overimg.visible = true;
		Events.addUp(Lib.current.stage, _onOut, false);
	}

	private function _onOut(e:Event) {
		if (upimg == null) {
			return;
		}

		upimg.visible = true;
		overimg.visible = false;
		Events.removeUp(Lib.current.stage, out, false);
	}

	private function _onDispose(e:Event) {
		removeEventListener(Event.REMOVED_FROM_STAGE, _onDispose);
		Events.removeUp(this, _onClick, true);
		Events.removeOut(this, _onOut);
		Events.removeDown(this, _onOver);
		Events.removeUp(Lib.current.stage, out, false);
		_onClick = null;
	}
}
