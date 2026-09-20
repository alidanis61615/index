package com.example.ali61

import org.junit.Assert.assertEquals
import org.junit.Test

class CalculatorEngineTest {
    @Test
    fun addsTwoNumbers() {
        val calculator = CalculatorEngine()
        calculator.inputDigit(1)
        calculator.inputDigit(2)
        calculator.setOperator(CalculatorEngine.Operator.ADD)
        calculator.inputDigit(8)
        assertEquals("20", calculator.equals())
    }

    @Test
    fun dividesAndFormatsDecimalResult() {
        val calculator = CalculatorEngine()
        calculator.inputDigit(1)
        calculator.setOperator(CalculatorEngine.Operator.DIVIDE)
        calculator.inputDigit(4)
        assertEquals("0.25", calculator.equals())
    }

    @Test
    fun handlesDivisionByZero() {
        val calculator = CalculatorEngine()
        calculator.inputDigit(9)
        calculator.setOperator(CalculatorEngine.Operator.DIVIDE)
        calculator.inputDigit(0)
        assertEquals("Hata", calculator.equals())
    }

    @Test
    fun calculatesPercentage() {
        val calculator = CalculatorEngine()
        calculator.inputDigit(5)
        calculator.inputDigit(0)
        assertEquals("0.5", calculator.percent())
    }
}

