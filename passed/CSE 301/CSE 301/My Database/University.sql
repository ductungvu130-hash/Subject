-- Create the database
DROP DATABASE IF EXISTS University;
CREATE DATABASE University;
USE University;

-- Create 'student' table
CREATE TABLE student (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100)
);

-- Create 'course' table
CREATE TABLE course (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(100),
    credits INT
);

-- Create 'enroll' table
CREATE TABLE enroll (
    enroll_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    FOREIGN KEY (student_id) REFERENCES student(student_id),
    FOREIGN KEY (course_id) REFERENCES course(course_id)
);

-- Insert 20 sample students
INSERT INTO student (first_name, last_name, email) VALUES
('Alice', 'Johnson', 'alice.johnson@example.com'),
('Bob', 'Smith', 'bob.smith@example.com'),
('Charlie', 'Brown', 'charlie.brown@example.com'),
('Diana', 'Clark', 'diana.clark@example.com'),
('Ethan', 'Davis', 'ethan.davis@example.com'),
('Fiona', 'Miller', 'fiona.miller@example.com'),
('George', 'Moore', 'george.moore@example.com'),
('Hannah', 'Lee', 'hannah.lee@example.com'),
('Ian', 'Taylor', 'ian.taylor@example.com'),
('Jenna', 'White', 'jenna.white@example.com'),
('Kevin', 'Hall', 'kevin.hall@example.com'),
('Laura', 'Allen', 'laura.allen@example.com'),
('Mike', 'Young', 'mike.young@example.com'),
('Nina', 'King', 'nina.king@example.com'),
('Oscar', 'Wright', 'oscar.wright@example.com'),
('Paula', 'Scott', 'paula.scott@example.com'),
('Quincy', 'Green', 'quincy.green@example.com'),
('Rachel', 'Baker', 'rachel.baker@example.com'),
('Sam', 'Adams', 'sam.adams@example.com'),
('Tina', 'Nelson', 'tina.nelson@example.com');

-- Insert 20 sample courses
INSERT INTO course (course_name, credits) VALUES
('Mathematics I', 3),
('Computer Science I', 4),
('History of Art', 2),
('Physics I', 4),
('Introduction to Psychology', 3),
('Business Management', 3),
('Economics I', 3),
('English Literature', 2),
('Biology I', 4),
('Chemistry I', 4),
('Philosophy', 2),
('Data Structures', 3),
('Algorithms', 3),
('Statistics I', 3),
('Artificial Intelligence', 4),
('Database Systems', 3),
('Web Development', 3),
('Operating Systems', 4),
('Linear Algebra', 3),
('Software Engineering', 4);

-- Insert 20+ sample enrollments
INSERT INTO enroll (student_id, course_id, enrollment_date) VALUES
(1, 1, '2025-07-01'), (1, 2, '2025-07-01'),
(2, 3, '2025-07-02'), (2, 4, '2025-07-02'),
(3, 5, '2025-07-03'), (3, 6, '2025-07-03'),
(4, 7, '2025-07-04'), (4, 8, '2025-07-04'),
(5, 9, '2025-07-05'), (5,10, '2025-07-05'),
(6,11, '2025-07-06'), (6,12, '2025-07-06'),
(7,13, '2025-07-07'), (7,14, '2025-07-07'),
(8,15, '2025-07-08'), (8,16, '2025-07-08'),
(9,17, '2025-07-09'), (9,18, '2025-07-09'),
(10,19,'2025-07-10'), (10,20,'2025-07-10'),
(11,1, '2025-07-11'), (12,2, '2025-07-11'),
(13,3, '2025-07-12'), (14,4, '2025-07-12'),
(15,5, '2025-07-13'), (16,6, '2025-07-13'),
(17,7, '2025-07-14'), (18,8, '2025-07-14'),
(19,9, '2025-07-15'), (20,10,'2025-07-15');

select st.* from student as st 
	inner join enroll as en on st.student_id = en.student_id
	inner join course as co on en.course_id = co.course_id
