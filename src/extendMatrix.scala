package eu.dral.relevantie

import scala.language.implicitConversions
import eu.dral.relevantie.extend._

// Break controlflow
import scala.util.control.ControlThrowable
case class Returned[A](value: A) extends ControlThrowable {}

object extend {
  type V = Seq[Double]
  type Matrix = Seq[V]

  implicit def pimpStream[A](s: Stream[A]): BetterStream[A] = new BetterStream(s)
  implicit def pimpMatrix(m: Matrix): BetterMatrix = new BetterMatrix(m)
  implicit def pimpVector(v: V): BetterVector = new BetterVector(v)
}

// Better folding with an condition
class SpecialFolder[B, A](stream: Stream[A], start: B, op: (B, A) => B) {
  def until(cond: (B, B) => Boolean): Option[(B, Int)] = {
    var count = 0
    try {
      stream.foldLeft(start) { (b,a) =>
        val result = op(b, a)
        count += 1
        if (cond(result, b)) throw Returned(result)
        result
      }
      // When there is no match with the condition, return nothing
      None
    } catch {
      case Returned(v: B) => Some((v, count))
    }
  }
}
class BetterStream[A](stream: Stream[A]) {
  def specialFold[B](start: B)(op: (B, A) => B): SpecialFolder[B, A] = {
    new SpecialFolder(stream, start, op)
  }
}

class BetterVector(vector: V) {
  // Maak alle waardes tussen de 0 en de 1
  def normalize(): V = {
    val max = vector.max
    vector map { _ / max }
  }

  // Checkt of twee vectoren ongeveer gelijk zijn
  def ~(other: V, precision: Int = 2): Boolean = {
    lessPrecise(precision) == other.lessPrecise(precision)
  }

  def lessPrecise(precision: Int = 2): V = {
    val size = math.pow(10, precision)
    vector map { _ * size } map { _.ceil } map { _ / size }
  }
}

class BetterMatrix(matrix: Matrix) {
  def *(vector: V) = {
    matrix map { _ zip vector map { case (x, y) => x*y }} map (_.sum)
  }
}
