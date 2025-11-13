#git init
echo "name of folder"
read folder
mkdir $folder
cd $folder
pwd
echo "file name"
read  name
touch $name
echo "enter content of file"
read content
echo $content > $name

echo "enter username"
read uname
echo "enter email"
read email
git config --global user.email "$email"
git config --global user.name "$uname"
git init
git add $name
echo "enter commit msg"
read commitmsg
git commit -m "$commitmsg"
echo "enter repo link"
read origin
git remote add origin "$origin"
git checkout -b main

echo "enter github username"
read git_uname
echo "enter finegrane token"
read tk
full_url="https://${git_uname}:${tk}@${origin#https://}"

git push "${full_url}" main 2> /dev/null

# Check the exit status of the previous command (git push)
if [ $? -eq 0 ]; then
    echo "Git push completed successfully."
else
    echo " Git push failed."
fi
