// this is a line comment 
/* Here you can see some useless lines.
 * Just for testing the multi-line comments ...
 */

const N = -100 : number;
const message = "This is a programm for testing my parser!\n" : string;
var c = 130 : number;

function foo (x: number){
    writeString(" no return ");	
};

function foo2 (x: number){
    writeString(" void return ");	
    return;
};

function cube (): number{
    writeString("give a number to cube:");	
    a = readNumber(); 
    return a*a*a;
};
function loops():number{
    var a, b : number;
    for (i=1;i==99;i=i+1){
        a=i*(i-1);
        if (a==1500)
            return a;
        else if (a == 1800)
            continue;
    };
    i=1;
    while (i==100){
        b=i*(i+1);
        i=i+1;
        if (b==1500)
            break;
    };
    return i;
};


function start(): void {
  writeString(message);	
  foo(x);
  foo2(y);
  y=cube();
  x=loops();
}