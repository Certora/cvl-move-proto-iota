#[allow(unused_function, unused_mut_parameter)]
module certora::iota_vec_set_summaries;

use cvlm::ghost::{ ghost_write };
use cvlm::manifest::{ shadow, summary };
use cvlm::nondet::nondet;
use iota::vec_set::VecSet;

fun cvlm_manifest() {
    shadow(b"shadow_vec_set");
    shadow(b"present");
    summary(b"empty", @iota, b"vec_set", b"empty");
    summary(b"size", @iota, b"vec_set", b"size");
    summary(b"insert", @iota, b"vec_set", b"insert");
    summary(b"remove", @iota, b"vec_set", b"remove");
    summary(b"contains", @iota, b"vec_set", b"contains");
    summary(b"singleton", @iota, b"vec_set", b"singleton");
    summary(b"into_keys", @iota, b"vec_set", b"into_keys");
}

public struct ShadowVecSet<K: copy + drop> has copy, drop, store {
    size: u64,
    contents: ShadowContents<K>,
    indexed: vector<K>,
}
public native struct ShadowContents<K: copy + drop> has copy, drop, store;

// #[shadow]
native fun shadow_vec_set<K: copy + drop>(map: &VecSet<K>): &mut ShadowVecSet<K>;

// #[shadow]
native fun present<K: copy + drop>(contents: &ShadowContents<K>, key: K): &mut bool;

// #[summary(iota::vec_set::empty)]
fun empty<K: copy + drop>(): VecSet<K> {
    let set = nondet<VecSet<K>>();
    let shadow = shadow_vec_set(&set);
    shadow.size = 0;
    set
}

// #[summary(iota::vec_set::size)]
fun size<K: copy + drop>(self: &VecSet<K>): u64 {
    shadow_vec_set(self).size
}


// #[summary(iota::vec_set::insert)]
fun insert<K: copy + drop>(self: &mut VecSet<K>, key: K) {
    let set = shadow_vec_set(self);
    let present = present(&set.contents, key);
    assert!(!*present);
    *present = true;
    set.size = set.size + 1;
    set.indexed.push_back(key);
}

// #[summary(iota::vec_set::remove)]
fun remove<K: copy + drop>(self: &mut VecSet<K>, key: &K) {
    let set = shadow_vec_set(self);
    let present = present(&set.contents, *key);
    assert!(*present);
    *present = false;
    set.size = set.size - 1;
    ghost_write(&mut set.indexed, nondet());
}

// #[summary(iota::vec_set::contains)]
fun contains<K: copy + drop>(self: &VecSet<K>, key: &K): bool {
    let set = shadow_vec_set(self);
    *present(&set.contents, *key)
}

// #[summary(iota::vec_set::singleton)]
public fun singleton<K: copy + drop>(key: K): VecSet<K> {
    let set = nondet<VecSet<K>>();
    let shadow = shadow_vec_set(&set);
    *present(&shadow.contents, key) = true;
    shadow.size = 1;
    shadow.indexed = vector[key];
    set
}

// #[summary(iota::vec_set::into_keys)]
public fun into_keys<K: copy + drop>(self: VecSet<K>): vector<K> {
    shadow_vec_set(&self).indexed
}