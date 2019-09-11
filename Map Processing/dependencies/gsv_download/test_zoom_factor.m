  % input parameters
  TILE_WIDTH = 512;
  TILE_HEIGHT = 512;
  ZOOM0_WIDTH = 416;
  ZOOM0_HEIGHT = 208;
  zoomLevel = 3;
  
  % results
  width = ZOOM0_WIDTH * bitshift(1, zoomLevel);
  height = ZOOM0_HEIGHT * bitshift(1, zoomLevel);
  y = height / TILE_HEIGHT - 1;
  x = width / TILE_WIDTH - 1;
  tileY = ceil(height / TILE_HEIGHT) - 1;
  tileX = ceil(width / TILE_WIDTH) - 1;