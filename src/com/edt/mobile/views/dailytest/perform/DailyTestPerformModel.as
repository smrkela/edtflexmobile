package com.edt.mobile.views.dailytest.perform
{
	import com.evola.driving.model.Question;
	
	import mx.collections.ListCollectionView;
	

	[Bindable]
	public class DailyTestPerformModel
	{

		//da li je u toku ucitavanje
		public var isLoading:Boolean;
		
		//pitanja
		public var questions : ListCollectionView;
		
		//trenutno pitanje
		public var currentQuestion : Question;
		
		//index trenutnog pitanja
		public var currentIndex : int;

		//da li je korisnik vec polagao trazeni test
		public var hasUserTakenTest : Boolean;
		
		//vreme pocetka testa
		public var startTime : Number;
		
		//id testa
		public var testId:Number;
		
		//datum testa
		public var date:Date;
		
		//da li je danasnji test
		public var isToday : Boolean;

		public function DailyTestPerformModel()
		{
		}
	}
}
