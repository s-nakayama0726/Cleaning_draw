$(function(){

	var appendLogMsg = function(msg) {
		$('#msg')
	.append('<p class="muted">' + msg + '</p>')
	.scrollTop(100000000);

	}
	var p = {
		startCallback : function() {
			appendLogMsg('start');
			$('.start').attr('disabled', 'true');
			$('.stop').removeAttr('disabled');
		},
		slowDownCallback : function() {
			appendLogMsg('slowdown');
			$('.stop').attr('disabled', 'true');
		},
		stopCallback : function($stopElm) {
			appendLogMsg('stop');
			$('.start').removeAttr('disabled');
			$('.stop').attr('disabled', 'true');
		}

	}
	var rouletter = $('div.roulette');
	rouletter.roulette(p);	
	$('.stop').click(function(){
		var stopImageNumber = $('.userNumber').val();
		if(stopImageNumber == "") {
			stopImageNumber = null;
		}
		rouletter.roulette('stop');	
	});
	$('.stop').attr('disabled', 'true');
	$('.start').click(function(){
		rouletter.roulette('start');	
		$.ajax({
		   type: "GET",
   			url: "/draw/user_result",
   			success: function(msg){

   			}
 		});
	});

	var updateParamater = function(){
		p['speed'] = Number($('.userSpeed').val());
		p['duration'] = Number($('.userDuration').val());
		p['stopImageNumber'] = Number($('.userNumber').val());
		rouletter.roulette('option', p);	
	}

	var updateStopImageNumber = function(stopImageNumber) {
		$('.userNumber').text(stopImageNumber);
		updateParamater();
	}

	$('#stopImageNumber').spinner({
		spin: function( event, ui ) {
			var imageNumber = ui.value;
			if ( ui.value > 4 ) {
				$( this ).spinner( "value", -1 );
				imageNumber = 0;	
				updateStopImageNumber(-1);		
				return false;
			} else if ( ui.value < -1 ) {
				$( this ).spinner( "value", 4 );
				imageNumber = 4;	
				updateStopImageNumber(4);		
				return false;
			}
			updateStopImageNumber(imageNumber);		
		}
	});
	$('#stopImageNumber').spinner('value', 0);
	updateStopImageNumber($('#stopImageNumber').spinner('value'));		

	$('.image_sample').children().click(function(){
		var stopImageNumber = $(this).attr('data-value');
		$('#stopImageNumber').spinner('value', stopImageNumber);
		updateStopImageNumber(stopImageNumber);
	});
});

