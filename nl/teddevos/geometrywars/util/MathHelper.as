package nl.teddevos.geometrywars.util
{
	import flash.geom.Point;
	
	public class MathHelper 
	{
		public static function nextInt(max:int):int 
		{
			return Math.floor(Math.random() * max)
		}
		
		public static function nextNumber(max:Number):Number 
		{
			return Math.random() * max;
		}
		
		public static function rangeInt(min:int, max:int):int 
		{
			return min + Math.floor(Math.random() * (max - min));
		}
		
		public static function rangeNumber(min:Number, max:Number):Number 
		{
			return min + (Math.random() * (max - min));
		}
		
		public static function cos(direction:Number):Number 
		{
  			return Math.cos(direction * Math.PI / 180.0);
		}
		
		public static function sin(direction:Number):Number 
		{
   			return Math.sin(direction * Math.PI / 180.0);
 		}
		
		public static function dis(n1:Number, n2:Number):Number 
		{
   			return Math.sqrt((n1-n2)*(n1-n2));
  		}
		
		public static function dis2(x1:Number, y1:Number, x2:Number, y2:Number):Number 
		{
   			return Math.sqrt((x1-x2)*(x1-x2) + (y1-y2)*(y1-y2));
  		}
		
		public static function dis3(x1:Number, y1:Number, z1:Number, x2:Number, y2:Number, z2:Number):Number 
		{
   			return Math.sqrt((x1-x2)*(x1-x2) + (y1-y2)*(y1-y2) + (z1-z2)*(z1-z2));
  		}
		
		public static function pointToDegree(x1:Number, y1:Number, x2:Number, y2:Number):Number 
		{
   			return Math.atan2((y2 - y1), (x2 - x1)) * 180 / Math.PI;
  		}
	}
}