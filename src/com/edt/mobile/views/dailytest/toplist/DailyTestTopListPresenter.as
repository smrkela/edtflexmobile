package com.edt.mobile.views.dailytest.toplist
{
	import com.edt.mobile.components.XAlertPopup;
	import com.edt.mobile.utils.BasePresenter;
	import com.edt.mobile.utils.ServiceCall;
	
	import mx.collections.XMLListCollection;
	import mx.rpc.events.FaultEvent;

	public class DailyTestTopListPresenter extends BasePresenter
	{

		[Bindable]
		public var model:DailyTestTopListModel=new DailyTestTopListModel();

		public var view:DailyTestTopListView;

		private var service:ServiceCall=new ServiceCall("rest/mobile/dailyTest/getTopList", onDataLoaded, onDataFault);

		public function DailyTestTopListPresenter()
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
			model.isUserInTopList = result.attribute("is-user-in-top-list");
			model.orderNumber = result.attribute("order-number");
			model.dataProvider = new XMLListCollection(result.child("user"));
		}

		private function onDataFault(event : FaultEvent):void
		{

			model.isLoading = false;
			
			XAlertPopup.show(event);
		}
		
		public function lessonClicked(data:XML):void
		{


		}
	}
}
