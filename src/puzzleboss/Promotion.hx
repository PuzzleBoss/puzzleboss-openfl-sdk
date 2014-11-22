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
import flash.display.Loader;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Rectangle;
import flash.geom.Point;
import flash.events.Event;
import flash.net.URLRequest;
import flash.Lib;

class Promotion extends Sprite {

	public var _close:Event->Void;
	private var _image:ImageLoader;
	private var _game:CrossPromotion;
	private var _init:Bool = false;

	public static function create(parent:Sprite, ponclose:Event->Void):Promotion {
		if (CrossPromotion.ready) {

			var games = CrossPromotion.getGames(1);

			if (games == null || games.length == 0) {
				return null;
			}

			var p = new Promotion(games[0], ponclose);
			parent.addChild(p);
			return p;
		}

		return null;
	}

	public function new(pgame:CrossPromotion, pclose:Event->Void = null) {
		if (pgame == null) {
			return;
		}

		super();
		_game = pgame;
		_close = pclose;

		_image = new ImageLoader(_setImage, _cancelImage);
		_image.load(new URLRequest(_game.imageurl));
		addChild(_image);

		var closebutton = new IconButton("icon_close", close);
		addChild(closebutton);
		closebutton.x = Images.width - closebutton.width - 20;
		closebutton.y = 20;

		addEventListener(Event.ADDED_TO_STAGE, _onInit);
		addEventListener(Event.REMOVED_FROM_STAGE, _onDispose);
	}

	private function _onInit(e:Event) {
		removeEventListener(Event.ADDED_TO_STAGE, _onInit);
		Events.addUp(Lib.current.stage, _onOpen, true);
	}

	private function _cancelImage(e:Event) {
		_image = null;
	}

	private function _setImage(e:Event) {

		// if the _image has loadaed after we disposed of this
		if (_image == null || _image.content == null || parent == null) {
			_cancelPromotion();
			return;
		}

		_image.width = Images.width;
		_image.height = Images.height;
	}

	private function _cancelPromotion(e:Event=null) {
		_cancelImage(null);
		close();
	}

	public function close(e:Event = null) {
		if (_close != null) {
			_close(null);
			_close = null;
		}

		if (parent != null) {
			parent.removeChild(this);
		}

		_onDispose(e);
	}

	private function _onOpen(e:Event) {
		if (parent == null || (_image == null || !_image.ready)) {
			return;
		}

		var sx:Float = Reflect.getProperty(e, "stageX");
		var sy:Float = Reflect.getProperty(e, "stageY");

		// close if we hit the top right 20% corner
		if (sx > Images.width * 0.8 && sy < Images.height * 0.2) {
			close(e);
			return;
		}

		// no _game
		if (_game == null) {
			return;
		}

		Analytics.track("/Promotion/open/" + _game.pkg);
		AppLink.open(_game.pkg, _game.ean);
	}

	public function _onDispose(e:Event) {
		removeEventListener(Event.REMOVED_FROM_STAGE, _onDispose);
		removeEventListener(Event.ADDED_TO_STAGE, _onInit);
		Events.removeUp(Lib.current.stage, _onOpen, true);
		_image = null;
		_close = null;
		_game = null;
	}
}
