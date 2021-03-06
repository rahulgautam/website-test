module PageModels
  class AccountTab < PageModels::BlinkboxbooksSection
    element :link, 'a'

    def title
      link.text
    end

    def selected?
      root_element[:class] =~ /selected/
    end

    def click
      link.click
    end
  end

  class AccountNavFrame < PageModels::BlinkboxbooksSection
    element :account_nav_menu, '.account_menu'
    sections :tabs, AccountTab, '.account_menu li'

    def account_nav_tab(tab_name)
      tabs.select { |tab| tab.title == tab_name }.first
    end

    def navigate_to_account_tab(tab_name)
      wait_for_account_nav_menu
      account_nav_tab(tab_name).click
    end

    def selected_tab
      tabs.select { |tab| tab.selected? }.first
    end
  end
end
