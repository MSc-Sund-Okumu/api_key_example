from .base import AddingAPI
from console import Console
from .aggregator import AggregatorInterface

service Client {
    outputPort Aggregator {
        location: "socket://localhost:8081"
        protocol: sodep
        interfaces: AddingAPI, AggregatorInterface
    }
    embed Console as Console
    main {
        add@Aggregator({summand1= 2, summand2= 4})(result);
        addd@Aggregator(1)(result2);

        println@Console("result:" + result)()
        println@Console("result2:" + result2)()
    }
}