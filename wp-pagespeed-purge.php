<?php
/**
* Plugin Name: PageSpeed Cache Purge
* Plugin URI:  https://github.com/salaros/wp-pagespeed-purge
* Description: One-click PageSpeed cache purging using an admin bar button
* Version:     1.0.0
* Author:      Zhmayev Yaroslav aka Salaros
* Author URI:  https://salaros.com
* License:     MIT
* License URI: https://opensource.org/licenses/MIT
* Text Domain: wp-pagespeed-purge
*/

if ( ! defined( 'ABSPATH' ) ) exit; // Exit if accessed directly.

class PageSpeedPurge {

	public function __construct() {
		//sets the default trading hour days (used by the content type)
		add_action( 'admin_enqueue_scripts', array( $this, 'embed_admin_assets' ), 101 );

		// Add 'Clear Redis cache' button to the admin bar
		add_action( 'admin_bar_menu', array( $this, 'add_admin_bar_button' ), 101 );
	}

	public function embed_admin_assets() {
		// This is where you can add your CSS/JS entries for wp-admin UI
		$plugin_url = plugin_dir_url( __FILE__ );
		wp_enqueue_style( 'admin-styles', sprintf( '%s/assets/admin.css', $plugin_url ) );
		wp_enqueue_script( 'admin-styles', sprintf( '%s/assets/admin.js', $plugin_url ) );
	}

	public function add_admin_bar_button( $wp_admin_bar ) {
		$args = [
			'id'	=> 'pagespeed_purge',
			'title' => 'Clear Pagespeed Cache',
			'href' => '#pagespeed_purge',
		];

		$wp_admin_bar->add_menu( $args );
	}
}

new PageSpeedPurge();
