var gulp = require('gulp');
var util = require('gulp-util');
var jasmine = require('gulp-jasmine');
var spawn = require('child_process').spawn;
var watching = false;
var index;
var tests_running = false;

if ((index = process.argv.indexOf('--watch')) >= 0) {
  process.argv.splice(index, 1);
  watching = true;
}

function abort_tests() {
  if (tests_running) tests_running.kill();
}

function run_tests(cb) {
  if (tests_running) abort_tests();
  tests_running = spawn('gulp', ['test'], {
    stdio: 'inherit'
  }).
    on('exit', function() {
      tests_running = false;
      if (typeof cb === "function") cb();
    });
  return tests_running;
}

if (watching && process.argv.indexOf('test') >= 0) {
  gulp.watch(['src/**/*.coffee', 'test/global.js', 'test/**/*.spec.coffee'], run_tests);
}

gulp.task('test', function() {
  return gulp.src(['test/global.js', 'test/**/*.spec.coffee']).
    pipe(jasmine({
      verbose: false,
      includeStackTrace: true
    }));
});
