//
//  LuaMacrosBridge.swift
//  Lua
//
//  Created by Antoine Bollengier on 08.09.2023.
//  Copyright © 2023 Antoine Bollengier. All rights reserved.
//

import Foundation

public var BLUA_REGISTRYINDEX = (-LUAI_MAXSTACK - 1000)

public func blua_upvalueindex(i: Int32) -> Int32 {
    return (BLUA_REGISTRYINDEX - (i));
}

public func blua_call(L: UnsafeMutablePointer<lua_State>, n: Int32, r: Int32) {
    return lua_callk(L, (n), (r), 0, nil);
}

public func blua_pcall(L: UnsafeMutablePointer<lua_State>, n: Int32, r: Int32, f: Int32) -> Int32 {
    return lua_pcallk(L, (n), (r), (f), 0, nil);
}

public func blua_yield(L: UnsafeMutablePointer<lua_State>, n: Int32) -> Int32 {
    return lua_yieldk(L, (n), 0, nil);
}


//public func blua_getextraspace(L: UnsafeMutablePointer<lua_State>) -> UnsafeMutableRawPointer {
//    return ((L as UnsafeMutablePointer<CChar>
//) - LUA_EXTRASPACE) as UnsafeMutableRawPointer;
//}

public func blua_tonumber(L: UnsafeMutablePointer<lua_State>, i: Int32) -> lua_Number {
    return lua_tonumberx(L,(i),nil);
}

public func blua_tointeger(L: UnsafeMutablePointer<lua_State>, i: Int32) -> lua_Integer {
    return lua_tointegerx(L,(i),nil);
}

public func blua_pop(L: UnsafeMutablePointer<lua_State>, n: Int32) {
    return lua_settop(L, -(n)-1);
}

public func blua_newtable(L: UnsafeMutablePointer<lua_State>) {
    return lua_createtable(L, 0, 0);
}

public func blua_pushcfunction(L: UnsafeMutablePointer<lua_State>, f: lua_CFunction) {
    return lua_pushcclosure(L, (f), 0);
}

public func blua_register(L: UnsafeMutablePointer<lua_State>, n: UnsafeMutablePointer<Character>, f: lua_CFunction) {
    blua_pushcfunction(L: L, f: f)
    lua_setglobal(L, n)
    return
}


public func blua_isfunction(L: UnsafeMutablePointer<lua_State>, n: Int32) -> Bool {
    return (lua_type(L, (n)) == LUA_TFUNCTION);
}

public func blua_istable(L: UnsafeMutablePointer<lua_State>, n: Int32) -> Bool {
    return (lua_type(L, (n)) == LUA_TTABLE);
}

public func blua_islightuserdata(L: UnsafeMutablePointer<lua_State>, n: Int32) -> Bool {
    return (lua_type(L, (n)) == LUA_TLIGHTUSERDATA);
}

public func blua_isnil(L: UnsafeMutablePointer<lua_State>, n: Int32) -> Bool {
    return (lua_type(L, (n)) == LUA_TNIL);
}

public func blua_isboolean(L: UnsafeMutablePointer<lua_State>, n: Int32) -> Bool {
    return (lua_type(L, (n)) == LUA_TBOOLEAN);
}

public func blua_isthread(L: UnsafeMutablePointer<lua_State>, n: Int32) -> Bool {
    return (lua_type(L, (n)) == LUA_TTHREAD);
}

public func blua_isnone(L: UnsafeMutablePointer<lua_State>, n: Int32) -> Bool {
    return (lua_type(L, (n)) == LUA_TNONE);
}

public func blua_isnoneornil(L: UnsafeMutablePointer<lua_State>, n: Int32) -> Bool {
    return (lua_type(L, (n)) <= 0);
}

public func blua_pushliteral(L: UnsafeMutablePointer<lua_State>, s: UnsafePointer<Character>) -> UnsafePointer<CChar> {
    return lua_pushstring(L, s);
}

public func blua_pushglobaltable(L: UnsafeMutablePointer<lua_State>) {
    lua_rawgeti(L, BLUA_REGISTRYINDEX, lua_Integer(LUA_RIDX_GLOBALS))
    return
}

public func blua_tostring(L: UnsafeMutablePointer<lua_State>, i: Int32) -> UnsafePointer<CChar> {
    return lua_tolstring(L, (i), nil)
}

public func blua_insert(L: UnsafeMutablePointer<lua_State>, idx: Int32) {
    return lua_rotate(L, (idx), 1);
}

public func blua_remove(L: UnsafeMutablePointer<lua_State>, idx: Int32) {
    lua_rotate(L, (idx), -1)
    blua_pop(L: L, n: 1)
    return
}

public func blua_replace(L: UnsafeMutablePointer<lua_State>, idx: Int32) {
    lua_copy(L, -1, (idx))
    blua_pop(L: L, n: 1)
    return
}

public func blua_newuserdata(L: UnsafeMutablePointer<lua_State>, s: size_t) -> UnsafeMutableRawPointer {
    return lua_newuserdatauv(L,s,1);
}

public func blua_getuservalue(L: UnsafeMutablePointer<lua_State>, idx: Int32) -> Int32 {
    return lua_getiuservalue(L,idx,1);
}

public func blua_setuservalue(L: UnsafeMutablePointer<lua_State>, idx: Int32) -> Int32 {
    return lua_setiuservalue(L,idx,1);
}
