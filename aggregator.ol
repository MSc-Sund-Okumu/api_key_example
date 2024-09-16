from .base import AddingAPI
from .base import adder
from console import Console
interface AggregatorInterface {
    RequestResponse:
        addd(int)(int)
}

service Api_key_service {
    execution: concurrent
    
    outputPort AdderPort {
    location: "socket://localhost:8080"
    protocol: http
    interfaces: AddingAPI

    }
   inputPort api_key {
        location: "socket://localhost:8081"
        protocol: sodep
        interfaces: AggregatorInterface
        aggregates: AdderPort
    }
    embed Console as Console
    
    
    define validate_api_key {
        
        role = 12425
    }
    courier api_key {
        [ add(request)(response)] {
            forward(request)(response)
        }
        /*
        [ sub(request)(response)] {

        }
        */
    }

    embed adder
    main {    
            addd(dummy)(owo){
            owo = dummy + 5
            }
        }
}
