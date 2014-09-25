{new_var, sub_str, can_generalize} = require './syntax'

p = [(do new_var), (sub_str 'ABC'), (do new_var), (sub_str 'DEF')]
q = [(do new_var), (sub_str 'ABC'), (do new_var), (sub_str 'DEF')]

console.assert can_generalize p, "ABCDEF"
console.assert can_generalize q, "xxABCxxDEF"
console.assert not can_generalize p, "xxABxxDEF"
console.assert not can_generalize p, "xxABCDF"

r = [(do new_var), (sub_str 'ABC'), (do new_var), (sub_str 'BCD')]
console.assert not can_generalize r, "ABCD"
console.assert not can_generalize r, "ABCCD"
console.assert can_generalize r, "ABCBCD"
