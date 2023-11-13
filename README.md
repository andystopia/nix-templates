# Andy's Nix Templates

A repository containing the templates that 
I would like to use for various projects.


## fenix-rust

source: me :D


Best described by the description, 
a starting point for compiling Rust, and 
creating Docker images automatically.

> Create a development environment for a basic Rust program.
> - Create a devshell for development (with lld for linking)
> - Create builds for the current system.
> - Create linux MUSL-libc builds
> - Cross compile MUSL builds for docker OCI

## typst-math

Creates a typst environment, which ships Typst, a font 
that I like to use, and a _mostly_ configured vscodium,
which just needs to have nvarner's typst lsp not output
to pdf on save (I couldn't figure out how to declare
this without home manager).

 - Includes a template
 - Have a fully configured typst env.

Simply instantiate the template and then call `codium .`, 
and click the preview button on the right, and you're 
off to the races. 

The environment includes just as well, for the justfile, 
which let's you convert images. I don't include imagemagick
in the flake, so you'll need to have that installed prior

The justfile lets you convert mac screenshots to have
the same background color as the template (could they 
be transparent? - I'll have to investigate later).


LIMITATION: cannot use custom font with nvarner-lsp


TODO: include imagemagick in a devshell.

