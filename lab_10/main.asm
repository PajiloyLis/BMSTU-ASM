bits 64

%include "gtk.inc"

global main

extern printf

extern bisection
extern find_func_root

section .bss
    window:     resq 1
    layout:     resq 1

    entry_x0: resq 1
    entry_x1: resq 1
    entry_iter: resq 1

    label_x0: resq 1
    label_x1: resq 1
    label_iter: resq 1

    label_info: resq 1

    button: resq 1
    ; reset_button: resq 1
    dialog: resq 1

    x_0: resq 1
    x_1: resq 1
    iter: resq 1


section .rodata
    signal:
        .destroy:   db  "destroy", 0
        .clicked:   db "clicked", 0
        ; .reset_clicked: db "reset_clicked", 0
        .value_changed:   db "value_changed", 0
    title:      db  "Лаб 10", 0
    text_label_info:      db  "sin(x^2-5)", 0
    text_label_x0: db "x_0: ", 0
    text_label_x1: db "x_1: ", 0
    text_label_iter: db "iter: ", 0
    default_text_x_0_label: db "1", 0
    default_text_x_1_label: db "1,5", 0
    default_text_iter_label: db "1000", 0
    ; zero_label: db "0", 0
    button_label: db "Вычислить корень", 0
    reset_button_label: db "Сброс в 0", 0
    success_message: db "Результат: %.5f", 0

section .data
    result: dq 0
    entry_x0_value: dq 0
    entry_x1_value: dq 0


