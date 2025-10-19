# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: aulicna <aulicna@student.42prague.com>     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/01/07 13:51:37 by aulicna           #+#    #+#              #
#    Updated: 2025/10/19 12:39:18 by aulicna          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

CC     = cc
CFLAGS = -Wall -Wextra -Werror
RM     = rm -f

SRC1 = Colleen.c
OBJ1 = Colleen.o
NAME1 = Colleen
COLLEEN_OUTPUT = tmp_Colleen

SRC2 = Grace.c
OBJ2 = Grace.o
NAME2 = Grace
GRACE_OUTPUT = Grace_kid.c

SRC3 = Sully.c
OBJ3 = Sully.o
NAME3 = Sully
SULLY_OUTPUT = Sully_*

all: $(NAME1) $(NAME2) $(NAME3)

# Colleen
$(NAME1): $(OBJ1)
	$(CC) $(CFLAGS) -o $(NAME1) $(OBJ1)

$(OBJ1): $(SRC1)
	$(CC) $(CFLAGS) -c $(SRC1) -o $(OBJ1)

# Grace
$(NAME2): $(OBJ2)
	$(CC) $(CFLAGS) -o $(NAME2) $(OBJ2)

$(OBJ2): $(SRC2)
	$(CC) $(CFLAGS) -c $(SRC2) -o $(OBJ2)

# Sully
$(NAME3): $(OBJ3)
	$(CC) $(CFLAGS) -o $(NAME3) $(OBJ3)

$(OBJ3): $(SRC3)
	$(CC) $(CFLAGS) -c $(SRC3) -o $(OBJ3)
	
clean:
	$(RM) $(OBJ1) $(OBJ2) $(OBJ3)

fclean: clean
	$(RM) $(NAME1) $(NAME2) $(NAME3) $(COLLEEN_OUTPUT) $(GRACE_OUTPUT) $(SULLY_OUTPUT)

re: fclean all

.PHONY: all clean fclean re