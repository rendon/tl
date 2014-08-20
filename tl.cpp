#include <iostream>
#include <fstream>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <algorithm>
#include <map>
#include <wordexp.h>
#include <readline/readline.h>
#include <readline/history.h>

#include <curl/curl.h>
using namespace std;
const char tl_version_string[] = 
    "Translator v0.1\n"
    "Copyright (C) 2014 Rafael Rendon Pablo\n"
    "License GPLv3+: GNU GPL version 3 or later"
    " <http://gnu.org/licenses/gpl.html>.\n"
    "This is free software: you are free to change and redistribute it.\n"
    "There is NO WARRANTY, to the extent permitted by law.";
const char tl_help_string[] =
    "Available options:\n"
    "   -v, --version   Displays the current version of tl.\n"
    "\n"
    "   -h, --help      Displays this text.\n"
    "\n"
    "   -s, --source    Use it to indicate the source language using the\n"
    "                   language code. Use this option to override the source\n"
    "                   language in the config file (~/.tlrc), both in the\n"
    "                   interactive version as in the one-time translation.\n"
    "\n"
    "   -t, --target    Use it to indicate the target language using the\n"
    "                   language code. Use this option to override the source\n"
    "                   language in the config file (~/.tlrc), both in the\n"
    "                   interactive version as in the one-time translation.\n"
    "\n"
    "   -p, --play      Retrieve and play the pronunciation. If this option\n"
    "                   is passed in the interactive version ALL translations\n"
    "                   will play the pronunciation.\n"
    "\n"
    "   -l, --langs     Display the list of supported languages and their\n"
    "                   codes. This language codes are what --source and\n"
    "                   --target receives.\n"
    "\n"
    "BASIC USAGE:\n"
    "   Without arguments tl launches an interactive session.\n"
    "\n"
    "   Translate words or text:\n"
    "\n"
    "       $ tl text to translate\n"
    "\n"
    "   Translate with pronunciation:\n"
    "\n"
    "       $ tl -p text to translate\n"
    "\n"
    "   Specify the source and target language:\n"
    "\n"
    "       $ tl -s en -t es alibi\n";

const string RC_FILE = "~/.tlrc";
const char* USER_AGENT = "Mozilla/5.0";
const string PRONUNCIATION_DIRECTORY = "~/.pronunciations";
const string URL4AUDIO = "http://translate.google.com/translate_tts?ie=UTF-8";
const string BASE_URL = "http://translate.google.com/translate_a/t?client=t&text=";

const unsigned MAX_TEXT_LENGTH = 512;

vector<string> languages = {
    "Afrikaans", "Albanian", "Arabic", "Armenian", "Azerbaijani", "Basque",
    "Belarusian", "Bulgarian", "Catalan", "Chinese, (Simplified)",
    "Chinese, (Traditional)", "Croatian", "Czech", "Danish", "Dutch", "English",
    "Estonian", "Filipino", "Finnish", "French", "Galician", "Georgian",
    "German", "Greek", "Haitian, Creole", "Hebrew", "Hindi", "Hungarian",
    "Icelandic", "Indonesian", "Irish", "Italian", "Japanese", "Korean",
    "Latin", "Latvian", "Lithuanian", "Macedonian", "Malay", "Maltese",
    "Norwegian", "Persian", "Polish", "Portuguese", "Romanian", "Russian",
    "Serbian", "Slovak", "Slovenian", "Spanish", "Swahili", "Swedish", "Thai",
    "Turkish", "Ukrainian", "Urdu", "Vietnamese", "Welsh", "Yiddish"
};

vector<string> lang_codes =  {
    "af", "sq", "ar", "hy", "az", "eu", "be", "bg", "ca", "zh-CN", "zh-TW",
    "hr", "cs", "da", "nl", "en", "et", "tl", "fi", "fr", "gl", "ka", "de",
    "el", "ht", "iw", "hi", "hu", "is", "id", "ga", "it", "ja", "ko", "la",
    "lv", "lt", "mk", "ms", "mt", "no", "fa", "pl", "pt", "ro", "ru", "sr",
    "sk", "sl", "es", "sw", "sv", "th", "tr", "uk", "ur", "vi", "cy", "yi"
};

CURL *curl;

struct String {
    char *str;
    size_t length;
};

struct Audio {
    char *bytes;
    size_t length;
};

/* ========== Utility functions ========== */
bool starts_with(const string &str, const string &prefix)
{
    int n = str.length();
    int m = prefix.length();
    if (m > n) {
        return false;
    }

    while (m > 0) {
        if (str[m-1] != prefix[m-1]) {
            return false;
        }
        m--;
    }

    return true;
}

