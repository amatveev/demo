package com.rll.net.files 
{
	import com.rll.errors.SingeltonError;
	import com.rll.events.EventDispatcher;
	import com.rll.net.files.events.FileEvent;
	import com.rll.net.files.events.FileLoaderEvent;
	import com.rll.net.files.types.AbstractFile;
	import com.rll.net.files.types.FileTypesFactory;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
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
	
	//-------------
	
	/**
	 *  @eventType com.rll.net.files.events.FileLoaderEvent.COMPLETE
	 *  
	 */
	[Event(name="complete", type="com.rll.net.files.events.FileLoaderEvent")]
	
	/**
	 *  @eventType com.rll.net.files.events.FileLoaderEvent.START
	 *  
	 */
	[Event(name="start", type="com.rll.net.files.events.FileLoaderEvent")]
	
	/**
	 *  @eventType com.rll.net.files.events.FileLoaderEvent.PROGRESS
	 *  
	 */
	[Event(name="progress", type="com.rll.net.files.events.FileLoaderEvent")]
	
	/**
	 * Singelton Class.
	 * Class is describe file loder. This class create queue of files and handle loading files on one/more standart flash URLstream's
	 * @example
	 * <listing version="3.0">
	 * var f:ImageFile = Fileloader.getInstance().loadByURL(
	 * "http://wwwimages.adobe.com/www.adobe.com/special/ri/prod/assets/base/img/logo-with-text.fp-1e711c186819c1ab620043546df9ac77.png");
	 * this.addChild(f.getBitmap());
	 * </listing>
	 * 
	 * @includeExample fileLoaderExample/FileLoaderExample.as
	 * 
	 * @author amatveev
	 */
	public class FileLoader extends EventDispatcher
	{
		/**
		 * Minimal load treads count
		 */
		public static const MIN_NUM_TREADS:uint = 1;
		
		private static var _inatance:FileLoader;
		protected static var _allowInstance:Boolean;
		/**
		 * @default 2
		 */
		protected var _numTreads:uint = 2;
		protected var _queue:Array = [];
		protected var _waitingLoading:Dictionary = new Dictionary();
		protected var _loaders:Vector.<URLStream>;
		protected var _currentExecuteCount:int = 0;
		protected var _totalFilesCount:int = 0;
		protected var _loadedFilesCount:int = 0;
		/**
		 * Counstructor
		 * 
		 */
		public function FileLoader() 
		{
			if (!_allowInstance)
			{
				throw new SingeltonError();
			}
			this.numTreads = _numTreads;
			FileTypesFactory.init();
		}
		/**
		 * @return FileLoader instance
		 */
		public static function getInstance():FileLoader
		{
			if (!_inatance) {
				_allowInstance = true;
				_inatance = new FileLoader();
				_allowInstance = false;
			}
			return _inatance;
		}
		protected function createLoaders():Vector.<URLStream> {
			var len:int = _numTreads;
			var r:Vector.<URLStream> = new Vector.<URLStream>();
			var l:URLStream;
			
			while (len-->0) {
				l = new URLStream();
				r.push(l);
			}
			
			return r;
		}
		protected function addHandlers(loader:URLStream):URLStream {
			loader.addEventListener(Event.OPEN, handleLoaderOpen);
			loader.addEventListener(Event.COMPLETE, handleLoaderComplete);
			loader.addEventListener(ProgressEvent.PROGRESS, handleLoaderProgress);
			loader.addEventListener(IOErrorEvent.IO_ERROR, handleLoaderError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleLoaderError);
			
			return loader;
		}
		protected function removeHandler(loader:URLStream):URLStream {
			loader.removeEventListener(Event.OPEN, handleLoaderOpen);
			loader.removeEventListener(Event.COMPLETE, handleLoaderComplete);
			loader.removeEventListener(ProgressEvent.PROGRESS, handleLoaderProgress);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, handleLoaderError);
			loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handleLoaderError);
			
			return loader;
		}
		protected function getNext():void {
			var files:Array = [];
			
			for (var i:int = 0, l:int = Math.min(_queue.length, _numTreads); i < l; ++i) 
			{
				files.push(_queue.shift());
			}
			
			execute(files);
			_currentExecuteCount = files.length;
			
			
		}
		protected function execute(files:Array):void {
			
			var loader:URLStream;
			var file:AbstractFile;
			
			for (var i:int = 0, l:int = files.length; i < l; ++i) 
			{
				file = files[i];
				loader = _loaders[i];
				_waitingLoading[loader] = file;
				loader.load(new URLRequest(file.url));
				
			}
			
		}
		
		
		protected function pushFile(file:AbstractFile):AbstractFile {
			_queue.push(file);
			_totalFilesCount = _currentExecuteCount + _queue.length;
			_loadedFilesCount = 0;
			return file;
		}
		
		protected function validateStartEvents():void {
			this.dispatchEvent(new FileLoaderEvent(FileLoaderEvent.START, _totalFilesCount, _loadedFilesCount));
		}
		private function handleLoaderError(e:Event):void 
		{
			var evt:FileLoaderEvent;
			var file:AbstractFile = _waitingLoading[e.target];
			/////////
			file.errorMsg = e["text"];
			/////
			
			file.dispatchEvent(evt);
			this.dispatchEvent(evt);
			///////
			if (!_queue.length)
			{
				evt  = new FileLoaderEvent(FileLoaderEvent.COMPLETE,_totalFilesCount, _loadedFilesCount);
				this.dispatchEvent(evt);
			}
			
			_currentExecuteCount--;
			if (!_currentExecuteCount) 
			{
				this.getNext();
			}
		}
		
		private function handleLoaderProgress(e:ProgressEvent):void 
		{
			var file:AbstractFile = _waitingLoading[e.target];
			var evt:FileEvent = new FileEvent(FileEvent.FILE_PROGRESS, file);
			/////////////////
			file.bytesLoaded = e.bytesLoaded;
			file.bytesTotal = e.bytesTotal;
			//////////////////////
			file.dispatchEvent(evt);
			this.dispatchEvent(evt);
		}
		
		private function handleLoaderComplete(e:Event):void 
		{
			var evt:FileLoaderEvent;
			var loader:URLStream = URLStream(e.target);
			var file:AbstractFile = _waitingLoading[loader];
			///////////
			var ba:ByteArray = new ByteArray();
			loader.readBytes(ba, 0, loader.bytesAvailable);
			file.content = ba;
			//////////
			
			if (file.bundle) {
				file.bundle.loadedFilesCount++;
			}
			var fileEvt:FileEvent = new FileEvent(FileEvent.FILE_COMPLETE, file);
			
			file.dispatchEvent(fileEvt);
			this.dispatchEvent(fileEvt);
			
			
			
			/////////////////////////
			_currentExecuteCount--;
			_loadedFilesCount++;
			///////////////
			evt = new FileLoaderEvent(FileLoaderEvent.PROGRESS, _totalFilesCount, _loadedFilesCount);
			this.dispatchEvent(evt);
			
			if (!_queue.length && _totalFilesCount == _loadedFilesCount)
			{
				evt = new FileLoaderEvent(FileLoaderEvent.COMPLETE, _totalFilesCount, _loadedFilesCount);
				this.dispatchEvent(evt);
			}
			
			if (!_currentExecuteCount) 
			{
				this.getNext();
			}
		}
		
		private function handleLoaderOpen(e:Event):void 
		{
			var file:AbstractFile = _waitingLoading[e.target];
			var evt:FileEvent = new FileEvent(FileEvent.FILE_START, file);
			
			file.dispatchEvent(evt);
			this.dispatchEvent(evt);
		}
		
		/**
		 * Load file by URL
		 * @param url  -  file URL
		 * @param params - optional file params
		 * @return Instance of object AbstractFile
		 */
		public function loadByURL(url:String, params:* = null):AbstractFile {
			var file:AbstractFile = FileTypesFactory.getInstance(url, params);
			
			this.pushFile(file);
			this.validateStartEvents();
			
			if(!_currentExecuteCount)
				this.getNext();
			
			return file;
		}
		/**
		 * Load File bundle
		 * @params bundle - Ref on file bundle
		 * @return Ref on Filebundle
		 */
		public function loadBundle(bundle:FileBundle):FileBundle 
		{
			for (var i:int = 0, l:int = bundle.files.length; i < l; ++i) 
			{
				this.pushFile(bundle.files[i]);
			}
			
			if (!_currentExecuteCount) 
			this.getNext();
			
			this.validateStartEvents();
			
			return bundle;
		}
		/**
		 * @return Treads count of load
		 */
		public function get numTreads():uint 
		{
			return _numTreads;
		}
		/**
		 * Set treads count of load (loaders count)
		 * @params value - count of loaders objetcts
		 */
		public function set numTreads(value:uint):void 
		{
			_numTreads = value < MIN_NUM_TREADS ? MIN_NUM_TREADS : value;
			if (_loaders) {
				while (_loaders.length) {
					removeHandler(_loaders.pop())
				}
			}
			_loaders = this.createLoaders();
			var len:int = _loaders.length;
			while (len-->0)
			{
				this.addHandlers(_loaders[len]);
			}
			
		}
	}

}