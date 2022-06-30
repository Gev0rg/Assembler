TARGET = lab5

help:
		@echo Available goals:
		@echo ' run   - create and run '
		@echo ' debug - create and debug  '
		@echo ' help  - show this message '
$(TARGET): $(TARGET).asm	
		nasm -f elf64 -l $(TARGET).lst $(TARGET).asm
		ld -o $(TARGET) $(TARGET).o 
run: $(TARGET)
		nasm -f elf64 -l $(TARGET).lst $(TARGET).asm
		ld -o $(TARGET) $(TARGET).o
		./$(TARGET)
debug: $(TARGET)
		edb --run $(TARGET)

cpp:
	nasm -f elf64 $(TARGET).asm -l $(TARGET).lst
	g++ main.cpp -c
	g++ main.o $(TARGET).o
	./a.out
