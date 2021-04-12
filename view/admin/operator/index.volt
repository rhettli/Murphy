<!DOCTYPE html>
            <html lang="zh-CN">
            <head>
            <meta charset="UTF-8">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <meta http-equiv="refresh" content="300">
            <title>管理后台</title>
<script src="/static/js/jquery/1.11.2/jquery.min.js" type="text/javascript"></script>
<script src="/static/js/jquery.form/3.51.0/jquery.form.js" type="text/javascript"></script>
<script src="/static/framework/bootstrap/3.3.4/js/bootstrap.min.js" type="text/javascript"></script>
<script src="/static/js/admin.js" type="text/javascript"></script>
    <style>
        body{
            font-family: Arial, Helvetica, sans-serif;
            background:#000;
            overflow:hidden;
            margin: 0;
        }
        input:focus{
           outline: black;
        }
        .form-group{
            box-sizing: border-box;
        }
        .user_input{
            border: 1px solid #e3e6934a;
          width: 100%;
          padding: 14px 12px;
          background-color: #0e1e4887;
          color: #ffff8c;
            }

        /*===========================================================================
           2. SKY
           ========================================================================== */
        #sky{
            position:absolute;
            height:85%;
            width:100%;
            z-index:0;
            background: #0957bc; /* Old browsers */
            background: -moz-linear-gradient(top, #0957bc 0%, #053c89 100%); /* FF3.6+ */
            background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#0957bc), color-stop(100%,#053c89)); /* Chrome,Safari4+ */
            background: -webkit-linear-gradient(top, #0957bc 0%,#053c89 100%); /* Chrome10+,Safari5.1+ */
            background: -o-linear-gradient(top, #0957bc 0%,#053c89 100%); /* Opera 11.10+ */
            background: -ms-linear-gradient(top, #0957bc 0%,#053c89 100%); /* IE10+ */
            background: linear-gradient(top, #0957bc 0%,#053c89 100%); /* W3C */
            filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#0957bc', endColorstr='#053c89',GradientType=0 ); /* IE6-9 */
        }


        #stars{
            height:100%;
            width:100%;
            /* background: url(http://sub.slinto.sk/ParallaxStars.png) repeat 0 0;*/
            position:absolute;
            top:0;
            left:0;
            -webkit-animation: bgAnimation 7s infinite;
            -moz-animation: bgAnimation 7s infinite;
            -ms-animation: bgAnimation 7s infinite;
            -o-animation: bgAnimation 7s infinite;
            animation: bgAnimation 7s infinite;
            -webkit-animation-timing-function: linear;
            -moz-animation-timing-function: linear;
            -ms-animation-timing-function: linear;
            -o-animation-timing-function: linear;
            animation-timing-function: linear;

        }


        .asteroid{
            position:absolute;
            top:-200px;
            left:-200px;
            width:200px;
            height:200px;
            opacity:0.8;
            -webkit-animation: asteroidAnimation 5s infinite;
            -webkit-animation-timing-function:ease-in;
            -moz-animation-timing-function:ease-in;
            -ms-animation-timing-function:ease-in;
            -o-animation-timing-function:ease-in;
            animation-timing-function:ease-in;

            -webkit-animation-delay:2s;
            -moz-animation-delay:2s;
            -ms-animation-delay:2s;
            -o-animation-delay:2s;
            animation-delay:2s;
        }
        .asteroid-head{
            width:10px;
            height:10px;
            -webkit-border-radius:50%;
            -moz-border-radius:50%;
            border-radius:50%;
            background:#FFF;
            -webkit-box-shadow:0px 0px 7px 2px #FFF;
            -moz-box-shadow:0px 0px 7px 2px #FFF;
            box-shadow:0px 0px 7px 2px #FFF;
            position: absolute;
            bottom:0;
            right:0;
        }
        .asteroid-tail{
            width:0;
            height:0;
            border-left: 3px solid transparent;
            border-bottom: 200px solid #FFF;
            border-right: 3px solid transparent;
            position: absolute;
            bottom:-22px;
            right:75px;
            -webkit-transform:rotate(-45deg);
            -moz-transform:rotate(-45deg);
            -o-transform:rotate(-45deg);
            -ms-transform:rotate(-45deg);
            transform:rotate(-45deg);
        }


        .a2{
            top:-205px;
            left:400px;
            -webkit-animation: asteroidAnimationTwo 6s infinite;
            -webkit-animation-timing-function:ease-in;
            -moz-animation-timing-function:ease-in;
            -ms-animation-timing-function:ease-in;
            -o-animation-timing-function:ease-in;
            animation-timing-function:ease-in;

            -webkit-animation-delay:4s;
            -moz-animation-delay:4s;
            -ms-animation-delay:4s;
            -o-animation-delay:4s;
            animation-delay:4s;

        }


        /* =============================================================================
           3. MOON
           ========================================================================== */
        #moon{
            position:absolute;
            top:10%;
            right:10%;
            width:200px;
            height:200px;
            border-radius:50%;
            background:#FFFF8C;
            box-shadow:0px 0px 100px #FFFF8C;
            z-index:5;
            -webkit-animation: moonAnimation 3s infinite;
            -moz-animation: moonAnimation 3s infinite;
            -ms-animation: moonAnimation 3s infinite;
            -o-animation: moonAnimation 3s infinite;
            animation: moonAnimation 3s infinite;
        }

        .crater{
            position:absolute;
            top:30px;
            left:40px;
            width:25px;
            height:45px;
            background:#E3E693;
            border-top-right-radius:50px 100px;
            border-top-left-radius:50px 100px;
            border-bottom-right-radius:50px 100px;
            border-bottom-left-radius:50px 100px;
            -webkit-transform:rotate(40deg);
            -moz-transform:rotate(40deg);
            -o-transform:rotate(40deg);
            -ms-transform:rotate(40deg);
            transform:rotate(40deg);
        }

        .crater2{
            position:absolute;
            top:125px;
            right:20px;
            width:15px;
            height:20px;
            background:#E3E693;
            border-top-right-radius:20px 20px;
            border-top-left-radius:20px 20px;
            border-bottom-right-radius:20px 30px;
            border-bottom-left-radius:20px 30px;
            -webkit-transform:rotate(-60deg);
            -moz-transform:rotate(-60deg);
            -o-transform:rotate(-60deg);
            -ms-transform:rotate(-60deg);
            transform:rotate(-60deg);
        }

        .crater3{
            position:absolute;
            top:120px;
            left:60px;
            width:10px;
            height:10px;
            background:#E3E693;
            border-radius:50%;
        }

        .crater4{
            position:absolute;
            top:90px;
            right:90px;
            width:10px;
            height:10px;
            background:#E3E693;
            border-radius:50%;
        }

        .crater5{
            position:absolute;
            top:50px;
            left:120px;
            width:30px;
            height:35px;
            background:#E3E693;
            border-radius:50%;
            -webkit-transform:rotate(120deg);
            -moz-transform:rotate(120deg);
            -o-transform:rotate(120deg);
            -ms-transform:rotate(120deg);
            transform:rotate(120deg);
        }

        .crater6{
            position:absolute;
            bottom:15px;
            left:80px;
            width:15px;
            height:15px;
            background:#E3E693;
            border-radius:50%;
        }

        .crater7{
            position:absolute;
            bottom:15px;
            left:130px;
            width:5px;
            height:5px;
            background:#E3E693;
            border-radius:50%;
        }



        /* =============================================================================
           4. TREES
           ========================================================================== */
        .tuja{
            width:30px;
            height:150px;
            background:#000;
            position:absolute;
            bottom:-10px;
            left:10%;
            border-top-right-radius:20px 100px;
            border-top-left-radius:20px 100px;
            border-bottom-right-radius:20px 100px;
            border-bottom-left-radius:20px 100px;
            z-index:10;
        }

        .two{
            left:15%;
        }


        /* =============================================================================
           5. ALIEN
           ========================================================================== */
        #cover{
            position:absolute;
            right:10%;
            bottom:-70px;
            height:70px;
            width:70px;
            background:#000;
        }
        #alien{
            position:absolute;
            right:10%;
            bottom:-70px;
            background:#000;
            width:50px;
            height:70px;
            border-top-left-radius: 100px;
            border-top-right-radius: 100px;
            border-bottom-left-radius:100px 150px;
            border-bottom-right-radius:100px 150px;

            -webkit-animation: alienAnimation 10s infinite;
            -moz-animation: alienAnimation 10s infinite;
            -ms-animation: alienAnimation 10s infinite;
            -o-animation: alienAnimation 10s infinite;
            animation: alienAnimation 10s infinite;
        }

        #alien:before{
            content:' ';
            position:absolute;
            left:-5px;
            top:0px;
            width:60px;
            height:60px;
            background:#000;
            border-top-left-radius: 100px;
            border-top-right-radius: 100px;
            border-bottom-left-radius:100px 150px;
            border-bottom-right-radius:100px 150px;
        }

        .eye{
            background: rgba(243, 225, 5, 0.3);
            position:absolute;
            top:15px;
            left:5px;
            width:15px;
            height:15px;
            border-top-right-radius:15px 10px;
            border-top-left-radius:2px;
            border-bottom-left-radius:15px 10px;
            border-bottom-right-radius:3px;
        }

        .eyeR{
            background: rgba(243, 225, 5, 0.3);
            position:absolute;
            top:15px;
            right:5px;
            width:15px;
            height:15px;
            border-top-left-radius:15px 10px;
            border-top-right-radius:2px;
            border-bottom-right-radius:15px 10px;
            border-bottom-left-radius:3px;
        }

        /* =============================================================================
           6. GRASS
           ========================================================================== */

        /*---------- Right radius grass -----------*/
        .grass{
            position:absolute;
            bottom:0;
            left:3%;
            height:20px;
            width:10px;
            border-left:5px solid #000;
            border-right:0;
            border-bottom:0;
            border-top-left-radius:50px 200px;
            border-top-right-radius:0px;
            z-index:5;

            -webkit-animation: grassAnimation 2s infinite;
            -moz-animation: grassAnimation 2s infinite;
            -ms-animation: grassAnimation 2s infinite;
            -o-animation: grassAnimation 2s infinite;
            animation: grassAnimation 2s infinite;

            -webkit-animation-timing-function: linear;
            -moz-animation-timing-function: linear;
            -ms-animation-timing-function: linear;
            -o-animation-timing-function: linear;
            animation-timing-function: linear;
        }

        .g1{left:5%;   height:26px;}
        .g2{left:8%;   height:16px;}
        .g3{left:10%;  height:22px;}
        .g4{left:15%;  height:18px;}
        .g5{left:16%;  height:26px;}
        .g6{left:20%;  height:20px;}
        .g7{left:23%;  height:22px;}
        .g8{left:27%;  height:26px;}
        .g9{left:33%;  height:17px;}
        .g10{left:37%; height:24px;}
        .g11{left:39%; height:26px;}
        .g12{left:42%; height:16px;}
        .g13{left:45%; height:22px;}
        .g14{left:48%; height:18px;}
        .g15{left:50%; height:26px;}
        .g16{left:53%; height:20px;}
        .g17{left:58%; height:22px;}
        .g18{left:60%; height:26px;}
        .g19{left:62%; height:17px;}
        .g20{left:65%; height:24px;}
        .g21{left:67%;  height:26px;}
        .g22{left:68%;  height:16px;}
        .g23{left:70%; height:22px;}
        .g24{left:72%; height:18px;}
        .g25{left:74%; height:26px;}
        .g26{left:75%; height:20px;}
        .g27{left:78%; height:22px;}
        .g28{left:80%; height:26px;}
        .g29{left:82%; height:17px;}
        .g30{left:83%; height:24px;}
        .g31{left:85%; height:26px;}
        .g32{left:87%; height:16px;}
        .g33{left:89%; height:22px;}
        .g34{left:91%; height:18px;}
        .g35{left:92%; height:26px;}
        .g36{left:94%; height:20px;}
        .g37{left:96%; height:22px;}
        .g38{left:97%; height:26px;}
        .g39{left:99%; height:17px;}
        .g40{left:100%; height:24px;}

        /*---------- Left radius grass -----------*/
        .grassL{
            position:absolute;
            bottom:0;
            left:3%;
            height:20px;
            width:10px;
            border-right:5px solid #000;
            border-left:0;
            border-bottom:0;
            border-top-right-radius:50px 200px;
            border-top-left-radius:0px;
            z-index:5;


            -webkit-animation: grassLAnimation 2s infinite;
            -moz-animation: grassLAnimation 2s infinite;
            -ms-animation: grassLAnimation 2s infinite;
            -o-animation: grassLAnimation 2s infinite;
            animation: grassLAnimation 2s infinite;

            -webkit-animation-timing-function: linear;
            -moz-animation-timing-function: linear;
            -ms-animation-timing-function: linear;
            -o-animation-timing-function: linear;
            animation-timing-function: linear;

            -webkit-animation-delay:3s;
            -moz-animation-delay:3s;
            -ms-animation-delay:3s;
            -o-animation-delay:3s;
            animation-delay:3s;
        }

        .gL1{left:1%;   height:26px;}
        .gL2{left:3%;   height:16px;}
        .gL3{left:4%;  height:22px;}
        .gL4{left:6%;  height:18px;}
        .gL5{left:8%;  height:26px;}
        .gL6{left:11%;  height:20px;}
        .gL7{left:12%;  height:22px;}
        .gL8{left:15%;  height:26px;}
        .gL9{left:17%;  height:17px;}
        .gL10{left:19%; height:24px;}
        .gL11{left:22%; height:26px;}
        .gL12{left:26%; height:16px;}
        .gL13{left:27%; height:22px;}
        .gL14{left:29%; height:18px;}
        .gL15{left:30%; height:26px;}
        .gL16{left:33%; height:20px;}
        .gL17{left:35%; height:22px;}
        .gL18{left:37%; height:26px;}
        .gL19{left:40%; height:17px;}
        .gL20{left:43%; height:24px;}
        .gL21{left:48%;  height:26px;}
        .gL22{left:51%;  height:16px;}
        .gL23{left:53%; height:22px;}
        .gL24{left:56%; height:18px;}
        .gL25{left:58%; height:26px;}
        .gL26{left:60%; height:20px;}
        .gL27{left:62%; height:22px;}
        .gL28{left:64%; height:26px;}
        .gL29{left:66%; height:17px;}
        .gL30{left:68%; height:24px;}
        .gL31{left:71%; height:26px;}
        .gL32{left:73%; height:16px;}
        .gL33{left:76%; height:22px;}
        .gL34{left:79%; height:18px;}
        .gL35{left:81%; height:26px;}
        .gL36{left:83%; height:20px;}
        .gL37{left:85%; height:22px;}
        .gL38{left:88%; height:26px;}
        .gL39{left:90%; height:17px;}
        .gL40{left:93%; height:24px;}
        .gL41{left:95%; height:24px;}
        .gL42{left:97%; height:24px;}


        /* =============================================================================
           7. HOUSE
           ========================================================================== */
        #house{
            position: absolute;
            bottom:0;
            left:25%;
            width:350px;
            height:150px;
            background:#000;
            z-index:10;
        }

        #roof{
            width:0;
            height:0;
            border-left: 230px solid transparent;
            border-bottom: 130px solid #000;
            border-right: 230px solid transparent;
            position: absolute;
            top:-120px;
            left:-50px;
        }

        .window{
            position:absolute;
            top:20px;
            left:60px;
            width:50px;
            height:70px;
            background-color: rgba(243, 225, 5, 0.5);
            border:3px solid #000;
            box-shadow:0px 0px 60px rgba(243, 225, 5, 0.3);
            -webkit-animation: windowAnimation 3s infinite;
            -moz-animation: windowAnimation 3s infinite;
            -ms-animation: windowAnimation 3s infinite;
            -o-animation: windowAnimation 3s infinite;
            animation: windowAnimation 3s infinite;

        }

        .line1{
            position:absolute;
            left:24px;
            width:3px;
            height:70px;
            background:#000;
        }
        .line2{
            position:absolute;
            top:34px;
            width:50px;
            height:3px;
            background:#000;
        }


        /* =============================================================================
           8. ANIMATIONS
           ========================================================================== */

        @keyframes "bgAnimation" {
            0% {
                background-position: 0px 0;
            }
            50% {
                background-position: 50px 0;
            }
            100% {
                background-position: 0px 0;
            }

        }

        @-moz-keyframes bgAnimation {
            0% {
                background-position: 0px 0;
            }
            50% {
                background-position: 50px 0;
            }
            100% {
                background-position: 0px 0;
            }

        }

        @-webkit-keyframes "bgAnimation" {
            0% {
                background-position: 0px 0;
            }
            50% {
                background-position: 50px 0;
            }
            100% {
                background-position: 0px 0;
            }

        }

        @-ms-keyframes "bgAnimation" {
            0% {
                background-position: 0px 0;
            }
            50% {
                background-position: 50px 0;
            }
            100% {
                background-position: 0px 0;
            }

        }

        @-o-keyframes "bgAnimation" {
            0% {
                background-position: 0px 0;
            }
            50% {
                background-position: 50px 0;
            }
            100% {
                background-position: 0px 0;
            }
        }

        /*****************************************/
        @keyframes "windowAnimation" {
            0% {
                -webkit-box-shadow: 0px 0px 40px #FF0;
                -moz-box-shadow: 0px 0px 40px #FF0;
                box-shadow: 0px 0px 40px #FF0;
            }
            50% {
                -webkit-box-shadow: 0px 0px 60px #FF0;
                -moz-box-shadow: 0px 0px 60px #FF0;
                box-shadow: 0px 0px 60px #FF0;
            }
            100% {
                -webkit-box-shadow: 0px 0px 40px #FF0;
                -moz-box-shadow: 0px 0px 40px #FF0;
                box-shadow: 0px 0px 40px #FF0;
            }

        }

        @-moz-keyframes windowAnimation {
            0% {
                -moz-box-shadow: 0px 0px 40px #FF0;
                box-shadow: 0px 0px 40px #FF0;
            }
            50% {
                -moz-box-shadow: 0px 0px 60px #FF0;
                box-shadow: 0px 0px 60px #FF0;
            }
            100% {
                -moz-box-shadow: 0px 0px 40px #FF0;
                box-shadow: 0px 0px 40px #FF0;
            }

        }

        @-webkit-keyframes "windowAnimation" {
            0% {
                -webkit-box-shadow: 0px 0px 40px #FF0;
                box-shadow: 0px 0px 40px #FF0;
            }
            50% {
                -webkit-box-shadow: 0px 0px 60px #FF0;
                box-shadow: 0px 0px 60px #FF0;
            }
            100% {
                -webkit-box-shadow: 0px 0px 40px #FF0;
                box-shadow: 0px 0px 40px #FF0;
            }

        }

        @-ms-keyframes "windowAnimation" {
            0% {
                box-shadow: 0px 0px 40px #FF0;
            }
            50% {
                box-shadow: 0px 0px 60px #FF0;
            }
            100% {
                box-shadow: 0px 0px 40px #FF0;
            }

        }

        @-o-keyframes "windowAnimation" {
            0% {
                box-shadow: 0px 0px 40px #FF0;
            }
            50% {
                box-shadow: 0px 0px 60px #FF0;
            }
            100% {
                box-shadow: 0px 0px 40px #FF0;
            }

        }


        /*-----------------------------------*/
        @keyframes "moonAnimation" {
            0% {
                -webkit-box-shadow: 0px 0px 100px #FFFF8C;
                -moz-box-shadow: 0px 0px 100px #FFFF8C;
                box-shadow: 0px 0px 100px #FFFF8C;
            }
            50% {
                -webkit-box-shadow: 0px 0px 140px #FFFF8C;
                -moz-box-shadow: 0px 0px 140px #FFFF8C;
                box-shadow: 0px 0px 140px #FFFF8C;
            }
            100% {
                -webkit-box-shadow: 0px 0px 100px #FFFF8C;
                -moz-box-shadow: 0px 0px 100px #FFFF8C;
                box-shadow: 0px 0px 100px #FFFF8C;
            }

        }

        @-moz-keyframes moonAnimation {
            0% {
                -moz-box-shadow: 0px 0px 100px #FFFF8C;
                box-shadow: 0px 0px 100px #FFFF8C;
            }
            50% {
                -moz-box-shadow: 0px 0px 140px #FFFF8C;
                box-shadow: 0px 0px 140px #FFFF8C;
            }
            100% {
                -moz-box-shadow: 0px 0px 100px #FFFF8C;
                box-shadow: 0px 0px 100px #FFFF8C;
            }

        }

        @-webkit-keyframes "moonAnimation" {
            0% {
                -webkit-box-shadow: 0px 0px 100px #FFFF8C;
                box-shadow: 0px 0px 100px #FFFF8C;
            }
            50% {
                -webkit-box-shadow: 0px 0px 140px #FFFF8C;
                box-shadow: 0px 0px 140px #FFFF8C;
            }
            100% {
                -webkit-box-shadow: 0px 0px 100px #FFFF8C;
                box-shadow: 0px 0px 100px #FFFF8C;
            }

        }

        @-ms-keyframes "moonAnimation" {
            0% {
                box-shadow: 0px 0px 100px #FFFF8C;
            }
            50% {
                box-shadow: 0px 0px 140px #FFFF8C;
            }
            100% {
                box-shadow: 0px 0px 100px #FFFF8C;
            }

        }

        @-o-keyframes "moonAnimation" {
            0% {
                box-shadow: 0px 0px 100px #FFFF8C;
            }
            50% {
                box-shadow: 0px 0px 140px #FFFF8C;
            }
            100% {
                box-shadow: 0px 0px 100px #FFFF8C;
            }

        }


        /*--------------------------------------------------*/
        @keyframes "asteroidAnimation" {
            0% {
                top: -200px;
                left: -200px;
                -ms-filter: "progid:DXImageTransform.Microsoft.Alpha(Opacity=80)";
                filter: alpha(opacity=80);
                opacity: 0.8;
            }
            10% {
                top: 200px;
                left: 200px;
                -ms-filter: "progid:DXImageTransform.Microsoft.Alpha(Opacity=0)";
                filter: alpha(opacity=0);
                opacity: 0;
            }
            100% {
                -ms-filter: "progid:DXImageTransform.Microsoft.Alpha(Opacity=0)";
                filter: alpha(opacity=0);
                opacity: 0;
            }

        }

        @-moz-keyframes asteroidAnimation {
            0% {
                top: -200px;
                left: -200px;
                filter: alpha(opacity=80);
                opacity: 0.8;
            }
            10% {
                top: 200px;
                left: 200px;
                filter: alpha(opacity=0);
                opacity: 0;
            }
            100% {
                filter: alpha(opacity=0);
                opacity: 0;
            }

        }

        @-webkit-keyframes "asteroidAnimation" {
            0% {
                top: -200px;
                left: -200px;
                filter: alpha(opacity=80);
                opacity: 0.8;
            }
            10% {
                top: 200px;
                left: 200px;
                filter: alpha(opacity=0);
                opacity: 0;
            }
            100% {
                filter: alpha(opacity=0);
                opacity: 0;
            }

        }

        @-ms-keyframes "asteroidAnimation" {
            0% {
                top: -200px;
                left: -200px;
                -ms-filter: "progid:DXImageTransform.Microsoft.Alpha(Opacity=80)";
                filter: alpha(opacity=80);
                opacity: 0.8;
            }
            10% {
                top: 200px;
                left: 200px;
                -ms-filter: "progid:DXImageTransform.Microsoft.Alpha(Opacity=0)";
                filter: alpha(opacity=0);
                opacity: 0;
            }
            100% {
                -ms-filter: "progid:DXImageTransform.Microsoft.Alpha(Opacity=0)";
                filter: alpha(opacity=0);
                opacity: 0;
            }

        }

        @-o-keyframes "asteroidAnimation" {
            0% {
                top: -200px;
                left: -200px;
                filter: alpha(opacity=80);
                opacity: 0.8;
            }
            10% {
                top: 200px;
                left: 200px;
                filter: alpha(opacity=0);
                opacity: 0;
            }
            100% {
                filter: alpha(opacity=0);
                opacity: 0;
            }

        }


        /*-----------------------------------------------------------------------*/
        @keyframes "asteroidAnimationTwo" {
            0% {
                top: -200px;
                left: 400px;
                -ms-filter: "progid:DXImageTransform.Microsoft.Alpha(Opacity=80)";
                filter: alpha(opacity=80);
                opacity: 0.8;
            }
            10% {
                top: 400px;
                left: 980px;
                -ms-filter: "progid:DXImageTransform.Microsoft.Alpha(Opacity=0)";
                filter: alpha(opacity=0);
                opacity: 0;
            }
            100% {
                -ms-filter: "progid:DXImageTransform.Microsoft.Alpha(Opacity=0)";
                filter: alpha(opacity=0);
                opacity: 0;
            }

        }

        @-moz-keyframes asteroidAnimationTwo {
            0% {
                top: -200px;
                left: 400px;
                filter: alpha(opacity=80);
                opacity: 0.8;
            }
            10% {
                top: 400px;
                left: 980px;
                filter: alpha(opacity=0);
                opacity: 0;
            }
            100% {
                filter: alpha(opacity=0);
                opacity: 0;
            }

        }

        @-webkit-keyframes "asteroidAnimationTwo" {
            0% {
                top: -200px;
                left: 400px;
                filter: alpha(opacity=80);
                opacity: 0.8;
            }
            10% {
                top: 400px;
                left: 980px;
                filter: alpha(opacity=0);
                opacity: 0;
            }
            100% {
                filter: alpha(opacity=0);
                opacity: 0;
            }

        }

        @-ms-keyframes "asteroidAnimationTwo" {
            0% {
                top: -200px;
                left: 400px;
                -ms-filter: "progid:DXImageTransform.Microsoft.Alpha(Opacity=80)";
                filter: alpha(opacity=80);
                opacity: 0.8;
            }
            10% {
                top: 400px;
                left: 980px;
                -ms-filter: "progid:DXImageTransform.Microsoft.Alpha(Opacity=0)";
                filter: alpha(opacity=0);
                opacity: 0;
            }
            100% {
                -ms-filter: "progid:DXImageTransform.Microsoft.Alpha(Opacity=0)";
                filter: alpha(opacity=0);
                opacity: 0;
            }

        }

        @-o-keyframes "asteroidAnimationTwo" {
            0% {
                top: -200px;
                left: 400px;
                filter: alpha(opacity=80);
                opacity: 0.8;
            }
            10% {
                top: 400px;
                left: 980px;
                filter: alpha(opacity=0);
                opacity: 0;
            }
            100% {
                filter: alpha(opacity=0);
                opacity: 0;
            }

        }
        /*--------------------------------------------------------*/
        @keyframes "grassAnimation" {
            0% {
                border-top-left-radius: 50px 200px;
            }
            50% {
                border-top-left-radius: 30px 50px;
            }
            100% {
                border-top-left-radius: 50px 200px;
            }

        }

        @-moz-keyframes grassAnimation {
            0% {
                border-top-left-radius: 50px 200px;
            }
            50% {
                border-top-left-radius: 30px 50px;
            }
            100% {
                border-top-left-radius: 50px 200px;
            }

        }

        @-webkit-keyframes "grassAnimation" {
            0% {
                border-top-left-radius: 50px 200px;
            }
            50% {
                border-top-left-radius: 30px 50px;
            }
            100% {
                border-top-left-radius: 50px 200px;
            }

        }

        @-ms-keyframes "grassAnimation" {
            0% {
                border-top-left-radius: 50px 200px;
            }
            50% {
                border-top-left-radius: 30px 50px;
            }
            100% {
                border-top-left-radius: 50px 200px;
            }

        }

        @-o-keyframes "grassAnimation" {
            0% {
                border-top-left-radius: 50px 200px;
            }
            50% {
                border-top-left-radius: 30px 50px;
            }
            100% {
                border-top-left-radius: 50px 200px;
            }

        }


        @keyframes "grassLAnimation" {
            0% {
                border-top-right-radius: 50px 200px;
            }
            50% {
                border-top-right-radius: 30px 50px;
            }
            100% {
                border-top-right-radius: 50px 200px;
            }

        }

        @-moz-keyframes grassLAnimation {
            0% {
                border-top-right-radius: 50px 200px;
            }
            50% {
                border-top-right-radius: 30px 50px;
            }
            100% {
                border-top-right-radius: 50px 200px;
            }

        }

        @-webkit-keyframes "grassLAnimation" {
            0% {
                border-top-right-radius: 50px 200px;
            }
            50% {
                border-top-right-radius: 30px 50px;
            }
            100% {
                border-top-right-radius: 50px 200px;
            }

        }

        @-ms-keyframes "grassLAnimation" {
            0% {
                border-top-right-radius: 50px 200px;
            }
            50% {
                border-top-right-radius: 30px 50px;
            }
            100% {
                border-top-right-radius: 50px 200px;
            }

        }

        @-o-keyframes "grassLAnimation" {
            0% {
                border-top-right-radius: 50px 200px;
            }
            50% {
                border-top-right-radius: 30px 50px;
            }
            100% {
                border-top-right-radius: 50px 200px;
            }

        }

        /*---------------------------------------------------------------*/
        @keyframes "alienAnimation" {
            0% {
                bottom: -70px;
            }
            20% {
                bottom: -30px;
            }
            40% {
                bottom: -70px;
            }
            100% {
                bottom: -70px;
            }

        }

        @-moz-keyframes alienAnimation {
            0% {
                bottom: -70px;
            }
            20% {
                bottom: -30px;
            }
            40% {
                bottom: -70px;
            }
            100% {
                bottom: -70px;
            }

        }

        @-webkit-keyframes "alienAnimation" {
            0% {
                bottom: -70px;
            }
            20% {
                bottom: -30px;
            }
            40% {
                bottom: -70px;
            }
            100% {
                bottom: -70px;
            }

        }

        @-ms-keyframes "alienAnimation" {
            0% {
                bottom: -70px;
            }
            20% {
                bottom: -30px;
            }
            40% {
                bottom: -70px;
            }
            100% {
                bottom: -70px;
            }

        }

        @-o-keyframes "alienAnimation" {
            0% {
                bottom: -70px;
            }
            20% {
                bottom: -30px;
            }
            40% {
                bottom: -70px;
            }
            100% {
                bottom: -70px;
            }

        }

    </style>

    <!--  <script src="https://cdnjs.cloudflare.com/ajax/libs/prefixfree/1.0.7/prefixfree.min.js"></script> -->

