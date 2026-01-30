#[allow(unused_function)]
#[test_only]
module certora::iota_event_summaries_testonly;

use cvlm::manifest::summary;
use certora::iota_event_summaries::{ event_count, events };

fun cvlm_manifest() {
    summary(b"num_events", @iota, b"event", b"num_events");
    summary(b"events_by_type", @iota, b"event", b"events_by_type");
}

// #[summary(iota::event::num_events)]
fun num_events(): u32 {
    *event_count()    
}

// #[summary(iota::event::events_by_type)]
fun events_by_type<T: copy + drop>(): vector<T> {
    *events<T>()
}