---Standarize Date Format

Select SaleDateConverted, CONVERT(Date, Saledate) as NewDate
From NashVille

Alter Table NashVille
Add SaleDateConverted date;

Update NashVille
Set SaleDateConverted = CONVERT(Date, Saledate)

-- Property Address

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From NashVille a
Join NashVille b
     on a.ParcelID = b.ParcelID
	 and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Update a
Set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashVille a
Join PortfolioProject.dbo.NashVille b
     on a.ParcelID = b.ParcelID
	 and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Select * from NashVille
Where PropertyAddress is null

--Breaking out Address into Individiual columns

Select PropertyAddress
From NashVille

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as State
From NashVille

ALTER TABLE NashVille
Add PropertySplitAddress nvarchar(255),
    PropertySplitCity nvarchar(255);

Update NashVille
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

Select PropertySplitAddress, PropertySplitCity 
From NashVille

Select OwnerAddress
From NashVille

Select
PARSENAME(Replace(OwnerAddress,',','.'),3),
PARSENAME(Replace(OwnerAddress,',','.'),2),
PARSENAME(Replace(OwnerAddress,',','.'),1)
From NashVille

ALTER TABLE NashVille
Add OwnerSplitAddress nvarchar(255),
    OwnerSplitCity nvarchar(255),
	OwnerSplitState nvarchar(255);

Update NashVille
Set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress,',','.'),3),
    OwnerSplitCity = PARSENAME(Replace(OwnerAddress,',','.'),2),
	OwnerSplitState = PARSENAME(Replace(OwnerAddress,',','.'),1)

Select OwnerSplitAddress, OwnerSplitCity, OwnerSplitState
From NashVille

--Change Y and N to Yes and No in "Sold as Vacant" Field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From NashVille
Group by SoldAsVacant

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' Then 'Yes'
       When SoldAsVacant = 'N' Then 'No'
	   Else SoldAsVacant
	   END
From NashVille

Update NashVille
Set SoldAsVacant = CASE When SoldAsVacant = 'Y' Then 'Yes'
       When SoldAsVacant = 'N' Then 'No'
	   Else SoldAsVacant
	   END
From NashVille

-- Remove Duplicates
With CTE as (
Select *,
      ROW_NUMBER() over(
	  Partition by ParcelID,
	               PropertyAddress, 
				   SalePrice, 
				   SaleDate, 
				   LegalReference
	  Order by UniqueID) row_num
From NashVille
)
 
Select * from 
CTE
Where row_num > 1
Order by UniqueID


-- Delete Unused Columns

Select * from
NashVille

 
 Alter Table NashVille
 Drop Column OwnerAddress, PropertyAddress, SaleDate, TaxDistrict