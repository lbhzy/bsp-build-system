TARGET = app
SOURCE = hello.c
PREFIX ?= _install
BINDIR = $(PREFIX)/bin

$(TARGET): $(SOURCE)
	gcc -static $< -o $@
	gcc -nostdlib -static -I../kernel/tools/include/nolibc/ -Os -s $< -o $@-nolibc

clean:
	rm -f $(TARGET)

install: $(TARGET)
	install -d $(BINDIR)
	install -m 0755 $(TARGET) $(BINDIR)/

.PHONY: clean install
