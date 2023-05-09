RAGEL_RUST = ragel-rust
RUSTC = rustc
RUST_RAGEL_SOURCES = $(wildcard *.rs.rl)
EXECUTABLES = $(RUST_RAGEL_SOURCES:.rs.rl=_rust)
INTERMEDIATES = $(RUST_RAGEL_SOURCES:.rs.rl=.rs)
KEEP_INTERMEDIATES ?= 0

ifneq ($(KEEP_INTERMEDIATES),0)
    $(info [BUILD] Keeping intermediate sources)
    .PRECIOUS: %.rs
else
    $(info [BUILD] Not keeping intermediate sources)
    .INTERMEDIATE: %.rs
endif

$(info [BUILD] Executables: $(EXECUTABLES))

all: $(EXECUTABLES)

clean:
	@echo [CLEAN]
	find . -name '*.o' | xargs -n 1 rm -f
	find . -name '*.ri' | xargs -n 1 rm -f
	rm -f $(EXECUTABLES)
	rm -f $(INTERMEDIATES)

%_rust: %.rs
	@echo [RUSTC] $@
	@$(RUSTC) $< -o $@

%.rs: %.rs.rl
	@echo [RAGEL] $@
	@$(RAGEL_RUST) $< -o $*.rs
