using Granite.Widgets;

namespace Application {
public class HeaderBar : Gtk.HeaderBar {
    
    static HeaderBar? instance;

    private StackManager stackManager = StackManager.get_instance();
    ListBox listBox = ListBox.get_instance();    
    public Gtk.SearchEntry searchEntry = new Gtk.SearchEntry ();
    public Gtk.Button return_button = new Gtk.Button ();
    private Granite.Widgets.ModeButton view_mode = new Granite.Widgets.ModeButton();

    HeaderBar() {
        Granite.Widgets.Utils.set_color_primary (this, Constants.BRAND_COLOR);
        
        generateSearchEntry();
        generateReturnButton();
        generateViewMode();
    
        this.show_close_button = true;
        this.pack_start (view_mode);
        this.pack_start (return_button);
        this.pack_end (searchEntry);
    }
 
    public static HeaderBar get_instance() {
        if (instance == null) {
            instance = new HeaderBar();
        }
        return instance;
    }

    private void generateViewMode(){
	    //Create two labels. Assign names for a check later on.
	    var label1 = new Gtk.Label("Home");
	    label1.name = "home";
            
	    var label2 = new Gtk.Label("Updates");
	    label2.name = "updates";
        
	    //Add each label to the Mode Button.
	    view_mode.append(label1);
	    view_mode.append(label2);

	    //Specify which button is active on initialization
	    view_mode.set_active(0);
        view_mode.margin = 1;
        view_mode.notify["selected"].connect (on_view_mode_changed);
    }

    private void generateSearchEntry(){
        searchEntry.set_placeholder_text(_("Search Apps"));
        searchEntry.set_tooltip_text(_("Search for applications"));
        searchEntry.sensitive = true;
        searchEntry.search_changed.connect (() => {
            view_mode.visible = false;
            listBox.getOnlinePackages(searchEntry.text);
        });
    }

    private void generateReturnButton(){
        return_button.label = _("Back");
        return_button.no_show_all = true;
        return_button.get_style_context ().add_class ("back-button");
        return_button.visible = false;
        return_button.clicked.connect (() => {
            searchEntry.set_text("");
            showReturnButton(false);
            showViewMode(true);
            stackManager.getStack().visible_child_name = "welcome-view";
        });
    }

    public void showSearchEntry(bool answer){
        searchEntry.visible = answer;
    }

    public void showReturnButton(bool answer){
        return_button.visible = answer;
    }

    public void showViewMode(bool answer){
        view_mode.visible = answer;
    }

     private void on_view_mode_changed () {
        if (view_mode.selected == 0){
            stackManager.getStack().visible_child_name = "welcome-view";
            searchEntry.sensitive = true;
        }else{
            stackManager.getStack().visible_child_name = "list-view";
            listBox.getInstalledPackages();
            searchEntry.sensitive = false;
        }
    }
}
}
