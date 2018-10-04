package com.edt.mobile.views.login
{
	import com.edt.mobile.components.XLoadingPopup;
	import com.edt.mobile.utils.BasePresenter;
	import com.edt.mobile.utils.LocalDataStorage;
	import com.edt.mobile.utils.ServiceCall;
	import com.evola.driving.Session;
	import com.edt.mobile.utils.Settings;
	import com.edt.mobile.views.home.HomeView;
	import com.edt.mobile.views.loginhelp.ForgottenPasswordView;
	import com.edt.mobile.views.loginhelp.ForgottenUsernameView;
	import com.edt.mobile.views.loginhelp.LoginHelpView;
	import com.edt.mobile.views.register.RegisterView;
	
	import mx.rpc.events.FaultEvent;

	public class LoginPresenter extends BasePresenter
	{

		[Bindable]
		public var model:LoginModel=new LoginModel();
		public var view:LoginView;

		private var loginService:ServiceCall=new ServiceCall("login", onDataLoaded, onLoginFault, "post");

		public function LoginPresenter()
		{
		}

		public function loginClicked():void
		{

			loginService.checkResult=false;
			loginService.send({username: model.username, password: model.password});

			model.loginMessage=null;

			XLoadingPopup.show("Prijava...");
		}

		//**********************************************

		private function onLoginFault(event:FaultEvent):void
		{

			XLoadingPopup.hide();

			var m:String="Greška tokom logovanja.";

			if (event.fault.errorID == 2032)
				m+=" Proveri internet konekciju.";

			model.loginMessage=m;

			trace("Login Error: " + event.toString());
		}

		private function onDataLoaded(xmlData:XML):void
		{

			XLoadingPopup.hide();

			//ako u odgovoru imamo formu za login znaci da je neuspesan login
			var errorHtmlPart:String="action=\"/uloguj-se\"";
			var errorHtmlPart2:String="action=\"/ROOT/uloguj-se\"";

			var string:String=xmlData ? xmlData.toString() : "";

			if (string.search(errorHtmlPart) > -1 || string.search(errorHtmlPart2) > -1)
			{

				model.loginMessage="Neispravno korisničko ime ili lozinka.";
			}
			else
			{
				Session.USERNAME=model.username;
				Session.USER_ID=xmlData.@userId;

				saveToLocalStore();

				pushView(HomeView);
			}
		}

		// Metoda radi cuvanje unetih podataka u local store (ako je korisnik izabrao da ih cuva).
		private function saveToLocalStore():void
		{

			if (model.isRememberMe) //Pamcenje username & password;
			{
				LocalDataStorage.setLocalString(model.username, "user");
				LocalDataStorage.setLocalString(model.password, "pass");
				LocalDataStorage.setLocalBoolean(true, "remember");
			}
			else //Ne pamte se username & password;
			{
				LocalDataStorage.setLocalBoolean(false, "remember");
			}

		}

		public function viewInitialized():void
		{

			view.actionBarVisible=false;

			model.isRememberMe=LocalDataStorage.getLocalBoolean("remember", true);

			if (model.isRememberMe) //Ako su login informacije zapamcene, uchitaj ih;
			{
				model.username=LocalDataStorage.getLocalString("user");
				model.password=LocalDataStorage.getLocalString("pass");
			}

			//ucitavamo i koji put korisnik uci
			var orderNumber:int=LocalDataStorage.getLocalInteger("learningOrderNumber");

			if (isNaN(orderNumber) || orderNumber < 1 || orderNumber > 3)
				orderNumber=1;

			Settings.learningOrderNumber=orderNumber;
		}

		public function loginHelpClicked():void
		{

			pushView(LoginHelpView);
		}

		public function registerClicked():void
		{

			pushView(RegisterView);
		}

		public function passwordForgottenClicked():void
		{

			pushView(ForgottenPasswordView);
		}

		public function usernameForgottenClicked():void
		{

			pushView(ForgottenUsernameView);
		}
	}
}
