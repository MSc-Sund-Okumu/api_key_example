// Some data types
type TokenRequest { token:string }
type StatusResponse { status:string }
type TokenError: void {
    .exceptionMessage: string
}

interface ValidatorInterface {
    RequestResponse: authorize( TokenRequest )( StatusResponse ) throws Exception(TokenError)
}

service Validator {
    execution: concurrent

    inputPort ValidatorInput {
        location: "socket://localhost:8081" 
        protocol: http { format = "json" }   
        interfaces: ValidatorInterface     
    }

    main {
        authorize( request )( response ) {
            //Potential to create RBAC quite easily here
            if (request.token != "magisk") {
                with( exceptionMessage ){
      				.exceptionMessage = "Token not valid"
    			};
                throw(Exception, exceptionMessage)
            }
            response.status = "Validated"
        }
    }
}