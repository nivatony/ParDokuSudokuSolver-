provider "aws" {
  region = "eu-north-1"  # Replace with your desired region..
}

resource "aws_ecr_repository" "sudoku_solver" {
  name = "sudoku-solver-app"
}

output "ecr_repository_url" {
  value = aws_ecr_repository.sudoku_solver.repository_url
}

