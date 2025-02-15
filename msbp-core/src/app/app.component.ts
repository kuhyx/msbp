import { AboutUsComponent } from './about-us/about-us.component';
import { RealizationsComponent } from './realizations/realizations.component';
import { Component } from '@angular/core';
import { MatSidenavContainer } from '@angular/material/sidenav';
import { MatSlideToggleModule } from '@angular/material/slide-toggle';
import { MatToolbarModule } from '@angular/material/toolbar';
import { RouterOutlet } from '@angular/router';
import { ServicesSectionComponent } from './services-section/services-section.component';
import { ToolbarComponent } from './toolbar/toolbar.component';
import { WorkComponent } from './work/work.component';
import { ContactComponent } from './contact/contact.component';
import { WorkedWithComponent } from './worked-with/worked-with.component';
import { TeamComponent } from './team/team.component';

@Component({
  imports: [RouterOutlet, ServicesSectionComponent, MatSlideToggleModule, MatSidenavContainer, MatToolbarModule, AboutUsComponent, ToolbarComponent, RealizationsComponent, TeamComponent,
  WorkComponent,
  ContactComponent,
  WorkedWithComponent
  ],
  selector: 'app-root',
  standalone: true,
  styleUrl: './app.component.scss',
  templateUrl: './app.component.html',
})
export class AppComponent {
  public title = 'msbp-core';
  public currentYear = new Date().getFullYear();
}
