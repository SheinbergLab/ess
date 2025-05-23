
#
# LOADERS
#   match_to_sample colormatch
#
# DESCRIPTION
#   Load trials Present a target color and two choices
#

namespace eval match_to_sample::colormatch {
    proc setup_trials { color_choices scale n_rep } {
	
	# build our stimdg
	if { [dg_exists stimdg] } { dg_delete stimdg }
	set g [dg_create stimdg]
	dg_rename $g stimdg
	
	set xoff 3.0
	set yoff 2.0
	
	set n_obs [expr $n_rep*2]
	
	set maxx [expr $screen_halfx]
	set maxy [expr $screen_halfy]
	
	dl_set $g:stimtype [dl_fromto 0 $n_obs]
	dl_set $g:side [dl_repeat "0 1" $n_rep]
	
	if { $color_choices == "redgreen" } {
	    dl_local red [dl_flist 1 0 0]
	    dl_local green [dl_flist 0 1 0]
	    dl_local sample_colors [dl_repeat [dl_llist $red $green] $n_rep]
	    dl_local nonmatch_colors [dl_repeat [dl_llist $green $red] $n_rep]
	} elseif { $color_choices == "random" } {
	    dl_local sample_colors [dl_urand [dl_repeat 3 $n_obs]]
	    dl_local nonmatch_colors [dl_urand [dl_repeat 3 $n_obs]]
	} elseif { $color_choices == "easy" } {
	    dl_local sample_hues [dl_irand $n_obs 360]
	    dl_local nonmatch_hues [dl_mod [dl_add 180 $sample_hues] 360]
	    dl_local l [dl_repeat 85. $n_obs]
	    dl_local c [dl_repeat 95. $n_obs]
	    dl_local sample_colors \
		[dl_div [dl_transpose \
			     [dlg_polarlabcolors $l $c [dl_float $sample_hues]]] \
		     255.]
	    dl_local nonmatch_colors \
		[dl_div [dl_transpose \
			     [dlg_polarlabcolors $l $c [dl_float $nonmatch_hues]]] \
		     255.]
	}
	
	dl_set $g:sample_x [dl_repeat 0. $n_obs]
	dl_set $g:sample_y [dl_repeat $yoff $n_obs]
	dl_set $g:sample_r [dl_repeat $scale $n_obs]
	dl_set $g:sample_color $sample_colors
	dl_set $g:sample_pos \
	    [dl_reshape [dl_interleave $g:sample_x $g:sample_y] - 2]
	
	
	dl_set $g:match_x [dl_mult 2 [dl_sub $g:side .5] $xoff]
	dl_set $g:match_y [dl_repeat [expr -1*$yoff] $n_obs]
	dl_set $g:match_r [dl_repeat $scale $n_obs]
	dl_set $g:match_color $sample_colors
	dl_set $g:match_pos [dl_reshape [dl_interleave $g:match_x $g:match_y] - 2]
	
	dl_set $g:nonmatch_x [dl_mult 2 [dl_sub [dl_sub 1 $g:side] .5] $xoff]
	dl_set $g:nonmatch_y [dl_repeat [expr -1*$yoff] $n_obs]
	dl_set $g:nonmatch_r [dl_repeat $scale $n_obs]
	dl_set $g:nonmatch_color $nonmatch_colors
	dl_set $g:nonmatch_pos \
	    [dl_reshape [dl_interleave $g:nonmatch_x $g:nonmatch_y] - 2]
	
	dl_set $g:remaining [dl_ones $n_obs]
	
	return $g
    }
}
