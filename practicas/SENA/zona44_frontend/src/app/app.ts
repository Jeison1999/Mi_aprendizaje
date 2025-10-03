import { Component, signal } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import { AppMenuComponent } from "./app-menu.component";

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [RouterOutlet, AppMenuComponent],
  templateUrl: './app.html',
  styleUrls: ['./app.css']
})
export class App {
  protected readonly title = signal('zona44_frontend');
}
