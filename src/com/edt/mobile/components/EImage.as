package com.edt.mobile.components
{
	import mx.core.mx_internal;
	
	import spark.core.ContentCache;
	import spark.primitives.BitmapImage;

	use namespace mx_internal;

	public class EImage extends BitmapImage
	{

		private static var _contentCache:ContentCache;

		private var _dpiSource:String;
		private var _dpiSourceChanged:Boolean;

		public function EImage()
		{
			super();

			if (!_contentCache)
			{

				_contentCache=new ContentCache();
				_contentCache.enableCaching=true;
				_contentCache.maxCacheEntries=50;
			}

			contentLoader=_contentCache;

			//source=new MultiDPIBitmapSource();
		}

//		/**
//		 * Ovo je naziv slike unutar foldera pics/dpi240 npr. ondosno
//		 * puna putanja unutar tog foldera ako je slika u nekom podfolderu.
//		 * Ako slika nema ekstenziju u prosledjenom nazivu, bice joj dodata png ektenzija.
//		 */
//		public function set dpiSource(value:String):void
//		{
//			if (!value || _dpiSource == value)
//				return;
//
//			if (source is MultiDPIBitmapSource)
//			{
//
//				if (value.indexOf(".") == -1)
//					value+=".png";
//
//				var source:MultiDPIBitmapSource=source as MultiDPIBitmapSource;
//
//				source.source160dpi=Session.IMAGE_PATH_160 + value;
//				source.source240dpi=Session.IMAGE_PATH_240 + value;
//				source.source320dpi=Session.IMAGE_PATH_320 + value;
//
//				_dpiSourceChanged=true;
//
//				invalidateProperties();
//			}
//		}

		override protected function commitProperties():void
		{

			super.commitProperties();

			if (_dpiSourceChanged)
			{

				_dpiSourceChanged=false;

				applySource();
			}
		}

	}
}
