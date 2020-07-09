FROM ruby:2.7.1-slim

ENV dir /usr/src/app

RUN mkdir -p ${dir}
WORKDIR ${dir}

RUN echo 'gem: --no-ri --no-rdoc' > ~/.gemrc

COPY Gemfile ${dir}
COPY Gemfile.lock ${dir}

RUN gem install bundler

RUN bundle config --global jobs $(($(nproc) * 2)) && \
    bundle install

COPY . ${dir}
