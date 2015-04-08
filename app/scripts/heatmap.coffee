###*
HeatMap CoffeeScript

The MIT License (MIT)

Copyright (c) 2015 Muyiwa Olurin (Anthony)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the 'Software'), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

Ref [1]
http://stackoverflow.com/questions/5623838/rgb-to-hex-and-hex-to-rgb

###

'use strict';
_componentToHex = (color) ->
  hex = color.toString(16)
  (if hex.length is 1 then '0' + hex else hex)


_rgbtoHex = (r, g, b) ->
  '#' + _componentToHex(r) + _componentToHex(g) + _componentToHex(b)

#Get Maximum and Minimum value out of an array
#http://ejohn.org/blog/fast-javascript-maxmin/

_max = (array) ->
  Math.max.apply Math, array

_min = (array) ->
  Math.min.apply Math, array

_average = (array) ->
  summation = 0
  i = 0
  while i < array.length
    summation += parseFloat(array[i]) # base 10
    i++
  average = summation / array.length
  Math.round average

_sort = (array) ->
  array.sort()

_mode = (array) ->
  counter = {}
  mode = []
  max = 0
  array = array.sort()
  array[Math.round(array.length / 2)]

#Color Scheme Function
# This function should select the right color scheme from the dropdown widget.
_colorScheme = (scheme) ->
  firstColor = undefined
  secondColor = undefined
  thirdColor = undefined
  firstColor = []
  secondColor = []
  thirdColor = []
  switch scheme
    when 'GYR'
      firstColor = [ 243, 81, 88 ]
      secondColor = [ 254, 233, 144 ]
      thirdColor = [ 84, 180, 104 ]
    when 'RYG'
      firstColor = [ 84, 180, 104 ]
      secondColor = [ 254, 233, 144 ]
      thirdColor = [ 243, 81, 88 ]
    when 'GWR'
      firstColor = [ 243, 81, 88 ]
      secondColor = [ 256, 256, 256 ]
      thirdColor = [ 84, 180, 104 ]
    else
      firstColor = [ 243, 81, 88 ]
      secondColor = [ 254, 233, 144 ]
      thirdColor = [ 84, 180, 104 ]
  firstColor: firstColor
  secondColor: secondColor
  thirdColor: thirdColor

@ColorScale = (tablename, classname) -> 
  
  scheme = ''
  changeSelect = $('select#color-scale-select')
  
  changeSelect.change () ->
    scheme = $('#color-scale-select option:selected').val()
    _heatmap(tablename, classname, scheme)
    return true

  ## Call HEATMAP
  _heatmap(tablename, classname, scheme)
    

_heatmap = (tablename, classname, scheme) ->
  console.log 'HeatMap Started ... '

  piaArray = $('table#'+tablename+' tbody td.' + classname).map(->
    parseFloat $(this).text()
  ).get()

  max = _max(piaArray)
  ave = _average(piaArray)
  min = _min(piaArray)
  mod = _mode(piaArray)

  getColorScheme = _colorScheme(scheme)

## X-'s'
  xr = getColorScheme.firstColor[0]
  xg = getColorScheme.firstColor[1]
  xb = getColorScheme.firstColor[2]

## A-'s'
  ar = getColorScheme.secondColor[0]
  ag = getColorScheme.secondColor[1]
  ab = getColorScheme.secondColor[2]

## Y-'s'
  yr = getColorScheme.thirdColor[0]
  yg = getColorScheme.thirdColor[1]
  yb = getColorScheme.thirdColor[2]

  n = 100

  $('table#'+tablename+' tbody td.' + classname).each ->
    value = parseFloat($(this).text())
    if value < mod
      pos = parseInt((Math.round(((value - min) / (mod - min)) * 100)).toFixed(0))
      red = parseInt((xr + ((pos * (ar - xr)) / (n - 1))).toFixed(0))
      green = parseInt((xg + ((pos * (ag - xg)) / (n - 1))).toFixed(0))
      blue = parseInt((xb + ((pos * (ab - xb)) / (n - 1))).toFixed(0))
      clr = _rgbtoHex(red, green, blue)
      $(this).css backgroundColor: clr
    if value is mod
      red = ar
      green = ag
      blue = ab
      clr = _rgbtoHex(red, green, blue)
      $(this).css backgroundColor: clr
    if value > mod
      pos = parseInt((Math.round(((value - mod) / (max - mod)) * 100)).toFixed(0))
      red = parseInt((ar + ((pos * (yr - ar)) / (n - 1))).toFixed(0))
      green = parseInt((ag + ((pos * (yg - ag)) / (n - 1))).toFixed(0))
      blue = parseInt((ab + ((pos * (yb - ab)) / (n - 1))).toFixed(0))
      clr = _rgbtoHex(red, green, blue)
      $(this).css backgroundColor: clr
return