-- where co.course_name = 'Database Systems' or co.course_name = 'Artificial Intelligence';
where co.course_name in ('Database Systems','Artificial Intelligence');

select st.* from student as st 
	inner join enroll as en on st.student_id = en.student_id
    inner join course co on en.course_id = co.course_id
where co.course_name = 'Database Systems'

-- union 
union all
select st.* from student as st 
	inner join enroll as en on st.student_id = en.student_id
    inner join course co on en.course_id = co.course_id
where co.course_name = 'Artificial Intelligence';

-- Thong ke mon hoc va so luong sinh vien dang ky
-- abc 10, def 0 
select co.course_id, course_name, count(*) as numberOfStudent from course co 
	left join enroll en on co.course_id = en.course_id 
	group by co.course_id, course_name;

-- 5 sinh vien dang ki som nhst 
select st.*, en.enrollment_date from student as st 
inner join enroll as en on st.student_id = en.student_id 
order by en.enrollment_date ASC
limit 5;

-- Khong dang ky va dang ky
select co.course_id, course_name, count(*) as numberOfStudent from course co 
	left join enroll en on co.course_id = en.course_id 
	group by co.course_id, course_name
union all 
select co.course_id, course_name, 0 as total from course co
where co.course_id not in (select course_id from enroll);

-- Thong ke dang ky theo ngay
select enrollment_date, count(*) as total from enroll
group by enrollment_date;

-- Thong ke dang ky theo mon hoc va theo ngay 
select co.course_name, enrollment_date, count(*) as total from enroll en 
inner join course co on co.course_id = en.course_id 
group by co.course_name, enrollment_date;

-- thong ke dang ky theo mon hoc va theo ngay voi so luong > 1
select co.course_name, enrollment_date, count(*) as total
from enroll en inner join course co on co.course_id = en.course_id
group by co.course_name, enrollment_date
-- having count(*)>1;
having total > 1;

-- Lay nhung ban sinh vien dang ky tu 2 mon hoc tro len 
select st.* from student st
where st.student_id in (
	select st.student_id from student st 
    inner join enroll en on en.student_id = st.student_id
	group by st.student_id
	having count(*) > 1
);

-- Lay tat ca mon hoc khong co sinh vien dang ky 
select co.* from course co
where co.course_id not in (select course_id from enroll);

-- 
select * from course co 
where exists (select * 
			  from enroll en 
			  where en.course_id = co.course_id
			 );
             
alter table student add column grade float; 
-- Phan loai sinh vien 
select *, 
case when grade < 5 then 'fail' else 'pass' 
end result 
from student;
-- Phan loai theo F < 5, D < 6.5, C < 8, B < 9, A < 10
select *, 
case when grade < 5 then 'F' else 
	case when grade < 6.5 then 'D' else 
		case when grade < 8 then 'C' else 
			case when grade < 9 then 'B' else 'A'
            end
		end
	end
end result 
from student; 

-- Lay thong tin sinh vien, thong tin mon hoc cua 3 ban co so luong dang ky nhieu nhat neu = nhau thi uu tien dang ky som
select st.*, co.* from student st 
	inner join enroll en on st.student_id = en.student_id
    inner join course co on en.course_id = co.course_id
    inner join (
		select student_id from enroll 
		group by student_id
		order by count(*) DESC, student_id DESC
		limit 3 
    ) t on st.student_id = t.student_id;

-- My teacher's question

 -- 1. Lấy danh sách các môn học có số tín chỉ lớn hơn 3.
select * 
from course
where credits > 3;  

-- 2. Đếm số lượng môn học có tín chỉ là 3.
select count(*) countSubject 
from course  
where credits = 3;

-- 3. Tìm sinh viên chưa đăng ký môn học nào.
select st.* 
from student st 
where st.student_id not in (
	select en.student_id from enroll en 
);

