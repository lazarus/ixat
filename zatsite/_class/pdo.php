<?php
/*  Boring Stuff -- @Author Skyflare (Legendfoxy)
    Inputs within "[]" brackets are not required.
	
      Database->__construct([host, db_username, db_password[, db_name]])
      Database->setDB(db_name)
      Database->insert('table_name', array('column_name' => 'value'[, *]));
      Database->query('update `a` set `b`=:c where `d`=:f;', array('c' => 'stuffs', 'f' => 'more stuffs'));
      Database->fetch_array({Database->query})
      Database::hash('input', {''}[, ENGINE]);
      Database::validate('input', Database::hash('input')[, ENGINE]);
      Database::rand(length);
*/

class Database extends PDO
{
	static $debug = false;
	public $conn  = false;
	
	public function __construct()
	{
		$args = func_get_args();
		
		if(count($args) == 0)
		{
			$dir = "../../_class/";
			$dir = str_replace('\\', '\\\\', $dir);
			require $dir . 'config.php';
			$args = $config->db;
		}
		
		if(count($args) >= 3)
		{
			try
			{
				parent::__construct('mysql:charset=utf8;host=' . $args[0], $args[1], $args[2], [
			        PDO::ATTR_TIMEOUT => "2", //time in seconds
			        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION //no clue what this even means but it works *dabs* -austin
			    ]);
				
				if(isset($args[3]))
				{
					if(!$this->setDB($args[3]))
					{
						Database::exception('Couldn\'t select database');
					}
				}
			}
			catch(PDOException $e)
			{
				Database::exception('Error connecting to database.');
			}
		}
	}
	
	public function setDB($dbname)
	{
		try
		{
			parent::exec('use `' . $dbname . '`;');
			$test = parent::query('select database();');
			$test = $test->fetch(self::FETCH_ASSOC);
			
			if(strtolower($test['database()']) != strtolower($dbname))
			{
				throw new Exception;
			}
			
			$this->conn = true;
			return true;
		}
		catch(Exception $e)
		{
			// Do Nothing
		}
		
		return false;
	}
	
	public function insert($table, $values)
	{
		$query = "insert into `{$table}`(`" . implode("`, `", array_keys($values)) . "`) values(:" . implode(", :", array_keys($values)) . ");";
		return $this->query($query, $values);
	}
	
	public function insert_id()
	{ // because some people are just.. let's not go there.
		return $this->lastInsertId();
	}
	
	public function query($query, $bind = array())
	{
		try
		{
            /* test later
            if (substr_count($query, ';') > 1) {
                return false;//possible sqli
            }*/
			$ps = parent::prepare($query);
			
			foreach($bind as $index => &$value)
			{
				$ps->bindParam($index, $value);
			}
			
			$ps->execute();
			return $ps;
		}
		catch(PDOException $e)
		{
			if(Database::$debug)
			{
				Database::exception($e->getMessage());
			}
		}
		
		return false;
	}
	
	public function fetch_array($query, $bind = array(), $return = array())
	{
		$query = $this->query($query, $bind);
		
		if(method_exists($query, 'fetch'))
		{
			while($row = $query->fetch(self::FETCH_ASSOC))
			{
				array_push($return, $row);
			}
		}
		
		return $return;
	}
	
	static function encode($str)
	{
		$strE = $salt = rand(100, 128);
		$strL = strlen($str);
		for($i = 0; $i < $strL; $i++)
		{
			$strE .= '0x' . dechex(ord($str[$i]) + $salt);
		}
		
		return $strE;
	}
	
	static function decode($str)
	{
		$strE = '';
		$strA = explode('0x', $str);
		$salt = array_shift($strA);
		foreach($strA as $u)
		{
			$strE .= chr(hexdec($u) - $salt);
		}
		
		return $strE;
	}
	
	static function hash($str, $rawsalt = '', $hash = 'sha512')
	{
		if($rawsalt == '')
		{
			$rawsalt = self::rand(((strlen($str) % 3) + 1) * 5);
		}
		
		$loc = array(hash('sha1', $rawsalt), hash('sha1', $str), '');
		foreach(str_split($loc[0], 1) as $index => $character)
		{
			$loc[2] .= $character . $loc[1][$index];
		}
		
		$hash = hash($hash, $loc[2]);
		return substr_replace($hash, $rawsalt, (strlen($str) << 2) % strlen($hash), 0);
	}
	
	static function validate($str, $hash, $engine = 'sha512')
	{
		if(empty($str)||empty($hash))
			return false;
		
		$salt = substr($hash, (strlen($str) << 2) % strlen(hash($engine, 1)), ((strlen($str) % 3) + 1) * 5);
		return self::hash($str, $salt, $engine) === $hash ? true : false;
	}

	static function use_hash($str, $hash, $engine = 'sha512')
	{
		$salt = substr($hash, (strlen($str) << 2) % strlen(hash($engine, 1)), ((strlen($str) % 3) + 1) * 5);
		return self::hash($str, $salt, $engine);
	}
	
	static function rand($len = 32)
	{
		$chars = array_merge(range('a', 'z'), range('A', 'Z'), range('0', '9'));
		for($rand = ''; strlen($rand) < $len; $rand .= $chars[rand(0, 61)]);
		return $rand;
	}
	
	static function exception($e = false)
	{
		if(Database::$debug && $e != false)
		{
			print $e;
		}
		//exit;
	}
}
