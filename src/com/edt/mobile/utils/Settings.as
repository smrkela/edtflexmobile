package com.edt.mobile.utils
{
	import com.google.analytics.v4.Configuration;

	[Bindable]
	public class Settings
	{

		public static var FORUM_MESSAGE_LIMIT:int = 1000;
		
		//da li je ovo demo aplikacija u razvoju, brojni view-ovi su unapred popunjeni zbog brzeg rada tokom razvoja
		public static var IS_DEMO:Boolean=false;

		public static var URL:String;
		public static var APPLICATION:String;
		public static var SERVER:String="http://localhost:8080/ROOT/";
		//public static var SERVER:String="http://192.168.1.103:8080/ROOT/";
		//public static var SERVER:String="http://www.vozacisrbije.com/";
		//public static var SERVER_URL:String="http://localhost/EDTService"; //"http://188.2.242.230:8080/EDTService";
		public static var SITE:String="http://www.vozacisrbije.com";
		public static var SITE_LOGIN:String="/uloguj-se";
		public static var SITE_FORUM:String="/forum";
		public static var EMAIL:String="office.vozacisrbije@gmail.com";

		//id user-a iz baze
		public static var userId:String;

		public static var learningOrderNumber:int=1; //1,2,3

		//google analytics podesavanja
		public static var GA_CONFIGURATION:Configuration;
		public static var GA_MODE:String="AS3";
		public static var GA_ACCOUNT:String="UA-43047679-1";

		//posebne captcha vrednosti koje dopustaju prolaz
		public static const ALLOWED_CHALLENGE:String="clkvjawefhzkjnvxcoipf";
		public static const ALLOWED_RESPONSE:String="soidj23-04i0sdifsdfjkj";

		public function Settings()
		{
		}

		public static function configure(settingsXML:XML):void
		{

			URL=settingsXML.child("url")[0].attribute("value");
			APPLICATION=settingsXML.child("application")[0].attribute("value");

			if (APPLICATION)
				SERVER="http://" + URL + "/" + APPLICATION;
			else
				SERVER="http://" + URL;

			SITE=URL;

			try
			{
				//site ne moramo imati
				SITE=settingsXML.child("site")[0].attribute("value");
			}
			catch (e:Error)
			{
			}

			try
			{
				//email ne moramo imati
				EMAIL=settingsXML.child("email")[0].attribute("value");
			}
			catch (e:Error)
			{
			}
		}
	}
}
