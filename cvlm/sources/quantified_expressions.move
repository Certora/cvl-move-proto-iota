/// Provies support for quantified expressions in CVLM specifications.  The `for_all_*` macros support "universal" 
/// quantification, while the `exists_*` macros support "existential" quantification, over some number of variables
/// (currently up to 3).  
///
/// Quantified variables must be of type `u256` or `address` (more types may be allowed in the future).
///
/// The lambda passed to the quantified expression macro must be a pure expression, and should be kept relatively 
/// simple.  The Prover may fail to verify specifications with complex quantified expressions.
module cvlm::quantified_expressions;

use cvlm::internal_quantified_expressions::{quant_start, quant_var, quant_for_all, quant_exists};

// We provide quant_var_type_check methods for each type that can be used as a quantified variable.  If the macro is 
// used with another type, the compiler will fail with an error about no method `quant_var_type_check` being found for 
// that type, which is hopefully clear enough to guide users to the issue.
use fun cvlm::internal_quantified_expressions::quant_var_type_check_u256 as u256.quant_var_type_check;
use fun cvlm::internal_quantified_expressions::quant_var_type_check_address as address.quant_var_type_check;

/// See `cvlm::quantified_expressions`
public macro fun for_all_1<$T>($expr: |$T| -> bool): bool {    
    quant_for_all(
        quant_start(), 
        $expr(
            quant_var<$T>().quant_var_type_check()
        )
    )
}

/// See `cvlm::quantified_expressions`
public macro fun for_all_2<$T1, $T2>($expr: |$T1, $T2| -> bool): bool {    
    quant_for_all(
        quant_start(), 
        $expr(
            quant_var<$T1>().quant_var_type_check(), 
            quant_var<$T2>().quant_var_type_check()
        )
    )
}

/// See `cvlm::quantified_expressions`
public macro fun for_all_3<$T1, $T2, $T3>($expr: |$T1, $T2, $T3| -> bool): bool {    
    quant_for_all(
        quant_start(), 
        $expr(
            quant_var<$T1>().quant_var_type_check(), 
            quant_var<$T2>().quant_var_type_check(), 
            quant_var<$T3>().quant_var_type_check()
        )
    )
}

/// See `cvlm::quantified_expressions`
public macro fun exists_1<$T>($expr: |$T| -> bool): bool {    
    quant_exists(
        quant_start(), 
        $expr(
            quant_var<$T>().quant_var_type_check()
        )
    )
}

/// See `cvlm::quantified_expressions`
public macro fun exists_2<$T1, $T2>($expr: |$T1, $T2| -> bool): bool {    
    quant_exists(
        quant_start(), 
        $expr(
            quant_var<$T1>().quant_var_type_check(), 
            quant_var<$T2>().quant_var_type_check()
        )
    )
}

/// See `cvlm::quantified_expressions`
public macro fun exists_3<$T1, $T2, $T3>($expr: |$T1, $T2, $T3| -> bool): bool {    
    quant_exists(
        quant_start(), 
        $expr(
            quant_var<$T1>().quant_var_type_check(), 
            quant_var<$T2>().quant_var_type_check(), 
            quant_var<$T3>().quant_var_type_check()
        )
    )
}