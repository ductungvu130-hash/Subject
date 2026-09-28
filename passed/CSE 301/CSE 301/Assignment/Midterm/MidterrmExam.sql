-- Create database
CREATE DATABASE IF NOT EXISTS UniversityManagement;
USE UniversityManagement;

-- Create table Departments
CREATE TABLE Departments (
    DepartmentID VARCHAR(5) PRIMARY KEY,
    DepartmentName VARCHAR(50) NOT NULL,
    Faculty VARCHAR(50) NOT NULL
);

-- Create table Courses
CREATE TABLE Courses (
    CourseID VARCHAR(5) PRIMARY KEY,
    CourseName VARCHAR(50) NOT NULL,
    Credit INT NOT NULL,
    DepartmentID VARCHAR(5) NOT NULL,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- Create table Lecturers
CREATE TABLE Lecturers (
    LecturerID VARCHAR(5) PRIMARY KEY,
    LecturerName VARCHAR(50) NOT NULL,
    Email CHAR(50) NOT NULL UNIQUE,
    Phone VARCHAR(15) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Address VARCHAR(100) NOT NULL
);

-- Create table Students
CREATE TABLE Students (
    StudentID VARCHAR(10) PRIMARY KEY,
    StudentName VARCHAR(50) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Class VARCHAR(10) NOT NULL,
    DepartmentID VARCHAR(10) NOT NULL,
    Address VARCHAR(100) NOT NULL,
    Phone VARCHAR(15) NOT NULL,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- Create table Student_Course
CREATE TABLE Student_Course (
    StudentID VARCHAR(10) NOT NULL,
    CourseID VARCHAR(5) NOT NULL,
    Grade DECIMAL(5,2),
    Result VARCHAR(10),
    Semester INT NOT NULL,
    AcademicYear CHAR(9) NOT NULL,
    LecturerID VARCHAR(5) NOT NULL,
    PRIMARY KEY (StudentID, CourseID, AcademicYear, Semester),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),
    FOREIGN KEY (LecturerID) REFERENCES Lecturers(LecturerID)
);

-- Insert records into Departments
INSERT INTO Departments (DepartmentID, DepartmentName, Faculty) VALUES
('CS', 'Computer Science', 'Faculty of Information Technology'),
('BM', 'Business Management', 'Faculty of Economics'),
('AC', 'Accounting', 'Faculty of Accounting'),
('FI', 'Finance', 'Faculty of Finance'),
('MK', 'Marketing', 'Faculty of Economics');

-- Insert records into Courses
INSERT INTO Courses (CourseID, CourseName, Credit, DepartmentID) VALUES
('CS101', 'Introduction to Programming', 3, 'CS'),
('BM102', 'Business Administration', 3, 'BM'),
('AC103', 'Principles of Accounting', 3, 'AC'),
('BM201', 'Macroeconomics', 3, 'BM'),
('AC202', 'Financial Accounting', 3, 'AC'),
('FI203', 'Corporate Finance', 3, 'FI'),
('MK204', 'Fundamentals of Marketing', 3, 'MK');

-- Insert records into Lecturers
INSERT INTO Lecturers (LecturerID, LecturerName, Email, Phone, DateOfBirth, Address) VALUES
('L001', 'Nguyen Thi Hoa', 'nguyenthihoa@example.com', '0901234567', '1975-01-10', '123 Dinh Bo Linh St, Ho Chi Minh City'),
('L002', 'Tran Minh Tuan', 'tranminhtuan@example.com', '0901234568', '1976-02-15', '456 Nguyen Binh Khiem St, Ho Chi Minh City'),
('L003', 'Le Thi Thu', 'lethithu@example.com', '0901234569', '1977-03-20', '789 Le Loi St, Thu Dau Mot, Binh Duong'),
('L004', 'Nguyen Van Hai', 'nguyenvanhai@example.com', '0901234570', '1978-04-25', '101 Nguyen Trai St, Bien Hoa, Dong Nai'),
('L005', 'Hoang Thi Linh', 'hoangthilinh@example.com', '0901234571', '1979-05-30', '202 Cong Hoa St, Ho Chi Minh City'),
('L006', 'Pham Van Cuong', 'phamvancuong@example.com', '0901234572', '1980-06-05', '303 Binh Thoi St, Ho Chi Minh City'),
('L007', 'Vu Thi Dao', 'vuthidao@example.com', '0901234573', '1981-07-10', '404 Thu Khoa Huan St, Thu Dau Mot, Binh Duong'),
('L008', 'Nguyen Van Phuc', 'nguyenvanphuc@example.com', '0901234574', '1982-08-15', '505 Vo Thi Sau St, Bien Hoa, Dong Nai'),
('L009', 'Le Thi Quyen', 'lethiquyen@example.com', '0901234575', '1983-09-20', '606 Nguyen Dinh Chieu St, Ho Chi Minh City'),
('L010', 'Tran Thi Hong', 'tranthihong@example.com', '0901234576', '1984-10-25', '707 Ho Hao Hon St, Ho Chi Minh City');

-- Insert records into Students
INSERT INTO Students (StudentID, StudentName, DateOfBirth, Class, DepartmentID, Address, Phone) VALUES
('S001', 'Nguyen Van Nam', '2002-01-15', 'K07', 'CS', '123 Dinh Bo Linh St, Ho Chi Minh City', '0912345678'),
('S002', 'Tran Thi Mai', '2002-02-20', 'K07', 'BM', '456 Nguyen Binh Khiem St, Ho Chi Minh City', '0912345679'),
('S003', 'Le Minh Hoang', '2002-03-25', 'K08', 'AC', '789 Le Loi St, Thu Dau Mot, Binh Duong', '0912345680'),
('S004', 'Nguyen Thi Lan', '2002-04-30', 'K08', 'FI', '101 Nguyen Trai St, Bien Hoa, Dong Nai', '0912345681'),
('S005', 'Hoang Van Tuan', '2002-05-05', 'K09', 'CS', '202 Cong Hoa St, Ho Chi Minh City', '0912345682'),
('S006', 'Pham Thi Huong', '2002-06-10', 'K09', 'BM', '303 Binh Thoi St, Ho Chi Minh City', '0912345683'),
('S007', 'Vu Van Phat', '2002-07-15', 'K10', 'AC', '404 Thu Khoa Huan St, Thu Dau Mot, Binh Duong', '0912345684'),
('S008', 'Nguyen Thi Thao', '2002-08-20', 'K10', 'FI', '505 Vo Thi Sau St, Bien Hoa, Dong Nai', '0912345685'),
('S009', 'Le Thi Mai', '2002-09-25', 'K11', 'CS', '606 Nguyen Dinh Chieu St, Ho Chi Minh City', '0912345686'),
('S010', 'Tran Van Khoa', '2002-10-30', 'K11', 'BM', '707 Ho Hao Hon St, Ho Chi Minh City', '0912345687'),
('S011', 'Hoang Thi Hanh', '2002-11-05', 'K12', 'AC', '808 Nguyen Thi Minh Khai St, Ho Chi Minh City', '0912345688'),
('S012', 'Nguyen Van Duong', '2002-12-10', 'K12', 'FI', '909 Tran Phu St, Thu Dau Mot, Binh Duong', '0912345689'),
('S013', 'Pham Van An', '2003-01-15', 'K13', 'CS', '010 Dinh Tien Hoang St, Bien Hoa, Dong Nai', '0912345690'),
('S014', 'Vu Thi Lan', '2003-02-20', 'K13', 'BM', '111 Le Quy Don St, Ho Chi Minh City', '0912345691'),
('S015', 'Nguyen Thi Huong', '2003-03-25', 'K14', 'AC', '222 Nguyen Hue St, Ho Chi Minh City', '0912345692'),
('S016', 'Le Van Son', '2003-04-30', 'K14', 'FI', '333 Nguyen Huu Canh St, Bien Hoa, Dong Nai', '0912345693'),
('S017', 'Tran Thi Dao', '2003-05-05', 'K15', 'CS', '444 Vo Van Tan St, Ho Chi Minh City', '0912345694'),
('S018', 'Nguyen Thi Mai', '2003-06-10', 'K15', 'BM', '555 Pham Van Dong St, Ho Chi Minh City', '0912345695'),
('S019', 'Le Thi Thu', '2003-07-15', 'K16', 'AC', '666 Tran Phu St, Thu Dau Mot, Binh Duong', '0912345696'),
('S020', 'Nguyen Van Trung', '2003-08-20','K16', 'FI', '777 Pham Ngoc Thach St, Bien Hoa, Dong Nai', '0912345697');

-- Insert records into Student_Course
INSERT INTO Student_Course (StudentID, CourseID, Grade, Semester, AcademicYear, LecturerID) 
VALUES
('S001', 'CS101', 8.0, 1, '2023-2024', 'L001'),
('S001', 'BM102', 6.5, 1, '2023-2024', 'L002'),
('S002', 'AC103', 4.0, 1, '2023-2024', 'L003'),
('S002', 'FI203', 5.5, 2, '2023-2024', 'L004'),
('S003', 'MK204', 7.0, 1, '2023-2024', 'L005'),
('S003', 'CS101', 6.0, 2, '2023-2024', 'L001'),
('S004', 'BM102', 3.5, 1, '2023-2024', 'L002'),
('S004', 'AC202', 7.5, 2, '2023-2024', 'L003'),
('S005', 'CS101', 5.0, 1, '2023-2024', 'L001'),
('S005', 'MK204', 8.0, 2, '2023-2024', 'L005'),
('S006', 'AC103', 6.0, 1, '2023-2024', 'L003'),
('S006', 'FI203', 5.0, 2, '2023-2024', 'L004'),
('S007', 'BM201', 4.5, 1, '2023-2024', 'L002'),
('S007', 'AC202', 6.0, 2, '2023-2024', 'L003'),
('S008', 'FI203', 5.5, 1, '2023-2024', 'L004'),
('S008', 'MK204', 7.0, 2, '2023-2024', 'L005'),
('S009', 'CS101', 9.0, 1, '2023-2024', 'L001'),
('S009', 'BM102', 8.5, 2, '2023-2024', 'L002'),
('S010', 'AC103', 6.0, 1, '2023-2024', 'L003'),
('S010', 'FI203', 7.5, 2, '2023-2024', 'L004'),
('S011', 'MK204', 4.5, 1, '2023-2024', 'L005'),
('S011', 'CS101', 5.5, 2, '2023-2024', 'L001'),
('S012', 'BM201', 6.0, 1, '2023-2024', 'L002'),
('S012', 'AC202', 8.0, 2, '2023-2024', 'L003'),
('S013', 'CS101', 5.0, 1, '2023-2024', 'L001'),
('S013', 'MK204', 6.5, 2, '2023-2024', 'L005'),
('S014', 'FI203', 4.0, 1, '2023-2024', 'L004'),
('S014', 'AC202', 7.0, 2, '2023-2024', 'L003'),
('S015', 'BM102', 6.5, 1, '2023-2024', 'L002'),
('S015', 'CS101', 8.0, 2, '2023-2024', 'L001'),
('S016', 'MK204', 5.0, 1, '2023-2024', 'L005'),
('S016', 'FI203', 6.5, 2, '2023-2024', 'L004'),
('S017', 'AC103', 7.5, 1, '2023-2024', 'L003'),
('S017', 'BM201', 6.0, 2, '2023-2024', 'L002'),
('S018', 'CS101', 4.0, 1, '2023-2024', 'L001'),
('S018', 'MK204', 7.0, 2, '2023-2024', 'L005'),
('S019', 'FI203', 8.0, 1, '2023-2024', 'L004'),
('S019', 'CS101', 6.5, 2, '2023-2024', 'L001'),
('S020', 'AC103', 7.0, 1, '2023-2024', 'L003'),
('S020', 'BM201', 6.0, 2, '2023-2024', 'L002'),
('S002', 'CS101', 3.0, 1, '2023-2024', 'L001'), 
('S001', 'BM102', 4.5, 2, '2023-2024', 'L002'), 
('S020', 'FI203', 2.5, 1, '2023-2024', 'L004'), 
('S016', 'MK204', 4.0, 2, '2023-2024', 'L005'), 
('S011', 'AC103', 3.5, 1, '2023-2024', 'L003'),
('S016', 'CS101', 4.3, 2, '2023-2024', 'L001'),
('S001', 'CS101', 7.0, 3, '2023-2024', 'L006'),
('S002', 'BM102', 4.0, 3, '2023-2024', 'L006'),
('S003', 'AC103', 8.5, 3, '2023-2024', 'L006'),
('S004', 'FI203', 5.5, 3, '2023-2024', 'L006'),
('S005', 'MK204', 3.0, 3, '2023-2024', 'L007'),
('S006', 'CS101', 6.0, 3, '2023-2024', 'L007'),
('S007', 'BM102', 7.5, 3, '2023-2024', 'L007'),
('S008', 'AC103', 4.5, 2, '2023-2024', 'L007'),
('S009', 'FI203', 5.0, 2, '2023-2024', 'L008'),
('S010', 'MK204', 7.0, 3, '2023-2024', 'L008'),
('S011', 'CS101', 3.5, 3, '2023-2024', 'L008'),
('S012', 'BM102', 6.5, 3, '2023-2024', 'L008'),
('S013', 'AC103', 7.0, 2, '2023-2024', 'L009'),
('S014', 'FI203', 4.0, 2, '2023-2024', 'L009'),
('S015', 'MK204', 8.0, 2, '2023-2024', 'L009'),
('S016', 'CS101', 3.0, 3, '2023-2024', 'L009'),
('S017', 'BM102', 6.0, 3, '2023-2024', 'L010'),
('S018', 'AC103', 4.5, 1, '2023-2024', 'L010'),
('S019', 'FI203', 7.5, 3, '2023-2024', 'L010'),
('S020', 'MK204', 5.0, 3, '2023-2024', 'L010');


SET SQL_SAFE_UPDATES = 0;