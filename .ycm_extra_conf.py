# Copyright (C) 2014 Google Inc.
#
# This file is part of ycmd.
#
# ycmd is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# ycmd is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with ycmd.  If not, see <http://www.gnu.org/licenses/>.

import os
import ycm_core
import glob

# These are the compilation flags that will be used in case there's no
# compilation database set (by default, one is not set).
# CHANGE THIS LIST OF FLAGS. YES, THIS IS THE DROID YOU HAVE BEEN LOOKING FOR.
flags = [
'-Wall',
'-Wextra',
'-Werror',
'-fexceptions',
'-DNDEBUG',
# THIS IS IMPORTANT! Without a '-std=<something>' flag, clang won't know which
# language to use when compiling headers. So it will guess. Badly. So C++
# headers will be compiled as C headers. You don't want that so ALWAYS specify
# a '-std=<something>'.
# For a C project, you would set this to something like 'c99' instead of
# 'c++11'.
'-std=c++11',
# ...and the same thing goes for the magic -x option which specifies the
# language that the files to be compiled are written in. This is mostly
# relevant for c++ headers.
# For a C project, you would set this to 'c' instead of 'c++'.
'-x',
'c++',
'-isystem',
'/usr/include',
'-isystem',
'/usr/local/include',
'-isystem',
]

debug = False
debug_out_file = open('/tmp/ycm_debug_file.log', 'w+')

def debug_out(string):
    global debug_out
    if debug:
        debug_out_file.write(string + '\n')
        debug_out_file.flush()


# Set this to the absolute path to the folder (NOT the file!) containing the
# compile_commands.json file to use that instead of 'flags'. See here for
# more details: http://clang.llvm.org/docs/JSONCompilationDatabase.html
#
# Most projects will NOT need to set this to anything; you can just change the
# 'flags' list of compilation flags.
compilation_database_folder = ''

g_cwd = ''
#debug_output = open('debug.txt', 'w')

if os.path.exists( compilation_database_folder ):
    database = ycm_core.CompilationDatabase( compilation_database_folder )
else:
    database = None

SOURCE_EXTENSIONS = [ '.cpp', '.cxx', '.cc', '.c', '.m', '.mm' ]

def DirectoryOfThisScript():
    return os.path.dirname( os.path.abspath( __file__ ) )


def MakeRelativePathsInFlagsAbsolute( flags, working_directory ):
    if not working_directory:
        return list( flags )
    new_flags = []
    make_next_absolute = False
    path_flags = [ '-isystem', '-I', '-iquote', '--sysroot=' ]
    for flag in flags:
        new_flag = flag

        if make_next_absolute:
            make_next_absolute = False
            if not flag.startswith( '/' ):
                new_flag = os.path.join( working_directory, flag )

        for path_flag in path_flags:
            if flag == path_flag:
                make_next_absolute = True
                break

            if flag.startswith( path_flag ):
                path = flag[ len( path_flag ): ]
                new_flag = path_flag + os.path.join( working_directory, path )
                break

        if new_flag:
          new_flags.append( new_flag )
    return new_flags


def IsHeaderFile( filename ):
    extension = os.path.splitext( filename )[ 1 ]
    return extension in [ '.h', '.hxx', '.hpp', '.hh' ]


def GetCompilationInfoForFile( filename ):
    # The compilation_commands.json file generated by CMake does not have entries
    # for header files. So we do our best by asking the db for flags for a
    # corresponding source file, if any. If one exists, the flags for that file
    # should be good enough.
    if IsHeaderFile( filename ):
        basename = os.path.splitext( filename )[ 0 ]
        for extension in SOURCE_EXTENSIONS:
            replacement_file = basename + extension
            if os.path.exists( replacement_file ):
                compilation_info = database.GetCompilationInfoForFile(
                    replacement_file )
                if compilation_info.compiler_flags_:
                    return compilation_info
                return None
    return database.GetCompilationInfoForFile( filename )

def findProjectDirectory(directory):
    debug_out("findProjectDirectory...")
    cur_dir = directory
    project_dir = directory
    while cur_dir:
        debug_out("testing " + cur_dir)
        cmake_lists_file = os.path.join(cur_dir,  'CMakeLists.txt')
        if os.path.exists(cmake_lists_file):
            project_dir = cur_dir

        (new_dir, head) = os.path.split(cur_dir)
        if new_dir == cur_dir:
            break
        cur_dir = new_dir

    debug_out('using project dir ' +  project_dir)
    return project_dir

def locateDatabase(directory):
    project_dir = findProjectDirectory(directory)
    if not project_dir:
        return None

    build_types = [
            'debug', 
            'Debug', 
            'release', 
            'Release', 
            'RelWithDebInfo', 
            'relwithdebinfo', 
            'minsizerel', 
            'MinSizeRel', 
            'build-*',
            ]

    possible_build_dirs = [
            'build',
            'Build',
            '.',
            '..'
            ]

    for build_dir_prefix in possible_build_dirs:
        build_dir_base = os.path.join(project_dir, build_dir_prefix)
        if not os.path.exists(build_dir_base):
            continue

        for build_type in build_types:
            full_build_dir = os.path.join(build_dir_base, build_type)
            debug_out("Testing build root dir " + full_build_dir)
            paths = glob.glob(full_build_dir)
            for path in paths:
                debug_out("Checking build dir" + path)
                database_file = os.path.join(path, 'compile_commands.json')
                if os.path.exists(database_file):
                    return os.path.normpath(path)

    return None

# This is the entry point; this function is called by ycmd to produce flags for
# a file.
def FlagsForFile( filename, **kwargs ):
    global g_cwd
    #global debug_output
    global database
    current_cwd = os.getcwd()
    debug_out("Getting flags for file: " + str(filename))
    debug_out('cwd: ' + str(current_cwd))
    if g_cwd != current_cwd:
        debug_out('Trying to locate database file')
        g_cwd = current_cwd
        try:
            debug_out('Locating database...')
            database_dir = locateDatabase(current_cwd)
            debug_out('Got database dir: ' + database_dir)
            if database_dir:
                database = ycm_core.CompilationDatabase( database_dir )
                debug_output('Database loaded: ' + str(database.DatabaseSuccessfullyLoaded()) + '\n')
        except:
            type, value, traceback = sys.exc_info()
            debug_out(traceback)
            debug_out('Error: ' + value )
            pass
    if database:
        debug_out('Got a database for file: ' + filename)
        # Bear in mind that compilation_info.compiler_flags_ does NOT return a
        # python list, but a 'list-like' StringVec object
        compilation_info = GetCompilationInfoForFile( filename )
        if not compilation_info:
            debug_out('No compilation info for file: ' + filename)
            return None

        debug_out('Flags: ' + str(len(compilation_info.compiler_flags_)))
        final_flags = MakeRelativePathsInFlagsAbsolute(
            compilation_info.compiler_flags_,
            compilation_info.compiler_working_dir_ )
    else:
        relative_to = DirectoryOfThisScript()
        final_flags = MakeRelativePathsInFlagsAbsolute( flags, relative_to )

    return {
        'flags': final_flags,
        'do_cache': True
    }

    #debug_output.close()

