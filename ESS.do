**** IDEOLOGICAL EDUCATION AND SUPPORT FOR DEMOCRACY ****
* 13/7 - 2024
* Daniel Carelli, Hilma Lindskog 


**Set working directory**

cd "/Volumes/ShareFile/Shared Folders/Fostering Citizens/Data"

**Set dataset**

use "/Volumes/ShareFile/Shared Folders/Fostering Citizens/Data/ESS/ESS1e06_7-ESS2e03_6-ESS3e03_7-ESS4e04_6-ESS5e03_5-ESS6e02_6-ESS7e02_3-ESS8e02_3-ESS9e03_2-ESS10-ESS10SC-ESS11-subset-2/ESS1e06_7-ESS2e03_6-ESS3e03_7-ESS4e04_6-ESS5e03_5-ESS6e02_6-ESS7e02_3-ESS8e02_3-ESS9e03_2-ESS10-ESS10SC-ESS11-subset.dta", clear


						 
* INDIVIDUAL LEVEL VARIABLES
* INDIVIDUAL LEVEL VARIABLES

*** DEPENDENT
* OM DEMOKRATI: How important for you to live in democratically governed country. democratci direction.  Skewed. (1-10) 
gen democracy = implvdm
drop if democracy <0
tab democracy


* OM AUTHORITARIANISM: 
* Obedience and respect for authority most important  virtues children should learn (1-5)
* DEPENDENT VARIABLE: Obedience and respect for authority most important  virtues children should learn (1-5), liberal direction
gen obedience = lrnobed
drop if obedience <0
tab obedience


* Country needs most loyalty towards its leaders (1-5), liberal direction
gen leader = loylead
drop if leader <0
tab leader


* NATIONALISM
*How emotionally attached to cntry (1-10), nationalistic direction 
gen nation = atchctr
drop if nation <0
tab nation


*** CONTROL VARIABLES: Individual 

* CONTROL VARIABLES 
* AGE <- Både för merge och som kontroll < börjar på 1885
gen yrborn = yrbrn 


*Generate the age variable by subtracting the year of birth from the year of the survey
keep if agea>22


* GEN YEAR WHEN RESPONDENT IS 10 YEARS OLD 
gen yr10 = yrborn + 10

* GENDER (0=man, 1 = woman)
gen gender = gndr 
recode gender(-5/0=.)(1=0)(2=1)
tab gender


* Social class -> eventuellt byt till occupation -> tror onödig kontroll eftersom vi har inkomst och utbildningslängd
*X045 = social class (subjective)

* Income - in deciles, suitable for comparative analysis. 
gen income = hinctnta
drop if hinctnta <0

* Fathers backgorund 
gen father = eiscedf
drop if father == 0 
drop if father == 55

* Place of residence 

*gen place = 


* Education level (three levels and continuous)

recode eisced(0=.)(55=.), gen(edu)
recode eisced(0=.)(55=.)(1/3=1)(4/5=2)(6/7=3), gen(edu3)

* Keep only respondents born in the country 

keep if brncntr == 1

* Remove people still in education? 

drop if edctn>0 


save "/Volumes/ShareFile/Shared Folders/Fostering Citizens/Data/ESS/ESS1e06_7-ESS2e03_6-ESS3e03_7-ESS4e04_6-ESS5e03_5-ESS6e02_6-ESS7e02_3-ESS8e02_3-ESS9e03_2-ESS10-ESS10SC-ESS11-subset_korr.dta", replace


********************** PREPARE EPSM FOR MERGE **********************

use "/Volumes/ShareFile/Shared Folders/Fostering Citizens/Data/WVS/EPSM.dta", clear
rename year yr10
sort country_text_id yr10
drop if yr10 < 1880
drop if yr10 > 2015


* Create a list of the country codes to keep
local countries "ALB AUT BEL BGR CHE CYP CZE DEU DNK EST ESP FIN FRA GBR GRC HRV HUN IRL ISR ISL ITA LTU LUX LVA MNE MKD NLD NOR POL PRT ROU SRB RUS SWE SVN SVK TUR UKR XKX"

* Loop over the list of countries and keep only those observations
gen keep = 0
foreach c in `countries' {
    replace keep = 1 if country_text_id == "`c'"
}
keep if keep == 1
drop keep

