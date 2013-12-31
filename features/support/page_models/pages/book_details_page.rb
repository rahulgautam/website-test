module PageModels
  class BookDetailsPage < PageModels::BlinkboxbooksPage
    set_url_matcher /book/
    element :read_offline, ".read-offline"
    element :buy_now, "button", :text => "BUY NOW"
  end
  register_model_caller_method(BookDetailsPage)
end