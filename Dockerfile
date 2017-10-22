FROM rails:onbuild
ENV RAILS_ENV=production
CMD ["bundle", "exec", "rackup", "--port", "8080", "-o", "0.0.0.0"]