int read_config_file(string file_name, map<string, string> &config)
{
    wordexp_t exp_result;
    wordexp(file_name.c_str(), &exp_result, 0);
    ifstream config_file(exp_result.we_wordv[0]);
    if (config_file.fail()) {
        return 1;
    }

    string line;
    while (getline(config_file, line)) {
        string key = "";
        string value = "";
        int i = 0, end = line.length();

        // Trim
        while (end > 0 && line[end-1] == ' ') { end--; }
        while (i < end && line[i] == ' ')     { i++;   }

        while (i < end && line[i] != ' ' && line[i] != '=') {
            key += line[i++];
        }

        while (i < end && line[i] == ' ') { i++; }
        // Invalid key-value entry
        if (i >= end || line[i] != '=')   { continue; }

        i++; // skip '=' 
        while (i < end && line[i] == ' ') { i++; }

        while (i < end) {
            value += line[i++];
        }

        if (!key.empty() && !value.empty()) {
            config[key] = value;
        }
    }

    config_file.close();
    return 0;
}

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
        fprintf(stderr, "String: Memory reallocation failed: realloc()\n");
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
        fprintf(stderr, "Audio: Memory reallocation failed: realloc()\n");
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
    // Limit result to 5 words.
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

int play(string text, string source, string target)
{
    wordexp_t exp_result;
    wordexp(PRONUNCIATION_DIRECTORY.c_str(), &exp_result, 0);
    string dir(exp_result.we_wordv[0]);
    // Create directory if not exists
    string command = "mkdir -p " + dir;
    system(command.c_str());

    // TODO: Escape especial character for the file name.
    string file_name = dir + "/" + text + "." + source + "_" + target + ".mp3";
    command = "mplayer " + file_name + " > /dev/null 2>&1 &";

    // Test if file already exist.
    FILE *mp3_file = fopen(file_name.c_str(), "r");
    CURL *curl = curl_easy_init();

    // If file exists, just play it.
    if (mp3_file != NULL) {
        fclose(mp3_file);
        system(command.c_str());

    } else {
        // Otherwise, retrieve it.
        Audio mp3;
        init_audio(&mp3);
        string url = URL4AUDIO + "&tl=" + source + "&q=" + text;
        curl_easy_setopt(curl, CURLOPT_USERAGENT, USER_AGENT);
        curl_easy_setopt(curl, CURLOPT_URL, url.c_str());
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, write_mp3);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, &mp3);
        int ret = curl_easy_perform(curl);
        if (ret != CURLE_OK) {
            return EXIT_FAILURE;
        }

        mp3_file = fopen(file_name.c_str(), "w+");
        if (mp3_file == NULL) {
            fprintf(stderr, "Couldn't open file %s\n", file_name.c_str());
        } else {
            fwrite(mp3.bytes, 1, mp3.length, mp3_file);
            fclose(mp3_file);
            system(command.c_str());
        }
    }

    return CURLE_OK;
}

int translate(string text, string source, string target, bool play_sound)
{
    // Escape spaces
    for (int i = 0; i < int(text.length()); i++)
        if (text[i] == ' ')
            text[i] = '+';

    // Retrieve translations
    String ans;
    init_string(&ans);
    //"&sl=en&tl=es";
    string url = BASE_URL + text + "&sl=" + source + "&tl=" + target; 
    //string url = BASE_URL + text + LANG_OPTIONS;
    curl_easy_setopt(curl, CURLOPT_USERAGENT, USER_AGENT);
    curl_easy_setopt(curl, CURLOPT_URL, url.c_str());
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, write_function);
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, &ans);
    int ret = curl_easy_perform(curl);
    if (ret != CURLE_OK) {
        return EXIT_FAILURE;
    }

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
        while (pos < length && ans.str[pos] != '"') {
            pos++;
        }

        pos++;
        while (pos < length && ans.str[pos] != '"') {
            putchar(ans.str[pos++]);
        }

        printf("\n");
    }

    // Text To Speech
    // Pronunciation in the source language.
    if (play_sound && text != "") {
        return play(text, source, target);
    } else {
        return CURLE_OK; // 0
    }
}

