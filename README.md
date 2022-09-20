# Pallex Nexus CFML

Pallex Nexus CFML provides a wrapper for the Pallex Nexus API.
At present, the module only includes a very limited subset of functionality to retrieve consignment data
Further updates may include access to other Pallex Nexus API functionality.
Pull requests welcome.

## Installation
```js
box install pallexNexusCFML
```

## Examples
Check out the `/examples` folder for an example implementation.

## Usage
The Pallex Nexus CFML wrapper currently consists of a core model which handles connection to the Pallex Nexus API endpoints.
A separate model exists for consignment functionality that both extends the core model, and is automatically instantiated and maintained _by_ it.
Subsequent updates may see more models added, and they should extend in the same way.
   
The wrapper may be used standalone, or as a ColdBox module.


### Standalone
```cfc
	// Instantiate PallexNexus core
	PallexNexusCFML = new models.pallexNexus(
			username 	= 'XXXXXXXX'
		,	password 	= 'XXXXXXXX'
		,	env 		= 'LIVE'
	);

```

### ColdBox
```cfc
PallexNexusCFML	= getInstance("PallexNexus@PallexNexusCFML");
```
alternatively inject it directly into your handler
```cfc
property name="PallexNexusCFML" inject="PallexNexus@PallexNexusCFML";
```

When using with ColdBox, you'll want to insert your API authentication details into your module settings:

```cfc
PallexNexusCFML = {
		username 	= getSystemSetting("PallexNexusCFML_USERNAME", "")
	,	password 	= getSystemSetting("PallexNexusCFML_PASSWORD", "")
}
```

### Retrieve consignment data
```cfc
// Consignment module functionality may be accessed with `getConsignments()`
consignments = PallexNexusCFML.getConsignments().retrive() (
		minCreatedDate = '2022-01-01'
	,	limit = 20
	,	offset = 0
);
```


## Author
Written by Gary Stanton.  
https://garystanton.co.uk
