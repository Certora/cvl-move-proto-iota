#[allow(unused_function)]
module certora::iota_types_summaries;

use cvlm::manifest::{ summary, ghost };

fun cvlm_manifest() {
    ghost(b"is_one_time_witness");
    summary(b"is_one_time_witness", @iota, b"types", b"is_one_time_witness");
}

public native fun is_one_time_witness<T: drop>(_: &T): bool;