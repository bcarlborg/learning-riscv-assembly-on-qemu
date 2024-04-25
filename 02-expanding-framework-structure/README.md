# 03: Developing a framework for development
As we built up to printing out hello-world in our previous directory, our single file entry.s was getting pretty unwieldy! In this sub-directory, we make some updates to our project's structure to make things easier to follow. The end result of running this program is still the same as it was in the previous sub-directory: we print "hello world".

To go into a tad more detail, in this sub-directory, we make the following changes:
- we break up the code in the entry.s file into many assembly files in a new `framework/` directory.
- we setup the code in framework such that it initializes our system, then jumps to the non-framework code in `main.s`.
- `main.s` should have two functions defined in it: `setup` and `loop`.
    - `setup` will be called once after the basic system initialization is done
    - `loop` will be called over and over again after that
- We make some updates to our `Makefile` to support this new directory structure
