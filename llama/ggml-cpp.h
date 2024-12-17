/**
 * llama.cpp - commit 081b29bd2a3d91e7772e3910ce223dd63b8d7d26 - do not edit this file
 *
 * MIT License
 *
 * Copyright (c) 2023-2024 The ggml authors
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#pragma once

#ifndef __cplusplus
#error "This header is for C++ only"
#endif

#include "ggml.h"
#include "ggml-alloc.h"
#include "ggml-backend.h"
#include <memory>

// Smart pointers for ggml types

// ggml

struct ggml_context_deleter { void operator()(ggml_context * ctx) { ggml_free(ctx); } };
struct gguf_context_deleter { void operator()(gguf_context * ctx) { gguf_free(ctx); } };

typedef std::unique_ptr<ggml_context, ggml_context_deleter> ggml_context_ptr;
typedef std::unique_ptr<gguf_context, gguf_context_deleter> gguf_context_ptr;

// ggml-alloc

struct ggml_gallocr_deleter { void operator()(ggml_gallocr_t galloc) { ggml_gallocr_free(galloc); } };

typedef std::unique_ptr<ggml_gallocr_t, ggml_gallocr_deleter> ggml_gallocr_ptr;

// ggml-backend

struct ggml_backend_deleter        { void operator()(ggml_backend_t backend)       { ggml_backend_free(backend); } };
struct ggml_backend_buffer_deleter { void operator()(ggml_backend_buffer_t buffer) { ggml_backend_buffer_free(buffer); } };
struct ggml_backend_event_deleter  { void operator()(ggml_backend_event_t event)   { ggml_backend_event_free(event); } };
struct ggml_backend_sched_deleter  { void operator()(ggml_backend_sched_t sched)   { ggml_backend_sched_free(sched); } };

typedef std::unique_ptr<ggml_backend,        ggml_backend_deleter>        ggml_backend_ptr;
typedef std::unique_ptr<ggml_backend_buffer, ggml_backend_buffer_deleter> ggml_backend_buffer_ptr;
typedef std::unique_ptr<ggml_backend_event,  ggml_backend_event_deleter>  ggml_backend_event_ptr;
typedef std::unique_ptr<ggml_backend_sched,  ggml_backend_sched_deleter>  ggml_backend_sched_ptr;
