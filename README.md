Deconvolution practicals
=========================
Implementation of various deconvolution approaches in Matlab.

## Content
Here is the content of the repository:
```
├── data [datasets]
├── exercises [exercices]
├── solutions [solution to the exercices]
├── test [testing]
└── utils [various useful functions, io, plot]
```

In each folder solutions and exercises, a test code `demo2.m` is used to generate a test image and apply deconvolution algorithms using the function deconvolve. The function `deconvolve` is used to call various deconvolution methods using a string parameter and a struct option.


## Requirement
- Matlab or octave

## Usage
- Download the code or clone the repository
```bash
git clone https://github.com/jboulanger/deconvolution-practicals.git
```

- Navigate to the exercises folder run the block of codes and in demo2d.m.

- Fill out the missing blanks indicated by `% TODO` in demo2.m and each method:
    - In demo2.m, code the convolution of the test image by the optical transfer function:
        ```matlab
        Hu = % TODO
        ```
    - In deconvolve_inverse.m, code the expression of the inverse filter:
        ```matlab
        eps = options.regularization
        filter = % TODO
        ```
        and test it in demo2.m:
        ```matlab
        options.regularization = 0.01;
        uest = deconvolve(f, H, 'inverse', options);
        ```
    - In deconvolve_wiener.m, code the expression of the Wiener filter:
        ```matlab
        filter = % TODO
        ```
        and test it in demo2.m:
        ```matlab
        options.noise_level = sigma;
        uest = deconvolve(f, H, 'wiener', options);
        ```
    - In deconvolve_gold.m, code the update equation
        ```matlab
        for iter = 1:options.max_iter
            Hu = real(H .* fftn(u));
            u = % TODO
        end
        ```
        and test it in demo2d.m:
        ```matlab
        options.max_iter = 30;
        uest = deconvolve(f, H, 'gold', options);
        ```
    - In `deconvolve_richardsonlucy.m`, code the update equation
        ```matlab
        for iter = 1:options.max_iter
            Hu = real(H .* fftn(u));
            u = % TODO
        end
        ```
        and test it in `demo2d.m`:
        ```matlab
        options.max_iter = 30;
        uest = deconvolve(f, H, 'richardsonlucy', options);
        ```
    - In `deconvolve_tikhonov.m` code the update equation:
        ```matlab
        % TODO initialization
        
        for iter = 1:options.max_iter
            du = % TODO 
            du = du ./ max(abs(du(:)));
            u = max(0, u - options.step_size * du);
        end
        ```
        and test it in `demo2d.m`:
        ```matlab
        options.max_iter = 30;
        options.regularization = 0.001;
        uest = deconvolve(f, H, 'tikhonov', options);
        ```
    - In `deconvolve_tv.m`, code the update equation:
        ```matlab
        Hf = real(ifftn(H .* fftn(f)));
        HtH = conj(H).*H;
        u = Hf;
        for iter = 1:options.max_iter
            gx = % gradient in x
            gy = % gradient in y
            n = % norm of the gradients + epsilon
            curv = % divergence of grad(u)/|grad(u)+epsilon|
            du = real(ifftn(HtH.*fftn(u))) - Hf - options.regularization * curv;
            du = du ./ max(abs(du(:)));
            u = max(0, u - options.step_size * du);
        end
        ```
        and test it in `demo2d.m`:
        ```matlab
        options.max_iter = 30;
        options.regularization = 0.001;
        uest = deconvolve(f, H, 'tv', options);
        ```
    - In `deconvolve_richardsonlucy_tv.m`, combine the previous examples.

    - In `demo3.m`, 
        - load the data from the file `../data/img-gfp-tubuline.tif`.
        - visualize it with `imshow3`
        - repeat the steps with the image of a fluorescent bead `../data/psf-gfp.tif`.
        - convert the bead to an OTF
        - visualize the OTF
        - deconvolve the image using one of the methods.


    

