// Basic Arithmetic Functions in GML

/// @function Add(a, b)
/// @description Adds two numbers.
/// @param {real} a The first number.
/// @param {real} b The second number.
/// @returns {real} The sum of a and b.
function Add(a, b) {
    return a + b;
}

/// @function Subtract(a, b)
/// @description Subtracts one number from another.
/// @param {real} a The number to subtract from.
/// @param {real} b The number to subtract.
/// @returns {real} The difference of a and b.
function Subtract(a, b) {
    return a - b;
}

/// @function Multiply(a, b)
/// @description Multiplies two numbers.
/// @param {real} a The first number.
/// @param {real} b The second number.
/// @returns {real} The product of a and b.
function Multiply(a, b) {
    return a * b;
}

/// @function Divide(a, b)
/// @description Divides one number by another.
/// @param {real} a The dividend.
/// @param {real} b The divisor.
/// @returns {real} The quotient of a and b, or infinity if b is 0.
function Divide(a, b) {
    if (b == 0) {
        return infinity;
    }
    return a / b;
}

/// @function IntegerDivide(a, b)
/// @description Performs integer division of one number by another.
/// @param {real} a The dividend.
/// @param {real} b The divisor.
/// @returns {real} The integer quotient of a and b, or infinity if b is 0.
function IntegerDivide(a, b) {
    if (b == 0) {
        return infinity;
    }
    return floor(a / b);
}

/// @function Modulo(a, b)
/// @description Calculates the remainder of a division.
/// @param {real} a The dividend.
/// @param {real} b The divisor.
/// @returns {real} The remainder of a divided by b, or infinity if b is 0.
function Modulo(a, b) {
    if (b == 0) {
        return infinity;
    }
    return a mod b;
}

/// @function Power(a, b)
/// @description Raises a number to a power.
/// @param {real} a The base.
/// @param {real} b The exponent.
/// @returns {real} a raised to the power of b.
function Power(a, b) {
    return power(a, b);
}

// More Advanced Math Functions in GML

/// @function SquareRoot(a)
/// @description Calculates the square root of a number.
/// @param {real} a The number.
/// @returns {real} The square root of a, or NaN if a is negative.
function SquareRoot(a) {
    if (a < 0) {
        return NaN;
    }
    return sqrt(a);
}

/// @function AbsoluteValue(a)
/// @description Calculates the absolute value of a number.
/// @param {real} a The number.
/// @returns {real} The absolute value of a.
function AbsoluteValue(a) {
    return abs(a);
}

/// @function Negate(a)
/// @description Negates a number.
/// @param {real} a The number.
/// @returns {real} The negation of a.
function Negate(a) {
    return -a;
}

/// @function Sin(a)
/// @description Calculates the sine of an angle in radians.
/// @param {real} a The angle in radians.
/// @returns {real} The sine of a.
function Sin(a) {
    return sin(a);
}

/// @function Cos(a)
/// @description Calculates the cosine of an angle in radians.
/// @param {real} a The angle in radians.
/// @returns {real} The cosine of a.
function Cos(a) {
    return cos(a);
}

/// @function Tan(a)
/// @description Calculates the tangent of an angle in radians.
/// @param {real} a The angle in radians.
/// @returns {real} The tangent of a.
function Tan(a) {
    return tan(a);
}

/// @function ArcSin(a)
/// @description Calculates the arcsine (inverse sine) of a number.
/// @param {real} a The number.
/// @returns {real} The arcsine of a in radians, or NaN if a is outside the range [-1, 1].
function ArcSin(a) {
    if (a < -1 || a > 1) {
        return NaN;
    }
    return arcsin(a);
}

/// @function ArcCos(a)
/// @description Calculates the arccosine (inverse cosine) of a number.
/// @param {real} a The number.
/// @returns {real} The arccosine of a in radians, or NaN if a is outside the range [-1, 1].
function ArcCos(a) {
    if (a < -1 || a > 1) {
        return NaN;
    }
    return arccos(a);
}

/// @function ArcTan(a)
/// @description Calculates the arctangent (inverse tangent) of a number.
/// @param {real} a The number.
/// @returns {real} The arctangent of a in radians.
function ArcTan(a) {
    return arctan(a);
}

/// @function Logarithm(a, base)
/// @description Calculates the logarithm of a number to a specified base.
/// @param {real} a The number.
/// @param {real} base The base of the logarithm.
/// @returns {real} The logarithm of a to the base, or NaN if a <= 0 or base <= 0 or base == 1.
function Logarithm(a, base) {
    if (a <= 0 || base <= 0 || base == 1) {
        return NaN;
    }
    return ln(a) / ln(base);
}

/// @function NaturalLogarithm(a)
/// @description Calculates the natural logarithm (base e) of a number.
/// @param {real} a The number.
/// @returns {real} The natural logarithm of a, or NaN if a <= 0.
function NaturalLogarithm(a) {
    if (a <= 0) {
        return NaN;
    }
    return ln(a);
}

/// @function Exponential(a)
/// @description Calculates e raised to the power of a number.
/// @param {real} a The exponent.
/// @returns {real} e raised to the power of a.
function Exponential(a) {
    return exp(a);
}

/// @function Floor(a)
/// @description Rounds a number down to the nearest integer.
/// @param {real} a The number.
/// @returns {real} The floor of a.
function Floor(a) {
    return floor(a);
}

/// @function Ceil(a)
/// @description Rounds a number up to the nearest integer.
/// @param {real} a The number.
/// @returns {real} The ceiling of a.
function Ceil(a) {
    return ceil(a);
}

/// @function Round(a)
/// @description Rounds a number to the nearest integer.
/// @param {real} a The number.
/// @returns {real} The rounded value of a.
function Round(a) {
    return round(a);
}