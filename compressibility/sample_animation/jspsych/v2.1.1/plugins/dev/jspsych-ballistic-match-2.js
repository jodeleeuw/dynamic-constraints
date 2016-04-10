(function( $ ) {
	jsPsych.ballistic_match = (function(){
	
		var plugin = {};
	
		plugin.create = function(params) {
			stims = params["stimuli"];
			trials = new Array(stims.length);
			for(var i = 0; i < trials.length; i++)
			{
				trials[i] = {};
				trials[i]["type"] = "ballistic_match";
				trials[i]["target_idx"] = params["target_idx"][i];
				trials[i]["start_idx"] = params["start_idx"][i];
				trials[i]["stimuli"] = params["stimuli"][i];
				trials[i]["timing"] = params["timing"];
				trials[i]["key_dec"] = params["key_dec"];
				trials[i]["key_inc"] = params["key_inc"];
				trials[i]["animate_frame_time"] = params["animate_frame_time"] || 100;
				if(params["prompt"] != undefined){
					trials[i]["prompt"] = params["prompt"];
				}
				if(params["data"]!=undefined){
					trials[i]["data"] = params["data"][i];
				}
			}
			return trials;
		}
		

		var change = 0; // which direction they indicated the stim should move.
		var start_time;
		var end_time; 
		
		plugin.trial = function(display_element, block, trial, part)
		{
			switch(part){
				case 1:
					// starting new trial
					start_time = (new Date()).getTime();
					change = 0;
						
					// show manipulate image
					display_element.append($('<img>', {
						"src": trial.stimuli[trial.start_idx],
						"class": 'bm_img',
						"id": 'bm_manipulate'
					}));
						
					// show target image
					display_element.append($('<img>', {
						"src": trial.stimuli[trial.target_idx],
						"class": 'bm_img',
						"id": 'bm_target'
					}));
					
					if(trial.prompt)
					{
						display_element.append(trial.prompt);
					}
					
					// categorize the image.
					
					var resp_func = function(e) {
						var valid_response = false;
						if(e.which == trial.key_dec)
						{
							change = -1;
							valid_response = true;
						} else if (e.which == trial.key_inc)
						{
							change = 1;
							valid_response = true;
						}
						
						if(valid_response){
							end_time = (new Date()).getTime();
							plugin.trial(display_element,block,trial,part+1);
							$(document).unbind('keyup', resp_func);
						}
					}
					
					$(document).keyup(resp_func);
					break;
				case 2:
					// clear everything
					display_element.html('');
					setTimeout(function(){plugin.trial(display_element, block, trial, part + 1);}, trial.timing[1]);
					break;
				case 3:
					// draw trajectory
					draw_trajectory(display_element,
									trial.stimuli[trial.target_idx], 
									trial.stimuli[trial.start_idx], 
									trial.target_idx/(trial.stimuli.length-1),
									trial.start_idx/(trial.stimuli.length-1));
					
					display_element.append($('<div>',{
						"id":"bm_feedback",
						}));
					
					if(change>0) {
						$("#bm_feedback").html('<p>You said increase.</p>');
					} else {
						$("#bm_feedback").html('<p>You said decrease.</p>');
					}
					
					setTimeout(function(){plugin.trial(display_element, block, trial, part + 1);}, trial.timing[1]*3);
					break;
				case 4:
					var curr_loc = trial.start_idx
					animate_interval = setInterval(function(){
		
						// clear everything
						display_element.html('');
						// draw trajectory
						draw_trajectory(display_element,
										trial.stimuli[trial.target_idx], 
										trial.stimuli[curr_loc], 
										trial.target_idx/(trial.stimuli.length-1),
										curr_loc/(trial.stimuli.length-1));
						
						curr_loc += change;
						
						
						if(curr_loc - change == trial.target_idx || curr_loc < 0 || curr_loc == trial.stimuli.length)
						{
							clearInterval(animate_interval);
							var correct = false;
							if(change > 0 && trial.start_idx < trial.target_idx) { correct = true; }
							if(change < 0 && trial.start_idx > trial.target_idx) { correct = true; }
							
							display_element.append($('<div>',{
								"id":"bm_feedback",
							}));
							if(correct){
								$("#bm_feedback").html('<p>Correct!</p>');
							} else {
								$("#bm_feedback").html('<p>Wrong.</p>');
							}
							setTimeout(function(){plugin.trial(display_element, block, trial, part + 1);}, trial.timing[1]*3);
						}
					}, trial.animate_frame_time);				
					break;
				case 5:
					display_element.html(''); 
					var correct = false;
					if(change > 0 && trial.start_idx < trial.target_idx) { correct = true; }
					if(change < 0 && trial.start_idx > trial.target_idx) { correct = true; }
					
					var trial_data = {"start_idx":trial.start_idx, "target_idx": trial.target_idx, "correct": correct, "rt": (end_time-start_time)};
					block.data[block.trial_idx] = $.extend({},trial_data,trial.data);
					
					setTimeout(function(){block.next();}, trial.timing[0]);
					break;
			}
		}
		
		function draw_trajectory(display_element,target_img, moving_img, target_loc_percent, marker_loc_percent)
		{
			// display the image as it morphs
			display_element.append($('<img>',{
				"src": moving_img,
				"id": "moving_image"
			}));
			
			// show the linear trajectory below 
		
			display_element.append($('<div>', {
				"id": "trajectory"}));
			
			$("#trajectory").append($('<div>', {
				"id": "line"}));
			
			// display the images on the trajectory							
			$("#trajectory").append($('<div>', {
				"id": "target_flag"}));
				
				$("#target_flag").append($('<div>', {
				"id": "target_dot"}));
				
				$("#target_flag").append($('<div>', {
				"id": "target_words"}));
				
				$("#target_words").html("<p>Target Cell</p>");
			
			$("#trajectory").append($('<div>', {
				"id": "marker_flag"}));
				
				$("#marker_flag").append($('<div>', {
				"id": "marker_dot"}));
				
				$("#marker_flag").append($('<div>', {
				"id": "marker_words"}));
				
				$("#marker_words").html("<p>Above Cell</p>");
				
			// label the trajectory line
			$("#trajectory").append($('<span>', {
				"id": "left_label"}));
			
			$("#trajectory").append($('<span>', {
				"id": "right_label"}));
				
			$("#left_label").html("Less Chemical X");
			$("#right_label").html("More Chemical X");
			
			// set the location of the flags on the line
			var dot_width = parseInt($("#marker_dot").css('width'));
			var line_width = parseInt($("#line").css('width'));
			
			var target_flag_left = (line_width- dot_width) * target_loc_percent;
			var marker_flag_left = (line_width- dot_width) * marker_loc_percent;
			
			$("#marker_flag").css('left', marker_flag_left);
			$("#target_flag").css('left', target_flag_left);
			
			
		}
		
		return plugin;
	})();
})(jQuery);