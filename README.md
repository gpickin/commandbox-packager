# CommandBox Packager

This Module takes the packaging logic out of CommandBox and makes it available for alternative build / deployment options instead of ForgeBox.
This module allows you to pass a path, and it will return the location of the zip file.

## Use from Task Runner

```
component {

    function run(){
        print.line( "Loading Module" );
        loadModule( 'modules/commandbox-packager' );
        var packager = getInstance( "packager@commandbox-packager" );
        print.line( "Zipping Module" );
        var theZip = packager.createZipFromPath( expandPath( './' ) );
        print.line( theZip );
    }
}
```