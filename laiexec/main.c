
#include <stdio.h>
#include <stdlib.h>

#include <lai/core.h>

void laihost_handle_amldebug(lai_object_t *object) {
    if(object->type == LAI_STRING)
        printf("amldebug: (string \"%s\")\n", object->string);
    else if(object->type == LAI_INTEGER)
        printf("amldebug: (integer %lu)\n", object->integer);
    else
        printf("amldebug: (unknown)\n");
}

int main(int argc, char **argv) {
    lai_state_t state;

    // Quick and dirty way to read the entire input file.
    FILE *f = fopen(argv[1], "rb");
    fseek(f, 0, SEEK_END);
    long size = ftell(f);
    fseek(f, 0, SEEK_SET);

    void *buffer = malloc(size + 1);
    fread(buffer, size, 1, f);
    fclose(f);

    // Load the AML table and initialize the namespace.
    acpi_aml_t *table = buffer;
    lai_init_state(&state);
    lai_populate(NULL, table->data, table->header.length - sizeof(acpi_header_t), &state);
    lai_finalize_state(&state);

    printf("ACPI namespace created, total of %zd predefined objects.\n", lai_ns_size);

    // Execute the _SB._INI control method.
    lai_nsnode_t *handle = acpins_resolve("\\._SB_._INI");
    if(!handle) {
        fprintf(stderr, "could not find _SB_._INI method\n");
        abort();
    }

    lai_init_state(&state);
    printf("Executing _SB_._INI\n");
    lai_exec_method(handle, &state);
    printf("Execution finished successfully\n");
    lai_finalize_state(&state);
}

