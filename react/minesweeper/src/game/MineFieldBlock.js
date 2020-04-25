export const MINE = 'b';
export const FREE = 'f'

export class MineFieldBlock {
  constructor(type = FREE, number = 0, opened = false, marked = false) {
    this.type = type;
    this.opened = opened;
    this.number = number;
    this.marked = marked
  }

  open() {
    return new MineFieldBlock(this.type, this.number, true);
  }

  toggleMarking() {
    const marked = this.opened ? this.marked : !this.marked;
    return new MineFieldBlock(this.type, this.number, this.opened, marked);
  }

  get isMine() {
    return this.type === MINE;
  }
}