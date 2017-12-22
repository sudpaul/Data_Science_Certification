SELECT 
	a.Title AS Album_Title
	, t.Name AS Track_Name
	, il.InvoiceId AS Invoice_Id
FROM track t
LEFT JOIN invoiceLine il
	ON t.TrackId = il.TrackId
JOIN album AS a
	ON a.AlbumId = t.AlbumId
ORDER BY Track_Name DESC, Invoice_Id DESC;


SELECT c.LastName , a.Title, t.Name, CONVERT(InvoiceDate, CHAR CHARACTER SET utf8) AS PurchaseDate FROM Album AS a JOIN Track AS t
ON a.AlbumId = t.AlbumId
JOIN InvoiceLine AS il
ON t.TrackId = il.TrackId
JOIN Invoice AS i
ON il.InvoiceId = i.InvoiceId
JOIN Customer AS c 
ON i.CustomerId = c.CustomerId
WHERE c.FirstName = 'Julia'
ORDER BY PurchaseDate, a.Title, t.name;

SELECT c.FirstName, c.LastName, SUM(i.Total) AS TotalSales FROM customer c JOIN
invoice i ON c.CustomerId = i.CustomerId GROUP BY c.FirstName, c.LastName HAVING TotalSales>42;


SELECT 	a.Name TopArtist
FROM track t
JOIN album al
	ON al.AlbumId = t.AlbumId
JOIN artist a
	ON a.ArtistId = al.ArtistId
GROUP BY a.Name
ORDER BY Count(a.Name) DESC
LIMIT 1;

SELECT FirstName, LastName, Title, CASE
WHEN Title LIKE '%Sales%' THEN 'Sales'
WHEN Title LIKE '%IT' THEN 'TECHNOLOGY'
WHEN Title LIKE '%Manager' THEN 'Management' 
END Department 
ORDER BY Management, 



SELECT c.LastName , a.Title, t.Name, CONVERT(InvoiceDate, CHAR CHARACTER SET utf8) AS PurchaseDate FROM Album AS a JOIN Track AS t
ON a.AlbumId = t.AlbumId
JOIN InvoiceLine AS il
ON t.TrackId = il.TrackId
JOIN Invoice AS i
ON il.InvoiceId = i.InvoiceId
JOIN Customer AS c 
ON i.CustomerId = c.CustomerId
WHERE c.FirstName = 'Julia'
ORDER BY PurchaseDate, a.Title, t.name;



SELECT a.Name AS ArtistName, SUM(i.Total) AS TotalSales FROM artist a JOIN album al ON a.ArtistId = al.ArtistId JOIN track t ON al.AlbumId = t.AlbumId
JOIN invoiceLine il t.TrackId= il.TrackId JOIN invoice i ON il.InvoiceId= i.InvoiceId JOIN MediaType m ON t.MediaTypeId = m.MediaTypeId
GROUP BY a.Name
WHERE i.InvoiceDate Between ('2011-07-01' AND '2012-06-30') AND m.MediaTypeId <> 3 LIMIT 10;


SELECT a.Name AS ArtistName
	, ((COUNT(a.Name))*il.UnitPrice) AS TotalSale
FROM invoice i
JOIN invoiceLine il
	ON i.InvoiceId = il.InvoiceId
JOIN track t
	ON il.TrackId = t.TrackId
JOIN album al
	ON t.AlbumId = al.AlbumId
JOIN artist a
	ON a.ArtistId = al.ArtistId
JOIN mediaType m
	ON t.MediaTypeId = m.MediaTypeId
WHERE m.Name LIKE '%audio%'
	AND i.InvoiceDate BETWEEN '2011-07-01' AND '2012-06-30'
GROUP BY a.Name
	, il.UnitPrice
ORDER BY ((COUNT(a.Name))*il.UnitPrice) DESC LIMIT 10;



CREATE VIEW Track_v AS
SELECT t.* , g.Name AS GenreName, m.Name AS MediaTypeName FROM track t
JOIN genre g ON t.GenreId = g.GenreId  JOIN 
mediatype m ON t.MediaTypeId = m.MediaTypeId;

DELIMITER $$

CREATE FUNCTION ArtistAlbum_fn_edw (track_id int)
RETURNS varchar(100)

BEGIN
	 DECLARE ArtistAlbum varchar(100);
	 SELECT CONCAT(a.Name, '-', al.Title) 
	 INTO ArtistAlbum
	 FROM artist a JOIN album al ON a.ArtistId = al.ArtistId JOIN
	 track t ON al.AlbumId = t.AlbumId WHERE t.TrackId = track_id;
     
	 RETURN ArtistAlbum; 

END$$


DELIMITER $$

CREATE PROCEDURE TrackByArtist_sp (IN artist_name varchar(100))

BEGIN
	 SELECT a.Name AS ArtistName, al.Title AS AlbumTitle, t.Name AS TrackName 
	 
	 FROM track t
	 RIGHT JOIN album al
	 ON t.AlbumId = al.AlbumId
     RIGHT JOIN artist a
	 ON al.ArtistId = a.ArtistId
     WHERE a.Name LIKE CONCAT('%', artist_name, '%');
  
END $$

SELECT
ArtistAlbum_fn_edw(TrackId) AS Artist_Album, Name AS TrackName
FROM Track_v
WHERE GenreName = 'Opera';





