.POSIX:
.SUFFIXES: .o

CC ?= gcc
OUT := hello

SRC += main.c
OBJ := $(SRC:.c=.o)

CFLAGS += @compile_flags.txt
CFLAGS += -ffunction-sections -fdata-sections

LDFLAGS := -fwhole-program -flto
LDFLAGS += -Wl,--gc-sections -s

RM ?= rm -f

.DEFAULT_GOAL: all
.PHONY: all
all: $(OUT)

$(OUT): $(OBJ)
	$(CC) -o $@ $<

.PHONY: clean
clean:
	$(RM) $(OBJ)

.PHONY: fclean
fclean: clean
	$(RM) -r $(OUT)

.PHONY: re
.NOTPARALLEL: re
re: fclean all
