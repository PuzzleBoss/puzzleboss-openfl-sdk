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
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.Event;

class IconButton extends Sprite {
	private var _icon:Bitmap;
	private var _onclick:Event->Void;

	public function new(picon:String, ponclick:Event->Void) {
		super();

		_icon = new Bitmap();
		Images.attach(picon, _icon);
		addChild(_icon);

		_onclick = ponclick;
		useHandCursor = true;
		mouseChildren = false;
		buttonMode = true;

		addEventListener(Event.REMOVED_FROM_STAGE, _onDispose);
		Events.addUp(this, _onclick, true);
	}

	private function _onDispose(e:Event) {
		Events.removeUp(this, _onclick, true);
		removeEventListener(Event.REMOVED_FROM_STAGE, _onDispose);
		_onclick = null;
	}
}
