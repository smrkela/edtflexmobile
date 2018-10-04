package com.edt.mobile.views.lessons
{
	import mx.collections.XMLListCollection;

	[Bindable]
	public class LessonsModel
	{
		//learning ili testing
		public var type:String;
		public var isLearning:Boolean;

		public var groupId:String;
		public var groupName:String;
		public var lessons:XMLListCollection;

		public function LessonsModel()
		{
		}
	}
}
