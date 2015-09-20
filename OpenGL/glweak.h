#import <OpenGL/CGLTypes.h>
#import <OpenGL/gl.h>
#import <OpenGL/glext.h>

#if __ANDROID__

#import <EGL/egl.h>

CGL_INLINE void CGLBufferData(GLenum target, GLsizeiptr size, const GLvoid *data, GLenum usage) {
    glBufferData(target, size, data, usage);
}

CGL_INLINE void CGLGenBuffers(GLsizei n, GLuint *buffers) {
    glGenBuffers(n,buffers);
}

CGL_INLINE void CGLDeleteBuffers(GLsizei n, const GLuint *buffers) {
    glDeleteBuffers(n, buffers);
}

CGL_INLINE void CGLBindBuffer(GLenum target, GLuint buffer) {
    glBindBuffer(target, buffer);
}

CGL_INLINE void CGLBufferSubData(GLenum target, GLintptr offset, GLsizeiptr size, const GLvoid *data) {
    glBufferSubData(target, offset, size, data);
}

CGL_INLINE void *CGLMapBuffer(GLenum target, GLenum access) {
    PFNGLMAPBUFFEROESPROC f = (PFNGLMAPBUFFEROESPROC)eglGetProcAddress("glMapBufferOES");
    return f ? f(target, access) : NULL;
}

CGL_INLINE GLboolean CGLUnmapBuffer(GLenum target) {
    PFNGLUNMAPBUFFEROESPROC f = (PFNGLUNMAPBUFFEROESPROC)eglGetProcAddress("glUnmapBufferOES");
    return f ? f(target) : GL_FALSE;
}

#else

CGL_EXPORT void CGLBufferData(GLenum target, GLsizeiptr size, const GLvoid *data, GLenum usage);
CGL_EXPORT void CGLGenBuffers(GLsizei n, GLuint *buffers);
CGL_EXPORT void CGLDeleteBuffers(GLsizei n, const GLuint *buffers);
CGL_EXPORT void CGLBindBuffer(GLenum target, GLuint buffer);
CGL_EXPORT void CGLBufferSubData(GLenum target, GLintptr offset, GLsizeiptr size, const GLvoid *data);
CGL_EXPORT void *CGLMapBuffer(GLenum target, GLenum access);
CGL_EXPORT GLboolean CGLUnmapBuffer(GLenum target);

#define glBufferData(_1, _2, _3, _4) CGLBufferData(_1, _2, _3, _4)
#define glGenBuffers(_1, _2) CGLGenBuffers(_1, _2)
#define glBindBuffer(_1, _2) CGLBindBuffer(_1, _2)
#define glBufferSubData(_1, _2, _3, _4) CGLBufferSubData(_1, _2, _3, _4)

#endif
