class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(App.bounds)
    @window.makeKeyAndVisible

    @controller = AccordionViewController.alloc.init
    @window.rootViewController = @controller

    true
  end
end
