from flask import Flask, render_template

app = Flask(__name__)


@app.route("/")
def dashboard() -> str:
    rooms = [
        {"name": "Living Room", "temp": "72°F", "lights": "On", "security": "Secure"},
        {"name": "Kitchen", "temp": "70°F", "lights": "Off", "security": "Secure"},
        {"name": "Bedroom", "temp": "68°F", "lights": "Dim", "security": "Secure"},
        {"name": "Garage", "temp": "65°F", "lights": "Off", "security": "Door Closed"},
    ]

    quick_actions = [
        {"label": "All Lights Off", "icon": "💡"},
        {"label": "Arm Security", "icon": "🛡️"},
        {"label": "Eco Mode", "icon": "🌿"},
        {"label": "Good Night", "icon": "🌙"},
    ]

    return render_template("index.html", rooms=rooms, quick_actions=quick_actions)


if __name__ == "__main__":
    app.run(debug=True)