SELECT a.Name AS Artist_Name, ((COUNT(a.Name))*il.UnitPrice) AS Total_Sales, YEAR(i.InvoiceDate) AS Invoice_Year 
FROM artist a JOIN album al ON a.ArtistId = al.ArtistId 
JOIN track t ON al.AlbumId =t.AlbumId
JOIN invoiceline il ON t.TrackId = il.TrackId 
JOIN invoice i ON il.InvoiceId = i.InvoiceId 
WHERE i.InvoiceDate BETWEEN '2011-07-01' AND '2012-06-30'
GROUP BY a.Name
ORDER BY Total_Sales
LIMIT 10;



SELECT a.Name AS Artist_Name
	, ((COUNT(a.Name))*il.UnitPrice) AS Total_Sales
FROM invoice i
JOIN invoiceline il
ON i.InvoiceId = il.InvoiceId
JOIN track t
ON il.TrackId = t.TrackId
JOIN album al
ON t.AlbumId = al.AlbumId
JOIN Artist a
ON a.ArtistId = al.ArtistId
JOIN mediatype mt
ON t.MediaTypeId = mt.MediaTypeId
WHERE mt.Name LIKE '%audio%'
AND i.InvoiceDate BETWEEN '2011-07-01' AND '2012-06-30'
GROUP BY a.Name, IL.UnitPrice
ORDER BY Total_Sales DESC
LIMIT 10;



SELECT 
CONCAT(e.FirstName, ' ', e.LastName) AS Employee_Name, 
YEAR(i.InvoiceDate) AS Fiscal_Year, 
CASE QUARTER(i.InvoiceDate)
WHEN 1 THEN 'Fisrt' 
WHEN 2 THEN 'Second' 
WHEN 3 THEN 'Third'
ELSE 'Fourth' END AS Sales_Quarter, 
MAX(i.Total) AS Highest_Sale,
COUNT(i.Total) AS Number_Of_Sales, 
SUM(i.Total) AS Total_Sales 
FROM employee e JOIN customer c ON e.EmployeeId = c.SupportRepId 
JOIN invoice i
ON c.CustomerId = i.CustomerId 
WHERE i.InvoiceDate BETWEEN '2010-01-01' AND '2012-06-30' 
GROUP BY CONCAT(e.FirstName, ' ', e.LastName), YEAR(i.InvoiceDate), QUARTER(i.InvoiceDate)
ORDER BY Employee_Name, Fiscal_Year, QUARTER(i.InvoiceDate); 




SELECT 
	P.Name AS Playlist_Name
	, MAX(Py.PlaylistId) AS Playlist_ID
	, PT.TrackId AS Track_ID
From
	(SELECT Name ,COUNT(*) c
		FROM Playlist
		GROUP BY Name
		HAVING COUNT(*)>1
	)  P
JOIN Playlist Py
	ON P.Name = Py.Name
LEFT JOIN PlaylistTrack PT
	ON Py.PlaylistId = PT.PlaylistId
GROUP BY
	P.Name
	, PT.TrackId
ORDER BY Playlist_Name



SELECT 
       i.BillingCountry AS Country, a.Name AS Artist_Name ,
       COUNT(t.TrackId) AS Track_Count, COUNT(DISTINCT (t.TrackId)) AS Unique_Track_Count,

       (COUNT(t.TrackId) - COUNT(DISTINCT(t.TrackId))) AS Count_Difference, 
	    (COUNT(il.Quantity) * t.UnitPrice) AS Total_Revenue, 
		
		CASE m.MediaTypeId

		WHEN  3 THEN 'Video'
		ELSE 'Audio'
		
		END AS MediaType_Name

FROM  invoice i JOIN invoiceline il ON i.InvoiceId = il.InvoiceId 

JOIN track t ON il.TrackId = t.TrackId JOIN album al ON t.AlbumId = al.AlbumId 

JOIN artist a ON al.ArtistId = a.ArtistId 

JOIN mediatype m ON t.MediaTypeId=m.MediaTypeId

WHERE i.InvoiceDate BETWEEN '2009-07-01' AND '2013-06-30' 

GROUP BY i.BillingCountry, a.Name
ORDER BY i.BillingCountry, COUNT(t.TrackId)  DESC, a.Name;

SELECT 
m.Name AS Media_Type, 

g.Name AS Genre_Name,

COUNT(DISTINCT t.TrackId) AS Unique_Track_Count, 

SUM(il.Quantity) AS Tracks_Purchase_Count,

(COUNT(il.Quantity)* t.UnitPrice) AS Total_Revenue, 

CONVERT(100.0*(SUM(il.Quantity)/ COUNT(DISTINCT t.TrackId)),DECIMAL(5,2)) AS Percentile
  
FROM mediatype m JOIN track t ON m.MediaTypeId = t.MediaTypeId 
JOIN genre g ON t.GenreId = g.GenreId 
JOIN invoiceline il ON t.TrackId = il.TrackId

GROUP BY g.Name, m.Name

HAVING  (((COUNT(il.Quantity))*0.99)< 10.00) OR (CONVERT(100.00*(SUM(il.Quantity)/ COUNT(DISTINCT t.TrackId)),DECIMAL(5,2))< 50.00)

ORDER BY Total_Revenue ASC, Percentile DESC, Genre_Name ASC;
