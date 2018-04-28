import * as Seasons from "./Seasons";

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
      return x === i && y === j
              ? 1
              : tile;
    });
  });
}

export function summerToFall(grid) {
  const potatoGrowthRate = 0.5;
  const seedPotatoGrowthRate = 0.3;
  const potatoDeathRate = 0.2;

  return grid.reduce(([newGrid, potatoes, seedPotatoes], row, i) => {
    let [updatedRow, potatoesInRow, seedPotatoesInRow] = row.reduce(([newRow, rowPot, rowSeed], tile, j) => {
      let rand = Math.random();

      if (tile === 0 || tile === buyableTileSymbol) {
        return [newRow.concat(tile), rowPot, rowSeed];
      }
      else if (rand >= 0 && rand < seedPotatoGrowthRate) {
        return [newRow.concat(tile-1), rowPot, rowSeed+1];
      }
      else if (rand >= seedPotatoGrowthRate && rand < seedPotatoGrowthRate + potatoGrowthRate) {
        return [newRow.concat(tile-1), rowPot+1, rowSeed];
      } 
      else {
        return [newRow.concat(tile-1), rowPot, rowSeed];
      }

    }, [[], 0, 0]);
    return [newGrid.concat([updatedRow]), potatoes+potatoesInRow, seedPotatoes+seedPotatoesInRow];
  }, [[], 0, 0]);
}

