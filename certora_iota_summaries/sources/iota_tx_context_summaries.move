#[allow(unused_function)]
module certora::iota_tx_context_summaries;

use cvlm::conversions::u256_to_address;
use cvlm::manifest::{ summary, hash };

fun cvlm_manifest() {
    summary(b"derive_id", @iota, b"tx_context", b"derive_id");
    hash(b"derive_id_hash");
}

native fun derive_id_hash(tx_hash: vector<u8>, ids_created: u64): u256;

fun derive_id(tx_hash: vector<u8>, ids_created: u64): address {
    u256_to_address(derive_id_hash(tx_hash, ids_created))
}