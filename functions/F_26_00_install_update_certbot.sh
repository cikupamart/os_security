# =====================
# Enable databag
# =====================
# RENDER_CP

# ******* Define var *******
local certbot_root="/opt"
local certbot_path="${certbot_root}/certbot"
local certbot_command="${certbot_path}/certbot-auto"

# ******* Fetching / Update certbot *******
if [ -d $certbot_path ]
then
  echo "---Updating CERTBOT---"
  cd $certbot_path
  git pull
else
  echo "---Downloading CERTBOT---"
  cd $certbot_root
  git clone $certbot_src_url
fi

echo "disable httpd server..."
systemctl disable httpd
systemctl stop httpd

# ******* Install certbot renew script *******
echo "========================================="
echo "   Install certbot renew script"
echo "========================================="
local file_certbot_confs=($(find ${CONFIG_FOLDER} -type f))
local file_certbot_target=""
local file_certbot_target_folder=""
for file_certbot_conf in ${file_certbot_confs[@]}
do
  file_certbot_target="${file_certbot_conf/${CONFIG_FOLDER}/}"
  file_certbot_target_folder="$(dirname $file_certbot_target)"

  test -d $file_certbot_target_folder || mkdir -p $file_certbot_target_folder
  echo "Setting up config file \"${file_certbot_target}\"......"
  \cp -a --backup=t $file_certbot_conf $file_certbot_target

  # ********* Only Chmod certbot-auto_renew  ********
  if [ "$(basename $file_certbot_target)" = "certbot-auto_renew" ]
  then
    chmod 777 $file_certbot_target
    # *********************************
    # Adding certificates renewal into crontab
    # *********************************
    echo "Adding cert renewal into crontab..."
    sed -i /certbot-auto_renew/d /etc/crontab
    echo "1 3 * * * root ${file_certbot_target}" >> /etc/crontab
  fi
done

