console.log("I like AWS");
console.log("I like AWS CF");
//window.alert("I really love AWS CF!");
//comment
/*comment
too
*/
let firstname = "Syed Azam";
let lastname = "Sajjad";
let age;
age = 34;

let student = false;

age = age + 1;

console.log("Hello",firstname);
console.log("You are",age,"years old");
console.log("Enrolled:",student);

document.getElementById("p1").innerHTML = "Hello, " + firstname + lastname;
document.getElementById("p2").innerHTML = "You are " + age + " years old";
document.getElementById("p3").innerHTML = "Enrolled: " + student;

let students = 20;
students += 11;
let extrastudents = students % 3; //storing remainder with modulus operator
console.log(extrastudents);

/*how to accept user input
EASY WAY with a window prompt

let username = window.prompt("what's your name?")
console.log(username);

DIFFICULT WAY with HTML Textbox
*/
let username;
document.getElementById("myButton").onclick = function(){

    username = document.getElementById("myText").value;
    console.log(username);
    document.getElementById("myLabel").innerHTML = "Hello, " + username;
}


/*
Type Conversion = change the datatype of a value to another
                   (strings, numbers, booleans)

*/

// let ages = window.prompt("How old are you?");
// ages = Number(age); //number constructor
// ages += 1;

// console.log("Your age will be",age,"when you apply PR");


let x;
let y;
let z;

x = Number("3.14"); // if x = Number("pizza") => NAN not a number
y = String(3.14);
z = Boolean(""); //empty=false, anything written=true

console.log(x, typeof x);
console.log(y, typeof y);
console.log(z, typeof z);


// const = a variable that cannot be changed
// cant be re-assigned
/*
const PI = 3.14159;
let radius;
let circumference;

radius = window.prompt("Enter the Radius of a circle");
radius = Number(radius);

circumference = 2 * PI * radius;
console.log("The Circumference is:", circumference);
*/


// Math Built-in function
// lets round off a value

let xx = 3.74;
let yy = 5;
let zz = 9;
let maximum;
let minimum;
// xx = Math.round(xx);
// xx = Math.floor(xx); //round off to low number
// xx = Math.ceil(xx); // round off to high number
// xx = Math.pow(x, 2); //x to the power of 2
// xx = Math.sqrt(x); // square root
xx = Math.abs(x); //distance from 0 , always positive number

xx = Math.PI; // xx redefined with built-in Constant
maximum = Math.max(xx, yy, zz);
minimum = Math.min(xx, yy, zz);

console.log(xx);
console.log(maximum,minimum);

