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
import flash.display.DisplayObject;
import flash.events.Event;
import flash.geom.Rectangle;
import motion.Actuate;
#if android
import openfl.utils.JNI;
#end

class Support extends Sprite {
	private var _note:Label;
	private var _clickHandler:Event->Void;

	public function new(ponclose:Event->Void) {
		super();
		_clickHandler = ponclose;
		scrollRect = new Rectangle(0, 0, Images.width, Images.height);
		addEventListener(Event.ADDED_TO_STAGE, _onInit);
		addEventListener(Event.REMOVED_FROM_STAGE, _onDispose);

		graphics.beginFill(0x000000, 0.75);
		graphics.drawRect(0, 0, Images.width, Images.height);
		graphics.endFill();
	}

	private function _onInit(e:Event) {
		removeEventListener(Event.ADDED_TO_STAGE, _onInit);

		var container = new Sprite();
		addChild(container);

		var label = new Label("PuzzleBoss support: support@puzzleboss.com", 30);
		label.x = 10;
		label.y = 10;
		container.addChild(label);

		var label2 = new Label("If you email from your computer please include this information,\n" +
		"it will automatically be included if you press 'Send email'.  Support\n" +
		"available in English only!\n\n" +
		"Uninstalling the app and then downloading again often fixes problems.", 20);
		label2.x = 10;
		label2.y = label.y + label.height + 16;
		container.addChild(label2);

		var data = _getJNIData();
		data.push("Screen resolution: " + Images.width + "x" + Images.height);
		data.push("Game: " + Settings.NAME);
		data.push("Store: " + Settings.APP_STORE);
		data.push("Version: " + Settings.VERSION);

		_note = new Label(data.join("\n"), 14);
		_note.x = label.x;
		_note.y = label2.y + label2.height + 20;
		container.addChild(_note);

		container.x = Math.floor((Images.width - container.width) / 2);
		container.y = Math.floor((Images.height - container.height) / 2);

		var buttons = new Sprite();
		addChild(buttons);

		var homeButton = new TextButton("Back", _onClose);
		buttons.addChild(homeButton);

		var emailButton = new TextButton("Send email", _sendMail);
		emailButton.x = homeButton.x + homeButton.width + 20;
		buttons.addChild(emailButton);

		buttons.x = Math.floor((Images.width - buttons.width) / 2);
		buttons.y = Images.height - buttons.height - 20;
	}

	private function _sendMail(e:Event) {
		var send = JNI.createStaticMethod("com/puzzleboss/core/Support", "sendEmail", "(Ljava/lang/String;)V");
		send(_note.text);
	}

	private static function _getJNIData():Array<String> {
		var data:Array<String> = [];
		var jni = "com/puzzleboss/core/Support";
		var getOS = JNI.createStaticMethod(jni, "getOS", "()Ljava/lang/String;");
		var getAPILevel = JNI.createStaticMethod(jni, "getAPILevel", "()Ljava/lang/String;");
		var getDevice = JNI.createStaticMethod(jni, "getDevice", "()Ljava/lang/String;");
		var getModel = JNI.createStaticMethod(jni, "getModel", "()Ljava/lang/String;");
		var getProduct = JNI.createStaticMethod(jni, "getProduct", "()Ljava/lang/String;");

		var os:String = getOS();
		if (os.indexOf("-") > -1) {
			os = os.substr(0, os.indexOf("-"));
		}

		data.push("OS: " + os);
		data.push("API Level: " + getAPILevel());
		data.push("Device: " + getDevice());
		//data.push("Model: " + getModel());
		//data.push("Product: " + getProduct());
		return data;
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
