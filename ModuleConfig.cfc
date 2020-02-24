
component {

	// Module Properties
	this.title 				= "commandbox Packager";
	this.author 			= "";
	this.webURL 			= "";
	this.description 		= "";
	this.version			= "1.0.0";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup 	= true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// Module Entry Point
	this.entryPoint			= "commandbox-packager";
	// Model Namespace
	this.modelNamespace		= "commandbox-packager";
	// CF Mapping
	this.cfmapping			= "commandbox-packager";
	// Auto-map models
	this.autoMapModels		= true;
	// Module Dependencies
    this.dependencies 		= [];
    
    function configure(){

    }

}