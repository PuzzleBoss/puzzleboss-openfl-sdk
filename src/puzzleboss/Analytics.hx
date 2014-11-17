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
		action += Settings.VENDOR + "/";
		action += Settings.VERSION;

		_tracker.trackPageview(new Page(action), _session, _visitor);
	}
}
