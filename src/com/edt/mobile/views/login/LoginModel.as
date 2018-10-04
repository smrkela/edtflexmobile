package com.edt.mobile.views.login
{
	[Bindable]
	public class LoginModel
	{
		//poruka koja se ispisuje u slucaju login greske
		public var loginMessage : String;
		
		//korisnicko ime
		public var username : String;
		
		//sifra
		public var password : String;
		
		//da li je remember me zapamceno
		public var isRememberMe : Boolean;
		
		public function LoginModel()
		{
		}
	}
}