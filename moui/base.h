// Copyright (c) 2014 Ollix. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// ---
// Author: olliwang@ollix.com (Olli Wang)

#ifndef MOUI_BASE_H_
#define MOUI_BASE_H_

namespace moui {

// Indicates inset distances for rectangles.
struct EdgeInsets {
  float top;
  float left;
  float bottom;
  float right;
};

// Indicates a specific location.
struct Point {
  float x;
  float y;
};

// Indicates a specific size.
struct Size {
  float width;
  float height;
};

// A macro to disallow the copy constructor and `operator=` functions.
// This should be used in the private section of a class interface.
#define DISALLOW_COPY_AND_ASSIGN(TypeName) \
  TypeName(const TypeName&);               \
  void operator=(const TypeName&)

}  // namespace moui

#endif  // MOUI_BASE_H_
