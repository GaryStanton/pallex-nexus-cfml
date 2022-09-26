<!doctype html>

<cfscript>
	setting requesttimeout="600";
	if (StructKeyExists(URL, 'clear')) {
		StructDelete(Session, 'pallexNexus');
		location(url="/examples", addtoken="false");
	}

	if (StructKeyExists(Form, 'username') && StructKeyExists(Form, 'password') && structKeyExists(Form, 'env')) {
		Session.pallexNexus = new models.pallexNexus(
				username = form.username
			,	password = form.password
			,	env 	 = form.env
		);
	}
	else if (StructKeyExists(URL, 'dump')) {
		writeDump(Session.pallexNexus.getMemento());
	}

	if (StructKeyExists(Session, 'pallexNexus') && StructKeyExists(Form, 'action')) {
		switch(Form.action) {
			case 'listConsignments':
				consignments = Session.pallexNexus.getConsignments();
				writeDump(form);
				writeDump(consignments.list(ArgumentCollection = form));
			break;

			case 'retrieveConsignment':
				consignments = Session.pallexNexus.getConsignments();
				writeDump(form);
				writeDump(consignments.retrieve(ArgumentCollection = form));
			break;
		}
	}
</cfscript>

<html lang="en">
	<head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
		<title>Pallex Nexus CFML examples</title>
	</head>

	<body>
		<div class="container">
			<h1>Pallex Nexus CFML examples</h1>
			<hr>

			<cfoutput>

				<div class="row">
					<cfif structKeyExists(Session, 'pallexNexus')>
						<div class="col-sm-7">
							<div class="mr-7">
								<h2>List Consignments</h2>
								<p>Retrive a list of consignments matching the given criteria</p>

								<cfset formName = 'frmListConsignments' />
								<form method="POST" id="#formName#">
									<div class="form-group row">
										<label for="#formName#_minCreatedDate" class="col-sm">minCreatedDate</label>
										<div class="col-sm">
											<input type="text" class="form-control" id="#formName#_minCreatedDate" name="minCreatedDate" aria-describedby="minCreatedDate" placeholder="yyyy-mm-dd">
										</div>
									</div>

									<div class="form-group row">
										<label for="#formName#_maxCreatedDate" class="col-sm">maxCreatedDate</label>
										<div class="col-sm">
											<input type="text" class="form-control" id="#formName#_maxCreatedDate" name="maxCreatedDate" aria-describedby="maxCreatedDate" placeholder="yyyy-mm-dd">
										</div>
									</div>

									<div class="form-group row">
										<label for="#formName#_output" class="col-sm">Output</label>
										<div class="col-sm">
											<select class="form-control" id="#formName#_output" name="output">
												<option value="JSON">JSON</option>
												<option value="RAW">RAW</option>
												<option value="DEBUG">DEBUG</option>
											</select>
										</div>
									</div>


									<div class="input-group">
										<button type="submit" class="btn btn-primary" type="button" name="action" value="listConsignments">List consignments</button>
									</div>
								</form>
							</div>

							<hr />

							<div>
								<h2>Retrieve Consignment data</h2>
								<p>Retrive a single consignment by ID</p>

								<cfset formName = 'frmRetrieveConsignment' />
								<form method="POST">
									<div class="form-group row">
										<label for="#formName#_consignmentID" class="col-sm">consignmentID</label>
										<div class="col-sm">
											<input type="text" class="form-control" id="#formName#_consignmentID" name="consignmentID" aria-describedby="consignmentID" placeholder="0000000">
										</div>
									</div>

									<div class="form-group row">
										<label for="#formName#_output" class="col-sm">Output</label>
										<div class="col-sm">
											<select class="form-control" id="#formName#_output" name="output">
												<option value="JSON">JSON</option>
												<option value="RAW">RAW</option>
												<option value="DEBUG">DEBUG</option>
											</select>
										</div>
									</div>

									<div class="input-group">
										<button type="submit" class="btn btn-primary" type="button" name="action" value="retrieveConsignment">Retrieve consignment data</button>
									</div>
								</form>
							</div>
						</div>
						<div class="col-sm-5">
							<h3>API details</h3>
							<table class="table">
								<tr>
									<td>Username</td>
									<td>#EncodeForHTML(session.pallexNexus.getUsername())#</td>
								</tr>
								<tr>
									<td>Password</td>
									<td>#EncodeForHTML(session.pallexNexus.getPassword())#</td>
								</tr>
								<tr>
									<td>Bearer token</td>
									<td><div style="width: 300px; word-wrap: break-word;">#EncodeForHTML(session.pallexNexus.getBearerToken())#</div></td>
								</tr>
								<tr>
									<td>Token timestamp</td>
									<td>#EncodeForHTML(session.pallexNexus.getTokenTimeStamp())#</td>
								</tr>
							</table>
							<a href="?clear" class="btn btn-danger btn-sm">Clear</a>
						</div>
					<cfelse> 
						<div class="col-sm-12">
							<h2>Authentication</h2>
							<p>Provide an active username and password to use the Pallex Nexus API</p>

							<div class="col-sm-6">
								<form method="POST">
									<div class="form-group row">
										<label for="username" class="col-sm">Username</label>
										<div class="col-sm">
											<input type="text" required="true" class="form-control" id="username" name="username" aria-describedby="username">
										</div>
									</div>
									<div class="form-group row">
										<label for="password" class="col-sm">Password</label>
										<div class="col-sm">
											<input type="password" required="true" class="form-control" id="password" name="password" aria-describedby="password">
										</div>
									</div>
									<div class="form-group row">
										<label for="env" class="col-sm">Environment</label>
										<select class="form-control col-sm" id="env" name="env">
											<option value="TEST">Test</option>
											<option value="LIVE">Live</option>
										</select>
									</div>

									<button type="submit" class="btn btn-primary" type="button" name="action" value="initAPI">Init API</button>
								</form>
							</div>
						</div>
					</cfif>
				</div>

			</cfoutput>
		</div>
	</body>
</html>