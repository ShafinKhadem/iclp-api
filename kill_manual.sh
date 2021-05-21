# Sometimes nodemon tries to restart the server without properly 
# closing the port. In a result, it fails. We may need to explicitly
# kill the previous process.
# 
# If nodemon can restart the server properly, it will show something like
# this on terminal-
# iclp-api is running at port: 5000
# 
# If it does not show,
# find the process which is using port 5000-
lsof -i :5000

# Result will be empty if no process is listenig to port 5000.
# Otherwise, something like this will show up
#
# COMMAND   PID     USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
# node    18320 mwashief   19u  IPv6 127040      0t0  TCP *:5000 (LISTEN)
#
# We can see process with PID = 18320 is listening to port 5000.
# We can run this command to kill the process-
kill -9 18320

# Make sure you use the correct PID shown earlier.
# It is more likely to be different from here.
#
#
# I assumed, api is running at port no 5000, use correct
# port number if you change API_PORT variable in .env file
