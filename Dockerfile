FROM ruby:2.4.2-onbuild
ENV RAILS_ENV=production
CMD ["bundle", "exec", "rackup", "--port", "8080", "-o", "0.0.0.0"]
