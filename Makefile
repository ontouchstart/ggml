./build/bin:
	mkdir -p build
	cd build && cmake .. \
		-DCMAKE_BUILD_TYPE=Release \
		-D GGML_NATIVE=OFF \
		-D GGML_CPU_ARM_ARCH=armv8-a \
		-D GGML_CPU=ON \
		-D BUILD_TESTS=OFF
	cd build && cmake --build .
	cd build && ctest --output-on-failure

./models/gpt-2-117M/ggml-model.bin:
	./examples/gpt-2/download-ggml-model.sh 117M


test: ./build/bin ./models/gpt-2-117M/ggml-model.bin
	./build/bin/gpt-2-alloc
	./build/bin/gpt-2-batched
	./build/bin/gpt-2-backend
	./build/bin/gpt-2-ctx
	./build/bin/gpt-2-sched
	mkdir -p quant
	./build/bin/gpt-2-quantize models/gpt-2-117M/ggml-model.bin quant/ggml-model-q2_k.bin q2_k
	./build/bin/gpt-2-quantize models/gpt-2-117M/ggml-model.bin quant/ggml-model-q3_k.bin q3_k
	./build/bin/gpt-2-quantize models/gpt-2-117M/ggml-model.bin quant/ggml-model-q4_0.bin q4_0
	./build/bin/gpt-2-quantize models/gpt-2-117M/ggml-model.bin quant/ggml-model-q4_1.bin q4_1
	./build/bin/gpt-2-quantize models/gpt-2-117M/ggml-model.bin quant/ggml-model-q4_k.bin q4_k
	./build/bin/gpt-2-quantize models/gpt-2-117M/ggml-model.bin quant/ggml-model-q5_0.bin q5_0
	./build/bin/gpt-2-quantize models/gpt-2-117M/ggml-model.bin quant/ggml-model-q5_1.bin q5_1
	./build/bin/gpt-2-quantize models/gpt-2-117M/ggml-model.bin quant/ggml-model-q5_k.bin q5_k
	./build/bin/gpt-2-quantize models/gpt-2-117M/ggml-model.bin quant/ggml-model-q6_k.bin q6_k
	./build/bin/gpt-2-quantize models/gpt-2-117M/ggml-model.bin quant/ggml-model-q8_0.bin q8_0
	du -h quant/*
	du -h models/gpt-2-117M/ggml-model.bin
