package com.example.ali61

import android.os.Bundle
import android.widget.TextView
import androidx.activity.enableEdgeToEdge
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import com.google.android.material.button.MaterialButton

class MainActivity : AppCompatActivity() {
    private val calculator = CalculatorEngine()
    private lateinit var displayText: TextView

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContentView(R.layout.activity_main)

        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main)) { view, insets ->
            val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
            view.setPadding(view.paddingLeft, systemBars.top, view.paddingRight, systemBars.bottom)
            insets
        }

        displayText = findViewById(R.id.displayText)
        bindNumberButtons()
        bindActionButtons()
        updateDisplay(calculator.display)
    }

    private fun bindNumberButtons() {
        val numberButtons = mapOf(
            R.id.button0 to 0, R.id.button1 to 1, R.id.button2 to 2,
            R.id.button3 to 3, R.id.button4 to 4, R.id.button5 to 5,
            R.id.button6 to 6, R.id.button7 to 7, R.id.button8 to 8,
            R.id.button9 to 9
        )
        numberButtons.forEach { (buttonId, number) ->
            findViewById<MaterialButton>(buttonId).setOnClickListener {
                updateDisplay(calculator.inputDigit(number))
            }
        }
    }

    private fun bindActionButtons() {
        setClick(R.id.buttonClear) { calculator.clear() }
        setClick(R.id.buttonSign) { calculator.toggleSign() }
        setClick(R.id.buttonPercent) { calculator.percent() }
        setClick(R.id.buttonDecimal) { calculator.inputDecimal() }
        setClick(R.id.buttonAdd) { calculator.setOperator(CalculatorEngine.Operator.ADD) }
        setClick(R.id.buttonSubtract) { calculator.setOperator(CalculatorEngine.Operator.SUBTRACT) }
        setClick(R.id.buttonMultiply) { calculator.setOperator(CalculatorEngine.Operator.MULTIPLY) }
        setClick(R.id.buttonDivide) { calculator.setOperator(CalculatorEngine.Operator.DIVIDE) }
        setClick(R.id.buttonEquals) { calculator.equals() }
    }

    private fun setClick(buttonId: Int, action: () -> String) {
        findViewById<MaterialButton>(buttonId).setOnClickListener {
            updateDisplay(action())
        }
    }

    private fun updateDisplay(value: String) {
        displayText.text = value.replace('.', ',')
    }
}

