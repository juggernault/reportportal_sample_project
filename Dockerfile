# XXX todo: add following to jenkins job, somewhere.


# Base the image off of the latest pre-built ruby image
FROM ruby:2.4
ENV DEBIAN_FRONTEND noninteractive
# make and switch to the /code directory which will hold the tests

RUN mkdir /code
WORKDIR /code

RUN mkdir output && chmod a+w output && mkdir output/logs
# move over the Gemfile and Gemfile.lock before the rest so that we can cache the installed gems
ADD Gemfile /code/Gemfile
ADD Gemfile.lock /code/Gemfile.lock
# Copy credenfials config (specific for zooplapro tests)
ADD config/credentials_automation.yml.examples /code/config/credentials.yml
ADD config/report_portal.yml /code/report_portal.yml
# upgrade to latest version of bundler
RUN gem install bundler -v 1.14.6
# install all the gems specified by the gemfile
RUN bundle install

RUN echo "deb http://dl.google.com/linux/chrome/deb/ stable main" | tee -a /etc/apt/sources.list
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN apt-get update && \
    apt-get -qq -y install xvfb iceweasel \
                           libxpm4 libxrender1 libgtk2.0-0 libnss3 libgconf-2-4 \
                           libpango1.0-0 libxss1 libxtst6 fonts-liberation libappindicator1 xdg-utils

#keep this comment till the issue with latest chrome version will get sorted
#RUN apt-get -y install google-chrome-stable

# copy .deb package *only* into the container
ADD drivers/chrome64_55.deb /code/drivers/chrome64_55.deb
#Using chrome version 55 from /drivers
RUN dpkg -i /code/drivers/chrome64_55.deb
RUN apt-get install -f
RUN apt-get -y install \
               xvfb gtk2-engines-pixbuf \
               xfonts-cyrillic xfonts-100dpi xfonts-75dpi xfonts-base xfonts-scalable \
               imagemagick x11-apps zip



#RUN wget -O /tmp/chromedriver.zip https://chromedriver.storage.googleapis.com/2.27/chromedriver_linux64.zip
#RUN unzip /tmp/chromedriver.zip chromedriver -d /usr/local/bin/
#RUN chmod ugo+rx /drivers/linux/chromedriver
RUN Xvfb -ac :99 -screen 0 1680x1050x24 &
RUN export DISPLAY=:99

# copy over the rest of the tests
ADD . /code

