package com.rll.net.files 
{
	import com.rll.core.rll_internal;
	import com.rll.core.IDestroyable;
	import com.rll.events.EventDispatcher;
	import com.rll.net.files.events.FileLoaderEvent;
	import com.rll.net.files.types.AbstractFile;
	import com.rll.net.files.types.FileTypesFactory;
	
	
	/**
	 *  @eventType com.rll.net.files.events.FileLoaderEvent.COMPLETE
	 *  
	 */
	[Event(name="complete", type="com.rll.net.files.events.FileLoaderEvent")]
	
	/**
	 *  @eventType com.rll.net.files.events.FileLoaderEvent.PROGRESS
	 *  
	 */
	[Event(name="progress", type="com.rll.net.files.events.FileLoaderEvent")]
	
	/**
	 * FileBundle class - stack, contains files any types
	 * @author amatveev
	 */
	public class FileBundle extends EventDispatcher implements IDestroyable
	{
		
		private var _files:Vector.<AbstractFile>;
		/**
		 * @default 0
		 */
		private var _loadedFiles:int = 0;
		/**
		 * 
		 * Constructor
		 * @args Arrays of URLS, AbstractFiles , URLS Strings, AbstractFiles. 
		 */
		public function FileBundle(...args) 
		{
			
			FileTypesFactory.init();
			
			for(var i:int = 0, len:int = args.length;  i < len; ++i)
			{
				if(args[i] is Array){
				
					this.importItems(args[i]);
						
				}else{
						
					rll_internal::add(args[i]);
				}
			
			}
		}
		/**
		 * @private
		 * Append item
		 * @return file
		 */
		rll_internal function add(item:*):AbstractFile
		{
			if(item is AbstractFile){
				return this.addFile(item);
			}
				return this.add(item);
		}
		/**
		 * append Data
		 * @param arr array of any types AbstractFile or String(URL)
		 */
		public function importItems(arr:Array):void{
			for(var i:int = 0, len:int = arr.length; i < len; ++i)
			{
				rll_internal::add(arr[i]);
			}
		}
		/**
		 * @return list of files on Bundle
		 */
		public function get files():Vector.<AbstractFile>
		{
			return _files;
		}

		
		/**
		 * Append file to bundle by URL
		 * @see com.rll.net.files.types.AbstractFile
		 * @return ref on instance AbstractFile
		 */
		public function add(url:String, params:* = null):AbstractFile 
		{
			var file:AbstractFile = 
				FileTypesFactory.getInstance(url, params);
			
			return this.addFile(file);
		}
		/**
		 * @return ref on instance AbstractFile
		 */
		public function addFile(file:AbstractFile):AbstractFile
		{
			_files = _files || new Vector.<AbstractFile>();
			file.bundle = this;
			_files.push(file);
			
			return file;
		}
		/**
		 * @return total count files in bundle
		 */
		public function get totalFilesCount():int 
		{
			return files ? files.length : 0;
		}
		/**
		 * @return count loaded files in bundle
		 */
		public function get loadedFilesCount():int 
		{
			return _loadedFiles;
		}
		/**
		 * @param value count of loaded files
		 */
		public function set loadedFilesCount(value:int):void 
		{
			if(_loadedFiles == value)
			{
				return;
			}
			
			_loadedFiles = value;
			
			var evt:FileLoaderEvent;
			
			if (_loadedFiles == this.totalFilesCount) 
			{
				evt = new FileLoaderEvent(FileLoaderEvent.COMPLETE, this.totalFilesCount, this.loadedFilesCount);
				
			}else {
				evt = new FileLoaderEvent(FileLoaderEvent.PROGRESS, this.totalFilesCount, this.loadedFilesCount);
			}
			
			this.dispatchEvent(evt);
			
		}
		override public function toString():String{
			return "[totalFiles: " + this.totalFilesCount + 
				" loadedFiles: " + this.loadedFilesCount+" files: "+ _files+"]"
		}
		/**
		 * @inheritDoc
		 */
		override public function destroy():void
		{
			_files = null;
			
			super.destroy();
		}
		
		
	}

}