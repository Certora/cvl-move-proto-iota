#[allow(unused_function)]
module certora::iota_tx_context_summaries;

use cvlm::manifest::{ summary, hash };

fun cvlm_manifest() {
    summary(b"derive_id", @iota, b"tx_context", b"derive_id");
    hash(b"derive_id");
}

native fun derive_id(tx_hash: vector<u8>, ids_created: u64): address;