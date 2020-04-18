export const MINE = 'b';
export const FREE = 'f'

export class MineFieldBlock {
  constructor(type = FREE, number = 0, opened = false) {
    this.type = type;
    this.opened = opened;
    this.number = number;
  }

  open() {
    return new MineFieldBlock(this.type, this.number, true);
  }

  get isMine() {
    return this.type === MINE;
  }
}