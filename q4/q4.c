#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<dlfcn.h>

int main()
{
    char op[10];
    int a = 0;
    int b = 0;

    while((scanf("%5s %d %d", op, &a, &b))==3)   //basically only keep reading input till user keeps giving three input parameters
    {
        char libname[20];
        strcpy(libname, "./lib");
        strcat(libname, op);
        strcat(libname, ".so");


        void *f = dlopen(libname, RTLD_LAZY);
        if(f == NULL)
        {
            printf("%s\n", dlerror());
            continue;
        }
        
        int (*func)(int, int);
        dlerror();
        func = (int (*)(int, int))dlsym(f, op);


        if(func == NULL)    //function isnt in the library
        {
            printf("%s\n", dlerror());
            dlclose(f);
            continue;
        }


        //now we have function loaded so well call it
        int ans = func(a, b);

        printf("%d\n", ans);
        dlclose(f);
    }
    return 0;
}
