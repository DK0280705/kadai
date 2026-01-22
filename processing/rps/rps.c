#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include <ncurses.h>

typedef enum {
    NONE = -1,
    ROCK,
    PAPER,
    SCISSORS
} hand_t;

typedef enum {
    LOSE = 0,
    TIE,
    WIN
} result_t;

const char* rock_art[] = {
    "     ___     ",
    "    /  \\\\    ",
    "   |  \\  |   ",
    "   |     |   ",
    "    \\___/    ",
    "     ROCK    "
};
const char* paper_art[] = {
    "   _______   ",
    "  |  __   |  ",
    "  |    __ |  ",
    "  |  __   |  ",
    "  |_______|  ",
    "    PAPER    "
};
const char* scissors_art[] = {
    "    \\   /    ",
    "     \\ /     ",
    "      X      ",
    "     / \\     ",
    "   O/   \\O   ",
    "   SCISSORS  "
};

const char* lose_art[] = {
    " _     _____ _____ _____ ",
    "| |   |  _  /  ___|  ___|",
    "| |   | | | \\ `--.| |__  ",
    "| |   | | | |`--. \\  __| ",
    "| |___\\ \\_/ /\\__/ / |___ ",
    "\\_____/\\___/\\____/\\____/ ",
};
const char* tie_art[] = {
    "    _____ _____ _____    ",
    "   |_   _|_   _|  ___|   ",
    "     | |   | | | |__     ",
    "     | |   | | |  __|    ",
    "     | |  _| |_| |___    ",
    "     \\_/  \\___/\\____/    ",
};
const char* win_art[] = {
    "   _    _ _____ _   _    ",
    "  | |  | |_   _| \\ | |   ",
    "  | |  | | | | |  \\| |   ",
    "  | |/\\| | | | | . ` |   ",
    "  \\  /\\  /_| |_| |\\  |   ",
    "   \\/  \\/ \\___/\\_| \\_/   ",
};


void print_art(const char** art, int start_y, int start_x, int color_pair) {
    attron(COLOR_PAIR(color_pair));
    for (int i = 0; i < 6; i++) {
        mvprintw(start_y + i, start_x, "%s", art[i]);
    }
    attroff(COLOR_PAIR(color_pair));
}

void print_hand_t(hand_t hand, int start_y, int start_x) {
    switch(hand) {
        case ROCK: print_art(rock_art, start_y, start_x, 1); break;
        case PAPER: print_art(paper_art, start_y, start_x, 2); break;
        case SCISSORS: print_art(scissors_art, start_y, start_x, 3); break;
    }
}

void print_art_slow(const char** art, int start_y, int start_x, int color_pair) {
    attron(COLOR_PAIR(color_pair));
    for (int i = 0; i < 6; i++) {
        napms(100);
        mvprintw(start_y + i, start_x, "%s", art[i]);
        refresh();
    }
    attroff(COLOR_PAIR(color_pair));
}

void print_result_t(result_t result, int start_y, int start_x) {
    switch(result) {
        case LOSE: print_art_slow(lose_art, start_y, start_x, 5); break;
        case TIE: print_art_slow(tie_art, start_y, start_x, 1); break;
        case WIN: print_art_slow(win_art, start_y, start_x, 3); break;
    }
}

void print_scores(int player_score, int computer_score, int ties) {
    int max_y, max_x;
    getmaxyx(stdscr, max_y, max_x);

    char scoreline[100];
    snprintf(scoreline, sizeof(scoreline), "Score: You %d  | Computer %d  | Ties %d", player_score, computer_score, ties);
    mvprintw(max_y - 2, (max_x - strlen(scoreline)) / 2, "%s", scoreline); 
}

hand_t set_player_hand() {
    while (true) {
        int ch = getch();
        switch(ch) {
            case 'r': return ROCK;
            case 'p': return PAPER;
            case 's': return SCISSORS;
            case 'q': return NONE;
            default: break;
        }
    }
}

hand_t set_computer_hand() {
    return rand() % 3;
}

result_t evaluate(hand_t player_hand, hand_t computer_hand) {
    return (player_hand - computer_hand + 4) % 3;
}

void print_result(result_t result, hand_t player_hand, hand_t computer_hand) {
    int max_y, max_x;
    getmaxyx(stdscr, max_y, max_x);

    clear();
    attron(A_BOLD | COLOR_PAIR(4));
    const char *result_title = "Rock Paper Scissors - Results";
    mvprintw(1, (max_x - strlen(result_title)) / 2, "%s", result_title);
    attroff(A_BOLD | COLOR_PAIR(4));

    const char *you_chose = "You chose:";
    const char *comp_chose = "Computer chose:";
    mvprintw(3, max_x / 4 - strlen(you_chose) / 2, "%s", you_chose);
    mvprintw(3, 3 * max_x / 4 - strlen(comp_chose) / 2, "%s", comp_chose);

    print_hand_t(player_hand, 5, max_x / 4 - 7);
    print_hand_t(computer_hand, 5, 3 * max_x / 4 - 7);

    refresh();

    print_result_t(result, 12, (max_x - 26) / 2);

}

int main() {
    initscr();
    noecho(); // Disable echo on typing
    cbreak(); // Disable line buffering
    curs_set(0); // Hide text cursor
    srand(time(NULL));  // Random initialization

    hand_t player_hand;
    hand_t computer_hand;
    result_t result;

    int player_score = 0, computer_score = 0, ties = 0;

    if (has_colors()) { // Color initialization
        start_color();
        init_pair(1, COLOR_YELLOW, COLOR_BLACK);
        init_pair(2, COLOR_CYAN, COLOR_BLACK);
        init_pair(3, COLOR_GREEN, COLOR_BLACK);
        init_pair(4, COLOR_MAGENTA, COLOR_BLACK);
        init_pair(5, COLOR_RED, COLOR_BLACK);
    }

    while(1) {
        // Get maximum terminal screen resolution
        int max_y, max_x;
        getmaxyx(stdscr, max_y, max_x);

        // Create title screen
        clear();
        attron(A_BOLD | COLOR_PAIR(4));
        const char *title = "Rock Paper Scissors!";
        mvprintw(1, (max_x - strlen(title)) / 2, "%s", title);
        attroff(A_BOLD | COLOR_PAIR(4));

        const char *inst = "Press 'r' for Rock, 'p' for Paper, 's' for Scissors, 'q' to quit.";
        mvprintw(3, (max_x - strlen(inst)) / 2, "%s", inst);

        print_scores(player_score, computer_score, ties);
        refresh();

        computer_hand = set_computer_hand();
        player_hand = set_player_hand(); 

        // If player pressed q, break the loop
        if (player_hand == NONE) break;

        result = evaluate(player_hand, computer_hand);
        switch (result) {
            case LOSE: ++computer_score; break;
            case TIE: ++ties; break;
            case WIN: ++player_score; break;
        }

        print_result(result, player_hand, computer_hand);
        print_scores(player_score, computer_score, ties);
    
        // Make continue message blinking.
        const char *cont = "Press any key to continue, or 'q' to quit...";                
        attron(A_BLINK);
        mvprintw(max_y-5, (max_x - strlen(cont)) / 2, "%s", cont);
        attroff(A_BLINK);
        refresh();

        // Block the process until user presses a key.
        int ch = getch();
        if (ch == 'q') break;
    }

    endwin();
    return 0;
}