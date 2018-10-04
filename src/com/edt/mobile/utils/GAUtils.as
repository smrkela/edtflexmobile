package com.edt.mobile.utils
{
	import com.google.analytics.GATracker;

	import mx.core.FlexGlobals;

	public class GAUtils
	{

		public static var PREFIX:String="mobile";

		private static var tracker:GATracker;

		public static function url(path:String):String
		{

			return PREFIX + "/" + path;
		}

		public static function getTracker():Object
		{

			return tracker;
		}

		public static function setup():void
		{

			var app:Object=FlexGlobals.topLevelApplication;

			if (!tracker)
				tracker=new GATracker(app.stage, Settings.GA_ACCOUNT, Settings.GA_MODE);

		}
		
		public static function trackPageview(param0:String):void
		{

			if(tracker)
				tracker.trackPageview(param0);
		}
	}
}
