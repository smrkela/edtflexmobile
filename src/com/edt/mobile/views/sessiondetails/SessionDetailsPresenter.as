package com.edt.mobile.views.sessiondetails
{
	import com.edt.mobile.components.XAlertPopup;
	import com.edt.mobile.utils.BasePresenter;
	import com.edt.mobile.utils.ServiceCall;
	import com.evola.driving.util.DateUtils;
	import com.evola.driving.util.FormattingUtils;

	import mx.collections.XMLListCollection;
	import mx.rpc.events.FaultEvent;

	public class SessionDetailsPresenter extends BasePresenter
	{

		[Bindable]
		public var model:SessionDetailsModel=new SessionDetailsModel();

		public var view:SessionDetailsView;

		private var serviceLoadLearningSession:ServiceCall=new ServiceCall("rest/statistics/loadLearningSessionQuestions", onLearningSessionQuestionsLoaded, onDataFault);
		private var serviceLoadTestingSession:ServiceCall=new ServiceCall("rest/statistics/loadTestingSessionQuestions", onTestingSessionQuestionsLoaded, onDataFault);

		public function SessionDetailsPresenter()
		{
		}

		public function viewShown():void
		{

			model.sessionId=view.data.sessionId;
			model.isLearning=view.data.isLearning;
			model.isLoading=true;

			if (model.isLearning)
				serviceLoadLearningSession.send({sessionUid: model.sessionId});
			else
				serviceLoadTestingSession.send({sessionUid: model.sessionId});
		}

		//***********************************************

		protected function onLearningSessionQuestionsLoaded(result:XML):void
		{

			model.isLoading=false;

			var sessionXML:XML=result.child("learning-session")[0];

			model.title="Učena pitanja - " + DateUtils.formatDateExtended(FormattingUtils.parseJavaDateString(sessionXML.@start));
			model.dataProvider=new XMLListCollection(sessionXML.child("question-learn"));
		}

		protected function onTestingSessionQuestionsLoaded(result:XML):void
		{

			model.isLoading=false;

			var sessionXML:XML=result.child("testing-session")[0];

			model.title="Proverena pitanja - " + DateUtils.formatDateExtended(FormattingUtils.parseJavaDateString(sessionXML.@start));
			model.dataProvider=new XMLListCollection(sessionXML.child("question-test"));
		}

		private function onDataFault(event:FaultEvent):void
		{

			model.isLoading=false;

			XAlertPopup.show(event);
		}

	}
}
