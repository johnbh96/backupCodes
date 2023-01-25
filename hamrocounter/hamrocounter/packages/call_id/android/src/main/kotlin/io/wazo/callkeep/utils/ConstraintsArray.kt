package io.package.call_id

import java.util.ArrayList

class ConstraintsArray {
    private val mArray: ArrayList<Object>

    constructor() {
        mArray = ArrayList()
    }

    constructor(array: ArrayList<Object?>) {
        mArray = array
    }

    fun size(): Int {
        return mArray.size()
    }

    fun isNull(index: Int): Boolean {
        return mArray.get(index) == null
    }

    fun getBoolean(index: Int): Boolean {
        return mArray.get(index)
    }

    fun getDouble(index: Int): Double {
        return mArray.get(index)
    }

    fun getInt(index: Int): Int {
        return mArray.get(index)
    }

    fun getString(index: Int): String {
        return mArray.get(index)
    }

    fun getByte(index: Int): Array<Byte> {
        return mArray.get(index)
    }

    fun getArray(index: Int): ConstraintsArray {
        return ConstraintsArray(mArray.get(index) as ArrayList<Object?>)
    }

    fun getMap(index: Int): ConstraintsMap {
        return ConstraintsMap(mArray.get(index) as Map<String, Object?>)
    }

    fun getType(index: Int): ObjectType {
        val `object`: Object = mArray.get(index)
        if (`object` == null) {
            return ObjectType.Null
        } else if (`object` is Boolean) {
            return ObjectType.Boolean
        } else if (`object` is Double ||
            `object` is Float ||
            `object` is Integer
        ) {
            return ObjectType.Number
        } else if (`object` is String) {
            return ObjectType.String
        } else if (`object` is ArrayList) {
            return ObjectType.Array
        } else if (`object` is Map) {
            return ObjectType.Map
        } else if (`object` is Byte) {
            return ObjectType.Byte
        }
        return ObjectType.Null
    }

    fun toArrayList(): ArrayList<Object> {
        return mArray
    }

    fun pushNull() {
        mArray.add(null)
    }

    fun pushBoolean(value: Boolean) {
        mArray.add(value)
    }

    fun pushDouble(value: Double) {
        mArray.add(value)
    }

    fun pushInt(value: Int) {
        mArray.add(value)
    }

    fun pushString(value: String?) {
        mArray.add(value)
    }

    fun pushArray(array: ConstraintsArray) {
        mArray.add(array.toArrayList())
    }

    fun pushByte(value: ByteArray?) {
        mArray.add(value)
    }

    fun pushMap(map: ConstraintsMap) {
        mArray.add(map.toMap())
    }
}