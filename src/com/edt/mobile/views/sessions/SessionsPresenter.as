package com.edt.mobile.views.sessions
{
	import com.edt.mobile.components.XAlertPopup;
	import com.edt.mobile.utils.BasePresenter;
	import com.edt.mobile.utils.ServiceCall;
	import com.edt.mobile.views.sessiondetails.SessionDetailsView;
	import com.evola.driving.util.SessionUtils;
	
	import mx.rpc.events.FaultEvent;

	public class SessionsPresenter extends BasePresenter
	{

		[Bindable]
		public var model:SessionsModel=new SessionsModel();

		public var view:SessionsView;

		private var serviceLoadLearningSessions:ServiceCall=new ServiceCall("rest/statistics/loadAllLearningSessions", onDataLoaded, onDataFault);
		
		private var serviceLoadTestingSessions:ServiceCall=new ServiceCall("rest/statistics/loadAllTestingSessions", onDataLoaded, onDataFault);

		public function SessionsPresenter()
		{
		}

		public function viewShown():void
		{

			model.type=view.data.type;
			model.isLearning=model.type == "learning";

			if (model.isLearning)
				serviceLoadLearningSessions.send();
			else
				serviceLoadTestingSessions.send();
			
			model.isLoading = true;
		}

		//***********************************************

		private function onDataLoaded(data:XML):void
		{
			
			model.isLoading = false;

			if (model.isLearning)
				model.sessions=SessionUtils.regroupSessions(data.child('learning-session'));
			else
				model.sessions=SessionUtils.regroupSessions(data.child('testing-session'));
			
			model.doneQuestions = SessionUtils.calculateAllSessions(model.sessions);
		}
		
		private function onDataFault(event : FaultEvent):void
		{

			model.isLoading = false;
			
			XAlertPopup.show(event);
		}

		public function sessionClicked(uid:Object):void
		{

			pushView(SessionDetailsView, {sessionId: uid, isLearning: model.isLearning});
		}
	}
}
