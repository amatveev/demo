package com.rll.net.files.events 
{
	
	
	import flash.events.Event;
	
	/**
	 * Events Fileloader
	 * @author amatveev
	 */
	public class FileLoaderEvent extends Event 
	{
		
	
		/**
		 * Broadcast when all files loaded in queue
		 */
		public static const COMPLETE:String = "complete";
		/**
		 * Broadcast when queue of files started
		 */
		public static const START:String = "start";
		/**
		 * Broadcast when files are loading state
		 */
		public static const PROGRESS:String = "progress";
		
		/**
		 * Count of total files in queue
		 */
		protected var _totalFiles:int = 0;
		/**
		 * Count of current loaded files
		 */
		protected var _loadedFiles:int = 0;
		
		public function FileLoaderEvent(type:String,
										totalFiles:int = 0,
										loadedFiles:int = 0,
										bubbles:Boolean=false,
										cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			_totalFiles = totalFiles;
			_loadedFiles = loadedFiles;
			
		} 
		/**
		 * @inheritDoc
		 */
		public override function clone():Event 
		{ 
			return new FileLoaderEvent(type, _totalFiles, _loadedFiles, bubbles, cancelable);
		} 
		/**
		 * @inheritDoc
		 */
		public override function toString():String 
		{ 
			return formatToString(
								"FileLoaderEvent", 
								"type",
								"totalFiles", 
								"loadedFiles", 
								"bubbles", 
								"cancelable", 
								"eventPhase"); 
		}
		
		/**
		 * Count of total files in queue
		 */
		public function get totalFiles():int 
		{
			return _totalFiles;
		}
		
		public function set totalFiles(value:int):void 
		{
			_totalFiles = value;
		}
		/**
		 * Coount of complete loading files
		 */
		public function get loadedFiles():int 
		{
			return _loadedFiles;
		}
		
		public function set loadedFiles(value:int):void 
		{
			_loadedFiles = value;
		}
		
	}
	
}