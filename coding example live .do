/* 

Basic Data Viz
Author: Josh Allen
input: palmerpenguins */
cls 
clear all 

cd "/Users/josh/Dropbox/Data Viz"


import delimited "penguins.csv", clear 

drop if sex == "NA"

label var species "Penguin Species"
label var island "Where the Penguins Live"
label var bill_length_mm "Bill Length(mm)"
label var bill_depth_mm "Bill Depth(mm)"
label var flipper_length_mm "Flipper Length(mm)"
label var body_mass_g "Body Mass(g)"
label var sex "Sex of the Penguin"

desc

set scheme s2color


twoway scatter body_mass_g flipper_length_mm

twoway scatter body_mass_g flipper_length_mm, graphregion(color(white)) ///
xtitle("Flipper Length(mm)") ytitle("Body Mass(G)")


twoway scatter body_mass_g flipper_length_mm, graphregion(color(white)) ///
xtitle("Flipper Length(mm)") ytitle("Body Mass(G)") ylabel(,angle(360)) ///
mcolor(black) jitter(4) jitterseed(1994) 


twoway (scatter body_mass_g flipper_length_mm if sex == "male", mcolor(red) ///
        jitter(4) jitterseed(1994)) ///
       (scatter body_mass_g flipper_length_mm if sex == "female", mcolor(black) ///
	     msymbol(d) jitter(4) jitterseed(1994)), xtitle("Flipper Length(mm)") ///
		 ytitle("Body Mass(G)") ylabel(,angle(360))  graphregion(color(white))
		 

	twoway (scatter body_mass_g flipper_length_mm if sex == "male", mcolor(red) ///
        jitter(4) jitterseed(1994)) ///
       (scatter body_mass_g flipper_length_mm if sex == "female", mcolor(black) ///
	     msymbol(d) jitter(4) jitterseed(1994)), xtitle("Flipper Length(mm)") ///
		 ytitle("Body Mass(G)") ylabel(,angle(360))  graphregion(color(white)) ///
		 scheme(cleanplots) legend(order(1 "Male" 2 "Female")) 
		 
		 net install scheme-modern, from("https://raw.githubusercontent.com/mdroste/stata-scheme-modern/master/") replace

net install cleanplots, from("https://tdmize.github.io/data/cleanplots") replace


set scheme cleanplots, perm






twoway scatter body_mass_g flipper_length_mm || ///
lfit body_mass_g flipper_length_mm






twoway scatter body_mass_g flipper_length_mm if sex == "male", name(male,replace) ///
jitter(4) jitterseed(1994) title("Male Body Mass G") xlabel(180(10)240)


twoway scatter body_mass_g flipper_length_mm if sex == "female", name(female,replace) ///
jitter(4) jitterseed(1994) title("Female Body Mass G") xlabel(170(10)230)


gr combine male female, col(1)



twoway (scatter body_mass_g flipper_length_mm if species == "Adelie",jitter(4) ///
jitterseed(1994) mcolor(blue))  ///
(scatter body_mass_g flipper_length_mm if species == "Gentoo",jitter(4) ///
jitterseed(1994) mcolor(purple) msymbol(D)) ///
(scatter body_mass_g flipper_length_mm if species == "Chinstrap",jitter(4) ///
jitterseed(1994) mcolor(magenta) msymbol(s))  ///
(lfit body_mass_g flipper_length_mm if species == "Adelie", lcolor(blue)) ///
(lfit body_mass_g flipper_length_mm if species == "Gentoo", lcolor(purple)) ///
(lfit body_mass_g flipper_length_mm if species == "Chinstrap", lcolor(magenta)), ///
legend(pos(11) order(1 "Adelie" 2 "Gentoo" 3 "Chinstrap"))

gr bar (count),  by(island) over(species)  blabel(bar)

gr export "where-penguins-live.png", replace 


 ssc install spineplot 

spineplot species sex 

encode species, g(penguins)
encode sex, g(sex2)

encode island, g(location)


spineplot penguins sex2


spineplot penguins location















