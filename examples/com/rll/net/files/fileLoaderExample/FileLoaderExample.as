package
{
	import com.rll.net.files.FileBundle;
	import com.rll.net.files.FileLoader;
	import com.rll.net.files.events.FileEvent;
	import com.rll.net.files.events.FileLoaderEvent;
	import com.rll.net.files.types.AbstractFile;
	import com.rll.net.files.types.ImageFile;
	import com.rll.net.files.types.SWFFile;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.system.LoaderContext;
	
	
	public class FileLoaderExample extends Sprite
	{
		//test images
		private var _filesURLS:Array = [
			"http://wwwimages.adobe.com/www.adobe.com/images/shared/download_buttons/get_flash_player.gif",
			"http://cs625221.vk.me/v625221473/d11b/au4Dj1JIpFY.jpg",
			"http://cs624131.vk.me/v624131473/1bdda/Rcp5oMuJ8VI.jpg"
			
		];
		private var _files:Array = [];
		private var _loader:FileLoader;
		public function FileLoaderExample()
		{
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.align = StageAlign.TOP_LEFT;
			
			_loader = FileLoader.getInstance();
			
			this.appendHandlersForLoader(_loader);
			
			
			//create ImageFiles
			for each(var v:String in _filesURLS)
			{
				_files.push(v);
			}
			
			
			//load By URL
			var f:AbstractFile;
			var dObject:DisplayObject;
			
			for(var i:int = 0, l:int = _filesURLS.length; i < l; ++i)
			{
				f = FileLoader.getInstance().loadByURL(_filesURLS[i]);
				this.appendHandlersForFile(f);
				
				if(f is ImageFile)
				{
					this.addChild(ImageFile(f).getBitmap()).x = i*100;
				}else if(f is SWFFile){
					dObject = this.addChild(SWFFile(f).getLoader(new LoaderContext()));
					
					dObject.x = i*100;
					dObject.scaleX = dObject.scaleY = 0.3;
					
					
				}
			}
			//load FileBudle
			var fileBundle:FileBundle = new FileBundle(
				_files,
				_files,
				_filesURLS[1],
				_files);
			
			_loader.loadBundle(fileBundle).addEventListener(FileLoaderEvent.COMPLETE, handleLoadFileBundleComplete);
			
			
		}
		protected function appendHandlersForFile(f:AbstractFile):void{
			f.addEventListener(FileEvent.FILE_START, handleLoadFileEvent);
			f.addEventListener(FileEvent.FILE_PROGRESS, handleLoadFileEvent);
			f.addEventListener(FileEvent.FILE_COMPLETE, handleLoadFileEvent);
			f.addEventListener(FileEvent.FILE_ERROR, handleLoadFileEvent);
			
		}
		protected function appendHandlersForLoader(l:FileLoader):void{
			l.addEventListener(FileLoaderEvent.START, handleFileLoaderEvent);
			l.addEventListener(FileLoaderEvent.PROGRESS, handleFileLoaderEvent);
			l.addEventListener(FileLoaderEvent.COMPLETE, handleFileLoaderEvent);
			
		}
		
		protected function handleLoadFileBundleComplete(event:FileLoaderEvent):void
		{
			var b:FileBundle = FileBundle(event.target);
			b.removeEventListener(FileLoaderEvent.COMPLETE, handleLoadFileBundleComplete);
			trace("FileBundle complete", b.loadedFilesCount);
			//append on stage
			var dObject:DisplayObject
			var f:AbstractFile;
			for(var i:int = 0, l:int = b.totalFilesCount; i <l; ++i)
			{
				f = b.files[i];
				
				if(f is ImageFile)
				{
					dObject = this.addChild(ImageFile(f).getBitmap());
					dObject.x = i*100;
					dObject.y = 300;
					dObject.scaleX = dObject.scaleY = 0.2;
				}else if(f is SWFFile){
					dObject = this.addChild(SWFFile(f).getLoader(new LoaderContext()));
					dObject.x = i*100;
					dObject.y = 300;
					dObject.scaleX = dObject.scaleY = 0.2;
					
				}
			}
			
		}
		protected function handleLoadFileEvent(e:FileEvent):void
		{
			trace(e);
		}
		protected function handleFileLoaderEvent(e:FileLoaderEvent):void
		{
			trace(e);
		}
		
		
	}
}