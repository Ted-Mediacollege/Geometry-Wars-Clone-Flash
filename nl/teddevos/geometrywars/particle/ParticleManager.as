package  nl.teddevos.geometrywars.particle
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
	import nl.teddevos.geometrywars.data.Settings;
	
	public class ParticleManager extends DisplayObject
	{        
        private static const PROGRAM_NAME:String = "PART";
		
		private var mVertexBuffer:VertexBuffer3D;
        private var mIndexBuffer:IndexBuffer3D;
		private var mIndexData:Vector.<uint>;
		
		private var particle:Particle;
		
		public var particlesLength:int = 0; //max == 16383
		public var nextPool:int = 0;
		public var time:Number = 0;
		public var oldtime:Number = 0;
		public var ready:Boolean = false;
		public var paused:Boolean = false;
		
        private static var sHelperMatrix:Matrix = new Matrix();
        private static var sRenderAlpha:Vector.<Number> = new <Number>[1.0, 1.0, 1.0, 1.0];
        private static var sRenderMatrix:Matrix3D = new Matrix3D();
        private static var sProgramNameCache:Dictionary = new Dictionary();
		
		public var particleSetting:Number = 1;
		
		public var mVertexData:ParticleVertex;
		
		public function ParticleManager(q:Particle, len:int) 
		{
			particlesLength = len;
			
			particle = q;
			particle.x = 700;
			
			switch(Settings.PARTICLES)
			{
				case 1: particleSetting = 4; break;
				case 2: particleSetting = 2; break;
				case 3: particleSetting = 1.5; break;
				case 4: particleSetting = 1; break;
			}
			
			mVertexData = new ParticleVertex(particlesLength * 4, true);
			
			blendMode = blendMode ? blendMode : q.blendMode;
			mVertexData.setPremultipliedAlpha(q.premultipliedAlpha);
			//mVertexData.scaleAlpha(vertexID, alpha, 4);
			
			oldtime = new Date().time;
			
			for (var i:int = 0; i < particlesLength; i++ )
			{
				q.copyVertexDataTransformedTo(mVertexData, i * 4, q.transformationMatrix);
			}
			
			mIndexData = new Vector.<uint>(particlesLength*j);
			for (var j:int = 0; j < particlesLength; j++ )
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
			trace("created");
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
            
            mVertexBuffer = context.createVertexBuffer(numVertices, ParticleVertex.ELEMENTS_PER_VERTEX);
            mVertexBuffer.uploadFromVector(mVertexData.rawData, 0, numVertices);
			
            mIndexBuffer = context.createIndexBuffer(numIndices);
            mIndexBuffer.uploadFromVector(mIndexData, 0, numIndices);
        }
		
		public function createExplosion(posX:Number, posY:Number, amount:int, color:uint, minspeed:Number, randspeed:Number, rot:Number = 0, sprayWidth:Number = 180, skip:Number = 0):void
		{
			var vel:Number = 0;
			var r:Number = 0;
			amount = int(Math.ceil(amount / particleSetting));
			
			for (var i:int = 0; i < amount; i++)
			{
				r = rot - sprayWidth + (Math.random() * sprayWidth * 2);
				particle.x = posX;
				particle.y = posY;
				particle.rotation = r / 180 * Math.PI;
				particle.color = color;
				vel = minspeed + Math.random() * randspeed;
				setParticle(particle, Math.cos(r / 180 * Math.PI) * vel, Math.sin(r / 180 * Math.PI) * vel, time - skip);
			}
		}
		
		public function setParticle(p:Particle, vx:Number, vy:Number, age:Number):void
		{
			p.copyVertexDataTransformedTo(mVertexData, nextPool * 4, p.transformationMatrix, vx, vy, age);
			nextPool++;
			
			if (nextPool > particlesLength - 1)
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
            //if (resultRect == null) resultRect = new Rectangle(0,0,0,0);
            
            //var transformationMatrix:Matrix = targetSpace == this ?
            //    null : getTransformationMatrix(targetSpace, sHelperMatrix);
            
            return new Rectangle(0,0,0,0);// mVertexData.getBounds(transformationMatrix, 0, particlesLength * 4, resultRect);
        }
        
        public override function render(support:RenderSupport, parentAlpha:Number):void
        {
			support.finishQuadBatch();
			support.raiseDrawCount();
			renderCustom(support.mvpMatrix3D, alpha * parentAlpha, support.blendMode);
        }
		
		private function syncBuffers():void
		{
			mVertexBuffer.uploadFromVector(mVertexData.rawData, 0, (particlesLength - 1) * 4);
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
				context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 0, sRenderAlpha, 1);
				context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 1, mvpMatrix, true);
				
				if (!KeyInput.SPACE && !paused)
				{
					var newtime:Number = new Date().time;
					if (Settings.GLOW)
					{
						time += 14;
					}
					else
					{
						time += 28;
					}
					oldtime = newtime;
				}
				
				var a:Vector.<Number> = new <Number>[time, time, time, time];
				context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 5, a, 1);

				a = new <Number>[0.999, 0.999, 0.999, 0.999];
				context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 6, a, 1);
				
				a = new <Number>[900, 900, 900, 900];
				context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 7, a, 1);
				
				a = new <Number>[4, 4, 4, 4];
				context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 8, a, 1);
				
				a = new <Number>[25, 3, 0, 0];
				context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 9, a, 1);
				
				a = new <Number>[3, 25, 0, 0];
				context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 10, a, 1);
				
				a = new <Number>[850, 850, 850, 850];
				context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 11, a, 1);
				
				a = new <Number>[0, 0, 0, 1];
				context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 12, a, 1);
				
				context.setVertexBufferAt(0, mVertexBuffer, ParticleVertex.POSITION_OFFSET, Context3DVertexBufferFormat.FLOAT_2); 
				context.setVertexBufferAt(1, mVertexBuffer, ParticleVertex.COLOR_OFFSET, Context3DVertexBufferFormat.FLOAT_4);
				context.setVertexBufferAt(2, mVertexBuffer, ParticleVertex.VELOCITY_OFFSET, Context3DVertexBufferFormat.FLOAT_3);
				context.setVertexBufferAt(3, mVertexBuffer, ParticleVertex.SCALE_OFFSET1, Context3DVertexBufferFormat.FLOAT_2);
				context.setVertexBufferAt(4, mVertexBuffer, ParticleVertex.SCALE_OFFSET2, Context3DVertexBufferFormat.FLOAT_2);
				
				context.drawTriangles(mIndexBuffer, 0, particlesLength * 2);
				
				context.setVertexBufferAt(4, null);
				context.setVertexBufferAt(3, null);
				context.setVertexBufferAt(2, null);
				context.setVertexBufferAt(1, null);
				context.setVertexBufferAt(0, null);
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
                // va2 -> velocity
				//
				// vt0 -> age
				// vt1 -> temp pos
				// vt2 -> temp Vel
				//
                // vc0 -> alpha
                // vc1 -> mvpMatrix
				// vc5 -> time
				
				var vertexShader:String =
					"mov vt1, 		va0						\n" + // move origanal pos to temp
					"sub vt0,	 	vc5,		va2.z 		\n" + // calculate age
					"pow vt3.xy,	vc6.xy,		vt0.xy		\n" + // calculate pow
					"mul vt2.xy,	vt0.xy,		va2.xy		\n" + // calculate velocity
					"mul vt2.xy,	vt2.xy,		vt3.xy		\n" + // apply pow
					"add vt1.xy,	vt2.xy,		vt1.xy		\n" + // apply velocity
					
					"div vt3,		vt0,		vc7			\n" + // 0 - 1
					"neg vt3,		vt3						\n" + // negative
					"add vt3,		vt3,		vc6			\n" + // add 1 to neg
					"mul vt3,		vt3,		va2			\n" + // scale to vel
					
					"mul vt5.xy,	va3.xy,		vt3			\n" + // velocity width
					"mul vt5.xy,	vt5.xy,		vc9.xy		\n" + // multiply width
					
					"mul vt6.xy,	va4.xy,		vt3			\n" + // velocity width
					"mul vt6.xy,	vt6.xy,		vc10.xy		\n" + // multiply width
					
					"add vt1.xy,	vt1.xy,		vt5.xy		\n" + // add width
					"add vt1.xy,	vt1.xy,		vt6.xy		\n" + // add width
					
					"m44 op,		vt1,		vc1			\n" + // 4x4 matrix transform to output clipspace

					"mov vt4,		va1						\n" + // move color to temp
					"div vt4.a,		vt0.a,		vc11.a		\n" + // 0 - 1
					"neg vt5,		vt4						\n" + // negative
					"add vt5,		vt5,		vc6			\n" + // add 1 to neg
					"mul vt5,		vt5,		vc8			\n" + // add 1 to neg
					"min vt5,		vc12,		vt5			\n" + // max to 1
					"mov vt0.rgb,	va1.rgb					\n" + // restore rgb
					"add vt0.a,		vt0.a,		vt5.a		\n" + // restore a
					"mul v0,		vt0,		vc0			\n";  // multiply alpha (vc0) with color (va1)
				
				var fragmentShader:String =
					"mov oc, v0       \n";  // output color
				
                program = target.registerProgramFromSource(PROGRAM_NAME, vertexShader, fragmentShader);
            }
            return program;
        }
	}
}

/*


				var vertexShader:String =
					"mov vt1, 		va0						\n" + 
					"sub vt0,	 	vc5,		va2.z 		\n" + // Age
					"mul vt2.xy,	vt0.xy,		va2.xy		\n" + 
					"add vt1.xy,	vt2.xy,		vt1.xy		\n" + // velocity
					"m44 op,		vt1,		vc1			\n" + // 4x4 matrix transform to output clipspace
					"mul v0,		va1,		vc0			\n";  // multiply alpha (vc0) with color (va1)
				
				var fragmentShader:String =
					"mov oc, v0       \n";  // output color

					"mov vt4,		va1						\n" + // move color to temp
					"div vt4.a,		vt0.a,		vc7.a		\n" + // 0 - 1
					"neg vt5,		vt4						\n" + // negative
					"add vt5,		vt5,		vc6			\n" + // add 1 to neg
					"mul vt5,		vt5,		vc8			\n" + // add 1 to neg
					"mul v0,		vt5,		vc0			\n";  // multiply alpha (vc0) with color (va1)
*/