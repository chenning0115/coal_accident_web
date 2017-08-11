
function  DateAdd(interval,number,date) 
{ 
    switch(interval) 
    { 
        case  "y"  :  { 
            date.setFullYear(date.getFullYear()+number); 
            return  date; 
            break; 
        } 
        case  "q"  :  { 
            date.setMonth(date.getMonth()+number*3); 
            return  date; 
            break; 
        } 
        case  "m"  :  { 
            date.setMonth(date.getMonth()+number);
            return  date; 
            break; 
        } 
        case  "d"  :  { 
            date.setDate(date.getDate()+number); 
            return  date; 
            break; 
        } 
        default  :  { 
            date.setDate(date.getDate()+number); 
            return  date; 
            break; 
        } 
    } 
}