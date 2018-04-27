<?php
/**
* Plugin Name: PageSpeed Purge Button
* Plugin URI:  https://github.com/salaros/wp-purge-pagespeed-button
* Description: One-click PageSpeed cache purging using an admin bar button
* Version:     0.0.0
* Author:      Zhmayev Yaroslav aka Salaros
* Author URI:  https://salaros.com
* License:     MIT
* License URI: https://opensource.org/licenses/MIT
* Text Domain: wp-purge-pagespeed-button
* Domain Path: /languages/
*/

if ( ! defined( 'ABSPATH' ) ) {
	exit; // Exit if accessed directly.
}

class PageSpeedPurge {

	public function __construct() {
		// Enqueue css and js files
		if( ! is_admin() && is_admin_bar_showing() ) {
			add_action( 'wp_enqueue_scripts', array( $this, 'embed_admin_assets' ), 101 );
		} else {
			add_action( 'admin_enqueue_scripts', array( $this, 'embed_admin_assets' ), 101 );
		}

		// Add 'Clear Redis cache' button to the admin bar
		add_action( 'admin_bar_menu', array( $this, 'add_admin_bar_button' ), 101 );

		// Load plugin textdomain
		add_action( 'plugins_loaded', array( $this, 'load_plugin_textdomain' ) );
	}

	public function embed_admin_assets() {
		// This is where you can add your CSS/JS entries for wp-admin UI
		$plugin_url = plugin_dir_url( __FILE__ );
		$asset_suffix = ( defined( SCRIPT_DEBUG ) && ! empty( SCRIPT_DEBUG ) ) ? '.min' : '';
		wp_enqueue_style( 'admin-styles', sprintf( '%s/assets/wp-purge-pagespeed-button%s.css', $plugin_url, $asset_suffix ) );
		wp_enqueue_script( 'admin-styles', sprintf( '%s/assets/wp-purge-pagespeed-button%s.js', $plugin_url, $asset_suffix ), array( 'jquery' ) );
	}

	public function add_admin_bar_button( $wp_admin_bar ) {
		$args = [
			'id'	=> 'pagespeed_purge',
			'href'	=> '#pagespeed_purge',
			'title'	=> __( 'Purge Pagespeed Cache', 'wp-purge-pagespeed-button' ),
		];

		$wp_admin_bar->add_menu( $args );
	}

	public function load_plugin_textdomain() {
		$textdomain = 'wp-purge-pagespeed-button';
		$plugin_locale = apply_filters( 'plugin_locale', get_locale(), $textdomain );
		$plugin_dir = dirname( __FILE__ );

		// wp-content/languages/plugin-name/plugin-name-ru_RU.mo
		load_textdomain( $textdomain, sprintf( '%s/plugins/%s-%s.mo', WP_LANG_DIR , $textdomain, $plugin_locale ) );

		// wp-content/plugins/plugin-name/languages/plugin-name-ru_RU.mo
		load_textdomain( $textdomain, sprintf( '%s/languages/%s-%s.mo', $plugin_dir , $textdomain, $plugin_locale ) );
	}
}

add_action( 'plugins_loaded', function () {
    new PageSpeedPurge();
} );
