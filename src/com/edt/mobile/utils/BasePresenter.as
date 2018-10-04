package com.edt.mobile.utils
{
	import flash.events.Event;

	import mx.core.FlexGlobals;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;

	import spark.components.ViewNavigatorApplication;

	public class BasePresenter
	{

		protected var resourceManager:IResourceManager;

		public function BasePresenter()
		{
			resourceManager=ResourceManager.getInstance();

			resourceManager.addEventListener("change", onResourceManagerChange);

			//setujemo lokalizovane podatke odmah po kreiranju
			setLocaleData();
		}

		private function onResourceManagerChange(e:Event):void
		{
			//setujemo lokalizovane podatke i svaki put kada promenimo jezik
			setLocaleData();
		}

		protected function setLocaleData():void
		{
			//Ovde se setuju podaci za Locale (en, sr, de);
		}

		protected function pushView(viewClass:Class, data:Object=null):void
		{
			(FlexGlobals.topLevelApplication as ViewNavigatorApplication).navigator.pushView(viewClass, data);
		}

		protected function popView():void
		{
			(FlexGlobals.topLevelApplication as ViewNavigatorApplication).navigator.popView();
		}

	}
}

