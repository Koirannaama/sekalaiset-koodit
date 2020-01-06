import { Component, OnInit } from '@angular/core';
import { Store, select } from '@ngrx/store';
import { State, selectAllReports } from 'src/app/state/state';
import { ActivityReport } from 'src/app/models/activity-report';
import { Observable } from 'rxjs';

@Component({
  selector: 'app-report-archive',
  templateUrl: './report-archive.component.html',
  styleUrls: ['./report-archive.component.sass']
})
export class ReportArchiveComponent implements OnInit {

  reports$: Observable<ActivityReport[]>;

  constructor(private store: Store<{activities: State}>) { }

  ngOnInit() {
    this.reports$ = this.store.pipe(select(selectAllReports));
  }

}
