#
# This is an example VCL file for Varnish.
#
# It does not do anything by default, delegating control to the
# builtin VCL. The builtin VCL is called when there is no explicit
# return statement.
#
# See the VCL chapters in the Users Guide at https://www.varnish-cache.org/docs/
# and https://www.varnish-cache.org/trac/wiki/VCLExamples for more examples.

# Marker to tell the VCL compiler that this VCL has been adapted to the
# new 4.0 format.
vcl 4.0;

# Default backend definition. Set this to point to your content server.
backend default {
    .host = "127.0.0.1";
    .port = "8080";
}

backend lic {
    .host = "ffaa-prod-prm.dof6.com";
    .port = "80";
}

#backend movistarplus {
#    .host = "www.movistarplus.es";
#    .port = "80";
#}

#backend stageclientservices {
#    .host = "stage-clientservices.dof6.com";
#    .port = "80";
#}

#backend voddelivery {
#    .host = "voddelivery.dof6.com";
#    .port = "80";
#}

sub vcl_recv {
    # Happens before we check if we have this in cache already.
    #
    # Typically you clean up the request here, removing cookies you don't need,
    # rewriting the request, etc.
#    if (req.http.host ~ "movitarplus.es") {
#        set req.backend_hint = movistarplus;
#    } elsif (req.http.host ~ "stage-clientservices.dof6.com") {
#        set req.backend_hint = stageclientservices;
#    } elsif (req.http.host ~ "voddelivery.dof6.com") {
#        set req.backend_hint = voddelivery;
#    }
    if (req.http.host ~ "lic.playrenfe.dof6.com") {
        set req.backend_hint = lic;
        return(pass);
    }
    if (req.http.host ~ "(.*).vod.cdn.telefonica.com") {
        return(pass);
    }
}

sub vcl_backend_response {
    # Happens after we have read the response headers from the backend.
    #
    # Here you clean the response headers, removing silly Set-Cookie headers
    # and other mistakes your backend does.
    set beresp.ttl = 60m;
}

sub vcl_deliver {
    # Happens when we have all the pieces we need, and are about to send the
    # response to the client.
    #
    # You can do accounting or modifying the final object here.
}
