package com.edt.mobile.views.toplists
{
	import com.edt.mobile.components.XAlertPopup;
	import com.edt.mobile.utils.BasePresenter;
	import com.edt.mobile.utils.ServiceCall;

	import mx.collections.XMLListCollection;
	import mx.rpc.events.FaultEvent;

	public class TopListsPresenter extends BasePresenter
	{

		[Bindable]
		public var model:TopListsModel=new TopListsModel();
		public var view:TopListsView;

		private var loadLeaderboard:ServiceCall=new ServiceCall("rest/statistics/loadLeaderboard", onLoadProgressResult, onLoadProgressFault);

		public function TopListsPresenter()
		{
		}

		public function viewShown():void
		{

			model.selectedSection=1;

			load();
		}

		private function onLoadProgressResult(result:XML):void
		{

			model.isLoading=false;

			model.results=new XMLListCollection(result.children());
		}

		private function onLoadProgressFault(event:FaultEvent):void
		{

			model.isLoading=false;

			XAlertPopup.show(event);
		}

		public function loadSection(section:int):void
		{

			//ako jos uvek traje ucitavanje onda ne dozvoljavamo novo kliktanje

			model.selectedSection=section;

			load();
		}

		private function load():void
		{

			model.isLoading=true;

			loadLeaderboard.send({typeId: model.selectedSection});
		}
	}
}
