// Basic Comparisons

/// @function LessThan(a, b)
/// @description Checks if a is less than b.
/// @param {real} a The first value.
/// @param {real} b The second value.
/// @returns {bool} True if a < b, false otherwise.
function LessThan(a, b) {
    return a < b;
}

/// @function GreaterThan(a, b)
/// @description Checks if a is greater than b.
/// @param {real} a The first value.
/// @param {real} b The second value.
/// @returns {bool} True if a > b, false otherwise.
function GreaterThan(a, b) {
    return a > b;
}

/// @function EqualTo(a, b)
/// @description Checks if a is equal to b.
/// @param {any} a The first value.
/// @param {any} b The second value.
/// @returns {bool} True if a == b, false otherwise.
function EqualTo(a, b) {
    return a == b;
}

/// @function LessThanOrEqualTo(a, b)
/// @description Checks if a is less than or equal to b.
/// @param {real} a The first value.
/// @param {real} b The second value.
/// @returns {bool} True if a <= b, false otherwise.
function LessThanOrEqualTo(a, b) {
    return a <= b;
}

/// @function GreaterThanOrEqualTo(a, b)
/// @description Checks if a is greater than or equal to b.
/// @param {real} a The first value.
/// @param {real} b The second value.
/// @returns {bool} True if a >= b, false otherwise.
function GreaterThanOrEqualTo(a, b) {
    return a >= b;
}

/// @function NotEqualTo(a, b)
/// @description Checks if a is not equal to b.
/// @param {any} a The first value.
/// @param {any} b The second value.
/// @returns {bool} True if a != b, false otherwise.
function NotEqualTo(a, b) {
    return a != b;
}

// Range Comparisons

/// @function IsInRange(value, min, max)
/// @description Checks if a value is within a specified range.
/// @param {real} value The value to check.
/// @param {real} min The minimum value of the range.
/// @param {real} max The maximum value of the range.
/// @returns {bool} True if value is within the range, false otherwise.
function IsInRange(value, min, max) {
    return value >= min && value <= max;
}

/// @function IsNotInRange(value, min, max)
/// @description Checks if a value is outside a specified range.
/// @param {real} value The value to check.
/// @param {real} min The minimum value of the range.
/// @param {real} max The maximum value of the range.
/// @returns {bool} True if value is outside the range, false otherwise.
function IsNotInRange(value, min, max) {
    return value < min || value > max;
}

// Bitwise Comparisons (if needed for specific game logic)

/// @function BitwiseAnd(a, b)
/// @description Performs a bitwise AND operation.
/// @param {real} a The first value.
/// @param {real} b The second value.
/// @returns {real} The result of a & b.
function BitwiseAnd(a, b) {
    return a & b;
}

/// @function BitwiseOr(a, b)
/// @description Performs a bitwise OR operation.
/// @param {real} a The first value.
/// @param {real} b The second value.
/// @returns {real} The result of a | b.
function BitwiseOr(a, b) {
    return a | b;
}

/// @function BitwiseXor(a, b)
/// @description Performs a bitwise XOR operation.
/// @param {real} a The first value.
/// @param {real} b The second value.
/// @returns {real} The result of a ^ b.
function BitwiseXor(a, b) {
    return a ^ b;
}

/// @function BitwiseNot(a)
/// @description Performs a bitwise NOT operation.
/// @param {real} a The value.
/// @returns {real} The result of ~a.
function BitwiseNot(a) {
    return ~a;
}

/// @function BitwiseLeftShift(a, b)
/// @description Performs a bitwise left shift operation.
/// @param {real} a The value to shift.
/// @param {real} b The number of bits to shift.
/// @returns {real} The result of a << b.
function BitwiseLeftShift(a, b) {
    return a << b;
}

/// @function BitwiseRightShift(a, b)
/// @description Performs a bitwise right shift operation.
/// @param {real} a The value to shift.
/// @param {real} b The number of bits to shift.
/// @returns {real} The result of a >> b.
function BitwiseRightShift(a, b) {
    return a >> b;
}

// String Comparisons (if strings are relevant to your AI)

/// @function StringEquals(str1, str2)
/// @description Checks if two strings are equal.
/// @param {string} str1 The first string.
/// @param {string} str2 The second string.
/// @returns {bool} True if str1 == str2, false otherwise.
function StringEquals(str1, str2) {
    return str1 == str2;
}

/// @function StringContains(str, substr)
/// @description Checks if a string contains a substring.
/// @param {string} str The string to search.
/// @param {string} substr The substring to find.
/// @returns {bool} True if str contains substr, false otherwise.
function StringContains(str, substr) {
    return string_pos(substr, str) > 0;
}

/// @function StringStartsWith(str, prefix)
/// @description Checks if a string starts with a prefix.
/// @param {string} str The string to check.
/// @param {string} prefix The prefix to check for.
/// @returns {bool} True if str starts with prefix, false otherwise.
function StringStartsWith(str, prefix) {
    return string_copy(str, 1, string_length(prefix)) == prefix;
}

/// @function StringEndsWith(str, suffix)
/// @description Checks if a string ends with a suffix.
/// @param {string} str The string to check.
/// @param {string} suffix The suffix to check for.
/// @returns {bool} True if str ends with suffix, false otherwise.
function StringEndsWith(str, suffix) {
    var suffixLength = string_length(suffix);
    var strLength = string_length(str);
    if (suffixLength > strLength) {
        return false;
    }
    return string_copy(str, strLength - suffixLength + 1, suffixLength) == suffix;
}

// Boolean Comparisons

/// @function IsTrue(value)
/// @description Checks if a value is true.
/// @param {bool} value The value to check.
/// @returns {bool} True if value is true, false otherwise.
function IsTrue(value) {
    return value == true;
}

/// @function IsFalse(value)
/// @description Checks if a value is false.
/// @param {bool} value The value to check.
/// @returns {bool} True if value is false, false otherwise.
function IsFalse(value) {
    return value == false;
}

// Object/Instance Comparisons (if applicable)

/// @function InstanceExists(instanceId)
/// @description Checks if an instance exists.
/// @param {id} instanceId The instance ID.
/// @returns {bool} True if the instance exists, false otherwise.
function InstanceExists(instanceId) {
    return instance_exists(instanceId);
}

/// @function InstanceOf(instanceId, objectIndex)
/// @description Checks if an instance is of a specific object type.
/// @param {id} instanceId The instance ID.
/// @param {object index} objectIndex The object index.
/// @returns {bool} True if the instance is of the object type, false otherwise.
function InstanceOf(instanceId, objectIndex) {
    return instance_exists(instanceId) && instanceId.object_index == objectIndex;
}

/// @function InstanceIsInRoom(instanceId, roomIndex)
/// @description Checks if an instance is in a specific room.
/// @param {id} instanceId