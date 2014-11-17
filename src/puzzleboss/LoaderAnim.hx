package puzzleboss;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.events.Event;
import openfl.Assets;

class LoaderAnim extends Sprite {

	private var _bmp:Bitmap;

	public function new() {
		super();
		addEventListener(Event.ADDED_TO_STAGE, _onInit);
		addEventListener(Event.REMOVED_FROM_STAGE, _onDispose);
	}

	private function _onInit(e:Event) {
		removeEventListener(Event.ADDED_TO_STAGE, _onInit);

		_bmp = new Bitmap();
		addChild(_bmp);
		Images.attach("loader", _bmp);
		_bmp.x = -(_bmp.width / 2);
		_bmp.y = -(_bmp.height / 2);

		addEventListener(Event.ENTER_FRAME, _onTick);
	}

	private function _onTick(e:Event) {
		rotation++;
	}

	private function _onDispose(e:Event) {
		removeEventListener(Event.ADDED_TO_STAGE, _onInit);
		removeEventListener(Event.REMOVED_FROM_STAGE, _onDispose);
		removeEventListener(Event.ENTER_FRAME, _onTick);
		_bmp.bitmapData = null;
	}
}
