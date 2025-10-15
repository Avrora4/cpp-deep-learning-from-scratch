#include <iostream>
#include <cstdlib>
#include <stdio.h>
#include <vector>
#include <memory>
using namespace std;

class List
{
    public:
    int num;
    List *next = NULL;
    List (int n)
    {
        num = n;
    }
};

class Function;

class Variable
{
    public:
    float a = 0;
    Function *creator = NULL;

    Variable(float a)
    {
        this->a = a;
    }

};

using PVariable = shared_ptr<Variable>;

class Function
{
    public:
    vector<PVariable> v;

    PVariable forward(PVariable v1, PVariable v2)
    {
        v.push_back(v1);
        v.push_back(v2);

        PVariable pv = PVariable(new Variable(0));
        pv->creator = this;

        pv->a += v1->a;
        pv->a += v2->a;

        return pv;
    }

    PVariable forward(PVariable v1)
    {
        v.push_back(v1);

        PVariable pv = PVariable(new Variable(0));
        pv->creator = this;

        pv->a += v1->a;

        return pv;
    }
};

void traverse(PVariable v)
{
    cout << v->a << endl;

    Function *f = v->creator;
    if(f == NULL) return;

    for (int i=0; i<f->v.size(); i++)
    {
        traverse(f->v[i]);
    }
}

int main()
{
    // start pointer contents
    float *a = (float *)malloc(sizeof(float) * 5);
    // incorrect
    // below code is access to 8 index ahead
    float *b = a + sizeof(float) * 2;

    // correct
    // float pointer is access by using index
    b = a + 2;
    cout << a << endl;
    cout << b << endl;
    free(a);
    // end pointer contents


    // start list structure
    List *obj1 = new List(1);
    List *obj2 = new List(2);
    List *obj3 = new List(3);
    List *obj4 = new List(4);

    obj1->next = obj2;
    obj2->next = obj3;
    obj3->next = obj4;

    List *obj = obj1;
    
    for (int i=0; i < 4; i++)
    {
        cout << "num: " << obj->num << endl;
        obj = obj->next;
    }
    // end list structure

    // start tree structure
    // this tree is composed Variable and Function
    PVariable v1 = PVariable(new Variable(1)); // v1->a = 1, v1->creator = NULL
    PVariable v2 = PVariable(new Variable(1)); // v2->a = 1, v2->creator = NULL
    Function *f1 = new Function();
    Function *f2 = new Function();
    Function *f3 = new Function();

    PVariable r1 = f1->forward(v1,v2);
    PVariable r2 = f2->forward(r1);
    PVariable r3 = f3->forward(r2);

    traverse(r3);
    // end tree structure

    return 0;
}
