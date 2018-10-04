package com.edt.mobile.views.dailytest.list
{
	import com.edt.mobile.components.XAlertPopup;
	import com.edt.mobile.utils.BasePresenter;
	import com.edt.mobile.utils.ServiceCall;
	import com.evola.driving.Session;
	import com.edt.mobile.views.dailytest.perform.DailyTestPerformView;
	import com.edt.mobile.views.dailytest.results.DailyTestResultsView;
	
	import mx.collections.XMLListCollection;
	import mx.rpc.events.FaultEvent;

	public class DailyTestListPresenter extends BasePresenter
	{

		[Bindable]
		public var model:DailyTestListModel=new DailyTestListModel();

		public var view:DailyTestListView;

		private var service:ServiceCall=new ServiceCall("rest/mobile/dailyTest/getTestsList", onDataLoaded, onDataFault);

		public function DailyTestListPresenter()
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
			model.totalPoints = result.attribute("total-points");
			model.totalTests = result.attribute("total-tests");
			
			//moramo prvo proci kroz mesece da bi postavili expanded/collapsed atribute po mesecima
			var months : XMLList = result.child("month");
			
			for(var i : int = 0; i<months.length(); i++){

				var month : XML = months[i];
				var isExpanded : Boolean = false;
				
				if(model.savedMonthStates){
					
					var key : String = month.@year+"-"+month.@month;
					
					if(model.savedMonthStates.hasOwnProperty(key))
						isExpanded = model.savedMonthStates[key];
				}
				else{
					
					isExpanded = i < 2;
				}
				
				var tests : XMLList =  month.child("test");
				//stavljamo i broj testova koje je korsinik uradio
				var numOfTestsTaken : int = tests.(attribute("has-user-taken-test") == "true").length();
				var totalTests : int = tests.length();
				
				month.attribute("is-expanded")[0] = isExpanded;
				month.attribute("tests-taken")[0] = numOfTestsTaken;
				month.attribute("total-tests")[0] = totalTests;
			}
			
			model.dataProvider = new XMLListCollection(months);
		}

		private function onDataFault(event : FaultEvent):void
		{

			model.isLoading = false;
			
			XAlertPopup.show(event);
		}
		
		public function performTest(testId : String):void
		{
			
			saveExpansionStates();

			pushView(DailyTestPerformView, {testId: testId});
		}
		
		public function viewTestResults(testId : String):void
		{
			
			saveExpansionStates();

			pushView(DailyTestResultsView, {testId: testId, userId: Session.model.user.id});
		}
		
		private function saveExpansionStates():void
		{

			//cuvamo is-expanded stanja meseci
			var states : Object = {};
			
			for each(var month : XML in model.dataProvider){
				
				var key : String = month.@year + "-"+month.@month;
				
				states[key] = month.attribute("is-expanded") == "true";
			}
			
			model.savedMonthStates = states;
		}
	}
}
