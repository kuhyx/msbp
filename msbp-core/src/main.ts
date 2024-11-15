import { AppComponent } from './app/app.component';
import { appConfig } from './app/app.config';
import { bootstrapApplication } from '@angular/platform-browser';

bootstrapApplication(AppComponent, appConfig).catch((err: unknown) => {
  // eslint-disable-next-line no-console
  console.error(`An error occurred: ${String(err)}`);
});
