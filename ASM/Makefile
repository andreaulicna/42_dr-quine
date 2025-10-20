# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: aulicna <aulicna@student.42prague.com>     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/01/07 13:51:37 by aulicna           #+#    #+#              #
#    Updated: 2025/10/21 01:49:12 by aulicna          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

ASM      = nasm
ASMFLAGS = -f elf64
CC       = gcc
LDFLAGS  = -no-pie
RM       = rm -f

SRCS = Colleen.s Grace.s Sully.s
OBJS = $(SRCS:.s=.o)
BINS = Colleen Grace Sully

all: $(BINS)

Colleen: Colleen.o
	@echo "Linking Colleen..."
	@$(CC) $(LDFLAGS) $^ -o $@

Grace: Grace.o
	@echo "Linking Grace..."
	@$(CC) $(LDFLAGS) $^ -o $@

Sully: Sully.o
	@echo "Linking Sully..."
	@$(CC) $(LDFLAGS) $^ -o $@

%.o: %.s
	@echo "Assembling $<..."
	@$(ASM) $(ASMFLAGS) $< -o $@

clean:
	@echo "Cleaning object files..."
	@$(RM) $(OBJS)

fclean: clean
	@echo "Removing binaries and generated files..."
	@$(RM) $(BINS) tmp_Colleen Grace_kid.s Sully_*.s Sully_*

re: fclean all

.PHONY: all clean fclean re