package eu.dral.relevantie

import eu.dral.relevantie.extend._
import scala.util.Random

object app {
  def main(args: Array[String]): Unit = {
    println("Starting.. ^^")
    timeTest()
  }

  def timeTest() {
    val matrix = randomMatrix(3000)
    val base = Vector.fill(matrix.size)(1.0)
    time {
      **(Stream(matrix).circular, base)
    }
  }

  def randomStart() {
    val matrix = randomMatrix(3000)
    val (vector1, itt1) = time {
      val base = Vector.fill(matrix.size)(1.0)
      **(Stream(matrix).circular, base)
    }
    val (vector2, itt2) = time {
      val base = Vector.fill(matrix.size)(Random.nextDouble)
      **(Stream(matrix).circular, base)
    }

    println("Are they the same? "+(if (vector1 ~ vector2) "yes! :-D" else "no :-("))
    println("It is %d vs %d".format(itt1, itt2))
  }


  def changeInBetween() {
    val matrix = betterRandomMatrix(1000)
    val stream = Stream.continually(matrix)

    var count = 0
    val matrixEditted = matrix.map {
      case x if Random.nextDouble > .998 => x.map {
        case y if Random.nextDouble > .998 => count += 1; 1.0 - y
        case y => y
      }
      case x => x
    }
    println("I've editted "+count+" cells.")
    val streamEditted = Stream.continually(matrixEditted)

    // Test group
    val (vector1, itt1) = time {
      val base = Vector.fill(matrixEditted.size)(1.0)
      **(streamEditted, base)
    }

    // With change
    val (vector2, itt2) = time {
      val base = Vector.fill(matrix.size)(Random.nextDouble)
      val (vector, itt) = **(stream, base)
      **(streamEditted, vector)
    }

    println("Are they the same? "+(if (vector1 ~ vector2) "yes! :-D" else "no :-("))
    println("It is %d vs %d".format(itt1, itt2))
  }


  // Helpers
  def randomMatrix(size: Int) = {
    val range = (1 to size)
    val (one, zero, half) = (1.0, .0, .8)
    range map { _ => range map { _ => if (Random.nextDouble > half) one else zero }}
  }

  def betterRandomMatrix(size: Int) = {
    val range = (1 to size)
    val (one, zero, half) = (1.0, .0, .8)
    Vector.fill(size)(Random.nextDouble) map { x => range map { _ => if (Random.nextDouble > x) one else zero }}
  }

  def **(matrices: Stream[Matrix], base: V) = {
    matrices.specialFold(base)({
      (vector: V, matrix: Matrix) =>
        val res: V = matrix * vector normalize()
        res
    }) until ((now, back) => now ~ back) match {
      case None => println("Hahahaaaa"); (Vector(0.0), 0)
      case Some(x) => x
    }
  }

  def printVector(vector: V, dec: Int = 2) {
    println(vector.lessPrecise(dec))
  }

  def time[A](a: => A) = {
    val now = System.nanoTime
    val result = a
    val micros = (System.nanoTime - now) / 1000
    println("%d microseconds".format(micros))
    result
  }
}
