// Import and register all your controllers
import { application } from "./application";

import HamburgerController from "./hamburger_controller";
application.register("hamburger", HamburgerController);

import ModalController from "./modal_controller";
application.register("modal", ModalController);

import ClipboardController from "./clipboard_controller";
application.register("clipboard", ClipboardController);

import FlashController from "./flash_controller";
application.register("flash", FlashController);
