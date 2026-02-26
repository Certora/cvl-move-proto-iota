#[allow(unused_function)]
module certora::iota_config_summaries;

use cvlm::manifest::{ summary, ghost };

fun cvlm_manifest() {
    ghost(b"read_setting_impl");
    summary(b"read_setting_impl", @iota, b"config", b"read_setting_impl");
}

native fun read_setting_impl<
    FieldSettingValue: key,
    SettingValue: store,
    SettingDataValue: store,
    Value: copy + drop + store,
>(
    config: address,
    name: address,
    current_epoch: u64,
): Option<Value>;
