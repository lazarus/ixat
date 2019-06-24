<?php
	if(!isset($core->user)) return include $pages['profile'];
?>
<section class="section bg-gray p-25">
	<div class="container">
		<div class="row gap-y">
			<div class="col-12">
				<div class="card">
					<div class="card-block">
						<h5 class="card-title">Pawns</h5>
						<?php
							$pow2 = getJson('http://ixat.io/web_gear/chat/pow2.php');
							$pawns = getPawns($pow2);
							$pname = [];
							foreach($mysql->fetch_array("select `id`,`name` from `powers` where `name` not like '%undefined%';") as $p) {
								$pname[$p['id']] = $p['name'];
							}
							
							{
								echo "<table class=\"table\">
									<tbody>";
										
										$maxid = $pawns["count"];
										unset($pawns["count"]);
										$pawns = array_reverse($pawns);
										$maxcols = 7;
										$pawns = array_values($pawns);
										for ($i = 0;$i<ceil($maxid/$maxcols);$i++) {
										echo "</tr>\n<tr>\n";
										for ($j=0;$j<$maxcols;$j++)
											if ($i * $maxcols + $j < $maxid)
											echo "<td>
											<center>
												<b>".$pname[$pawns[$i * $maxcols + $j][0]]."</b>
												</center>
											</td>\n";
										else
											echo "<td>
										</td>\n";
									echo "</tr>\n<tr>\n";
									for ($j=0;$j<$maxcols;$j++)
										if ($i * $maxcols + $j < $maxid)
											echo "<td>
											<center>
												<embed src='//ixat.io/web_gear/flash/smiliesshow.swf' flashvars='r=".$pawns[$i * $maxcols + $j][1]."' wmode=\"transparent\" style='width: 60px; height: 60px;'>
												</center>
											</td>\n";
										else
											echo "<td>
										</td>\n";
								echo "</tr>\n<tr>\n";
								for ($j=0;$j<$maxcols;$j++)
									if ($i * $maxcols + $j < $maxid)
									echo "<td>
									<center>
										<b>(hat#h".$pawns[$i * $maxcols + $j][2].")</b>
										</center>
									</td>\n";
								else
									echo "<td>
								</td>\n";
							echo "</tr>\n<tr>\n";
							for ($j=0;$j<$maxcols;$j++)
								echo "<td>
							</td>\n";
						echo "</tr>\n";
					}
					
				echo "</tbody>
			</table>";
		}
		
		
		function getJson($url, $true = true)
		{
			$json = file_get_contents($url);
				return json_decode($json, $true);
		}
		function p_sort($a,$b) {
			return $a[0]>$b[0];
		}
		
		function getPawns($pow2)
		{
			$hats = array();
			$count = 0;
	unset($pow2[7][1]['time'],$pow2[7][1]['!']);
			foreach($pow2[7][1] as $code => $value) {
				//if(!isset($hats[$value[0]])) $hats[$value[0]] = [];
	$hats[] = [$value[0], $value[1], "{$code}"];
	$count++;
	}
			usort($hats, 'p_sort');
			$hats["count"] = $count;
					return $hats;
			}
	?>
					</div>
				</div>
			</div>
		</div>
	</div>
</section>