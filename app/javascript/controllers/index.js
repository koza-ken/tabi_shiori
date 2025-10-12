// Import and register all your controllers
import { application } from "./application"

// Manually import controllers (add more as needed)
import HelloController from "./hello_controller"

// Register controllers
application.register("hello", HelloController)
