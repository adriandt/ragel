//
// Convert a string to an integer.
//

%%{
    machine atoi;
    write data;
}%%

fn atoi(data: &[u8]) -> i32
{
    let mut cs: i32 = 0;
    let mut p = 0usize;  // Start position
    let mut pe = data.len();  // End position
    let mut val = 0i32;  // Accumulated value
    let mut neg = false;  // Negative number flag

    %%{
        action see_neg {
            neg = true;
        }

        # Take a look at `fc`. It denotes current symbol
        action add_digit {
            val = val * 10 + (fc - ('0' as u8)) as i32;
        }

        main :=
            ( '-'@see_neg | '+' )? ( digit @add_digit )+
            '\n';

        # Initialize and execute.
        write init;
        write exec;
    }%%

    if neg {
        val = -val;
    }

    if cs < atoi_first_final {
        println!("atoi: error");
    }

    return val;
}


const BUFSIZE: usize = 1024;

fn main() {
    use std::io::BufRead;
    use std::convert::TryInto;

    let stdin = std::io::stdin();
    let mut handle = stdin.lock();

    loop {
        let mut buffer = String::new();
        handle.read_line(&mut buffer);
        let result = atoi(buffer.as_bytes());
        println!("{}", result);
    }
}
