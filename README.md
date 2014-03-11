workon.sh
=========

Execute specified commands when you move to work-directory

Sorry
-----

I wrote this in Jenglish.

Install & Setting
-----------------

Place `.workon` file to your work-directory. You must define `workonfunc` and `workonresetfunc` to `.workon` file.
Load `workon.sh` in `.bashrc`.
And set to `COMMAND_PROMPT` the exec of `workon_workon` function.

`.workon` example:

    function workon_func {
      workon hatebui
    }

    function workon_resetfunc {
      deactivate
    }

`COMMAND_PROMPT` in `.bashrc` example:

    function prompt_command {
      workon_workon
    }

    PROMPT_COMMAND=prompt_command

This example shows setting up Python virtualenv. That's right, `.workon` file is a shell-script that defines the function, simply.
`workonresetfunc` is executed when you go out from work-directory.

Example
-------

The case of placing `.workon` to `toromoti-playground` directory.

    workon.sh$ cd ../toromoti-playground/
    (hatebui)toromoti-playground$ cd tool/
    (hatebui)tool$ cd ..
    (hatebui)toromoti-playground$ cd ..
    github$ cd ..
    ~$
