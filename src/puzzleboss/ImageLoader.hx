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
import flash.display.Loader;
import flash.events.Event;

class ImageLoader extends Loader {
	private var _complete:Event->Void;
	private var _fail:Event->Void;
	public var ready:Bool = false;

	public function new(pcomplete:Event->Void, pfail:Event->Void) {
		super();
		_complete = pcomplete;
		_fail = pfail;
		contentLoaderInfo.addEventListener("ioError", _onFail);
		contentLoaderInfo.addEventListener("securityError", _onFail);
		contentLoaderInfo.addEventListener("uncaughtError", _onFail);
		contentLoaderInfo.addEventListener("httpStatus", _onIgnore);
		contentLoaderInfo.addEventListener("progress", _onIgnore);
		contentLoaderInfo.addEventListener("complete", _onComplete);
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
		ready = true;
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
		contentLoaderInfo.removeEventListener("ioError", _onFail);
		contentLoaderInfo.removeEventListener("securityError", _onFail);
		contentLoaderInfo.removeEventListener("uncaughtError", _onFail);
		contentLoaderInfo.removeEventListener("httpStatus", _onIgnore);
		contentLoaderInfo.removeEventListener("progress", _onIgnore);
		contentLoaderInfo.removeEventListener("complete", _onComplete);
		removeEventListener(Event.REMOVED_FROM_STAGE, onDispose);
	}
}
