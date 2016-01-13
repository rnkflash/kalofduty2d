package warfare.game.parsers
{
	import flash.display.MovieClip;
	import nape.constraint.AngleJoint;
	import nape.constraint.PivotJoint;
	import nape.dynamics.InteractionFilter;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Circle;
	import nape.shape.Polygon;
	import nape.space.Space;
	import warfare.game.objects.ObjectManager;
	import warfare.game.objects.other.RagdollPart;
	import warfare.game.physics.CollisionTypes;
	/**
	 * ...
	 * @author me
	 */
	public class RagdollMovieclipParser 
	{
		
		public static var space:Space;
		public static var objectManager:ObjectManager;
		
		public function RagdollMovieclipParser() 
		{
			
		}
		
		public static function CreateRagdoll(mc:MovieClip, worldPos:Vec2,vel:Vec2):void
		{
			var orderedBodies:Array = [];
			var bodies:Object = { };
			var pivots:Array = [];
			var groupsAndMasks:Object = {};
			
			var bodyGroup:int = 0x000000001;
			var bodyMask:int =  0x000000001;
			groupsAndMasks["bod"] = { group:bodyGroup, mask:bodyMask };
			
			var headGroup:int = 0x000000010;
			var headMask:int =  0x000000001;
			groupsAndMasks["hea"] = { group:headGroup, mask:headMask };
			
			var armsGroup:int = 0x000000100;
			var armsMask:int =  0x000000001;
			groupsAndMasks["arm"] = { group:armsGroup, mask:armsMask };
			
			var legsGroup:int = 0x000001000;
			var legsMask:int =  0x000000001;
			groupsAndMasks["leg"] = { group:legsGroup, mask:legsMask };
			
			
			
			for (var i:int = 0; i < mc.numChildren; i++) 
			{
				var child:MovieClip = mc.getChildAt(i) as MovieClip;
				if (child)
				{
					var name:String = child.name;
					var args:Array = name.split("_");
					var rotation:Number = child.rotation;
					var id:String = "";
					var pos:Vec2 = new Vec2(child.x, child.y);
					if (args[0] == "box")
					{
						var sizeX:Number = Number(args[1]);
						var sizeY:Number = Number(args[2]);
						id = args[3];
						var collId:String = id.substr(0, 3);
						if (groupsAndMasks[collId] != undefined)
						{
							var intFil:InteractionFilter = new InteractionFilter(groupsAndMasks[collId].group, groupsAndMasks[collId].mask);
						} else
							intFil = null;
						
						var bodyMaterial:Material = new Material(0, 1, 1, id!="body"?0.5:1, 0.01);
						var body:Body = new Body(BodyType.DYNAMIC , new Vec2(pos.x, pos.y));
						body.cbTypes.add(CollisionTypes.RAGDOLL_TYPE);
						body.shapes.add(new Polygon(Polygon.rect( -sizeX / 2, -sizeY / 2, 
							sizeX, sizeY), bodyMaterial,intFil));
						body.space = space;
						body.rotation = rotation * Math.PI / 180;
						bodies[id] = { body:body, graphic:child, destructable:id!="body" };
						orderedBodies.push(bodies[id]);
						
					} else
					if (args[0] == "circle")
					{
						var radius:Number = Number(args[1]);
						id = args[2];
						collId = id.substr(0, 3);
						if (groupsAndMasks[collId] != undefined)
						{
							intFil = new InteractionFilter(groupsAndMasks[collId].group, groupsAndMasks[collId].mask);
						} else
							intFil = null;
						
						bodyMaterial = new Material(0, 1, 1, 1, 0.01);
						body = new Body(BodyType.DYNAMIC , new Vec2(pos.x, pos.y));
						body.cbTypes.add(CollisionTypes.RAGDOLL_TYPE);
						body.shapes.add(new Circle(radius, new Vec2(0, 0), bodyMaterial, intFil));
						body.space = space;
						body.rotation = rotation * Math.PI / 180;
						bodies[id] = { body:body, graphic:child , destructable:id!="body"};
						orderedBodies.push(bodies[id]);
					} else
					if (args[0] == "pivot")
					{
						var id1:String = args[1];
						var id2:String = args[2];
						
						var t:Object = { id1:id1, id2:id2, pos:pos.copy() };
						pivots.push( t );
						
						if (args[3] != undefined && args[3] != undefined)
						{
							args[3] = String(args[3]).replace("m", "-");
							args[4] = String(args[4]).replace("m", "-");
							t.angle1 = Number(args[3]);
							t.angle2 = Number(args[4]);
						}
					}
					
				}
			}
			
			for each (var info:Object in orderedBodies) 
			{
				body = info.body;
				//body.graphic = info.graphic;
				body.position.setxy(body.position.x + worldPos.x, body.position.y + worldPos.y);
				var ragdolP:RagdollPart = new RagdollPart(0, 0, info.graphic, body,Boolean(info.destructable));
				objectManager.Add(ragdolP);
				body.velocity.setxy(vel.x, vel.y);
			}
			
			for (var j:int = 0; j < pivots.length; j++) 
			{
				info = pivots[j];
				var b1:Body = bodies[info.id1].body;
				var b2:Body = bodies[info.id2].body;
				var pivotJoint:PivotJoint = new PivotJoint(b1, b2, b1.worldToLocal(new Vec2(info.pos.x + worldPos.x, info.pos.y + worldPos.y)), 
					b2.worldToLocal(new Vec2(info.pos.x + worldPos.x,info.pos.y + worldPos.y)));
				pivotJoint.ignore = true;
				pivotJoint.space = space;
				
				if (info.angle1 != undefined && info.angle2 != undefined)
				{
					var angleJoint:AngleJoint = new AngleJoint(b2, b1, info.angle1 * Math.PI / 180, info.angle2 * Math.PI / 180);
					angleJoint.ignore = true;
					angleJoint.space = space;
				}
			}
			
			
			
		}
		
	}

}