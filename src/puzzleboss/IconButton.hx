package puzzleboss;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.Event;

/**
* ...
* @author Ben Lowry
*/
class IconButton extends Sprite
{
	private var icon1:Bitmap;
	private var onclick1:Event->Void;
	private var icon2:Bitmap;
	private var onclick2:Event->Void;
	private var active:Bitmap;
	private var activeonclick:Event->Void;
	public var origX:Int;
	public var origY:Int;

	public function new(picon:String, ponclick:Event->Void, picon2:String=null, ponclick2:Event->Void=null) {
		super();

		// icon 1
		icon1 = new Bitmap();
		Images.loadBitmap(picon, icon1);
		addChild(icon1);
		onclick1 = ponclick;

		// icon 2
		if(picon2 != null) {
			icon2 = new Bitmap();
			Images.loadBitmap(picon2, icon2);
			addChild(icon2);

			onclick2 = ponclick2;
			icon2.visible = false;
		}

		// active icon
		swap(1);
		useHandCursor = true;
		mouseChildren = false;
		buttonMode = true;
		addEventListener(Event.REMOVED_FROM_STAGE, dispose);
		Events.addUp(this, click, true);
	}

	public function swap(n:Int = 0):Void {
		// single purpose
		if(icon2 == null)
		{
			active = icon1;
			activeonclick = onclick1;
			icon1.visible = true;
			return;
		}

		// swap
		if(n == 0) {
			active = active == icon1 ? icon2 : icon1;
			activeonclick = active == icon1 ? onclick1 : onclick2;
			icon1.visible = active == icon1;
			icon2.visible = active == icon2;
			return;
		}

		// set
		if(n == 1) {
			active = icon1;
			activeonclick = onclick1;
			icon1.visible = true;
			icon2.visible = false;
			return;
		}

		if(n == 2) {
			active = icon2;
			activeonclick = onclick2;
			icon1.visible = false;
			icon2.visible = true;
		}
	}

	private function click(e:Event) {
		var i1 = icon1 != null && !icon1.visible;
		var i2 = icon2 != null && !icon2.visible;

		if(active == null || !active.visible || alpha == 0)
		{
			return;
		}

		activeonclick(e);
		e.stopImmediatePropagation();
	}

	private function dispose(e:Event) {
		Events.removeUp(this, click, true);
		removeEventListener(Event.REMOVED_FROM_STAGE, dispose);
		onclick1 = null;
		onclick2 = null;
		activeonclick = null;
	}
}
