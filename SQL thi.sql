CREATE DATABASE MyBlog
GO

USE MyBlog
GO

CREATE TABLE Users
(
	UserID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
    UserName varchar(20) NOT NULL,
	Password varchar(30) NOT NULL,
	Email varchar(30) NOT NULL UNIQUE,
	Address nvarchar(200)
)
GO

CREATE TABLE Posts
(
	PostID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	Title nvarchar(200) NOT NULL,
	Content nvarchar(MAX) NOT NULL,
	Tag nvarchar(100) NULL,
	Status bit,
	CreateTime datetime DEFAULT(getdate()),
	UpdateTime datetime,
	UserID int,
	FOREIGN KEY(UserID) REFERENCES Users(UserID) 
)
GO

CREATE TABLE Comments
(
	CommentID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	Content nvarchar(500),
	Status bit,
	CreateTime datetime DEFAULT(getdate()),
	Author nvarchar(30),
	Email varchar(50) NOT NULL,
	PostID int,
	FOREIGN KEY(PostID) REFERENCES Posts(PostID)
)
GO

ALTER TABLE Comments
ADD CHECK (Email like '%@%')

ALTER TABLE Users
ADD CHECK (Email like '%@%')

CREATE INDEX IX_UserName
ON Users(UserName)

INSERT INTO Users VALUES ('minh','123','minh@gmail.com','TayHo')
INSERT INTO Users VALUES ('minh1','456','minh2@gmail.com','Thanh Xuan')
INSERT INTO Users VALUES ('minh3','789','minh3@gmail.com','BaDinh')

INSERT INTO Posts VALUES ('hoang1', 'minhminh1', 'okem1', 'true', getdate(),getdate(), 1 )
INSERT INTO Posts VALUES ('hoang2', 'minhminh2', 'okem2', 'true', getdate(),getdate(), 2 )
INSERT INTO Posts VALUES ('hoang3', 'minhminh3', 'okem3', 'true', getdate(),getdate(), 3 )

INSERT INTO Comments VALUES ('Hello ae','true', getdate()+3, 'okaetoi','okeme@gmail.com', 1)
INSERT INTO Comments VALUES ('Hello khabanh','true', getdate()-2, 'okaetoiok','okeaee@gmail.com', 2)
INSERT INTO Comments VALUES ('Hello cac con vo','true', getdate()-4, 'okaetoiokok','vkl@gmail.com', 3)

SELECT * FROM Posts WHERE Tag = 'Social'

SELECT * FROM Posts WHERE UserID in (SELECT UserID From Users WHERE Email='minh@gmail.com')

SELECT COUNT(*) as Count FROM Comments

CREATE VIEW v_NewPost AS
SELECT  TOP 2 dbo.Posts.Title, dbo.Users.UserName, dbo.Posts.CreateTime
FROM dbo.Posts 
INNER JOIN dbo.Users ON dbo.Posts.UserID = dbo.Users.UserID
ORDER BY dbo.Posts.CreateTime DESC

CREATE Procedure sp_GetComment 
	@PostID int AS
BEGIN
	select * from Comments where PostID = @PostID
END
GO

CREATE TRIGGER tg_UpdateTime
ON Posts
AFTER  INSERT,UPDATE AS
BEGIN
   UPDATE Posts 
   SET UpdateTime = GETDATE()
   FROM Posts
   JOIN deleted ON Posts.PostID = deleted.PostID    
END