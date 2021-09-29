import pandas

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
        playtime = IntegerField('Time available to play in minutes')
        Submit = SubmitField('Submit')

    class BoardGame:
        
        def __init__(self, bgname, playersmin, playersmax, time, timeperplayer):
            self.bgname = bgname
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

    excel_import = pandas.read_excel('games.xlsx', sheet_name='sheet')

    list = []

    for index, row in excel_import.iterrows():
        list.append( BoardGame(str(row.bgname), int(row.playersmin), int(row.playersmax), int(row.time), bool(row.timeperplayer)))

    form = BGForm()

    if form.validate_on_submit():
        availablegames = ["Games available to play - if the following lines are blank there are no games avaiable within your constraints:"]
        for obj in list:
            allthattime = obj.total_time()
            if form.players.data >= obj.playersmin:
                if form.players.data <= obj.playersmax:
                    if form.playtime.data >= allthattime:
                        availablegames.append ("The game " + obj.bgname + " is available and takes " + str(obj.total_time()) + " minutes to play.")

        return jsonify(availablegames)
    return render_template('form.html', form=form)

if __name__== '__main__':
    app.run(host="0.0.0.0",port=80,debug=True)
 
    


