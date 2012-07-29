package totem.net
{
	public function getURL( value : String, type : String ) : String
	{
		return instanceURLManager( type ).getURL( value );
	}
}
