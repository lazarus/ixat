<?php

class AccessTokenAuthentication {
    /*
     * Get the access token.
     *
     * @param string $azure_key    Subscription key for Text Translation API.
     *
     * @return string.
     */
    function getToken($azure_key)
    {
        $url = 'https://api.cognitive.microsoft.com/sts/v1.0/issueToken';
        $ch = curl_init();
        $data_string = json_encode('{body}');
        curl_setopt($ch, CURLOPT_POSTFIELDS, $data_string);
        curl_setopt($ch, CURLOPT_HTTPHEADER, array(
                'Content-Type: application/json',
                'Content-Length: ' . strlen($data_string),
                'Ocp-Apim-Subscription-Key: ' . $azure_key
            )
        );
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_HEADER, false);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, TRUE);
        $strResponse = curl_exec($ch);
        curl_close($ch);
        return $strResponse;
    }
}

/*
 * Class:HTTPTranslator
 *
 * Processing the translator request.
 */
Class HTTPTranslator {
    /*
     * Create and execute the HTTP CURL request.
     *
     * @param string $url        HTTP Url.
     * @param string $authHeader Authorization Header string.
     * @param string $postData   Data to post.
     *
     * @return string.
     *
     */
    function curlRequest($url, $authHeader) {
        //Initialize the Curl Session.
        $ch = curl_init();
        //Set the Curl url.
        curl_setopt ($ch, CURLOPT_URL, $url);
        //Set the HTTP HEADER Fields.
        curl_setopt ($ch, CURLOPT_HTTPHEADER, array($authHeader,"Content-Type: text/xml"));
        //CURLOPT_RETURNTRANSFER- TRUE to return the transfer as a string of the return value of curl_exec().
        curl_setopt ($ch, CURLOPT_RETURNTRANSFER, TRUE);
        //CURLOPT_SSL_VERIFYPEER- Set FALSE to stop cURL from verifying the peer's certificate.
        curl_setopt ($ch, CURLOPT_SSL_VERIFYPEER, False);
        //Execute the  cURL session.
        $curlResponse = curl_exec($ch);
        //Get the Error Code returned by Curl.
        $curlErrno = curl_errno($ch);
        if ($curlErrno) {
            $curlError = curl_error($ch);
            throw new Exception($curlError);
        }
        //Close a cURL session.
        curl_close($ch);
        return $curlResponse;
    }
}

try {
	$u = is_numeric($_GET['u']) ? $_GET['u'] : '';
	if(isset($u) && !empty($u)){
		$callback = is_numeric($_GET['callback']) ? $_GET['callback'] : '0';
		
		$q = $_GET['q'] ? rawurlencode($_GET['q']) : '';
		$source = isset($_GET['source']) ? strlen($_GET['source']) <= 6 ? $_GET['source'] : '' : '';
		$target = strlen($_GET['target']) <= 6 ? $_GET['target'] : '';

	    //Client Secret key of the application.
	    $clientSecret = "fa0547978de247d7a1929d5bb7ae008d";

	    //Create the AccessTokenAuthentication object.
	    $authObj      = new AccessTokenAuthentication();
	    //Get the Access token.
	    $accessToken  = $authObj->getToken($clientSecret);
	    //Create the authorization Header string.
	    $authHeader = "Authorization: Bearer ". $accessToken;

	    //Set the params.//
	    $fromLanguage = $source;
	    $toLanguage   = $target;
	    $inputStr     = $q; //DATA IS ALREADY URL ENCODED LOL PLS 
	    $contentType  = 'text/plain';
	    $category     = 'general';
	    
	    $params = "text=".$inputStr."&to=".$toLanguage."&from=".$fromLanguage;
	    $translateUrl = "https://api.microsofttranslator.com/v2/Http.svc/Translate?$params";
	    
	    //Create the Translator Object.
	    $translatorObj = new HTTPTranslator();
	    
	    //Get the curlResponse.
	    $curlResponse = $translatorObj->curlRequest($translateUrl, $authHeader);
	    
	    //Interprets a string of XML into an object.
	    $xmlObj = simplexml_load_string($curlResponse);
	    foreach((array)$xmlObj[0] as $val){
	        $translatedStr = $val;
	    }
		$translatedStr = trim($translatedStr);
		if(strtolower(trim(urldecode($inputStr))) == strtolower($translatedStr)) $translatedStr = "";
		echo '// API callback '.$callback.'({"data":{"translations":[{"translatedText": "'.$translatedStr.'"}]}});';
	} else {
		$callback = is_numeric($_GET['callback']) ? $_GET['callback'] : '0';
		echo '// API callback '.$callback.'({"data":{"translations":[{"translatedText":"Please login"}]}});';
	}
} catch (Exception $e) {
	$callback = is_numeric($_GET['callback']) ? $_GET['callback'] : '0';
	echo '// API callback '.$callback.'({"data":{"translations":[{"translatedText":"Please login"}]}});';
    //echo "Exception: " . $e->getMessage() . PHP_EOL;
}


/*
 * Create and execute the HTTP CURL request.
 * 
 * @param string $url        HTTP Url.
 * @param string $authHeader Authorization Header string.
 * @param string $postData   Data to post.
 *
 * @return string.
 *
 */
function curlRequest($url, $authHeader, $postData=''){
    //Initialize the Curl Session.
    $ch = curl_init();
    //Set the Curl url.
    curl_setopt ($ch, CURLOPT_URL, $url);
    //Set the HTTP HEADER Fields.
    curl_setopt ($ch, CURLOPT_HTTPHEADER, array($authHeader,"Content-Type: text/xml"));
    //CURLOPT_RETURNTRANSFER- TRUE to return the transfer as a string of the return value of curl_exec().
    curl_setopt ($ch, CURLOPT_RETURNTRANSFER, TRUE);
    //CURLOPT_SSL_VERIFYPEER- Set FALSE to stop cURL from verifying the peer's certificate.
    curl_setopt ($ch, CURLOPT_SSL_VERIFYPEER, False);
    if($postData) {
        //Set HTTP POST Request.
        curl_setopt($ch, CURLOPT_POST, TRUE);
        //Set data to POST in HTTP "POST" Operation.
        curl_setopt($ch, CURLOPT_POSTFIELDS, $postData);
    }
    //Execute the  cURL session. 
    $curlResponse = curl_exec($ch);
    //Get the Error Code returned by Curl.
    $curlErrno = curl_errno($ch);
    if ($curlErrno) {
        $curlError = curl_error($ch);
        throw new Exception($curlError);
    }
    //Close a cURL session.
    curl_close($ch);
    return $curlResponse;
}

?>