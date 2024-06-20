import { application } from "./application"

import HelloController from "./hello_controller"
application.register("hello", HelloController)

import LoadingController from "./loading_controller"
application.register("loading", LoadingController)
