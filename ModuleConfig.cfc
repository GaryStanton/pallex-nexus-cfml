/**
* This module wraps DHL Parcel UK International web services
**/
component {

	// Module Properties
    this.modelNamespace			= 'PallexNexusCFML';
    this.cfmapping				= 'PallexNexusCFML';
    this.parseParentSettings 	= true;

	/**
	 * Configure
	 */
	function configure(){

		// Skip information vars if the box.json file has been removed
		if( fileExists( modulePath & '/box.json' ) ){
			// Read in our box.json file for so we don't duplicate the information above
			var moduleInfo = deserializeJSON( fileRead( modulePath & '/box.json' ) );

			this.title 				= moduleInfo.name;
			this.author 			= moduleInfo.author;
			this.webURL 			= moduleInfo.repository.URL;
			this.description 		= moduleInfo.shortDescription;
			this.version			= moduleInfo.version;

		}

		// Settings
		settings = {
				'username' : ''
			,	'password' : ''
			,	'env' : 'test'
		};
	}

	function onLoad(){
		binder.map( "pallexNexus@PallexNexusCFML" )
			.to( "#moduleMapping#.models.pallexNexus" )
			.asSingleton()
			.initWith(
					username 	= settings.username
				,	password 	= settings.password
				,	env 		= settings.env
			);
	}

}