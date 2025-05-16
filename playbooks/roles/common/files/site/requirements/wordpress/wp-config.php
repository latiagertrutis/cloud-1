<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the installation.
 * You don't have to use the website, you can copy this file to "wp-config.php"
 * and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * Database settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://developer.wordpress.org/advanced-administration/wordpress/wp-config/
 *
 * @package WordPress
 */

// ** Database settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpress' );

/** Database username */
define( 'DB_USER', getenv('MYSQL_USER'));

/** Database password */
define( 'DB_PASSWORD', getenv('MYSQL_PASSWORD'));

/** Database hostname */
define( 'DB_HOST', 'mariadb' );

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

// ** Redis settings ** //
define( 'WP_REDIS_HOST', 'redis' );
define( 'WP_REDIS_PORT', 6379 );
define( 'FS_METHOD', 'direct' );

/**#@+
 * Authentication unique keys and salts.
 *
 * Change these to different unique phrases! You can generate these using
 * the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.
 *
 * You can change these at any point in time to invalidate all existing cookies.
 * This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         'c7Z^7xB|l{K)vu0r>d+J_g?]p,&llo[+#e.fi8*EifYHl4DXJ*$Bxe2@-`N6_zJ>');
define('SECURE_AUTH_KEY',  'H$|&-[vC]*H,v7!]f(|OM 7kd*I+C]YT)2.(%M.k`i+}RS2({4~=uf!DBms-GAqg');
define('LOGGED_IN_KEY',    '^M8tX]k-TZ1<7.c<*+_G+VdC?uV<j1.,K<M,{ov]:t;m>lVZ-?sB-e|DhO/HLLsr');
define('NONCE_KEY',        'ih|%KeL7)raOea#Q/R,,GDS+^`W=gwe<s6R(!HzGwerJ(L doszRru+!-taszMEX');
define('AUTH_SALT',        'c>2P803B,{@+4V`hu28o*=x%G=L6;){gy[]{]#E{Z^1!AIOgAi5+L|&[Ec}D|@fc');
define('SECURE_AUTH_SALT', 'ZRZ.oh-7TTT$-!&nLX~RKF{9$XeuZ(Px*IgXn%2MBDg.I4&oL35_*x6}af*.lr$x');
define('LOGGED_IN_SALT',   '=ELH+V|VR|uM+IY=LOt(dd,C.a2+N|kiX]oBdR_NLK3c$YLC&#K{| W[zKc7{6&)');
define('NONCE_SALT',       'XU-LjkL6?f6IR4n9Ud/A4+_0OiBe!U(YnH4}#]+3*m>*j~9&lexy`s EbhD0H*a5');

/**#@-*/

/**
 * WordPress database table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 *
 * At the installation time, database tables are created with the specified prefix.
 * Changing this value after WordPress is installed will make your site think
 * it has not been installed.
 *
 * @link https://developer.wordpress.org/advanced-administration/wordpress/wp-config/#table-prefix
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://developer.wordpress.org/advanced-administration/debug/debug-wordpress/
 */
define( 'WP_DEBUG', false );

/* Add any custom values between this line and the "stop editing" line. */



/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';