* Replace country codes to match the first dataset
replace country_text_id = "AL" if country_text_id == "ALB"
replace country_text_id = "AT" if country_text_id == "AUT"
replace country_text_id = "BE" if country_text_id == "BEL"
replace country_text_id = "BG" if country_text_id == "BGR"
replace country_text_id = "CH" if country_text_id == "CHE"
replace country_text_id = "CY" if country_text_id == "CYP"
replace country_text_id = "CZ" if country_text_id == "CZE"
replace country_text_id = "DE" if country_text_id == "DEU"
replace country_text_id = "DK" if country_text_id == "DNK"
replace country_text_id = "EE" if country_text_id == "EST"
replace country_text_id = "ES" if country_text_id == "ESP"
replace country_text_id = "FI" if country_text_id == "FIN"
replace country_text_id = "FR" if country_text_id == "FRA"
replace country_text_id = "GB" if country_text_id == "GBR"
replace country_text_id = "GR" if country_text_id == "GRC"
replace country_text_id = "HR" if country_text_id == "HRV"
replace country_text_id = "HU" if country_text_id == "HUN"
replace country_text_id = "IE" if country_text_id == "IRL"
replace country_text_id = "IL" if country_text_id == "ISR"
replace country_text_id = "IS" if country_text_id == "ISL"
replace country_text_id = "IT" if country_text_id == "ITA"
replace country_text_id = "LT" if country_text_id == "LTU"
replace country_text_id = "LU" if country_text_id == "LUX"
replace country_text_id = "LV" if country_text_id == "LVA"
replace country_text_id = "ME" if country_text_id == "MNE"
replace country_text_id = "MK" if country_text_id == "MKD"
replace country_text_id = "NL" if country_text_id == "NLD"
replace country_text_id = "NO" if country_text_id == "NOR"
replace country_text_id = "PL" if country_text_id == "POL"
replace country_text_id = "PT" if country_text_id == "PRT"
replace country_text_id = "RO" if country_text_id == "ROU"
replace country_text_id = "RS" if country_text_id == "SRB"
replace country_text_id = "RU" if country_text_id == "RUS"
replace country_text_id = "SE" if country_text_id == "SWE"
replace country_text_id = "SI" if country_text_id == "SVN"
replace country_text_id = "SK" if country_text_id == "SVK"
replace country_text_id = "TR" if country_text_id == "TUR"
replace country_text_id = "UA" if country_text_id == "UKR"
replace country_text_id = "XK" if country_text_id == "XKX"


* Rename the variable to match the first dataset
rename country_text_id cntry
tab cntry


// Check for duplicates with inconsistent values
/*bysort COW_NUM yr10 (national_civics_prim): gen tag = _n == 1
bysort COW_NUM yr10: gen inconsistency = national_civics_prim[1] != national_civics_prim[_N]

// List inconsistencies
list COW_NUM yr10 national_civics_prim if inconsistency */

// Aggregate the necessary variables while keeping all important variables
collapse (mean) national_civics_prim (first) national_civics_contents (first) teacher_training_ideology, by(cntry yr10)

save "/Volumes/ShareFile/Shared Folders/Fostering Citizens/Data/WVS/EPSMkorr_ess.dta", replace


***MERGE datasets with EPSM on year and country*** 
use "/Volumes/ShareFile/Shared Folders/Fostering Citizens/Data/ESS/ESS1e06_7-ESS2e03_6-ESS3e03_7-ESS4e04_6-ESS5e03_5-ESS6e02_6-ESS7e02_3-ESS8e02_3-ESS9e03_2-ESS10-ESS10SC-ESS11-subset_korr.dta", clear


// Aggregate the necessary variables
sort cntry yr10
merge m:1 cntry yr10 using "//Volumes/ShareFile/Shared Folders/Fostering Citizens/Data/WVS/EPSMkorr_ess.dta", keepusing(national_civics_prim national_civics_contents teacher_training_ideology)

drop if _merge==1

drop if _merge==2

drop _merge 
describe national_civics_prim yr10

//MERGE with autocracy variable

merge m:1 cntry yr10 using "/Volumes/ShareFile/Shared Folders/Fostering Citizens/Data/merge_autocracy.dta", keepusing(autocracy)

drop if _merge==1

drop if _merge==2

describe autocracy

******* COUNTRY LEVEL VARIABLES ******
* Main variables 

* Keep only if ideological education in education  
*keep if national_civics_prim == 2

* Code ideological content 
// Split the variable into separate components
gen civics_science = strpos(national_civics_contents, "1") > 0
gen civics_nationalist = strpos(national_civics_contents, "2") > 0
gen civics_regime = strpos(national_civics_contents, "3") > 0
gen civics_leader = strpos(national_civics_contents, "4") > 0
gen civics_democratic = strpos(national_civics_contents, "5") > 0
gen civics_religion = strpos(national_civics_contents, "6") > 0
gen civics_ethnicity = strpos(national_civics_contents, "7") > 0
gen civics_other = strpos(national_civics_contents, "8") > 0

