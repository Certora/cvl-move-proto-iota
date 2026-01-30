module certora::iota_system_sui_system_summaries;

use cvlm::manifest::{ summary, ghost };
use iota_system::iota_system::IotaSystemState;
use iota_system::iota_system_state_inner::IotaSystemStateV2;

public fun cvlm_manifest() {
    summary(b"load_inner_maybe_upgrade", @iota_system, b"sui_system", b"load_inner_maybe_upgrade");
    ghost(b"the_system_state_inner_v2");
}

native fun the_system_state_inner_v2(): &mut IotaSystemStateV2;

public fun load_inner_maybe_upgrade(_self: &mut IotaSystemState): &mut IotaSystemStateV2 { 
    // IotaSystemState is a singleton, so we can just always return the same IotaSystemStateV2 instance
    the_system_state_inner_v2() 
}
