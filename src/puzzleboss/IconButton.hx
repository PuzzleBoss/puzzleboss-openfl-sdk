package puzzleboss;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.Event;

/**
* ...
* @author Ben Lowry
*/
class IconButton extends Sprite {
	private var _icon:Bitmap;
	private var _onclick:Event->Void;

	public function new(picon:String, ponclick:Event->Void) {
		super();

		_icon = new Bitmap();
		Images.attach(picon, _icon);
		addChild(_icon);

		_onclick = ponclick;
		useHandCursor = true;
		mouseChildren = false;
		buttonMode = true;

		addEventListener(Event.REMOVED_FROM_STAGE, _onDispose);
		Events.addUp(this, _onclick, true);
	}

	private function _onDispose(e:Event) {
		Events.removeUp(this, _onclick, true);
		removeEventListener(Event.REMOVED_FROM_STAGE, _onDispose);
		_onclick = null;
	}
}
