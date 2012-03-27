package nano.objects {
	
	import nano.geom.Vertex;
	import nano.material.Material;
	
	public class Plane extends Mesh {
		public function Plane(width:Number, height:Number, stepsX:Number, stepsY:Number, material:Material) {
			super();
			createPlane(width, height, stepsX, stepsY, material);
		}
		
		protected function createPlane(width:Number, height:Number, stepsX:Number, stepsY:Number, material:Material):void {
			var i:Number;
			var j:Number;
			var ar:Array = [];
			width *= 2;
			height *= 2;
			for(i = 0;i <= stepsX; i++) {
				ar.push([]);
				for(j = 0;j <= stepsY; j++) {
					var x:Number = i * (width / stepsX) - width / 2;
					var y:Number = j * (height / stepsY) - height / 2;
					ar[i].push(new Vertex(x, y, 0));
				}
			}
			var xscaling:Number = 1 / stepsX;
			var yscaling:Number = 1 / stepsY;
			for(i = 0;i < ar.length; i++) {
				for(j = 0;j < ar[i].length; j++) {
					if(i > 0 && j > 0) {
						var uv1:Array = [{ u: Number((i - 1) * xscaling), v: Number((j - 1) * yscaling) }, { u: Number((i - 1) * xscaling), v: Number((j) * yscaling) }, { u: Number((i) * xscaling), v: Number((j) * yscaling) }];
						var uv2:Array = [{ u: Number((i - 1) * xscaling), v: Number((j - 1) * yscaling) }, { u: Number((i) * xscaling), v: Number((j) * yscaling) }, { u: Number((i) * xscaling), v: Number((j - 1) * yscaling) }];
						addFace(ar[i - 1][j - 1], ar[i - 1][j], ar[i][j], material, uv1);
						addFace(ar[i - 1][j - 1], ar[i][j], ar[i][j - 1], material, uv2);
					}
				}
			}
		}
	}
}