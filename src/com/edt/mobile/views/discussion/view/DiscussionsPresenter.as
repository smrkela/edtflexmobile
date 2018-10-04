package com.edt.mobile.views.discussion.view
{
	import com.edt.mobile.utils.BasePresenter;
	import com.edt.mobile.utils.ServiceCall;
	import com.edt.mobile.utils.ServiceUtils;
	import com.edt.mobile.views.discussion.popup.QuestionDiscussPopup;
	import com.edt.mobile.views.discussion.view.controls.PageEvent;
	import com.evola.driving.model.Question;
	
	import mx.collections.XMLListCollection;
	import mx.events.ItemClickEvent;
	import mx.rpc.events.FaultEvent;

	[Bindable]
	public class DiscussionsPresenter extends BasePresenter
	{

		[Bindable]
		public var model:DiscussionsModel=new DiscussionsModel();
		public var view:DiscussionsView;

		private var serviceLoadMyDiscussions:ServiceCall=new ServiceCall("rest/question/getMyQuestionMessages", onMyDiscussionsLoaded, onLoadFault, "get");
		private var serviceLoadAllDiscussions:ServiceCall=new ServiceCall("rest/question/getAllQuestionMessages", onAllDiscussionsLoaded, onLoadFault, "get");

		public function DiscussionsPresenter()
		{
		}

		public function viewInitialized():void
		{

			if (!model.mode)
				model.mode="my";

			load();
		}

		private function load():void
		{

			model.isLoading = true;
			model.noMessages = false;
			
			if (model.mode == "my")
			{

				model.myDiscussionMessages=new XMLListCollection();
				serviceLoadMyDiscussions.send({startPage: model.currentLoadingIndex});
			}
			else
			{

				model.allDiscussionMessages=new XMLListCollection();
				serviceLoadAllDiscussions.send({startPage: model.currentLoadingIndex});
			}
		}

		public function onMyDiscussionsLoaded(result:XML):void
		{

			model.myDiscussionsTotalPages=result.attribute('total-pages');
			model.pageSize=result.attribute('page-size');
			model.myDiscussionsStartPageIndex=model.currentLoadingIndex;

			model.myDiscussionMessages=new XMLListCollection(result.child('question-message'));
			
			model.noMessages = model.myDiscussionMessages.length == 0; 
			model.isLoading = false;
		}

		public function onAllDiscussionsLoaded(result:XML):void
		{

			model.allDiscussionsTotalPages=result.attribute('total-pages');
			model.pageSize=result.attribute('page-size');
			model.allDiscussionsStartPageIndex=model.currentLoadingIndex;

			model.allDiscussionMessages=new XMLListCollection(result.child('question-message'));
			
			model.noMessages = model.allDiscussionMessages.length == 0;
			model.isLoading = false;
		}

		public function messageClicked(message:XML):void
		{

			var question:Question=new Question();
			question.id=message.attribute('question-id');
			question.text=message.attribute('question-text');

			QuestionDiscussPopup.init(question, true);
		}

		public function pageChangeClicked(event:PageEvent):void
		{

			var index:int=event.pageIndex;
			var currentIndex:int;

			if (model.mode == "my")
				currentIndex=model.myDiscussionsStartPageIndex;
			else
				currentIndex=model.allDiscussionsStartPageIndex;

			if (index != currentIndex)
			{

				model.currentLoadingIndex=index;
				load();
			}
		}

		public function refresh():void
		{

			load();
		}

		public function myDiscussionsClicked():void
		{
			model.mode="my";
			model.currentLoadingIndex=model.myDiscussionsStartPageIndex;
			
			load();
		}

		public function allDiscussionsClicked():void
		{
			model.mode="all";
			model.currentLoadingIndex=model.allDiscussionsStartPageIndex;
			
			load();
		}

		private function onLoadFault(event:FaultEvent):void
		{

			ServiceUtils.manageFault(event, "Greška tokom učitavanja.");
			
			model.isLoading = false;
		}
	}
}
