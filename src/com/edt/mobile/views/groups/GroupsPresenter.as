package com.edt.mobile.views.groups
{
	import com.edt.mobile.utils.BasePresenter;
	import com.edt.mobile.utils.ServiceCall;
	import com.edt.mobile.views.lessons.LessonsView;

	import flash.events.MouseEvent;

	import mx.collections.XMLListCollection;

	public class GroupsPresenter extends BasePresenter
	{

		[Bindable]
		public var model:GroupsModel=new GroupsModel();

		public var view:GroupsView;

		private var service:ServiceCall=new ServiceCall("rest/statistics/loadGroups", onDataLoaded);

		public function GroupsPresenter()
		{
			super();
		}

		public function viewShown():void
		{
			
			model.type = view.data.type;
			model.isLearning = model.type == "learning";

			service.send();
		}

		private function onDataLoaded(result:XML):void
		{

			model.groups=new XMLListCollection(result.child("group"));

		}

		public function itemClicked(event:MouseEvent):void
		{

			var data:XML=event.currentTarget.data;
			var groupId:String=data.@id;
			var groupName:String=data.@title;

			pushView(LessonsView, {groupId: groupId, groupName: groupName, type: model.type});
		}
	}
}
