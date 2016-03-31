(function (env) {
    "use strict";
    env.ddg_spice_trimet = function(api_result) {

        if (!api_result || api_result.error) {
            return Spice.failed('trimet');
        }
        
        Spice.add({
            id: "trimet",
            name: "TriMet",
            data: api_result.resultSet.arrival,
            meta: {
                primaryText: "Arrivals for " + api_result.resultSet.location[0].desc,
                itemType: "Arrivals",
                sourceName: "http://trimet.org",
                sourceUrl: 'http://example.com/url/to/details/' + api_result.name
            },
            normalize: function(item) {
                return {
                    arrival_time: format_time(item.estimated, item.scheduled),
                    arrives_in: countdown(item.estimated, item.scheduled),
                    name: item.shortSign,
                    status: item.locid,
                    title: item.shortSign,
                    subtitle: format_time(item.estimated, item.scheduled),
                    description: format_time(item.estimated, item.scheduled),
                    title_content: item.fullSign
                };
            },
            templates: {
                group: 'text',
                //detail: false,
                //item_detail: false,
                variants: {
                    //tile: 'basic4'
                },
                options: {
                    content: Spice.trimet.train_item,
                    moreAt: true
                }
            }
        });
    };
    function format_time(estimated, scheduled) {
        if (estimated) {
            var estimated_array = estimated.split('T');
            var estimated_time = estimated_array[1];
            return estimated_time.substr(0, 5);
        }
        else if (scheduled) {
            var scheduled_array = scheduled.split('T');
            var scheduled_time = scheduled_array[1];
            return scheduled_time.substr(0, 5);
        }
    };
    function countdown(estimated, scheduled) {
        if (estimated) {
            var arrival = format_time(estimated, scheduled);
            var date = new Date();
            var hours = date.getHours();
            var minutes = date.getMinutes();
            var time = parseInt(arrival);
            return time;
        }
        else if (scheduled) {
            return format_time(estimated, scheduled);
        }
    }
}(this));
