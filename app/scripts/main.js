
/**
HeatMap JavaScript

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
 */

(function() {
  'use strict';
  var _average, _colorScheme, _componentToHex, _max, _min, _mode, _rgbtoHex, _sort;

  _componentToHex = function(color) {
    var hex;
    hex = color.toString(16);
    if (hex.length === 1) {
      return '0' + hex;
    } else {
      return hex;
    }
  };

  _rgbtoHex = function(r, g, b) {
    return '#' + _componentToHex(r) + _componentToHex(g) + _componentToHex(b);
  };

  _max = function(array) {
    return Math.max.apply(Math, array);
  };

  _min = function(array) {
    return Math.min.apply(Math, array);
  };

  _average = function(array) {
    var average, i, summation;
    summation = 0;
    i = 0;
    while (i < array.length) {
      summation += parseFloat(array[i]);
      i++;
    }
    average = summation / array.length;
    return Math.round(average);
  };

  _sort = function(array) {
    return array.sort();
  };

  _mode = function(array) {
    var counter, max, mode;
    counter = {};
    mode = [];
    max = 0;
    array = array.sort();
    return array[Math.round(array.length / 2)];
  };

  _colorScheme = function(scheme) {
    var firstColor, secondColor, thirdColor;
    firstColor = void 0;
    secondColor = void 0;
    thirdColor = void 0;
    firstColor = [];
    secondColor = [];
    thirdColor = [];
    switch (scheme) {
      case 'GYR':
        firstColor = [243, 81, 88];
        secondColor = [254, 233, 144];
        thirdColor = [84, 180, 104];
        break;
      case 'RYG':
        firstColor = [84, 180, 104];
        secondColor = [254, 233, 144];
        thirdColor = [243, 81, 88];
        break;
      default:
        firstColor = [243, 81, 88];
        secondColor = [254, 233, 144];
        thirdColor = [84, 180, 104];
    }
    return {
      firstColor: firstColor,
      secondColor: secondColor,
      thirdColor: thirdColor
    };
  };

  this.heatmap = function(tablename, classname, scheme) {
    var ab, ag, ar, ave, getColorScheme, max, min, mod, n, piaArray, xb, xg, xr, yb, yg, yr;
    piaArray = $('table#' + tablename + ' tbody td.' + classname).map(function() {
      return parseFloat($(this).text());
    }).get();
    max = _max(piaArray);
    ave = _average(piaArray);
    min = _min(piaArray);
    mod = _mode(piaArray);
    getColorScheme = _colorScheme(scheme);
    xr = getColorScheme.firstColor[0];
    xg = getColorScheme.firstColor[1];
    xb = getColorScheme.firstColor[2];
    ar = getColorScheme.secondColor[0];
    ag = getColorScheme.secondColor[1];
    ab = getColorScheme.secondColor[2];
    yr = getColorScheme.thirdColor[0];
    yg = getColorScheme.thirdColor[1];
    yb = getColorScheme.thirdColor[2];
    n = 100;
    return $('table#' + tablename + ' tbody td.' + classname).each(function() {
      var blue, clr, green, pos, red, value;
      value = parseFloat($(this).text());
      if (value < mod) {
        pos = parseInt((Math.round(((value - min) / (mod - min)) * 100)).toFixed(0));
        red = parseInt((xr + ((pos * (ar - xr)) / (n - 1))).toFixed(0));
        green = parseInt((xg + ((pos * (ag - xg)) / (n - 1))).toFixed(0));
        blue = parseInt((xb + ((pos * (ab - xb)) / (n - 1))).toFixed(0));
        clr = _rgbtoHex(red, green, blue);
        $(this).css({
          backgroundColor: clr
        });
      }
      if (value === mod) {
        red = ar;
        green = ag;
        blue = ab;
        clr = _rgbtoHex(red, green, blue);
        $(this).css({
          backgroundColor: clr
        });
      }
      if (value > mod) {
        pos = parseInt((Math.round(((value - mod) / (max - mod)) * 100)).toFixed(0));
        red = parseInt((ar + ((pos * (yr - ar)) / (n - 1))).toFixed(0));
        green = parseInt((ag + ((pos * (yg - ag)) / (n - 1))).toFixed(0));
        blue = parseInt((ab + ((pos * (yb - ab)) / (n - 1))).toFixed(0));
        clr = _rgbtoHex(red, green, blue);
        return $(this).css({
          backgroundColor: clr
        });
      }
    });
  };

  return;

}).call(this);
