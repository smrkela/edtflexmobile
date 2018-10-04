package com.edt.mobile.views.register
{
	import com.edt.mobile.components.XLoadingPopup;
	import com.edt.mobile.components.XNotificationPopup;
	import com.edt.mobile.utils.BasePresenter;
	import com.edt.mobile.utils.LocalDataStorage;
	import com.edt.mobile.utils.ServiceCall;
	import com.edt.mobile.utils.ServiceUtils;
	import com.evola.driving.Session;
	import com.edt.mobile.utils.Settings;
	import com.edt.mobile.views.home.HomeView;
	import com.edt.mobile.views.loginhelp.LoginHelpView;
	
	import mx.rpc.events.FaultEvent;

	public class RegisterPresenter extends BasePresenter
	{

		[Bindable]
		public var model:RegisterModel=new RegisterModel();
		public var view:RegisterView;

		private var registerService:ServiceCall=new ServiceCall("rest/user/registerUser", onRegisterSuccess, onRegisterFault, "post");

		public function RegisterPresenter()
		{
		}

		public function registerClicked():void
		{

			//treba da imamo sve podatke koji su zahtevani na serveru
			var obj:Object={};
			obj.firstName=model.firstName;
			obj.lastName=model.lastName;
			obj.username=model.username;
			obj.password=model.password;
			obj.email=model.email;
			obj.isMale=model.isMale;
			obj.recaptcha_challenge_field="dummy";
			obj.recaptcha_response_field="dummy";
			obj.signInProvider="MOBILE"; //posebna vrednost za mobilnu aplikaciju

			registerService.send(obj);

			XLoadingPopup.show("Registracija...");
		}

		//**********************************************

		private function onRegisterSuccess(result:XML):void
		{

			XLoadingPopup.hide();

			pushView(RegisterSuccessView, {email: model.email});
		}

		private function onRegisterFault(event:FaultEvent):void
		{

			ServiceUtils.manageFault(event, "Greška tokom registracije.");
		}

		public function viewInitialized():void
		{

			if (Settings.IS_DEMO)
			{

				model.firstName="Office";
				model.lastName="Vozači";
				model.username="evola"
				model.password="EVOLA";
				model.email="office.vozacisrbije@gmail.com";
				model.isMale=true;
			}
			else
			{
				model.firstName="";
				model.lastName="";
				model.username="";
				model.password="";
				model.email="";
				model.isMale=true;
			}
		}

	}
}
