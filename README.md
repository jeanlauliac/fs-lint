# fs-lint

File naming consistency verification tool. It just checks that all your files,
or different subsets of your files, follow a consistent naming convention.
For example, you may want all your CSS or SASS or Stylus files to be named
using a `lowercase-with-dashes.css` convention.

# Install

Most of the time:

```bash
$ npm install fs-lint --save-dev
```

You can install it globally as well.

# Usage

```bash
$ node_modules/.bin/fs-lint --help

  Usage: fs-lint [options]

  Options:

    -h, --help           output usage information
    -c, --config <file>  specify configuration file
    -v, --verbose        show more information
    --color              force color display out of a TTY

$ echo .fs-lint
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

# Limitations

Can't specify custom naming conventions. Feel free to fork and add the feature
if you need it and find the module useful.

Don't provide a Grunt task. Feel free to implement one.

# Contribute

Feel free to fork and submit pull requests.
