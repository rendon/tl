#include <iostream>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <algorithm>

#include <readline/readline.h>
#include <readline/history.h>

#include <curl/curl.h>
using namespace std;

const string PRONUNCIATION_DIRECTORY = "/home/rendon/.pronunciations";
const string URL4AUDIO = "http://translate.google.com/translate_tts?ie=UTF-8&tl=en&q=";
const string BASE_URL = "http://translate.google.com/translate_a/t?client=t&text=";
const string LANG_OPTIONS = "&sl=en&tl=es";
struct String {
    char *str;
    size_t length;
};

struct Audio {
    char *bytes;
    size_t length;
};

void init_string(struct String *s)
{
    s->length = 0;
    s->str = (char *)malloc(s->length + 1);
    if (s->str == NULL) {
        fprintf(stderr, "Memory allocation failed!\n");
        exit(EXIT_FAILURE);
    }
    s->str[0] = '\0';
}

void init_audio(struct Audio *a)
{
    a->length = 0;
    a->bytes = (char *)malloc(a->length);
    if (a->bytes == NULL) {
        fprintf(stderr, "Memory allocation failed!\n");
        exit(EXIT_FAILURE);
    }
}

// Custom function for cURL to call instead of fwrite().
// I use this function to store the response message in a string.
size_t write_function(void *ptr, size_t size, size_t nmemb, struct String *s)
{
    size_t new_length = s->length + size * nmemb;
    s->str = (char *)realloc(s->str, new_length + 1);
    if (s->str == NULL) {
        fprintf(stderr, "String: Momory reallocation failed: realloc()\n");
        exit(EXIT_FAILURE);
    }

    memcpy(s->str + s->length, ptr, size * nmemb);
    s->str[new_length] = '\0';
    s->length = new_length;

    return size * nmemb;
}

// Custom function for cURL to call instead of fwrite().
// I use this function to store the audio file returned by the server.
size_t write_mp3(void *ptr, size_t size, size_t nmemb, struct Audio *a)
{
    size_t new_length = a->length + size * nmemb;
    a->bytes = (char *)realloc(a->bytes, new_length);
    if (a->bytes == NULL) {
        fprintf(stderr, "Audio: Momory reallocation failed: realloc()\n");
        exit(EXIT_FAILURE);
    }

    memcpy(a->bytes + a->length, ptr, size * nmemb);
    a->length = new_length;

    return size * nmemb;
}

string trim(string str)
{
    int left = 0;
    int right = str.length() - 1;
    while (left <= right && str[left] == ' ')
        left++;
    while (right >= left && str[right] == ' ')
        right--;

    string new_str = "";
    for (int i = left; i <= right; i++)
        new_str += str[i];

    return new_str;
}

vector<string> split(string str, char separator)
{
    vector<string> tokens;
    string token;
    int length = str.length();
    for (int i = 0; i < length; i++) {
        if (str[i] == separator) {
            tokens.push_back(token);
            token = "";
        } else {
            token += str[i];
        }
    }

    if (token != "") {
        tokens.push_back(token);
    }
    return tokens;
}

vector<string> extract(const char *text, string preffix)
{
    int length = strlen(text);
    int pos = preffix.length();
    int size = preffix.length();
    while (pos < length) {
        bool found = true;
        for (int i = 0; i < size; i++)
            if (text[pos-size+i] != preffix[i])
                found = false;
        pos++;
        if (found)
            break;
    }

    string list;
    while (pos < length && text[pos] != ']') {
        if (text[pos] != '"')
            list += text[pos];
        pos++;
    }

    vector<string> words = split(list, ',');
    return words;
}

void print_words(const vector<string> &words)
{
    // Limit result to 5 words
    int n = min(5, int(words.size()));
    for (int i = 0; i < n; i++) {
        cout << words[i];
        if (i + 1 < n)
            cout << ", ";
    }
    cout << endl << endl;
}

bool print_adjective(const char *text)
{
    string preffix = "[\"adjective\",[";
    vector<string> words = extract(text, preffix);
    if (words.size() == 0)
        return false;

    cout << "adjective:\n----------\n";
    print_words(words);

    return true;
}

bool print_verb(const char *text)
{
    string preffix = "[\"verb\",[";
    vector<string> words = extract(text, preffix);
    if (words.size() == 0)
        return false;

    cout << "verb:\n-----\n";
    print_words(words);
    return true;
}

