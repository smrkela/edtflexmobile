package com.edt.mobile.views.learning
{
	import com.edt.mobile.utils.BasePresenter;
	import com.edt.mobile.utils.ServiceCall;
	import com.evola.driving.Session;
	import com.edt.mobile.utils.Sounds;
	import com.edt.mobile.views.testresults.TestResultsView;
	import com.evola.driving.model.Question;
	import com.evola.driving.util.CommonsSettings;
	import com.evola.driving.util.ModelParser;
	import com.evola.driving.util.QuestionsParser;
	
	import flash.events.TimerEvent;
	import flash.events.TransformGestureEvent;
	import flash.utils.Timer;
	
	import spark.components.Image;

	public class LearningPresenter extends BasePresenter
	{

		[Bindable]
		public var model:LearningModel=new LearningModel();

		public var view:LearningView;

		private var service:ServiceCall=new ServiceCall("rest/question/getLessonQuestions", onQuestionsLoaded);
		private var serviceSaveLearning:ServiceCall=new ServiceCall("rest/statistics/saveLearning", onLearningSaveResult);
		private var serviceSaveTesting:ServiceCall=new ServiceCall("rest/statistics/saveTesting", onTestingSaveResult);

		private var _learningTimer:Timer;

		public function LearningPresenter()
		{
		}

		public function viewShown():void
		{

			model.groupId=view.data.groupId;
			model.lessonId=view.data.lessonId;
			model.type=view.data.type;
			model.isLearning=model.type == "learning";

			model.currentQuestion=null;

			Session.model.isUnconfirmed=true;

			if (model.isLearning)
				Session.model.startLearningSimple();
			else
				Session.model.startTestingSimple();

			service.send({groupId: model.groupId, lessonId: model.lessonId});

			CommonsSettings.testingSaveHandler=saveQuestionTestingStat;
		}

		//***********************************************

		private function onQuestionsLoaded(result:XML):void
		{

			model.groupId=result.attribute("group-id");
			model.groupName=result.attribute("group-name");
			model.lessonId=result.attribute("lesson-id");
			model.lessonName=result.attribute("lesson-name");
			model.removedQuestionsCount=result.attribute("removed-questions-count");

			model.questions=ModelParser.parseQuestions(result, Session.model);
			QuestionsParser.assignNumberOfCorrectAnswers(model.questions);

			if (model.questions.length > 0)
			{

				model.currentQuestion=model.questions.getItemAt(0) as Question;
				model.currentIndex=0;

				saveLearning();
			}
		}

		public function previousQuestionClicked():void
		{

			selectQuestion(-1);
		}

		public function nextQuestionClicked():void
		{

			Session.model.isUnconfirmed=true;

			selectQuestion(1);

			saveLearning();
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

			var isUpdate:Boolean=false;

			//ako smo vec sacuvali ovo pitanje u toku ove sesije onda radimo update
			if (question.id in Session.model.testingSavedQuestions)
				isUpdate=true;

			serviceSaveTesting.send({questionId: Session.model.selectedQuestion.id, isCorrect: question.isCorrectlyAnswered(), isUpdate: isUpdate, sessionUid: Session.model.testingSessionUID});
			//trace("SAVING TESTING...");

			Session.model.testingSavedQuestions[question.id]=question;
		}

		protected function onLearningSaveResult(xml:XML):void
		{

		}

		protected function onTestingSaveResult(xml:XML):void
		{

		}

		private function saveLearning():void
		{

			Session.model.selectedQuestion=model.currentQuestion;

			//sada treba da cuvamo informaciju o citanju pitanja
			if (!Session.model.isTestingMode)
			{

				saveQuestionLearning();
			}
		}

		private function saveQuestionLearning():void
		{

			if (!Session.model.selectedQuestion)
				return;

			//ako smo vec sacuvali ovo pitanje u toku ove sesije ne cuvamo ga opet
			if (Session.model.selectedQuestion.id in Session.model.learningSavedQuestions)
				return;

			//cuvamo ucenje pitanja samo ako ono traje duze od odredjenog vremena
			if (_learningTimer && _learningTimer.running)
				_learningTimer.reset();

			if (!_learningTimer)
			{

				_learningTimer=new Timer(1000, 1);
				_learningTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onLearningTimerComplete);
			}

			_learningTimer.start();
		}

		protected function onLearningTimerComplete(event:TimerEvent):void
		{

			//resetujemo timer da moze opet da se koristi
			_learningTimer.reset();

			if (!Session.model.selectedQuestion)
				return;

			serviceSaveLearning.send({questionId: Session.model.selectedQuestion.id, sessionUid: Session.model.learningSessionUID});
			//trace("SAVING LEARNING...");

			Session.model.learningSavedQuestions[Session.model.selectedQuestion.id]=Session.model.selectedQuestion;
		}

		public function finishLearningClicked():void
		{
			
			Sounds.playLearningFinish();

			view.navigator.backKeyUpHandler();
		}

		public function confirmQuestionClicked():void
		{

			Session.model.isUnconfirmed=false;

			if (model.currentQuestion.isCorrectlyAnswered())
				Sounds.playQuestionSuccess();
			else
				Sounds.playQuestionFailure();
		}

		public function finishClicked():void
		{

			Sounds.playTestingFinish();

			//belezimo rezultate testa
			var answeredQuestions:int=0;
			var correctlyAnswered:int=0;
			var incorrectlyAnswered:int=0;
			var unansweredQuestions:Array=[]; //of questions

			for each (var question:Question in model.questions)
			{

				if (question.isAnswered)
				{

					answeredQuestions++;

					if (question.isCorrectlyAnswered())
						correctlyAnswered++;
					else
						incorrectlyAnswered++;
				}
				else
				{

					unansweredQuestions.push(question);
				}
			}

			pushView(TestResultsView, {numberOfQuestions: model.questions.length, answeredQuestions: answeredQuestions, correctlyAnswered: correctlyAnswered, incorectlyAnswered: incorrectlyAnswered, lessonName: model.lessonName});
		}

		public function skipQuestionClicked():void
		{

			//ako preskacemo poslednje pitanje onda zavrsavamo test
			if (model.currentIndex == model.questions.length - 1)
			{

				finishClicked();
			}
			else
			{

				Session.model.isUnconfirmed=true;
				model.currentIndex++;
				model.currentQuestion=model.questions.getItemAt(model.currentIndex) as Question;
			}
		}

		public function questionsSwiped(event:TransformGestureEvent):void
		{
			
			//za sada otkazujemo swipe jer pravi problem kada se kristi u kombinaciji sa slikama u scrolleru
			if(true)
				return;
			
			//ako je radjen swipe preko slika a skrol postoji onda ne radimo swipe posto tada treba skrol da radi
			if(view.questionControl.imageScroller.visible && view.questionControl.imageScroller.horizontalScrollBar.visible){

				if(event.target is Image)
					return;
			}
			
			//swipe podrzavamo u dva slucaja:
			//1. u toku je ucenje
			//2. u toku je testiranje i korisnik je potvrdio odgovor i radi swipe u levo tj. ide na sledece pitanje

			var isNext:Boolean=event.offsetX < 0;
			var isPrevious:Boolean=event.offsetX > 0;

			if (model.isLearning)
			{

				if (isNext)
				{
					if (model.currentIndex != model.questions.length - 1)
						nextQuestionClicked();
					else
						finishLearningClicked();
				}
				else if (isPrevious)
				{
					previousQuestionClicked();
				}
			}
			else
			{

				//ako nije potvrdjen odgovor ne dozvoljavamo akciju
				if (Session.model.isUnconfirmed)
					return;

				//ako korisnik pokusava da se vrati ne dozvoljavamo akciju
				if (isPrevious)
					return;

				if (model.currentIndex != model.questions.length - 1)
					nextQuestionClicked();
				else
					finishClicked();
			}

		}
	}
}
