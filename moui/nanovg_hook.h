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

#ifndef MOUI_NANOVG_HOOK_H_
#define MOUI_NANOVG_HOOK_H_

#include "moui/defines.h"
#include "moui/opengl_hook.h"

#include "nanovg/src/nanovg.h"

#ifdef MOUI_BGFX
#  include "bx/bx.h"
#  include "bgfx/bgfx.h"
#  include "bgfx/examples/common/nanovg/nanovg_bgfx.h"
#else
#  include "nanovg/src/nanovg_gl.h"
#  include "nanovg/src/nanovg_gl_utils.h"
#endif

#if defined MOUI_BGFX
#  define nvgCreateContext(flags) nvgCreate(1, 0, NULL)
#  define nvgDeleteContext(context) nvgDelete(context)
#elif defined MOUI_GL2
#  define NANOVG_GL2 1
#  define nvgCreateContext(flags) nvgCreateGL2(flags)
#  define nvgDeleteContext(context) nvgDeleteGL2(context)
#elif defined MOUI_GLES2
#  define NANOVG_GLES2 1
#  define nvgCreateContext(flags) nvgCreateGLES2(flags)
#  define nvgDeleteContext(context) nvgDeleteGLES2(context)
#elif defined MOUI_GL3
#  define NANOVG_GL3 1
#  define nvgCreateContext(flags) nvgCreateGL3(flags)
#  define nvgDeleteContext(context) nvgDeleteGL3(context)
#elif defined MOUI_GLES3
#  define NANOVG_GLES3 1
#  define nvgCreateContext(flags) nvgCreateGLES3(flags)
#  define nvgDeleteContext(context) nvgDeleteGLES3(context)
#endif

// Additonal APIs for nanovg.
namespace moui {

// Returns `true` if passed colors are the same.
bool nvgCompareColor(const NVGcolor& color1, const NVGcolor& color2);

// Returns the image identifier of the current snapshot of the passed context
// or -1 on failure. The returned image needs to be freed manually through
// `nvgDeleteImage()`.
int nvgCreateImageSnapshot(NVGcontext* context, const int x, const int y,
                           const int width, const int height,
                           const float scale_factor);

// Deletes the passed framebuffer and resets the pointer.
void nvgDeleteFramebuffer(NVGLUframebuffer** framebuffer);

// Deletes the passed image and set the image id to -1.
void nvgDeleteImage(NVGcontext* context, int* image);

// Draws drop shadow.
void nvgDrawDropShadow(NVGcontext* context, const float x, const float y,
                       const float width, const float height,
                       const float radius, float feather,
                       const NVGcolor inner_color,
                       const NVGcolor outer_color);

// Updates the specified `image` data to unpremultiply its alpha values.
void nvgUnpremultiplyImageAlpha(unsigned char* image, const int width,
                                const int height);

}  // namespace moui

#endif  // MOUI_NANOVG_HOOK_H_
