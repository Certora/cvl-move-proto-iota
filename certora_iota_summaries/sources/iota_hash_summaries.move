#[allow(unused_function)]
module certora::iota_hash_summaries;

use cvlm::manifest::{ summary, ghost };

fun cvlm_manifest() {
    ghost(b"keccak256");
    ghost(b"blake2b256");
    summary(b"keccak256", @iota, b"hash", b"keccak256");
    summary(b"blake2b256", @iota, b"hash", b"blake2b256");
}

native fun keccak256(_: &vector<u8>): vector<u8>;
native fun blake2b256(_: &vector<u8>): vector<u8>;