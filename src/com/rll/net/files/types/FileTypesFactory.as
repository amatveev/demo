package com.rll.net.files.types 
{
	
	/**
	 * Create Files Any Type by URL. Fileloader Util
	 * @see com.rll.net.files.FileLoader
	 * @see com.rll.net.files.FileBundle
	 * @author amatveev
	 */
	public class FileTypesFactory 
	{
		private static var _fileTypes:Object = {};
		private static var _initted:Boolean;
		/**
		 * 
		 * Init
		 */
		public static function init():void {
			if (_initted) {
				return;
			}
			//common types
			registerTypeByExtension(".jpg", ImageFile);
			registerTypeByExtension(".jpeg", ImageFile);
			registerTypeByExtension(".png", ImageFile);
			registerTypeByExtension(".gif", ImageFile);
			registerTypeByExtension(".swf", SWFFile);
			registerTypeByExtension(".txt", TXTFile);
			_initted = true;
		}
		/**
		 * Register types by file extantion
		 */
		public static function registerTypeByExtension(ext:String, cls:Class):void {
			_fileTypes[ext] = cls;
		}
		/**
		 * 
		 * @return instance of object
		 */
		public static function getInstance(url:String, params:*):AbstractFile
		{
			
			var result:AbstractFile;
			var ext:String;
			
			for (var key:String in _fileTypes) 
			{
				
				if (url.indexOf(key) != -1) {
					ext = key;
					break;
				}
			}
			
			var cls:Class = _fileTypes[ext];
			
			if (cls) {
				result  = new cls(url, params);
			}else {
				result = new AbstractFile(url, params);
			}
			
			return result;
		}
	}

}