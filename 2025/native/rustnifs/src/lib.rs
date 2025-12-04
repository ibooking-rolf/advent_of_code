mod atoms {
    rustler::atoms! {
        ok,
        error
    }
}

#[rustler::nif]
fn add(a: i64, b: i64) -> i64 {
    a + b
}

#[rustler::nif]
fn check_adjacents(input: String) -> i64 {
    let grid: Vec<Vec<char>> = input
        .lines()
        .map(|line| line.chars().collect())
        .collect();

    // for (i, row) in grid.iter().enumerate() {
    //     println!("Row {}: {:?}", i, row);
    // }

    for (row_num, row) in grid.iter().enumerate() {
        for (cell_num, cell) in row.iter().enumerate() {
            print!("(row, cell) ({}, {}) ", row_num, cell_num);
            if cell_num + 1 < row.len() {
                print!("right: {} ", row[cell_num + 1]);
            }
        }
        println!();
    }

    return grid.len() as i64;
}

rustler::init!("Elixir.RustNifs");
