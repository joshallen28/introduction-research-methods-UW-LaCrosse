/*

Title: Data Vizualization with Stata
by: Josh Allen
input:  penguins.csv based on the palmerpenguins R package 
Version: Stata 16 IC
*/

* Asteriks are how you talk to yourself in code
cls /* Clears the console aka where your code shows up */
clear all /* Clears any data and any thing that is in the memory */
cd "/Users/josh/Dropbox/Data Viz"  /*Tells Stata where to look for things and to save stuff*/

version 15 /* This is for my purpose this sets stata to a previous version */

/* Lets simulate a little data for a toy example */
clear
set seed 1994
set obs 1000

 g y = rnormal(0,1) /* mean = 0, sd = 1 */

 sum y

 hist y, graphregion(color(white)) bin(6) bcolor(gs8) start(-4) normal ///
 xtitle("DV") title("Distribution of The Dependent Variable") ///
 normopts(lcolor(black))

 gr export "hist.png", replace

 

import delimited "penguins.csv", clear

drop if sex == "NA"

set scheme s2color /* Default Stata Scheme */
desc

tw scatter body_mass_g bill_length_mm /* Not great all around so lets change that */

gr export "penguin-basic.png",replace

tw scatter body_mass_g bill_length_mm, graphregion(color(white)) ///
 xtitle("Bill Length(mm)") ytitle("Body Mass(g)")  mcolor(black)
 
 gr export "penguin-basic-with-title.png", replace

*Labelling your variables can save you some time
label var species "Penguin Species"
label var island "Where the Penguins Live"
label var bill_length_mm "Bill Length(mm)"
label var bill_depth_mm "Bill Depth(mm)"
label var flipper_length_mm "Flipper Length(mm)"
label var body_mass_g "Body Mass(g)"
label var sex "Sex of the Penguin"

desc 
/*If you noticed in the last plot some of the points overlapped */

tw scatter body_mass_g bill_length_mm, ylabel(,angle(45)) ///
 jitter(2) jitterseed(1994) graphregion(color(white)) mcolor(black)
 
 gr export "scatter-penguins-jitter.png",replace
 
 
 /* Lets see if this varies by sex */
 tw (scatter body_mass_g bill_length_mm if sex=="male",mcolor(black) ///
 jitter(2) jitterseed(1994)) ///
 (scatter body_mass_g bill_length_mm if sex=="female", msymbol(d) mcolor(red) ///
 jitter(2) jitterseed(1994)), ///
 graphregion(color(white)) ///
ylabel(,angle(360)) /* I do not like the having 
the labels be 90 degrees so lets change that*/

gr export "penguin-sex-body_mass.png",replace 

/* This throws an error because Stata uses boolean operators
  "==" is equals
  "|" is or
   "!" is not
   "&" is and */
 tw (scatter body_mass_g bill_length_mm if sex="male",mcolor(black) ///
 jitter(2) jitterseed(1994)) ///
 (scatter body_mass_g bill_length_mm if sex="female", msymbol(d) mcolor(red) ///
 jitter(2) jitterseed(1994)), ///
 graphregion(color(white)) ///
ylabel(,angle(360))
/*Using schemes saves you a ton of time */


/* Lets also install some of the themes I like */
ssc install scheme-burd, replace

net install scheme-modern, from("https://raw.githubusercontent.com/mdroste/stata-scheme-modern/master/") replace

net install cleanplots, from("https://tdmize.github.io/data/cleanplots") replace

tw scatter body_mass_g flipper_length_mm, mcolor(black) scheme(cleanplots) 

 gr export "theme-example.png", replace

 /* I really like clean plots so lets set it as the permanent default */

 set scheme cleanplots, permanent
 
 /* I also don't like the default font of stata so lets change that */
 
graph set window fontface "Arial Narrow"

tw scatter body_mass_g flipper_length_mm if sex == "female", jitter(2) ///
jitterseed(1994) name(female_scatter,replace)

tw scatter body_mass_g flipper_length_mm if sex == "male", jitter(2) ///
jitterseed(1994) name(male_scatter,replace)

gr combine female_scatter male_scatter, col(1)

gr export "combo-plot.png", replace 



 
/*Lets see if there are any differences among penguin species
We introduced a few things here so lets walk through them
Here we are creating individual scatter plots for each species of penguin
A line fitting through all points using Linear regression
and a legend to tell the readers what it all means */
tw (scatter body_mass_g flipper_length_mm if species== "Gentoo", ///
 jitter(2) jitterseed(1994))  ///
(scatter body_mass_g flipper_length_mm if species== "Adelie", ///
 jitter(2) jitterseed(1994) msymbol(d))  ///
