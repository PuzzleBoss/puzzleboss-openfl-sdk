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
import flash.display.Sprite;
import flash.events.Event;
import flash.net.SharedObject;

class Rating extends Sprite {

	private var _clickHandler:Event->Void;
	private var _support:Support;

	public static function create(parent:Sprite, ponclose:Event->Void):Rating {
		#if (flash || html5 || mac)
		return null;
		#end

		var so = SharedObject.getLocal("prompt");

		if (Reflect.hasField(so.data, "noprompt")) {
			return null;
		}

		var r = new Rating(ponclose);
		parent.addChild(r);
		return r;
	}

	public function new(ponclose:Event->Void) {
		super();
		_clickHandler = ponclose;
		addEventListener(Event.ADDED_TO_STAGE, _onInit);
		addEventListener(Event.REMOVED_FROM_STAGE, _onDispose);
	}

	private function _onInit(e:Event) {
		removeEventListener(Event.ADDED_TO_STAGE, _onInit);

		var bg = new Sprite();
		bg.graphics.beginFill(0x000000, 0.85);
		bg.graphics.drawRect(0, 0, Images.width, Images.height);
		bg.graphics.endFill();
		bg.x = 0;
		bg.y = 0;
		addChild(bg);

		var bar = new Sprite();
		bar.graphics.beginFill(0x000000, 0.5);
		bar.graphics.drawRect(0, 0, Images.width, 200);
		bar.graphics.endFill();
		bar.x = 0;
		bar.y = 0;
		addChild(bar);

		var container = new Sprite();
		addChild(container);

		var label = new Label("Rate this game", 20, false, null, 0xFFFFFF);
		container.addChild(label);

		var message = new Label("If you're enjoying this app please leave us a rating!", 14);
		message.y = label.height + (20 * Images.scaleY);
		container.addChild(message);

		var buttons = new Sprite();
		buttons.y = message.y + message.height + (20 * Images.scaleY);
		container.addChild(buttons);

		var updatebutton = new TextButton("Rate", _onRate);
		buttons.addChild(updatebutton);

		var closebutton = new TextButton("No thanks", _onClose);
		closebutton.x = updatebutton.x + updatebutton.width + (20 * Images.scaleX);
		buttons.addChild(closebutton);

		var neverbutton = new TextButton("Never", _onNever);
		neverbutton.x = closebutton.x + closebutton.width + (20 * Images.scaleX);
		buttons.addChild(neverbutton);

		var supportbutton = new TextButton(Language.get("Support"), _openSupport);
		supportbutton.x = neverbutton.x + neverbutton.width + (20 * Images.scaleX);
		buttons.addChild(supportbutton);

		bar.height = container.height + (40 * Images.scaleY);
		bar.y = Math.floor((Images.height - bar.height) / 2);
		container.y = bar.y + (20 * Images.scaleY);
		container.x = Math.floor((Images.width - container.width) / 2);
	}

	private function _openSupport(e:Event) {
		_support = new Support(_closeSupport);
		addChild(_support);
	}

	private function _closeSupport(e:Event) {
		removeChild(_support);
		_support = null;
	}

	private function _onRate(e:Event) {
		AppLink.open(Settings.PACKAGE, Settings.EAN);
		_onNever(e);
	}

	private function _onNever(e:Event) {
		var so = SharedObject.getLocal("prompt");
		so.data.noprompt = "true";
		so.flush();
		_onClose(e);
	}

	private function _onClose(e:Event) {
		if (_clickHandler != null) {
			_clickHandler(e);
		}
	}

	private function _onDispose(e:Event) {
		removeEventListener(Event.ADDED_TO_STAGE, _onInit);
		removeEventListener(Event.REMOVED_FROM_STAGE, _onDispose);
		_clickHandler = null;
	}
}
