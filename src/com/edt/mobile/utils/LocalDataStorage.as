package com.edt.mobile.utils
{
	import mx.collections.ArrayList;

	public class LocalDataStorage
	{
		import flash.data.EncryptedLocalStore;
		import flash.utils.ByteArray;

		public function LocalDataStorage()
		{
		}

		public static function setLocalString(source:String, name:String):void
		{
			var bytes:ByteArray=new ByteArray();
			bytes.writeUTFBytes(source);
			EncryptedLocalStore.setItem(name, bytes);
		}

		public static function getLocalString(name:String):String
		{
			var bytes:ByteArray=EncryptedLocalStore.getItem(name);
			if (bytes != null)
				return bytes.readUTFBytes(bytes.length);

			return "";
		}

		public static function setLocalBoolean(value:Boolean, name:String) : void
		{
			var bytes:ByteArray=new ByteArray();
			bytes.writeBoolean(value);
			EncryptedLocalStore.setItem(name, bytes);
		}

		public static function getLocalBoolean(name:String, defaultValue : Boolean = false):Boolean
		{
			var bytes:ByteArray=EncryptedLocalStore.getItem(name);

			if (bytes != null)
				return bytes.readBoolean();

			return defaultValue;
		}

		public static function setLocalArrayList (value:ArrayList, name:String) : void
		{
			var bytes:ByteArray = new ByteArray();
			bytes.writeObject(value);
			EncryptedLocalStore.setItem(name, bytes);
		}

		public static function getLocalArrayList(name:String):ArrayList
		{
			var bytes:ByteArray=EncryptedLocalStore.getItem(name);

			if (bytes != null)
				return ArrayList(bytes.readObject());

			return new ArrayList();
		}

		public static function setLocalInteger(source:int, name:String):void
		{
			var bytes:ByteArray=new ByteArray();
			bytes.writeInt(source);
			EncryptedLocalStore.setItem(name, bytes);
		}

		public static function getLocalInteger(name:String):int
		{
			var bytes:ByteArray=EncryptedLocalStore.getItem(name);
			if (bytes != null)
				return bytes.readInt();

			return 0;
		}
	}
}

