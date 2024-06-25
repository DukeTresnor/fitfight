# fitfight

# Developer notes
#   Collisions
#     Pushback needs to occur in the proper direction
#	  Pushback needs to be applied according to the amount given during signal
#       output. How should this be determined? How do other games do it?
#		I have a pushback "amount," but what does this mean in terms of actual
#         gameplay? A pushback duration, a pushback amount, a pushback velocity?
#       More research or theroycraffting is needed
#	  Pushback needs to apply to the attacker when in the corner
#       Reference: https://game.capcom.com/cfn/sfv/column/131545?lang=en#:~:text=Pushback%3A%20Hit%2FBlock&text=The%20opponent%20is%20pushed%20back,its%20own%20unique%20pushback%20distance.
#       Currently when a collision occurs, the player getting hit applies pushback
#         to themselves according to data that was sent through signals at the
#		  time of collision. How to apply pushback to the attacker?
#       One option is, at the time of collision, do a check on the defender's
#         position. If their position is at the corner, then do 2 things:
#		    1. Don't send pushback information to the defender (or send 0
#			  pushback)
#			2. Apply that pushback to the attacker
# 	  Cancelable strings
#       Current logic for canceling moves into others doesn't retrigger collisions,
#		  despite re-enterin the proper attack state. Not sure of the solution
#         just yet
#   Menu
#     Smooth transitions between game modes is needed
