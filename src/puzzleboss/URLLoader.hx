package puzzleboss;

import flash.net.URLLoader;
import flash.events.Event;

class URLLoader extends flash.net.URLLoader {

	private var _complete:URLLoader->Void;

	public function new(pcomplete:URLLoader->Void) {
		super();
		_complete = pcomplete;
		addEventListener("ioError", _onIgnore);
		addEventListener("securityError", _onIgnore);
		addEventListener("uncaughtError", _onIgnore);
		addEventListener("httpStatus", _onIgnore);
		addEventListener("progress", _onIgnore);
		addEventListener("complete", _onComplete);
	}

	private function _onIgnore(e:Event) {
	}

	private function _onComplete(e:Event) {
		_complete(this);
		_complete = null;
		removeEventListener("ioError", _onIgnore);
		removeEventListener("securityError", _onIgnore);
		removeEventListener("uncaughtError", _onIgnore);
		removeEventListener("httpStatus", _onIgnore);
		removeEventListener("progress", _onIgnore);
		removeEventListener("complete", _onComplete);
	}
}
