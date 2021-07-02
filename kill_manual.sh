# Sometimes nodemon tries to restart the server without properly
# closing the port. In a result, it fails. We may need to explicitly
# kill the previous process using this script.
#
# If nodemon can restart the server properly, it will show something like
# this on terminal-
# iclp-api is running at port: 5000
#
# I assumed, api is running at port no 5000, use correct
# port number if you change API_PORT variable in .env file

tmp=($(lsof -i :5000));
if [[ ${#tmp[@]} -gt 10 ]]; then
    pid=${tmp[10]};
    kill $pid;
    echo "killed PID $pid";
fi