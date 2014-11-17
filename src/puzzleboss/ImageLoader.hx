package puzzleboss;

import flash.display.Loader;
import flash.events.Event;

class ImageLoader extends Loader {

	private var _complete:Event->Void;
	private var _fail:Event->Void;

	public function new(pcomplete:Event->Void, pfail:Event->Void) {
		super();
		_complete = pcomplete;
		_fail = pfail;
		addEventListener("ioError", _onFail);
		addEventListener("securityError", _onFail);
		addEventListener("uncaughtError", _onFail);
		addEventListener("httpStatus", _onIgnore);
		addEventListener("progress", _onIgnore);
		addEventListener("complete", _onComplete);

		addEventListener(Event.REMOVED_FROM_STAGE, onDispose);
	}

	private function _onIgnore(e:Event) {
	}

	private function _onComplete(e:Event) {
		if (_complete == null) {
			return;
		}
		_complete(e);
		onDispose(e);
	}

	private function _onFail(e:Event) {
		if (_fail == null) {
			return;
		}
		_fail(e);
		onDispose(e);
	}

	public function onDispose(e:Event) {
		_complete = null;
		_fail = null;
		removeEventListener("ioError", _onFail);
		removeEventListener("securityError", _onFail);
		removeEventListener("uncaughtError", _onFail);
		removeEventListener("httpStatus", _onIgnore);
		removeEventListener("progress", _onIgnore);
		removeEventListener("complete", _onComplete);
		removeEventListener(Event.REMOVED_FROM_STAGE, onDispose);
	}
}
