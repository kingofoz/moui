# Copyright 2016 Ollix
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
{
  'includes': [
    'common.gypi',
  ],
  'targets': [
    {
      'target_name': 'libbgfx',
      'type': 'static_library',
      'sources': [
        'deps/bgfx/src/amalgamated.cpp',
        'deps/bgfx/src/amalgamated.mm',
      ],
      'include_dirs': [
        'deps/bx/include',
        'deps/bgfx/3rdparty',
        'deps/bgfx/include',
      ],

      'conditions': [
        ['OS == "mac" or OS == "ios"', {
          'sources!': [ 'deps/bgfx/src/amalgamated.cpp' ],
          'xcode_settings': {
            'STRIP_INSTALLED_PRODUCT': 'NO',
          },
        }, {
          'sources!': [ 'deps/bgfx/src/amalgamated.mm' ],
        }],
        ['OS == "android"', {
        }],
        ['OS == "ios"', {
          'include_dirs': [ 'deps/bx/include/compat/ios' ],
        }],
        ['OS == "mac"', {
          'include_dirs': [ 'deps/bx/include/compat/mac' ],
        }],
        ['OS == "win"', {
          'include_dirs': [ 'deps/bx/include/compat/msvc' ],
        }],
      ],  # conditions
      'direct_dependent_settings': {
        'include_dirs': [
          '..',
          'deps',
          'deps/bx/include',
          'deps/bgfx/3rdparty',
          'deps/bgfx/include',
        ],
        'conditions': [
          ['OS == "android"', {
          }],
          ['OS == "ios"', {
            'include_dirs': [ 'deps/bx/include/compat/ios' ],
          }],
          ['OS == "mac"', {
            'include_dirs': [ 'deps/bx/include/compat/mac' ],
          }],
          ['OS == "win"', {
            'include_dirs': [ 'deps/bx/include/compat/msvc' ],
          }],
        ],  # conditions
      },  # direct_dependent_settings
    },
  ],
}