bool print_adverb(const char *text)
{
    string preffix = "[\"adverb\",[";
    vector<string> words = extract(text, preffix);
    if (words.size() == 0)
        return false;

    cout << "adverb:\n-------\n";
    print_words(words);
    return true;
}

bool print_noun(const char *text)
{
    string preffix = "[\"noun\",[";
    vector<string> words = extract(text, preffix);
    if (words.size() == 0)
        return false;

    cout << "noun:\n-----\n";
    print_words(words);
    return true;
}

bool print_pronoun(const char *text)
{
    string preffix = "[\"pronoun\",[";
    vector<string> words = extract(text, preffix);
    if (words.size() == 0)
        return false;

    cout << "pronoun:\n--------\n";
    print_words(words);
    return true;
}

void play(string text)
{
    string file_name = PRONUNCIATION_DIRECTORY + "/" + text + ".mp3";
    string command = "mplayer " + file_name + " > /dev/null 2>&1 &";

    // Test if file already exist
    FILE *mp3_file = fopen(file_name.c_str(), "r");
    CURL *curl = curl_easy_init();
    // If file exists, just play it.
    if (mp3_file != NULL) {
        fclose(mp3_file);
        system(command.c_str());

    } else { // Otherwise, retrieve it.
        Audio mp3;
        init_audio(&mp3);
        string url = URL4AUDIO + text;
        curl_easy_setopt(curl, CURLOPT_USERAGENT, "Mozilla/5.0");
        curl_easy_setopt(curl, CURLOPT_URL, url.c_str());
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, write_mp3);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, &mp3);
        curl_easy_perform(curl);

        mp3_file = fopen(file_name.c_str(), "w+");
        if (mp3_file == NULL) {
            fprintf(stderr, "Couldn't open file %s\n", file_name.c_str());
        } else {
            fwrite(mp3.bytes, 1, mp3.length, mp3_file);
            fclose(mp3_file);
            system(command.c_str());
        }
    }
}

int main(int argc, char *argv[])
{
    char prompt[] = ">> ";
    char *input;
    CURL *curl = curl_easy_init();
    if (curl == NULL) {
        fprintf(stderr, "Curl couldn't be initiated.\n");
        exit(EXIT_FAILURE);
    }

    string last;
    while (true) {
        input = readline(prompt);
        if (!input) // Ctrl-D
            break;

        add_history(input);
        string text(trim(input));
        if (text.empty())
            continue;

        rl_clear_screen(0, 0);
        printf("\n");

        // Parse command
        bool play_sound = false;
        if (text.length() == 1) {
            if (text[0] == 'p') {
                play_sound = true;
                text = ""; 
            }
        } else if (text.length() > 1) {
            if (text[0] == 'p' && text[1] == ' ') {
                play_sound = true;
                text = text.substr(2);
            }
        }

        // Escape spaces
        for (int i = 0; i < int(text.length()); i++)
            if (text[i] == ' ')
                text[i] = '+';

        // Retrieve translations
        String ans;
        init_string(&ans);
        string url = BASE_URL + text + LANG_OPTIONS;
        curl_easy_setopt(curl, CURLOPT_USERAGENT, "Mozilla/5.0");
        curl_easy_setopt(curl, CURLOPT_URL, url.c_str());
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, write_function);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, &ans);
        curl_easy_perform(curl);

        // Find definitions
        bool verb = print_verb(ans.str);
        bool adverb = print_adverb(ans.str);
        bool noun = print_noun(ans.str);
        bool pronoun = print_pronoun(ans.str);
        bool adjective = print_adjective(ans.str);

        // Sentence translation?
        if (!(verb || adverb || noun || pronoun || adjective)) {
            int length = strlen(ans.str);
            int pos = 0;
            while (pos < length && ans.str[pos] != '"')
                pos++;

            pos++;
            while (pos < length && ans.str[pos] != '"')
                putchar(ans.str[pos++]);

            printf("\n");
        }

        // Text To Speech
        if (play_sound) {
            if (text != "")
                play(text);
            else if (last != "")
                play(last);
        }

        if (text != "")
            last = text;

        free(input);
    }
    return 0;
}
