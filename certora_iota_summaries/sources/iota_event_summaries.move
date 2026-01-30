#[allow(unused_function)]
module certora::iota_event_summaries;

use cvlm::manifest::{ summary, ghost };

fun cvlm_manifest() {
    ghost(b"event_count");
    ghost(b"events");

    summary(b"emit", @iota, b"event", b"emit");
}

//#[ghost]
public(package) native fun event_count(): &mut u32;

//#[ghost]
public(package) native fun events<T: copy + drop>(): &mut vector<T>;

// #[summary(iota::event::emit)]
fun emit<T: copy + drop>(event: T) {
    let count = event_count();
    *count = *count + 1;
    events<T>().push_back(event);
}
