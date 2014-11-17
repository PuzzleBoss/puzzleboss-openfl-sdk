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
