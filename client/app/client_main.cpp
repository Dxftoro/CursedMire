#include <iostream>
#include <asio.hpp>

constexpr size_t READ_BLOCK_SIZE = 64;

int main() {
	asio::io_context io;
	asio::ip::tcp::socket socket(io);

	asio::error_code errorCode;
	asio::ip::tcp::endpoint endpoint(asio::ip::make_address("127.0.0.1"), 3333);

	socket.connect(endpoint, errorCode);

	if (errorCode) {
		std::cerr << "Can't connect to the server!" << std::endl;
		return -1;
	}
	std::cout << "Connected to Mire!" << std::endl;

	std::string message, responseText;
	std::vector<uint8_t> buffer(READ_BLOCK_SIZE);
	asio::streambuf response(READ_BLOCK_SIZE);

	while (true) {		
		asio::error_code readError;
		size_t bytesRead = 0;

		bytesRead = asio::read_until(socket, response, "\r\n", readError);
		std::cout << "bytes read: " << bytesRead << std::endl;
		
		std::istream responseContent(&response);
		std::string tempText;
		std::getline(responseContent, tempText);
		responseText += tempText;

		std::cout << "--- " << responseText << std::endl;
		
		std::cout << responseText << std::endl;
		responseText.clear();

		std::cout << "> ";
		std::getline(std::cin, message);
		message += "\n";

		asio::write(socket, asio::buffer(message));
	}

	socket.close();
	return 0;
}