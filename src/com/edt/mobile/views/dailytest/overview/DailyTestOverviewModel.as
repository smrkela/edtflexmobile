package com.edt.mobile.views.dailytest.overview
{
	import mx.collections.XMLListCollection;
	

	[Bindable]
	public class DailyTestOverviewModel
	{

		//da li je u toku ucitavanje
		public var isLoading:Boolean;
		
		//da li je danasnji test uradjen ili ne
		public var isTodayTestDone : Boolean;
		
		//danasnja pozicija
		public var todayTestPosition : int;
		
		//koliko je korisnik ukupno testova uradio
		public var totalTestsDone : int;
		
		//koliko testova do danas ima ukupno
		public var totalTests : int;
		
		//koliko je ukupno poena skupio
		public var totalPointsEarned : int;
		
		//ako je uradio danasnji test, koliko je poena skupio
		public var todayTestPoints : int;
		
		//trenutna pozicija korisnika, 0 ako nije korisnik na listi
		public var currentPosition : int;
		
		//ukupno korisnika koji su polagali
		public var totalTestUsers : int;
		
		//ukupno korisnika koji su danas polagali test
		public var totalTodayTestUsers : int;
		
		//danasnji rezultati 
		public var todayResults : XMLListCollection;
		
		public function DailyTestOverviewModel()
		{
		}
	}
}
