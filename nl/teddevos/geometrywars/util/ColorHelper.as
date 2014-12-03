package nl.teddevos.geometrywars.util 
{
	public class ColorHelper 
	{
		public static function HUEtoHEX(h:Number, s:Number, l:Number):uint
		{
			h = h / 360;
			var r:Number = 0;
			var g:Number = 0;
			var b:Number = 0;

			if(l==0)
			{
				r=g=b=0;
			}
			else
			{
				if(s == 0)
				{
					r=g=b=l;
				}
				else
				{
					var c2:Number = l <= 0.5 ? l * (1 + s) : l + s - (l * s);
					var c1:Number = 2 * l - c2;
					var c3:Vector.<Number> = new Vector.<Number>();
					c3.push(h+1/3);
					c3.push(h);
					c3.push(h-1/3);
					var col:Vector.<Number> = new Vector.<Number>();
					col.push(0);
					col.push(0);
					col.push(0);
					for(var i:int=0;i<3;i++)
					{
						if (c3[i] < 0)
						{
							c3[i] += 1;
						}
						if (c3[i] > 1)
						{
							c3[i] -= 1;
						}

						if (6 * c3[i] < 1)
						{
							col[i] = c1 + (c2 - c1) * c3[i] * 6;
						}
						else if (2 * c3[i] < 1)
						{
							col[i] = c2;
						}
						else if (3 * c3[i] < 2)
						{
							col[i] = (c1 + (c2 - c1) * ((2 / 3) - c3[i]) * 6);
						}
						else
						{
							col[i]= c1;
						}
						r=col[0];
						g=col[1];
						b=col[2];
					}
				}
			}
			return ((int(r * 255) << 16) | (int(g * 255) << 8) | int(b * 255));
		}
	}
}