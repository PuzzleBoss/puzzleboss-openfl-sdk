package puzzleboss;

import flash.display.Sprite;
import flash.events.Event;
import flash.net.SharedObject;

class Rating extends Sprite
{
	public static function prompt(parent:Sprite):Bool {
		#if (flash || html5 || mac)
		return false;
		#end

		var so = SharedObject.getLocal("prompt");

		if (Reflect.hasField(so.data, "noprompt")) {
			return false;
		}

		parent.addChild(new Rating());
		return true;
	}

	public function new() {
		super();
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
		bar.graphics.drawRect(0, 0, Images.width, 160);
		bar.graphics.endFill();
		bar.x = 0;
		bar.y = 0;
		addChild(bar);

		var label = new Label("Rate this game", 20, false, null, 0xFFFFFF);
		addChild(label);

		var message = new Label("Ratings are really important and help us build our company!", 14);
		addChild(message);

		label.y = Math.floor((Images.height - label.height - 200) / 2);
		bar.y = label.y - 20;
		message.y = label.y + label.height + 10;

		var buttons = new Sprite();
		addChild(buttons);

		var updatebutton = new TextButton("Rate", _rate);
		buttons.addChild(updatebutton);

		var closebutton = new TextButton("No thanks", _close);
		closebutton.x = updatebutton.x + updatebutton.width + 50;
		buttons.addChild(closebutton);

		var neverbutton = new TextButton("Never", _never);
		neverbutton.x = closebutton.x + closebutton.width + 50;
		buttons.addChild(neverbutton);

		buttons.x = Math.floor((Images.width - buttons.width) / 2);
		buttons.y = message.y + message.height + 50;

		label.x = buttons.x;
		message.x = buttons.x;
	}

	private function _rate(e:Event) {
		AppLink.open(Settings.PACKAGE, Settings.EAN);
		never(e);
	}

	private function _never(e:Event) {
		var so = SharedObject.getLocal("prompt");
		so.data.noprompt = "true";
		so.flush();

		close(e);
	}

	private function _close(e:Event) {
		parent.removeChild(this);
	}

	private function _onDispose(e:Event) {
		removeEventListener(Event.ADDED_TO_STAGE, _onInit);
		removeEventListener(Event.REMOVED_FROM_STAGE, _onDispose);
	}
}
