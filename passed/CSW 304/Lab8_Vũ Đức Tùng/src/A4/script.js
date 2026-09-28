$(document).ready(function () {
    let students = [];
    let classes = [];

    $.get(
        "http://45.32.46.181/getdata-student.php",
        { Type: "Student" },
        function (data) {
            console.log(data);
            students = data;
            displayStudent(students);
        },
        "json"
    );

    $.get(
        "http://45.32.46.181/getdata-student.php",
        { Type: "Class" },
        function (data) {
            console.log(data);
            classes = data;
            displayClass(classes);
        },
        "json"
    );

    function displayClass(_data) {
        $("#class-list").html("");
        $("#studentClass").html('<option value="">-- Select a Class --</option>');
        
        for (let item of _data) {
            let className = typeof item === 'string' ? item : (item.Name || item.class);
            $("#class-list").append(`<li style="cursor: pointer;" class="py-1">${className}</li>`);
            $("#studentClass").append(`<option value="${className}">${className}</option>`);
        }
    }

    function displayStudent(_data) {
        _data.sort(function (a, b) {
            let _a = (a.Name || "").toLowerCase();
            let _b = (b.Name || "").toLowerCase();
            if (_a < _b) return -1;
            if (_a > _b) return 1;
            return 0;
        });

        $("tbody").html("");
        let stt = 1;
        
        for (let item of _data) {
            $("tbody").append(
                `<tr>
                    <th scope="row">${stt++}</th>
                    <td>${item.Name}</td>
                    <td>${item.ID}</td>
                    <td>${item.Email}</td>
                    <td>${item.Class}</td>
                    <td>
                        <button class="btn btn-sm btn-warning edit" data-id="${item.ID}">Edit</button>
                        <button class="btn btn-sm btn-danger delete" data-id="${item.ID}">Delete</button>
                    </td>
                </tr>`
            );
        }
    }

    function addToHead(_student) {
        students.unshift(_student);
        displayStudent(students);
    }

    $("#add").click(function () {
        let _id = $("#studentID").val().trim();
        let _name = $("#studentName").val().trim();
        let _email = $("#studentEmail").val().trim();
        let _class = $("#studentClass").val();

        if (!_id || !_name || !_email || !_class) return alert("Vui lòng nhập đủ thông tin");

        let isUpdate = false;
        for (let i in students) {
            if (students[i].ID == _id) {
                students[i] = { ID: _id, Name: _name, Email: _email, Class: _class };
                isUpdate = true;
                displayStudent(students);
                break;
            }
        }

        if (!isUpdate) {
            addToHead({
                ID: _id,
                Name: _name,
                Email: _email,
                Class: _class
            });
        }

        $("#studentID").val("").prop("readonly", false);
        $("#studentName").val("");
        $("#studentEmail").val("");
        $("#studentClass").val("");
    });

    $("#class-list").on("click", "li", function () {
        let value = $(this).html();
        let _newList = [];
        
        for (let item of students) {
            if (item.Class == value) {
                _newList.push(item);
            }
        }
        displayStudent(_newList);
    });

    $("#search").click(function () {
        let kw = $("#keyword").val();
        let _newList = [];
        
        for (let item of students) {
            if ((item.Name || "").toLowerCase().includes(kw.toLowerCase())) {
                _newList.push(item);
            }
        }
        displayStudent(_newList);
    });

    $("tbody").on("click", ".delete", function () {
        if (confirm("Are you sure?")) {
            let _id = $(this).attr("data-id");
            for (let i in students) {
                if (students[i].ID == _id) {
                    students.splice(i, 1);
                    break;
                }
            }
            displayStudent(students);
        }
    });

    $("tbody").on("click", ".edit", function () {
        let _id = $(this).attr("data-id");
        for (let item of students) {
            if (item.ID == _id) {
                $("#studentID").val(item.ID).prop("readonly", true);
                $("#studentName").val(item.Name);
                $("#studentEmail").val(item.Email);
                $("#studentClass").val(item.Class);
                window.scrollTo({ top: 0, behavior: 'smooth' });
                break;
            }
        }
    });
});