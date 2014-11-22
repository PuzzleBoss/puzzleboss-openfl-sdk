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
import googleAnalytics.Page;
import googleAnalytics.Visitor;
import googleAnalytics.Session;
import googleAnalytics.Tracker;

class Analytics {

	private static var _visitor:googleAnalytics.Visitor;
	private static var _session:googleAnalytics.Session;
	private static var _tracker:googleAnalytics.Tracker;

	/**
	* initialize prepares the analytics package with your tracking
	* code and player id
	*/
	public static function initialize() {

		// NB: you can add details to these two vars for the person
		// as a whole and their individual sessions within your app
		_visitor = new Visitor();
		_session = new Session();

		_tracker = new Tracker("UA-42445367-2", "puzzleboss.com");
	}

	/**
	* track will send a pageview to google analytics prefixed with
	* your 'action'.  It will append the information from your Settings.hx
	* to the url so you can segregate based on version, appstore etc.
	*
	* @param action your action, eg '/opened'
	*/
	public static function track(action:String) {

		if (_tracker == null) {
			initialize();
		}

		action = StringTools.replace("/" + action + "/", "//", "/");
		action += Settings.TYPE + "/";
		action += Settings.PACKAGE + "/";
		action += Settings.APP_STORE + "/";
		action += Settings.VERSION;

		_tracker.trackPageview(new Page(action), _session, _visitor);
	}
}
