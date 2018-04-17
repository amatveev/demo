package com.rll.net.files.types 
{
	import com.rll.core.IDestroyable;
	import com.rll.events.EventDispatcher;
	import com.rll.net.files.FileBundle;
	import com.rll.net.util.URLUtil;
	
	import flash.utils.ByteArray;
	
	/**
	 *  @eventType com.rll.net.files.events.FileEvent.FILE_ERROR
	 *  
	 */
	[Event(name="fileError", type="com.rll.net.files.events.FileEvent")]
	
	/**
	 *  @eventType com.rll.net.files.events.FileEvent.FILE_PROGRESS
	 *  
	 */
	[Event(name="fileProgress", type="com.rll.net.files.events.FileEvent")]
	/**
	 *  @eventType com.rll.net.files.events.FileEvent.FILE_START
	 *  
	 */
	[Event(name="fileStart", type="com.rll.net.files.events.FileEvent")]
	
	/**
	 *  @eventType com.rll.net.files.events.FileEvent.FILE_COMPLETE
	 *  
	 */
	[Event(name="fileComplete", type="com.rll.net.files.events.FileEvent")]
	/**
	 * AbstractFile class - impletement file of any type. Contains bytes of file  
	 * Wrapper on Bytes
	 * @author amatveev
	 */
	public class AbstractFile extends EventDispatcher implements IDestroyable
	{
		
		public static const DEFAULT_URL_VALUE:String = "URL not defined";
		
		protected var _url:String = DEFAULT_URL_VALUE;
		protected var _content:ByteArray;
		protected var _params:Object;
		protected var _typeName:String;
		protected var _errorMsg:String;
		protected var _bytesTotal:Number = 0.0;
		protected var _bytesLoaded:Number = 0.0;
		protected var _bundle:FileBundle;
		protected var _toStringPropsList:Array = [
			"typeName",
			"filename",
			"url",
			"errorMsg",
			"bytesLoaded",
			"bytesTotal"
		];
		
		override public function toString():String {
			var s:String = this.formatToString(
				_typeName,
				_toStringPropsList
			);
			
			return s;
		}
		/**
		 * @return name and values
		 */
		public function formatToString(className:String, properties:Array):String 
		{
			var s:String='['+className;
			var prop:String;
			for (var i:int=0; i < properties.length; ++i) {
				prop=properties[i];
				s+=' '+ prop +'=' + this[prop];
			}
			return s+']';
		}
		/**
		 * Constructor
		 * @param url file URL
		 * @param params optional file params
		 */
		public function AbstractFile(url:String, params:*) 
		{
			_typeName = "Abstract(Binary)";
			_url = url;
			_params = params;
			
		}
		/**
		 * Name of file
		 * @return Name of loaded file
		 */
		public function get filename():String {
			return URLUtil.getFileName(_url);
		}
		/**
		 * URL of file
		 * @return File url
		 */
		public function get url():String 
		{
			return _url;
		}
		/**
		 * URL of file
		 * @param value file URL
		 * @return File url
		 */
		public function set url(value:String):void 
		{
			_url = value;
		}
		/**
		 * Bytes of file
		 * @return File content - bytes
		 */
		public function get content():ByteArray
		{
			//_content.position = 0;
			return _content;
		}
		/**
		 * set file content
		 * @param value Bytes
		 */
		public function set content(value:ByteArray):void 
		{
			_content = value;
		}
		
		public function get typeName():String 
		{
			return _typeName;
		}
		
		public function get errorMsg():String 
		{
			return _errorMsg;
		}
		
		public function set errorMsg(value:String):void 
		{
			_errorMsg = value;
		}
		
		public function get bytesTotal():Number 
		{
			return _bytesTotal;
		}
		
		public function set bytesTotal(value:Number):void 
		{
			_bytesTotal = value;
		}
		/**
		 * Contains count of bytes loaded in time
		 * @return loaded Bytes Count 
		 */
		public function get bytesLoaded():Number 
		{
			return _bytesLoaded;
		}
		
 		public function set bytesLoaded(value:Number):void 
		{
			_bytesLoaded = value;
		}
		/**
		 * Reference on FileBundle
		 * @return Ref on FileBundel
		 */
		public function get bundle():FileBundle 
		{
			return _bundle;
		}
		
		public function set bundle(value:FileBundle):void 
		{
			_bundle = value;
		}
		
		override public function destroy():void {
			_content = null;
			_bundle = null;
			
			super.destroy();
		}
		
	}

}