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
import flash.geom.Rectangle;
import flash.geom.Point;
import flash.events.Event;
import flash.net.URLRequest;

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

		addEventListener(Event.ADDED_TO_STAGE, _onInit);
		addEventListener(Event.REMOVED_FROM_STAGE, _onDispose);
	}

	private function _onInit(e:Event) {

		removeEventListener(Event.ADDED_TO_STAGE, _onInit);

		graphics.beginFill(0xFFFFFF, 1);
		graphics.drawRect(0, 0, Images.width, Images.height);
		graphics.endFill();

		var loader = new LoaderAnim();
		loader.x = Math.floor(Images.width / 2);
		loader.y = Math.floor(Images.height / 2);
		addChild(loader);

		_image = new ImageLoader(_setImage, _cancelImage);
		_image.load(new URLRequest(_game.imageurl));
		addChild(_image);

		var closebutton = new IconButton("icon_close", close);
		addChild(closebutton);
		closebutton.x = Images.width - closebutton.width - 20;
		closebutton.y = 20;

		Events.addClick(this, _onOpen);
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

		if (parent == null || (_image == null || !_image.ready) || e.target != _image) {
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

		var sp = new Point(sx, sy);

		// which link
		if (_game.amazonRect != null && _game.amazonRect.containsPoint(sp)) {
			AppLink.amazon(_game.amazonPackage);
			Analytics.track("/Promotion/open/amazon/" + _game.amazonPackage);
		}

		if (_game.googleRect != null && _game.googleRect.containsPoint(sp)) {
			AppLink.google(_game.googlePackage);
			Analytics.track("/Promotion/open/google/" + _game.googlePackage);
		}

		if (_game.nookRect != null && _game.nookRect.containsPoint(sp)) {
			AppLink.nook(_game.nookEAN);
			Analytics.track("/Promotion/open/nook/" + _game.nookEAN);
		}

		if (_game.itunesRect != null && _game.itunesRect.containsPoint(sp)) {
			AppLink.link(_game.itunesURL);
			Analytics.track("/Promotion/open/itunes/" + _game.itunesURL);
		}
	}

	public function _onDispose(e:Event) {
		removeEventListener(Event.REMOVED_FROM_STAGE, _onDispose);
		removeEventListener(Event.ADDED_TO_STAGE, _onInit);
		Events.removeClick(this, _onOpen);
		_image = null;
		_close = null;
		_game = null;
	}
}
