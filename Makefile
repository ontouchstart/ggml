gpt-2: ./build/bin/gpt-2-backend ./models/gpt-2-117M/ggml-model.bin
	./build/bin/gpt-2-backend -m models/gpt-2-117M/ggml-model.bin -p "This is an example"

./build/bin/gpt-2-backend:
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

