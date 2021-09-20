
print("Enter number of players")
players = int(input())
print("Enter Time you have")
playtime = int(input())

class BoardGame:
    
    def __init__(self, name, playersmin, playersmax, time, timeperplayer):
        self.name = name
        self.playersmin = playersmin
        self.playersmax = playersmax
        self.time = time
        self.timeperplayer = timeperplayer

    def total_time(self):
        if self.timeperplayer == True:
            return self.time * players
        else:
            return self.time

list = []

list.append( BoardGame("Splendor", 2, 4, 60, False))
list.append( BoardGame("StockPile", 2, 5, 45, False))
list.append( BoardGame("Terra Mystica", 2, 5, 30, True))

print("Games you can play:")
print("")

for obj in list:
    allthattime = obj.total_time()
    if players >= obj.playersmin:
        if players <= obj.playersmax:
            if playtime >= allthattime:
                print("This game is", obj.name, "and takes", obj.total_time(), "minutes to play.")
