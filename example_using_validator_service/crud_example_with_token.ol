from .key_validator import ValidatorInterface
from .key_validator import TokenError

// Some data types
type IdRequest { id:string }
type PersonRequest { id: string 
                     name: string
                     age: int
                     email: string}
type StatusResponse { status:string }

interface PersonCrudInterface {
    RequestResponse: create( PersonRequest )( StatusResponse )
    RequestResponse: delete( IdRequest )( StatusResponse )
    RequestResponse: update( PersonRequest )( StatusResponse )
    RequestResponse: read( IdRequest )( StatusResponse )
}

service Greeter {
    execution: concurrent 

    inputPort CRUDInput {
        location: "socket://localhost:8080" 
        protocol: http { format = "json" }    
        interfaces: PersonCrudInterface    
    }

    outputPort Validator {
        Location: "socket://localhost:8081"
        protocol: http { format = "json" }   
        interfaces: ValidatorInterface
    }

    main {
        //API is protected with the authorize at Validator call.
        [create( request )( response ) {
            scope (check_key) {
                install ( Exception =>
                    response.status = "Error not allowed token" )
                //Someway to get the actual token here
                authorize@Validator({token="token"})()
            }
            response.status = "Hello, " + request.name + "\n" + request + "\nThe person has succesfully been addded"
        }]

        [delete( request )( response ) {
            response.status = "Person with the id: " + request.id + ", Has been deleted"
        }]

        [update( request )( response ) {
            response.status = "Hello, " + request.name + "\n" + request + "\nThe person has succesfully been updated based on the id"
        }]

        [read( request )( response ) {
            response.status = "Hello, " + request.id
        }]
    }
}