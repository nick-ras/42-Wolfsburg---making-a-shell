NAME =	minishell

CC = gcc
CFLAGS = -Wall -Werror -Wextra -g

LIBFT = libs/libft/libft.a
LIBFTDIR = libs/libft

LIBS = $(LIBFT) -lreadline -lncurses -L$(HOME)/goinfre/.brew/opt/readline/lib/ 
INC = -I libs/libft -I inc -I $(HOME)/goinfre/.brew/opt/readline/include/

SRC_DIR = src
OBJ_DIR = obj

SRCS =	src/main.c \
		src/clean_up.c \
		src/ft_echo.c \
		src/ft_exit.c \
		src/ft_env.c \
		src/init.c \
		src/error.c \
		src/ft_split_lexer.c \
		src/tests.c \
		src/make_env_arr.c \
		src/check_if_cmd.c \
		src/ft_message.c \
		src/categorize.c \
		src/parser.c \
		src/parser_utils.c \
		src/executer.c \
		src/ft_export.c \
		src/ft_unset.c \
		src/expand_variables.c \
		src/ft_cd.c \

OBJS = $(patsubst $(SRC_DIR)/%.c,$(OBJ_DIR)/%.o,$(SRCS))

all: $(NAME)

$(NAME): $(OBJS)
	@echo "Producing Objects: $(OBJS)"
	@make -C $(LIBFTDIR) bonus
	@$(CC) $(CFLAGS) -o $(NAME) $(OBJS) $(LIBS)

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(dir $@)
	@$(CC) $(CFLAGS) -c $< -o $@ $(INC)
	@echo "Shell building on Process $<"

re:	fclean all

l: all
	leaks --atExit -- ./$(NAME)

vg: re
	valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes ./$(NAME)

clean:
	@make -C $(LIBFTDIR) clean
	@rm -f $(OBJ_DIR)/*.o

fclean:	clean
	@make -C $(LIBFTDIR) fclean
	@rm -f $(NAME)

norm:
	norminette ./src/

.PHONY: all clean fclean re norm leaks
.NOTPARALLEL: all clean fclean re norm leaks vg