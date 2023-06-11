SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

CREATE TABLE IF NOT EXISTS `acls` (
  `id` int(11) NOT NULL,
  `address` varchar(255) NOT NULL,
  `netmask` varchar(255) NOT NULL,
  `k` varchar(255) NOT NULL,
  `v` varchar(255) default NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dump dei dati per la tabella `acls`
--


-- --------------------------------------------------------

--
-- Struttura della tabella `changesets`
--

CREATE TABLE IF NOT EXISTS `changesets` (
  `id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `created_at` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `min_lat` int(11) default NULL,
  `max_lat` int(11) default NULL,
  `min_lon` int(11) default NULL,
  `max_lon` int(11) default NULL,
  `closed_at` timestamp NOT NULL default '0000-00-00 00:00:00',
  `num_changes` int(11) NOT NULL default '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dump dei dati per la tabella `changesets`
--


-- --------------------------------------------------------

--
-- Struttura della tabella `changeset_tags`
--

CREATE TABLE IF NOT EXISTS `changeset_tags` (
  `changeset_id` bigint(20) NOT NULL,
  `k` varchar(255) default '',
  `v` varchar(255) default ''
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dump dei dati per la tabella `changeset_tags`
--


-- --------------------------------------------------------

--
-- Struttura della tabella `client_applications`
--

CREATE TABLE IF NOT EXISTS `client_applications` (
  `id` int(11) NOT NULL,
  `name` varchar(255) default NULL,
  `url` varchar(255) default NULL,
  `support_url` varchar(255) default NULL,
  `callback_url` varchar(255) default NULL,
  `key` varchar(50) default NULL,
  `secret` varchar(50) default NULL,
  `user_id` int(11) default NULL,
  `created_at` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL default '0000-00-00 00:00:00',
  `allow_read_prefs` tinyint(1) NOT NULL default '0',
  `allow_write_prefs` tinyint(1) NOT NULL default '0',
  `allow_write_diary` tinyint(1) NOT NULL default '0',
  `allow_write_api` tinyint(1) NOT NULL default '0',
  `allow_read_gpx` tinyint(1) NOT NULL default '0',
  `allow_write_gpx` tinyint(1) NOT NULL default '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dump dei dati per la tabella `client_applications`
--


-- --------------------------------------------------------

--
-- Struttura della tabella `countries`
--

CREATE TABLE IF NOT EXISTS `countries` (
  `id` int(11) NOT NULL,
  `code` varchar(2) NOT NULL,
  `min_lat` double NOT NULL,
  `max_lat` double NOT NULL,
  `min_lon` double NOT NULL,
  `max_lon` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dump dei dati per la tabella `countries`
--


-- --------------------------------------------------------

--
-- Struttura della tabella `current_nodes`
--

CREATE TABLE IF NOT EXISTS `current_nodes` (
  `node_id` bigint(20) NOT NULL,
  `latitude` int(11) NOT NULL,
  `longitude` int(11) NOT NULL,
  `changeset_id` bigint(20) NOT NULL,
  `visible` tinyint(1) NOT NULL,
  `timestamp` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `tile` bigint(20) NOT NULL,
  `version` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dump dei dati per la tabella `current_nodes`
--


-- --------------------------------------------------------

--
-- Struttura della tabella `current_node_tags`
--

CREATE TABLE IF NOT EXISTS `current_node_tags` (
  `node_id` bigint(20) NOT NULL,
  `k` varchar(255) default '',
  `v` varchar(255) default ''
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dump dei dati per la tabella `current_node_tags`
--


-- --------------------------------------------------------

--
-- Struttura della tabella `current_relations`
--

CREATE TABLE IF NOT EXISTS `current_relations` (
  `relation_id` bigint(20) NOT NULL,
  `changeset_id` bigint(20) NOT NULL,
  `timestamp` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `visible` tinyint(1) NOT NULL,
  `version` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dump dei dati per la tabella `current_relations`
--


-- --------------------------------------------------------

--
-- Struttura della tabella `current_relation_members`
--

CREATE TABLE IF NOT EXISTS `current_relation_members` (
  `relation_id` bigint(20) NOT NULL,
  `member_type` int(11) NOT NULL,
  `member_id` bigint(20) NOT NULL,
  `member_role` varchar(255) NOT NULL,
  `sequence_id` int(11) NOT NULL default '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dump dei dati per la tabella `current_relation_members`
--


-- --------------------------------------------------------

--
-- Struttura della tabella `current_relation_tags`
--

CREATE TABLE IF NOT EXISTS `current_relation_tags` (
  `relation_id` bigint(20) NOT NULL,
  `k` varchar(255) default '',
  `v` varchar(255) default ''
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dump dei dati per la tabella `current_relation_tags`
--


-- --------------------------------------------------------

--
-- Struttura della tabella `current_ways`
--

CREATE TABLE IF NOT EXISTS `current_ways` (
  `way_id` bigint(20) NOT NULL,
  `changeset_id` bigint(20) NOT NULL,
  `timestamp` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `visible` tinyint(1) NOT NULL,
  `version` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dump dei dati per la tabella `current_ways`
--


-- --------------------------------------------------------

--
-- Struttura della tabella `current_way_nodes`
--

CREATE TABLE IF NOT EXISTS `current_way_nodes` (
  `way_id` bigint(20) NOT NULL,
  `node_id` bigint(20) NOT NULL,
  `sequence_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dump dei dati per la tabella `current_way_nodes`
--


-- --------------------------------------------------------

--
-- Struttura della tabella `current_way_tags`
--

CREATE TABLE IF NOT EXISTS `current_way_tags` (
  `way_id` bigint(20) NOT NULL,
  `k` varchar(255) default '',
  `v` varchar(255) default ''
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dump dei dati per la tabella `current_way_tags`
--


-- --------------------------------------------------------

--
-- Struttura della tabella `diary_comments`
--

CREATE TABLE IF NOT EXISTS `diary_comments` (
  `id` bigint(20) NOT NULL,
  `diary_entry_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `body` text NOT NULL,
  `created_at` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL default '0000-00-00 00:00:00'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dump dei dati per la tabella `diary_comments`
--


-- --------------------------------------------------------

--
-- Struttura della tabella `diary_entries`
--

CREATE TABLE IF NOT EXISTS `diary_entries` (
  `id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `title` varchar(255) NOT NULL,
  `body` text NOT NULL,
  `created_at` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL default '0000-00-00 00:00:00',
  `latitude` double default NULL,
  `longitude` double default NULL,
  `language_code` varchar(255) default 'en'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dump dei dati per la tabella `diary_entries`
--


-- --------------------------------------------------------

--
-- Struttura della tabella `friends`
--

CREATE TABLE IF NOT EXISTS `friends` (
  `id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `friend_user_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dump dei dati per la tabella `friends`
--


-- --------------------------------------------------------

--
-- Struttura della tabella `gps_points`
--

CREATE TABLE IF NOT EXISTS `gps_points` (
  `altitude` double default NULL,
  `trackid` int(11) NOT NULL,
  `latitude` int(11) NOT NULL,
  `longitude` int(11) NOT NULL,
  `gpx_id` bigint(20) NOT NULL,
  `timestamp` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `tile` bigint(20) default NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dump dei dati per la tabella `gps_points`
--


-- --------------------------------------------------------

--
-- Struttura della tabella `gpx_files`
--

CREATE TABLE IF NOT EXISTS `gpx_files` (
  `id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `visible` tinyint(1) NOT NULL default '1',
  `name` varchar(255) default '',
  `size` bigint(20) default NULL,
  `latitude` double default NULL,
  `longitude` double default NULL,
  `timestamp` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `description` varchar(255) default '',
  `inserted` tinyint(1) NOT NULL,
  `visibility` int(11) NOT NULL default '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dump dei dati per la tabella `gpx_files`
--


-- --------------------------------------------------------

--
-- Struttura della tabella `gpx_file_tags`
--

CREATE TABLE IF NOT EXISTS `gpx_file_tags` (
  `gpx_id` bigint(20) NOT NULL default '0',
  `tag` varchar(255) NOT NULL,
  `id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dump dei dati per la tabella `gpx_file_tags`
--


-- --------------------------------------------------------

--
-- Struttura della tabella `languages`
--

CREATE TABLE IF NOT EXISTS `languages` (
  `code` varchar(255) NOT NULL,
  `english_name` varchar(255) NOT NULL,
  `native_name` varchar(255) default NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dump dei dati per la tabella `languages`
--


-- --------------------------------------------------------

--
-- Struttura della tabella `messages`
--

CREATE TABLE IF NOT EXISTS `messages` (
  `id` bigint(20) NOT NULL,
  `from_user_id` bigint(20) NOT NULL,
  `title` varchar(255) NOT NULL,
  `body` text NOT NULL,
  `sent_on` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `message_read` tinyint(1) NOT NULL default '0',
  `to_user_id` bigint(20) NOT NULL,
  `to_user_visible` tinyint(1) NOT NULL default '1',
  `from_user_visible` tinyint(1) NOT NULL default '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dump dei dati per la tabella `messages`
--


-- --------------------------------------------------------

--
-- Struttura della tabella `nodes`
--

CREATE TABLE IF NOT EXISTS `nodes` (
  `node_id` bigint(20) NOT NULL,
  `latitude` int(11) NOT NULL,
  `longitude` int(11) NOT NULL,
  `changeset_id` bigint(20) NOT NULL,
  `visible` tinyint(1) NOT NULL,
  `timestamp` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `tile` bigint(20) NOT NULL,
  `version` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dump dei dati per la tabella `nodes`
--


-- --------------------------------------------------------

--
-- Struttura della tabella `node_tags`
--

CREATE TABLE IF NOT EXISTS `node_tags` (
  `node_id` bigint(20) NOT NULL,
  `version` bigint(20) NOT NULL,
  `k` varchar(255) default '',
  `v` varchar(255) default ''
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dump dei dati per la tabella `node_tags`
--


-- --------------------------------------------------------

--
-- Struttura della tabella `oauth_nonces`
--

CREATE TABLE IF NOT EXISTS `oauth_nonces` (
  `id` int(11) NOT NULL,
  `nonce` varchar(255) default NULL,
  `timestamp` int(11) default NULL,
  `created_at` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL default '0000-00-00 00:00:00'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dump dei dati per la tabella `oauth_nonces`
--


-- --------------------------------------------------------

--
-- Struttura della tabella `oauth_tokens`
--

CREATE TABLE IF NOT EXISTS `oauth_tokens` (
  `id` int(11) NOT NULL,
  `user_id` int(11) default NULL,
  `type` varchar(20) default NULL,
  `client_application_id` int(11) default NULL,
  `token` varchar(50) default NULL,
  `secret` varchar(50) default NULL,
  `authorized_at` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `invalidated_at` timestamp NOT NULL default '0000-00-00 00:00:00',
  `created_at` timestamp NOT NULL default '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL default '0000-00-00 00:00:00',
  `allow_read_prefs` tinyint(1) NOT NULL default '0',
  `allow_write_prefs` tinyint(1) NOT NULL default '0',
  `allow_write_diary` tinyint(1) NOT NULL default '0',
  `allow_write_api` tinyint(1) NOT NULL default '0',
  `allow_read_gpx` tinyint(1) NOT NULL default '0',
  `allow_write_gpx` tinyint(1) NOT NULL default '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dump dei dati per la tabella `oauth_tokens`
--


-- --------------------------------------------------------

--
-- Struttura della tabella `relations`
--

CREATE TABLE IF NOT EXISTS `relations` (
  `relation_id` bigint(20) NOT NULL default '0',
  `changeset_id` bigint(20) NOT NULL,
  `timestamp` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `version` bigint(20) NOT NULL,
  `visible` tinyint(1) NOT NULL default '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dump dei dati per la tabella `relations`
--


-- --------------------------------------------------------

--
-- Struttura della tabella `relation_members`
--

CREATE TABLE IF NOT EXISTS `relation_members` (
  `relation_id` bigint(20) NOT NULL default '0',
  `member_type` varchar(20) NOT NULL,
  `member_id` bigint(20) NOT NULL,
  `member_role` varchar(255) NOT NULL,
  `version` bigint(20) NOT NULL default '0',
  `sequence_id` int(11) NOT NULL default '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dump dei dati per la tabella `relation_members`
--


-- --------------------------------------------------------

--
-- Struttura della tabella `relation_tags`
--

CREATE TABLE IF NOT EXISTS `relation_tags` (
  `relation_id` bigint(20) NOT NULL default '0',
  `k` varchar(255) default '',
  `v` varchar(255) default '',
  `version` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dump dei dati per la tabella `relation_tags`
--


-- --------------------------------------------------------

--
-- Struttura della tabella `schema_migrations`
--

CREATE TABLE IF NOT EXISTS `schema_migrations` (
  `version` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dump dei dati per la tabella `schema_migrations`
--


-- --------------------------------------------------------

--
-- Struttura della tabella `sessions`
--

CREATE TABLE IF NOT EXISTS `sessions` (
  `id` int(11) NOT NULL,
  `session_id` varchar(255) default NULL,
  `DATA` text,
  `created_at` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL default '0000-00-00 00:00:00'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dump dei dati per la tabella `sessions`
--


-- --------------------------------------------------------

--
-- Struttura della tabella `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `email` varchar(255) NOT NULL,
  `id` bigint(20) NOT NULL,
  `active` int(11) NOT NULL default '0',
  `pass_crypt` varchar(255) NOT NULL,
  `creation_time` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `display_name` varchar(255) default '',
  `data_public` tinyint(1) NOT NULL default '0',
  `description` text NOT NULL,
  `home_lat` double default NULL,
  `home_lon` double default NULL,
  `home_zoom` smallint(6) default '3',
  `nearby` int(11) default '50',
  `pass_salt` varchar(255) default NULL,
  `image` text,
  `email_valid` tinyint(1) NOT NULL default '0',
  `new_email` varchar(255) default NULL,
  `visible` tinyint(1) NOT NULL default '1',
  `creation_ip` varchar(255) default NULL,
  `languages` varchar(255) default NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dump dei dati per la tabella `users`
--


-- --------------------------------------------------------

--
-- Struttura della tabella `user_blocks`
--

CREATE TABLE IF NOT EXISTS `user_blocks` (
  `id` int(11) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `creator_id` bigint(20) NOT NULL,
  `reason` text NOT NULL,
  `ends_at` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `needs_view` tinyint(1) NOT NULL default '0',
  `revoker_id` bigint(20) default NULL,
  `created_at` timestamp NOT NULL default '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL default '0000-00-00 00:00:00'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dump dei dati per la tabella `user_blocks`
--


-- --------------------------------------------------------

--
-- Struttura della tabella `user_preferences`
--

CREATE TABLE IF NOT EXISTS `user_preferences` (
  `user_id` bigint(20) NOT NULL,
  `k` varchar(255) NOT NULL,
  `v` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dump dei dati per la tabella `user_preferences`
--


-- --------------------------------------------------------

--
-- Struttura della tabella `user_roles`
--

CREATE TABLE IF NOT EXISTS `user_roles` (
  `id` int(11) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `created_at` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL default '0000-00-00 00:00:00',
  `role` int(11) NOT NULL,
  `granter_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dump dei dati per la tabella `user_roles`
--


-- --------------------------------------------------------

--
-- Struttura della tabella `user_tokens`
--

CREATE TABLE IF NOT EXISTS `user_tokens` (
  `id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `token` varchar(255) NOT NULL,
  `expiry` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `referer` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dump dei dati per la tabella `user_tokens`
--


-- --------------------------------------------------------

--
-- Struttura della tabella `ways`
--

CREATE TABLE IF NOT EXISTS `ways` (
  `way_id` bigint(20) NOT NULL default '0',
  `changeset_id` bigint(20) NOT NULL,
  `timestamp` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `version` bigint(20) NOT NULL,
  `visible` tinyint(1) NOT NULL default '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dump dei dati per la tabella `ways`
--


-- --------------------------------------------------------

--
-- Struttura della tabella `way_nodes`
--

CREATE TABLE IF NOT EXISTS `way_nodes` (
  `way_id` bigint(20) NOT NULL,
  `node_id` bigint(20) NOT NULL,
  `version` bigint(20) NOT NULL,
  `sequence_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dump dei dati per la tabella `way_nodes`
--


-- --------------------------------------------------------

--
-- Struttura della tabella `way_tags`
--

CREATE TABLE IF NOT EXISTS `way_tags` (
  `way_id` bigint(20) NOT NULL default '0',
  `k` varchar(255) NOT NULL,
  `v` varchar(255) NOT NULL,
  `version` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dump dei dati per la tabella `way_tags`
--