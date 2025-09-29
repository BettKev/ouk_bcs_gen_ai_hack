import random;

glob choices: list[str] = ["rock", "paper", "scissors"];

def get_user_choice() -> str{
    print("Enter your choice (rock, paper, scissors): ");
    user_input: str = input().strip().lower();
    while user_input not in choices {
        print("Invalid choice. Please enter rock, paper, or scissors: ");
        user_input = input().strip().lower();
    }
    return user_input;
}

def get_computer_choice() -> str {
    return random.choice(choices);
}

def determine_winner(user: str, computer: str) -> str {
    if user == computer {
        return "It's a tie!";
    } elif (user == "rock" and computer == "scissors") or
         (user == "paper" and computer == "rock") or
         (user == "scissors" and computer == "paper") {
        return "You win!";
    } else {
        return "Computer wins!";
    }
}

with entry {
    print("Welcome to Rock, Paper, Scissors!");
    user_choice: str = get_user_choice();
    computer_choice: str = get_computer_choice();
    result: str = determine_winner(user_choice, computer_choice);
    print(result);
}