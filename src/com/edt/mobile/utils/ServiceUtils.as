package com.edt.mobile.utils
{
	import com.edt.mobile.components.XLoadingPopup;
	import com.edt.mobile.components.XNotificationPopup;
	
	import mx.rpc.events.FaultEvent;

	public class ServiceUtils
	{
		
		public static function manageFault(event : FaultEvent, customMessage : String) : void{
			
			XLoadingPopup.hide();
			
			var bodyMessage:String=getBodyMessage(event);
			
			if (bodyMessage)
			{
				
				XNotificationPopup.show(bodyMessage);
			}
			else
			{
				
				var m:String=customMessage;
				
				if (event.fault.errorID == 2032)
					m+=" Proveri internet konekciju.";
				
				XNotificationPopup.show(m);
			}
		}

		public static function getBodyMessage(event:FaultEvent):String
		{

			if (!event || !event.message)
				return null;

			var bodyString:String=String(event.message.body);

			var body:Object=null;

			try
			{
				body=JSON.parse(bodyString);
			}
			catch (e:Error)
			{
			}

			if (body && "message" in body)
			{

				var message:String=body.message;

				return message;
			}

			return null;
		}
	}
}
