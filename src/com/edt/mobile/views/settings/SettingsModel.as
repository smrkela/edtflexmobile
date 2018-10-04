package com.edt.mobile.views.settings
{
	import com.evola.driving.model.User;

	[Bindable]
	public class SettingsModel
	{
		
		//korisnik sa njegovim podacima
		public var user : User;
		
		public var isLoading : Boolean;
		
		//koji put se uci
		public var learningOrderNumber : int;
		
		public function SettingsModel()
		{
		}
	}
}