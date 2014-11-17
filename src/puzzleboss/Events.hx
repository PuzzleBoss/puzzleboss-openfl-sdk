package puzzleboss;

import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.MouseEvent;

/**
* ...
* @author Ben Lowry
*/
class Events {

	private static function _addClick(obj:DisplayObject, onWhatever:Event->Void) {
		_addEvent(MouseEvent.CLICK, obj, onWhatever);
	}

	private static function _removeClick(obj:DisplayObject, onWhatever:Event->Void) {
		_removeEvent(MouseEvent.CLICK, obj, onWhatever);
	}

	public static function addUp(obj:DisplayObject, onWhatever:Event->Void, isclick:Bool) {
		#if !html5
		if (isclick) {
			_addClick(obj, onWhatever);
			return;
		}
		#end

		_addEvent(MouseEvent.MOUSE_UP, obj, onWhatever);
	}

	public static function removeUp(obj:DisplayObject, onWhatever, isclick:Bool) {
		#if !html5
		if (isclick) {
			_removeClick(obj, onWhatever);
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
