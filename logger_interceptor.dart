import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class LoggerInterceptor extends Interceptor {
  Logger logger = Logger(
    // Customize the printer
    printer: PrettyPrinter(
      methodCount: 0,
      dateTimeFormat: DateTimeFormat.none,
    ),
  );

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final options = err.requestOptions;
    final requestPath = '${options.baseUrl}${options.path}';
    logger.e('${options.method} request => $requestPath'); // Debug log
    logger.d('Error: ${err.error}, Message: ${err.message}'); // Error log
    return super.onError(err, handler);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final requestPath = '${options.baseUrl}${options.path}';
    logger.i('${options.method} request => $requestPath'); // Info log

    // Log Query Parameters
    if (options.queryParameters.isNotEmpty) {
      logger.i('Request Query Params => ${options.queryParameters}');
    }

    // Log Request Body (including FormData)
    if (options.data != null) {
      String requestBody;

      if (options.data is FormData) {
        final formData = options.data as FormData;
        requestBody = 'Form Data => ${formData.fields.map((field) => '${field.key}: ${field.value}').join(', ')}';
      } else {
        requestBody = 'Request Body => ${options.data}';
      }

      logger.i(requestBody);
    }

    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.d('Statuscode: ${response.statusCode}, Data: \n${response.data}'); // Debug log
    return super.onResponse(response, handler);
  }
}
