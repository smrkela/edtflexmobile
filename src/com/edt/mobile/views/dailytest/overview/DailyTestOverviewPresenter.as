package com.edt.mobile.views.dailytest.overview
{
	import com.edt.mobile.components.XAlertPopup;
	import com.edt.mobile.utils.BasePresenter;
	import com.edt.mobile.utils.ServiceCall;
	import com.edt.mobile.views.dailytest.list.DailyTestListView;
	import com.edt.mobile.views.dailytest.perform.DailyTestPerformView;
	import com.edt.mobile.views.dailytest.toplist.DailyTestTopListView;
	
	import mx.collections.XMLListCollection;
	import mx.rpc.events.FaultEvent;

	public class DailyTestOverviewPresenter extends BasePresenter
	{

		[Bindable]
		public var model:DailyTestOverviewModel=new DailyTestOverviewModel();

		public var view:DailyTestOverviewView;

		private var service:ServiceCall=new ServiceCall("rest/mobile/dailyTest/getDailyTestOverview", onDataLoaded, onFault);

		public function DailyTestOverviewPresenter()
		{
			super();
		}

		public function viewShown():void
		{

			model.isLoading = true;
			
			service.send();
		}

		private function onDataLoaded(result:XML):void
		{
			
			model.isLoading = false;
			
			model.isTodayTestDone = result.attribute("is-today-test-done") == "true";
			model.todayTestPoints = result.attribute("today-test-points");
			model.todayTestPosition = result.attribute("today-test-position");
			model.totalPointsEarned = result.attribute("total-points-earned");
			model.totalTests = result.attribute("total-tests");
			model.totalTestsDone = result.attribute("total-tests-done");
			model.currentPosition = result.attribute("current-position");
			model.totalTestUsers = result.attribute("total-test-users");
			model.totalTodayTestUsers = result.attribute("total-today-test-users");
			model.todayResults = new XMLListCollection(result.child('today-result'));
		}

		public function lessonClicked(data:XML):void
		{


		}
		
		public function allTestsClicked():void
		{

			pushView(DailyTestListView);
		}
		
		private function onFault(event : FaultEvent):void
		{
			
			model.isLoading = false;
			
			XAlertPopup.show(event);
			
		}
		
		public function topListClicked():void
		{

			pushView(DailyTestTopListView);
		}
		
		public function doTodayTest():void
		{

			pushView(DailyTestPerformView);
		}
	}
}
