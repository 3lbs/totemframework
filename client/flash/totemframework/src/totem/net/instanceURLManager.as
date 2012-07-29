package totem.net
{
	
	internal function instanceURLManager ( value : String ) : URLManager
	{
		return URLManager.instance( value );
	}
	
	//internal var URL_MANAGER_INSTANCE : URLManager = URLManager.instance();
}