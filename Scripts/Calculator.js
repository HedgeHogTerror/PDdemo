var curVal = 0
var memory = 0
var lastOp = ""
var timer = 0

var division = "\u00f7"
var multiplication = "\u00d7"
var squareRoot = "\u221a"
var plusminus = "\u00b1"
var rotateLeft = "\u2939"
var rotateRight = "\u2935"
var leftArrow = "\u2190"

function disabled(op) {
    if (op == "." && currentValueDisplay.text.toString().search(/\./) != -1) {
        return true
    } else if (op == squareRoot &&  currentValueDisplay.text.toString().search(/-/) != -1) {
        return true
    } else {
        return false
    }
}

function op(op) {
    if (disabled(op)) {
        return
    }

    if (op.toString().length==1 && ((op >= "0" && op <= "9") || op==".") ) {
        if (currentValueDisplay.text.toString().length >= 14)
            return; // No arbitrary length numbers
        if (lastOp.toString().length == 1 && ((lastOp >= "0" && lastOp <= "9") || lastOp == ".") ) {
            currentValueDisplay.text = currentValueDisplay.text + op.toString()
        } else {
            currentValueDisplay.text = op
        }
        lastOp = op
        return
    }
    lastOp = op

    if (currentOperation.text == "+") {
        currentValueDisplay.text = Number(currentValueDisplay.text.valueOf()) + Number(curVal.valueOf())
    } else if (currentOperation.text == "-") {
        currentValueDisplay.text = Number(curVal) - Number(currentValueDisplay.text.valueOf())
    } else if (currentOperation.text == multiplication) {
        currentValueDisplay.text = Number(curVal) * Number(currentValueDisplay.text.valueOf())
    } else if (currentOperation.text == division) {
        currentValueDisplay.text = Number(Number(curVal) / Number(currentValueDisplay.text.valueOf())).toString()
    } else if (currentOperation.text == "=") {
    }

    if (op == "+" || op == "-" || op == multiplication || op == division) {
        currentOperation.text = op
        curVal = currentValueDisplay.text.valueOf()
        return
    }

    curVal = 0
    currentOperation.text = ""

    if (op == "1/x") {
        currentValueDisplay.text = (1 / currentValueDisplay.text.valueOf()).toString()
    } else if (op == "x^2") {
        currentValueDisplay.text = (currentValueDisplay.text.valueOf() * currentValueDisplay.text.valueOf()).toString()
    } else if (op == "Abs") {
        currentValueDisplay.text = (Math.abs(currentValueDisplay.text.valueOf())).toString()
    } else if (op == "Int") {
        currentValueDisplay.text = (Math.floor(currentValueDisplay.text.valueOf())).toString()
    } else if (op == plusminus) {
        currentValueDisplay.text = (currentValueDisplay.text.valueOf() * -1).toString()
    } else if (op == squareRoot) {
        currentValueDisplay.text = (Math.sqrt(currentValueDisplay.text.valueOf())).toString()
    } else if (op == "mc") {
        memory = 0;
    } else if (op == "m+") {
        memory += currentValueDisplay.text.valueOf()
    } else if (op == "mr") {
        currentValueDisplay.text = memory.toString()
    } else if (op == "m-") {
        memory = currentValueDisplay.text.valueOf()
    } else if (op == leftArrow) {
        currentValueDisplay.text = currentValueDisplay.text.toString().slice(0, -1)
        if (currentValueDisplay.text.length == 0) {
            currentValueDisplay.text = "0"
        }
    } else if (op == "Off") {
        Qt.quit();
    } else if (op == "C") {
        currentValueDisplay.text = "0"
    } else if (op == "AC") {
        curVal = 0
        memory = 0
        lastOp = ""
        currentValueDisplay.text ="0"
    }
}
