import { Component, OnInit } from '@angular/core';
import { Store, select } from '@ngrx/store';
import { State, selectActivityTypes } from 'src/app/state/state';
import { saveForm } from 'src/app/actions/form.actions';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { FormGroup, FormControl, Validators, FormArray, AbstractControl } from '@angular/forms';
import { writeInTypeValidator } from 'src/app/validators/activity-type.directive';
import { ActivityReport } from 'src/app/models/activity-report';

@Component({
  selector: 'app-activity-form',
  templateUrl: './activity-form.component.html',
  styleUrls: ['./activity-form.component.scss']
})
export class ActivityFormComponent implements OnInit {

  activityTypes$: Observable<string[]>;
  activityForm: FormGroup;

  private readonly otherType = "Other";

  constructor(private store: Store<{activities: State}>) { }

  ngOnInit() {
    this.activityTypes$ = this.store.pipe(select(selectActivityTypes))
    .pipe(map(types => types.concat(this.otherType)));

    this.activityForm = new FormGroup({
      location: new FormControl("", [Validators.required]),
      time: new FormControl(new Date(), [Validators.required]),
      type: new FormControl("", [Validators.required]),
      freeTextType: new FormControl(""),
      items: new FormArray([new FormControl("")]),
      invoked: new FormControl(false),
      additionalInfo: new FormControl("")
    },
    { validators: writeInTypeValidator(this.otherType) });
  }

  submitForm() {
    const report = this.createReport();
    this.store.dispatch(saveForm({ submittedReport: report }));
    this.activityForm.reset();
  }

  addItem() {
    const items = this.items as FormArray;
    items.push(new FormControl(""));
  }

  removeItem(index: number) {
    const items = this.items as FormArray;
    items.removeAt(index);
  }

  get location(): AbstractControl {
    return this.activityForm.get("location");
  }

  get time() {
    //console.log(this.activityForm.get("time").errors);
    return this.activityForm.get("time");
  }

  get type() {
    return this.activityForm.get("type");
  }

  get additionalInfo() {
    return this.activityForm.get("additionalInfo");
  }

  get items() {
    return this.activityForm.get("items");
  }

  get freeTextType() {
    return this.activityForm.get("freeTextType");
  }

  get invoked() {
    return this.activityForm.get("invoked");
  }

  private getType(): string {
    const typeSelection = this.type.value;
    return typeSelection !== this.otherType ? typeSelection : this.freeTextType.value;
  }

  private getItems(): string[] {
    return (this.items as FormArray).controls.reduce(
      (items, control) => control.value ? items.concat(control.value) : items, []);
  }

  private createReport(): ActivityReport {
    return {
      time: this.time.value,
      type: this.getType(),
      location: this.location.value,
      items: this.getItems(),
      invoked: this.invoked.value,
      additionalInfo: this.additionalInfo.value
    };
  }
}
