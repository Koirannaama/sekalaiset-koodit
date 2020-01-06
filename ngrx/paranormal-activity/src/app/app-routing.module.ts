import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { ReportArchiveComponent } from './components/report-archive/report-archive.component';
import { ActivityFormComponent } from './components/activity-form/activity-form.component';

const routes: Routes = [
  { path: "", component: ActivityFormComponent },
  { path: "reports", component: ReportArchiveComponent }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
