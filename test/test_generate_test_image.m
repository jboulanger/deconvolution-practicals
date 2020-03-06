addpath('../utils')
dims = [64 64 32];
subplot(321), imshow3(generate_test_image('wavy', dims),[])
subplot(322), imshow(generate_test_image('wavy', dims(1:2)),[])
subplot(323), imshow3(generate_test_image('fibers', dims),[])
subplot(324), imshow(generate_test_image('fibers', dims(1:2)),[])
subplot(325), imshow3(generate_test_image('steps', dims),[])
subplot(326), imshow(generate_test_image('steps', dims(1:2)),[])