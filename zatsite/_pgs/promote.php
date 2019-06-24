<?php

return include $pages['home'];

if (!isset($config->complete)) {
    return include $pages['setup'];

}

if (!isset($core->user)) {
    return require $pages['profile'];

}

if (isset($_POST['Submit'])) {
    $valid = true;
    $messages = array();
    $group = (string)trim($_POST['group']);
    $times_promoting = (int)trim($_POST['times_promoting']);
    $hours = $times_promoting * 0.5;
    $seconds = $times_promoting * 1800;
    $price = $times_promoting * 1000;
    $xats = $core->user->getXats();
    if ($valid && !$group) {
        $valid = false;
        array_push($messages, "You need to enter a group name.");
    }

    if ($valid && (!$seconds || $times_promoting <= 0)) {
        $valid = false;
        array_push($messages, "Invalid promotion time.");
    }

    if ($valid) {
        $group_row = $mysql->fetch_array("select * from `chats` where `name`=:group", array(
            "group" => $group
        ));
        if (isset($group_row[0])) {
            $group = $group_row[0]['name'];
        }
        else {
            $valid = false;
            array_push($messages, "Group does not exist.");
        }
    }

    if ($valid && $price > $xats) {
        $valid = false;
        array_push($messages, "You do not have enough xats.");
    }

    if ($valid) {
        $promoted_chats = json_decode($mysql->fetch_array('select `promoted_chats` from `server`') [0]['promoted_chats'], true);
        $added_time = false;
        foreach($promoted_chats as $k => $promo_data) {
            if (strtolower($promo_data['group']) == strtolower($group)) {
                if ($valid && $promo_data['time'] == 1) {
                    $valid = false;
                    array_push($messages, "You cannot promote a permanently promoted group.");
                }
                elseif ($valid && $promo_data['time'] != 1) {
                    $promoted_chats[$k]['time'] = ($promoted_chats[$k]['time'] - time()) + (time() + $seconds);
                    $added_time = true;
                }
            }
        }
    }

    if ($valid):

        // {

        if (!$added_time) {
            $time = time() + $seconds;
            array_push($promoted_chats, array(
                "group" => $group,
                "time" => $time
            ));
        }

        $mysql->query('update `users` set `xats`=`xats`-' . $price . ' where `id`=' . $core->user->getID() . ';');
        $mysql->query('update `server` set `promoted_chats`=:pc', array(
            'pc' => json_encode($promoted_chats)
        ));
        print '<div class="col-sm-4"></div>';
        print '<div class="col-sm-4"><div class="alert alert-success">';
        print "<button type=\"button\" class=\"close\" data-dismiss=\"alert\" aria-hidden=\"true\">×</button><center>{$group} got promoted for {$hours} hour(s), relogin to see updated xats.</center>";
        print '</div></div>';
        print '<div class="col-sm-4"></div>';

        // print '<font style="color:#FFFFFF; font-size: 28px;">'.$group.' got aids for '.$seconds.' seconds.</font>';
        // }

        else:

            // {

            print '<div class="col-sm-4"></div>';
            print '<div class="col-sm-4"><div class="alert alert-danger">';
            print "<button type=\"button\" class=\"close\" data-dismiss=\"alert\" aria-hidden=\"true\">×</button><center>" . implode('<br />', $messages) . "</center>";
            print '</div></div>';
            print '<div class="col-sm-4"></div>';

            // print '<font style="color:#FFFFFF; font-size: 28px;">Zzzz....</font>';

        endif;
    }

?>
<script type="text/javascript">
var times = null;
window.onload = function() {
    times = document.getElementById("times_promoting");
    doPromoCalc();
}

function doPromoCalc() {
    if (times != null) {
        var amount = parseInt(times.value) * 1000;
        if (!isNaN(amount)) {
            if (amount <= 0) {
                price.innerHTML = "Invalid promotion time.";
            } else {
                price.innerHTML = String(Math.floor(amount)) + " xats for " + String(parseInt(times.value) * 0.5) + " hour(s).";
            }
        } else {
            price.innerHTML = "Invalid promotion time.";
        }
    }
}
</script>
<section class="section bg-gray p-25">
    <div class="container">
        <div class="row gap-y">
            <div class="col-12 col-lg-6 offset-lg-3">
                <div class="card">
                    <div class="card-block">
                        <h5 class="card-title">Promote your group</h5>
                        <form method="post">
                            <div class="form-group">
                                <label><font color="white">Group</font></label>
                                <input class="form-control" type="text" name="group" placeholder="Enter Group"/>
                                <label><font color="white">Times Promoting (Half an hour costs 1000 xats each)</font></label>
                                <input class="form-control" style="width:60px" type="text" name="times_promoting" id="times_promoting" value="1" onkeyup="doPromoCalc()" />
                                <span id="price" style="font-size: 18px;"> </span>
                            </div>
                            <button class="btn btn-primary" type="submit" name="Submit" value="Promote"/>Promote Group</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>