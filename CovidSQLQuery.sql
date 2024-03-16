Use CovidProject

Select * From CovidDeaths
Order by 3,4

--Select * 
--From CovidVaccinations
--Order by 3,4

Select Location, date, total_cases, new_cases, total_deaths, population
From CovidDeaths
Order by 1,2

-- Looking at total cases vs total death for each country 
-- and then calculate the death ratio
-- Shows how likely it is to die if you contract covid in that country.

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_perc
From CovidDeaths
Where continent is not null
Order by 1,2

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_perc
From CovidDeaths
Where Location = 'India'
and continent is not null
Order by 1,2 

--In India, 
--1st case reported on: 2020-01-30 (30th Jan 2020)
--1st death reported on: 2020-03-11 (11th March 2020)
--	total cases on that day: 62
--	death percentage: 1.61%
--total cases at the end of year 2020: 10266674
--total deaths at the end of year 2020: 148738
--death percentage at the end of the year: 1.45%
-- In this dataset, maximum recorded death percentage: 3.60% 
--                                   date: 2020-04-12 (12th April 2020)
--                      On that day, cases: 9205 
--						On that day, deaths: 331
--At the end of this dataset, total cases: 19164969
--                            total deaths: 211853
--							  death percentage: 1.10%
--							  date: 2021-04-30 (30th April 2021)



-- Total cases vs Population
-- Shows what percantage of the population got Covid

Select continent, Location, date, total_cases, population, 
       (total_cases/population)*100 as population_perc_infected
From CovidDeaths
--Where Location = 'India'
Order by 1,2,3 


-- Looking at countries with highest infection count compared to the population

Select continent, Location, population, max(total_cases) as highest_infection_count, 
       max((total_cases/population))*100 as population_perc_infected
From CovidDeaths
--Where Location = 'India'
Where continent is NOT null
Group by continent, location, population
Order by 4 desc


-- And now the countries with highest death count compared to the population

Select continent, location, max(cast(total_deaths as int)) as total_death_count 
From CovidDeaths
--Where Location = 'India'
Where continent is NOT null
Group by continent, location  
Order by 2 desc


-- Lets break down by continent

Select continent, max(cast(total_deaths as int)) as total_death_count 
From CovidDeaths
--Where Location = 'India'
Where continent is not null
Group by continent 
Order by 2 desc


-- GLOBAL NUMBERS - These are calculations across the world, not particularly for any country for each day

Select date, sum(new_cases) as no_of_cases, sum(cast(new_deaths as int)) as no_of_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as death_perc
From CovidDeaths
-- Where Location = 'India'
Where continent is not null
Group by date
Order by 1


-- Final summation of cases, death and death percentage across the world

Select sum(new_cases) as no_of_cases, sum(cast(new_deaths as int)) as no_of_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as death_perc
From CovidDeaths
-- Where Location = 'India'
Where continent is not null
--Group by date
Order by 1

-- Total no. of cases =  150574977
-- Total no. of deaths =   3180206
-- Total death percentage = 2.11% of infected people died across the world

-- Let's look at the vaccination table now.

Select * 
From CovidVaccinations


-- Looking at total population vs vaccinations in the world

-- Let's join both the Death and the Vaccinations table for easy access to data

Select d.continent, d.location, d.date, d.population, v.new_vaccinations
From CovidDeaths d
Join CovidVaccinations v
	On d.location = v.location
	and d.date = v.date
Where d.continent is not null
Order by 1,2,3


-- Earliest vaccinations and related data

Select d.continent, d.location, d.date, d.population, v.new_vaccinations
From CovidDeaths d
Join CovidVaccinations v
	On d.location = v.location
	and d.date = v.date
Where d.continent is not null
and v.new_vaccinations is not null
Order by 3
-- Earliest vaccination recorded in Canada on 15th Dec 2020


-- In India:

Select d.date, v.new_vaccinations
From CovidDeaths d
Join CovidVaccinations v
	On d.location = v.location
	and d.date = v.date
