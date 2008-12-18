/**
 * ColorRange demo showing the following:
 * - different sort modes for ColorLists
 * - creating different shades (sets of shades) by applying ColorRanges
 * 
 * Press any key to re-generate a random variation
 *
 * @author Karsten Schmidt <info at postspectacular dot com>
 */

import java.util.Iterator;

import toxi.color.*;
import toxi.color.theory.*;
import toxi.math.*;
import toxi.util.datatypes.*;

float   SWATCH_HEIGHT = 24;
float   SWATCH_WIDTH = 5;
int     SWATCH_GAP = 1;

float   MAX_SIZE = 150;
int     NUM_DISCS = 300;

boolean showDiscs=true;

void setup() {
  size(1024, 768);
  noLoop();
  textFont(createFont("arial", 9));

}

void draw() {
  background(0);
  ColorList list = new ColorList();
  for (int i = 0; i < 100; i++) {
    list.add(TColor.newRandom());
  }
  int yoff = 10;
  swatches(list, 10, yoff);
  yoff += SWATCH_HEIGHT + 10;
  ColorList sorted = null;
  sorted = list.clusterSort(AccessCriteria.HUE,
  AccessCriteria.BRIGHTNESS, 12, true);
  sorted = list.sortByComparator(new ProximityComparator(
  NamedColor.BLUE, new RGBDistanceProxy()), false);
  swatches(sorted, 10, yoff);
  yoff += SWATCH_HEIGHT + 10;
  sorted = list.sortByDistance(false);
  swatches(sorted, 10, yoff);
  yoff += SWATCH_HEIGHT + 10;
  sorted = list.sortByDistance(new RGBDistanceProxy(), false);
  swatches(sorted, 10, yoff);
  yoff += SWATCH_HEIGHT + 10;
  sorted = list.sortByDistance(new CMYKDistanceProxy(), false);
  swatches(sorted, 10, yoff);
  yoff += SWATCH_HEIGHT + 10;

  TColor col = TColor.newHSV(random(1), random(0.75, 1), random(1));
  int idx = 0;
  yoff = 10;
  ArrayList strategies=ColorTheoryRegistry.getRegisteredStrategies();
  for (Iterator i = strategies.iterator(); i.hasNext();) {
    ColorTheoryStrategy s = (ColorTheoryStrategy) i.next();
    System.out.println(s);
    sorted = ColorList.createUsingStrategy(s, col);
    sorted = sorted.sortByDistance(false);
    swatches(sorted, 900, yoff);
    yoff += SWATCH_HEIGHT + 10;
    idx++;
  }
  yoff = 260;
  col = TColor.newRandom();
  Collection ranges=ColorRange.PRESETS.values();
  for (Iterator i = ranges.iterator(); i.hasNext();) {
    ColorRange range = (ColorRange) i.next();
    sorted = range.getColors(col, 100, 0.1f);
    sorted = sorted.sortByCriteria(AccessCriteria.BRIGHTNESS, false);
    swatches(sorted, 10, yoff);
    fill(255);
    text(range.getName(), 15 + 100 * (SWATCH_WIDTH + SWATCH_GAP), yoff + SWATCH_HEIGHT);
    yoff += SWATCH_HEIGHT + 10;
  }
  ColorRange range = ColorRange.FRESH.getSum(ColorRange.BRIGHT).add(
  ColorRange.LIGHT).add(TColor.WHITE);
  sorted = range.getColors(TColor.MAGENTA, 100, 0.35f);
  sorted = sorted.sortByDistance(false);
  swatches(sorted, 10, yoff);
  yoff += SWATCH_HEIGHT + 10;
  range = new ColorRange(ColorTheoryRegistry.SPLIT_COMPLEMENTARY
    .createListFromColor(TColor.YELLOW));
  sorted = range.getColors(100).sortByDistance(false);
  swatches(sorted, 10, yoff);
  yoff += SWATCH_HEIGHT + 10;
}

void keyPressed() {
  redraw();
}


void swatch(TColor c, int x, int y) {
  fill(c.toARGB());
  rect(x, y, SWATCH_WIDTH, SWATCH_HEIGHT);
}

void swatches(ColorList sorted, int x, int y) {
  noStroke();
  for (Iterator i = sorted.iterator(); i.hasNext();) {
    TColor c = (TColor) i.next();
    swatch(c, x, y);
    x += SWATCH_WIDTH + SWATCH_GAP;
  }
}
