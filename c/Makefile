CC ?= gcc
CFLAGS += -pedantic -Wall -Wextra -O2

OUT := hello
BINDIR ?= /usr/bin

SRC += main.c
OBJ := $(SRC:.c=.o)

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

.PHONY: install
install:
	install -D hello ${BINDIR}/hello --mode 0755
