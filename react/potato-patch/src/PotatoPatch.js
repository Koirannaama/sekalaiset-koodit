const buyableTileSymbol = "-";
export const initialPotatoPatch = [
  [0, 0, buyableTileSymbol],
  [0, 0, buyableTileSymbol],
  [buyableTileSymbol, buyableTileSymbol, buyableTileSymbol]
];

export function isTileBuyable(tile) {
  return tile === buyableTileSymbol;
}

export function buyTileAt(grid, x, y) {
  let tileBought = grid.map((row, i) => {
    return row.map((tile, j) => {
      return x === i && y === j && grid[x][y] === buyableTileSymbol 
              ? 0 : tile;
    });
  });
  let hasBuyableTiles = tileBought.some(row => row.some(tile => tile === buyableTileSymbol));
  return hasBuyableTiles 
          ? tileBought 
          : createNewBuyableTiles(tileBought);
}

function createNewBuyableTiles(grid) {
  let newRow = grid[0].map(tile => buyableTileSymbol);
  return grid.concat([newRow]).map(row => row.concat(buyableTileSymbol));
}

export function canPlantAt(grid, x, y) {
  return grid[x][y] === 0;
}

export function plantPotatoAt(grid, x, y) {
  return grid.map((row, i) => {
    return row.map((tile, j) => {
      return x === i && y === j /* && tile === 0 */
              ? 1
              : tile;
    });
  });
}