* Generate binary indicators
replace civics_science = civics_science > 0
replace civics_nationalist = civics_nationalist > 0
replace civics_regime = civics_regime > 0
replace civics_leader = civics_leader > 0
replace civics_democratic = civics_democratic > 0
replace civics_religion = civics_religion > 0
replace civics_ethnicity = civics_ethnicity > 0
replace civics_other = civics_other > 0

* Generate authoritarian education (includes regime, nationalist and leader. NOT RELIGION ETHNICITY )
gen authoritarian = 0
replace authoritarian = 1 if civics_nationalist == 1 | civics_regime == 1 | civics_leader == 1
tab authoritarian

* Generate liberal education_level
gen liberal = 0
replace liberal = 1 if civics_science == 1 | civics_democratic == 1 
tab liberal

* Generate pure authoritarian education (no liberal at all)
gen authoritarian_pure = 0
replace authoritarian_pure = 1 if authoritarian == 1 & liberal != 1
tab authoritarian_pure


* Generate pure liberal education (no authoritarian)
gen liberal_pure = 0
replace liberal_pure = 1 if liberal == 1 & authoritarian != 1
tab liberal_pure



******* TEACHER VARIABLES ******** 
* Focus only on those that demand idology and membership in party (the most strict demand)
gen teacher_noID = strpos(teacher_training_ideology, "1") > 0
gen teacher_certainID = strpos(teacher_training_ideology, "2") > 0
gen teacher_specific = strpos(teacher_training_ideology, "3") > 0
gen teacher_demandID = strpos(teacher_training_ideology, "4") > 0

replace teacher_noID = teacher_noID > 0
replace teacher_certainID = teacher_certainID > 0
replace teacher_specific = teacher_specific > 0
replace teacher_demandID = teacher_demandID > 0
tab teacher_demandID

replace teacher_demandID = 0 if teacher_demandID == 1 & autocracy == 0

* Teacher training 
/*tab teacher_training_presence
rename teacher_training_presence teacher_training
drop if teacher_training==1

gen teacher_full = ""
replace teacher_full = "High_ID" if teacher_demandID == 1 & teacher_training == 3
replace teacher_full = "Low_ID" if teacher_demandID == 1 & teacher_training == 2
replace teacher_full = "High_NO_ID" if teacher_demandID == 0 & teacher_training == 3
replace teacher_full = "Low_NO_ID" if teacher_demandID == 0 & teacher_training == 2

encode teacher_full, gen(teacher_full_cat)
tab teacher_full_cat */


* MERGE COUNTRY CONTROLS at ESSROUND and Country from QoG: GDP/Capita, Unemployment, democracy???, share immigrants? 

save "/Volumes/ShareFile/Shared Folders/Fostering Citizens/Data/ESS/ESS1e06_7-ESS2e03_6-ESS3e03_7-ESS4e04_6-ESS5e03_5-ESS6e02_6-ESS7e02_3-ESS8e02_3-ESS9e03_2-ESS10-ESS10SC-ESS11-subset_FINAL.dta", replace

************************ MAIN ANALYSIS ************************
****************************************************************
* SUMMARY TABLE OF DESCRIPTIVES 
use "/Volumes/ShareFile/Shared Folders/Fostering Citizens/Data/countrycontrols/country_controls.dta", clear
recast int surveyyear

sort cntry surveyyear

save "/Volumes/ShareFile/Shared Folders/Fostering Citizens/Data/countrycontrols/country_controls_korr.dta", replace

***********************************************************************

use "/Volumes/ShareFile/Shared Folders/Fostering Citizens/Data/ESS/ESS1e06_7-ESS2e03_6-ESS3e03_7-ESS4e04_6-ESS5e03_5-ESS6e02_6-ESS7e02_3-ESS8e02_3-ESS9e03_2-ESS10-ESS10SC-ESS11-subset_FINAL.dta", clear

rename essround surveyyear
drop _merge
recast int surveyyear
drop if surveyyear<10
recode surveyyear (10=2014) (11=2018)
tab surveyyear

*Add country level controls
merge m:1 cntry surveyyear using "/Volumes/ShareFile/Shared Folders/Fostering Citizens/Data/countrycontrols/country_controls_korr.dta", keepusing(e_gdppc oecd_unemplrt_t1c v2x_libdem)

keep if _merge == 3

