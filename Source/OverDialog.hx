package;

import haxe.ui.core.Component;
import haxe.ui.containers.dialogs.DialogOptions;
import haxe.ui.containers.dialogs.DialogButton;

class OverDialog extends Component{

    private var white:DialogButton;
    private var black:DialogButton;
    private var quit:DialogButton;
    public var opts = new DialogOptions();

    public function new() {
        super();
        
        black = new DialogButton("black", "Black", true);
        white = new DialogButton("white", "White", true);
        quit = new DialogButton("quit", "Quit", true);

        opts.icon = DialogOptions.ICON_QUESTION;
        
        black.styleNames = "dialog-button";
        opts.addButton(black);

        white.styleNames = "dialog-button";
        opts.addButton(white);

        quit.styleNames = "dialog-button";
        //opts.addButton(quit);
        
    }
    
}