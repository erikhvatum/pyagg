# The MIT License (MIT)
#
# Copyright (c) 2016 WUSTL ZPLAB
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# Authors: John Wiggins

class LineJoin(IntEnum):
    JoinMiter = _graphics_state.JoinMiter
    JoinRound = _graphics_state.JoinRound
    JoinBevel = _graphics_state.JoinBevel

class LineCap(IntEnum):
    CapButt = _graphics_state.CapButt
    CapSquare = _graphics_state.CapSquare
    CapRound = _graphics_state.CapRound

class BlendMode(IntEnum):
    BlendAlpha = _graphics_state.BlendAlpha
    BlendClear = _graphics_state.BlendClear
    BlendSrc = _graphics_state.BlendSrc
    BlendDst = _graphics_state.BlendDst
    BlendSrcOver = _graphics_state.BlendSrcOver
    BlendDstOver = _graphics_state.BlendDstOver
    BlendSrcIn = _graphics_state.BlendSrcIn
    BlendDstIn = _graphics_state.BlendDstIn
    BlendSrcOut = _graphics_state.BlendSrcOut
    BlendDstOut = _graphics_state.BlendDstOut
    BlendSrcAtop = _graphics_state.BlendSrcAtop
    BlendDstAtop = _graphics_state.BlendDstAtop
    BlendXor = _graphics_state.BlendXor
    BlendAdd = _graphics_state.BlendAdd
    BlendMultiply = _graphics_state.BlendMultiply
    BlendScreen = _graphics_state.BlendScreen
    BlendOverlay = _graphics_state.BlendOverlay
    BlendDarken = _graphics_state.BlendDarken
    BlendLighten = _graphics_state.BlendLighten
    BlendColorDodge = _graphics_state.BlendColorDodge
    BlendColorBurn = _graphics_state.BlendColorBurn
    BlendHardLight = _graphics_state.BlendHardLight
    BlendSoftLight = _graphics_state.BlendSoftLight
    BlendDifference = _graphics_state.BlendDifference
    BlendExclusion = _graphics_state.BlendExclusion


cdef class Color:
    cdef _graphics_state.Color* _this

    def __cinit__(self, uint8_t r=0, uint8_t g=0, uint8_t b=0, uint8_t a=255):
        self._this = new _graphics_state.Color(r, g, b, a)

    def __dealloc__(self):
        del self._this

    def __repr__(self):
        name = type(self).__name__
        return "{}({}, {}, {}, {})".format(name, self._this.r, self._this.g,
                                           self._this.b, self._this.a)

    property a:
        def __get__(self):
            return self._this.a
        def __set__(self, value):
            self._this.a = value

    property r:
        def __get__(self):
            return self._this.r
        def __set__(self, value):
            self._this.r = value

    property g:
        def __get__(self):
            return self._this.g
        def __set__(self, value):
            self._this.g = value

    property b:
        def __get__(self):
            return self._this.b
        def __set__(self, value):
            self._this.b = value

    property invisible:
        def __get__(self):
            cdef _graphics_state.Color* obj = self._this
            return (obj.r == 0 and obj.g == 0 and obj.b == 0 and obj.a == 0)


cdef class Rect:
    cdef _graphics_state.Rect* _this

    def __cinit__(self, double x1=0., double y1=0., double x2=0., double y2=0.):
        self._this = new _graphics_state.Rect(x1, y1, x2, y2)

    def __dealloc__(self):
        del self._this

    def __repr__(self):
        name = type(self).__name__
        return "{}({}, {}, {}, {})".format(name, self._this.x1, self._this.y1,
                                           self._this.x2, self._this.y2)

    property x1:
        def __get__(self):
            return self._this.x1
        def __set__(self, value):
            self._this.x1 = value

    property x2:
        def __get__(self):
            return self._this.x2
        def __set__(self, value):
            self._this.x2 = value

    property y1:
        def __get__(self):
            return self._this.y1
        def __set__(self, value):
            self._this.y1 = value

    property y2:
        def __get__(self):
            return self._this.y2
        def __set__(self, value):
            self._this.y2 = value

    property valid:
        def __get__(self):
            return self._this.is_valid()


cdef class GraphicsState:
    cdef _graphics_state.GraphicsState* _this

    def __cinit__(self):
        self._this = new _graphics_state.GraphicsState()

    def __dealloc__(self):
        del self._this

    property anti_aliased:
        def __get__(self):
            return self._this.antiAliased()
        def __set__(self, aa):
            self._this.antiAliased(aa)

    property clip_box:
        def __get__(self):
            cdef _graphics_state.Rect ret = self._this.clipBox()
            return Rect(ret.x1, ret.y1, ret.x2, ret.y2)
        def __set__(self, Rect box):
            self._this.clipBox(box._this[0])

    property blend_mode:
        def __get__(self):
            return BlendMode(self._this.blendMode())
        def __set__(self, m):
            m = BlendMode(m)
            self._this.blendMode(m)

    property image_blend_mode:
        def __get__(self):
            return BlendMode(self._this.imageBlendMode())
        def __set__(self, m):
            m = BlendMode(m)
            self._this.imageBlendMode(m)

    property image_blend_color:
        def __get__(self):
            cdef _graphics_state.Color ret = self._this.imageBlendColor()
            return Color(ret.r, ret.g, ret.b, ret.a)
        def __set__(self, Color col):
            self._this.imageBlendColor(col._this[0])

    property master_alpha:
        def __get__(self):
            return self._this.masterAlpha()
        def __set__(self, a):
            self._this.masterAlpha(a)

    property anti_alias_gamma:
        def __get__(self):
            return self._this.antiAliasGamma()
        def __set__(self, g):
            self._this.antiAliasGamma(g)

    property fill_color:
        def __get__(self):
            cdef _graphics_state.Color ret = self._this.fillColor()
            return Color(ret.r, ret.g, ret.b, ret.a)
        def __set__(self, Color col):
            self._this.fillColor(col._this[0])

    property line_color:
        def __get__(self):
            cdef _graphics_state.Color ret = self._this.lineColor()
            return Color(ret.r, ret.g, ret.b, ret.a)
        def __set__(self, Color col):
            self._this.lineColor(col._this[0])

    def no_fill(self):
        """no_fill(self)"""
        self._this.noFill()

    def no_line(self):
        """no_line(self)"""
        self._this.noLine()

    property line_width:
        def __get__(self):
            return self._this.lineWidth()
        def __set__(self, w):
            self._this.lineWidth(w)

    property line_cap:
        def __get__(self):
            return LineCap(self._this.lineCap())
        def __set__(self, cap):
            cap = LineCap(cap)
            self._this.lineCap(cap)

    property line_join:
        def __get__(self):
            return LineJoin(self._this.lineJoin())
        def __set__(self, join):
            join = LineJoin(join)
            self._this.lineJoin(join)

    property fill_even_odd:
        def __get__(self):
            return self._this.fillEvenOdd()
        def __set__(self, even_odd_flag):
            self._this.fillEvenOdd(even_odd_flag)
