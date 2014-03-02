# Compiler flags
DEBUG_INFO=-g
CC=gcc
CFLAGS=-I $(NS_INCLUDE) -fconstant-string-class=NSConstantString -std=c99 $(DEBUG_INFO) -DGNUSTEP
LDFLAGS=
LIBS= -L $(NS_LIBRARY) -lobjc -lgnustep-base -lgnustep-gui -lfreeglut -lopengl32 -lglu32 $(DEBUG_INFO)


# C source code 
C_NAMES= 
C_SOURCE_BARE=$(addsuffix .c, $(C_NAMES))
C_SOURCES=$(addprefix src/, $(C_SOURCE_BARE))

C_OBJECT_BARE=$(addsuffix -c.o, $(C_NAMES))
C_OBJECTS=$(addprefix obj/, $(C_OBJECT_BARE))


# Objective-C source code and objects
OBJC_NAMES=	Main Renderer Mesh+Builder Mesh ObjParser AppController
OBJC_SOURCE_BARE=$(addsuffix .m, $(OBJC_NAMES))
OBJC_SOURCES=$(addprefix src/, $(OBJC_SOURCE_BARE))

OBJC_OBJECT_BARE=$(addsuffix -objc.o, $(OBJC_NAMES))
OBJC_OBJECTS=$(addprefix obj/, $(OBJC_OBJECT_BARE))


# Executable name
EXEC=objc-view


# Makefile rules 
all: $(C_SOURCES) $(OBJC_SOURCES) $(EXEC)

$(EXEC): $(C_OBJECTS) $(OBJC_OBJECTS)
	$(CC) $(LDFLAGS) $(C_OBJECTS) $(OBJC_OBJECTS) $(LIBS) -o bin/$@

obj/%-c.o: src/%.c
	$(CC) $(CFLAGS) $< -o $@ -c

obj/%-objc.o: src/%.m
	$(CC) $(CFLAGS) $< -o $@ -c

clean:
	rm obj/*
	rm bin/*