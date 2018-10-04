package com.edt.mobile.views.dailytest.results
{
	import com.edt.mobile.components.XAlertPopup;
	import com.edt.mobile.utils.BasePresenter;
	import com.edt.mobile.utils.ServiceCall;
	import com.evola.driving.Session;
	import com.evola.driving.model.Question;
	import com.evola.driving.model.QuestionAnswer;
	import com.evola.driving.util.CommonsSettings;
	import com.evola.driving.util.DateUtils;
	import com.evola.driving.util.FormattingUtils;
	import com.evola.driving.util.ModelParser;
	import com.evola.driving.util.QuestionsParser;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.events.FaultEvent;

	public class DailyTestResultsPresenter extends BasePresenter
	{

		[Bindable]
		public var model:DailyTestResultsModel=new DailyTestResultsModel();

		public var view:DailyTestResultsView;

		private var service:ServiceCall=new ServiceCall("rest/mobile/dailyTest/getResults", onDataLoaded, onDataFault);

		public function DailyTestResultsPresenter()
		{
			super();
		}

		public function viewShown():void
		{

			model.isLoading=true;
			model.isOverview = true;

			var testId:String=view.data.testId;
			var userId:String=view.data.userId;

			service.send({testId: testId, userId: userId});
			
			CommonsSettings.testingSaveHandler=saveQuestionTestingStat;
		}

		private function onDataLoaded(result:XML):void
		{

			model.isLoading=false;

			var resultQuestions:XMLList=result.child("result-question");

			var questions:ArrayCollection=new ArrayCollection();

			for each (var rq:XML in resultQuestions)
			{

				var question:Question=ModelParser.parseQuestion(rq.child("question")[0], Session.model);

				QuestionsParser.assignNumberOfCorrectAnswersForQuestion(question);
				
				questions.addItem(question);
				
				//moramo rucno ubaciti odgovore korisnika
				var answers : XMLList = rq.child("answer");
				
				for each(var answerXML : XML in answers){
					
					var answerId : String = answerXML.attribute("id");
					
					var answer : QuestionAnswer = question.getAnswer(answerId);
					
					if(question.isMultiSelect)
						answer.isUserSelected = true;
					else
						question.setUserAnswer(answer);
				}
			}

			model.questions=questions;

			if (model.questions.length > 0)
			{

				model.currentQuestion=model.questions.getItemAt(0) as Question;
				model.currentIndex=0;
			}
			
			var userResult : XML = result.child("user-result")[0];
			
			model.correctAnswers = userResult.attribute("correct-answers");
			model.incorrectAnswers = userResult.attribute("wrong-answers");
			model.correctPercent = userResult.attribute("correct-percent");
			model.timeTakenString = userResult.attribute("time-taken-string");
			model.date = FormattingUtils.parseJavaDateString(result.attribute("date"));
			model.points = userResult.attribute("points");
			
			Session.model.isUnconfirmed=false;
		}

		private function onDataFault(event:FaultEvent):void
		{

			model.isLoading=false;

			XAlertPopup.show(event);
		}

		public function previousQuestionClicked():void
		{

			selectQuestion(-1);
		}

		public function nextQuestionClicked():void
		{
			Session.model.isUnconfirmed=false;

			selectQuestion(1);
		}

		public function finishClicked():void
		{

			popView();
		}

		private function selectQuestion(delta:int):void
		{

			var index:int=model.questions.getItemIndex(model.currentQuestion);

			index+=delta;

			if (model.questions.length == index)
				index=index - 1;
			else if (index < 0)
				index=0;

			model.currentQuestion=model.questions.getItemAt(index) as Question;
			model.currentIndex=index;
		}
		
		public function saveQuestionTestingStat(question:Question):void
		{
			
			if (!question)
				return;
			
			//ne radimo cuvanje u bazi za rezultate testa dana
			
			//Session.model.testingSavedQuestions[question.id]=question;
		}
		
		public function showOverviewClicked():void
		{

			model.isOverview = true;
		}
		
		public function showDetailsClicked():void
		{

			model.isOverview = false;
		}
	}
}
