/**
 * Name: Pallex Nexus API Wrapper core
 * Author: Gary Stanton (@SimianE)
 * Description: Core CFC to be extended by individual API CFCs
 * @username The username to access the API
 * @password The password to access the API
 * @env The API environment to use (TEST|LIVE)
 * @apiurl The URL for the API. Set automatically when changing environments
 * @bearerToken Set when calling the authentication function
 * @tokenTimestamp Timestamp to indicate when the bearer token was set. The token should last an hour, and can be refreshed with a call to 'account/refresh', however since there's no harm in doing so, the module will simply call 'account/login' to retrieve a new bearer token.
 */
component singleton accessors="true" {
	property name="username" 		type="string";
	property name="password" 		type="string";
	property name="env"  			type="string" default="TEST";
	property name="apiurl"  		type="string";
	property name="bearerToken" 	type="string";
	property name="tokenTimestamp" 	type="string";

	// Child CFCs representing Pallex Nexus APIs
	property name="consignments" 	type="consignments";
	property name="lookups" 		type="lookups";

	/**
	 * Constructor
	 * @username The username to access the API
	 * @password The password to access the API
	 * @env The API environment to use (TEST|LIVE)
	 */
	public pallexNexus function init(
		required string username 
	,	required string password
	,	string env = 'TEST'
	){  
		setUsername(Arguments.username);
		setPassword(Arguments.password);
		setEnv(Arguments.env);

		// Consignments API
		setConsignments(new consignments())
		getConsignments()
			.setUsername(getUsername())
			.setPassword(getPassword())
			.setEnv(getEnv())
		;

		// Lookups API
		setLookups(new lookups())
		getLookups()
			.setUsername(getUsername())
			.setPassword(getPassword())
			.setEnv(getEnv())
		;


		authenticate();

		return this;
	}

	/**
	 * Set the env variable. The API URL will automatically be set based on the environment variable (LIVE/TEST)
	 * @env 	The env variable
	 * @return  this
	 */
	function setEnv(
		required string env
	) {
		Variables.env = Arguments.env;

		if (Arguments.env == 'LIVE') {
			Variables.apiurl = 'https://rest-api-nexus.pallex.com/v1/'
		}
		else {
			Variables.apiurl = 'https://s-nexus-rest-api-test.pallex.com/v1/'
		}

		return this;
	}

	/**
	 * @brief      	Set a the bearer token variable in this and all child CFCs - and update the timestamp
	 * @bearerToken The bearer token
	 * @return     	this
	 */
	function setNewBearerToken(
		required string bearerToken
	) {
		setBearerToken(Arguments.bearerToken);
		setTokenTimestamp(Now());

		getConsignments()
			.setBearerToken(Arguments.bearerToken)
			.setTokenTimestamp(Now());

		return this;
	}


	/**
	 * Checks that the bearer token timestamp is < 30 minutes old
	 * @return boolean
	 */
	private function checkBearerToken() {
		try {
			return isDate(getTokenTimestamp()) && dateadd('n', -30, Now()) < getTokenTimestamp();
		}
		catch(any e) {
			return false;
		}
	}


	/**
	 * Post the username/password to the login endpoing to retrieve a new bearer token
	 * @return this
	 */
	private function getNewBearerToken() {
		cfhttp(
			method  = "POST",
			charset = "utf-8", 
			url     = getApiurl() & 'Account/login/',
			result  = "result"
		) {
			var result = {};
			var payload = {
				"username": "#getUsername()#",
				"password": "#getPassword()#"
			}

			cfhttpparam(type="header", name="Content-Type", value="application/json");
			cfhttpparam(type="body", value="#serializeJSON(payload)#");
		}

		try {
			return setNewBearerToken(deserializeJSON(result.fileContent).bearerToken);
		}
		catch(any e) {
			return {errors: 'Unable to parse result', detail: e.message, result: result};
		}
	}

	/**
	 * Check that the bearer token is valid and if not, run the authentication logic to retrieve a new bearer token.
	 * @return this
	 */
	private function authenticate() {
		if (!checkBearerToken()) {
			return getNewBearerToken();
		}
		else {
			return this;
		}
	}


	/**
	 * Makes a request to the API. Will return the content from the cfhttp request.
	 * @endpoint The request endpoint
	 * @body The body of the request
	 * @output Output type: JSON|RAW|DEBUG (Parsed JSON | Raw filecontent | CFHTTP object)
	 */
	private function makeRequest(
			required string endpointString
		,	string method = 'GET'
		,   string output = 'JSON'
	){
		var requestURL  = getApiurl() & endpointString
		var result      = {};

		// Decide param types
		var paramType = 'url';
		switch (Arguments.method) {
			case 'GET':
				paramType = 'url';
				break;

			case 'POST': case 'PUT': case 'DELETE':
				paramType = 'body';
				Arguments.headers['Content-Type'] = 'application/json';
				break;
		}


		// Update the bearer token
		authenticate();

		// Make the call
		cfhttp(
			method  = Arguments.method,
			charset = "utf-8", 
			url     = requestURL,
			result  = "result"
		) {
			cfhttpparam(type="header", name="Authorization", value="Bearer #getBearerToken()#");
			cfhttpparam(type="header", name="Content-Type", value="application/json");

			// Add parameters
			if (structKeyExists(Arguments, 'params') && isStruct(Arguments.params)) {
				for (Local.thisParam in Arguments.params) {
					// If we have an 'output' param, that should be pushed to the arguments scope to override the default output
					if (Local.thisParam == 'Output' && StructKeyExists(Arguments.params, Local.thisParam)) {
						Arguments.Output = Arguments.params[Local.thisParam];
					}
					else if (ListFindNoCase('xml,json', Local.thisParam) && StructKeyExists(Arguments.params, Local.thisParam)) {
						cfhttpparam(type="#paramType#", value="#Arguments.params[Local.thisParam]#");
					}
					else if (StructKeyExists(Arguments.params, Local.thisParam)) {
						cfhttpparam(type="#paramType#", value="#Arguments.params[Local.thisParam]#", name="#lCase(Local.thisParam)#");
					}
				}
			}
		}

		if (StructKeyExists(result, 'fileContent') && isJSON(result.fileContent)) {
			switch (Arguments.output) {
				case "DEBUG" :
					result.environment = getEnv();
					result.endpoint = requestURL;
					return result;
				break;
				case "RAW" :
					return result.fileContent;
				break;
				default:
					return deserializeJSON(result.fileContent);
				break;
			}
		}
		else {
			return {errors: 'Unable to parse result', result: result, request: requestURL};
		}
	}

	public function getMemento() {
		return Variables;
	}
}
