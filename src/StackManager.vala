namespace Application {
public class StackManager : Object {
    
    static StackManager? instance;

    private Gtk.Stack stack;
    private const string LIST_VIEW_ID = "list-view";
    private const string EMPTY_VIEW_ID = "empty-view";
    private const string NOT_FOUND_VIEW_ID = "not-found-view";
    private const string WELCOME_VIEW_ID = "welcome-view";
    private const string PROGRESS_VIEW_ID = "progress-view";
    private const string DETAIL_VIEW_ID = "detail-view";

    DetailView detailView;
    public Gtk.Window mainWindow;

    StackManager() {
        stack = new Gtk.Stack ();
        stack.margin_bottom = 4;
        stack.transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT;
    }
 
    public static StackManager get_instance() {
        if (instance == null) {
            instance = new StackManager();
        }
        return instance;
    }

    public Gtk.Stack getStack() {
        return this.stack;
    }

    public void loadViews(Gtk.Window window) {
        detailView = new DetailView();
        mainWindow = window;

        stack.add_named (new ListView(), LIST_VIEW_ID);
        stack.add_named (new NotFoundView(), NOT_FOUND_VIEW_ID);
        stack.add_named (new WelcomeView(), WELCOME_VIEW_ID);
        stack.add_named (new ProgressView(), PROGRESS_VIEW_ID);
        stack.add_named (detailView, DETAIL_VIEW_ID);

        stack.notify["visible-child"].connect (() => {
            var headerBar = HeaderBar.get_instance();

            if(stack.get_visible_child_name() == WELCOME_VIEW_ID){
                headerBar.showViewMode(true);
                headerBar.setSelectedViewMode(0);
                headerBar.showReturnButton(false);
            }

            if(stack.get_visible_child_name() == DETAIL_VIEW_ID){
                headerBar.showViewMode(false);
                headerBar.showReturnButton(true);
            }

            if(stack.get_visible_child_name() == PROGRESS_VIEW_ID){
                headerBar.showViewMode(false);
                headerBar.showReturnButton(false);
            }

            if(stack.get_visible_child_name() == LIST_VIEW_ID){
                headerBar.showViewMode(true);
                headerBar.setSelectedViewMode(1);
                headerBar.showReturnButton(false);
            }
        });

        window.add(stack);
        window.show_all();
   }

   public void setDetailPackage(Package package) {
        detailView.loadPackage(package);
   }
}
}
