#!/usr/bin/with-contenv bash

echo "Adding custom extensions..."
mkdir -p /data/assets /data/extensions/.cache /data/storage
touch /data/extensions/list

# Auto-add extensions
echo $'\n\
andre-pullinen/ads\n\
migratetoflarum/fake-data\n\
fof/default-group\n\
fof/recaptcha\n\
AlexanderOMara/flarum-gravatar\n\
fof/socialprofile\n\
fof/share-social\n\
fof/nightmode\n\
therealsujitk/flarum-ext-gifs\n\
zerosonesfun/elint\n\
fof/pretty-mail\n\
fof/realtimelogin\n\
fof/realtimedate\n\
nearata/flarum-ext-tags-color-generator\n\
therealsujitk/flarum-ext-hljs\n\
fof/drafts\n\
askvortsov/flarum-discussion-templates\n\
fof/split\n\
fof/merge-discussions\n\
fof/formatting\n\
dem13n/topic-starter-label\n\
fof/best-answer\n\
flarumite/simple-discussion-views\n\
fof/impersonate\n\
fof/masquerade\n\
fof/disposable-emails\n\
fof/stopforumspam\n\
fof/filter\n\
fof/links\n\
davwheat/custom-sidenav-links\n\
fof/frontpage\n\
askvortsov/flarum-categories\n\
dem13n/discussion-cards\n\
fof/pages\n\
fof/custom-footer\n\
fof/terms\n\
fof/analytics\n\
fof/byobu\n\
askvortsov/flarum-pwa\n\
v17development/flarum-blog\n\
blomstra/payments'> /data/extensions/list

# fof/gamification\n\
# fof/html-errors\n\
# v17development/flarum-seo\n\

if [ -s "/data/extensions/list" ]; then
  while read extension; do
    test -z "${extension}" && continue
    extensions="${extensions}${extension} "
  done < /data/extensions/list
  echo "Installing additional customs extensions..."
  COMPOSER_CACHE_DIR="/data/extensions/.cache" yasu flarum:flarum composer config repositories.blomstra composer https://extiverse.com/composer/
  COMPOSER_CACHE_DIR="/data/extensions/.cache" yasu flarum:flarum composer config --global --auth bearer.extiverse.com ${EXTIVERSE_TOKEN}
  COMPOSER_CACHE_DIR="/data/extensions/.cache" yasu flarum:flarum composer require --working-dir /opt/flarum ${extensions}
fi

yasu flarum:flarum php flarum migrate
yasu flarum:flarum php flarum cache:clear