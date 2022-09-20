/**
 * Name: Pallex Nexus Consignments API
 * Author: Gary Stanton (@SimianE)
 * Description: Wrapper for the Pallex Nexus Consignments API methods
 * Currently contains only a very limited subset of methods. Feel free to add!
 */
component singleton accessors="true" extends="pallexNexus" {

	/**
	 * Constructor
	 * @username The username to access the API
	 * @password The password to access the API
	 * @env The API environment to use (TEST|LIVE)
	 */
	private consignments function init(
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
	 * Retrieve consignments
	 * @customerID The customer ID
	 * @consignmentTypeID The consignment type ID
	 * @statusID The status ID
	 * @minCreatedDate Minimum created date
	 * @maxCreatedDate Maximum created date
	 * @minManifestDate Minimum manifest date
	 * @maxManifestDate Maximum manifest date
	 * @minEstimatedCollectionDate Minimum estimated collection date
	 * @maxEstimatedCollectionDate Maximum estimated collection date
	 * @minEstimatedDeliveryDate Minimum estimated delivery date
	 * @maxEstimatedDeliveryDate Maximum estimated delivery date
	 * @minCollectionDate Minimum collection date
	 * @maxCollectionDate Maximum collection date
	 * @minDeliveryDate Minimum delivery date
	 * @maxDeliveryDate Maximum delivery date
	 * @searchTerm A term used to filter the records returned
	 * @limit Maximum number of records to be returned
	 * @offset Number of records to skip before returning data
	 *
	 * @return string|object Response data.
	 * @throws Exception
	 */
	public function retrieve(
			numeric customerID
		,	numeric consignmentTypeID
		,	array statusID
		,	string minCreatedDate
		,	string maxCreatedDate
		,	string minManifestDate
		,	string maxManifestDate
		,	string minEstimatedCollectionDate
		,	string maxEstimatedCollectionDate
		,	string minEstimatedDeliveryDate
		,	string maxEstimatedDeliveryDate
		,	string minCollectionDate
		,	string maxCollectionDate
		,	string minDeliveryDate
		,	string maxDeliveryDate
		,	string searchTerm
		,	numeric limit = 20
		,	numeric offset = 0
	){
		return makeRequest(
			endpointString 	= 'consignments/'
		,	method 			= 'GET'
		,	params 			= Arguments
		);
	}
}