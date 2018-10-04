package com.edt.mobile.utils
{
	import com.edt.mobile.components.XAlertPopup;
	
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	
	import mx.messaging.messages.AbstractMessage;
	import mx.messaging.messages.IMessage;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;


	public class ServiceCall
	{

		private var _resultFunction:Function;
		private var _faultFunction:Function;
		private var _destination:String;
		private var _showBusyCursor:Boolean=true;
		private var _method:String="GET";
		
		public var checkResult : Boolean = true;
		
		public var contentType:String = "application/x-www-form-urlencoded";
		public var headers : Object = {};

		public function ServiceCall(destination:String, resultFunction:Function, faultFunction:Function=null, method:String="get", showBusyCursor:Boolean=true)
		{
			_destination=destination;
			_resultFunction=resultFunction;
			_faultFunction=faultFunction;
			_showBusyCursor=showBusyCursor;
			_method=method;
		}

		public function send(params:Object=null):void
		{
			var service:HTTPService=new HTTPService();
			service.addEventListener(ResultEvent.RESULT, onResult);
			service.addEventListener(FaultEvent.FAULT, onServiceFault);
			service.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, onHttpStatus);
			service.addEventListener(HTTPStatusEvent.HTTP_STATUS, onStatus);
			service.method=_method;
			service.url=Settings.SERVER + _destination;
			service.resultFormat="e4x";
			service.contentType = contentType;
			service.headers = headers;

			service.request=params;

			service.send();

			service.showBusyCursor=_showBusyCursor;

//			if (_showBusyCursor) {
//				WaitCursor.show();
//			}

		}
		
		protected function onStatus(event:Event):void
		{

			trace("STATUS: "+event.toString());
		}
		
		protected function onHttpStatus(event:Event):void
		{

			trace("HTTP STATUS: "+event.toString());
		}
		
		protected function onServiceFault(event:FaultEvent):void
		{
//			WaitCursor.hide();
			onFault(event);
		}

		protected function onResult(event:ResultEvent):void
		{
			var xml:XML=event.result as XML;

//			WaitCursor.hide();

			//ako imamo xml i on pocinje sa html tagom onda je u pitanje spring security greska: redirect to login

			var isError:Boolean=false;

			if (checkResult && event.result && event.result is XML)
			{

				if (event.result.head.length() > 0 && event.result.body.length() > 0)
				{

					isError=true;

					event.stopImmediatePropagation();
					event.preventDefault();

					//simuliramo not authorized event

					var message:IMessage=new AbstractMessage();
					message.headers={};
					message.headers[AbstractMessage.STATUS_CODE_HEADER]=401;

					var fault:FaultEvent=new FaultEvent(FaultEvent.FAULT, false, true, null, null, message);

					//greska
					onFault(fault);
				}
			}

			if (!isError)
				_resultFunction(xml);
		}

		private function onFault(event:FaultEvent):void
		{
//			WaitCursor.hide();

			if (_faultFunction != null)
			{

				_faultFunction(event);
			}
			else
			{

				XAlertPopup.show(event);
			}
		}

	}
}

