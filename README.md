# memvalid

Tool for either memorising text by checking that you can reconstruct what you've read just by the first letter of each word.

## TODO

* [X] Single textbox to paste stuff into
* [X] div with truncated words from textbox
* [X] Right/space/l reveals next word and moves cursor forward
* [X] Left/h hides current word and and moves cursor back
* [X] Make heroku.yml and create Docker images for build / run steps
* [X] Make it look real purdy
* [ ] Make it more efficient (don't reprocess the input every time the user moves forward or back -- do it once when switching out of edit mode)
* [ ] Click to save textbox in DB with (required) title
* [ ] On load, show one div for each row in DB (with your user id... later)
* [ ] div starts out collapsed, click heading to reveal and test
* [ ] Only one div can be expanded at a time
