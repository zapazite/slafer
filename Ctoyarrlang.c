//https://tio.run/##XVJtb@IwDP6eXxGBNsWpiyjstVmGppMmTWJibx8mekxCWcuKaIYg2xWq/vXjHAa3031JYvuJ/Ty2TTgxZrNpvqZZblM@EBbLVqsFqsreFyK3jue6rfILq/IggKpUdc324DtxjRlciz5fYZ@XUPX5Wg@FXMFArMJLi@vwcp7kI02G65HhfjId4bUPej@WEO@eGS@3jwO67AhWeq1q5lbzlErxpVt8GFd5MhYdzpNRLfvKqkJJp6imSukcCgvVWhfj2ezdCGblGSgqabVV9Y2nCBVBtPQFwcvck8u/qt2JKwzgTjwhk3TdYgg/vpWVXxrkUERA/3SJ67hUQ0EZvVIIPG9QrEgLM18Jnxt9Jdzy@McbUH@93@N3FN02t2L1455mBEp68Da3qh@@eWwllP9LWDHY5olULWSWjECArtr4gG28wie8xR/4iDe1evYDlQ6qVFPnnBaFliwIHPSku4g6p73T8xdJNpk6S4qXo5NeEZ8E0o1EivQPn4WDWBACXRKNNMsSH8uSk6AgCODu5YPg0T43xNLFqarvScUaqoFvA1Fnvp/3YicBvBYbRlrnvXi@IJqZaHDVgG/j4LWxF8wA6mKcW2FwCpV5Gy9kiXKJ8lM3mnkgQ2yogTh0aDXtziy1YpK6pVgCqCmjdXb7NfEj8I00eklpVbfzYnoumQYBrcXyNZ/kThjo@YGgHwibaxMendHsRekzm7eF@EQD0ItoAT5jE7dhetA5PLwXvlOg5h9UttEgupvNcStnjA7e5F3Gznk@kPz4r4cjj7CD3S9HizcJso0c84Cf8pBHXPJzxn6bbDaeLDdh0e1swl9/AA
// From finooiigee (apl farm discord)
#define O(n,x...);{for(int i=0;i<n;i++){x;}}
#define P(F,f)F(L y,L x){L z=Z(*y)O(y->n,z->p[i]=y->t?z->t\
=1,F(y->p[i],x):y->p[i]f x->p[i%x->n])y=z;}
typedef struct{int n,t,p[]}*L;n;m;*t;L z;e;L Z(n){z=malloc(
n*8);z->n=n;}I(L y){Z(n=*y->p)O(n,z->p[i]=i)y=z;}P(A,+)P(T,
*)P(M,-)C(L y,L x){x=y->t?*Z(1)->p=x,z:x;Z((n=y->n)+x->n);
memcpy(z->p,y->p,n*8);memcpy(z->p+n,x->p,x->n*8);z->t=y->t;
}S(L y){Z(1);*z->p=y->n;}R(L y,L x){Z(n=*x->p)O(n,z->p[i]=y
)z->t=1;}(*f[])()={0,R,0,A,T,M,C,S,I};X(int*t){e=*t;t=(m=*
++t)?*t<127?79^*++t?*t=f[m^46?m:6+*t](e,*t),X(t):(++t,t[1]=
f[*t](f[6+m](e),f[6+m](t[1])),X(++t)):*t:e;}Q(L z){O(z->n,z
->t?Q(z->p[i]),z->n-1==i?:printf(" ;"):printf(" %d",z->p[i]
))}main(c,j){char*x,*s,*v="#i+*-,";O(&t,n=strlen(gets(s));j
=0;t=malloc(n*8)O(n,c=s[i];32^c?t[j++]=isdigit(c)?Z(1),*z->
p=c-48,z:(x=strchr(v,c))?1+x-v:c:0)j%2&&Q(X(t));puts(""))}
