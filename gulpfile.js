var gulp = require('gulp'),
    sass = require('gulp-sass'),
    autoprefixer = require('gulp-autoprefixer'),
    sourcemaps = require('gulp-sourcemaps'),
    rename = require('gulp-rename'),
    cssnano = require('gulp-cssnano');

gulp.task('default', [ 'scss-compile' ]);

gulp.task('scss-compile', function () {
    gulp.src("./assets/**/*.scss")
        .pipe(sourcemaps.init())
        .pipe(sass().on('error', sass.logError))
        .pipe(autoprefixer({
            browsers: ['last 2 versions'],
            cascade: false
        }))
        .pipe(gulp.dest("assets/"))
        .pipe(cssnano())
        .pipe(rename({
            suffix: ".min",
        }))
        .pipe(sourcemaps.write("./", {addComment: false}))
        .pipe(gulp.dest("assets/"));
});
