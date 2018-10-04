package com.edt.mobile.components
{
	import mx.core.mx_internal;
	
	import spark.core.ContentCache;
	import spark.primitives.BitmapImage;

	use namespace mx_internal;

	public class XImage extends BitmapImage
	{

		private static var _contentCache:ContentCache;

		public function XImage()
		{
			super();

			if (!_contentCache)
			{

				_contentCache=new ContentCache();
				_contentCache.enableCaching=true;
				_contentCache.maxCacheEntries=50;
			}

			contentLoader=_contentCache;
		}
		
	}
}
