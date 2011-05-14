ProductsController.class_eval do
  self.const_set("HTTP_REFERER_REGEXP", /^http?:\/\/[^\/]+\/t\/([a-z0-9\-\/]+)$/)
end