void load_settings(string &source, string &target)
{
    map<string, string> config;
    int ret = read_config_file(RC_FILE, config);

    // Couldn't open configuration file.
    if (ret != 0) {
        if (source.empty()) {
            source = "en"; // From english by default.
        }

        if (target.empty()) {
            target = "es"; // To spanish by default.
        }
    } else {
        if (source.empty()) {
            source = config["source_language"];
        }

        if (target.empty()) {
            target = config["target_language"];
        }
    }
}

/* Verifies that the source language is valid. */
bool valid_source(string source)
{
    for (unsigned i = 0; i < lang_codes.size(); i++) {
        if (source == lang_codes[i]) {
            return true;
        }
    }

    return false;
}

/* Verifies that the target language is valid. */
bool valid_target(string target)
{
    for (unsigned i = 0; i < lang_codes.size(); i++) {
        if (target == lang_codes[i]) {
            return true;
        }
    }

    return false;
}

int main(int argc, char *argv[])
{
    string source, target;
    vector<string> params;
    for (int i = 1; i < argc; i++) {
        params.push_back(string(argv[i]));
    }

    unsigned i = 0;
    bool play_sound = false;
    while (i < params.size()) {
        // Option parsing will finish when a non-option is found. This is
        // because in a non-interactive version the rest of the parameters
        // will be concatenated and treated as the text to translate.
        if (params[i][0] != '-') {
            break;
        }

        if (params[i] == "-v" || params[i] == "--version") {
            cout << tl_version_string << endl;
            exit(0);
        } else if (params[i] == "-h" || params[i] == "--help") {
            cout << tl_help_string << endl;
            exit(0);
        } else if (params[i] == "-l" || params[i] == "--langs") {
            cout << "Code\tLanguage" << endl;
            cout << "--------------" << endl;
            for (unsigned i = 0; i < lang_codes.size(); i++) {
                cout << lang_codes[i] << "\t" << languages[i] << endl;
            }
            exit(0);
        } else if (params[i] == "-p" || params[i] == "--play") {
            play_sound = true;
        } else if (params[i] == "-s" || params[i] == "--source") {
            if (i + 1 == params.size() || params[i+1][0] == '-') {
                cerr << "Please provide a valid source language." << endl;
                exit(EXIT_FAILURE);
            }
            source = params[i+1];
            i++;
        } else if (params[i] == "-t" || params[i] == "--target") {
            if (i + 1 == params.size() || params[i+1][0] == '-') {
                cerr << "Please provide a valid target language." << endl;
                exit(EXIT_FAILURE);
            }
            target = params[i+1];
            i++;
        } else {
            cerr << "Unknown option: " << params[i] << endl;
            exit(EXIT_FAILURE);
        }
        i++;
    }

    if (source.empty() || target.empty()) {
        load_settings(source, target);
    }

    if (!valid_source(source)) {
        cerr << "Uknown source language code: " << source << endl;
        exit(EXIT_FAILURE);
    }

    if (!valid_target(target)) {
        cerr << "Uknown target language code: " << target << endl;
        exit(EXIT_FAILURE);
    }

    curl = curl_easy_init();
    if (curl == NULL) {
        fprintf(stderr, "Curl couldn't be initiated.\n");
        exit(EXIT_FAILURE);
    }

    // One-time translation: Take the rest of the arguments (starting at the
    // first non-parameter) as the text to translate.
    if (i < params.size()) {
        string text = "";
        while (i < params.size()) {
            text += params[i] + " ";
            i++;
        }

        text = trim(text);
        if (text.length() > MAX_TEXT_LENGTH) {
            cerr << endl << "\t\t--- The text is too long. Please use the "
                 << "Google translate page to translate documents. ---" << endl;
            exit(EXIT_FAILURE);
        }

        return translate(text, source, target, play_sound);
    }

    // One-time version and help info.
    cout << tl_version_string << endl << endl;
    cout << "Use `tl --help` to obtain help." << endl;

    char prompt[] = ">> ";
    char *input;
    while (true) {
        input = readline(prompt);
        if (!input) // Ctrl-D
            break;

        add_history(input);
        string text(trim(input));
        if (text.empty()) {
            free(input);
            continue;
        }

        rl_clear_screen(0, 0);
        printf("\n");

        bool ps = false;
        if (starts_with(text, "-p ")) {
            ps = true;
            text = text.substr(3);
        }

        if (text.length() > MAX_TEXT_LENGTH) {
            cerr << endl << "\t\t--- The text is too long. Please use the "
                 << "Google translate page to translate documents. ---" << endl;
            free(input);
            continue;
        }

        translate(text, source, target, play_sound | ps);
        free(input);
    }

    return EXIT_SUCCESS;
}

