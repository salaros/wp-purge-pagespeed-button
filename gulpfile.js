var gulp = require('gulp'),
    sass = require('gulp-sass'),
    autoprefixer = require('gulp-autoprefixer'),
    sourcemaps = require('gulp-sourcemaps'),
    rename = require('gulp-rename'),
    cssnano = require('gulp-cssnano'),
    uglify = require('gulp-uglify');

gulp.task('default', [ 'scss-compile', 'js-minify' ]);

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

gulp.task('js-minify', function () {
    gulp.src("./assets/**/*.js")
        .pipe(sourcemaps.init())
        .pipe(uglify())
        .pipe(rename({
            suffix: ".min",
        }))
        .pipe(sourcemaps.write('.', { addComment: false }))
        .pipe(gulp.dest("assets/"));
});
