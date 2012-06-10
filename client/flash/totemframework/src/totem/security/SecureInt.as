
//http://www.associatedcontent.com/article/1392196/secure_your_swf_files_against_the_cheat.html?cat=15

package totem.security
{
	import by.blooddy.crypto.MD5;
	
	public class SecureInt
	{
		
		private var scoreHash:String = "";
		
		private var scoreSalt:String = "iaw43982adkf"; 
		
		private var score : int;
		
		private var _value : int;
		
		public function SecureInt()
		{
		}
		
		public function get value () : int
		{
			return _value;
		}
		
		public function set int ( value : int ) : void
		{
		
		}
		// It's good
		
		public function secured () : Boolean
		{
			if(!score || scoreHash==MD5.hash(score.toString()+scoreSalt)) {
				
				score = score + 1;
				
				scoreHash = MD5.hash(score.toString()+scoreSalt);
				
			}
			// Hash did not match, hacker must be using Cheat Engine
			
			else {
				
				// Do what you like here
				
			} 
			
			return false;
		}
	}
}

