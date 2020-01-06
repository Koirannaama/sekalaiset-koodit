import { ValidatorFn, FormGroup, ValidationErrors } from '@angular/forms';

export function writeInTypeValidator(otherTypeOption: string): ValidatorFn {
  return (form: FormGroup): ValidationErrors | null => {
    const selectedType = form.get("type").value;
    const writeInType = form.get("freeTextType").value;

    return selectedType === otherTypeOption && !writeInType ? { 'emptyType': true } : null;
  };
}