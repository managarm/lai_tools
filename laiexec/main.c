
#include <ctype.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <lai/core.h>

static const char *path_arg;
static bool enable_trace = false;
static bool load_full_ns = false;

static void *read_entire_file(const char *path) {
    // Quick and dirty way to read the entire input file.
    FILE *f = fopen(path, "rb");
    if(!f)
        return NULL;
    fseek(f, 0, SEEK_END);
    long size = ftell(f);
    fseek(f, 0, SEEK_SET);

    void *buffer = malloc(size + 1);
    fread(buffer, size, 1, f);
    fclose(f);
    return buffer;
}

void *laihost_scan(const char *name, size_t index) {
    char *path;
    void *buffer = NULL;

    // First, try to find an un-indexed table.
    if(index <= 0) {
        if(asprintf(&path, "%s/%s.dat", path_arg, name) < 0) {
            fprintf(stderr, "asprintf() failed");
            abort();
        }
        for(size_t i = 0; path[i]; i++)
            path[i] = tolower(path[i]);
        printf("laiexec: looking for %s\n", path);

        buffer = read_entire_file(path);
        free(path);
    }

    // If that fails, find an indexed table.
    if(index >= 0 && !buffer) {
        if(asprintf(&path, "%s/%s%zu.dat", path_arg, name, index) < 0) {
            fprintf(stderr, "asprintf() failed");
            abort();
        }
        for(size_t i = 0; path[i]; i++)
            path[i] = tolower(path[i]);
        printf("laiexec: looking for %s\n", path);

        buffer = read_entire_file(path);
        free(path);
    }

    return buffer;
}

static void print_lai_object(lai_variable_t *object) {
    if(object->type == LAI_STRING)
        printf("(string \"%s\")", object->string_ptr->content);
    else if(object->type == LAI_INTEGER)
        printf("(integer %lu)", object->integer);
    else if(object->type == LAI_STRING_INDEX)
        printf("(string_index)");
    else if(object->type == LAI_BUFFER_INDEX)
        printf("(buffer_index)");
    else if(object->type == LAI_PACKAGE_INDEX)
        printf("(package_index)");
    else if(object->type == LAI_BUFFER) {
        printf("(buffer");
        for(int i = 0; i < object->buffer_ptr->size; i++) {
            printf(" 0x%02hhX", object->buffer_ptr->content[i]);
        }
        printf(")");
    }
    else if(object->type == LAI_PACKAGE) {
        printf("(package");
        for(int i = 0; i < object->pkg_ptr->size; i++) {
            printf(" ");
            print_lai_object(&object->pkg_ptr->elems[i]);
        }
        printf(")");
    }
    else if(object->type == 0)
        printf("(uninitialized)");
    else
        printf("(unknown %u)", object->type);
}

void laihost_handle_amldebug(lai_variable_t *object) {
    printf("amldebug: ");
    print_lai_object(object);
    printf("\n");
}

int main(int argc, char **argv) {
    lai_state_t state;

    // laiexec is used in tests and might crash in those.
    // Set output streams to unbuffered so that we can still read error messages.
    setvbuf(stdout, NULL, _IONBF, 0);
    setvbuf(stderr, NULL, _IONBF, 0);

    argv += 1; // Skip the program name.
    while(*argv) {
        if((*argv)[0] != '-')
            break;
        if(!strcmp(*argv, "--trace")) {
            enable_trace = true;
            argv++;
        }else if(!strcmp(*argv, "--fullns")) {
            load_full_ns = true;
            argv++;
        }else{
            printf("unexpected argument %s\n", *argv);
            exit(2);
        }
    }

    // Recompute argc.
    for(argc = 0; argv[argc]; argc++)
        ;
    if(!argc) {
        printf("expected exactly one positional argument\n");
        exit(2);
    }
    path_arg = argv[0];

    // Load the AML table and initialize the namespace.
    if(enable_trace)
        lai_enable_tracing(1);

    if(!load_full_ns) {
        void *buffer = read_entire_file(path_arg);
        if(!buffer) {
            printf("could not open input file\n");
            exit(1);
        }

        lai_nsnode_t *root_node = lai_create_root();

        struct lai_aml_segment amls;
        memset(&amls, 0, sizeof(struct lai_aml_segment));
        amls.table = buffer;

        lai_init_state(&state);
        if (lai_populate(root_node, &amls, &state)) {
            printf("Execution failure in table-level code");
            exit(1);
        }
        lai_finalize_state(&state);
        printf("ACPI namespace created, total of %zd predefined objects.\n",
                lai_current_instance()->ns_size);

        // Execute the _SB._INI control method.
        lai_nsnode_t *handle = lai_resolve_path(NULL, "\\_SB_._INI");
        if(!handle) {
            fprintf(stderr, "could not find _SB_._INI method\n");
            exit(1);
        }

        lai_init_state(&state);
        printf("Executing _SB_._INI\n");
        if (lai_eval(NULL, handle, &state)) {
            printf("Execution failure in _SB_._INI");
            exit(1);
        }
        printf("Execution finished successfully\n");
        lai_finalize_state(&state);
    }else{
        lai_create_namespace();
    }
}

