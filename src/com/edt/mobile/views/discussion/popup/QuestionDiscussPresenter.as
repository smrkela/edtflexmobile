package com.edt.mobile.views.discussion.popup
{
	import com.edt.mobile.components.XAlertPopup;
	import com.edt.mobile.components.XLoadingPopup;
	import com.edt.mobile.components.XNotificationPopup;
	import com.edt.mobile.utils.ServiceCall;
	import com.edt.mobile.utils.Settings;
	import com.edt.mobile.views.discussion.view.controls.PageEvent;
	import com.evola.driving.Session;
	import com.evola.driving.model.Question;
	import com.evola.driving.util.ModelParser;

	import flash.display.DisplayObject;
	import flash.events.MouseEvent;

	import mx.collections.XMLListCollection;
	import mx.core.FlexGlobals;
	import mx.managers.PopUpManager;
	import mx.rpc.events.FaultEvent;
	import mx.utils.StringUtil;

	[Bindable]
	public class QuestionDiscussPresenter
	{

		public var model:QuestionDiscussModel=new QuestionDiscussModel();
		public var view:QuestionDiscussPopup;

		private var serviceLoadMessages:ServiceCall=new ServiceCall("rest/question/getQuestionMessages", onLoadMessagesResult, loadMessagesFaultFunction);
		private var serviceSaveMessage:ServiceCall=new ServiceCall("rest/question/saveQuestionMessage", onSaveMessageResult, saveMessageFaultFunction);
		private var serviceDeleteMessage:ServiceCall=new ServiceCall("rest/question/deleteQuestionMessage", onDeleteMessageResult, deleteMessageFaultFunction);

		public function QuestionDiscussPresenter()
		{
		}

		public function initialize(question:Question, showLoadedQuestion:Boolean):void
		{

			model.question=question;
			model.messages=new XMLListCollection();
			model.isLoading=false;
			model.isWritingMessage=false;
			model.messageText="";
			model.deletedMessage=null;
			model.isSavingMessage=false;
			model.currentPageIndex=0;
			model.totalPages=0;
			model.loadedQuestion=null;
			model.showLoadedQuestion=showLoadedQuestion;

			PopUpManager.addPopUp(view, FlexGlobals.topLevelApplication as DisplayObject, true);

			positionAndSize();

			load(0);
		}

		private function load(pageIndex:int):void
		{

			XLoadingPopup.show("Učitavaju se pitanja...");

			model.isLoading=true;
			serviceLoadMessages.send({questionId: model.question.id, pageIndex: pageIndex});
		}

		public function close():void
		{

			if (model.isWritingMessage)
			{

				closeMessageWriting();
			}
			else
			{

				PopUpManager.removePopUp(view);
			}
		}

		public function saveMessage():void
		{

			var message:String=model.messageText;

			message=StringUtil.trim(message);

			if (!message)
			{

				XNotificationPopup.show("Unesi tekst pre čuvanja poruke.");
				return;
			}

			//poruka ne sme da ima vise od 2000 karaktera
			if (message.length > 2000)
			{

				XNotificationPopup.show("Poruka ne može da ima više od 2000 slova.");
				return
			}

			var parentMessageId:String=model.repliedMessage ? model.repliedMessage.@id : null;

			model.isSavingMessage=true;

			serviceSaveMessage.send({userId: Settings.userId, questionId: model.question.id, messageText: message, parentMessageId: parentMessageId});
		}

		public function cancelMessage():void
		{

			closeMessageWriting();
		}

		public function writeMessageClicked(event:MouseEvent):void
		{

			model.repliedMessage=null;
			model.isWritingMessage=true;

			view.txtMessage.setFocus();
		}

		public function replyMessageClicked(message:XML):void
		{

			model.repliedMessage=message;
			model.isWritingMessage=true;

			view.txtMessage.setFocus();
		}

		public function onSaveMessageResult(message:XML):void
		{

			//uspesno sacuvana poruka
			//treba da je dodamo medju ostale i zatvorimo editor

			model.messages.addItem(message);

			closeMessageWriting();

			model.isSavingMessage=false;

			//povecavamo broj poruka za ovo pitanje
			model.question.discussionCount++;
			model.totalMessages++;
		}

		public function onLoadMessagesResult(result:XML):void
		{

			model.isLoading=false;
			model.isAdministrator=result.attribute('is-administrator') == "true";
			model.currentPageIndex=result.attribute('current-page-index');
			model.totalPages=result.attribute('total-pages');
			model.pageSize=result.attribute('page-size');
			model.totalMessages=result.attribute('total-messages');

			model.messages=new XMLListCollection(result.child("question-message"));

			model.loadedQuestion=ModelParser.parseQuestion(result.child('question')[0], Session.model);

			XLoadingPopup.hide();
		}

		public function onDeleteMessageResult(result:XML):void
		{

			var index:int=model.messages.getItemIndex(model.deletedMessage);

			model.messages.removeItemAt(index);

			model.deletedMessage=null;

			model.question.discussionCount--;
			model.totalMessages--;
		}

		public function deleteMessageClicked(message:XML):void
		{

			model.deletedMessage=message;

			serviceDeleteMessage.send({questionMessageId: message.attribute('id')});
		}

		public function deleteMessageFaultFunction(event:FaultEvent):void
		{

			model.deletedMessage=null;

			XAlertPopup.show(event);
		}

		public function saveMessageFaultFunction(event:FaultEvent):void
		{

			model.isSavingMessage=false;

			XAlertPopup.show(event);
		}

		public function loadMessagesFaultFunction(event:FaultEvent):void
		{

			model.isLoading=false;

			XLoadingPopup.hide();
			XAlertPopup.show(event);
		}

		public function pageClicked(event:PageEvent):void
		{

			load(event.pageIndex);
		}

		public function positionAndSize():void
		{

			if (view && view.isPopUp)
			{

				var app:EDTFlexMobile=FlexGlobals.topLevelApplication as EDTFlexMobile;

				var width:Number=app.width * 0.98;
				var height:Number=app.height * 0.98;

				view.width=width;
				view.height=height;

				PopUpManager.centerPopUp(view);
			}
		}

		private function closeMessageWriting():void
		{

			model.isWritingMessage=false;
			model.messageText = "";

			if (view.stage)
				view.btn.setFocus();
		}


	}
}
