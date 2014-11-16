#if android
package puzzleboss;

import flash.display.Sprite;
import flash.display.DisplayObject;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.Lib;
import motion.Actuate;

/**
* ...
* @author Ben Lowry
*/
class MoreGames extends Sprite
{
	private var promotions:Array<CrossPromotion> = null;
	private var index:Int;
	private var promo:Promotion = null;
	private var prev:Sprite;
	private var next:Sprite;
	private var onclose:Event->Void;

	public function new(ponclose:Event->Void) {

		super();
		scrollRect = new Rectangle(0, 0, Images.WIDTH, Images.HEIGHT);
		promotions = CrossPromotion.getGames(12);
		onclose = ponclose;
		addEventListener(Event.ADDED_TO_STAGE, init);
		addEventListener(Event.REMOVED_FROM_STAGE, dispose);
	}

	private function init(e:Event):Void {
		removeEventListener(Event.ADDED_TO_STAGE, init);
		index = 0;

		var bg = new Sprite();
		bg.graphics.beginFill(0xFFFFFF);
		bg.graphics.drawRect(0, 0, Images.WIDTH, Images.HEIGHT);
		bg.graphics.endFill();
		addChild(bg);

		var loader = new LoaderAnim();
		loader.x = Math.floor(Images.WIDTH / 2);
		loader.y = Math.floor(Images.HEIGHT / 2);
		addChild(loader);

		// previous and next buttons
		var pbmp = new Bitmap();
		Images.loadBitmap("prevnext", pbmp, true);
		prev = new Sprite();
		prev.addChild(pbmp);
		addChild(prev);
		prev.x = 20;
		prev.y = Math.floor((Images.HEIGHT - prev.height) / 2) - (prev.height / 2) + (300 * Images.SCALEY);
		Events.addUp(prev, prevGame, true);

		var nbmp = new Bitmap();
		Images.loadBitmap("prevnext", nbmp);
		next = new Sprite();
		next.addChild(nbmp);
		addChild(next);
		next.x = Images.WIDTH - next.width - 40;
		next.y = prev.y;
		Events.addUp(next, nextGame, true);

		if(promotions != null)
		{
			refresh(null);
		}
	}

	private function prevGame(e:Event):Void {
		index--;

		if(index < 0) {
			index = promotions.length - 1;
		}

		refresh(e);
	}

	private function nextGame(e:Event):Void {
		index++;

		if(index >= promotions.length) {
			index = 0;
		}

		refresh(e);
	}

	private function refresh(e:Event):Void {
		if(promotions == null || index >= promotions.length) {
			return;
		}

		if(promo != null && promo.parent != null) {
			promo.parent.removeChild(promo);
			promo = null;
		}

		promo = new Promotion(promotions[index], close);
		addChildAt(promo, 2);
	}

	private function close(e:Event):Void {
		onclose(e);
	}

	private function dispose(e:Event):Void {
		removeEventListener(Event.ADDED_TO_STAGE, init);
		removeEventListener(Event.REMOVED_FROM_STAGE, dispose);
		Events.removeUp(next, nextGame, true);
		Events.removeUp(prev, prevGame, true);

 		promotions = null;

		if(promo != null && promo.parent != null) {
			promo.parent.removeChild(promo);
			promo = null;
		}
	}
}
#end
