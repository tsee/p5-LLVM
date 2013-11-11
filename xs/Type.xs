MODULE = LLVM				PACKAGE = LLVM::Type

Type
void(class)
	SV *class

	CODE:
		RETVAL = LLVMVoidType();

	OUTPUT: RETVAL

Type
int(class, bits)
	SV *class
	unsigned int bits

	CODE:
		RETVAL = LLVMIntType(bits);

	OUTPUT: RETVAL

Type
float(class)
	SV *class

	CODE:
		RETVAL = LLVMFloatType();

	OUTPUT: RETVAL

Type
double(class)
	SV *class

	CODE:
		RETVAL = LLVMDoubleType();

	OUTPUT: RETVAL


Type
IV(class)
	SV *class

	ALIAS:
		UV = 1
	CODE:
		RETVAL = LLVMIntType(sizeof(IV)*8);

	OUTPUT: RETVAL

Type
NV(class)
	SV *class
	CODE:
		switch (sizeof(NV)) {
		case sizeof(double):
			RETVAL = LLVMDoubleType();
			break;
		case sizeof(float):
			RETVAL = LLVMFloatType();
			break;
		default:
			abort();
		}

	OUTPUT: RETVAL

Type
func(class, ret_type, ...)
	SV *class
	Type ret_type

	CODE:
		int i;

		Type *params = malloc(sizeof(Type) * (items - 2));

		for (i = 2; i < items; i++) {
			Type param;
			SV *arg = ST(i);

			if (sv_isobject(arg) && sv_derived_from(arg, "LLVM::Type"))
				param = INT2PTR(Type, SvIV((SV *) SvRV(arg)));
			else
				Perl_croak(aTHX_ "arg is not of type LLVM::Type");

			params[i - 2] = param;
		}

		RETVAL = LLVMFunctionType(ret_type, params, items - 2, 0);

	OUTPUT: RETVAL
