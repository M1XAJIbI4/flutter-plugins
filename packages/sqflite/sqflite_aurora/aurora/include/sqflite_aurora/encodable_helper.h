/*
 * SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
 * SPDX-License-Identifier: BSD-3-Clause
 */
#ifndef FLUTTER_PLUGIN_ENCODABLE_HELPER_H
#define FLUTTER_PLUGIN_ENCODABLE_HELPER_H

#include <flutter/method_channel.h>
#include <flutter/encodable_value.h>

#include <list>
#include <memory>
#include <string>

typedef flutter::EncodableValue EncodableValue;
typedef flutter::EncodableMap EncodableMap;
typedef flutter::EncodableList EncodableList;

// Database transaction type
namespace DatabaseTransaction {
  enum ID {
      None = -2,
      Force = -1,
  };
}

namespace Val {

typedef flutter::MethodCall<EncodableValue> MethodCall;

// ========== encodable_value ==========

template <typename T>
inline bool TypeIs(const EncodableValue val) {
  return std::holds_alternative<T>(val);
}

template <typename T>
inline const T GetValue(EncodableValue val) {
  return std::get<T>(val);
}

template <typename T>
inline std::vector<T> GetVector(const EncodableValue& val) {
  if (TypeIs<std::vector<T>>(val))
    return GetValue<std::vector<T>>(val);
  return std::vector<T>();
}

inline EncodableMap GetMap(const EncodableMap& map, const std::string& key) {
  auto it = map.find(EncodableValue(key));
  if (it != map.end() && TypeIs<EncodableMap>(it->second))
    return GetValue<EncodableMap>(it->second);
  return EncodableMap();
}

inline EncodableList GetList(const EncodableMap& map, const std::string& key) {
  auto it = map.find(EncodableValue(key));
  if (it != map.end() && TypeIs<EncodableList>(it->second))
    return GetValue<EncodableList>(it->second);
  return EncodableList();
}

inline int GetInt(const EncodableMap& map, const std::string& key) {
  auto it = map.find(EncodableValue(key));
  if (it != map.end() && TypeIs<int>(it->second))
    return GetValue<int>(it->second);
  return -1;
}

inline bool GetBool(const EncodableMap& map, const std::string& key) {
  auto it = map.find(EncodableValue(key));
  if (it != map.end() && TypeIs<bool>(it->second))
    return GetValue<bool>(it->second);
  return false;
}

inline std::string GetString(const EncodableMap& map, const std::string& key) {
  auto it = map.find(EncodableValue(key));
  if (it != map.end() && TypeIs<std::string>(it->second))
    return GetValue<std::string>(it->second);
  return std::string();
}

inline EncodableMap FindMap(const MethodCall& method_call, const std::string& key) {
  if (TypeIs<EncodableMap>(*method_call.arguments())) {
    return GetMap(GetValue<EncodableMap>(*method_call.arguments()), key);
  }
  return EncodableMap();
}

inline EncodableList FindList(const MethodCall& method_call, const std::string& key) {
  if (TypeIs<EncodableMap>(*method_call.arguments())) {
    return GetList(GetValue<EncodableMap>(*method_call.arguments()), key);
  }
  return EncodableList();
}

inline int FindInt(const MethodCall& method_call, const std::string& key) {
  if (TypeIs<EncodableMap>(*method_call.arguments())) {
    return GetInt(GetValue<EncodableMap>(*method_call.arguments()), key);
  }
  return -1;
}

inline bool FindBool(const MethodCall& method_call, const std::string& key) {
  if (TypeIs<EncodableMap>(*method_call.arguments())) {
    return GetBool(GetValue<EncodableMap>(*method_call.arguments()), key);
  }
  return false;
}

inline std::string FindString(const MethodCall& method_call, const std::string& key) {
  if (TypeIs<EncodableMap>(*method_call.arguments())) {
    return GetString(GetValue<EncodableMap>(*method_call.arguments()), key);
  }
  return std::string();
}

inline int64_t FindTransaction(const MethodCall& method_call, const std::string& key) {
  if (TypeIs<EncodableMap>(*method_call.arguments())) {
    return GetInt(GetValue<EncodableMap>(*method_call.arguments()), key);
  }
  return static_cast<int64_t>(DatabaseTransaction::ID::None);
}

} // namespace Val

#endif /* FLUTTER_PLUGIN_ENCODABLE_HELPER_H */
