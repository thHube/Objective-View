# Compiler flags
DEBUG_INFO=-g
CC=gcc
NS_FLAGS=-fconstant-string-class=NSConstantString -std=c99  -DGNUSTEP
GLEW_DEFS=-DGLEW_STATIC -DGLEW_BUILD
CFLAGS=-I $(NS_INCLUDE) -I include $(DEBUG_INFO) $(NS_FLAGS) $(GLEW_DEFS)
LDFLAGS=
LIBS= -L $(NS_LIBRARY) -lobjc -lgnustep-base -lgnustep-gui -lfreeglut -lopengl32 -lglu32 $(DEBUG_INFO)

# Objective-C source code and objects
OBJC_NAMES=	Main Renderer Mesh+Builder Mesh ObjParser AppController Shader
OBJC_SOURCE_BARE=$(addsuffix .m, $(OBJC_NAMES))
OBJC_SOURCES=$(addprefix src/, $(OBJC_SOURCE_BARE))

OBJC_OBJECT_BARE=$(addsuffix -objc.o, $(OBJC_NAMES))
OBJC_OBJECTS=$(addprefix obj/, $(OBJC_OBJECT_BARE))

# GL extension wrangler build
GLEW_OBJ=obj/glew.o
GLEW_FLAGS= $(GLEW_DEFS) -O2 -Wall -W -I include

# Executable name
EXEC=ObjectiveView


# Makefile rules 
all: $(OBJC_SOURCES) $(EXEC)

$(EXEC): $(OBJC_OBJECTS) $(GLEW_OBJ)
	$(CC) $(LDFLAGS) $(OBJC_OBJECTS) $(GLEW_OBJ) $(LIBS) -o bin/$@

obj/%-objc.o: src/%.m
	$(CC) $(CFLAGS) $< -o $@ -c

$(GLEW_OBJ): src/glew.c
	$(CC) $(GLEW_FLAGS) -o $(GLEW_OBJ) -c $<

clean:
	rm obj/*
	rm bin/*