rename e_gdppc gdp
rename oecd_unemplrt_t1c employment
rename v2x_libdem demo

* The analysis includes weights and fixed effect for surveyyear and individual level control variables 
* On authoirtarianism: strong leader (1-4 liberal direction)
*mixed obedience authoritarian_pure i.teacher_training i.teacher_demandID i.gender c.age c.income education_level i.essround || cntry:
*keep if e(sample)
alpha leader obedience // alpha 65 så hög! 
gen authoritarian_index = leader + obedience 
*[pweight=anweight]



***********************
* Slutanalys
********************
reg authoritarian_index c.edu i.authoritarian_pure teacher_demandID i.gender c.agea c.income i.surveyyear
keep if e(sample)

mixed authoritarian_index c.edu i.surveyyear c.gdp c.demo c.employment || cntry: 
estimates store model1
estat icc

mixed authoritarian_index c.edu i.gender c.agea c.income i.surveyyear c.gdp c.demo c.employment || cntry:
estimates store model2
estat icc

mixed authoritarian_index c.edu##i.authoritarian_pure i.gender c.agea c.income i.surveyyear c.gdp c.demo c.employment || cntry:
estimates store model3
estat icc

mixed authoritarian_index c.edu##i.teacher_demandID i.gender c.agea c.income i.surveyyear i.authoritarian_pure c.gdp c.demo c.employment || cntry:
estimates store model4
estat icc

* Display the results with standard errors and export to RTF
esttab model1 model2 model3 model4 using "final_models_results_new.rtf", se replace
eststo clear




* MARGINPLOTS 
* VISUALIZE INTERACTION EFFECTS 
* CURRICULUM
* Mixed model for curriculum and authoritarian index
mixed authoritarian_index c.edu##i.authoritarian_pure i.gender c.agea c.income i.surveyyear c.gdp c.demo c.employment || cntry:

* Generate margins plot
quietly margins, at(edu=(1(1)7) authoritarian_pure=(0 1)) atmeans vsquish
marginsplot, title("Curriculum") ///
    ytitle("Authoritarianism") ///
    xtitle("Education") ///
    ylabel(3(1)7) ///
    noci ///
    legend(order(1 "Neutral" 2 "Authoritarian")) ///
	    graphregion(color(white)) ///
    bgcolor(white) ///
    scheme(s2mono)

* Export the graph as a high-resolution PNG file
graph export "Graph_curriculum.png", replace resolution(300)


* TEACHER IDEOLOGY 
* Mixed model for teacher ideology and authoritarian index
mixed authoritarian_index c.edu##i.teacher_demandID i.gender c.agea c.income i.surveyyear i.authoritarian_pure c.gdp c.demo c.employment || cntry: 

* Generate margins plot
quietly margins, at(edu=(1(1)7) teacher_demandID=(0 1)) atmeans vsquish
marginsplot, title("Teacher Ideology") ///
    ytitle("Authoritarianism") ///
    xtitle("Education") ///
    ylabel(3(1)7) ///
	yscale(off) ///
    noci ///
    legend(order(1 "Neutral" 2 "Authoritarian = 1")) ///
	    graphregion(color(white)) ///
    bgcolor(white) ///
    scheme(s2mono)
graph export "Graph_teacher.png", replace resolution(300)



* Combine the two saved graphs into one figure
graph combine Graph_curriculum.gph Graph_teacher.gph, ///
    title("Marginsplot: Curriculum and Teacher Ideology") ///
    cols(2)


* mixed authoritarian_index c.edu##i.teacher_demandID i.gender c.agea c.income i.surveyyear c.gdp c.demo c.employment || cntry:


*mixed authoritarian_index c.edu##i.teacher_demandID i.authoritarian_pure i.gender c.agea c.income i.essround || cntry:

* father background as a control in a footnote/appendic as we loose observations with it in 


