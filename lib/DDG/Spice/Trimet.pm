package DDG::Spice::Trimet;

# ABSTRACT: Trimet Spice returns arrival times to specified stops

use DDG::Spice;

spice to => 'http://developer.trimet.org/ws/V1/arrivals?locIDs=$1&appID=EEC2E165C636DB6E52C2B0084&json=true&callback={{callback}}';

spice is_cached => 1;
spice proxy_cache_valid => "418 1d";

spice wrap_jsonp_callback => 0;

triggers any => 'trimet';

handle remainder => sub {

    return $_ if $_;
};

1;
