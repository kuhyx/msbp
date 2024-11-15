import { AboutUsComponent } from './about-us/about-us.component';
import { Component } from '@angular/core';
import { MatButton } from '@angular/material/button';
import { MatSidenavContainer } from '@angular/material/sidenav';
import { MatSlideToggleModule } from '@angular/material/slide-toggle';
import { MatToolbarModule } from '@angular/material/toolbar';
import { RouterOutlet } from '@angular/router';
import { ToolbarComponent } from './toolbar/toolbar.component';

@Component({
  imports: [RouterOutlet, MatSlideToggleModule, MatSidenavContainer, MatToolbarModule, MatButton, AboutUsComponent, ToolbarComponent],
  selector: 'app-root',
  standalone: true,
  styleUrl: './app.component.scss',
  templateUrl: './app.component.html',
})
export class AppComponent {
  public title = 'msbp-core';
}
