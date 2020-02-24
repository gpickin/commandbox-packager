component {

    property name="packageService" inject="packageService";
    property name='fileSystemUtil'		inject='FileSystem';
    property name="tempDir" 			inject="tempDir@constants";
   	property name='pathPatternMatcher' 	inject='provider:pathPatternMatcher@globber';


    function createZipFromPath( required string path ) {
		if( !packageService.isPackage( arguments.path ) ) {
			throw(
				'Sorry but [#arguments.path#] isn''t a package.',
				'endpointException',
				'Please double check you''re in the correct directory or use "package init" to turn your directory into a package.'
			);
		}
		var boxJSON = packageService.readPackageDescriptor( arguments.path );
		var ignorePatterns = generateIgnorePatterns( boxJSON );
		var tmpPath = tempDir & hash( arguments.path );
		if ( directoryExists( tmpPath ) ) {
			directoryDelete( tmpPath, true );
		}
		directoryCreate( tmpPath );
		directoryCopy( arguments.path, tmpPath, true, function( directoryPath ){
			// This will normalize the slashes to match
			directoryPath = fileSystemUtil.resolvePath( directoryPath );
			// Directories need to end in a trailing slash
			if( directoryExists( directoryPath ) ) {
				directoryPath &= server.separator.file;
			}
			// cleanup path so we just get from the archive down
			var thisPath = replacenocase( directoryPath, tmpPath, "" );
			// Ignore paths that match one of our ignore patterns
			var ignored = pathPatternMatcher.matchPatterns( ignorePatterns, thisPath );
			// What do we do with this file/directory
			return ! ignored;
		});
		var zipFileName = tmpPath & ".zip";
		cfzip(
			action = "zip",
			file = zipFileName,
			overwrite = true,
			source = tmpPath
		);
		directoryDelete( tmpPath, true );
		return zipFileName;
	}

	private array function generateIgnorePatterns( boxJSON ) {
		var ignorePatterns = [];

		var alwaysIgnores = [
			".*.swp", "._*", ".DS_Store", ".git", "hg", ".svn",
			".lock-wscript", ".wafpickle-*", "config.gypi"
		];
		var gitIgnores = readGitIgnores();
		var boxJSONIgnores = ( isArray( boxJSON.ignore ) ? boxJSON.ignore : [] );

		// this order is important for exclusions to work as expected.
		arrayAppend( ignorePatterns, alwaysIgnores, true );
		arrayAppend( ignorePatterns, gitIgnores, true );
		arrayAppend( ignorePatterns, boxJSONIgnores, true );

		// make any `/` paths absolute
		return ignorePatterns.map( function( pattern ) {
			if ( left( pattern, 1 ) == "/" ) {
				return fileSystemUtil.resolvePath( "" ) & pattern;
			}
			return pattern;
		} );
	}

	private array function readGitIgnores() {
		var projectRoot = fileSystemUtil.resolvePath( "" );
		if ( ! fileExists( projectRoot & "/.gitignore" ) ) {
			return [];
		}
		return fileRead( projectRoot & "/.gitignore" ).listToArray(
			createObject( "java", "java.lang.System" ).getProperty( "line.separator" )
		);
    }
    





    


}