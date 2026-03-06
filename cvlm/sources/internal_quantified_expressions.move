/// Supporting functions for the `cvlm::quantified` module.  These are not intended to be used directly by end-users; 
/// use the macros in `cvlm::quantified` instead.
module cvlm::internal_quantified_expressions;

/* 
    These functions are treated specially by the Prover; they provide "markers" delineating the structure of quantified
    expressions.  Each expression must begin with a call to `quant_start`, followed by zero or more calls to
    `quant_var<T>` (one for each quantified variable), and ending with a call to `quant_for_all` or `quant_for_any` that
    takes the result of `quant_start` and the body of the quantified expression.
 */
public native fun quant_start(): u256;
public native fun quant_var<T>(): T;
public native fun quant_for_all(start: u256, expr: bool): bool;
public native fun quant_exists(start: u256, expr: bool): bool;

/*
    Used for type-checking quantified variables in the for_all_* macros.  We only define these for types that are 
    permitted as quantified variables.
 */
public fun quant_var_type_check_u256(x: u256): u256 { x }
public fun quant_var_type_check_address(x: address): address { x }
