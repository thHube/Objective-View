#import "Shader.h"

#include <GL/glew.h>
#include <stdlib.h>
#include <string.h>

void printShaderInfoLog(GLuint obj)
{
    int infologLength = 0;
    int charsWritten  = 0;
    char *infoLog;

    glGetShaderiv(obj, GL_INFO_LOG_LENGTH, &infologLength);

    if (infologLength > 0) {
        infoLog = (char *)malloc(infologLength);
        glGetShaderInfoLog(obj, infologLength, &charsWritten, infoLog);
        NSLog([NSString stringWithFormat:@"%s", infoLog]);
        free(infoLog);
    }
}

void printProgramInfoLog(GLuint obj)
{
    int infologLength = 0;
    int charsWritten  = 0;
    char *infoLog;

    glGetProgramiv(obj, GL_INFO_LOG_LENGTH,&infologLength);

    if (infologLength > 0) {
        infoLog = (char *)malloc(infologLength);
        glGetProgramInfoLog(obj, infologLength, &charsWritten, infoLog);
        NSLog([NSString stringWithFormat:@"%s", infoLog]);
        free(infoLog);
    }
}

@implementation Shader

-(id)initWithFilename:(NSString*)vsFilename pixelShader:(NSString*)psFilename
{
    self = [super init];
    if (self) {
        NSString* vsSource = [NSString stringWithContentsOfFile:vsFilename];
        NSString* psSource = [NSString stringWithContentsOfFile:psFilename];
        const char* vsCString = [vsSource UTF8String];
        const char* psCString = [psSource UTF8String];

        _glVertex = glCreateShader(GL_VERTEX_SHADER);
        _glPixel = glCreateShader(GL_FRAGMENT_SHADER);

        glShaderSource(_glVertex, 1, &vsCString, NULL);
        glShaderSource(_glPixel, 1, &psCString, NULL);

        glCompileShader(_glVertex);
        printShaderInfoLog(_glVertex);
        glCompileShader(_glPixel);
        printShaderInfoLog(_glPixel);

        _glProgram = glCreateProgram();
        glAttachShader(_glProgram, _glVertex);
        glAttachShader(_glProgram, _glPixel);
        glLinkProgram(_glProgram);
        printProgramInfoLog(_glProgram);

        RELEASE(vsSource);
        RELEASE(psSource);
    }
    return self;
}

-(void)bind
{
    glUseProgram(_glProgram);
}


-(void)dealloc
{
    [super dealloc];
    glDetachShader(_glProgram, _glVertex);
    glDetachShader(_glProgram, _glPixel);
    glDeleteShader(_glVertex);
    glDeleteShader(_glPixel);
    glDeleteProgram(_glProgram);
}

@end

