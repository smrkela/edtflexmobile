package com.edt.mobile.utils
{
	import com.evola.driving.util.ThemeSounds;

	public class Sounds
	{

		public function Sounds()
		{
		}

		public static function playQuestionSuccess():void
		{

			if (shouldPlaySounds())
				ThemeSounds.playQuestionSuccess();
		}

		public static function playQuestionFailure():void
		{

			if (shouldPlaySounds())
				ThemeSounds.playQuestionFailure();
		}

		public static function playLearningFinish():void
		{

			if (shouldPlaySounds())
				ThemeSounds.playLearningFinish();
		}
		
		public static function playTestingFinish():void
		{
			
			if (shouldPlaySounds())
				ThemeSounds.playTestingFinish();
		}

		public static function playNewLevel():void
		{
			
			if(shouldPlaySounds())
				ThemeSounds.playLevelUp();
		}
		
		private static function shouldPlaySounds():Boolean
		{
			
			return LocalDataStorage.getLocalBoolean("playSounds", true);
		}

	}
}
