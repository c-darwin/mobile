package get_files_dir

/*
#cgo LDFLAGS: -llog -landroid
#include <android/log.h>
#include <jni.h>
#include <stdlib.h>

#define LOG_FATAL(...) __android_log_print(ANDROID_LOG_FATAL, "Go/fatal", __VA_ARGS__)
#define LOG_INFO(...) __android_log_print(ANDROID_LOG_INFO, "Go/info", __VA_ARGS__)

char* GetFilesDir(void* java_vm, void* ctx) {
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

	jclass cls = (*env)->GetObjectClass(env, ctx);
	jmethodID nJmethodID = (*env)->GetMethodID(env, cls, "getFilesdir", "()Ljava/lang/String;");
	jstring path = (jstring)(*env)->CallObjectMethod(env, ctx, nJmethodID);
	const char* filesdir = (*env)->GetStringUTFChars(env, path, NULL);

	if (attached) {
		(*vm)->DetachCurrentThread(vm);
	}

	return (char*)filesdir;
}
*/
import "C"
import (
	"github.com/c-darwin/mobile/internal/mobileinit"
	"fmt"
)

func GetFilesDir() string {
	fmt.Println("getdirr")
	ctx := mobileinit.Context{}
	return  C.GoString(C.GetFilesDir(ctx.JavaVM(), ctx.AndroidContext()))
}


