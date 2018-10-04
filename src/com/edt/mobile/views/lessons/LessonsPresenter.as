package com.edt.mobile.views.lessons
{
	import com.edt.mobile.utils.BasePresenter;
	import com.edt.mobile.utils.ServiceCall;
	import com.edt.mobile.views.learning.LearningView;

	import mx.collections.XMLListCollection;

	public class LessonsPresenter extends BasePresenter
	{

		[Bindable]
		public var model:LessonsModel=new LessonsModel();

		public var view:LessonsView;

		private var service:ServiceCall=new ServiceCall("rest/statistics/loadLessons", onDataLoaded);

		public function LessonsPresenter()
		{
			super();
		}

		public function viewShown():void
		{
			
			
			model.groupId = view.data.groupId;
			model.groupName = view.data.groupName;
			model.type = view.data.type;
			model.isLearning = model.type == "learning";
			
			service.send({categoryId: model.groupId});
		}

		private function onDataLoaded(result:XML):void
		{

			model.lessons=new XMLListCollection(result.child("lesson"));

		}

		public function lessonClicked(data:XML):void
		{

			pushView(LearningView, {lessonId: data.@id, groupId: model.groupId, type: model.type});

		}
	}
}
