package com.edt.mobile.views.home
{
	import mx.collections.XMLListCollection;
	
	[Bindable]
	public class HomeModel
	{
		
		//osnovni podaci o korisniku
		public var email:String;
		public var userId : String;
		public var firstName : String;
		public var lastName : String;
		
		//podaci o iskustvu
		public var nextLevelPoints:Number;
		public var thisLevelPoints:Number;
		public var testedQuestions:Number;
		public var learnedQuestions:Number;
		public var experiencePoints:Number;
		public var currentProgress:Number;
		public var currentLevel:Number;
		
		//da li je u toku ucitavanje za test dana
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
		
		//id danasnjeg testa
		public var todayTestId:String;
		
		public function HomeModel()
		{
		}
	}
}