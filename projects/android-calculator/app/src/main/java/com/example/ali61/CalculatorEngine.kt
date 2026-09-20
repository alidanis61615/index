package com.example.ali61

import java.math.BigDecimal
import java.math.MathContext
import java.math.RoundingMode

class CalculatorEngine {
    var display: String = "0"
        private set

    private var storedValue: BigDecimal? = null
    private var pendingOperator: Operator? = null
    private var waitingForOperand = false

    fun inputDigit(digit: Int): String {
        if (digit !in 0..9) return display
        if (display == ERROR || waitingForOperand) {
            display = digit.toString()
            waitingForOperand = false
        } else if (display == "0") {
            display = digit.toString()
        } else if (display.replace("-", "").replace(".", "").length < MAX_DIGITS) {
            display += digit
        }
        return display
    }

    fun inputDecimal(): String {
        if (display == ERROR || waitingForOperand) {
            display = "0."
            waitingForOperand = false
        } else if (!display.contains('.')) {
            display += "."
        }
        return display
    }

    fun clear(): String {
        display = "0"
        storedValue = null
        pendingOperator = null
        waitingForOperand = false
        return display
    }

    fun toggleSign(): String {
        if (display == ERROR || display == "0") return display
        display = if (display.startsWith('-')) display.drop(1) else "-$display"
        return display
    }

    fun percent(): String {
        val value = currentValue() ?: return clear()
        display = format(value.divide(BigDecimal("100"), MATH_CONTEXT))
        return display
    }

    fun setOperator(operator: Operator): String {
        val value = currentValue() ?: return clear()
        if (pendingOperator != null && !waitingForOperand) {
            val result = calculate(storedValue ?: BigDecimal.ZERO, value, pendingOperator!!)
            if (result == null) return showError()
            storedValue = result
            display = format(result)
        } else {
            storedValue = value
        }
        pendingOperator = operator
        waitingForOperand = true
        return display
    }

    fun equals(): String {
        val operator = pendingOperator ?: return display
        val rightValue = currentValue() ?: return clear()
        val leftValue = storedValue ?: BigDecimal.ZERO
        val result = calculate(leftValue, rightValue, operator) ?: return showError()
        display = format(result)
        storedValue = null
        pendingOperator = null
        waitingForOperand = true
        return display
    }

    private fun currentValue(): BigDecimal? =
        if (display == ERROR) null else display.toBigDecimalOrNull()

    private fun calculate(left: BigDecimal, right: BigDecimal, operator: Operator): BigDecimal? =
        when (operator) {
            Operator.ADD -> left.add(right, MATH_CONTEXT)
            Operator.SUBTRACT -> left.subtract(right, MATH_CONTEXT)
            Operator.MULTIPLY -> left.multiply(right, MATH_CONTEXT)
            Operator.DIVIDE -> if (right.compareTo(BigDecimal.ZERO) == 0) null
            else left.divide(right, DIVISION_SCALE, RoundingMode.HALF_UP)
        }

    private fun showError(): String {
        display = ERROR
        storedValue = null
        pendingOperator = null
        waitingForOperand = true
        return display
    }

    private fun format(value: BigDecimal): String {
        val normalized = value.stripTrailingZeros()
        return if (normalized.compareTo(BigDecimal.ZERO) == 0) "0" else normalized.toPlainString()
    }

    enum class Operator { ADD, SUBTRACT, MULTIPLY, DIVIDE }

    private companion object {
        const val ERROR = "Hata"
        const val MAX_DIGITS = 15
        const val DIVISION_SCALE = 10
        val MATH_CONTEXT = MathContext(15, RoundingMode.HALF_UP)
    }
}

