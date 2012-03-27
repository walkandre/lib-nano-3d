package nano.renderer{
	
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import nano.geom.Face;
	import nano.geom.Vertex;
	import nano.material.BitmapMaterial;
	import nano.material.Material;
	import nano.objects.Object3D;
	import nano.objects.PointCamera;
	
	public class Renderer {
		public var stage:Sprite;
		public var drawStage:Sprite;
		public var facesTotal:int = 0;
		public var meshesTotal:int = 0;
		private var meshToStage:Dictionary;
		
		public function Renderer(stage:Sprite) {
			this.stage = stage;
			drawStage = this.stage.addChild(new Sprite()) as Sprite;
			meshToStage = new Dictionary(true);
		}
		
		public function project(meshList:Array, cam:PointCamera, dontZSort:Boolean = false):Array {
			facesTotal = 0;
			meshesTotal = meshList.length;
			// cam rotation
			var cosZ:Number = Math.cos(cam.rotationZ);
			var sinZ:Number = Math.sin(cam.rotationZ);
			var cosY:Number = Math.cos(cam.rotationY);
			var sinY:Number = Math.sin(cam.rotationY);
			var cosX:Number = Math.cos(cam.rotationX);
			var sinX:Number = Math.sin(cam.rotationX);
			// local rotation
			var cosZMesh:Number;
			var sinZMesh:Number;
			var cosYMesh:Number;
			var sinYMesh:Number;
			var cosXMesh:Number;
			var sinXMesh:Number;
			var i:int = meshList.length;
			var j:int;
			var curMesh:Object3D;
			var curVertex:Vertex;
			var x:Number;
			var y:Number;
			var x1:Number;
			var x2:Number;
			var x3:Number;
			var x4:Number;
			var y1:Number;
			var y2:Number;
			var y3:Number;
			var y4:Number;
			var z1:Number;
			var z2:Number;
			var z3:Number;
			var z4:Number;
			var scale:Number;
			var faceList:Array = [];
			var vertexList:Array = [];
			while(--i > -1){ 
				curMesh = meshList[i];
				faceList = faceList.concat(curMesh.faceList);
				vertexList = curMesh.vertexList;
				j = vertexList.length;
				cosZMesh = Math.cos(curMesh.rotationZ);
				sinZMesh = Math.sin(curMesh.rotationZ);
				cosYMesh = Math.cos(curMesh.rotationY);
				sinYMesh = Math.sin(curMesh.rotationY);
				cosXMesh = Math.cos(curMesh.rotationX);
				sinXMesh = Math.sin(curMesh.rotationX);
				while(--j > -1){
					curVertex = vertexList[j];
					x1 = (curVertex.x * curMesh.scaleX) * cosZMesh - (curVertex.y * curMesh.scaleY) * sinZMesh;
					y1 = (curVertex.y * curMesh.scaleY) * cosZMesh + (curVertex.x * curMesh.scaleX) * sinZMesh;
					x2 = x1 * cosYMesh - (curVertex.z * curMesh.scaleZ) * sinYMesh;
					z1 = (curVertex.z * curMesh.scaleZ) * cosYMesh + x1 * sinYMesh;
					y2 = y1 * cosXMesh - z1 * sinXMesh;
					z2 = z1 * cosXMesh + y1 * sinXMesh;
					x2 += curMesh.x;
					y2 += curMesh.y;
					z2 += curMesh.z;
					x2 -= cam.x;
					y2 -= cam.y;
					z2 -= cam.z;
					x3 = x2 * cosZ - y2 * sinZ;
					y3 = y2 * cosZ + x2 * sinZ;
					x4 = x3 * cosY - z2 * sinY;
					z3 = z2 * cosY + x3 * sinY;
					y4 = y3 * cosX - z3 * sinX;
					z4 = z3 * cosX + y3 * sinX;
					scale = cam.fl / (cam.fl + z4 + cam.zOffset);
					x = cam.vpX + x4 * scale;
					y = cam.vpY + y4 * scale;
					curVertex.screenX = x;
					curVertex.screenY = y;
					curVertex.scale = scale;
					curVertex.x3d = x4;
					curVertex.y3d = y4;
					curVertex.z3d = z4;
				}
			}
			if(!dontZSort){
				faceList = faceList.sort(faceZSort);
			}
			return faceList;
		}
		
		public function render(meshList:Array, cam:PointCamera):void {
			var faceList:Array = project(meshList, cam);
			var curStageGfx:Graphics;
			var curFace:Face;
			var curMaterial:Material;
			var curColor:uint;
			var faceIndex:int = 0;
			var thickness:Number;
			clearStage(drawStage);
			facesTotal = faceList.length;
			for(faceIndex = 0; faceIndex < facesTotal; faceIndex++){
				curFace = faceList[faceIndex];
				curMaterial = curFace.material;
				if ((curMaterial.doubleSided ||  
					!isBackFace(curFace.v1, curFace.v2, curFace.v3)) && 
					(curFace.v1.z3d > -cam.fl - cam.zOffset && curFace.v2.z3d > -cam.fl - cam.zOffset && curFace.v3.z3d > -cam.fl - cam.zOffset)) 
				{
					curStageGfx = getStage(curFace).graphics;
					curColor = curMaterial.color;
					if(curMaterial is BitmapMaterial) {
						renderUV(curStageGfx, curMaterial, curFace.v1, curFace.v2, curFace.v3, curFace.uvMap, (curColor / curMaterial.color));
					}else {
						renderFlatFace(curColor, curStageGfx, curMaterial, curFace.v1, curFace.v2, curFace.v3);
					}
				}
			}
		}
		
		private function getStage(face:Face):Sprite {
			var tmpStage:Sprite = drawStage;
			var newStage:Sprite;
			if(face.meshRef.container){
				if (!face.meshRef.container.parent) tmpStage.addChild(face.meshRef.container);
				meshToStage[face.meshRef] = tmpStage = face.meshRef.container;
				drawStage.addChild(tmpStage);
			}
			return tmpStage;
		}
		
		private function clearStage(tmpStage:Sprite):void {
			tmpStage.graphics.clear();
			for(var i:int = 0;i < tmpStage.numChildren; i++){
				clearStage(Sprite(tmpStage.getChildAt(i)));
			}
		}
		
		private function isBackFace(pa:Vertex, pb:Vertex, pc:Vertex):Boolean {
			return ((pc.screenX - pa.screenX) * (pb.screenY - pa.screenY) - (pc.screenY - pa.screenY) * (pb.screenX - pa.screenX) < 0);
		}
		
		private function faceZSort(ta:Face, tb:Face):Number{
			var za:Number = (ta.v1.z3d + ta.v2.z3d + ta.v3.z3d) / 3;
			var zb:Number = (tb.v1.z3d + tb.v2.z3d + tb.v3.z3d) / 3;
			return (za > zb) ? -1 : 1;
		}
		
		public function renderFlatFace(calculatedColor:Number, gfx:Graphics, material:Material, v1:Vertex, v2:Vertex, v3:Vertex):void {
			gfx.lineStyle();
			gfx.beginFill(calculatedColor, material.alpha);
			gfx.moveTo(v1.screenX, v1.screenY);
			gfx.lineTo(v2.screenX, v2.screenY);
			gfx.lineTo(v3.screenX, v3.screenY);
			gfx.lineTo(v1.screenX, v1.screenY);
			gfx.endFill();
		}
		
		public function renderUV(gfx:Graphics, material:Material, a:Vertex, b:Vertex, c:Vertex, uvMap:Array, colorFactor:Number, ambientColor:uint = 0x000000):void {
			var x0:Number = a.screenX;
			var y0:Number = a.screenY;
			var x1:Number = b.screenX;
			var y1:Number = b.screenY;
			var x2:Number = c.screenX;
			var y2:Number = c.screenY;
			var texture:BitmapData = material.texture;
			if(!texture) return;
			var w:Number = texture.width;
			var h:Number = texture.height;
			var u0:Number = uvMap[0].u * w;
			var v0:Number = uvMap[0].v * h;
			var u1:Number = uvMap[1].u * w;
			var v1:Number = uvMap[1].v * h;
			var u2:Number = uvMap[2].u * w;
			var v2:Number = uvMap[2].v * h;
			var sMat:Matrix = new Matrix();
			var tMat:Matrix = new Matrix();
			tMat.tx = u0;
			tMat.ty = v0;
			tMat.a = (u1 - u0) / w;
			tMat.b = (v1 - v0) / w;
			tMat.c = (u2 - u0) / h;
			tMat.d = (v2 - v0) / h;
			sMat.a = (x1 - x0) / w;
			sMat.b = (y1 - y0) / w;
			sMat.c = (x2 - x0) / h;
			sMat.d = (y2 - y0) / h;
			sMat.tx = x0;
			sMat.ty = y0;
			tMat.invert();
			tMat.concat(sMat);
			var smoothing:Boolean = material.smoothed;
			if(smoothing){ 
				var u:Point = new Point(x1 - x0, y1 - y0);
				var v:Point = new Point(x2 - x0, y2 - y0);
				var dot:Number = u.x * v.x + u.y * v.y;
				var angle:Number = Math.acos(dot / (u.length * v.length)) * 180 / Math.PI;
				
				if(angle < 5 || angle > 175){
					smoothing = false;
				}
			}
			gfx.lineStyle();
			gfx.beginBitmapFill(texture, tMat, false, smoothing);
			gfx.moveTo(x0, y0);
			gfx.lineTo(x1, y1);
			gfx.lineTo(x2, y2);
			gfx.lineTo(x0, y0);
			gfx.endFill();
		}
	}
}