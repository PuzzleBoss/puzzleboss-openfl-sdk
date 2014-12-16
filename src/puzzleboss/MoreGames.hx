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
import flash.display.Bitmap;
import flash.events.Event;
import flash.geom.Rectangle;
import motion.Actuate;

class MoreGames extends Sprite {

	private var _promotions:Array<CrossPromotion> = null;
	private var _index:Int;
	private var _promo:Promotion = null;
	private var _prev:Sprite;
	private var _next:Sprite;
	private var _clickHandler:Event->Void;
	private var _closeButton:IconButton;

	public static function create(parent:Sprite, ponclose:Event->Void):MoreGames {

		if (CrossPromotion.ready) {
			var r = new MoreGames(ponclose);
			parent.addChild(r);
			return r;
		}

		return null;
	}

	public function new(ponclose:Event->Void) {
		super();
		scrollRect = new Rectangle(0, 0, Images.width, Images.height);
		_promotions = CrossPromotion.getGames(12);
		_clickHandler = ponclose;
		addEventListener(Event.ADDED_TO_STAGE, _onInit);
		addEventListener(Event.REMOVED_FROM_STAGE, _onDispose);
	}

	private function _onInit(e:Event) {
		removeEventListener(Event.ADDED_TO_STAGE, _onInit);
		_index = 0;

		var bg = new Sprite();
		bg.graphics.beginFill(0xFFFFFF);
		bg.graphics.drawRect(0, 0, Images.width, Images.height);
		bg.graphics.endFill();
		addChild(bg);

		// previous and _next buttons
		var pbmp = new Bitmap();
		Images.attach("prevnext", pbmp, true);

		_prev = new Sprite();
		_prev.addChild(pbmp);
		addChild(_prev);
		_prev.x = 20;
		_prev.y = Math.floor((Images.height - _prev.height) / 2);
		Events.addClick(_prev, _prevGame);

		var nbmp = new Bitmap();
		Images.attach("prevnext", nbmp);

		_next = new Sprite();
		_next.addChild(nbmp);
		addChild(_next);
		_next.x = Images.width - _next.width - 40;
		_next.y = _prev.y;
		Events.addClick(_next, _nextGame);

		_closeButton = new IconButton("icon_close", _onClose);
		addChild(_closeButton);
		_closeButton.x = Images.width - _closeButton.width - 20;
		_closeButton.y = 20;

		if (_promotions != null) {
			_refresh(null);
		}
	}

	private function _prevGame(e:Event) {
		if (_promotions == null) {
			return;
		}

		_index--;

		if (_index < 0) {
			_index = _promotions.length - 1;
		}

		_refresh(e);
	}

	private function _nextGame(e:Event) {
		if (_promotions == null) {
			return;
		}

		_index++;

		if (_index >= _promotions.length) {
			_index = 0;
		}

		_refresh(e);
	}

	private function _refresh(e:Event) {
		if (_promotions == null || _index >= _promotions.length) {
			return;
		}

		if (_promo != null && _promo.parent != null) {
			_promo.parent.removeChild(_promo);
			_promo = null;
		}

		_promo = new Promotion(_promotions[_index], _onClose);
		addChild(_promo);
		setChildIndex(_closeButton, numChildren - 1);
		setChildIndex(_next, numChildren - 1);
		setChildIndex(_prev, numChildren - 1);
	}

	private function _onClose(e:Event) {
		if (_clickHandler != null) {
			_clickHandler(e);
		}
	}

	private function _onDispose(e:Event) {
		removeEventListener(Event.ADDED_TO_STAGE, _onInit);
		removeEventListener(Event.REMOVED_FROM_STAGE, _onDispose);
		Events.removeClick(_next, _nextGame);
		Events.removeClick(_prev, _prevGame);
		_promotions = null;

		if (_promo != null && _promo.parent != null) {
			_promo.parent.removeChild(_promo);
			_promo = null;
		}
	}
}
