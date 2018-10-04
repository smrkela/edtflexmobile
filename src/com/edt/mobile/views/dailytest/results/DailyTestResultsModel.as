package com.edt.mobile.views.dailytest.results
{
	import com.evola.driving.model.Question;
	
	import mx.collections.ArrayCollection;
	

	[Bindable]
	public class DailyTestResultsModel
	{

		//da li je u toku ucitavanje
		public var isLoading:Boolean;
		
		//id testa za kojeg se gledaju rezultati
		public var testId : String;
		
		//id user-a za kojeg se gledaju rezultati
		public var userId : String;

		//lista pitanja
		public var questions : ArrayCollection;
		
		//index trenutnog pitanja
		public var currentIndex:int;
		
		//trenutno pitanje
		public var currentQuestion:Question;
		
		//datum testa
		public var date : Date;
		
		//string izraz za vreme
		public var timeTakenString : String;
		
		//broj tacnih odgovora
		public var correctAnswers : int;
		
		//broj netacnih odgovora
		public var incorrectAnswers : int;
		
		//da li su prikazani detalji ili samo overview
		public var isOverview : Boolean;
		
		//procenat tacnosti
		public var correctPercent : Number;
		
		//broj poena
		public var points : Number;
		
		public function DailyTestResultsModel()
		{
		}
	}
}
