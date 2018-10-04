package com.edt.mobile.views.dailytest.list
{
	import mx.collections.XMLListCollection;
	

	[Bindable]
	public class DailyTestListModel
	{

		//da li je u toku ucitavanje
		public var isLoading:Boolean;

		//ukupno skupljenih poena
		public var totalPoints : int;
		
		//ukupno odradjenih testova
		public var totalTests : int;
		
		//lista testova
		public var dataProvider : XMLListCollection = new XMLListCollection();

		//sacuvana stanja expandovanih meseci
		public var savedMonthStates:Object;
		
		public function DailyTestListModel()
		{
		}
	}
}
