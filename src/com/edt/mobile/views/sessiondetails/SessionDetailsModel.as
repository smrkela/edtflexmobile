package com.edt.mobile.views.sessiondetails
{
	import mx.collections.XMLListCollection;
	
	
	[Bindable]
	public class SessionDetailsModel
	{
		public var dataProvider:XMLListCollection;
		public var title:String;
		public var isLearning:Boolean;
		public var sessionId:String;
		public var isLoading:Boolean;
		
		public function SessionDetailsModel()
		{
		}
	}
}