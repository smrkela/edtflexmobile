package com.edt.mobile.views.sessions
{
	import mx.collections.ListCollectionView;
	
	[Bindable]
	public class SessionsModel
	{
		public var isLoading:Boolean;
		public var doneQuestions:int;
		public var type:String;
		public var isLearning : Boolean;
		
		public var sessions : ListCollectionView;
		
		public function SessionsModel()
		{
		}
	}
}