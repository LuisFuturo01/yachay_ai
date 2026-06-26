import '../models/lesson.dart';

/// Mock science lesson data.
/// Replace with API response when backend is ready.

class MockScienceData {
  MockScienceData._();

  static const List<Lesson> lessons = [
    Lesson(
      id: 'science_1',
      subjectId: 'science',
      level: 0,
      title: 'Los Animales de Bolivia',
      description: 'Conoce los animales que viven en nuestro país.',
      emoji: '🦙',
      pointsReward: 50,
      questions: [
        Question(
          question: '¿En qué parte de Bolivia vive la llama?',
          correctAnswer: 'En el altiplano',
          options: ['En la selva', 'En el altiplano', 'En el mar', 'En el desierto'],
          hints: [
            'Las llamas viven en lugares altos y fríos...',
            'Piensa en La Paz y Oruro. ¿Cómo es la tierra allí?',
          ],
          explanation: 'Las llamas viven en el altiplano boliviano, donde hace frío y hay mucha altura.',
          imageEmoji: '🏔️',
        ),
        Question(
          question: '¿Qué animal es el símbolo de Bolivia y vuela muy alto?',
          correctAnswer: 'El cóndor',
          options: ['El loro', 'El cóndor', 'El águila', 'El tucán'],
          hints: [
            'Es un ave muy grande que aparece en el escudo de Bolivia...',
            'Vive en las montañas y puede volar más alto que cualquier otra ave.',
          ],
          explanation: 'El cóndor andino es el ave voladora más grande del mundo y es símbolo de Bolivia.',
          imageEmoji: '🦅',
        ),
        Question(
          question: '¿Qué animal vive en el Lago Titicaca y es muy especial?',
          correctAnswer: 'La rana gigante',
          options: ['El delfín', 'El tiburón', 'La rana gigante', 'La tortuga'],
          hints: [
            'Es un anfibio que solo vive en este lago...',
            'Es una rana, pero mucho más grande de lo normal.',
          ],
          explanation: 'La rana gigante del Titicaca es una especie única que solo vive en este lago.',
          imageEmoji: '🐸',
        ),
      ],
    ),

    Lesson(
      id: 'science_2',
      subjectId: 'science',
      level: 1,
      title: 'Las Plantas y la Tierra',
      description: '¿Cómo crecen las plantas? ¡Descúbrelo!',
      emoji: '🌱',
      pointsReward: 60,
      questions: [
        Question(
          question: '¿Qué necesita una planta para crecer?',
          correctAnswer: 'Agua, sol y tierra',
          options: ['Solo agua', 'Solo sol', 'Agua, sol y tierra', 'Solo tierra'],
          hints: [
            'Las plantas necesitan más de una cosa para vivir...',
            'Piensa en lo que le pones a tu planta: la riegas, la pones al sol...',
          ],
          explanation: 'Las plantas necesitan agua, luz del sol y tierra con nutrientes para crecer sanas.',
          imageEmoji: '🌻',
        ),
        Question(
          question: '¿Qué planta es muy importante en Bolivia y crece en el altiplano?',
          correctAnswer: 'La quinua',
          options: ['El trigo', 'La quinua', 'El arroz', 'El maíz'],
          hints: [
            'Es un grano muy nutritivo que comemos en sopa...',
            'Bolivia es uno de los mayores productores de este alimento en el mundo.',
          ],
          explanation: 'La quinua es el "grano de oro" de Bolivia. ¡Es súper nutritiva!',
          imageEmoji: '🌾',
        ),
        Question(
          question: '¿Qué parte de la planta absorbe el agua de la tierra?',
          correctAnswer: 'La raíz',
          options: ['La hoja', 'El tallo', 'La raíz', 'La flor'],
          hints: [
            'Está debajo de la tierra, donde no la vemos...',
            'Es como unos "deditos" que beben agua del suelo.',
          ],
          explanation: 'La raíz es la parte de la planta que está bajo la tierra y absorbe agua y nutrientes.',
          imageEmoji: '🌿',
        ),
      ],
    ),

    Lesson(
      id: 'science_3',
      subjectId: 'science',
      level: 2,
      title: 'El Cuerpo Humano',
      description: 'Conoce cómo funciona tu cuerpo.',
      emoji: '🫀',
      pointsReward: 80,
      questions: [
        Question(
          question: '¿Cuántos huesos tiene el cuerpo humano adulto?',
          correctAnswer: '206',
          options: ['106', '206', '306', '150'],
          hints: [
            'Son más de 200 huesos...',
            'Es un número que empieza con 2 y termina en 6.',
          ],
          explanation: 'El cuerpo humano adulto tiene 206 huesos que nos ayudan a movernos.',
          imageEmoji: '🦴',
        ),
        Question(
          question: '¿Qué órgano bombea la sangre por todo tu cuerpo?',
          correctAnswer: 'El corazón',
          options: ['El cerebro', 'El corazón', 'El estómago', 'Los pulmones'],
          hints: [
            'Pon tu mano en el pecho. ¿Sientes algo que late?',
            'Late "tum-tum-tum" todo el día sin parar.',
          ],
          explanation: 'El corazón es un músculo que bombea sangre a todo tu cuerpo. ¡Late unas 100,000 veces al día!',
          imageEmoji: '❤️',
        ),
        Question(
          question: '¿Qué órgano usas para pensar y aprender?',
          correctAnswer: 'El cerebro',
          options: ['El corazón', 'El cerebro', 'El hígado', 'El estómago'],
          hints: [
            'Está dentro de tu cabeza...',
            'Lo estás usando ahora mismo para responder esta pregunta.',
          ],
          explanation: 'El cerebro es el órgano más importante. ¡Con él piensas, aprendes y sueñas!',
          imageEmoji: '🧠',
        ),
      ],
    ),

    Lesson(
      id: 'science_4',
      subjectId: 'science',
      level: 3,
      title: 'El Agua y la Vida',
      description: 'El agua es esencial para todos los seres vivos.',
      emoji: '💧',
      pointsReward: 100,
      questions: [
        Question(
          question: '¿En qué estados se puede encontrar el agua?',
          correctAnswer: 'Sólido, líquido y gaseoso',
          options: ['Solo líquido', 'Líquido y sólido', 'Sólido, líquido y gaseoso', 'Solo gaseoso'],
          hints: [
            'Piensa en el hielo, el agua del grifo y el vapor...',
            'El hielo es sólido, el agua es líquida, y el vapor es...',
          ],
          explanation: 'El agua existe en 3 estados: sólido (hielo), líquido (agua) y gaseoso (vapor).',
          imageEmoji: '🧊',
        ),
        Question(
          question: '¿Cuál es el lago navegable más alto del mundo?',
          correctAnswer: 'El Lago Titicaca',
          options: ['El Lago Poopó', 'El Lago Titicaca', 'El Lago Rogaguado', 'El Lago Uru Uru'],
          hints: [
            'Está entre Bolivia y Perú...',
            'Su nombre tiene dos palabras repetidas: Titi...caca.',
          ],
          explanation: 'El Lago Titicaca, entre Bolivia y Perú, es el lago navegable más alto del mundo a 3,812 m.',
          imageEmoji: '🌊',
        ),
        Question(
          question: '¿Por qué es importante cuidar el agua?',
          correctAnswer: 'Porque es un recurso limitado',
          options: ['Porque es bonita', 'Porque es un recurso limitado', 'Porque es salada', 'Porque llueve siempre'],
          hints: [
            'No toda el agua del planeta se puede beber...',
            'Solo una pequeña parte del agua del mundo es dulce y potable.',
          ],
          explanation: 'Solo el 2.5% del agua del planeta es dulce. ¡Debemos cuidarla para que todos tengan!',
          imageEmoji: '🌍',
        ),
      ],
    ),

    Lesson(
      id: 'science_5',
      subjectId: 'science',
      level: 4,
      title: 'El Clima de Bolivia',
      description: 'Bolivia tiene muchos climas diferentes. ¡Descúbrelos!',
      emoji: '🌤️',
      pointsReward: 120,
      questions: [
        Question(
          question: '¿Cómo es el clima en el altiplano boliviano?',
          correctAnswer: 'Frío y seco',
          options: ['Caliente y húmedo', 'Frío y seco', 'Templado', 'Tropical'],
          hints: [
            'En La Paz y Oruro hace mucho frío, especialmente de noche...',
            'Es un lugar alto donde llueve poco.',
          ],
          explanation: 'El altiplano tiene clima frío y seco por su gran altitud (más de 3,500 m).',
          imageEmoji: '🥶',
        ),
        Question(
          question: '¿En qué región de Bolivia hace mucho calor y hay selva?',
          correctAnswer: 'En los llanos orientales',
          options: ['En el altiplano', 'En los valles', 'En los llanos orientales', 'En el Salar'],
          hints: [
            'Piensa en Santa Cruz y el Beni...',
            'Es la zona donde hay selva amazónica.',
          ],
          explanation: 'Los llanos orientales (Santa Cruz, Beni, Pando) tienen clima tropical con selva y calor.',
          imageEmoji: '🌴',
        ),
        Question(
          question: '¿Qué es el granizo?',
          correctAnswer: 'Bolitas de hielo que caen del cielo',
          options: ['Lluvia muy fuerte', 'Bolitas de hielo que caen del cielo', 'Nieve derretida', 'Viento con arena'],
          hints: [
            'Es como lluvia, pero las gotas se congelan antes de caer...',
            'Son como pelotitas de hielo que rebotan en el suelo.',
          ],
          explanation: 'El granizo son gotas de agua que se congelan en las nubes y caen como bolitas de hielo.',
          imageEmoji: '🌨️',
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
