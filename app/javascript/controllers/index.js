// Import and register all your controllers
import { application } from "./application";

// Manually import controllers (add more as needed)
import HamburgerController from "./hamburger_controller";
// Register controllers
application.register("hamburger", HamburgerController);

// Manually import controllers (add more as needed)
import ModalController from "./modal_controller";
// Register controllers
application.register("modal", ModalController);
