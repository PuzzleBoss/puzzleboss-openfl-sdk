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
import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.MouseEvent;

class Events {

	public static function addClick(obj:DisplayObject, onWhatever:Event->Void) {
		_addEvent(MouseEvent.CLICK, obj, onWhatever);
	}

	public static function removeClick(obj:DisplayObject, onWhatever:Event->Void) {
		_removeEvent(MouseEvent.CLICK, obj, onWhatever);
	}

	public static function addUp(obj:DisplayObject, onWhatever:Event->Void, isclick:Bool) {
		#if !html5
		if (isclick) {
			addClick(obj, onWhatever);
			return;
		}
		#end

		_addEvent(MouseEvent.MOUSE_UP, obj, onWhatever);
	}

	public static function removeUp(obj:DisplayObject, onWhatever, isclick:Bool) {
		#if !html5
		if (isclick) {
			removeClick(obj, onWhatever);
			return;
		}
		#end

		_removeEvent(MouseEvent.MOUSE_UP, obj, onWhatever);
	}

	public static function addDown(obj:DisplayObject, onWhatever:Event->Void) {
		_addEvent(MouseEvent.MOUSE_DOWN, obj, onWhatever);
	}

	public static function removeDown(obj:DisplayObject, onWhatever:Event->Void) {
		_removeEvent(MouseEvent.MOUSE_DOWN, obj, onWhatever);
	}

	public static function addMove(obj:DisplayObject, onWhatever:Event->Void) {
		_addEvent(MouseEvent.MOUSE_MOVE, obj, onWhatever);
	}

	public static function removeMove(obj:DisplayObject, onWhatever:Event->Void) {
		_removeEvent(MouseEvent.MOUSE_MOVE, obj, onWhatever);
	}

	public static function addOver(obj:DisplayObject, onWhatever:Event->Void) {
		_addEvent(MouseEvent.MOUSE_OVER, obj, onWhatever);
	}

	public static function removeOver(obj:DisplayObject, onWhatever:Event->Void) {
		_removeEvent(MouseEvent.MOUSE_OVER, obj, onWhatever);
	}

	public static function addOut(obj:DisplayObject, onWhatever:Event->Void) {
		_addEvent(MouseEvent.MOUSE_OUT, obj, onWhatever);
	}

	public static function removeOut(obj:DisplayObject, onWhatever:Event->Void) {
		_removeEvent(MouseEvent.MOUSE_OUT, obj, onWhatever);
	}

	private static function _addEvent(ev:String, obj:DisplayObject, onWhatever:Event->Void) {
		if (obj == null) {
			return;
		}

		obj.addEventListener(ev, onWhatever);
	}

	private static function _removeEvent(ev:String, obj:DisplayObject, onWhatever:Event->Void) {
		if (obj == null) {
			return;
		}

		obj.removeEventListener(ev, onWhatever);
	}
}
