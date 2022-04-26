*******************************************************************************
*
*
*Making one background variable file from all background variables in LISS
*
*
*
* Syntax by Klara Raiber - Stata 16
*
*******************************************************************************

*******************************************************************************
*
* 
********************************************************************************
clear
set more off

capture log close


*******************************************************************************
*
*Naming variables after data sets + create new data sets 
********************************************************************************
*cd "" // set cd to the folder where all downloaded background variables are in 
// - downloaded from https://www.dataarchive.lissdata.nl/study_units/view/322


local files : dir . files "*.dta"  //  "*" is needed - 
foreach aaa of local files {
   use `aaa', clear
   local name_dataset = substr("`aaa'", 7, 6)
    foreach x of varlist _all {
	rename `x' `x'_`name_dataset'
}   

rename nomem_encr* nomem_encr

local new = subinstr("`aaa'", ".dta", "", .) + "_done.dta"
save "`new'", replace  
}
dir *.dta

*******************************************************************************
*
*Merging all data sets together 
********************************************************************************
use "", clear // insert date file that you want to merge the background variables with 
// or open the first background variable data set

local files : dir . files "*_done.dta"  //  "*" is needed.

foreach bbb of local files {
	use "merged_data.dta", clear
  merge 1:1 nomem_encr using "`bbb'" 
  drop _merge
  drop if v1 == .
  save "merged_data.dta", replace
}

use "merged_data.dta", clear

save "", replace // save it with the wished name 