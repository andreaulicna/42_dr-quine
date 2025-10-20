# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: aulicna <aulicna@student.42prague.com>     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/01/07 13:51:37 by aulicna           #+#    #+#              #
#    Updated: 2025/10/20 23:37:33 by aulicna          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

ASM      = nasm
ASMFLAGS = -f elf64
CC       = gcc
LDFLAGS  = -no-pie
RM       = rm -f

SRCS = Colleen.s Grace.s
OBJS = $(SRCS:.s=.o)
BINS = Colleen Grace

all: $(BINS)

Colleen: Colleen.o
	$(CC) $(LDFLAGS) $^ -o $@

Grace: Grace.o
	$(CC) $(LDFLAGS) $^ -o $@

%.o: %.s
	$(ASM) $(ASMFLAGS) $< -o $@

clean:
	$(RM) $(OBJS)

fclean: clean
	$(RM) $(BINS) tmp_Colleen Grace_kid.s

re: fclean all

.PHONY: all clean fclean re