#[allow(unused_function)]
module certora::iota_hex_summaries;

use cvlm::nondet::nondet;
use cvlm::manifest::{ summary };

fun cvlm_manifest() {
    summary(b"encode", @iota, b"hex", b"encode");
    summary(b"decode", @iota, b"hex", b"decode");
}

// #[summary(iota::hex::encode)]
fun encode(_: vector<u8>): vector<u8> { nondet() }

// #[summary(iota::hex::decode)]
fun decode(_: vector<u8>): vector<u8> { nondet() }