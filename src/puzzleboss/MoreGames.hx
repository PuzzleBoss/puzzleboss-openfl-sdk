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
import flash.display.BitmapData;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.Lib;
import motion.Actuate;

class MoreGames extends Sprite {

	private var promotions:Array<CrossPromotion> = null;
	private var index:Int;
	private var promo:Promotion = null;
	private var prev:Sprite;
	private var next:Sprite;
	private var onclose:Event->Void;

	public static function create(parent:Sprite, ponclose:Event->Void):Bool {

		if(CrossPromotion.ready) {
			parent.addChild(new MoreGames(ponclose));
			return true;
		}

		return false;
	}

	public function new(ponclose:Event->Void) {
		super();
		scrollRect = new Rectangle(0, 0, Images.width, Images.height);
		promotions = CrossPromotion.getGames(12);
		onclose = ponclose;
		addEventListener(Event.ADDED_TO_STAGE, init);
		addEventListener(Event.REMOVED_FROM_STAGE, dispose);
	}

	private function init(e:Event) {
		removeEventListener(Event.ADDED_TO_STAGE, init);
		index = 0;

		var bg = new Sprite();
		bg.graphics.beginFill(0xFFFFFF);
		bg.graphics.drawRect(0, 0, Images.width, Images.height);
		bg.graphics.endFill();
		addChild(bg);

		var loader = new LoaderAnim();
		loader.x = Math.floor(Images.width / 2);
		loader.y = Math.floor(Images.height / 2);
		addChild(loader);

		// previous and next buttons
		var pbmp = new Bitmap();
		Images.attach("prevnext", pbmp, true);

		prev = new Sprite();
		prev.addChild(pbmp);
		addChild(prev);
		prev.x = 20;
		prev.y = Math.floor((Images.height - prev.height) / 2);
		Events.addUp(prev, prevGame, true);

		var nbmp = new Bitmap();
		Images.attach("prevnext", nbmp);

		next = new Sprite();
		next.addChild(nbmp);
		addChild(next);
		next.x = Images.width - next.width - 40;
		next.y = prev.y;
		Events.addUp(next, nextGame, true);

		if (promotions != null)
		{
			refresh(null);
		}
	}

	private function prevGame(e:Event) {

		if (promotions == null) {
			return;
		}

		index--;

		if (index < 0) {
			index = promotions.length - 1;
		}

		refresh(e);
	}

	private function nextGame(e:Event) {

		if (promotions == null) {
			return;
		}

		index++;

		if (index >= promotions.length) {
			index = 0;
		}

		refresh(e);
	}

	private function refresh(e:Event) {

		if (promotions == null || index >= promotions.length) {
			return;
		}

		if (promo != null && promo.parent != null) {
			promo.parent.removeChild(promo);
			promo = null;
		}

		promo = new Promotion(promotions[index], close);
		addChildAt(promo, 2);
	}

	private function close(e:Event) {
		onclose(e);
	}

	private function dispose(e:Event) {
		removeEventListener(Event.ADDED_TO_STAGE, init);
		removeEventListener(Event.REMOVED_FROM_STAGE, dispose);
		Events.removeUp(next, nextGame, true);
		Events.removeUp(prev, prevGame, true);

		promotions = null;

		if (promo != null && promo.parent != null) {
			promo.parent.removeChild(promo);
			promo = null;
		}
	}
}
