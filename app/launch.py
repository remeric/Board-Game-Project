#Application to help users select a boardgame to play based on parameters

#Using flask to present app via web when I launch app in Azure/AWS

#Import flask module
from flask import Flask, request, render_template, jsonify, redirect
from flask.sessions import NullSession
from flask_wtf import FlaskForm
from wtforms import SubmitField, IntegerField

app = Flask(__name__)
app.config['SECRET_KEY'] = 'testtesttest'

@app.route('/')
def entry():
    return redirect('/form')

@app.route('/form', methods=['GET', 'POST'])
def form():
    
    class BGForm(FlaskForm):
        players = IntegerField('Number of Players')
        playtime = IntegerField('Time available to play')
        Submit = SubmitField('Submit')

    class BoardGame:
        
        def __init__(self, name, playersmin, playersmax, time, timeperplayer):
            self.name = name
            self.playersmin = playersmin
            self.playersmax = playersmax
            self.time = time
            self.timeperplayer = timeperplayer

    #Fucntion to calculate total play time
        def total_time(self):
            if self.timeperplayer == True:
                return self.time * form.players.data
            else:
                return self.time

    #Board Game List
    list = []
    list.append( BoardGame("Splendor", 2, 4, 60, False))
    list.append( BoardGame("StockPile", 2, 5, 45, False))
    list.append( BoardGame("Terra Mystica", 2, 5, 30, True))
    list.append( BoardGame("Mage Knight", 1, 4, 180, False))
    list.append( BoardGame("Star Realms", 2, 2, 20, False))
    list.append( BoardGame("Viticulture", 1, 6, 90, False))
    list.append( BoardGame("Tesla vs Edison", 2, 6, 20, True))

    form = BGForm()

    if form.validate_on_submit():
        availablegames = ["Games available to play - if the following lines are blank there are no games avaiable within your constraints:"]
        for obj in list:
            allthattime = obj.total_time()
            if form.players.data >= obj.playersmin:
                if form.players.data <= obj.playersmax:
                    if form.playtime.data >= allthattime:
                        availablegames.append ("The game " + obj.name + " is available and takes " + str(obj.total_time()) + " minutes to play.")

        return jsonify(availablegames)
    return render_template('form.html', form=form)

if __name__== '__main__':
    app.run(host="localhost",port=80,debug=True)
 
    


