## Input from user
print("Enter number of players")
players = int(input())
print("Enter Time you have")
playtime = int(input())

##Class for storing Board Games and their attributes
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
            return self.time * players
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


print("Games you can play:")
print("")

#For loop to determine playable games, then print games to the user
for obj in list:
    allthattime = obj.total_time()
    if players >= obj.playersmin:
        if players <= obj.playersmax:
            if playtime >= allthattime:
                print("The game", obj.name, "is available and takes", obj.total_time(), "minutes to play.")
