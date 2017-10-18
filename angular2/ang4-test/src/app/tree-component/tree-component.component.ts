import { Component, OnInit, Input } from '@angular/core';
import { Tree } from '../app.component'

@Component({
  selector: 'tree-component',
  templateUrl: './tree-component.component.html',
  styleUrls: ['./tree-component.component.css']
})
export class TreeComponentComponent implements OnInit {

  @Input() tree: Tree;
  
  constructor() { }

  ngOnInit() {
  }

}
