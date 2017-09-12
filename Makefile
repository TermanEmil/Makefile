# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: eterman <marvin@42.fr>                     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2016/10/22 12:15:47 by eterman           #+#    #+#              #
#    Updated: 2016/12/27 20:02:30 by eterman          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# This exact Makefile works only with if there is a folder named includes (where
# are all header files) and src folder (with all .c files).
# The makefile will search for all headers and .c files recursively
#
# The following Makefile will recompile only the modified files from src and
# include all headers -r from includes
#
# Use make -s (quiet mode).
#
# If you want to compile without flags, change $(COMPILE):
#	$(CC) $(INCLUDES) $(FLAGS).
#
# How it works ?
#	1) SRC finds all c files in 'src' (with full path).
#	2) SRC_FILES finds the name of each c file (without path).
#	3) INCLUDES includes all headers form all directories form the current
#		project includes and libft's includes.
#	4) Creates a rule for each '.o' file (here's the trick with compile
#		the modified only).

# Some colors
GREEN 		=	'\033[0;32m'
RED			=	'\033[0;31m'
CYAN 		=	'\033[0;36m'
MAGENTA		=	'\033[35m'
YELLOW		=	'\033[33m'
EOC			=	'\033[0m'

NAME		=	executable
FLAGS		=	-Wall -Wextra -Werror
CC			=	gcc

# Finds all directories from include
INC_DIRS	=	$(shell find includes -type d)

# Adds -I to each element frm above
INC_PROJ	=	$(foreach d, $(INC_DIRS), -I $d)

INCLUDES	=	$(INC_PROJ)

# This is the compile command used for each .c file
COMPILE		=	$(CC) $(FLAGS) $(INCLUDES)

# Find all '.c' files in 'src' recursively

SRC			=	$(shell find src -name '*.c')

# This will contain an array of all SRC files without path.
# Ex: src/dir1/file.c --> file.c
# This functionality is used for OBJS

SRC_FILES	=	$(notdir $(SRC))

# Name of the directory with objects
OBJDIR		=	objs

# Makes an array of .o file names from .c files
OBJS_NAMES	=	$(SRC_FILES:.c=.o)

OBJS		=	$(addprefix $(OBJDIR)/,$(OBJS_NAMES))

# The main rule
all: $(NAME)

# Quietly creates an $(OBJDIR) directory
$(OBJDIR):
	mkdir -p $(OBJDIR)

# A makefile function used to compile the the given $(1) (.c file) into $(2) (
# .o object). If it's success, prints a success message.
define COMPILE_FILE
	@$(COMPILE) -c $(1) -o $(2)
	@(if [ $$? -eq 0 ] ; \
		then echo $(GREEN)[OK]$(EOC) $(MAGENTA)$(1)$(EOC) ; fi)
endef

# These are rules for all .c files from src.
# This is a dirty way, but a working one...
# Bassically, a rule is: file.o: file.c
# So:
# file.o: file.c						-->
# $(OBJDIR)/file.o: file.c				-->
# $(OBJDIR)/%.o: %.c (where the percent symbols means that the name of the file
# has to match, that is: file == file)	-->
# $(OBJDIR)/%.o: src/%.c I keep my .c file in src
# $(OBJDIR)/%.o: src/*/%.c the star makes it look in all directories from src
# $(OBJDIR)/%.o: src/*/*/%.c looks in directories one branch deeper
# etc

$(OBJDIR)/%.o: src/%.c
	$(call COMPILE_FILE,$<,$@)

$(OBJDIR)/%.o: src/*/%.c
	$(call COMPILE_FILE,$<,$@)

$(OBJDIR)/%.o: src/*/*/%.c
	$(call COMPILE_FILE,$<,$@)

$(OBJDIR)/%.o: src/*/*/*/%.c
	$(call COMPILE_FILE,$<,$@)

$(OBJDIR)/%.o: src/*/*/*/*/%.c
	$(call COMPILE_FILE,$<,$@)

$(OBJDIR)/%.o: src/*/*/*/*/*/%.c
	$(call COMPILE_FILE,$<,$@)

$(OBJDIR)/%.o: src/*/*/*/*/*/%.c
	$(call COMPILE_FILE,$<,$@)


# The main rule
# First, it makes sure that $(OBJDIR) exists.
# Then it calls a rule for each .o file (the bunch of rules described above) 
# The last line of this rule, compiles the program. It can be changed to compile
# a library.
$(NAME): $(OBJDIR) $(OBJS)
	@echo "\n"
	@echo $(CYAN)"Compiling program"$(EOC)
	@$(COMPILE) $(OBJS) -o $(NAME)

# Removes the objects
clean:
	rm -f $(OBJS)
	rm -rf $(OBJDIR)
 
fclean: clean
	rm -f $(NAME)

# Recompiles everything
re: fclean all	

run:
	./$(NAME)

# This rule compiles and runs the program.
sure: all run
