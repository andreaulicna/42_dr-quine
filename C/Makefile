# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: aulicna <aulicna@student.42prague.com>     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/01/07 13:51:37 by aulicna           #+#    #+#              #
#    Updated: 2025/10/16 23:37:54 by aulicna          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME = Colleen

SRC = Colleen.c

OBJ = $(SRC:.c=.o)

CFLAGS = -Wall -Wextra -Werror

CC = cc

RM = rm -f

all: $(NAME)
	@echo "$(NAME) executable ready ✅"

$(NAME): $(OBJ)
	$(CC) $(CFLAGS) -o $@ $^

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	$(RM) $(OBJ)

fclean: clean
	$(RM) $(NAME)

re: fclean all

.PHONY: all clean fclean re