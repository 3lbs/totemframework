package totem3d.utils
{
	import away3d.cameras.Camera3D;
	
	import totem3d.events.Camera3DEvent;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	/**
	 *
	 * @author David Lenaerts
	 */
	public class HoverDragController
	{
		private var _displayStage : DisplayObjectContainer;
		
		private var _target : Vector3D;
		
		private var _camera : Camera3D;
		
		private var _radius : Number = 1000;
		
		private var _speed : Number = .001;
		
		private var _dragSmoothing : Number = 0;
		
		private var _drag : Boolean;
		
		private var _referenceX : Number = 0;
		
		private var _referenceY : Number = 0;
		
		private var _xRad : Number = 0;
		
		private var _yRad : Number = .5;
		
		private var _targetXRad : Number = 0;
		
		private var _targetYRad : Number = .5;
		
		private var _targetRadius : Number = 1000;
		
		//private var _enabled : Boolean;
		
		private var _orbitCamera : Boolean = false;
		
		private var _panCamera : Boolean = false;
		
		private var zoomMultiplier : Number = 10;
		
		private var prevMouseVector : Vector3D;
		
		private var _startPosition : Vector3D;
		
		private var _startTarget : Vector3D;
		
		// placeholder used for caluclations
		private var _pos : Vector3D = new Vector3D ();
		
		private var _referenceMatrix3D : Matrix3D;
		
		private var panAxis : Vector3D;
		
		private var panDragDistance : Number = 0;
		
		private var panAngle : Number;
		
		private var angleVector : Vector3D;
		
		/**
		 * Creates a HoverDragController object
		 * @param camera The camera to control
		 * @param stage The stage that will be receiving mouse events
		 */
		public function HoverDragController( camera : Camera3D, stage : DisplayObjectContainer, target : Vector3D = null )
		{
			_displayStage = stage;
			_target = target || new Vector3D ();
			
			_camera = camera;
			
			_startTarget = _target.clone ();
			_startPosition = camera.position;
			
			stage.addEventListener ( MouseEvent.MOUSE_DOWN, onMouseDown );
			stage.addEventListener ( MouseEvent.MOUSE_UP, onMouseUp );
			_displayStage.addEventListener ( MouseEvent.MOUSE_WHEEL, onMouseWheel );
			stage.addEventListener ( Event.ENTER_FRAME, onEnterFrame );
			
			_displayStage.addEventListener(Camera3DEvent.HOVER_CAMERA, handleMoveCamera );
			resetCamera ();
			//_enabled = false;
		}
		
		/**
		 * Amount of "lag" the camera has
		 */
		public function get dragSmoothing() : Number
		{
			return _dragSmoothing;
		}
		
		public function set dragSmoothing( value : Number ) : void
		{
			_dragSmoothing = value;
		}
		
		/**
		 * The distance of the camera to the target
		 */
		public function get radius() : Number
		{
			return _targetRadius;
		}
		
		public function set radius( value : Number ) : void
		{
			_targetRadius = value;
		}
		
		/**
		 * The amount by which the camera be moved relative to the mouse movement
		 */
		public function get speed() : Number
		{
			return _speed;
		}
		
		public function set speed( value : Number ) : void
		{
			_speed = value;
		}
		
		/**
		 * Removes all listeners
		 */
		public function destroy() : void
		{
			_displayStage.removeEventListener ( MouseEvent.MOUSE_DOWN, onMouseDown );
			_displayStage.removeEventListener ( MouseEvent.MOUSE_UP, onMouseUp );
			_displayStage.removeEventListener ( MouseEvent.MOUSE_WHEEL, onMouseWheel );
			_displayStage.removeEventListener ( Event.ENTER_FRAME, onEnterFrame );
		}
		
		/**
		 * The center of attention for the camera
		 */
		public function get target() : Vector3D
		{
			return _target;
		}
		
		public function set target( value : Vector3D ) : void
		{
			_target = value;
		}
		
		/**
		 * Update cam movement towards its target position
		 */
		private function onEnterFrame( event : Event ) : void
		{
			
			if ( _drag )
			{
				var cy : Number;
				
				if ( orbitCamera )
				{
					updateRotationTarget ();
					
					_radius = _radius + ( _targetRadius - _radius );
					_xRad = _xRad + ( _targetXRad - _xRad );
					_yRad = _yRad + ( _targetYRad - _yRad );
					
					cy = Math.cos ( _yRad ) * _radius;
					_camera.x = _target.x + Math.sin ( _xRad ) * cy;
					_camera.y = _target.y + Math.sin ( _yRad ) * _radius;
					_camera.z = _target.z + Math.cos ( _xRad ) * cy;
					_camera.lookAt ( _target );
					
					/*var ray:Number3D = view.camera.unproject(view.mouseX, view.mouseY);
					ray.add(ray, new Number3D(view.camera.x, view.camera.y, view.camera.z));
					
					var cameraVertex:Vertex = new Vertex(view.camera.x, view.camera.y, view.camera.z);
					var rayVertex:Vertex = new Vertex(ray.x, ray.y, ray.z);
					var intersectPoint:Vertex = planeToDragOn.getIntersectionLine(cameraVertex, rayVertex);*/
				}
				else if ( panCamera )
				{
					updatePanTarget ();
					
					if ( panDragDistance > 0 )
					{
						panAxis = new Vector3D ( Math.cos ( panAngle ), Math.sin ( panAngle ), 0 );
						
						_camera.translateLocal ( angleVector, panDragDistance );
						
						panDragDistance = 0;
						
						// move the rotation target
						cy = Math.cos ( _yRad ) * _radius;
						_target.x = _camera.x - Math.sin ( _xRad ) * cy;
						_target.y = _camera.y - Math.sin ( _yRad ) * _radius;
						_target.z = _camera.z - Math.cos ( _xRad ) * cy;
						
					}
				}
			}
		
		}
		
		private function updateCameraTransforms() : void
		{
			_radius = _radius + ( _targetRadius - _radius );
			_xRad = _xRad + ( _targetXRad - _xRad );
			_yRad = _yRad + ( _targetYRad - _yRad );
			
			var cy : Number = Math.cos ( _yRad ) * _radius;
			_camera.x = _target.x + Math.sin ( _xRad ) * cy;
			_camera.y = _target.y + Math.sin ( _yRad ) * _radius;
			_camera.z = _target.z + Math.cos ( _xRad ) * cy;
			_camera.lookAt ( _target );
		}
		
		private function updatePanTarget() : void
		{
			var mouseX : Number = _displayStage.mouseX;
			var mouseY : Number = _displayStage.mouseY;
			var dx : Number = mouseX - _referenceX;
			var dy : Number = mouseY - _referenceY;
			
			
			var currentMouseVector : Vector3D = new Vector3D ( _displayStage.mouseX, _displayStage.mouseY );
			
			if ( !currentMouseVector.equals ( prevMouseVector ) )
			{
				
				angleVector = prevMouseVector.subtract ( currentMouseVector );
				panDragDistance = angleVector.length;
				
				angleVector.normalize ();
				angleVector.y = -angleVector.y;
				
				prevMouseVector = currentMouseVector;
				
			}
		}
		
		/**
		 * If dragging, update the target position's spherical coordinates
		 */
		private function updateRotationTarget() : void
		{
			var mouseX : Number = _displayStage.mouseX;
			var mouseY : Number = _displayStage.mouseY;
			var dx : Number = mouseX - _referenceX;
			var dy : Number = mouseY - _referenceY;
			var bound : Number = Math.PI * .5 - .05;
			
			_referenceX = mouseX;
			_referenceY = mouseY;
			_targetXRad += dx * _speed;
			_targetYRad += dy * _speed;
			
			if ( _targetYRad > bound )
				_targetYRad = bound;
			else if ( _targetYRad < -bound )
				_targetYRad = -bound;
		}
		
		public function set orbitCamera( value : Boolean ) : void
		{
			_panCamera = false;
			_orbitCamera = value;
		}
		
		public function get orbitCamera() : Boolean
		{
			return _orbitCamera;
		}
		
		public function set panCamera( value : Boolean ) : void
		{
			_orbitCamera = false;
			_panCamera = value;
		}
		
		public function get panCamera() : Boolean
		{
			return _panCamera;
		}
		
		private function handleMoveCamera ( event : Camera3DEvent ) : void
		{
		
		}
		/**
		 * Start dragging
		 */
		private function onMouseDown( event : MouseEvent ) : void
		{
			_referenceX = _displayStage.mouseX;
			_referenceY = _displayStage.mouseY;
			_displayStage.stage.addEventListener ( MouseEvent.MOUSE_UP, onMouseUp );
			
			prevMouseVector = new Vector3D ( _displayStage.mouseX, _displayStage.mouseY );
			
			_drag = true;
		
		}
		
		/**
		 * Stop dragging
		 */
		private function onMouseUp( event : MouseEvent ) : void
		{
			_drag = false;
			_displayStage.stage.removeEventListener ( MouseEvent.MOUSE_UP, onMouseUp );
		}
		
		/**
		 * Updates camera distance
		 */
		private function onMouseWheel( event : MouseEvent ) : void
		{
			_targetRadius -= event.delta * zoomMultiplier;
			
			updateCameraTransforms ();
		}
		
		
		public function resetCamera() : void
		{
			_panCamera = false;
			_orbitCamera = false;
			
			_referenceX = 0;
			_referenceY = 0;
			_xRad = 0;
			_yRad = .5;
			_targetXRad = 0;
			_targetYRad = .5;
			_targetRadius = 1000;
			
			_target = _startTarget.clone ();
			
			_camera.transform = new Matrix3D ();
			
			_camera.position = _startPosition;
			_camera.lookAt ( _target );
			
			prevMouseVector = new Vector3D ();
			
			updateCameraTransforms ();
		}
	}
}


