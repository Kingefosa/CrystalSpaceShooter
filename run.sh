# todo: move voidcsfml inside this directory
export LIBRARY_PATH=/home/marrow16180/Programming/Crystal/crsfml/voidcsfml
export LD_LIBRARY_PATH="$LIBRARY_PATH"

# debug
crystal main.cr

#crystal tools/gui_hotloader.cr

# release
#crystal main.cr --define release
