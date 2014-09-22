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

#import "moui/ui/mac/MOOpenGLView.h"

#include <memory>
#include <OpenGL/gl.h>

#include "moui/ui/view.h"


@interface MOOpenGLView (PrivateDelegateHandling)

- (NSPoint)convertToInternalPoint:(NSPoint)parentViewPoint;
- (void)handleEvent:(NSEvent *)event withType:(moui::Event::Type)type;
- (NSOpenGLContext *)openGLContext;

@end

@implementation MOOpenGLView (PrivateDelegateHandling)

- (NSPoint)convertToInternalPoint:(NSPoint)parentViewPoint {
  NSPoint point;
  point.x = parentViewPoint.x - self.frame.origin.x,
  point.y = self.frame.size.height - (parentViewPoint.y - self.frame.origin.y);
  return point;
}

- (void)handleEvent:(NSEvent *)event withType:(moui::Event::Type)type {
  auto mouiEvent = new moui::Event(type);
  // Adds the event location.
  NSPoint locationInWindow = [event locationInWindow];
  NSPoint locationInView = [self convertPoint:locationInWindow fromView:self];
  NSPoint location = [self convertToInternalPoint:locationInView];
  mouiEvent->locations()->push_back({static_cast<float>(location.x),
                                     static_cast<float>(location.y)});
  _mouiView->HandleEvent(std::unique_ptr<moui::Event>(mouiEvent));
}

- (NSOpenGLContext *)openGLContext {
  if (_openGLContext != nil)
    return _openGLContext;

  _openGLContext = [[NSOpenGLContext alloc] initWithFormat:_pixelFormat
                                              shareContext:nil];
  [_openGLContext setView:self];

  // Sets synch to VBL to eliminate tearing
  GLint vblSync = 1;
  [_openGLContext setValues:&vblSync forParameter:NSOpenGLCPSwapInterval];
  // Allows for transparent background.
  GLint opaque = 0;
  [_openGLContext setValues:&opaque forParameter:NSOpenGLCPSurfaceOpacity];
}

@end

@implementation MOOpenGLView

- (id)initWithMouiView:(moui::View *)mouiView {
  if((self = [super initWithFrame:NSMakeRect(0, 0, 0, 0)])) {
    _mouiView = mouiView;

    const NSOpenGLPixelFormatAttribute attributes[] =  {
        NSOpenGLPFAAccelerated,
        NSOpenGLPFAAlphaSize, 8,
        NSOpenGLPFAColorSize, 32,
        NSOpenGLPFADepthSize, 24,
        NSOpenGLPFADoubleBuffer,
        NSOpenGLPFANoRecovery,
        NSOpenGLPFAStencilSize, 8,
        NSOpenGLPFAWindow,
        (NSOpenGLPixelFormatAttribute)nil};
    _pixelFormat = [[NSOpenGLPixelFormat alloc] initWithAttributes:attributes];
  }
  return self;
}

- (void)dealloc {
  [_pixelFormat dealloc];
  if (_openGLContext != nil)
    [_openGLContext dealloc];
  [super dealloc];
}

- (void)drawRect:(NSRect)rect {
  [self render];
}

- (NSView *)hitTest:(NSPoint)parentViewPoint {
  NSPoint point = [self convertToInternalPoint:parentViewPoint];
  if (_mouiView->ShouldHandleEvent({static_cast<float>(point.x),
                                    static_cast<float>(point.y)}))
    return self;
  return nil;  // passes to the next responder
}

- (void)lockFocus {
  [super lockFocus];
  [[self openGLContext] makeCurrentContext];
}

- (void)mouseDown:(NSEvent *)event {
  [self handleEvent:event withType:moui::Event::Type::kDown];
}

- (void)mouseDragged:(NSEvent *)event {
  [self handleEvent:event withType:moui::Event::Type::kMove];
}

- (void)mouseUp:(NSEvent *)event {
  [self handleEvent:event withType:moui::Event::Type::kUp];
}

- (void)render {
  if (self.frame.size.width == 0 || self.frame.size.height == 0 ||
      [self isHidden])
    return;

  NSOpenGLContext* context = [self openGLContext];
  [context makeCurrentContext];
  _mouiView->Render();
  [context flushBuffer];
}

@end
