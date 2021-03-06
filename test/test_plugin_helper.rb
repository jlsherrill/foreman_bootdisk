require 'test_helper'

class ActionController::TestCase
  def setup_bootdisk
    setup_routes
    setup_settings
    setup_templates
  end

  def setup_routes
    @routes = ForemanBootdisk::Engine.routes
  end

  def setup_settings
    Setting::Bootdisk.load_defaults
  end

  def setup_templates
    load File.join(File.dirname(__FILE__), '..', 'db', 'seeds.d', '50-bootdisk_templates.rb')
  end

  def setup_org_loc
    disable_orchestration
    request.env["HTTP_REFERER"] = "/history"
    @org, @loc = FactoryGirl.create(:organization), FactoryGirl.create(:location)
  end

  def setup_subnet
    @subnet = FactoryGirl.create(:subnet, :tftp, :gateway => '10.0.1.254', :dns_primary => '8.8.8.8', :organizations => [@org], :locations => [@loc])
  end

  def setup_subnet_no_tftp
    @subnet = FactoryGirl.create(:subnet, :gateway => '10.0.1.254', :dns_primary => '8.8.8.8', :organizations => [@org], :locations => [@loc])
  end

  def setup_host
    @host = FactoryGirl.create(:host, :managed, :subnet => @subnet, :ip => @subnet.network.sub(/0$/, '4'), :organization => @org, :location => @loc)
  end

end
