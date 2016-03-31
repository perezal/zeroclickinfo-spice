package DDG::Spice::Trimet;

# ABSTRACT: Trimet Spice returns arrival times to specified stops

use DDG::Spice;

spice to => 'http://developer.trimet.org/ws/V1/arrivals?locIDs=$1&appID=EEC2E165C636DB6E52C2B0084&json=true&callback={{callback}}';

spice is_cached => 1;
spice proxy_cache_valid => "418 1d";

spice wrap_jsonp_callback => 0;

triggers any => 'trimet';

handle remainder => sub {
    my @location = ($loc->latitude, $loc->longitude);
    my @test_stops = ([45.532772, -122.620708, 8455], [45.496418,-122.68222, 8344], [40,-75,4]);
    my @distance_stops;
    
    #iterate through each stop, find the distance between the user and the stop, then push those distances with the stop ID into an array.
    for my $stop (@test_stops) {
        my $distance = sqrt( ($location[0] - @$stop[0])**2 + ($location[1] - @$stop[1])**2 );
        my @stop_data = ( $distance, @$stop[2] );
        push @distance_stops, [ @stop_data ];
    }
    
    #sort the stops in the array by distance.
    @distance_stops = sort { @$a[0] > @$b[0] } @distance_stops;
    
    #check to make sure the stop is the least distance and return its stop ID.
    if ($distance_stops[0][0] < $distance_stops[1][0] && $distance_stops[0][0] < $distance_stops[2][0]) {
        return $distance_stops[0][1];
    }
    elsif ($distance_stops[0][0] > $distance_stops[1][0]){
        return;
    }
    else {
    return;
    }
    #return $_ if $_;
};

1;