Where d.continent is not null
and d.location = 'India' 
Order by 1
-- Vaccination started on 16th January 2021; starting with 191181 vaccinations on the 1st day.


-- Let's create a vaccination counter for summing total new vaccinations each day 

Select d.continent, d.location, d.date, d.population, v.new_vaccinations,
       SUM(convert(int, v.new_vaccinations)) Over(Partition by d.location Order by d.location, d.date)
	   as vacc_sum_perday
	   --(vacc_sum_perday/d.population)*100
From CovidDeaths d
Join CovidVaccinations v
	On d.location = v.location
	and d.date = v.date
Where d.continent is not null
Order by 2,3


-- Using CTE:

With vacc_counter (Continent, Location, Date, Population, New_Vaccinations, Vacc_Sum_Perday)
as
(
Select d.continent, d.location, d.date, d.population, v.new_vaccinations,
       SUM(convert(int, v.new_vaccinations)) Over(Partition by d.location Order by d.location, d.date)
	   as vacc_sum_perday
	   --(vacc_sum_perday/d.population)*100
From CovidDeaths d
Join CovidVaccinations v
	On d.location = v.location
	and d.date = v.date
Where d.continent is not null
)
Select *, (Vacc_Sum_Perday/Population)*100 as Vacc_Perc
From vacc_counter
Order by 2,3


-- Using sub-queries

Select *, (vacc_sum_perday/population)*100 as Vacc_perc
From
(Select d.continent, d.location, d.date, d.population, v.new_vaccinations,
       SUM(convert(int, v.new_vaccinations)) Over(Partition by d.location Order by d.location, d.date)
	   as vacc_sum_perday
	   --(vacc_sum_perday/d.population)*100
From CovidDeaths d
Join CovidVaccinations v
	On d.location = v.location
	and d.date = v.date
Where d.continent is not null) a
Order by 2,3


-- Using Temp table

CREATE TABLE Vacc_counter
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
new_vaccinations numeric,
vacc_sum_perday numeric
)

INSERT INTO Vacc_counter
Select d.continent, d.location, d.date, d.population, v.new_vaccinations,
       SUM(convert(int, v.new_vaccinations)) Over(Partition by d.location Order by d.location, d.date)
	   as vacc_sum_perday
	   --(vacc_sum_perday/d.population)*100
From CovidDeaths d
Join CovidVaccinations v
	On d.location = v.location
	and d.date = v.date
Where d.continent is not null
--Order by 2,3

Select *, (Vacc_sum_perday/population)*100 as Vacc_perc
From Vacc_counter
Order by 2,3

-- If we make any changes to the temp table and re-run that query it will show
-- error as the same table is already created, so we will add 1 line at the start
-- It will automatically replace the existing table with the updated one:

DROP TABLE if exists Vacc_counter
CREATE TABLE Vacc_counter
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
new_vaccinations numeric,
vacc_sum_perday numeric
)
INSERT INTO Vacc_counter
Select d.continent, d.location, d.date, d.population, v.new_vaccinations,
       SUM(convert(int, v.new_vaccinations)) Over(Partition by d.location Order by d.location, d.date)
	   as vacc_sum_perday
	   --(vacc_sum_perday/d.population)*100
From CovidDeaths d
Join CovidVaccinations v
	On d.location = v.location
	and d.date = v.date
Where d.continent is not null
--Order by 2,3

Select *, (Vacc_sum_perday/population)*100 as Vacc_perc
From Vacc_counter
Order by 1,2,3


-- Creating view to store data for later visualizations

Create View Vacc_consecutive as
Select d.continent, d.location, d.date, d.population, v.new_vaccinations,
       SUM(convert(int, v.new_vaccinations)) Over(Partition by d.location Order by d.location, d.date)
	   as vacc_sum_perday
	   --(vacc_sum_perday/d.population)*100
From CovidDeaths d
Join CovidVaccinations v
	On d.location = v.location
	and d.date = v.date
Where d.continent is not null
--Order by 2,3

Select *, (vacc_sum_perday/population)*100 as vacc_perc
From Vacc_consecutive
Where new_vaccinations is not null
Order by 2,3