 function generate_sequence(tp, bi, fi, p, N, seq_length) {
     // make function scoped copies of arguments to guard against recursion errors
     var target_pair = tp.slice(0);
     var base_item = bi;
     var filler_items = fi.slice(0);


     var sequence = new Array(seq_length);

     // there are low probability cases that might generate an infitinite loop
     // if it looks like we are stuck, because this counter is too high, then
     // the function can safely restart.
     var safety_counter = 0;

     function check_safety_counter() {
         if (safety_counter > 500) {
             return false;
         }
         else {
             return true;
             //alert('safetycheck')
         }
     }

     // add N examples of target, with the constraint that they are at least
     // four spots away from each other
     var target_locs = [];
     for (var i = 0; i < N; i++) {
         if (i === 0) {
             target_locs.push(Math.floor(Math.random() * (seq_length - 4)) + 4); // range: 4 - (seq_length-1)
         }
         else {
             var new_loc = Math.floor(Math.random() * (seq_length - 4)) + 4;
             while (_.contains(target_locs, new_loc) || _.contains(target_locs, new_loc - 1) || _.contains(target_locs, new_loc - 2) || _.contains(target_locs, new_loc - 3) || _.contains(target_locs, new_loc - 4) || _.contains(target_locs, new_loc + 1) || _.contains(target_locs, new_loc + 2) || _.contains(target_locs, new_loc + 3) || _.contains(target_locs, new_loc + 4)) {
                 new_loc = Math.floor(Math.random() * (seq_length - 4)) + 4;
                 safety_counter++;
                 if (!check_safety_counter()) {
                     return generate_sequence(tp, bi, fi, p, N, seq_length);
                 }
             }
             target_locs.push(new_loc);
         }
     }

     for (var i = 0; i < target_locs.length; i++) {
         sequence[target_locs[i]] = target_pair[1];
     }

     // add p*N precursors 
     var precursor_N = Math.floor(p * N);
     for (var i = 0; i < precursor_N; i++) {
         sequence[target_locs[i] - 1] = target_pair[0];
     }

     // in the remaining spots, add filler items
     var prior_target_spots = spaces_before(sequence, target_pair[1]);
     var filler_items_to_use = _.shuffle(filler_items);
     if (p <= 0.2) {
         filler_items_to_use.push(base_item);
         filler_items_to_use = _.shuffle(filler_items_to_use);
     }
     for (var i = 0; i < prior_target_spots.length; i++) {
         sequence[prior_target_spots[i]] = filler_items_to_use[i];
     }



     // add N-1 examples of base item (saving the extra to be a repetition)
     // add an extra rep (cc) if needed, and then NO reps of cc in the test phase...
     var possible_locs = _.shuffle(empty_2_1(sequence));
     var base_locs = [];
     var remaining_c_items = N - count_occurences(sequence, base_item);

     var post_target_loc = target_locs[Math.floor(Math.random() * target_locs.length)] + 1;
     while (post_target_loc >= seq_length) {
         post_target_loc = target_locs[Math.floor(Math.random() * target_locs.length)] + 1;
         safety_counter++;
         if (!check_safety_counter()) {
             return generate_sequence(tp, bi, fi, p, N, seq_length);
         }
     }
     base_locs.push(post_target_loc); // after 'b'

     var loc_index = 0;
     for (var i = 0; i < remaining_c_items - 2; i++) {
         var candidate_loc = possible_locs[loc_index];
         while (_.contains(base_locs, candidate_loc) || _.contains(base_locs, candidate_loc - 1) || _.contains(base_locs, candidate_loc + 1)) {
             loc_index++;
             candidate_loc = possible_locs[loc_index];
             safety_counter++;
             if (!check_safety_counter()) {
                 return generate_sequence(tp, bi, fi, p, N, seq_length);
             }
         }
         base_locs.push(candidate_loc);
     }

     if (p == 1) {
         // 'a' will not be available as a precursor to 'c', so we have an extra rep of 'cc' instead.
         base_locs = _.shuffle(base_locs);
         while (base_locs[base_locs.length - 1] == post_target_loc) {
             base_locs = _.shuffle(base_locs);
             safety_counter++;
             if (!check_safety_counter()) {
                 return generate_sequence(tp, bi, fi, p, N, seq_length);
             }
         }
         var s_index = 0;
         while (_.contains(base_locs, base_locs[s_index] + 2) || !_.contains(possible_locs, base_locs[s_index] + 1)) {
             s_index++;
             safety_counter++;
             if (!check_safety_counter()) {
                 return generate_sequence(tp, bi, fi, p, N, seq_length);
             }
         }
         base_locs = base_locs.slice(0, - 1);
         base_locs.push(base_locs[s_index] + 1);
     }

     for (var i = 0; i < base_locs.length; i++) {
         sequence[base_locs[i]] = base_item;
     }

     // insert the last case of c in an empty spot before a 'c'
     // with an empty spot in front of it.
     var c_spots = spaces_before(sequence, base_item);
     var empty_spots = empty_duples(sequence);
     if (_.intersection(c_spots, empty_spots).length == 0) {
         return generate_sequence(tp, bi, fi, p, N, seq_length);
     }
     var valid_spots = _.shuffle(_.intersection(c_spots, empty_spots));
     sequence[valid_spots[0]] = base_item;

     // and fill prior spots with other stimuli
     // ac bc cc dc ec fc gc hc ic jc
     // one will already be after the target 'b'
     // and the rep 'cc' will already be in place if needed
     var prior_spots = spaces_before(sequence, base_item);
     var remaining_fillers = filler_items;
     if (p != 1) {
         remaining_fillers.push(target_pair[0]);
     }

     if (prior_spots.length != remaining_fillers.length) {
         alert('mismatch in length between prior spots and remaining fillers');
         return generate_sequence(tp, bi, fi, p, N, seq_length);
     }

     remaining_fillers = _.shuffle(remaining_fillers);
     prior_spots = _.shuffle(prior_spots);

     for (var i = 0; i < remaining_fillers.length; i++) {
         sequence[prior_spots[i]] = remaining_fillers[i];
     }

     // the first element needs to be filled randomly if not already filled
     if (typeof sequence[0] === 'undefined') {
         sequence[0] = _.shuffle(filler_items)[0];
     }

     // when adding random elements, count the transitions as the elements
     // are added and add in the lowest remaining one.

     while (empty_spaces_after_elem(sequence).length > 0) {
         var transition_table = create_transition_table(sequence, target_pair.concat(filler_items.concat(base_item)));
         var remaining_items = create_remaining_items_list(N, sequence, target_pair.concat(filler_items.concat(base_item)));

         var empty_locs = empty_spaces_after_elem(sequence);
         empty_locs = _.shuffle(empty_locs);

         var loc_to_fill = empty_locs[0];
         var prior_elem = sequence[loc_to_fill - 1];
         if (sequence[loc_to_fill + 1] == target_pair[1]) {
             remaining_items[target_pair[0]] = 0;
         }

         var new_elem = get_next_element(remaining_items, transition_table, prior_elem);

         if (prior_elem == new_elem) {
             if (sequence[loc_to_fill - 2] == new_elem) {
                 // do nothing
             }
             else {
                 sequence[loc_to_fill] = new_elem;
             }
         }
         else {
             sequence[loc_to_fill] = new_elem;
         }
         safety_counter++;
         if (!check_safety_counter()) {
             return generate_sequence(tp, bi, fi, p, N, seq_length);
         }
     }
     return sequence;
 }

 function generate_priming_sequence(tp, bi, fi, reps) {
     // final sequence
     var final_sequence = [];
     
     for(var k=0;k<reps;k++){
         //init sequence
         var sequence = [];
         for(var i=0;i<k+1;i++){
            sequence = _.shuffle(fi);
         }
    
         // pick base loc
         // can't be first or second item. 
         var locs = [2, 3, 4, 5, 6];
         locs = _.shuffle(locs);
         var base_loc = locs[0];
    
         // pick target pair loc
         // must be one item between base and target
         locs = [2, 3, 4, 5, 6, 7];
         for (var i = 0; i < locs.length; i++) {
             if (locs[i] == base_loc || locs[i] == base_loc + 1 || locs[i] == base_loc + 2 || locs[i] == base_loc - 1) {
                 locs.splice(i, 1);
                 i = -1;
             }
         }
         var target_loc = _.shuffle(locs)[0];
    
         sequence.splice(base_loc, 0, bi);
         sequence.splice(target_loc, 0, tp[0], tp[1]);
         
         final_sequence = final_sequence.concat(sequence);
     }

     return final_sequence;
 }



 function validate_sequence(sequence) {
     var validation_obj = {};
     validation_obj.a_b_frequency = a_b_frequency(sequence);
     validation_obj.prior_base_check = prior_base_check(sequence);
     validation_obj.n_reps = n_reps(sequence);
     validation_obj.predictor_check = predictor_check(sequence);

     var valid = (validation_obj.a_b_frequency == 'passed' && validation_obj.prior_base_check == 'passed' && validation_obj.predictor_check == 'passed');

     validation_obj.valid = valid;

     return validation_obj;
 }


 function get_next_element(remaining_items, transition_table, prior_element) {
     // get the appropriate part of the tt
     var tt = transition_table[prior_element];

     // get eligible items
     var ei = get_eligible_items(remaining_items);

     // iterate over eligible items to figure out which one has the lowest
     // number of transitions from the prior_element
     var min = tt[ei[0]];
     var elems = [ei[0]];
     for (var i = 1; i < ei.length; i++) {
         if (tt[ei[i]] < min) {
             min = tt[ei[i]];
             elems = [ei[i]];
         }
         else if (tt[ei[i]] == min) {
             elems.push(ei[i]);
         }
     }

     // elems contains all elements with lowest transition count.
     // randomly pick one.
     var elem = _.shuffle(elems)[0];

     return elem;
 }

 function get_eligible_items(ri) {
     var ei = [];
     var keys = _.keys(ri)
     for (var i = 0; i < keys.length; i++) {
         if (ri[keys[i]] !== 0) {
             ei.push(keys[i]);
         }
     }
     return ei;
 }

 function create_transition_table(arr, possible_elements) {
     var tt = {};
     for (var i = 0; i < possible_elements.length; i++) {
         tt[possible_elements[i]] = {};
         for (var j = 0; j < possible_elements.length; j++) {
             tt[possible_elements[i]][possible_elements[j]] = 0;
         }
     }
     for (var i = 0; i < arr.length - 1; i++) {
         if (typeof arr[i] !== 'undefined' && typeof arr[i + 1] !== 'undefined') {
             tt[arr[i]][arr[i + 1]] = tt[arr[i]][arr[i + 1]] + 1;
         }
     }
     return tt;
 }

 function create_remaining_items_list(N, arr, items) {
     var list = {};
     for (var i = 0; i < items.length; i++) {
         list[items[i]] = N - count_occurences(arr, items[i]);
     }
     return list;
 }

 function count_occurences(arr, target) {
     var count = 0;
     for (var i = 0; i < arr.length; i++) {
         if (arr[i] == target) {
             count++;
         }
     }
     return count;
 }

 function empty_spaces(arr) {
     var spaces = [];
     for (var i = 0; i < arr.length; i++) {
         if (typeof arr[i] === 'undefined') {
             spaces.push(i);
         }
     }
     return spaces;
 }

 function empty_spaces_after_elem(arr) {
     var spaces = [];
     for (var i = 1; i < arr.length; i++) {
         if (typeof arr[i] === 'undefined' && typeof arr[i - 1] != 'undefined') {
             spaces.push(i);
         }
     }
     return spaces;
 }

 function empty_duples(arr) {
     var spaces = [];
     for (var i = 1; i < arr.length; i++) {
         if (typeof arr[i] === 'undefined' && typeof arr[i - 1] === 'undefined') {
             spaces.push(i);
         }
     }
     return spaces;
 }

 function empty_triples(arr) {
     var spaces = [];
     for (var i = 1; i < arr.length - 1; i++) {
         if (typeof arr[i] === 'undefined' && typeof arr[i - 1] === 'undefined' && typeof arr[i + 1] === 'undefined') {
             spaces.push(i);
         }
     }
     return spaces;
 }

 function empty_2_1(arr) {
     var spaces = [];
     for (var i = 2; i < arr.length - 1; i++) {
         if (typeof arr[i] === 'undefined' && typeof arr[i - 1] === 'undefined' && typeof arr[i - 2] === 'undefined' && typeof arr[i + 1] === 'undefined') {
             spaces.push(i);
         }
     }
     return spaces;
 }

 function spaces_after(arr, target) {
     var spaces = [];
     for (var i = 1; i < arr.length; i++) {
         if (arr[i - 1] == target && typeof arr[i] === 'undefined') {
             spaces.push(i);
         }
     }
     return spaces;
 }

 function spaces_before(arr, target) {
     var spaces = [];
     for (var i = 1; i < arr.length; i++) {
         if (typeof arr[i - 1] == 'undefined' && arr[i] == target) {
             spaces.push(i - 1);
         }
     }
     return spaces;
 }

 // check for valid sequence

 function a_b_frequency(sequence) {
     var tt = create_transition_table(sequence, possible_elements);
     var tp = tt[target_pair[0]];

     return ((Math.floor(p * N) === tp[target_pair[1]]) ? 'passed' : 'failed');
 }

 function prior_base_check(sequence) {
     var tt = create_transition_table(sequence, possible_elements);

     var failed = false;

     for (var i = 0; i < possible_elements.length; i++) {
         if (tt[possible_elements[i]][base_item] != 1) {
             if (p != 1 || possible_elements[i] != base_item) {
                 if (p == 1 && tt[possible_elements[i]][base_item] == 0 && possible_elements[i] == target_pair[0]) {
                     //fine
                 }
                 else {
                     failed = true;
                     break;
                 }
             }
         }
     }

     return (failed ? "failed" : "passed");
 }

 function predictor_check(sequence) {
     var tt = create_transition_table(sequence, possible_elements);

     var failed = false;

     for (var i = 0; i < possible_elements.length; i++) {
         if (tt[possible_elements[i]][target_pair[1]] > 1) {
             if (possible_elements[i] != target_pair[0]) {
                 failed = true;
                 break;
             }
         }
     }

     return (failed ? "failed" : "passed");
 }

 function n_reps(sequence) {
     var count = 0;
     var last = sequence[0];
     for (var i = 1; i < sequence.length; i++) {
         if (sequence[i] == last) {
             count++;
         }
         last = sequence[i];
     }
     return count;
 }