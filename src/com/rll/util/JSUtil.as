package com.rll.util
{
	import flash.external.ExternalInterface;
	
	/**
	 * Util external intafce JS(JavaScript) 
	 * 
	 */
	public class JSUtil
	{
		
		public static const EVAL_LITERAL:String = "eval";
		
		/**
		 * Call JS function/class method
		 * @param fName name of JS function/method
		 * @param args  function argumetns 
		 * @return reslt JS method
		 */
		public static function call(fName:String, ...args):*{
			var params:String = fName + '(';
			
			for(var i:int = 0, len:int = args.length; i < len; ++i)
			{
				
				if(i > 0){params+=',';}
				
				params+= JSON.stringify(args[i]);
				
			}
			params+=')';
			
			return exec(params);
		}
		/**
		 * Append external callBack
		 * @param fName  function name
		 * @param handle function for handle
		 * @return true/false or Error object instance
		 */
		public static function addCallback(fName:String, handler:Function):*{
			if(ExternalInterface.available){
				try{
					ExternalInterface.addCallback(fName, handler);
					return true;
				}catch(e:Error){
					trace(e);
					return e;
				}
			}
			
			return false;
		}
		/**
		 * Execute JS(JavaScript) code
		 * @param script text of JS script
		 * @return result JS method or srting (ExternalInterface not available) or Error object instance
		 */
		public static function exec(script:String):*{
			if(ExternalInterface.available){
				try{
					return ExternalInterface.call(EVAL_LITERAL, script);
				}catch(e:Error){
					trace(e);
					return e;
				}
			}
			return "ExternalInterface not available"; 
			
		}
		/**
		 * Get cookie
		 * @param name name of field
		 */
		public static function getBrowserCookie(name:String):Object{
			var cookie:String = " " + exec("document.cookie;");
			var search:String = "" + name + "=";
			var setStr:String = null;
			var offset:int = 0;
			var end:int = 0;
			if (cookie.length > 0) {
				offset = cookie.indexOf(search);
				if (offset != -1) {
					offset += search.length;
					end = cookie.indexOf(";", offset)
					if (end == -1) {
						end = cookie.length;
					}
					setStr = unescape(cookie.substring(offset, end));
				}
			}
			return(setStr);
		}
		/**
		 * Set cookie
		 * @param name name of field
		 * @param value value of field
		 * @param delta  время в часах
		 * @param domain name of domain (scope) 
		 **/
		public static function setBrowserCookie(name:String, value:Object, delta:int, domain:String=null):void{
			var newCookie:String = name + "=" + value, domain:String = (domain ? domain : "");
			var s:String = "var d = new Date(); d.setTime(d.getTime() +" + delta + "*24*60*60*100); document.cookie='" + newCookie + "; path=/; domain=" + domain + "; expires='+d.toGMTString()+';';";
			
			exec(s);
		}
		/**
		 * Set cookie form AS3 object
		 * @param delta  время в часах
		 * @param domain name of domain (scope) 
		 **/
		public static function setBrowserCookieFromObject(data:Object, delta:int, domain:String = null):void{
			for(var key:String  in data)
			{
				setBrowserCookie(key, data[key], delta, domain);
			}
		}
		
	}
}