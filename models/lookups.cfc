/**
 * Name: Pallex Nexus Lookups API
 * Author: Gary Stanton (@SimianE)
 * Description: Wrapper for the Pallex Nexus Lookup API methods
 * Currently contains only a very limited subset of methods. Feel free to add!
 */
component singleton accessors="true" extends="pallexNexus" {

	/**
	 * Constructor
	 * @username The username to access the API
	 * @password The password to access the API
	 * @env The API environment to use (TEST|LIVE)
	 */
	private lookups function init(
			required string username 
		,	required string password
		,	string env = 'TEST'
	){  
		setUsername(Arguments.username);
		setPassword(Arguments.password);
		setEnv(Arguments.env);

		return this;
	}




	/**
	 * Returns a list of consignment attachment types.
	 * @searchTerm	 	A term used to filter the records returned. Only records where the consignment attachment type name contains the search term will be returned.
	 * @limit 			Maximum number of records to be returned
	 * @offset 			Number of records to skip before returning data
	 */
	public function consignmentAttachmentTypes(
			string searchTerm
		,	numeric limit = 50
		,	numeric offset = 0
	) {
		return makeRequest(
			endpointString 	= 'consignmentAttachmentTypes'
		,	method 			= 'GET'
		,	params 			= Arguments
		);
	}


	/**
	 * Returns a list of consignment statuses.
	 * @searchTerm	 	A term used to filter the records returned. Only records where the consignment status name contains the search term will be returned.
	 * @limit 			Maximum number of records to be returned
	 * @offset 			Number of records to skip before returning data
	 */
	public function consignmentStatuses(
			string searchTerm
		,	numeric limit = 20
		,	numeric offset = 0
	) {
		return makeRequest(
			endpointString 	= 'consignmentStatuses'
		,	method 			= 'GET'
		,	params 			= Arguments
		);
	}


	/**
	 * Returns a list of consignment types.
	 * @searchTerm	 	A term used to filter the records returned. Only records where the consignment type name contains the search term will be returned.
	 * @limit 			Maximum number of records to be returned
	 * @offset 			Number of records to skip before returning data
	 */
	public function consignmentTypes(
			string searchTerm
		,	numeric limit = 20
		,	numeric offset = 0
	) {
		return makeRequest(
			endpointString 	= 'consignmentTypes'
		,	method 			= 'GET'
		,	params 			= Arguments
		);
	}



	/**
	 * Returns a list of countries.
	 * @searchTerm	 	A term used to filter the records returned. Only records where the country name contains the search term will be returned.
	 * @limit 			Maximum number of records to be returned
	 * @offset 			Number of records to skip before returning data
	 */
	public function countries(
			string searchTerm
		,	numeric limit = 20
		,	numeric offset = 0
	) {
		return makeRequest(
			endpointString 	= 'countries'
		,	method 			= 'GET'
		,	params 			= Arguments
		);
	}



	/**
	 * Returns a list of currencies.
	 * @searchTerm	 	A term used to filter the records returned. Only records where the currency name contains the search term will be returned.
	 * @limit 			Maximum number of records to be returned
	 * @offset 			Number of records to skip before returning data
	 */
	public function currencyTypes(
			string searchTerm
		,	numeric limit = 20
		,	numeric offset = 0
	) {
		return makeRequest(
			endpointString 	= 'currencyTypes'
		,	method 			= 'GET'
		,	params 			= Arguments
		);
	}
}