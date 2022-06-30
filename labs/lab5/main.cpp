#include <iostream>
#include <vector>
#include <string>
#include <sstream>
#include <cctype>
#include <string.h>
using namespace std;
 
extern void printASM(char* line, int len);
extern int numwordASM(char* line, int len);

int main()
{
    string str("The quick brown-fox jump$ over, the --- lazy dog.");
    stringstream ss(str);
 
    string temp;
    vector<string> vec;
    while(ss >> temp)
    {
        vec.push_back(temp);
    }
    
 
    int counter;
    string line;
    char str_new[255];
    strcpy(str_new, str.c_str());

    int num_words = numwordASM(str_new, str.size());
    
    for(size_t i = 0; i != num_words; i++)
    {
        line.clear();
        counter = 0;
        while(counter < 30)
        {
            counter += (int)vec[i].length();
            if(counter >= 30||i >= num_words)
                break;
            line += vec[i];
            counter++;
            if(counter >= 30)
                break;
            line.push_back(' ');
            i++;
        }
 
        i--;
        int e = line.length();
 
        int j = 0;
        while(e < 30){
            while(!isspace(line[j]))
                j++;
            if(j < line.length()-1){
                line.insert(line.begin() + j, ' ');
                e++;
                if(e >= 30)
                    break;
            }
            j++;
            if(j == line.length())
                j = 0;
            while(isspace(line[j]))   
                j++;
        }

        char line_out[255];
        strcpy(line_out, line.c_str());
        printASM(line_out, line.size());
        // cout << line_out << endl;
    }
 
    return 0;
}