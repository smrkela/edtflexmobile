package com.edt.mobile.views.toplists
{
	import mx.collections.XMLListCollection;
	

	[Bindable]
	public class TopListsModel
	{
		
		public var isLoading : Boolean;
		public var selectedSection : int;
		public var results : XMLListCollection;
		
		public function TopListsModel()
		{
		}
	}
}