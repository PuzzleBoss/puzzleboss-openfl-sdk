package puzzleboss;

import flash.events.Event;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;

/**
* ...
* @a.heightor Ben Lowry
*/
class TextButton extends ImageButton {
	public var label:Label;

	public function new(ptext:String, ponclick:Event->Void) {
		super("smallbutton", "smallbutton_over", ponclick);

		label = new Label(ptext, 14);
		addChild(label);

		if(upimg != null) {
			label.x = Math.floor((upimg.width - label.width) / 2);
			label.centerVertically(upimg.height);
		}
	}
}
