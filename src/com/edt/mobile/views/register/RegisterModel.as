package com.edt.mobile.views.register
{
	[Bindable]
	public class RegisterModel
	{
		//ime korisnika
		public var firstName : String;
		
		//prezime korisnike
		public var lastName :String;
		
		//korisnicko ime
		public var username : String;
		
		//sifra
		public var password : String;
		
		//email
		public var email : String;
		
		//da li je muski pol
		public var isMale : Boolean;
		
		public function RegisterModel()
		{
		}
	}
}