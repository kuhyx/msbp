import { RouterModule, Routes } from '@angular/router';

import { AboutUsComponent } from './about-us/about-us.component';
import { NgModule } from '@angular/core';
import { RealizationsComponent } from './realizations/realizations.component';

const routes: Routes = [
  { component: AboutUsComponent, path: 'o-nas'},
  { component: RealizationsComponent, path: 'wybrane projekty'},
];

@NgModule({
  exports: [RouterModule],
  imports: [RouterModule.forRoot(routes, { scrollPositionRestoration: 'enabled' })],
})
export class AppRoutingModule { }