workon.sh
=========

Execute specified commands when you move to work-directory

Install & Setting
-----------------

Place `.workon` file to your work-directory. You must define `workonfunc` and `workonresetfunc` to `.workon` file.
Load `workon.sh` in `.bashrc`.
Setup `workon_workon` function to `PROMPT_COMMAND`.

.workon example:

    function workonfunc {
      workon hatebui
    }

    function workonresetfunc {
      deactivate
    }

This example shows setting up Python virtualenv.
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
