package puzzleboss;

import flash.display.DisplayObject;
import flash.events.MouseEvent;

#if (android || html5)
import flash.events.TouchEvent;
#end

/**
* ...
* @author Ben Lowry
*/
class Events {

	private static function addClick(obj:DisplayObject, f):Void {
		addEvent(MouseEvent.CLICK, obj, f);

		#if android
		//addEvent(TouchEvent.TOUCH_TAP, obj, f);
		#end
	}

	private static function removeClick(obj:DisplayObject, f):Void {
		removeEvent(MouseEvent.CLICK, obj, f);

		#if android
		//removeEvent(TouchEvent.TOUCH_TAP, obj, f);
		#end
	}

	public static function addUp(obj:DisplayObject, f, isclick:Bool):Void {
		#if !html5
		if(isclick) {
			addClick(obj, f);
			return;
		}
		#end

		addEvent(MouseEvent.MOUSE_UP, obj, f);

		#if android
		//addEvent(TouchEvent.TOUCH_END, obj, f);
		#end
	}

	public static function removeUp(obj:DisplayObject, f, isclick:Bool):Void {
		#if !html5
		if(isclick) {
			removeClick(obj, f);
			return;
		}
		#end

		removeEvent(MouseEvent.MOUSE_UP, obj, f);

		#if android
		//removeEvent(TouchEvent.TOUCH_END, obj, f);
		#end
	}

	public static function addDown(obj:DisplayObject, f):Void {
		addEvent(MouseEvent.MOUSE_DOWN, obj, f);

		#if android
		//addEvent(TouchEvent.TOUCH_BEGIN, obj, f);
		#end
	}

	public static function removeDown(obj:DisplayObject, f):Void {
		removeEvent(MouseEvent.MOUSE_DOWN, obj, f);

		#if android
		//removeEvent(TouchEvent.TOUCH_BEGIN, obj, f);
		#end
	}

	public static function addMove(obj:DisplayObject, f):Void {

		addEvent(MouseEvent.MOUSE_MOVE, obj, f);

		#if android
		//addEvent(TouchEvent.TOUCH_MOVE, obj, f);
		#end
	}

	public static function removeMove(obj:DisplayObject, f):Void {

		removeEvent(MouseEvent.MOUSE_MOVE, obj, f);

		#if android
		//removeEvent(TouchEvent.TOUCH_MOVE, obj, f);
		#end
	}

	public static function addOver(obj:DisplayObject, f):Void {
		addEvent(MouseEvent.MOUSE_OVER, obj, f);

		#if android
		//addEvent(TouchEvent.TOUCH_OVER, obj, f);
		#end
	}

	public static function removeOver(obj:DisplayObject, f):Void {
		removeEvent(MouseEvent.MOUSE_OVER, obj, f);

		#if android
		//removeEvent(TouchEvent.TOUCH_OVER, obj, f);
		#end
	}

	public static function addOut(obj:DisplayObject, f):Void {

		addEvent(MouseEvent.MOUSE_OUT, obj, f);

		#if android
		//addEvent(TouchEvent.TOUCH_OUT, obj, f);
		#end
	}

	public static function removeOut(obj:DisplayObject, f):Void {

		removeEvent(MouseEvent.MOUSE_OUT, obj, f);

		#if android
		//removeEvent(TouchEvent.TOUCH_OUT, obj, f);
		#end
	}

	private static function addEvent(ev:String, obj:DisplayObject, f):Void {
		if (obj == null)
		{
			return;
		}

		obj.addEventListener(ev, f);
	}

	private static function removeEvent(ev:String, obj:DisplayObject, f):Void {
		if (obj == null)
		{
			return;
		}

		obj.removeEventListener(ev, f);
	}
}
