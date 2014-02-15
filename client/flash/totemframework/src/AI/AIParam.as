package AI
{
	import totem.core.params.BaseParam;

	public class AIParam extends BaseParam
	{

		// Arrive speed settings
		public var speedTweaker:Number	=	.3;
		public var arriveFast:Number		=	1;
		public var arriveNormal:Number	=	3;
		public var arriveSlow:Number		=	5;
		
		// Wander Settings
		public var wanderJitter:Number	=	300; // ( per second )
		public var wanderDistance:Number	=	25;
		public var wanderRadius:Number	=	15;
		
		// Probabilities - Used to determine the chance that the Prioritized Dithering ( fastest ) calculation method will run a behavior
		public var separationProbability:Number			=	0.2;
		public var cohesionProbability:Number			=	0.6;
		public var alignmentProbability:Number			=	0.3;
		
		public var dodgeProbability:Number			=	0.6;
		
		public var seekProbability:Number				=	0.8;
		public var fleeProbability:Number				=	0.6;
		public var pursuitProbability:Number				=	0.8;
		public var evadeProbability:Number				=	1;
		public var offsetPursuitProbability:Number		=	0.8;
		public var arriveProbability:Number				=	0.5;
		
		public var obstacleAvoidanceProbability:Number	=	0.5;
		public var wallAvoidanceProbability:Number		=	0.5;
		public var hideProbability:Number				=	0.8;
		public var followPathProbability:Number			=	0.7;
		
		public var interposeProbability:Number			=	0.8;		
		public var wanderProbability:Number				=	0.8;
		
		// Weights - Scalar to effect the weights of individual behaviors
		public var separationWeight:Number			=	1;
		public var alignmentWeight:Number			=	3;
		public var cohesionWeight:Number				=	2;
		
		public var dodgeWeight:Number				=	1;		
		
		public var seekWeight:Number					=	1;
		public var fleeWeight:Number					=	1;
		public var pursuitWeight:Number				=	1;
		public var evadeWeight:Number				=	0.1;
		public var offsetPursuitWeight:Number		=	1;
		public var arriveWeight:Number				=	1;
		
		public var obstacleAvoidanceWeight:Number	=	3;
		public var wallAvoidanceWeight:Number		=	10;
		public var hideWeight:Number					=	1;
		public var followPathWeight:Number			=	0.5;
		
		public var interposeWeight:Number			=	1;		
		public var wanderWeight:Number				=	1;
		
		// Priorities - Order in which behaviors are calculated ( lower numbers get calculated first )
		public var wallAvoidancePriority:Number		=	10;
		public var obstacleAvoidancePriority:Number	=	20;
		public var evadePriority:Number				=	30;
		public var hidePriority:Number				=	35;
		
		public var seperationPriority:Number			=	40;
		public var alignmentPriority:Number			=	50;
		public var cohesionPriority:Number			=	60;
		
		public var dodgePriority:Number				=	65;
		
		public var seekPriority:Number				=	70;
		public var fleePriority:Number				=	80;
		public var arrivePriority:Number				=	90;
		public var pursuitPriority:Number			=	100;
		public var offsetPursuitPriority:Number		=	110;
		public var interposePriority:Number			=	120;
		public var followPathPriority:Number			=	130;
		public var wanderPriority:Number				=	140;
	
	
	}
}

