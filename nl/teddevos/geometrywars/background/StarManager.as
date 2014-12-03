package nl.teddevos.geometrywars.background
{
	import starling.core.Starling;
	import flash.display3D.Program3D;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.Context3D;
	import starling.errors.MissingContextError;
	import starling.core.RenderSupport;
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import flash.display3D.IndexBuffer3D;
	import flash.utils.Dictionary;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.Context3DBufferUsage;
	import nl.teddevos.geometrywars.input.KeyInput;
	
	public class StarManager extends DisplayObject
	{        
        private static const PROGRAM_NAME:String = "STAR";
		
		private var mVertexBuffer:VertexBuffer3D;
        private var mIndexBuffer:IndexBuffer3D;
		private var mIndexData:Vector.<uint>;
		
		private var star:Star;
		
		public var cameraX:Number = 0;
		public var cameraY:Number = 0;
		
		public var starsLength:int = 0; //max == 16383
		public var nextPool:int = 0;
		public var ready:Boolean = false;
		
        private static var sHelperMatrix:Matrix = new Matrix();
        private static var sRenderAlpha:Vector.<Number> = new <Number>[1.0, 1.0, 1.0, 1.0];
        private static var sRenderMatrix:Matrix3D = new Matrix3D();
        private static var sProgramNameCache:Dictionary = new Dictionary();
		
		public var mVertexData:StarVertex;
		
		private var offsetX:Number;
		private var offsetY:Number;
		
		public function StarManager(offX:Number, offY:Number) 
		{
			offsetX = offX;
			offsetY = offY;
			
			starsLength = 500;
			var s:Star = new Star(4, 4, 0xFFFFFF);
			s.x = 1500;
			star = s;
			
			mVertexData = new StarVertex(starsLength * 4, true);
			
			blendMode = blendMode ? blendMode : s.blendMode;
			mVertexData.setPremultipliedAlpha(s.premultipliedAlpha);
			//mVertexData.scaleAlpha(vertexID, alpha, 4);

			for (var i:int = 0; i < starsLength; i++ )
			{
				s.copyVertexDataTransformedTo(mVertexData, i * 4, s.transformationMatrix);
			}
			
			mIndexData = new Vector.<uint>(starsLength*j);
			for (var j:int = 0; j < starsLength; j++ )
			{
                mIndexData[int(j*6  )] = j*4;
                mIndexData[int(j*6+1)] = j*4 + 1;
                mIndexData[int(j*6+2)] = j*4 + 2;
                mIndexData[int(j*6+3)] = j*4 + 1;
                mIndexData[int(j*6+4)] = j*4 + 3;
                mIndexData[int(j*6+5)] = j*4 + 2;
			}
			
			Starling.current.stage3D.addEventListener(Event.CONTEXT3D_CREATE, onContextCreated, false, 1, true);
			
			touchable = false;
			createBuffers();
			
			var dep:Number = 0;
			var w:Number = offsetX;
			var h:Number = offsetX;
			for (var p:int = 0; p < 500; p++ )
			{
				dep = 1.2 + Math.random() * 4;
				star.x = (-w + Math.random() * w * 2) * (dep / 2);
				star.y = (-h + Math.random() * h * 2) * (dep / 2);
				star.scaleX = 1 / (dep / 1.5);
				star.scaleY = 1 / (dep / 1.5); 
				setStar(star, dep);
			}
		}
		
		public override function dispose():void
        {
            Starling.current.stage3D.removeEventListener(Event.CONTEXT3D_CREATE, onContextCreated);
            destroyBuffers();
            
			ready = false;
			
            super.dispose();
        }
        
        private function onContextCreated(event:Object):void
        {
			trace("created star manager");
            createBuffers();
        }
		
		public function createBuffers():void
        {
            destroyBuffers();
			
			ready = true;
			
            var numVertices:int = mVertexData.numVertices;
			var numIndices:int = mIndexData.length;
            var context:Context3D = Starling.context;
			
            if (context == null)  throw new MissingContextError();
            
            mVertexBuffer = context.createVertexBuffer(numVertices, StarVertex.ELEMENTS_PER_VERTEX);
            mVertexBuffer.uploadFromVector(mVertexData.rawData, 0, numVertices);
			
            mIndexBuffer = context.createIndexBuffer(numIndices);
            mIndexBuffer.uploadFromVector(mIndexData, 0, numIndices);
        }
		
		public function setStar(p:Star, depth:Number):void
		{
			p.copyVertexDataTransformedTo(mVertexData, nextPool * 4, p.transformationMatrix, depth);
			nextPool++;
			
			if (nextPool > starsLength - 1)
			{
				nextPool = 0;
			}
		}
        
        private function destroyBuffers():void
        {
            if (mVertexBuffer)
            {
                mVertexBuffer.dispose();
                mVertexBuffer = null;
            }

            if (mIndexBuffer)
            {
                mIndexBuffer.dispose();
                mIndexBuffer = null;
            }
        }
		
		public override function getBounds(targetSpace:DisplayObject, resultRect:Rectangle=null):Rectangle
        {
            return new Rectangle(0,0,0,0);
        }
        
        public override function render(support:RenderSupport, parentAlpha:Number):void
        {
			support.finishQuadBatch();
			support.raiseDrawCount();
			renderCustom(support.mvpMatrix3D, alpha * parentAlpha, support.blendMode);
        }
		
		private function syncBuffers():void
		{
			mVertexBuffer.uploadFromVector(mVertexData.rawData, 0, (starsLength - 1) * 4);
		}
		
		public function renderCustom(mvpMatrix:Matrix3D, parentAlpha:Number=1.0, blendMode:String=null):void
        {
			if (ready)
			{
				syncBuffers();
				
				var pma:Boolean = mVertexData.premultipliedAlpha;
				var context:Context3D = Starling.context;
				var tinted:Boolean = true;
				
				sRenderAlpha[0] = sRenderAlpha[1] = sRenderAlpha[2] = pma ? parentAlpha : 1.0;
				sRenderAlpha[3] = parentAlpha;
				
				RenderSupport.setBlendFactors(pma, blendMode ? blendMode : this.blendMode);
				
				context.setProgram(getProgram(tinted));
				context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 5, sRenderAlpha, 1);
				context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 6, mvpMatrix, true);

				var a:Vector.<Number> = new <Number>[-cameraX, -cameraY, 0, 0];
				context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 15, a, 1);
				
				a = new <Number>[offsetX, offsetY, 0, 0];
				context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 14, a, 1);
				
				context.setVertexBufferAt(5, mVertexBuffer, StarVertex.POSITION_OFFSET, Context3DVertexBufferFormat.FLOAT_2); 
				context.setVertexBufferAt(6, mVertexBuffer, StarVertex.COLOR_OFFSET, Context3DVertexBufferFormat.FLOAT_4);
				context.setVertexBufferAt(7, mVertexBuffer, StarVertex.DEPTH_OFFSET, Context3DVertexBufferFormat.FLOAT_1);
				
				context.drawTriangles(mIndexBuffer, 0, starsLength * 2);
				
				context.setVertexBufferAt(7, null);
				context.setVertexBufferAt(6, null);
				context.setVertexBufferAt(5, null);
			}
        }
		
		private function getProgram(tinted:Boolean):Program3D
        {
            var target:Starling = Starling.current;
            var program:Program3D = target.getProgram(PROGRAM_NAME);
            
            if (!program)
            {
                // va0 -> position
                // va1 -> color
                // va2 -> depth
				//
                // vc0 -> alpha
                // vc1 -> mvpMatrix
				// vc5 -> cameraXY
				// vc6 -> 
				
				var vertexShader:String =
					"mov vt0,		va5						\n" +
					"div vt1.xy,	vc15.xy,	va7.xx		\n" +
					"add vt0.xy,	vt0.xy,		vt1.xy		\n" + 
					"add vt0.xy,	vt0.xy,		vc14.xy		\n" + 
					"m44 op,		vt0,		vc1 		\n" + 
					"mul v0,		va6,		vc0 		\n"; 
				
				var fragmentShader:String =
					"mov oc, v0       \n";  
				
                program = target.registerProgramFromSource(PROGRAM_NAME, vertexShader, fragmentShader);
            }
            return program;
        }
	}
}