</head>

<body>
<div id="sky">
    <div id="stars">
        <!-- ASTEROID -->
        <div class="asteroid">
            <div class="asteroid-head"></div>
            <div class="asteroid-tail"></div>
        </div>

        <div class="asteroid a2">
            <div class="asteroid-head"></div>
            <div class="asteroid-tail"></div>
        </div>
        <!-- END of ASTEROID -->
        <!-- MOON -->
        <div id="moon">
            <div class="crater"></div>
            <div class="crater2"></div>
            <div class="crater3"></div>
            <div class="crater4"></div>
            <div class="crater5"></div>
            <div class="crater6"></div>
            <div class="crater7"></div>
        </div>
        <!-- END of MOON -->
        <!-- TREES -->
        <div class="tuja"></div>
        <div class="tuja two"></div>
        <!-- END of TREES -->
        <!-- HOUSE -->
        <div id="house">
            <div id="roof"></div>
            <div class="window">
                <div class="line1"></div><div class="line2"></div>
            </div>
        </div>
        <!-- END of HOUSE -->

        <div id="alien">
            <div class="eye"></div>
            <div class="eyeR"></div>
        </div>
        <div id="cover"></div>
        <!-- GRASS -->
        <div class="grass"></div>
        <div class="grass g1"></div>
        <div class="grass g2"></div>
        <div class="grass g3"></div>
        <div class="grass g4"></div>
        <div class="grass g5"></div>
        <div class="grass g6"></div>
        <div class="grass g7"></div>
        <div class="grass g8"></div>
        <div class="grass g9"></div>
        <div class="grass g10"></div>
        <div class="grass g11"></div>
        <div class="grass g12"></div>
        <div class="grass g13"></div>
        <div class="grass g14"></div>
        <div class="grass g15"></div>
        <div class="grass g16"></div>
        <div class="grass g17"></div>
        <div class="grass g18"></div>
        <div class="grass g19"></div>
        <div class="grass g20"></div>
        <div class="grass g21"></div>
        <div class="grass g22"></div>
        <div class="grass g23"></div>
        <div class="grass g24"></div>
        <div class="grass g25"></div>
        <div class="grass g26"></div>
        <div class="grass g27"></div>
        <div class="grass g28"></div>
        <div class="grass g29"></div>
        <div class="grass g30"></div>
        <div class="grass g31"></div>
        <div class="grass g32"></div>
        <div class="grass g33"></div>
        <div class="grass g34"></div>
        <div class="grass g35"></div>
        <div class="grass g36"></div>
        <div class="grass g37"></div>
        <div class="grassL"></div>
        <div class="grassL gL1"></div>
        <div class="grassL gL2"></div>
        <div class="grassL gL3"></div>
        <div class="grassL gL4"></div>
        <div class="grassL gL5"></div>
        <div class="grassL gL6"></div>
        <div class="grassL gL7"></div>
        <div class="grassL gL8"></div>
        <div class="grassL gL9"></div>
        <div class="grassL gL10"></div>
        <div class="grassL gL11"></div>
        <div class="grassL gL12"></div>
        <div class="grassL gL13"></div>
        <div class="grassL gL14"></div>
        <div class="grassL gL15"></div>
        <div class="grassL gL16"></div>
        <div class="grassL gL17"></div>
        <div class="grassL gL18"></div>
        <div class="grassL gL19"></div>
        <div class="grassL gL20"></div>
        <div class="grassL gL21"></div>
        <div class="grassL gL22"></div>
        <div class="grassL gL23"></div>
        <div class="grassL gL24"></div>
        <div class="grassL gL25"></div>
        <div class="grassL gL26"></div>
        <div class="grassL gL27"></div>
        <div class="grassL gL28"></div>
        <div class="grassL gL29"></div>
        <div class="grassL gL30"></div>
        <div class="grassL gL31"></div>
        <div class="grassL gL32"></div>
        <div class="grassL gL33"></div>
        <div class="grassL gL34"></div>
        <div class="grassL gL35"></div>
        <div class="grassL gL36"></div>
        <div class="grassL gL37"></div>
        <div class="grassL gL38"></div>
        <div class="grassL gL39"></div>
        <div class="grassL gL40"></div>
        <div class="grassL gL41"></div>
        <div class="grassL gL42"></div>
        <!-- GRASS -->
    </div></div>


<div style="
    position: absolute;
    display: flex;
    z-index: 10000;
    padding-top: 9rem;
    width: 100%;
    margin: 0 auto;
">
<div style="width: 300px;margin: 100px auto;">
                            <form action="/admin/operator/login" id="login_form" class="ajax_form" method="post" autocomplete="off" style="
    text-align: center;
">
                                <div class="form-group">
                                    <input name="username" type="text" class="form-control user_input" placeholder="用户">
                                </div>
                                <div class="form-group" style="margin-top:8px">
                                    <input type="password" name="password" class="form-control user_input" placeholder="密码">
                                </div>
                                <input type="submit" class="btn btn-primary" value="登录" style="
    width: 50%;
    border: 0;
    height: 30px;
    margin-top: 18px;
    background-color: #4e32983b;
    color: #dbe0e6;
">
                                <div class="error_reason"></div>
                            </form>
                    </div>
</div>

</body>
</html>
