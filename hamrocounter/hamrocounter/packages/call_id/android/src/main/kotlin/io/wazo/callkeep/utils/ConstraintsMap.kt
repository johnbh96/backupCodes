package io.package.call_id

import java.util.ArrayList

class ConstraintsMap {
    private val mMap: Map<String, Object?>

    constructor() {
        mMap = HashMap<String, Object>()
    }

    constructor(map: Map<String, Object?>) {
        mMap = map
    }

    fun toMap(): Map<String, Object?> {
        return mMap
    }

    fun hasKey(name: String): Boolean {
        return mMap.containsKey(name)
    }

    fun isNull(name: String): Boolean {
        return mMap[name] == null
    }

    fun getBoolean(name: String): Boolean {
        return mMap[name]
    }

    fun getDouble(name: String): Double {
        return mMap[name]
    }

    fun getInt(name: String): Int {
        return if (getType(name) === ObjectType.String) {
            Integer.parseInt(mMap[name] as String?)
        } else mMap[name]
    }

    fun getString(name: String): String? {
        return mMap[name]
    }

    fun getMap(name: String): ConstraintsMap? {
        val value: Object = mMap[name] ?: return null
        return ConstraintsMap(value as Map<String, Object?>)
    }

    fun getType(name: String): ObjectType {
        val value: Object? = mMap[name]
        return if (value == null) {
            ObjectType.Null
        } else if (value is Number) {
            ObjectType.Number
        } else if (value is String) {
            ObjectType.String
        } else if (value is Boolean) {
            ObjectType.Boolean
        } else if (value is Map) {
            ObjectType.Map
        } else if (value is ArrayList) {
            ObjectType.Array
        } else if (value is Byte) {
            ObjectType.Byte
        } else {
            throw IllegalArgumentException(
                "Invalid value " + value.toString().toString() + " for key " + name +
                        "contained in ConstraintsMap"
            )
        }
    }

    fun putBoolean(key: String?, value: Boolean) {
        mMap.put(key, value)
    }

    fun putDouble(key: String?, value: Double) {
        mMap.put(key, value)
    }

    fun putInt(key: String?, value: Int) {
        mMap.put(key, value)
    }

    fun putString(key: String?, value: String?) {
        mMap.put(key, value)
    }

    fun putByte(key: String?, value: ByteArray?) {
        mMap.put(key, value)
    }

    fun putNull(key: String?) {
        mMap.put(key, null)
    }

    fun putMap(key: String?, value: Map<String?, Object?>?) {
        mMap.put(key, value)
    }

    fun merge(value: Map<String?, Object?>?) {
        mMap.putAll(value)
    }

    fun putArray(key: String?, value: ArrayList<Object?>?) {
        mMap.put(key, value)
    }

    fun getArray(name: String): ConstraintsArray? {
        val value: Object = mMap[name] ?: return null
        return ConstraintsArray(value as ArrayList<Object?>)
    }

    fun getListArray(name: String): ArrayList<Object>? {
        return mMap[name] as ArrayList<Object>?
    }
}