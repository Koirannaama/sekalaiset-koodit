import { MineFieldBlock, MINE } from "./MineFieldBlock";

export class MineFieldGenerator {
  constructor() {
    this.totalMines = 15;
    this.fieldDimension = 10;
  }

  generateMineField() {
    const mines = this.generateMineCoords(this.totalMines, this.fieldDimension);

    const field = new Array(this.fieldDimension).fill(null).map(
      (_, x) => new Array(this.fieldDimension).fill(null).map(
        (_, y) => mines.some(([mineX, mineY]) => x === mineX && y === mineY)
          ? new MineFieldBlock(MINE) : new MineFieldBlock()
      )
    );

    field.forEach((row, x) => row.forEach((block, y) => block.number = this.minesAdjacentToBlockAt(x, y, field)));
    return field;
  }

  generateMineCoords(numberOfMines, fieldDimension) {
    return new Array(numberOfMines).fill(null)
      .reduce((mineCoords) => mineCoords.concat([this.generateMineCoord(mineCoords, fieldDimension)]), []);
  }

  generateMineCoord(allCoords, fieldDimension) {
    const randomCoord = () => Math.floor(fieldDimension * Math.random());
    const [newX, newY] = [randomCoord(), randomCoord()];
    if (!allCoords.some(([x, y]) => x === newX && y === newY)) {
      return [newX, newY];
    }
    else {
      return this.generateMineCoord(allCoords, fieldDimension);
    }
  }

  minesAdjacentToBlockAt(x, y, mineField) {
    let mines = 0;
    for (let i = x-1; i < x+2; i++) {
      for (let j = y-1; j < y+2; j++) {
        if (mineField[i] && mineField[i][j] && mineField[i][j].isMine) {
          mines++;
        }
      }
    }
    return mines;
  }
}