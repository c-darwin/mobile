package open_browser

/*
#cgo LDFLAGS: -llog -landroid
#include <android/log.h>
#include <jni.h>
#include <stdlib.h>

#define LOG_FATAL(...) __android_log_print(ANDROID_LOG_FATAL, "Go/fatal", __VA_ARGS__)
#define LOG_INFO(...) __android_log_print(ANDROID_LOG_INFO, "Go/info", __VA_ARGS__)

void OpenBrowser(void* java_vm, void* ctx, char* url, char* text) {
	JavaVM* vm = (JavaVM*)(java_vm);
	JNIEnv* env;
	int err;
	int attached = 0;

	err = (*vm)->GetEnv(vm, (void**)&env, JNI_VERSION_1_6);
	if (err != JNI_OK) {
		if (err == JNI_EDETACHED) {
			if ((*vm)->AttachCurrentThread(vm, &env, 0) != 0) {
				LOG_FATAL("cannot attach JVM");
			}
			attached = 1;
		} else {
			LOG_FATAL("GetEnv unexpected error: %d", err);
		}
	}
		
	jstring javaUrl = (jstring)(*env)->NewStringUTF(env, (const char *)url);
		
	jclass cls = (*env)->GetObjectClass(env, ctx);
	jmethodID nJmethodID = (*env)->GetMethodID(env, cls, "openBrowser", "(Ljava/lang/String;Ljava/lang/String;)V");
	(jstring)(*env)->CallObjectMethod(env, ctx, nJmethodID, javaUrl);

	if (attached) {
		(*vm)->DetachCurrentThread(vm);
	}
}
*/
import "C"
import (
	"github.com/c-darwin/mobile/internal/mobileinit"
)

func OpenBrowser(url string) {
	ctx := mobileinit.Context{}
	C.OpenBrowser(ctx.JavaVM(), ctx.AndroidContext(), C.CString(url))
}


