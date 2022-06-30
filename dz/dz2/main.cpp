#include <iostream>
#include <string.h>
#include <string>
#include <sstream>


enum Lex
{
    Const,
    Int,
    Var,
    LSbracket,
    RSbracket,
    PlusNumber,
    MinusNumber,
    Comma,
    LBrace,
    RBrace,
    Equals,
    Semicolon,
    Error 
};
Lex lex;
char str[100];
int k = 0;

////////


int checkInt(char* sym)
{
    int i = 0;
    int k = 0;
    if (sym[0] == '+')
    {
        i++;
    }
    if (sym[0] == '-')
    {
        i++;
        k = 1;
    }
    while (i < strlen(sym) && sym[i] >= '0' && sym[i] <= '9')
    {
        i++;
    }
    if (i != strlen(sym))
    {
        return 2;
    }
    return k;
}

Lex getLex(char* str,int& i)
{
    while (str[i] == ' ')
    {
        i++;
    }
    if (str[i] == '[')
    {
        i++;
        return LSbracket;
    }
    if (str[i] == ']')
    {
        i++;
        return RSbracket;
    }
    if (str[i] == ';')
    {
        i++;
        return Semicolon;
    }
    if (str[i] == '=')
    {
        i++;
        return Equals;
    }
    if (str[i] == '{')
    {
        i++;
        return LBrace;
    }
    if (str[i] == '}')
    {
        i++;
        return RBrace;
    }
    if (str[i] == ',')
    {
        i++;
        return Comma;
    }
    char symbols[50];
    int j = 0;
    while ((strlen(str) > i) && ((str[i] >= 'A' && str[i] <= 'Z') || (str[i] >= 'a' && str[i] <= 'z') || (str[i] >= '0' && str[i] <= '9') || str[i]=='+' || str[i]=='-'))
    {
        symbols[j] = str[i];
        j++;
        i++;
    } 
    symbols[j] = '\0';
    if (strcmp(symbols, "const") == 0)
    {
        return Const;
    }
    if (strcmp(symbols, "int") == 0)
    {
        return Int;
    }
    if (checkInt(symbols)==0)
    {
        
        return PlusNumber;
    }
    if (checkInt(symbols) == 1)
    {

        return MinusNumber;
    }
    if ((symbols[0] >= 'A' && symbols[0] <= 'Z') || (symbols[0] >= 'a' && symbols[0] <= 'z'))
    {
        return Var;
    }
    return Error;
}

void T();

void E()
{
    if (lex == Comma)
    {
        lex = getLex(str, k);
        T();
    }
}

void T()
{
    if (lex == MinusNumber || lex == PlusNumber)
    {
        lex = getLex(str, k);
        E();
    }
    else
    {
        throw "expected number!!!";
    }
}

void M()
{
    if (lex == LBrace)
    {
        lex = getLex(str, k);
        T();
        if (lex == RBrace)
        {
            lex = getLex(str, k);
        }
        else
        {
            throw "expected right brace!!!";
        }

        if (lex == Comma)
        {
            lex = getLex(str, k);
        }
        else
        {
            throw "expected comma!!!";
        }
        if (lex == LBrace)
        {
            lex = getLex(str, k);
        }
        else
        {
            throw "expected left brace!!!";
        }
        T();
        if (lex == RBrace)
        {
            lex = getLex(str, k);
        }
        else
        {
            throw "expected right brace!!!";
        }
    }
    else
    {
        T();
    }
}

void L()
{
    if (lex == LBrace)
    {
        lex = getLex(str, k);
    }
    else
    {
        throw "expected left brace!!!";
    }

    M();

    if (lex == RBrace)
    {
        lex = getLex(str, k);
    }
    else
    {
        throw "expected right brace!!!";
    }
}

void K()
{
    if (lex == Equals)
    {
        lex = getLex(str, k);
        L();
        if (lex != Semicolon)
        {
            throw "expected semicolon!!!";
        }
    }
    else if (lex != Semicolon)
    {
        throw "expected semicolon!!!";
    }
}

void C()
{
    if (lex == LSbracket)
    {
        lex = getLex(str, k);
        if (lex == PlusNumber)
        {
            lex = getLex(str, k);
        }
        else
        {
            throw "expected number!!!";
        }
        if (lex == RSbracket)
        {
            lex = getLex(str, k);
        }
        else
        {
            throw "expected right sbracket!!!";
        }
        K();
    }
    else
    {
        K();
    }
}

void A() 
{
    if (lex == Const)
    {
        lex = getLex(str, k);
    }
}
void B()
{
    if (lex == Int)
    {
        lex = getLex(str, k);
    }
    else
    {
        throw "expected int!!!";
    }

    if (lex == Var)
    {
        lex = getLex(str, k);
    }
    else
    {
        throw "expected name of array!!!";
    }


    if (lex == LSbracket)
    {
        lex = getLex(str, k);
    }
    else
    {
        throw "expected left sbracket!!!";
    }
    
    if (lex == PlusNumber)
    {
        lex = getLex(str, k);
    }
    else
    {
        throw "expected positive number!!!";
    }

    if (lex == RSbracket)
    {
        lex = getLex(str, k);
    }
    else
    {
        throw "expected right sbracket!!!";
    }
    C();
}


void synanalisator()
{
    lex = getLex(str,k);
    A();
    B();
}



int main()
{
    
    try
    {
        std::cin.getline(str, 100);
        synanalisator();
        std::cout << "OK";
    }
    catch (const char* bad_mes)
    {
        std::cout << bad_mes;
    }
    
}