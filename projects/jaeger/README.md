# Jaeger integration with Python

### Distributed tracing is a method used to profile and monitor applications, especially those built using a microservices architecture. Distributed tracing helps pinpoint where failures occur and what causes poor performance.

### Install Jaeger Client

```
$ pip install jaeger-client
```

### Running Jaeger backend as a Docker Image. The Image contains Jaeger UI, Collector, query and agent

```

  $ docker run -d -p6831:6831/udp -p16686:16686 jaegertracing/all-in-one:latest

```

## Check Docker Container Running 


```
$ docker ps

```

## Access the Jaeger UI 

### http://localhost:16686


## Creating Traces of Jaeger UI

### Create a Python script to create Traces. 

```
import sys
import time
import logging
import random
from jaeger_client import Config
from opentracing_instrumentation.request_context import get_current_span, span_in_context

def init_tracer(service):
    logging.getLogger('').handlers = []
    logging.basicConfig(format='%(message)s', level=logging.DEBUG)    
    config = Config(
        config={
            'sampler': {
                'type': 'const',
                'param': 1,
            },
            'logging': True,
        },
        service_name=service,
    )
    return config.initialize_tracer()

def booking_mgr(movie):
    with tracer.start_span('booking') as span:
        span.set_tag('Movie', movie)
        with span_in_context(span):
            cinema_details = check_cinema(movie)
            showtime_details = check_showtime(cinema_details)
            book_show(showtime_details)

def check_cinema(movie):
    with tracer.start_span('CheckCinema', child_of=get_current_span()) as span:
        with span_in_context(span):
            num = random.randint(1,30)
            time.sleep(num)
            cinema_details = "Cinema Details"
            flags = ['false', 'true', 'false']
            random_flag = random.choice(flags)
            span.set_tag('error', random_flag)
            span.log_kv({'event': 'CheckCinema' , 'value': cinema_details })
            return cinema_details

def check_showtime( cinema_details ):
    with tracer.start_span('CheckShowtime', child_of=get_current_span()) as span:
        with span_in_context(span):
            num = random.randint(1,30)
            time.sleep(num)
            showtime_details = "Showtime Details"
            flags = ['false', 'true', 'false']
            random_flag = random.choice(flags)
            span.set_tag('error', random_flag)
            span.log_kv({'event': 'CheckCinema' , 'value': showtime_details })
            return showtime_details

def book_show(showtime_details):
    with tracer.start_span('BookShow',  child_of=get_current_span()) as span:
        with span_in_context(span):
            num = random.randint(1,30)
            time.sleep(num)
            Ticket_details = "Ticket Details"
            flags = ['false', 'true', 'false']
            random_flag = random.choice(flags)
            span.set_tag('error', random_flag)
            span.log_kv({'event': 'CheckCinema' , 'value': showtime_details })
            print(Ticket_details)

assert len(sys.argv) == 2
tracer = init_tracer('booking')
movie = sys.argv[1]
booking_mgr(movie)
# yield to IOLoop to flush the spans
time.sleep(2)
tracer.close()



```
## Run the Python Script. Name the Python Script as moviebooking.py 

```
python moviebooking.py <movie-name>

```
 