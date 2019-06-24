<?php
$query = array();
$query['voteoften'] = 0;
$query['width'] = 420;
$query['height'] = 50;
$query['time'] = 1446414008;
$query['question'] = "what is your favorite part of social networks?";
$query['click'] = "NOTE YOU MAY ONLY VOTE ONCE";
$query['already'] = "Thank you for voting!";
$query['votes'] = "Thank you for voting! Total votes";
$query['numanswer'] = 3;
$query['background'] = "http://i.imgur.com/GwZsSYQ.jpg";
$query['answer1'] = "making new friendships";
$query['count1'] = 265;
$query['answer2'] = "maintaining existing friendships";
$query['count2'] = 231;
$query['answer3'] = "following celebrities and public figures";
$query['count3'] = 188;
die(http_build_query($query));
?>