# Sometimes nodemon tries to restart the server without properly
# closing the port. In a result, it fails. We may need to explicitly
# kill the previous process using this script. API_PORT is given in .env file.
#
# If nodemon can restart the server properly, it will show something like
# this on terminal-
# iclp-api is running at port: API_PORT
# 
# If it does not show,
# kill the process which is using port API_PORT-
if [ -f .env ]; then export $(cat .env | xargs); fi
tmp=($(lsof -i :$API_PORT))
if [[ ${#tmp[@]} -gt 10 ]]; then
    pid=${tmp[10]};
    kill $pid;
    echo "killed PID $pid";
fi