#[allow(unused_function)]
module certora::iota_dynamic_field_summaries;

use cvlm::ghost::{ ghost_read, ghost_write };
use cvlm::manifest::{ summary, ghost, hash };
use std::type_name;
use std::type_name::TypeName;
use certora::iota_object_summaries::borrow_uid;

fun cvlm_manifest() {
    ghost(b"child_object_value");
    ghost(b"child_object_type");

    hash(b"raw_hash_type_and_key");

    summary(b"hash_type_and_key", @iota, b"dynamic_field", b"hash_type_and_key");
    summary(b"has_child_object", @iota, b"dynamic_field", b"has_child_object");
    summary(b"has_child_object_with_ty", @iota, b"dynamic_field", b"has_child_object_with_ty");
    summary(b"borrow_child_object", @iota, b"dynamic_field", b"borrow_child_object");
    summary(b"borrow_child_object_mut", @iota, b"dynamic_field", b"borrow_child_object_mut");
    summary(b"add_child_object", @iota, b"dynamic_field", b"add_child_object");
    summary(b"remove_child_object", @iota, b"dynamic_field", b"remove_child_object");
}

// #[ghost]
native fun child_object_value<Child: key>(parent: address, id: address): &mut Child;
// #[ghost]
native fun child_object_type(parent: address, id: address): &mut TypeName;

// Type for use in child_object_type, when the child object is not present.
public struct NotPresent {}


// #[hash]
native fun raw_hash_type_and_key<Key: copy + drop + store>(parent: address, key: Key): u256;

// #[summary(iota::dynamic_field::hash_type_and_key)]
fun hash_type_and_key<Key: copy + drop + store>(parent: address, key: Key): address {
    iota::address::from_u256(raw_hash_type_and_key(parent, key))
}

// #[summary(iota::dynamic_field::has_child_object)]
fun has_child_object(parent: address, id: address): bool {
    child_object_type(parent, id) != type_name::get<NotPresent>()
}

// #[summary(iota::dynamic_field::has_child_object_with_ty)]
fun has_child_object_with_ty<Child: key>(parent: address, id: address): bool {
    *child_object_type(parent, id) == type_name::get<Child>()
}

// #[summary(iota::dynamic_field::borrow_child_object)]
fun borrow_child_object<Child: key>(object: &UID, id: address): &Child {
    let parent = object.to_address();
    assert!(has_child_object_with_ty<Child>(parent, id));
    child_object_value(parent, id)
}

// #[summary(iota::dynamic_field::borrow_child_object_mut)]
#[allow(unused_mut_parameter)]
fun borrow_child_object_mut<Child: key>(object: &mut UID, id: address): &mut Child {
    let parent = object.to_address();
    assert!(has_child_object_with_ty<Child>(parent, id));
    child_object_value(parent, id)
}

// #[summary(iota::dynamic_field::add_child_object)]
fun add_child_object<Child: key>(parent: address, child: Child) {
    let uid = borrow_uid(&child);
    let id = uid.to_address();
    assert!(!has_child_object(parent, id));
    *child_object_type(parent, id) = type_name::get<Child>();
    add_child_object_hook(uid);
    ghost_write(child_object_value(parent, id), child);
}

fun add_child_object_hook(_child_id: &UID) {
    /*
        This function is called each time a child object is added to a parent.  Specs can summarize this function to add
        assumptions about the child object.  This is useful for expressing that the child object does not itself have
        any child objects yet, by enumerating the possible types of child objects it does not have.

        (This is because we don't have quantified expressions, so we can't express "for all child names, there is no
        child object with that name".)

        For example:

        ```

        use iota::{ object, dynamic_field };
        use cvlm::manifest::summary;
        use cvlm::asserts::cvlm_assume_msg;

        fun cvlm_manifest() {
            summary(b"add_child_object_hook", @certora_iota_summaries, b"iota_dynamic_field_summaries", b"add_child_object_hook");
        }

        fun add_child_object_hook(child_id: &UID) {            
            cvlm_assume_msg(!dynamic_field::exists_(child_id, SomeChildName()));
            cvlm_assume_msg(!dynamic_field::exists_(child_id, SomeOtherChildName()));
        }
     */
}

// #[summary(iota::dynamic_field::remove_child_object)]
fun remove_child_object<Child: key>(parent: address, id: address): Child {
    assert!(has_child_object_with_ty<Child>(parent, id));
    *child_object_type(parent, id) = type_name::get<NotPresent>();
    ghost_read(child_object_value(parent, id))
}