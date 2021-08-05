import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import '../js/bootstrap_js_files.js'

import 'trix'
import '@rails/actiontext'

Rails.start()
Turbolinks.start()
ActiveStorage.start()

import '../js/recipes.js'
