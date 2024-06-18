
int wordaddress(int n, int wordsize)
  { return ((n + wordsize - 1) / wordsize) * wordsize; }

/* install variables in symbol table */
void instvars(TOKEN idlist, TOKEN typetok)
  {  SYMBOL sym, typesym; int align;
     if (DEBUG)
        { printf("instvars\n");
	  dbugprinttok(idlist);
	  dbugprinttok(typetok);
	};
     typesym = typetok->symtype;
     align = alignsize(typesym);
     while ( idlist != NULL )   /* for each id */
       {  sym = insertsym(idlist->stringval);
          sym->kind = VARSYM;
          sym->offset = wordaddress(blockoffs[blocknumber], align);
          sym->size = typesym->size;
          blockoffs[blocknumber] = sym->offset + sym->size;
          sym->datatype = typesym;
          sym->basicdt = typesym->basicdt; /* some student programs use this */
	  idlist = idlist->link;
	};
      if (DEBUG) printst();
  }
