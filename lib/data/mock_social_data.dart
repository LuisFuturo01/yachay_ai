import '../models/lesson.dart';

/// Mock social studies lesson data.
/// Replace with API response when backend is ready.

class MockSocialData {
  MockSocialData._();

  static const List<Lesson> lessons = [
    Lesson(
      id: 'social_1',
      subjectId: 'social',
      level: 0,
      title: 'Mi Familia y Comunidad',
      description: 'La familia es lo más importante. ¡Conócela mejor!',
      emoji: '👨‍👩‍👧‍👦',
      pointsReward: 50,
      questions: [
        Question(
          question: '¿Qué es una comunidad?',
          correctAnswer: 'Un grupo de personas que viven juntas en un lugar',
          options: [
            'Una persona sola',
            'Un grupo de personas que viven juntas en un lugar',
            'Un edificio grande',
            'Un tipo de comida',
          ],
          hints: [
            'Piensa en tu barrio, en tus vecinos...',
            'Es como una gran familia que comparte un lugar.',
          ],
          explanation: 'Una comunidad es un grupo de personas que viven en un mismo lugar y se ayudan mutuamente.',
          imageEmoji: '🏘️',
        ),
        Question(
          question: '¿Quiénes forman parte de tu familia?',
          correctAnswer: 'Papá, mamá, hermanos, abuelos y más',
          options: [
            'Solo tus amigos',
            'Papá, mamá, hermanos, abuelos y más',
            'Solo tu mascota',
            'Los vecinos',
          ],
          hints: [
            'Piensa en las personas que viven contigo o te cuidan...',
            'Mamá, papá, abuelos, tíos... todos son tu familia.',
          ],
          explanation: 'La familia incluye a padres, hermanos, abuelos, tíos y más. ¡Cada familia es especial!',
          imageEmoji: '❤️',
        ),
        Question(
          question: '¿Por qué es importante respetar a los mayores?',
          correctAnswer: 'Porque tienen experiencia y sabiduría',
          options: [
            'Porque son más altos',
            'Porque tienen experiencia y sabiduría',
            'Porque tienen dinero',
            'Porque son aburridos',
          ],
          hints: [
            'Los abuelos han vivido muchos años y aprendido muchas cosas...',
            'En la cultura boliviana, los mayores son muy respetados por su conocimiento.',
          ],
          explanation: 'Los mayores tienen experiencia y sabiduría. En Bolivia, el respeto a los abuelos es muy importante.',
          imageEmoji: '👴',
        ),
      ],
    ),

    Lesson(
      id: 'social_2',
      subjectId: 'social',
      level: 1,
      title: 'Bolivia, mi País',
      description: 'Conoce los datos más importantes de Bolivia.',
      emoji: '🇧🇴',
      pointsReward: 60,
      questions: [
        Question(
          question: '¿Cuál es la capital constitucional de Bolivia?',
          correctAnswer: 'Sucre',
          options: ['La Paz', 'Sucre', 'Santa Cruz', 'Cochabamba'],
          hints: [
            'No es la ciudad más grande, pero es la capital oficial...',
            'Está en el departamento de Chuquisaca.',
          ],
          explanation: 'Sucre es la capital constitucional de Bolivia, también llamada la "Ciudad Blanca".',
          imageEmoji: '🏛️',
        ),
        Question(
          question: '¿Cuántos departamentos tiene Bolivia?',
          correctAnswer: '9',
          options: ['7', '8', '9', '10'],
          hints: [
            'Piensa: La Paz, Oruro, Potosí, Cochabamba...',
            'Y también Chuquisaca, Tarija, Santa Cruz, Beni y Pando.',
          ],
          explanation: 'Bolivia tiene 9 departamentos: La Paz, Oruro, Potosí, Cochabamba, Chuquisaca, Tarija, Santa Cruz, Beni y Pando.',
          imageEmoji: '🗺️',
        ),
        Question(
          question: '¿De qué colores es la bandera de Bolivia?',
          correctAnswer: 'Rojo, amarillo y verde',
          options: ['Azul, blanco y rojo', 'Rojo, amarillo y verde', 'Verde y amarillo', 'Rojo y blanco'],
          hints: [
            'Son tres colores como un semáforo...',
            'El rojo arriba, el amarillo en medio y el verde abajo.',
          ],
          explanation: 'La bandera tricolor de Bolivia es roja (sangre de héroes), amarilla (riqueza mineral) y verde (naturaleza).',
          imageEmoji: '🇧🇴',
        ),
      ],
    ),

    Lesson(
      id: 'social_3',
      subjectId: 'social',
      level: 2,
      title: 'Culturas Originarias',
      description: 'Bolivia tiene 36 naciones indígenas. ¡Conócelas!',
      emoji: '🎭',
      pointsReward: 80,
      questions: [
        Question(
          question: '¿Cuántas naciones indígenas reconoce Bolivia?',
          correctAnswer: '36',
          options: ['10', '20', '36', '50'],
          hints: [
            'Son más de 30 pueblos originarios...',
            'La Constitución de Bolivia reconoce exactamente este número.',
          ],
          explanation: 'Bolivia reconoce 36 naciones indígena originario campesinas en su Constitución.',
          imageEmoji: '🌎',
        ),
        Question(
          question: '¿Qué pueblo originario construyó Tiwanaku?',
          correctAnswer: 'La cultura Tiwanakota',
          options: ['Los Incas', 'La cultura Tiwanakota', 'Los Guaraníes', 'Los Mojeños'],
          hints: [
            'El nombre del pueblo es muy parecido al nombre del lugar...',
            'Estas ruinas están cerca del Lago Titicaca.',
          ],
          explanation: 'La cultura Tiwanakota construyó la antigua ciudad de Tiwanaku hace más de 2000 años.',
          imageEmoji: '🏛️',
        ),
        Question(
          question: '¿Qué celebración boliviana fue declarada Patrimonio de la Humanidad?',
          correctAnswer: 'El Carnaval de Oruro',
          options: ['El Carnaval de Oruro', 'La Fiesta del Gran Poder', 'Todos Santos', 'Año Nuevo Aymara'],
          hints: [
            'Se celebra en una ciudad del altiplano con mucha minería...',
            'Es famosa por la Diablada y otras danzas folklóricas.',
          ],
          explanation: 'El Carnaval de Oruro fue declarado Patrimonio Cultural de la Humanidad por la UNESCO en 2001.',
          imageEmoji: '🎉',
        ),
      ],
    ),

    Lesson(
      id: 'social_4',
      subjectId: 'social',
      level: 3,
      title: 'Geografía de Bolivia',
      description: 'Montañas, ríos y paisajes increíbles.',
      emoji: '🏔️',
      pointsReward: 100,
      questions: [
        Question(
          question: '¿Cuál es la montaña más alta de Bolivia?',
          correctAnswer: 'El Nevado Sajama',
          options: ['El Illimani', 'El Huayna Potosí', 'El Nevado Sajama', 'El Tunari'],
          hints: [
            'Está en el departamento de Oruro...',
            'Es un volcán nevado que mide 6,542 metros.',
          ],
          explanation: 'El Nevado Sajama, con 6,542 metros, es la montaña más alta de Bolivia.',
          imageEmoji: '🏔️',
        ),
        Question(
          question: '¿Qué es el Salar de Uyuni?',
          correctAnswer: 'El desierto de sal más grande del mundo',
          options: ['Un lago muy grande', 'El desierto de sal más grande del mundo', 'Un volcán', 'Una selva'],
          hints: [
            'Es blanco como la nieve pero no es nieve...',
            'Está en Potosí y es famoso mundialmente.',
          ],
          explanation: 'El Salar de Uyuni es el desierto de sal más grande del mundo con 10,582 km².',
          imageEmoji: '🏜️',
        ),
        Question(
          question: '¿Qué río importante pasa por la Amazonía boliviana?',
          correctAnswer: 'El Río Mamoré',
          options: ['El Río Desaguadero', 'El Río Mamoré', 'El Río de la Plata', 'El Río Nilo'],
          hints: [
            'Está en la región del Beni...',
            'Es un afluente del río Madeira que va al Amazonas.',
          ],
          explanation: 'El Río Mamoré es uno de los ríos más importantes de la Amazonía boliviana.',
          imageEmoji: '🏞️',
        ),
      ],
    ),

    Lesson(
      id: 'social_5',
      subjectId: 'social',
      level: 4,
      title: 'Derechos y Deberes',
      description: 'Todos tenemos derechos y también responsabilidades.',
      emoji: '⚖️',
      pointsReward: 120,
      questions: [
        Question(
          question: '¿Cuál es un derecho de todos los niños?',
          correctAnswer: 'Ir a la escuela y aprender',
          options: ['Trabajar todo el día', 'Ir a la escuela y aprender', 'No hacer nada', 'Solo jugar'],
          hints: [
            'Piensa en algo que haces todos los días y es muy importante...',
            'La educación es un derecho fundamental de los niños.',
          ],
          explanation: 'Todos los niños tienen derecho a la educación. ¡Aprender es tu superpoder!',
          imageEmoji: '📚',
        ),
        Question(
          question: '¿Qué es un deber ciudadano?',
          correctAnswer: 'Una responsabilidad que tenemos todos',
          options: ['Un castigo', 'Una responsabilidad que tenemos todos', 'Un premio', 'Un juego'],
          hints: [
            'Es algo que debemos hacer para que todos vivamos bien...',
            'Por ejemplo, cuidar el medio ambiente es un deber.',
          ],
          explanation: 'Los deberes son responsabilidades que tenemos para vivir en armonía con los demás.',
          imageEmoji: '🤝',
        ),
        Question(
          question: '¿Por qué es importante votar cuando seas grande?',
          correctAnswer: 'Para elegir a quienes nos gobiernan',
          options: ['Para ganar premios', 'Para elegir a quienes nos gobiernan', 'Para no ir a la escuela', 'No es importante'],
          hints: [
            'En Bolivia, votar es obligatorio para los adultos...',
            'Es la forma de elegir al presidente y a las autoridades.',
          ],
          explanation: 'Votar es un derecho y un deber. Con el voto elegimos a quienes toman decisiones por todos.',
          imageEmoji: '🗳️',
        ),
      ],
    ),
  ];

  static Lesson getLesson(int level) {
    if (level < 0 || level >= lessons.length) return lessons.first;
    return lessons[level];
  }

  static int get totalLevels => lessons.length;
}
