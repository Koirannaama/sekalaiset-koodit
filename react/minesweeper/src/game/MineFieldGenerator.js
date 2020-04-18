import { MineFieldBlock } from "./MineFieldBlock";

export class MineFieldGenerator {
  generateMineField() {
    let field = new Array(10).fill(null).reduce(
      ([minesLeft, rows]) => {
        let [mines, newRow] = this.generateRow(minesLeft);
        rows.push(newRow)
        return [mines, rows];
      },
      [10, []]
    )[1];

    field.forEach((row, x) => row.forEach((block, y) => block.number = this.minesAdjacentToBlockAt(x, y, field)));
    console.log(field);
    return field;
  }

  generateRow(minesLeft) {
    let row = new Array(10).fill(null).map(() => {
      if (minesLeft && Math.random() <= 0.1) {
        minesLeft--;
        return new MineFieldBlock('b');
      }
      else {
        return new MineFieldBlock('0');
      }
    });
    return [minesLeft, row];
  }

  minesAdjacentToBlockAt(x, y, mineField) {
    let mines = 0;
    for (let i = x-1; i < x+2; i++) {
      for (let j = y-1; j < y+2; j++) {
        if (mineField[i] && mineField[i][j] && mineField[i][j].isMine()) {
          mines++;
        }
      }
    }
    return mines;
  }
}