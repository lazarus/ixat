<?php
	if(!isset($config->complete))
	{
		return include $pages['home'];
	}
	if(!isset($core->user))
	{
		return include $pages['profile'];
	}
?>
<script type="text/javascript">
	var usd = null;
	var xats = null;
	var price = null;
	
	function doCalc()
	{
		if(usd != null)
		{
			var amount = parseFloat(usd.value);
			if(!isNaN(amount))
			{
				xats.innerHTML = Math.floor(amount * 10000);
				price.innerHTML = Math.floor(amount);
			}
			else
			{
				xats.innerHTML = 0;
				price.innerHTML = 0;
			}
		}
	}
	
	function validate()
	{
		if(parseFloat(usd.value) < 4)
		{
			alert("The minimum donation amount is $4.00");
			return false;
		}
	}
	
	window.onload = function()
	{
		usd = document.getElementById("usd");
		xats = document.getElementById("xats");
		price = document.getElementById("price");
	}
</script>
<form action="https://www.paypal.com/cgi-bin/webscr" method="post">
	<section class="section bg-gray p-25">
		<div class="container">
			<div class="row gap-y">
				<div class="col-12 col-lg-6">
					<div class="card">
						<div class="card-block">
							<h5 class="card-title">How much will you get?</h5>
							<center>
							I would like to spend $
							<input class="form-control" style="width:200px" onkeyup="doCalc()" type="text" id="usd" name="amount" value="0" />(USD)
							<br /><br />
							For $<span id="price">0</span> <i>(USD)</i>, you will get <span id="xats">0</span> xats!
							</center>
						</div>
					</div>
				</div>
				<div class="col-12 col-lg-6">
					<div class="card">
						<div class="card-block">
							<h5 class="card-title">Donate here</h5>
							<input type="hidden" name="cmd" value="_xclick">
							<input type="hidden" name="business" value="runitys@gmail.com">
							<input type="hidden" name="lc" value="EN">
							<input type="hidden" name="item_name" value="General Donation">
							<input type="hidden" name="currency_code" value="USD">
							<input type="hidden" name="button_subtype" value="services">
							<input type="hidden" name="no_note" value="1">
							<input type="hidden" name="no_shipping" value="1">
							<input type="hidden" name="rm" value="1">
							<input type="hidden" name="return" value="http://ixat.io/success">
							<input type="hidden" name="cancel_return" value="http://ixat.io/">
							<input type="hidden" name="notify_url" value="http://ixat.io/ppipn?ajax">
							
							<input type="hidden" name="on0" value="username" />
							<input type="hidden" name="os0" value="<?php print $core->user->getUsername(); ?>" />
							
							<center><input onclick="return validate();" type="image" src="https://www.paypalobjects.com/en_US/GB/i/btn/btn_donateCC_LG.gif" border="0" name="submit" alt="PayPal - The safer, easier way to pay online."></center>
						</div>
					</div>
				</div>
			</div>
		</div>
	</section>
</form>
<section class="section p-25">
	<div class="container">
		<div class="row gap-y">
			<div class="col-12">
				<div class="card bg-gray p-10 m-10">
					<div class="card-block">
						<h5 class="card-title">ixat Donation Agreement:</h5>
						<p>
							By Donating to ixat Hosting, you're agreeing to the below terms & conditions.<br />
							- To Donate to ixat, you must have a paypal account and authorization of the credit card, or paypal balance.<br />
							- Your donation will be applied for server expenses and in return you're recieving coins currency to purchase features on our site.<br />
							- ixat will not give Refunds for accounts that have been compromised, torched, or banned.<br />
							- At our own discretion, we're allowed to decline your donation and refund you for fraud reasons<br />
							- ixat staff have the right to change prices at anytime.<br />
							- <b>BY NO MEANS WILL ixat ISSUE A REFUND IN ANYWAY TO YOUR DONATION!</b>(added 8/27/14).<br />
							- We take no responsibility if you lose anything by the means of trading, account sharing.<br />
							** Please submit a ticket to support.ixat.io if you do not get credited your purchase within 2 hours of payment. **<br />
							<br />
							If you open a dispute on your donation, you'll be banned from using ixat and your information will be reported.
						</p>
					</div>
				</div>
			</div>
		</div>
		<div class="row gap-y">
			<div class="col-12">
				<div class="card bg-gray p-10 m-10">
					<div class="card-block">
						<h5 class="card-title">Current Donation Specials:</h5>
						<p>
							<b>$20</b> will get you everypower, 1m ixats, Custom ID, Moderator in Lobby, Custom Pawn, *If you already have EP, will give 3M ixats* <br />
							<b>$50</b> will get you the above $20 special and access to staff commands. <br />
						</p>
					</div>
				</div>
			</div>
		</div>
	</div>
</section>