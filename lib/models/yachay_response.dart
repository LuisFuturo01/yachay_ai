/// Model representing the standard JSON contract structure returned by Gemini
/// as defined in the Prompt Library (JSON-01, JSON-02, JSON-03, JSON-04).
class YachayResponse {
  final String tipo;
  final String? titulo;
  final String mensaje;
  final Map<String, dynamic> contenido;
  final Map<String, dynamic> metadata;

  YachayResponse({
    required this.tipo,
    this.titulo,
    required this.mensaje,
    required this.contenido,
    required this.metadata,
  });

  /// Factory constructor to parse the JSON contract structure returned by the API
  factory YachayResponse.fromJson(Map<String, dynamic> json) {
    return YachayResponse(
      tipo: json['tipo'] as String? ?? '',
      titulo: json['titulo'] as String?,
      mensaje: json['mensaje'] as String? ?? '',
      contenido: json['contenido'] as Map<String, dynamic>? ?? const {},
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
    );
  }

  /// Convert model back to standard JSON structure
  Map<String, dynamic> toJson() {
    return {
      'tipo': tipo,
      'titulo': titulo,
      'mensaje': mensaje,
      'contenido': contenido,
      'metadata': metadata,
    };
  }
}
