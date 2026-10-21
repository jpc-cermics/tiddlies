// This is the builder.sce 
// must be run from this directory 

// [1] generate Path.incl 
if exists('%nsp') then 
  ilib_path_incl()
end 

// [3] the part devoted to shared lib generation 

ilib_name  = 'libsedumi' 		// interface library name 

// objects files (but do not give mexfiles here)

files= [
    'auxfwdpr1.o';
    'auxgivens.o';
    'blkaux.o';
    'blkchol2.o';
    'bwblkslv2.o';
    'ordmmd.o';
    'reflect.o';
    'sdmauxCmp.o';
    'sdmauxCone.o';
    'sdmauxFill.o';
    'sdmauxRdot.o';
    'sdmauxScalarmul.o';
    'sdmauxTriu.o';
    'sdmauxTriudot.o';
    'spscale.o';
    'symfct.o';
    'triuaux.o'];


// other libs needed for linking (must be shared library names)

libs =[];

// table of (scilab_name,interface-name or mexfile-name, type) 

table =['adendotd','adendotd','cmex';
	'adenscale','adenscale','cmex';
	'blkchol','blkchol','cmex';
	'bwblkslv','bwblkslv','cmex';
	'bwdpr1','bwdpr1','cmex';
	'cholsplit','cholsplit','cmex';
	'choltmpsiz','choltmpsiz','cmex';
	'ddot','ddot','cmex';
	'dpr1fact','dpr1fact','cmex';
	'eigK','eigK','cmex';
	'extractA','extractA','cmex';
	'eyeK','eyeK','cmex';
	'factorK','factorK','cmex';
	'findblks','findblks','cmex';
	'finsymbden','finsymbden','cmex';
	'fwblkslv','fwblkslv','cmex';
	'fwdpr1','fwdpr1','cmex';
	'getada1','getada1','cmex';
	'getada2','getada2','cmex';
	'getada3','getada3','cmex';
	'givensrot','givensrot','cmex';
	'incorder','incorder','cmex';
	'invcholfac','invcholfac','cmex';
	'iswnbr','iswnbr','cmex';
	'makereal','makereal','cmex';
	'mJdetd','mJdetd','cmex';
	'ordmmdmex','ordmmdmex','cmex';
	'partitA','partitA','cmex';
	'psdeig','psdeig','cmex';
	'psdfactor','psdfactor','cmex';
	'psdframeit','psdframeit','cmex';
	'psdinvjmul','psdinvjmul','cmex';
	'psdinvscale','psdinvscale','cmex';
	'psdjmul','psdjmul','cmex';
	'psdscale','psdscale','cmex';
	'qblkmul','qblkmul','cmex';
	'qframev','qframev','cmex';
	'qinvsqrt','qinvsqrt','cmex';
	'qreshape','qreshape','cmex';
	'qrK','qrK','cmex';
	'qscaleK','qscaleK','cmex';
	'quadadd','quadadd','cmex';
	'sortnnz','sortnnz','cmex';
	'sqrtinv','sqrtinv','cmex';
	'statsK','statsK','cmex';
	'symbbwblk','symbbwblk','cmex';
	'symbfwblk','symbfwblk','cmex';
	'symfctmex','symfctmex','cmex';
	'triumtriu','triumtriu','cmex';
	'urotorder','urotorder','cmex';
	'vecsym','vecsym','cmex';
	'vectril','vectril','cmex';
	'whichcpx','whichcpx','cmex';
	'blkmul','blkmul','cmex'  ];

// have been replaced by a macro in Sedumi      	'symbchol','symbchol','cmex';


ldflags =""
cflags = ""

// do not modify below 
// ----------------------------------------------

ilib_build(ilib_name,table,files,libs,ldflags = ldflags,cflags = cflags );



