# fs-lint

File naming consistency verification tool.

## What is this?

It just checks that all your files, or different subsets of your files, follow
a consistent naming convention. For example, you may want all your CSS or SASS
or Stylus files to be named using a `lowercase-with-dashes.css` convention.

## Install

Most of the time:

```bash
$ npm install fs-lint --save-dev
```

You can install it globally as well.

## CLI Usage

Example:

```bash
$ node_modules/.bin/fs-lint --help

  Usage: fs-lint [options]

  Options:

    -h, --help           output usage information
    -c, --config <file>  specify configuration file
    -v, --verbose        show more information
    --color              force color display out of a TTY

$ cat .fs-lint
{
  "rules": [
    {
      "files": [
        "assets/js/**/*.coffee",
        "lib/{,*/}*.coffee",
        "routes/*.coffee"
      ],
      "naming": "lowerCamelCase",
      "level": "error"
    },
    {
      "files": "assets/css/**/*.styl",
      "naming": "lowercase-dash",
      "level": "warning"
    }
  ]
}
$ node_modules/.bin/fs-lint
error: violates 'lowerCamelCase' naming: lib/FooBar.coffee
warning: violates 'lowercase-dash' naming: assets/css/fooBar.styl
```

## Programmatic Usage

The module exports a class `FsLint`, that
[generates events](http://nodejs.org/api/events.html).

`FsLint.process(config, baseDir)`: check files, just like the CLI tool is
doing. the `config` object should have the same organisation as the `.fs-lint`
files, see above. The `baseDir` defaults to `process.cwd`, it specifies where
the tool is looking for the patterns. Return `false` if some errors where
encountered, `true` otherwise.

Event `entry(entry)`: when there's a warning or error. `entry` contains
`naming`, `filePath`, `isError`.

Event `pattern(pattern)`: when starting globbing a path `pattern`.

Event `unknownLevel(level)`: when stumbling upon an invalid `level` in the
config.

Event `unknownNaming(naming)`: when stumbling upon an invalid `naming`.

Event `emptyPattern(pattern)`: when a path pattern does not match any file.

## Limitations

* Can't specify custom naming conventions;
* don't provide a Grunt task. Feel free to implement one.

## Roadmap

* Write proper tests;
* allow the config. to specify custom naming conventions.

## Contribute

Feel free to fork and submit pull requests.
