package com.edt.mobile.views.groups
{
	import mx.collections.XMLListCollection;

	[Bindable]
	public class GroupsModel
	{
		//learning ili testing
		public var type:String;
		public var isLearning : Boolean;
		
		public var groups : XMLListCollection; 
		
		public function GroupsModel()
		{
		}
	}
}