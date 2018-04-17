package com.rll.net.util{
	
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	/**
	 * Util. Work wiht URL and GET params
	 * @author amatveev
	 **/
	public class URLUtil{
		/**
		 * Append GET var "nocache" to URL string
		 * @param url URL
		 * @return URL string whit appended GET var "nocache"
		 */
		public static function addNoChache(url:String):String{
			return addVariable(url, "nocache", String(new Date().time)) ;
		}
		/**
		 * Append GET var "v" to URL string
		 * @param url URL
		 * @param vaersion append GET value 
		 * @return URL string whit appended var
		 */
		public static function addQueryVersion(url:String, version:String):String{
			return addVariable(url, "v", version);
		}
		/**
		 * Append var to URL string
		 * @param url URL
		 * @param params - vars append to URL
		 * @param value value
		 * @return URL string whit apended var
		 */
		public static function addVariable(url:String, name:String, value:String):String{
			if(url.indexOf("?") == -1){
				url += "?" + name + "=" + value;
			}else{
				url += "&" + name + "=" + value;
			}			
			return url;
		}
		/**
		 * Append vars to URL
		 * @param url URL
		 * @param params - vars append to URL
		 * @return URL with appended params
		 */
		public static function addVariables(url:String, params:Object):String{
			if(!params){return url;}
			for(var key:String in params){
				url = addVariable(url,key, params[key]);
			}
			return url;
		}
		/**
		 * Extract GET vars from URL
		 * @return Object whit GET vars
		 */
		public static function getParams(url:String):Object{
			var result:Object = {}, i:int=0, vars:String, arr:Array, p:Array;	
			if (url.indexOf("?") < 0) {	return result;}
			
			vars = url.substring(url.indexOf("?") + 1);
			arr = vars.split("&");
			if (!arr || !arr.length) { return result; }
			for (i = 0; i < arr.length; ++i) {
				p = arr[i].split("=");
				result[p[0]] = p[1];
			}
			return result;
		}
		/**
		 * Open new page/tab in browser
		 * @param url URL
		 * @param window type of window
		 */
		public static function goToURL(url:String, window:String='_blank'):void{
			navigateToURL(new URLRequest(url),window);
		}
		/**
		 * Extract file from file/resorce path
		 * @param url URL
		 * @return file name
		 */
		public static function getFileName(url:String):String {
			var patern:RegExp = /(?<=\/)(\w+)((\.\w+(?=\?))|(\.\w+)$)/g;
			return url.match(patern)[0];
		}
	}
}