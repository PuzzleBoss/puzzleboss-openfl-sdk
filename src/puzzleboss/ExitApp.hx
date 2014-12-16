/*
PuzzleBoss APIs and SDKs are licensed under the MIT license.  Certain
portions may come from 3rd parties and carry their own licensing
terms and are referenced where applicable.

https://github.com/puzzleboss/puzzleboss-openfl-sdk

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
IN THE SOFTWARE.
*/

package puzzleboss;
import flash.events.KeyboardEvent;
import flash.events.Event;
import flash.Lib;

#if android
import openfl.utils.JNI;
#end

class ExitApp {

	private static var _active:Bool = false;

	public static function enable() {
		_active = true;
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, _onBack);
	}

	public static function disable() {
		_active = false;
		Lib.current.stage.removeEventListener(KeyboardEvent.KEY_UP, _onBack);
	}

	public static function onExit(e:Event) {
		exit();
	}

	public static function exit() {
		#if android
		var sig = "com/puzzleboss/core/ExitApp";
		var exit = JNI.createStaticMethod(sig, "exitApp", "()V");
		exit();
		#else
		Lib.exit();
		#end
	}

	private static function _onBack(e:KeyboardEvent)
	{
		if (!_active || e.keyCode != KeyCodes.BACK) {
			return;
		}

		e.stopImmediatePropagation();
		exit();
	}
}