*/* DEPENDENT: OBEDIANCE - liberal direction (education did not work to add? nor weights)
mixed obedience i.authoritarian_pure i.essround || cntry: 
mixed obedience i.authoritarian_pure c.edu i.gender c.agea c.income i.essround || cntry:
mixed obedience i.authoritarian_pure##c.edu i.gender c.agea c.income i.essround || cntry:
mixed obedience i.authoritarian_pure##i.teacher_demandID i.essround || cntry:
mixed obedience i.authoritarian_pure##i.teacher_training i.essround || cntry:

mixed obedience i.authoritarian i.essround || cntry: 
mixed obedience i.authoritarian##c.edu i.gender c.agea c.income i.essround || cntry:
mixed obedience i.authoritarian##i.edu3 i.gender c.agea c.income i.essround || cntry:
mixed obedience i.authoritarian i.gender c.agea i.edu3 c.income i.essround  || cntry:
mixed obedience i.authoritarian##i.teacher_demandID i.essround || cntry:
mixed obedience i.authoritarian##i.teacher_training i.essround || cntry:



* Exakt samma resultat: man blir mer liberal men sbvagare effekt om duktiga/övertygade lärare! 

* DEPENDENT: Leader - liberal direction (education did not work to add? nor weights)
mixed leader i.authoritarian_pure i.essround || cntry: 
mixed leader i.authoritarian_pure c.edu i.gender c.agea c.income i.essround || cntry:
mixed leader i.authoritarian_pure##c.edu i.gender c.agea c.income i.essround || cntry:
mixed leader i.authoritarian_pure##i.teacher_demandID i.essround || cntry:
mixed leader i.authoritarian_pure##i.teacher_training i.essround || cntry:

mixed leader i.authoritarian i.essround || cntry: 
mixed leader i.authoritarian##c.edu i.gender c.agea c.income i.essround || cntry:
mixed leader i.authoritarian##i.edu3 i.gender c.agea c.income i.essround || cntry:
mixed leader i.authoritarian i.gender c.agea i.edu3 c.income i.essround  || cntry:
mixed leader i.authoritarian##i.teacher_demandID i.essround || cntry:
mixed leader i.authoritarian##i.teacher_training i.essround || cntry:

* DEPENDENT, authoritarianism :Exakt samma resultat: man blir mer liberal men sbvagare effekt om duktiga/övertygade lärare! 

mixed authoritarian_index i.authoritarian_pure i.essround || cntry: 
mixed authoritarian_index i.authoritarian_pure c.edu i.gender c.agea c.income i.essround || cntry:
mixed authoritarian_index i.authoritarian_pure##c.edu i.gender c.agea c.income i.essround || cntry:
mixed authoritarian_index i.authoritarian_pure##i.teacher_demandID i.essround || cntry:
mixed authoritarian_index i.authoritarian_pure##i.teacher_training i.essround || cntry:


mixed authoritarian_index i.authoritarian i.essround || cntry: 
mixed authoritarian_index i.authoritarian##c.edu i.gender c.agea c.income i.essround || cntry:
mixed authoritarian_index i.authoritarian##i.edu3 i.gender c.agea c.income i.essround || cntry:
mixed authoritarian_index i.authoritarian i.gender c.agea i.edu3 c.income i.essround  || cntry:
mixed authoritarian_index i.authoritarian##i.teacher_demandID i.essround || cntry:
mixed authoritarian_index i.authoritarian##i.teacher_training i.essround || cntry:

* Eventuellt kombinera den - teacher demand ID och högutbildade */ 









* Separat 
mixed leader c.edu i.essround || cntry: 
mixed leader c.edu i.gender c.agea c.income i.essround || cntry:
mixed leader c.edu##i.authoritarian i.gender c.agea c.income i.essround || cntry:
mixed leader c.edu##i.authoritarian_pure i.gender c.agea c.income i.essround || cntry:
mixed leader c.edu##i.teacher_demandID i.gender c.agea c.income i.essround || cntry:


mixed obedience c.edu i.essround || cntry: 
mixed obedience c.edu i.gender c.agea c.income i.essround || cntry:
mixed obedience c.edu##i.authoritarian i.gender c.agea c.income i.essround || cntry:
mixed obedience c.edu##i.authoritarian_pure i.gender c.agea c.income i.essround || cntry:
mixed obedience c.edu##i.teacher_demandID i.gender c.agea c.income i.essround || cntry:



mixed authoritarian_index c.edu i.essround || cntry: 
mixed authoritarian_index c.edu i.gender c.agea c.income i.essround || cntry:
mixed authoritarian_index c.edu##i.authoritarian_pure i.gender c.agea c.income i.essround || cntry:





* DEPENDENT: DEMOCRACY (democratci direction)
* Exakt samma resultat: man blir mer liberal men sbvagare effekt om duktiga/övertygade lärare! 

mixed democracy i.authoritarian_pure i.essround || cntry: 
mixed democracy i.authoritarian_pure i.gender c.agea c.income i.essround || cntry:
mixed democracy i.authoritarian_pure##i.teacher_demandID i.essround || cntry:
mixed democracy i.authoritarian_pure##i.teacher_training i.essround || cntry:




* MODEL SPECIFICATION 
* Weights - Anweight
