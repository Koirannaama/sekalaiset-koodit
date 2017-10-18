import { Component } from '@angular/core';
import { NgbModal } from '@ng-bootstrap/ng-bootstrap';

const treetypes = [
  { type: "Birch" },
  { type: "Spruce" },
  { type: "Oak" }
];

class TreeType {
  type: string;
}

export class Tree {
  type: TreeType;
  height: number;
  x: number;
  y: number;

  constructor(type: TreeType, height: number) {
    this.type = type;
    this.height = height;
    this.x = Math.random() * 300;
    this.y = Math.random() * 200;
  }
}

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})

export class AppComponent {
  title = 'Forest Creator';
  availableTrees: TreeType[] = treetypes;
  selectedTree: TreeType;
  createdTreeHeight: number;
  usersTrees: Tree[] = [];

  constructor( private modalService: NgbModal) {

  }

  onSelect(tree: TreeType, modal): void {
    this.selectedTree = tree;
    this.modalService.open(modal).result.then(result => {
      this.onClick();
    }, reason => {
      console.log("reason");
    });
  }

  onClick(): void {
    let newTree = new Tree(this.selectedTree, this.createdTreeHeight);
    this.usersTrees = this.usersTrees.concat(newTree);
    this.createdTreeHeight = null;
  }
}