-- 4. Lấy tổng số sinh viên mỗi khóa học.
select co.course_id, co.course_name, count(*) numberOfStudent 
from course as co
inner join enroll en on en.course_id = co.course_id
group by co.course_id, course_name;

-- 5. Lấy tên sinh viên và tên khóa học mà họ đăng ký.
select st.first_name, st.last_name, co.course_name 
from student st 
inner join enroll en on st.student_id = en.student_id 
inner join course co on co.course_id = en.course_id 
group by st.first_name, st.last_name, co.course_name;

-- 6. Lấy tên sinh viên đã học "Data Structures"
select st.first_name, st.last_name 
from student st 
inner join enroll en on st.student_id = en.student_id
inner join course co on co.course_id = en.course_id 
where co.course_name = 'Data Structures';

-- 7. Lấy tên các sinh viên có đăng ký môn học có tín chỉ là 4.
select st.first_name, st.last_name 
from student st 
inner join enroll en on st.student_id = en.student_id
inner join course co on co.course_id = en.course_id 
where co.credits = 4;

-- 8. Lấy tên sinh viên đã đăng ký tất cả các môn có tên chứa từ 'Science'.
select st.first_name, st.last_name 
from student st 
inner join enroll en on st.student_id = en.student_id
inner join course co on co.course_id = en.course_id 
where co.course_name like '%Science%';

-- 9. Lấy sinh viên có nhiều hơn 1 môn học.
select st.first_name, st.last_name 
from student st 
inner join enroll en on st.student_id = en.student_id
inner join course co on co.course_id = en.course_id
group by st.first_name, st.last_name 
having count(en.student_id) > 1;

-- 10. Lấy danh sách các môn học chưa có sinh viên đăng ký.
select co.course_id, co.course_name 
from course co 
inner join enroll en on co.course_id = en.course_id
group by co.course_id, co.course_name 
having count(en.course_id) = 0;


-- 11. Lấy tên sinh viên đã học môn có tín chỉ cao nhất.
select st.first_name, st.last_name, co.credits
from student st
inner join enroll en on st.student_id = en.student_id
inner join course co on co.course_id = en.course_id
where co.credits = (select max(credits) from course);

-- 12. Lấy tên các môn học mà có ít nhất 2 sinh viên đăng ký có tên bắt đầu bằng 'A'
select co.course_id, co.course_name 
from course co
inner join enroll en on co.course_id = en.course_id
inner join student st on st.student_id = en.student_id
where st.first_name like 'A%' 
group by co.course_id, co.course_name 
having count(distinct st.student_id) = 1; 

-- 13. Lấy danh sách sinh viên đã đăng ký nhiều môn học nhất (có thể có nhiều người cùng đứng đầu).
select st.student_id, st.first_name, st.last_name, count(en.course_id) total_course
from student st
inner join enroll en on st.student_id = en.student_id
inner join course co on co.course_id = en.course_id
group by st.student_id, st.first_name, st.last_name
having count(en.course_id) = (
	select max(course_count) 
    from (	
		select count(en.course_id) course_count 
        from enroll en 
        group by en.student_id 
    ) counts
);

-- Write a stored procedure that takes a courseld as input and uses a WHILE
-- loop to count how many students are enrolled in that course. Return the total with a SELECT.
DELIMITER $$
CREATE PROCEDURE CountEnrolledStudent 
(
	IN in_course_id INT
)
BEGIN
	DECLARE total_students INT DEFAULT 0;
    select count(*) into total_students 
    from enroll
    where in_course_id = course_id;
    select total_students as total_enrolled;
END$$
DELIMITER ;
call CountEnrolledStudent(1);

-- Write a stored procedure that uses a cursor to list all students whose grade is less than 5.
-- The procedure should print each student's first_name, last_name, and email.
ALTER TABLE enroll ADD grade DECIMAL(3,1);
UPDATE enroll SET grade = 4.5 WHERE enroll_id IN (1, 3, 6);
UPDATE enroll SET grade = 6.0 WHERE enroll_id IN (2, 4, 5);