(scatter body_mass_g flipper_length_mm if species== "Chinstrap", ///
jitter(2) jitterseed(1994) msymbol(s)) ///
 (lfit body_mass_g flipper_length_mm if species== "Gentoo") ///
 (lfit body_mass_g  flipper_length_mm if species== "Adelie") ///
 (lfit body_mass_g flipper_length_mm if species== "Chinstrap" ), ///
 legend(order(1 "Gentoo" 2 "Adelie" 3 "Chinstrap")) ///
ytitle("Body Mass in Grams") /* Anything after the comma is global option */

gr export "multiplot-by-penguing.png", replace



 ssc install spineplot 
 ssc install stripplot

/* What if We want to learn where the penguins live */


gr bar, by(species) over(island) blabel(bar)

encode species, g(penguin)
encode island, g(location)
encode sex, g(sex2)

spineplot penguin location /* Really good alternative */



/* You can change this to counts with a differnt option */


gr bar (count), by(species) over(island) blabel(bar) bar(1,bfcolor(blue)) 


/* What if we wnat to know the mean flipper lengths for each species */

gr bar flipper_length_mm, over(species) ytitle("Average Flipper Length")




/* or the distribution of flipper lenghts */

hist flipper_length_mm, by(species) xtitle("Flipper Length (mm)") bin(6) bcolor(gs8)


/* using the scatter plot as an example lets put all of this on one plot */


tw (histogram flipper_length_mm if species == "Gentoo", bcolor(lavender)) ///
 (histogram flipper_length_mm if species == "Adelie", bcolor(yellow)) ///
 (histogram flipper_length_mm if species == "Chinstrap", bcolor(magenta)), ///
  legend(order(1 "Gentoo" 2 "Adelie" 3 "Chinstrap"))

/* What if you wanted to see penguins by sex */




gr bar, by(species) over(sex) stack

/* There is an NA. This is from a dataset called palmer penguins in R.
R codes missing values as NA. So lets just get rid of the NA */



gr bar, by(species) over(sex) /* I want a stacked bar chart to see the proportion */


gr bar sex  species, stack  /* Stata doesn't really like string */


tab sex,g(sex)


rename sex1 female

rename sex2 male



gr bar female male, over(species) stack percent legend(order(1 "Female" 2 "Male"))


/* here is how we can make it a little complicated by creating your own color 
palettes */
net install palettes, replace from("https://raw.githubusercontent.com/benjann/palettes/master/")
net install colrspace, replace from("https://raw.githubusercontent.com/benjann/colrspace/master/")
/*285- 299 needs to be run in one go*/
colorpalette viridis, n(6) nograph /* Viridis is popular color pallete built in */
return list
local color1 = r(p1)
local color2 = r(p2)
local color3 = r(p3)
tw (scatter body_mass_g flipper_length_mm if species== "Gentoo", ///
 mc("`color1'") jitter(2) jitterseed(1994)) ///
(scatter body_mass_g flipper_length_mm if species== "Adelie", ///
 msymbol(dh) mc("`color2'") jitter(2) jitterseed(1994)) ///
(scatter body_mass_g flipper_length_mm if species== "Chinstrap", ///
 msymbol(s) mc("`color3'") jitter(2) jitterseed(1994)) ///
 (lfit body_mass_g flipper_length_mm if species== "Gentoo", lc("`color1'")) /// 
 (lfit body_mass_g  flipper_length_mm if species== "Adelie", lc("`color2'")) ///
 (lfit body_mass_g flipper_length_mm if species== "Chinstrap", lc("`color3'")), ///
 legend(order(1 "Gentoo" 2 "Adelie" 3 "Chinstrap")) 
 
 gr export "multiplot-viridis.png"
 
 /* This is one of my favorite color paletes in R based on New Zealand birds */
capture program drop colorpalette_manu
program colorpalette_manu
    c_local P #fae093, #d04e59, #bc8e7d
end
colorpalette manu, n(3) nograph
return list
local color1 = r(p1)
local colo2 = r(p2)
local color3 = r(p3)
tw (scatter body_mass_g flipper_length_mm if species== "Gentoo", ///
 mc("`color1'") jitter(2) jitterseed(1994)) ///
(scatter body_mass_g flipper_length_mm if species== "Adelie", ///
 msymbol(dh) mc("`color2'") jitter(2) jitterseed(1994)) ///
(scatter body_mass_g flipper_length_mm if species== "Chinstrap", ///
 msymbol(s) mc("`color3'") jitter(2) jitterseed(1994)) ///
 (lfit body_mass_g flipper_length_mm if species== "Gentoo", lc("`color1'")) /// 
 (lfit body_mass_g  flipper_length_mm if species== "Adelie", lc("`color2'")) ///
 (lfit body_mass_g flipper_length_mm if species== "Chinstrap", lc("`color3'")), ///
 legend(pos(11) order(1 "Gentoo" 2 "Adelie" 3 "Chinstrap")) ytitle("Body Weight(g)")
 
 
 
 gr export "penguins-manu-example.png", replace
 
 
