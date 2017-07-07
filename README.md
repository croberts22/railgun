<h3 align="center">
  <img src="http://i.imgur.com/WaxRVGs.png" alt="Railgun" />
</h3>


[![Twitter](https://img.shields.io/badge/contact-%40spacepyro-00aced.svg)](https://twitter.com/spacepyro)
[![GitHub license](https://img.shields.io/github/license/mashape/apistatus.svg)](http://choosealicense.com/licenses/mit/)
[![Build Status](https://travis-ci.org/croberts22/railgun.svg?branch=master)](https://travis-ci.org/croberts22/railgun)
[![Coverage Status](https://coveralls.io/repos/github/croberts22/railgun/badge.svg?branch=master)](https://coveralls.io/github/croberts22/railgun?branch=master)


Railgun is a REST API extension to the [MyAnimeList API](http://myanimelist.net/modules.php?go=api).

## Motivation

Previously, a separate project dedicated to providing a richer developer experience was derived from [chuyeow](https://github.com/chuyeow)'s fantastic [myanimelist-api](https://github.com/chuyeow/myanimelist-api). It seems like that project is no longer in development, nor does it seem like there is any interest in reviving the endpoints. So, I've decided to take in the responsibility of creating my own so that people can harness a stronger, dedicated API. Furthermore, MyAnimeList's official API hasn't been updated in several years, stagnating development.

Learning a few new languages and technologies is also a New Year's Resolution of mine. I'm not familiar with Ruby and Sinatra, so I've decided to dedicate this project for my own learning's sake.

## Requirements

- A User-Agent from MyAnimeList.net
- Ruby 2.2.1 or greater

## How to Use

- Clone this repository. 👌
- Run `bundle install` to install all of the dependencies.
- Set up your environment variables to include your User-Agent. This environment variable must be set up as `ENV['USER_AGENT']` (see `keys.rb`).
- If you have an instance of Rollbar running, you can also set up your access token via `ENV['ROLLBAR_ACCESS_TOKEN']`.
- If you have RubyMine, you can open this app and configure it to run `config.ru`. Otherwise, open up a terminal prompt and start it with the following command:

```
rackup -o 0.0.0.0 -p 9292 config.ru
```

- This project also supports `memcached`. You can run your instance of `memcached` and it will work out of the box.


## API Documentation

The interactive API is currently under construction, but you can check it out [here](http://docs.railgun.apiary.io/).

## Why the name "Railgun"?

A few reasons:

- Railguns are blazingly fast, efficient, and powerful. Those are the principles for what this API will accomplish.

- It's the nickname given to [Misaka Mikoto](http://myanimelist.net/character/13701/Mikoto_Misaka) from [A Certain Scientific Railgun](http://myanimelist.net/anime/6213/Toaru_Kagaku_no_Railgun).
![](http://i.imgur.com/74Zdsnu.png)

- It just sounds badass.

## Licensing

The MIT License (MIT)

Copyright (c) 2017 Corey Roberts

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
