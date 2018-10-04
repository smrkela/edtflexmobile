package com.edt.mobile.views.settings
{
	import com.edt.mobile.components.XAlertPopup;
	import com.edt.mobile.components.XNotificationPopup;
	import com.edt.mobile.utils.BasePresenter;
	import com.edt.mobile.utils.LocalDataStorage;
	import com.edt.mobile.utils.ServiceCall;
	import com.evola.driving.Session;
	import com.edt.mobile.utils.Settings;
	import com.evola.driving.model.DrivingCategory;
	import com.evola.driving.model.User;
	import com.evola.driving.util.DrivingUtils;

	import mx.collections.ArrayCollection;
	import mx.rpc.events.FaultEvent;
	import mx.utils.StringUtil;

	public class SettingsPresenter extends BasePresenter
	{

		[Bindable]
		public var model:SettingsModel=new SettingsModel();
		public var view:SettingsView;

		private var loadUserService:ServiceCall=new ServiceCall("rest/user/loadUser", onUserLoaded, onFault);
		private var saveUserService:ServiceCall=new ServiceCall("rest/user/updateUser", onUserUpdated, onFault);

		public function SettingsPresenter()
		{
		}

		public function viewShown():void
		{

			model.isLoading=true;
			model.learningOrderNumber=Settings.learningOrderNumber;

			loadUserService.send({userId: Session.model.user.id});
		}

		protected function onUserLoaded(result:XML):void
		{

			model.isLoading=false;

			var user:User=User.createFromXML(result.user[0]);
			var categories:ArrayCollection=new ArrayCollection();

			for each (var dcXML:XML in result.child("driving-category"))
			{

				categories.addItem(DrivingCategory.createFromXML(dcXML));
			}

			var playSounds:Boolean=LocalDataStorage.getLocalBoolean("playSounds", true);

			view.tiFirstName.text=user.firstName;
			view.tiLastName.text=user.lastName;
			view.tiEmail.text=user.email;
			view.rbgSex.selectedValue=user.isMale;
			//cmbQuestionsPerPage.selectedItem=user.questionsPerPage;
			view.cmbDrivignCategory.dataProvider=categories;
			view.cmbDrivignCategory.selectedItem=DrivingUtils.getBaseEntity(categories, user.drivingCategory);
			view.rbgSounds.selectedValue=playSounds;
		}

		protected function onUserUpdated(result:XML):void
		{

			var user:User=User.createFromXML(result.user[0]);

			Session.model.user=user;

			popView();
		}
		
		public function showLearningNumberNotiication(num:int):void
		{
			
			XNotificationPopup.show("Svi podaci o napretku biće prikazivani za " + num + ". krug učenja i provere.");
		}

		public function updateClicked():void
		{

			var firstName:String=view.tiFirstName.text;
			var lastName:String=view.tiLastName.text;
			var email:String=view.tiEmail.text; //email ne menjamo uopste
			var isMale:Boolean=view.rbgSex.selectedValue;
			var questionsPerPage:int=10; //int(cmbQuestionsPerPage.text);
			var drivingCategoryId:String=view.cmbDrivignCategory.selectedItem ? view.cmbDrivignCategory.selectedItem.id : null;

			if (!questionsPerPage)
				questionsPerPage=20;

			firstName=StringUtil.trim(firstName);
			lastName=StringUtil.trim(lastName);

			if (!firstName || !lastName)
			{
				XNotificationPopup.show("Ime i prezime ne smeju biti prazni.");
				return;
			}

			if (firstName.length > 30 || lastName.length > 30)
			{

				XNotificationPopup.show("Ime i prezime ne smeju biti duži od 30 karaktera.");
				return;
			}

			LocalDataStorage.setLocalBoolean(view.rbgSounds.selectedValue, "playSounds");

			var orderNumber:int=model.learningOrderNumber;

			if (isNaN(orderNumber) || orderNumber < 1 || orderNumber > 3)
				orderNumber=1;

			LocalDataStorage.setLocalInteger(orderNumber, "learningOrderNumber");
			Settings.learningOrderNumber=orderNumber;

			saveUserService.send({firstName: firstName, lastName: lastName, email: email, isMale: isMale, questionsPerPage: questionsPerPage, drivingCategoryId: drivingCategoryId});
		}

		private function onFault(event:FaultEvent):void
		{

			model.isLoading=false;

			XAlertPopup.show(event);
		}
	}
}
