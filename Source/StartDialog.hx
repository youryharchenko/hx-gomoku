package;

import openfl.Lib;
import haxe.ui.core.Component;
import haxe.ui.containers.dialogs.DialogOptions;
import haxe.ui.containers.dialogs.DialogButton;
import haxe.ui.components.Button;

class StartDialog extends Component{

    private var white:DialogButton;
    private var black:DialogButton;
    public var opts = new DialogOptions();

    public function new() {
        super();

        black = new DialogButton("black", "Black", true);
        white = new DialogButton("white", "White", true);

        opts.title = "Select color and press";
        opts.icon = DialogOptions.ICON_QUESTION;
        
        black.styleNames = "dialog-button";
        opts.addButton(black);

        white.styleNames = "dialog-button";
        opts.addButton(white);
        
    }
    
}