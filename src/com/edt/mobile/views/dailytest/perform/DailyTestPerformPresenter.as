package com.edt.mobile.views.dailytest.perform
{
	import com.edt.mobile.components.XAlertPopup;
	import com.edt.mobile.components.XLoadingPopup;
	import com.edt.mobile.components.XNotificationPopup;
	import com.edt.mobile.utils.BasePresenter;
	import com.edt.mobile.utils.ServiceCall;
	import com.evola.driving.Session;
	import com.edt.mobile.utils.Sounds;
	import com.edt.mobile.views.dailytest.results.DailyTestResultsView;
	import com.evola.driving.model.Question;
	import com.evola.driving.model.QuestionAnswer;
	import com.evola.driving.util.CommonsSettings;
	import com.evola.driving.util.FormattingUtils;
	import com.evola.driving.util.ModelParser;
	import com.evola.driving.util.QuestionsParser;

	import mx.rpc.events.FaultEvent;

	public class DailyTestPerformPresenter extends BasePresenter
	{

		[Bindable]
		public var model:DailyTestPerformModel=new DailyTestPerformModel();

		public var view:DailyTestPerformView;

		private var service:ServiceCall=new ServiceCall("rest/mobile/dailyTest/getQuestions", onDataLoaded, onDataFault);
		private var submitService:ServiceCall=new ServiceCall("rest/learning/submitDailyTest", onTestSubmitted, onTestSubmitFault, "post");

		public function DailyTestPerformPresenter()
		{
			super();
		}

		public function viewShown():void
		{

			model.isLoading=true;
			model.currentQuestion=null;

			Session.model.isUnconfirmed=true;
			Session.model.startTestingSimple();

			var testId:String=null;

			if (view.data && view.data.hasOwnProperty('testId'))
				testId=view.data['testId'];

			service.send({testId: testId});

			CommonsSettings.testingSaveHandler=saveQuestionTestingStat;
		}

		private function onDataLoaded(result:XML):void
		{

			model.isLoading=false;
			model.hasUserTakenTest=result.attribute("has-user-taken-test") == "true";
			model.startTime=result.attribute('start-time');
			model.testId=result.attribute('test-id');
			model.date=FormattingUtils.parseJavaDateString(result.attribute('date'));
			model.isToday=result.attribute('is-today') == "true";

			if (model.hasUserTakenTest)
			{

				XNotificationPopup.show("Već si polagao ovaj test, izaberi neki drugi test.");
				popView();
			}
			else
			{

				model.questions=ModelParser.parseQuestions(result, Session.model);

				QuestionsParser.assignNumberOfCorrectAnswers(model.questions);

				if (model.questions.length > 0)
				{

					model.currentQuestion=model.questions.getItemAt(0) as Question;
					model.currentIndex=0;
				}
			}
		}

		private function onDataFault(event:FaultEvent):void
		{

			model.isLoading=false;

			XAlertPopup.show(event);
		}

		public function confirmQuestionClicked():void
		{

			Session.model.isUnconfirmed=false;

			if (model.currentQuestion.isCorrectlyAnswered())
				Sounds.playQuestionSuccess();
			else
				Sounds.playQuestionFailure();
		}

		public function previousQuestionClicked():void
		{

			selectQuestion(-1);
		}

		public function nextQuestionClicked():void
		{
			Session.model.isUnconfirmed=true;

			selectQuestion(1);
		}

		public function finishClicked():void
		{

			Sounds.playTestingFinish();

			var dto:Object={};
			dto.questions=[];
			dto.startTime=model.startTime;
			dto.testId=model.testId;

			//belezimo rezultate testa
			var answeredQuestions:int=0;
			var correctlyAnswered:int=0;
			var incorrectlyAnswered:int=0;
			var unansweredQuestions:Array=[]; //of questions

			for each (var question:Question in model.questions)
			{

				var questionId:String=question.id;

				var questionDTO:Object={id: questionId, answers: []};

				dto.questions.push(questionDTO);

				for each (var answer:QuestionAnswer in question.answers)
				{

					if (answer.isUserSelected)
						questionDTO.answers.push(answer.id);
				}
			}

			submitService.contentType="application/json";
			submitService.headers={Accept: "application/json"};
			submitService.send(JSON.stringify(dto));

			XLoadingPopup.show("Obrađuju se rezultati...");
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

			//ne radimo cuvanje u bazi za test dana

			Session.model.testingSavedQuestions[question.id]=question;
		}

		private function onTestSubmitted(result:XML):void
		{

			XLoadingPopup.hide();

			popView();
			pushView(DailyTestResultsView, {testId: model.testId, userId: Session.model.user.id});
		}

		private function onTestSubmitFault(event:FaultEvent):void
		{

			XLoadingPopup.hide();

			XAlertPopup.show(event);
		}
	}
}
