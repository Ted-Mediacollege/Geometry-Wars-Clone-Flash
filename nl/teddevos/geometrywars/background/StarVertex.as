package nl.teddevos.geometrywars.background
{
    import flash.geom.Matrix;
    import flash.geom.Matrix3D;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.geom.Vector3D;
	import starling.utils.MatrixUtil;
	import starling.utils.MathUtil;
	
    public class StarVertex 
    {
        public static const ELEMENTS_PER_VERTEX:int = 7;
        public static const POSITION_OFFSET:int = 0; 		//x, y
        public static const COLOR_OFFSET:int = 2;			//r, g, b, a
        public static const DEPTH_OFFSET:int = 6;			//d
        
        private var mRawData:Vector.<Number>;
        private var mPremultipliedAlpha:Boolean;
        private var mNumVertices:int;

        private static var sHelperPoint:Point = new Point();
        private static var sHelperPoint3D:Vector3D = new Vector3D();
        private static var sHelperRect:Rectangle = new Rectangle();
        
        public function StarVertex(length:int, premultipliedAlpha:Boolean=false)
        {
            mRawData = new <Number>[];
            mPremultipliedAlpha = premultipliedAlpha;
            numVertices = length;
        }

        public function copyTo(targetData:StarVertex, targetVertexID:int=0, vertexID:int=0, numVertices:int=-1):void
        {
            copyTransformedTo(targetData, targetVertexID, null, vertexID, numVertices);
        }
        
        public function copyTransformedTo(targetData:StarVertex, targetVertexID:int=0, matrix:Matrix=null, vertexID:int=0, numVertices:int=-1, depth:Number = 1):void
        {
            if (numVertices < 0 || vertexID + numVertices > mNumVertices)
			{
                numVertices = mNumVertices - vertexID;
			}
            
            var x:Number, y:Number, w:Number, h:Number;
            var targetRawData:Vector.<Number> = targetData.mRawData;
            var targetIndex:int = targetVertexID * ELEMENTS_PER_VERTEX;
            var sourceIndex:int = vertexID * ELEMENTS_PER_VERTEX;
            var sourceEnd:int = (vertexID + numVertices) * ELEMENTS_PER_VERTEX;
			var count:int = 0;
			
            if (matrix)
            {
                while (sourceIndex < sourceEnd)
                {	
                    x = mRawData[int(sourceIndex++)];
                    y = mRawData[int(sourceIndex++)];

                    targetRawData[int(targetIndex++)] = matrix.a * x + matrix.c * y + matrix.tx;
                    targetRawData[int(targetIndex++)] = matrix.d * y + matrix.b * x + matrix.ty;
                    targetRawData[int(targetIndex++)] = mRawData[int(sourceIndex++)]; //r
                    targetRawData[int(targetIndex++)] = mRawData[int(sourceIndex++)]; //g
                    targetRawData[int(targetIndex++)] = mRawData[int(sourceIndex++)]; //b
                    targetRawData[int(targetIndex++)] = mRawData[int(sourceIndex++)]; //a
                    targetRawData[int(targetIndex++)] = depth; sourceIndex++; //depth
					count++;
                }
            }
            else
            {
                while (sourceIndex < sourceEnd)
                    targetRawData[int(targetIndex++)] = mRawData[int(sourceIndex++)];
            }
        }
        
        public function append(data:StarVertex):void
        {
            mRawData.fixed = false;
            
            var targetIndex:int = mRawData.length;
            var rawData:Vector.<Number> = data.mRawData;
            var rawDataLength:int = rawData.length;
            
            for (var i:int=0; i<rawDataLength; ++i)
                mRawData[int(targetIndex++)] = rawData[i];
            
            mNumVertices += data.numVertices;
            mRawData.fixed = true;
        }
        
        public function setPosition(vertexID:int, x:Number, y:Number):void
        {
            var offset:int = vertexID * ELEMENTS_PER_VERTEX + POSITION_OFFSET;
            mRawData[offset] = x;
            mRawData[int(offset+1)] = y;
        }
        
        public function getPosition(vertexID:int, position:Point):void
        {
            var offset:int = vertexID * ELEMENTS_PER_VERTEX + POSITION_OFFSET;
            position.x = mRawData[offset];
            position.y = mRawData[int(offset+1)];
        }
        
        /** Updates the RGB color and alpha value of a vertex in one step. */
        public function setColorAndAlpha(vertexID:int, color:uint, alpha:Number):void
        {
            if (alpha < 0.001)    alpha = 0.001; // zero alpha would wipe out all color data
            else if (alpha > 1.0) alpha = 1.0;
            
            var offset:int = vertexID * ELEMENTS_PER_VERTEX + COLOR_OFFSET;
            var multiplier:Number = mPremultipliedAlpha ? alpha : 1.0;
            
            mRawData[offset]        = ((color >> 16) & 0xff) / 255.0 * multiplier;
            mRawData[int(offset+1)] = ((color >>  8) & 0xff) / 255.0 * multiplier;
            mRawData[int(offset+2)] = ( color        & 0xff) / 255.0 * multiplier;
            mRawData[int(offset+3)] = alpha;
        }
        
        /** Updates the RGB color values of a vertex (alpha is not changed). */
        public function setColor(vertexID:int, color:uint):void
        {
            var offset:int = vertexID * ELEMENTS_PER_VERTEX + COLOR_OFFSET;
            var multiplier:Number = mPremultipliedAlpha ? mRawData[int(offset+3)] : 1.0;
            mRawData[offset]        = ((color >> 16) & 0xff) / 255.0 * multiplier;
            mRawData[int(offset+1)] = ((color >>  8) & 0xff) / 255.0 * multiplier;
            mRawData[int(offset+2)] = ( color        & 0xff) / 255.0 * multiplier;
        }
        
        /** Returns the RGB color of a vertex (no alpha). */
        public function getColor(vertexID:int):uint
        {
            var offset:int = vertexID * ELEMENTS_PER_VERTEX + COLOR_OFFSET;
            var divisor:Number = mPremultipliedAlpha ? mRawData[int(offset+3)] : 1.0;
            
            if (divisor == 0) return 0;
            else
            {
                var red:Number   = mRawData[offset]        / divisor;
                var green:Number = mRawData[int(offset+1)] / divisor;
                var blue:Number  = mRawData[int(offset+2)] / divisor;
                
                return (int(red*255) << 16) | (int(green*255) << 8) | int(blue*255);
            }
        }
        
        /** Updates the alpha value of a vertex (range 0-1). */
        public function setAlpha(vertexID:int, alpha:Number):void
        {
            if (mPremultipliedAlpha)
                setColorAndAlpha(vertexID, getColor(vertexID), alpha);
            else
                mRawData[int(vertexID * ELEMENTS_PER_VERTEX + COLOR_OFFSET + 3)] = alpha;
        }
        
        /** Returns the alpha value of a vertex in the range 0-1. */
        public function getAlpha(vertexID:int):Number
        {
            var offset:int = vertexID * ELEMENTS_PER_VERTEX + COLOR_OFFSET + 3;
            return mRawData[offset];
        }
        
        // utility functions
        
        /** Translate the position of a vertex by a certain offset. */
        public function translateVertex(vertexID:int, deltaX:Number, deltaY:Number):void
        {
            var offset:int = vertexID * ELEMENTS_PER_VERTEX + POSITION_OFFSET;
            mRawData[offset]        += deltaX;
            mRawData[int(offset+1)] += deltaY;
        }

        /** Transforms the position of subsequent vertices by multiplication with a 
         *  transformation matrix. */
        public function transformVertex(vertexID:int, matrix:Matrix, numVertices:int=1):void
        {
            var x:Number, y:Number;
            var offset:int = vertexID * ELEMENTS_PER_VERTEX + POSITION_OFFSET;
            
            for (var i:int=0; i<numVertices; ++i)
            {
                x = mRawData[offset];
                y = mRawData[int(offset+1)];
                
                mRawData[offset]        = matrix.a * x + matrix.c * y + matrix.tx;
                mRawData[int(offset+1)] = matrix.d * y + matrix.b * x + matrix.ty;
                
                offset += ELEMENTS_PER_VERTEX;
            }
        }
        
        /** Sets all vertices of the object to the same color values. */
        public function setUniformColor(color:uint):void
        {
            for (var i:int=0; i<mNumVertices; ++i)
                setColor(i, color);
        }
        
        /** Sets all vertices of the object to the same alpha values. */
        public function setUniformAlpha(alpha:Number):void
        {
            for (var i:int=0; i<mNumVertices; ++i)
                setAlpha(i, alpha);
        }
        
        /** Multiplies the alpha value of subsequent vertices with a certain factor. */
        public function scaleAlpha(vertexID:int, factor:Number, numVertices:int=1):void
        {
            if (factor == 1.0) return;
            if (numVertices < 0 || vertexID + numVertices > mNumVertices)
                numVertices = mNumVertices - vertexID;
             
            var i:int;
            
            if (mPremultipliedAlpha)
            {
                for (i=0; i<numVertices; ++i)
                    setAlpha(vertexID+i, getAlpha(vertexID+i) * factor);
            }
            else
            {
                var offset:int = vertexID * ELEMENTS_PER_VERTEX + COLOR_OFFSET + 3;
                for (i=0; i<numVertices; ++i)
                    mRawData[int(offset + i*ELEMENTS_PER_VERTEX)] *= factor;
            }
        }
        
        /** Calculates the bounds of the vertices, which are optionally transformed by a matrix. 
         *  If you pass a 'resultRect', the result will be stored in this rectangle 
         *  instead of creating a new object. To use all vertices for the calculation, set
         *  'numVertices' to '-1'. */
        public function getBounds(transformationMatrix:Matrix=null, 
                                  vertexID:int=0, numVertices:int=-1,
                                  resultRect:Rectangle=null):Rectangle
        {
            if (resultRect == null) resultRect = new Rectangle();
            if (numVertices < 0 || vertexID + numVertices > mNumVertices)
                numVertices = mNumVertices - vertexID;
            
            if (numVertices == 0)
            {
                if (transformationMatrix == null)
                    resultRect.setEmpty();
                else
                {
                    MatrixUtil.transformCoords(transformationMatrix, 0, 0, sHelperPoint);
                    resultRect.setTo(sHelperPoint.x, sHelperPoint.y, 0, 0);
                }
            }
            else
            {
                var minX:Number = Number.MAX_VALUE, maxX:Number = -Number.MAX_VALUE;
                var minY:Number = Number.MAX_VALUE, maxY:Number = -Number.MAX_VALUE;
                var offset:int = vertexID * ELEMENTS_PER_VERTEX + POSITION_OFFSET;
                var x:Number, y:Number, i:int;
                
                if (transformationMatrix == null)
                {
                    for (i=0; i<numVertices; ++i)
                    {
                        x = mRawData[offset];
                        y = mRawData[int(offset+1)];
                        offset += ELEMENTS_PER_VERTEX;
                        
                        if (minX > x) minX = x;
                        if (maxX < x) maxX = x;
                        if (minY > y) minY = y;
                        if (maxY < y) maxY = y;
                    }
                }
                else
                {
                    for (i=0; i<numVertices; ++i)
                    {
                        x = mRawData[offset];
                        y = mRawData[int(offset+1)];
                        offset += ELEMENTS_PER_VERTEX;
                        
                        MatrixUtil.transformCoords(transformationMatrix, x, y, sHelperPoint);
                        
                        if (minX > sHelperPoint.x) minX = sHelperPoint.x;
                        if (maxX < sHelperPoint.x) maxX = sHelperPoint.x;
                        if (minY > sHelperPoint.y) minY = sHelperPoint.y;
                        if (maxY < sHelperPoint.y) maxY = sHelperPoint.y;
                    }
                }
                
                resultRect.setTo(minX, minY, maxX - minX, maxY - minY);
            }
            
            return resultRect;
        }
        
        /** Calculates the bounds of the vertices, projected into the XY-plane of a certain
         *  3D space as they appear from a certain camera position. Note that 'camPos' is expected
         *  in the target coordinate system (the same that the XY-plane lies in).
         *  If you pass a 'resultRectangle', the result will be stored in this rectangle
         *  instead of creating a new object. To use all vertices for the calculation, set
         *  'numVertices' to '-1'. */
        public function getBoundsProjected(transformationMatrix:Matrix3D, camPos:Vector3D,
                                           vertexID:int=0, numVertices:int=-1,
                                           resultRect:Rectangle=null):Rectangle
        {
            if (camPos == null) throw new ArgumentError("camPos must not be null");
            if (resultRect == null) resultRect = new Rectangle();
            if (numVertices < 0 || vertexID + numVertices > mNumVertices)
                numVertices = mNumVertices - vertexID;

            if (numVertices == 0)
            {
                if (transformationMatrix)
                    MatrixUtil.transformCoords3D(transformationMatrix, 0, 0, 0, sHelperPoint3D);
                else
                    sHelperPoint3D.setTo(0, 0, 0);

                MathUtil.intersectLineWithXYPlane(camPos, sHelperPoint3D, sHelperPoint);
                resultRect.setTo(sHelperPoint.x, sHelperPoint.y, 0, 0);
            }
            else
            {
                var minX:Number = Number.MAX_VALUE, maxX:Number = -Number.MAX_VALUE;
                var minY:Number = Number.MAX_VALUE, maxY:Number = -Number.MAX_VALUE;
                var offset:int = vertexID * ELEMENTS_PER_VERTEX + POSITION_OFFSET;
                var x:Number, y:Number, i:int;

                for (i=0; i<numVertices; ++i)
                {
                    x = mRawData[offset];
                    y = mRawData[int(offset+1)];
                    offset += ELEMENTS_PER_VERTEX;

                    if (transformationMatrix)
                        MatrixUtil.transformCoords3D(transformationMatrix, x, y, 0, sHelperPoint3D);
                    else
                        sHelperPoint3D.setTo(x, y, 0);

                    MathUtil.intersectLineWithXYPlane(camPos, sHelperPoint3D, sHelperPoint);

                    if (minX > sHelperPoint.x) minX = sHelperPoint.x;
                    if (maxX < sHelperPoint.x) maxX = sHelperPoint.x;
                    if (minY > sHelperPoint.y) minY = sHelperPoint.y;
                    if (maxY < sHelperPoint.y) maxY = sHelperPoint.y;
                }
                resultRect.setTo(minX, minY, maxX - minX, maxY - minY);
            }
            return resultRect;
        }

        /** Creates a string that contains the values of all included vertices. */
        public function toString():String
        {
            var result:String = "[StarVertex \n";
            var position:Point = new Point();
            
            for (var i:int=0; i<numVertices; ++i)
            {
                getPosition(i, position);
                
                result += "  [Vertex " + i + ": " +
                    "x="   + position.x.toFixed(1)    + ", " +
                    "y="   + position.y.toFixed(1)    + ", " +
                    "rgb=" + getColor(i).toString(16) + ", " +
                    "a="   + getAlpha(i).toFixed(2)   + ", "
                    (i == numVertices-1 ? "\n" : ",\n");
            }
            
            return result + "]";
        }
        
        // properties
        
        /** Indicates if any vertices have a non-white color or are not fully opaque. */
        public function get tinted():Boolean
        {
            var offset:int = COLOR_OFFSET;
            
            for (var i:int=0; i<mNumVertices; ++i)
            {
                for (var j:int=0; j<4; ++j)
                    if (mRawData[int(offset+j)] != 1.0) return true;

                offset += ELEMENTS_PER_VERTEX;
            }
            
            return false;
        }
        
        /** Changes the way alpha and color values are stored. Optionally updates all exisiting 
         *  vertices. */
        public function setPremultipliedAlpha(value:Boolean, updateData:Boolean=true):void
        {
            if (value == mPremultipliedAlpha) return;
            
            if (updateData)
            {
                var dataLength:int = mNumVertices * ELEMENTS_PER_VERTEX;
                
                for (var i:int=COLOR_OFFSET; i<dataLength; i += ELEMENTS_PER_VERTEX)
                {
                    var alpha:Number = mRawData[int(i+3)];
                    var divisor:Number = mPremultipliedAlpha ? alpha : 1.0;
                    var multiplier:Number = value ? alpha : 1.0;
                    
                    if (divisor != 0)
                    {
                        mRawData[i]        = mRawData[i]        / divisor * multiplier;
                        mRawData[int(i+1)] = mRawData[int(i+1)] / divisor * multiplier;
                        mRawData[int(i+2)] = mRawData[int(i+2)] / divisor * multiplier;
                    }
                }
            }
            
            mPremultipliedAlpha = value;
        }
        
       /** Indicates if the rgb values are stored premultiplied with the alpha value.
        *  If you change this value, the color data is updated accordingly. If you don't want
        *  that, use the 'setPremultipliedAlpha' method instead. */
        public function get premultipliedAlpha():Boolean { return mPremultipliedAlpha; }
        public function set premultipliedAlpha(value:Boolean):void
        {
            setPremultipliedAlpha(value);
        }
        
        /** The total number of vertices. */
        public function get numVertices():int { return mNumVertices; }
        public function set numVertices(value:int):void
        {
            mRawData.fixed = false;
            mRawData.length = value * ELEMENTS_PER_VERTEX;
            
            var startIndex:int = mNumVertices * ELEMENTS_PER_VERTEX + COLOR_OFFSET + 3;
            var endIndex:int = mRawData.length;
            
            for (var i:int=startIndex; i<endIndex; i += ELEMENTS_PER_VERTEX)
                mRawData[i] = 1.0; // alpha should be '1' per default
            
            mNumVertices = value;
            mRawData.fixed = true;
        }
        
        /** The raw vertex data; not a copy! */
        public function get rawData():Vector.<Number> { return mRawData; }
    }
}