package com.edt.mobile.views.dailytest.toplist
{
	import mx.collections.XMLListCollection;
	

	[Bindable]
	public class DailyTestTopListModel
	{

		//da li je u toku ucitavanje
		public var isLoading:Boolean;

		//ukupno skupljenih poena
		public var isUserInTopList : Boolean;
		
		//koji je korisnik po redu
		public var orderNumber : int;
		
		//lista testova
		public var dataProvider : XMLListCollection;
		
		public function DailyTestTopListModel()
		{
		}
	}
}
