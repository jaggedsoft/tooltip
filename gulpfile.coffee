gulp = require('gulp')
coffee = require('gulp-coffee')
compass = require('gulp-compass')
concat = require('gulp-concat')
uglify = require('gulp-uglify')
header = require('gulp-header')
rename = require('gulp-rename')
bower = require('gulp-bower')

pkg = require('./package.json')
banner = "/*! #{ pkg.name } #{ pkg.version } */\n"

gulp.task 'bower', ->
  bower().pipe(gulp.dest('./bower_components'))

gulp.task 'coffee', ->
  gulp.src('coffee/*')
    .pipe(coffee())
    .pipe(gulp.dest('./js/'))

  gulp.src('docs/welcome/coffee/*')
    .pipe(coffee())
    .pipe(gulp.dest('./docs/welcome/js/'))

gulp.task 'concat', ->
  gulp.src(['./bower_components/tether/tether.js', './bower_components/drop/js/drop.js', './js/tooltip.js'])
    .pipe(concat('tooltip.js'))
    .pipe(header(banner))
    .pipe(gulp.dest('./'))

gulp.task 'uglify', ->
  gulp.src('./tooltip.js')
    .pipe(uglify())
    .pipe(header(banner))
    .pipe(rename('tooltip.min.js'))
    .pipe(gulp.dest('./'))

gulp.task 'js', ->
  gulp.run 'coffee', 'concat', 'uglify'

gulp.task 'compass', ->
  for path in ['', 'docs/welcome/']
    gulp.src("./#{ path }sass/*")
      .pipe(compass(
        sass: "#{ path }sass"
        css: "#{ path }css"
        comments: false
      ))
      .pipe(gulp.dest("./#{ path }css"))

gulp.task 'default', ->
  gulp.run 'bower', ->
    gulp.run 'js', 'compass'

  gulp.watch './coffee/*', ->
    gulp.run 'js'

  gulp.watch './**/*.sass', ->
    gulp.run 'compass'
