Select Location, date, total_cases, new_cases, total_deaths, population
From CovidDeaths
order by 1,2;

--Looking at Total Cases vs Total Deaths

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From CovidDeaths
Where Location like '%India%'
order by 1,2;

--Looking at Total Cases vs Population

Select Location, date, total_cases, population , (total_cases/population)*100 as DeathPercentage
From CovidDeaths
Where Location like '%India%'
order by 1,2;

-- Looking at Countries with highest infection rate compared to population

Select Location, MAX(total_cases) as HighestCount, population , MAX((total_cases/population))*100 as DeathPercentage
From CovidDeaths
Group by population, Location
order by DeathPercentage Desc;

--Showing countries with highest death count per population



Select Location, Continent, MAX(total_deaths) as HighestDeath
From CovidDeaths
Where continent is not null
Group by Continent, Location
order by HighestDeath Desc;

--Global Numbers
Select Location, total_cases, total_deaths, population, (total_deaths/total_cases)*100 as DeathPercentage
From CovidDeaths
Where continent is not null
order by DeathPercentage Desc;

--Looking at total population vs vaccinations

Select dea.continent, dea.location, dea.date, population 
From CovidDeaths dea Join CovidVaccination vac
ON dea.location = vac.location
and dea.date = vac.date

-- Use CTE

With PopvsVac (continent, location, date, population)
as
(
Select dea.continent, dea.location, dea.date, population
From CovidDeaths dea Join CovidVaccination vac
ON dea.location = vac.location
and dea.date = vac.date
)

Select *, population/100
From PopvsVac

 --Temp Tables
 Drop Table if exists #Percentpopulation
 Create Table #PercentPopulation
 (Continent nvarchar(255),
 Location nvarchar(255),
 Date datetime,
 Population numeric,
 Percentpopulation numeric
 )

 Insert into #PercentPopulation
 Select dea.continent, dea.location, dea.date, population, population
From CovidDeaths dea Join CovidVaccination vac
ON dea.location = vac.location
and dea.date = vac.date

Select * from #PercentPopulation

-- Creating View to store data for later visulizations

Create View HighestDeath as
Select Location, Continent, MAX(total_deaths) as HighestDeath
From CovidDeaths
Where continent is not null
Group by Continent, Location


Select AVG(HighestDeath)*100
From HighestDeath;