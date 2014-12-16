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
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.Event;
import flash.Lib;

class ImageButton extends Sprite {
	public var upimg:Bitmap;
	public var overimg:Bitmap;
	public var _onClick:Event->Void;

	public function new(pup:String, pover:String, ponclick:Event->Void) {
		super();

		_onClick = ponclick;
		mouseChildren = false;
		useHandCursor = true;
		buttonMode = true;

		if (pup != null) {
			upimg = new Bitmap();
			Images.attach(pup, upimg);
			upimg.smoothing = true;
			addChild(upimg);
		}

		if (pover != null) {
			overimg = new Bitmap();
			Images.attach(pover, overimg);
			overimg.visible = false;
			overimg.smoothing = true;
			addChild(overimg);
		}

		Events.addClick(this, _onClick);
		Events.addDown(this, _onOver);
		addEventListener(Event.REMOVED_FROM_STAGE, _onDispose, false);
	}

	private function _onOver(e:Event) {
		if (upimg == null) {
			return;
		}

		upimg.visible = false;
		overimg.visible = true;
		Events.addUp(Lib.current.stage, _onOut);
	}

	private function _onOut(e:Event) {
		if (upimg == null) {
			return;
		}

		upimg.visible = true;
		overimg.visible = false;
		Events.removeUp(Lib.current.stage, _onOut);
	}

	private function _onDispose(e:Event) {
		removeEventListener(Event.REMOVED_FROM_STAGE, _onDispose);
		Events.removeClick(this, _onClick);
		Events.removeOut(this, _onOut);
		Events.removeDown(this, _onOver);
		Events.removeUp(Lib.current.stage, _onOut);
		_onClick = null;
	}
}