section .text
    destroy_window:
        jmp gtk_main_quit

    button_clicked:
        mov rdi, [rel entry_x0]
        call gtk_entry_get_text

        mov rdi, rax
        xor rsi, rsi
        call strtod
        movsd [rel x_0], xmm0

        mov rdi, [rel entry_x1]
        call gtk_entry_get_text

        mov rdi, rax
        xor rsi, rsi
        call strtod
        movsd [rel x_1], xmm0

        mov rdi, [rel entry_iter]
        call gtk_entry_get_text

        mov rdi, rax
        xor rsi, rsi
        call strtod
        movsd [rel iter], xmm0

        movsd xmm2, [rel iter]      ; max_iter
        movq rax, xmm2
        push rax
        movsd xmm1, [rel x_1]       ; x1
        movq rax, xmm1
        push rax
        movsd xmm0, [rel x_0]       ; x0
        movq rax, xmm0
        push rax
        call bisection
        add rsp, 24
        mov [rel result], rax
        call show_result_dialog
        ret

    ; reset_button_clicked:
    ;     mov rdi, [ rel entry_x0 ]
    ;     mov rsi, zero_label
    ;     call gtk_entry_set_text

    ;     mov rdi, [ rel entry_x1 ]
    ;     mov rsi, zero_label
    ;     call gtk_entry_set_text
        
    ;     mov rdi, [ rel entry_iter ]
    ;     mov rsi, zero_label
    ;     call gtk_entry_set_text
        
    ;     ret

    show_result_dialog:
        mov rdi, 0
        mov rsi, 0
        mov rdx, 0
        mov rcx, 1
        mov r8, 0
        call gtk_message_dialog_new
        mov rbx, rax

        mov rdi, rbx
        mov rsi, success_message
        movsd xmm0, [rel result]
        call gtk_message_dialog_format_secondary_text

        mov rdi, rbx
        call gtk_window_present

        mov rdi, rbx
        call gtk_dialog_run
        mov rdi, rbx
        call gtk_widget_destroy
        ret

    main:
        push rbp
        mov rbp, rsp
        xor rdi, rdi
        xor rsi, rsi
        call gtk_init

        xor rdi, rdi
        call gtk_window_new
        mov qword [ rel window ], rax

        mov rdi, qword [ rel window ]
        mov rsi, title
        call gtk_window_set_title

        mov rdi, qword [ rel window ]
        mov rsi, GTK_WIN_WIDTH
        mov rdx, GTK_WIN_HEIGHT
        call gtk_window_set_default_size

        mov rdi, qword [ rel window ]
        mov rsi, GTK_WIN_POS_CENTER
        call gtk_window_set_position

        ;---------------------−
        xor rdi, rdi
        xor rsi, rsi
        call gtk_layout_new
        mov qword [ rel layout ], rax

        mov rsi, qword [ rel layout ]
        mov rdi, qword [ rel window ]
        call gtk_container_add


        ; label entry_info
        call gtk_label_new
        mov qword [rel label_info], rax

        mov rdi, qword[rel label_info]
        mov rsi, text_label_info
        call gtk_label_set_text

        mov rdi, qword [ rel layout ]
        mov rsi, qword [ rel label_info ]
        mov rdx, 350
        mov rcx, 10
        call gtk_layout_put
        ; label entry_info

        ; label entry_x0
        call gtk_label_new
        mov qword [rel label_x0], rax

        mov rdi, qword[ rel label_x0 ]
        mov rsi, text_label_x0
        call gtk_label_set_text

        mov rdi, qword [ rel layout ]
        mov rsi, qword [ rel label_x0 ]
        mov rdx, 100
        mov rcx, 50
        call gtk_layout_put
        ; label entry_x0

        ; label entry_x1
        call gtk_label_new
        mov qword [rel label_x1], rax

        mov rdi, qword[rel label_x1]
        mov rsi, text_label_x1
        call gtk_label_set_text


        mov rdi, qword [ rel layout ]
        mov rsi, qword [ rel label_x1 ]
        mov rdx, 100
        mov rcx, 90
        call gtk_layout_put
        ; label entry_x1

        ; label entry_iter
        call gtk_label_new
        mov qword [rel label_iter], rax

        mov rdi, qword[rel label_iter]
        mov rsi, text_label_iter
        call gtk_label_set_text

        mov rdi, qword [ rel layout ]
        mov rsi, qword [ rel label_iter ]
        mov rdx, 100
        mov rcx, 130
        call gtk_layout_put
        ; label entry_iter

        ;  entry_x0
        xor rdi, rdi
        mov rsi, 5
        call gtk_entry_new
        mov qword [ rel entry_x0 ], rax

        mov rdi, qword [ rel layout ]
        mov rsi, qword [ rel entry_x0 ]
        mov rdx, 300
        mov rcx, 50
        call gtk_layout_put
        
        
        ;  entry_x0

        ;  entry_x1
        xor rdi, rdi
        mov rsi, 5
        call gtk_entry_new
        mov qword [ rel  entry_x1 ], rax

        mov rdi, qword [ rel layout ]
        mov rsi, qword [ rel entry_x1 ]
        mov rdx, 300
        mov rcx, 90
        call gtk_layout_put
        ;  entry_x1

        ;  entry_x2
        xor rdi, rdi
        mov rsi, 5
        call gtk_entry_new
        mov qword [ rel  entry_iter ], rax

        mov rdi, qword [ rel layout ]
        mov rsi, qword [ rel entry_iter ]
        mov rdx, 300
        mov rcx, 130
        call gtk_layout_put
        ;  entry_x2

        mov rdi, qword[ rel entry_x0 ]
        mov rsi, default_text_x_0_label
        call gtk_entry_set_text

        mov rdi, qword[ rel entry_x1 ]
        mov rsi, default_text_x_1_label
        call gtk_entry_set_text

        mov rdi, qword[ rel entry_iter ]
        mov rsi, default_text_iter_label
        call gtk_entry_set_text

        ; reset button begin
        ; mov rdi, reset_button_label
        ; call gtk_button_new_with_label
        ; mov qword [rel reset_button], rax

        ; mov rdi, qword [rel reset_button]
        ; mov rsi, signal.clicked
        ; mov rdx, reset_button_clicked
        ; xor rcx, rcx
        ; xor r8d, r8d
        ; xor r9d, r9d
        ; call g_signal_connect_data

        ; mov rdi, qword [ rel layout ]
        ; mov rsi, qword [ rel reset_button ]
        ; mov rdx, 400
        ; mov rcx, 400
        ; call gtk_layout_put
        ; ----------------------------------
        ; calc button begin
        mov rdi, button_label
        call gtk_button_new_with_label
        mov qword [rel button], rax

        mov rdi, qword [rel button]
        mov rsi, signal.clicked
        mov rdx, button_clicked
        xor rcx, rcx
        xor r8d, r8d
        xor r9d, r9d
        call g_signal_connect_data

        mov rdi, qword [ rel layout ]
        mov rsi, qword [ rel button ]
        mov rdx, 200
        mov rcx, 400
        call gtk_layout_put



        ; calc button end

        ; --------------------------------------−

        mov rdi, qword [ rel window ]
        mov rsi, signal.destroy
        mov rdx, destroy_window
        xor rcx, rcx
        xor r8d, r8d
        xor r9d, r9d
        call g_signal_connect_data

        mov rdi, qword [ rel window ]
        call gtk_widget_show_all
        call gtk_main
        call exit