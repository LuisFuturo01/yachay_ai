import '../models/lesson.dart';

/// Mock math lesson data.
/// Replace with API response from tutor_service when backend is ready.

class MockMathData {
  MockMathData._();

  static const List<Lesson> lessons = [
    // ─── Nivel 1: Sumas Mágicas ───
    Lesson(
      id: 'math_1',
      subjectId: 'math',
      level: 0,
      title: 'Sumas Mágicas',
      description: '¡Aprende a sumar con objetos cotidianos!',
      emoji: '✨',
      pointsReward: 50,
      questions: [
        Question(
          question: '¿Cuánto es 3 + 4?',
          correctAnswer: '7',
          options: ['5', '6', '7', '8'],
          hints: [
            'Imagina que tienes 3 salteñas en una mano y 4 en la otra. ¿Cuántas tienes en total?',
            'Cuenta con los dedos: 3... y luego sigue contando 4 más.',
          ],
          explanation: '3 + 4 = 7. ¡Como tener 3 salteñas y comprar 4 más!',
          imageEmoji: '🥟',
        ),
        Question(
          question: '¿Cuánto es 5 + 5?',
          correctAnswer: '10',
          options: ['8', '9', '10', '11'],
          hints: [
            'Piensa en tus dos manos. Cada mano tiene 5 dedos...',
            'Junta los dedos de las dos manos y cuenta todos.',
          ],
          explanation: '5 + 5 = 10. ¡Igual que los dedos de tus dos manos!',
          imageEmoji: '🖐️',
        ),
        Question(
          question: '¿Cuánto es 8 + 2?',
          correctAnswer: '10',
          options: ['9', '10', '11', '12'],
          hints: [
            'Tienes 8 llamas y llegan 2 más al rebaño...',
            'Desde el 8, cuenta 2 más: 9... 10.',
          ],
          explanation: '8 + 2 = 10. ¡Tu rebaño de llamas creció!',
          imageEmoji: '🦙',
        ),
      ],
    ),

    // ─── Nivel 2: Restas Divertidas ───
    Lesson(
      id: 'math_2',
      subjectId: 'math',
      level: 1,
      title: 'Restas Divertidas',
      description: 'Descubre cómo restar es como compartir.',
      emoji: '🎯',
      pointsReward: 60,
      questions: [
        Question(
          question: '¿Cuánto es 9 - 3?',
          correctAnswer: '6',
          options: ['4', '5', '6', '7'],
          hints: [
            'Tenías 9 monedas de boliviano y regalaste 3. ¿Cuántas te quedan?',
            'Cuenta hacia atrás desde 9: 8, 7, 6...',
          ],
          explanation: '9 - 3 = 6. ¡Compartir es bonito!',
          imageEmoji: '🪙',
        ),
        Question(
          question: '¿Cuánto es 10 - 4?',
          correctAnswer: '6',
          options: ['5', '6', '7', '8'],
          hints: [
            'De 10 empanadas, te comiste 4. ¿Cuántas quedan?',
            'Piensa: 10 menos 4... quita 4 de los 10.',
          ],
          explanation: '10 - 4 = 6. ¡Quedan 6 empanadas para después!',
          imageEmoji: '🥟',
        ),
        Question(
          question: '¿Cuánto es 7 - 5?',
          correctAnswer: '2',
          options: ['1', '2', '3', '4'],
          hints: [
            'Tenías 7 cóndores volando y 5 se fueron a descansar...',
            'De 7, quita 5. ¿Cuántos siguen volando?',
          ],
          explanation: '7 - 5 = 2. ¡Solo 2 cóndores siguen en el cielo!',
          imageEmoji: '🦅',
        ),
      ],
    ),

    // ─── Nivel 3: Multiplicación Fantástica ───
    Lesson(
      id: 'math_3',
      subjectId: 'math',
      level: 2,
      title: 'Multiplicación Fantástica',
      description: 'Multiplicar es sumar muchas veces. ¡Es magia!',
      emoji: '⚡',
      pointsReward: 80,
      questions: [
        Question(
          question: '¿Cuánto es 3 x 4?',
          correctAnswer: '12',
          options: ['10', '11', '12', '14'],
          hints: [
            'Imagina 3 bolsas con 4 panes cada una. ¿Cuántos panes hay en total?',
            'Suma: 4 + 4 + 4 = ...',
          ],
          explanation: '3 x 4 = 12. ¡3 bolsas con 4 panes = 12 panes!',
          imageEmoji: '🍞',
        ),
        Question(
          question: '¿Cuánto es 7 x 8?',
          correctAnswer: '56',
          options: ['48', '54', '56', '58'],
          hints: [
            'Imagina 7 filas de 8 sillas en tu aula. ¿Cuántas sillas hay?',
            'Truco: 7 x 8 = 56. ¡5, 6, 7, 8! Los números van en orden.',
          ],
          explanation: '7 x 8 = 56. ¡Un truco fácil para recordar!',
          imageEmoji: '🪑',
        ),
        Question(
          question: '¿Cuánto es 5 x 6?',
          correctAnswer: '30',
          options: ['25', '28', '30', '35'],
          hints: [
            'Piensa en 5 grupos de 6 piedras de colores...',
            'Suma: 6 + 6 + 6 + 6 + 6 = ...',
          ],
          explanation: '5 x 6 = 30. ¡30 piedritas de colores!',
          imageEmoji: '💎',
        ),
      ],
    ),

    // ─── Nivel 4: División Aventurera ───
    Lesson(
      id: 'math_4',
      subjectId: 'math',
      level: 3,
      title: 'División Aventurera',
      description: 'Dividir es repartir en partes iguales.',
      emoji: '🧩',
      pointsReward: 100,
      questions: [
        Question(
          question: '¿Cuánto es 12 ÷ 3?',
          correctAnswer: '4',
          options: ['3', '4', '5', '6'],
          hints: [
            'Tienes 12 caramelos y los repartes entre 3 amigos por igual...',
            'Piensa: ¿3 x qué número = 12?',
          ],
          explanation: '12 ÷ 3 = 4. ¡Cada amigo recibe 4 caramelos!',
          imageEmoji: '🍬',
        ),
        Question(
          question: '¿Cuánto es 20 ÷ 4?',
          correctAnswer: '5',
          options: ['4', '5', '6', '7'],
          hints: [
            'Repartes 20 stickers entre 4 compañeros...',
            '¿4 x cuánto = 20?',
          ],
          explanation: '20 ÷ 4 = 5. ¡5 stickers para cada uno!',
          imageEmoji: '⭐',
        ),
        Question(
          question: '¿Cuánto es 15 ÷ 5?',
          correctAnswer: '3',
          options: ['2', '3', '4', '5'],
          hints: [
            'Son 15 lápices para 5 grupos iguales...',
            'Piensa: 5 x 3 = 15. Entonces 15 ÷ 5 = ...',
          ],
          explanation: '15 ÷ 5 = 3. ¡3 lápices por grupo!',
          imageEmoji: '✏️',
        ),
      ],
    ),

    // ─── Nivel 5: Problemas del Mercado ───
    Lesson(
      id: 'math_5',
      subjectId: 'math',
      level: 4,
      title: 'Problemas del Mercado',
      description: '¡Resuelve problemas como en el mercado de La Paz!',
      emoji: '🏪',
      pointsReward: 120,
      questions: [
        Question(
          question: 'María compra 3 panes a 2 Bs cada uno. ¿Cuánto paga en total?',
          correctAnswer: '6',
          options: ['5', '6', '7', '8'],
          hints: [
            'Si cada pan cuesta 2 Bs, y compra 3 panes...',
            'Multiplica: 3 panes × 2 Bs = ...',
          ],
          explanation: '3 × 2 = 6 Bs. ¡María paga 6 bolivianos!',
          imageEmoji: '🍞',
        ),
        Question(
          question: 'Juan tiene 15 Bs y gasta 8 Bs en fruta. ¿Cuánto le sobra?',
          correctAnswer: '7',
          options: ['5', '6', '7', '8'],
          hints: [
            'Tenía 15 Bs y gastó 8 Bs. ¿Cuánto le queda?',
            'Resta: 15 - 8 = ...',
          ],
          explanation: '15 - 8 = 7. ¡Le sobran 7 bolivianos!',
          imageEmoji: '🍊',
        ),
        Question(
          question: 'En una caja hay 24 naranjas. Se reparten en 6 bolsas iguales. ¿Cuántas hay en cada bolsa?',
          correctAnswer: '4',
          options: ['3', '4', '5', '6'],
          hints: [
            'Divide las 24 naranjas en 6 grupos iguales...',
            '24 ÷ 6 = ...',
          ],
          explanation: '24 ÷ 6 = 4. ¡4 naranjas en cada bolsa!',
          imageEmoji: '🍊',
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
