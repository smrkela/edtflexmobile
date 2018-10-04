package com.edt.mobile.views.learning
{
	import com.evola.driving.model.Question;
	
	import mx.collections.ArrayCollection;
	
	[Bindable]
	public class LearningModel
	{
		//learning ili testing
		public var currentIndex:int;
		public var type:String;
		public var isLearning:Boolean;
		
		public var currentQuestion:Question;
		
		public var groupId : String;
		public var lessonId : String;
		
		public var questions:ArrayCollection;
		public var removedQuestionsCount:int;
		public var lessonName:String;
		public var groupName:String;
		
		public function LearningModel()
		{
		}
	}
}