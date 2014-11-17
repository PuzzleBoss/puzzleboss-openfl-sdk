package puzzleboss;

import flash.events.KeyboardEvent;
import flash.Lib;

import openfl.utils.JNI;

class ExitApp {

	private static var _active:Bool = false;

	public static function enable():Void {
		_active = true;
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, _onBack);
	}

	public static function disable():Void {
		_active = false;
		Lib.current.stage.removeEventListener(KeyboardEvent.KEY_UP, _onBack);
	}

	public static function exit() {

		if(!_active) {
			return;
		}

		var sig = "com/puzzleboss/core/ExitApp";
		var exit = JNI.createStaticMethod(sig, "exitApp", "()V");
		exit();
	}

	private function _onBack(e:KeyboardEvent)
	{
		if(e.keyCode != KeyCodes.BACK) {
			return;
		}

		e.stopImmediatePropagation();
		exit();
	}
}
