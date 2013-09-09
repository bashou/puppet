class nass::bddservers {

	class {'mysql::server':
		config_hash => { 'root_password' => '{md5}$1$iVtVRAt9$yE8GjqB.BY6bkA0rfOrCt1' }
	}
}