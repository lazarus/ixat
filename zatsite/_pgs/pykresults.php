<?php
if(!isset($config->complete))
{
	return require $pages['home'];
}

$ppdb = new Database('205.185.112.51', 'ztsqlser_lc', 'Lcpzg0Fzc4fELgA3kR', 'ztsqlser_ipn');
$rows = $ppdb->fetch_array('select `username`, `amount`, `ipaymentstatus`, `mcfee`, `credit`, `ieverything_else` from `ibn_table` limit 0, 50;');
?>
<style type="text/css">
	th {
		font-size: 20px;
		font-family: "Segoe UI";
		color: #ffffff;
		font-weight: normal;
		width: 200px;
		cursor: default;
	}
	
	td {
		font-size: 13px;
		font-family: "Segoe UI";
		color: #ffffff;
		padding: 5px 15px;
		font-style: italic;
	}
	
	tr.evenRow:hover, tr.oddRow:hover { background-color: #222222; }
	tr.evenRow { background-color: #000000; }
	tr.oddRow { background: #111111; }
</style>
<table style="margin: 0px auto;" cellspacing="0">
	<tr> <th> Username </th> <th> Amount </th> <th> Status </th> <th> Fee </th> <th> Date </th> <th> Credited </th></tr>
	<?php
		for($i = count($rows) - 1; $i >= 0; $i--)
		{
			$extra = json_decode($rows[$i]['ieverything_else']);
			print '<tr class="' . ($i % 2 == 1 ? 'evenRow' : 'oddRow') . '"> <td> ' . $rows[$i]['username'] . ' </td> <td> $' . $rows[$i]['amount'] . ' </td> <td> ' . $rows[$i]['ipaymentstatus'] . ' </td> <td> ' . $rows[$i]['mcfee'] . ' </td> <td> ' . $extra->payment_date . ' </td> <td> ' . $rows[$i]['credit'] . ' </td> </tr>';
		}
	?>
</table>