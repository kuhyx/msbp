import { RouterModule, Routes } from '@angular/router';

import { AboutUsComponent } from './about-us/about-us.component';
import { NgModule } from '@angular/core';

const routes: Routes = [
  { component: AboutUsComponent, path: 'o-nas'},
];

@NgModule({
  exports: [RouterModule],
  imports: [RouterModule.forRoot(routes, { scrollPositionRestoration: 'enabled' })],
})
export class AppRoutingModule { }