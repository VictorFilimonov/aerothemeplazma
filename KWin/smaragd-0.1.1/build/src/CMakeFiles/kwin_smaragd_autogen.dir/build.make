# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.23

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Disable VCS-based implicit rules.
% : %,v

# Disable VCS-based implicit rules.
% : RCS/%

# Disable VCS-based implicit rules.
% : RCS/%,v

# Disable VCS-based implicit rules.
% : SCCS/s.%

# Disable VCS-based implicit rules.
% : s.%

.SUFFIXES: .hpux_make_needs_suffix_list

# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

#Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /mnt/792afca2-ecd6-4e41-938a-2e818d0f60d1/home/anon/Desktop/Aero_Theme/KWin/smaragd-0.1.1

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /mnt/792afca2-ecd6-4e41-938a-2e818d0f60d1/home/anon/Desktop/Aero_Theme/KWin/smaragd-0.1.1/build

# Utility rule file for kwin_smaragd_autogen.

# Include any custom commands dependencies for this target.
include src/CMakeFiles/kwin_smaragd_autogen.dir/compiler_depend.make

# Include the progress variables for this target.
include src/CMakeFiles/kwin_smaragd_autogen.dir/progress.make

src/CMakeFiles/kwin_smaragd_autogen:
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --blue --bold --progress-dir=/mnt/792afca2-ecd6-4e41-938a-2e818d0f60d1/home/anon/Desktop/Aero_Theme/KWin/smaragd-0.1.1/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Automatic MOC for target kwin_smaragd"
	cd /mnt/792afca2-ecd6-4e41-938a-2e818d0f60d1/home/anon/Desktop/Aero_Theme/KWin/smaragd-0.1.1/build/src && /usr/bin/cmake -E cmake_autogen /mnt/792afca2-ecd6-4e41-938a-2e818d0f60d1/home/anon/Desktop/Aero_Theme/KWin/smaragd-0.1.1/build/src/CMakeFiles/kwin_smaragd_autogen.dir/AutogenInfo.json ""

kwin_smaragd_autogen: src/CMakeFiles/kwin_smaragd_autogen
kwin_smaragd_autogen: src/CMakeFiles/kwin_smaragd_autogen.dir/build.make
.PHONY : kwin_smaragd_autogen

# Rule to build all files generated by this target.
src/CMakeFiles/kwin_smaragd_autogen.dir/build: kwin_smaragd_autogen
.PHONY : src/CMakeFiles/kwin_smaragd_autogen.dir/build

src/CMakeFiles/kwin_smaragd_autogen.dir/clean:
	cd /mnt/792afca2-ecd6-4e41-938a-2e818d0f60d1/home/anon/Desktop/Aero_Theme/KWin/smaragd-0.1.1/build/src && $(CMAKE_COMMAND) -P CMakeFiles/kwin_smaragd_autogen.dir/cmake_clean.cmake
.PHONY : src/CMakeFiles/kwin_smaragd_autogen.dir/clean

src/CMakeFiles/kwin_smaragd_autogen.dir/depend:
	cd /mnt/792afca2-ecd6-4e41-938a-2e818d0f60d1/home/anon/Desktop/Aero_Theme/KWin/smaragd-0.1.1/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /mnt/792afca2-ecd6-4e41-938a-2e818d0f60d1/home/anon/Desktop/Aero_Theme/KWin/smaragd-0.1.1 /mnt/792afca2-ecd6-4e41-938a-2e818d0f60d1/home/anon/Desktop/Aero_Theme/KWin/smaragd-0.1.1/src /mnt/792afca2-ecd6-4e41-938a-2e818d0f60d1/home/anon/Desktop/Aero_Theme/KWin/smaragd-0.1.1/build /mnt/792afca2-ecd6-4e41-938a-2e818d0f60d1/home/anon/Desktop/Aero_Theme/KWin/smaragd-0.1.1/build/src /mnt/792afca2-ecd6-4e41-938a-2e818d0f60d1/home/anon/Desktop/Aero_Theme/KWin/smaragd-0.1.1/build/src/CMakeFiles/kwin_smaragd_autogen.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : src/CMakeFiles/kwin_smaragd_autogen.dir/depend

