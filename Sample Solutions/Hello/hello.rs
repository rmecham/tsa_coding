use std::io;


fn main() {
    let mut raw_input = String::new();
    io::stdin()
        .read_line(&mut raw_input)
        .expect("Failed to read from stdin.");
    let trimmed = raw_input.trim();
    let num_iterations = trimmed.parse::<i32>().unwrap();
    for _i in 0..num_iterations {
        println!("Hello World!");
    }
}
