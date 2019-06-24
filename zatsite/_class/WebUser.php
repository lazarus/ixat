<?php
class WebUser {
	private $id;
	private $email;
	private $username;
	private $password;
	private $nickname;
	private $custompawn;
	private $custompawn_cycle;
	private $xats;
	private $reserve;
	private $hold;
	private $torched;
	
	private $admin;
	private $volunteer;
	
	public function __construct(array $info, object $config)
	{
		$this->id               = $info['id'] ?? 0;
		$this->email            = $info['email'] ?? '';
		$this->username         = $info['username'] ?? 'null'; // null as in toon
		$this->password         = $info['password'] ?? '';
		$this->nickname         = $info['nickname'] ?? '';
		$this->custompawn       = $info['custpawn'] ?? '';
		$this->custompawn_cycle = $info['custcyclepawn'] ?? '';
		$this->xats             = $info['xats'] ?? 0;
		$this->reserve          = $info['reserve'] ?? 0;
		$this->hold             = $info['hold'] ?? 0;
		$this->torched          = $info['torched'] ?? 0;
		
		$this->admin            = in_array($this->id, json_decode($config->info['staff'], false));
		$this->volunteer        = in_array($this->id, json_decode($config->info['vols'], false));
	}
	
	public function getID(): int
	{
		return $this->id;
	}
	
	public function getEmail(): string
	{
		return $this->email;
	}
	
	public function getUsername(): string
	{
		return $this->username;
	}

	public function getPassword(): string
	{
		return $this->password;
	}
	
	public function getNickname(): string
	{
		return $this->nickname;
	}
	
	public function getXats(): int
	{
		return $this->xats;
	}
	
	public function getReserve(): int
	{
		return $this->reserve;
	}
	
	public function getHoldTime(): int
	{
		return $this->hold;
	}
	
	public function getServerRank(): int
	{
		return $this->rank;
	}
	
	public function setNickname(string $nick)
	{
		$this->nickname = $nick;
	}	

	public function setXats(int $xats)
	{
		$this->xats = $xats;
	}	
	
	public function reduceXats(int $amount)
	{
		$this->xats = $this->xats - $amount;
	}	
	
	public function increaseXats(int $amount)
	{
		$this->xats = $this->xats + $amount;
	}
	
	public function isEncoded(): bool
	{
		return base64_encode(base64_decode($this->nickname)) == $this->nickname;
	}
	
	public function isHeld(): bool
	{
		return ($this->hold > time() || $this->hold == -1);
	}
		
	public function isTorched(): bool
	{
		return ($this->torched > time() || $this->torched == -1);
	}
	
	public function isAdmin()
	{
		return $this->admin;
	}	
	
	public function isVolunteer()
	{
		return $this->volunteer;
	}
	
	public function hasCustomPawn()
	{
		return !empty($this->custompawn);
	}	
	
	public function hasCustomCyclePawn()
	{
		return !empty($this->custompawn_cycle);
	}
	
}
?>