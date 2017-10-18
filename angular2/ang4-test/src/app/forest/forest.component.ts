import { Component, OnChanges, SimpleChange, OnInit, Input, AfterViewInit } from '@angular/core';
import { Tree } from '../app.component'
import * as D3 from "d3";

@Component({
  selector: 'forest',
  templateUrl: './forest.component.html',
  styleUrls: ['./forest.component.css']
})
export class ForestComponent implements OnInit {
  
  private _trees: Tree[];

  @Input()
  set trees(trees: Tree[]) {
    this._trees = trees;
    this.drawCircles(trees);
    console.log("trees set");
  }
  get trees(): Tree[] {
    return this._trees;
  }

  constructor() { }

  AfterViewInit() {
    this.drawCircles(this._trees);
  }

  drawCircles(trees: Tree[]) {
    let svg = D3.select("svg");
    svg.selectAll("circle")
      .data<Tree>(trees)
      .enter()
      .append("circle")
      .attr("r", 10)
      .attr("stroke", "red")
      .attr("cx", function(d: Tree) { return d.x; })
      .attr("cy", function(d: Tree) { return d.y; })
      .call(
        D3.drag<SVGCircleElement, Tree>()
          .on("start", this.startDrag)
          .on("drag", this.drag)
          .on("end", this.dragEnd)
      );
  }

  private startDrag() {
    
  }

  private drag(this: SVGCircleElement, d: Tree): void {
    let x = D3.event.x;
    let y = D3.event.y;
    D3.select(this).attr("cx", d.x = x).attr("cy", d.y = y)
  }

  private dragEnd() {

  }

  ngOnInit() {
  }

}
