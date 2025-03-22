import { Component } from '@angular/core';
import { MatToolbarModule } from '@angular/material/toolbar';
import { RouterModule } from '@angular/router';

@Component({
  imports: [MatToolbarModule, RouterModule],
  selector: 'app-toolbar',
  standalone: true,
  styleUrls: ['./toolbar.component.scss'],
  templateUrl: './toolbar.component.html',
  
})
export class ToolbarComponent {
  scroll(element_name: string) {
    const element = document.getElementById(element_name);
    if (element) {
      element.scrollIntoView({behavior: 'smooth'});
    } else {
      console.error(`Element with id ${element_name} not found`);
    }
  }
}
