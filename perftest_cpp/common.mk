#
# A makefile shared by all UNIX-like architectures.
#

DEBUG_FLAG   += -Wall

cxx_cc_flags += $(DEBUG_FLAG)
cxx_ld_flags += $(DEBUG_FLAG)

syslibs      += -ldl -lm -lpthread

DEFINES_ARCH_SPECIFIC += -DRTI_UNIX
ifdef RTI_SECURE_PERFTEST
DEFINES_CUSTOM += -DRTI_SECURE_PERFTEST
endif
ifdef RTI_PERFTEST_DYNAMIC_LINKING
DEFINES_CUSTOM += -DRTI_PERFTEST_DYNAMIC_LINKING
endif

DEFINES = $(DEFINES_ARCH_SPECIFIC) $(DEFINES_CUSTOM)

ifneq ($(findstring -g, $(DEBUG_FLAG)),)
  # debug
  RELEASEDIR := Debug
else
  # not debug
  RELEASEDIR := Release
endif

OBJDIRROOT   := obj/$(ARCH)
OBJDIR        = $(OBJDIRROOT)/$(RELEASEDIR)
BINDIRROOT   := ../bin/$(ARCH)
BINDIR        = $(BINDIRROOT)/$(RELEASEDIR)
TYPEDIR      := ../DDSTypes
IDLFILE      := ../idl/test.idl

INCLUDES      = -I. \
                -I$(TYPEDIR) \
                -I$(NDDSHOME)/include \
                -I$(NDDSHOME)/include/ndds

LIBS          = -L$(NDDSHOME)/lib/$(ARCH)

ifndef RTI_PERFTEST_DYNAMIC_LINKING
	STATICLIBSUFFIX = z
endif

ifneq ($(findstring -g, $(DEBUG_FLAG)),)
	OPENSSLLIBDIR = debug
	DEBUGLIBSUFFIX = d
else
	OPENSSLLIBDIR = release
endif

LIBSUFFIX = $(STATICLIBSUFFIX)$(DEBUGLIBSUFFIX)

LIBS       += -lnddscpp$(LIBSUFFIX) -lnddsc$(LIBSUFFIX) -lnddscore$(LIBSUFFIX)
ifdef RTI_SECURE_PERFTEST
  ifndef RTI_PERFTEST_DYNAMIC_LINKING
    LIBS       += -lnddssecurity$(LIBSUFFIX)
    LIBS       += -L$(RTI_OPENSSLHOME)/$(OPENSSLLIBDIR)/lib -lssl$(STATICLIBSUFFIX) -lcrypto$(STATICLIBSUFFIX)
  endif
endif

LIBS         += $(syslibs)

EXEC         := perftest_cpp
TYPESOURCES   = $(TYPEDIR)/test.cxx        \
                $(TYPEDIR)/testPlugin.cxx  \
                $(TYPEDIR)/testSupport.cxx
APPSOURCES   := RTIDDSImpl.cxx             \
                perftest_cpp.cxx

TYPEOBJS      = $(TYPESOURCES:$(TYPEDIR)/%.cxx=$(OBJDIR)/%.o)
APPOBJS       = $(APPSOURCES:%.cxx=$(OBJDIR)/%.o)
OBJS          = $(TYPEOBJS) $(APPOBJS)

DIRECTORIES   = $(OBJDIR).dir $(BINDIR).dir

all : $(ARCH)

# We stick the objects in a sub directory to keep your directory clean.
$(ARCH) : $(DIRECTORIES) $(COMMONOBJS) $(EXEC:%=$(BINDIR)/%)

$(BINDIR)/$(EXEC) : $(OBJS)
	$(cxx_ld) -o $(BINDIR)/$(EXEC) $(OBJS) $(LIBS) $(cxx_ld_flags)

$(APPOBJS)  : $(OBJDIR)/%.o : %.cxx             \
                              $(TYPEDIR)/test.h \
                              MessagingIF.h     \
                              RTIDDSImpl.h      \
                              perftest_cpp.h    
	$(cxx_cc) $(cxx_cc_flags)  -o $@ $(DEFINES) $(INCLUDES) -c $<

ifeq '$(OS_ARCH)' 'i86Win32'
RTIDDSGENSCRIPT = rtiddsgen.bat
else
RTIDDSGENSCRIPT = rtiddsgen
endif

generate: $(TYPESOURCES)

$(TYPESOURCES) : $(IDLFILE)
	$(NDDSHOME)/bin/$(RTIDDSGENSCRIPT) \
	    -replace      \
	    -language C++ \
	    -d $(TYPEDIR) $(RTIDDSGEN_PREPROCESSOR) \
	    $(IDLFILE)

$(TYPEOBJS) : $(OBJDIR)/%.o : $(TYPEDIR)/%.cxx  \
                              $(TYPEDIR)/test.h
	$(cxx_cc) $(cxx_cc_flags)  -o $@ $(DEFINES) $(INCLUDES) -c $<

clean :
	-rm -r $(OBJDIRROOT)/* $(BINDIRROOT)/*/$(EXEC)

# Here is how we create those subdirectories automatically.
%.dir :
	@if [ ! -d $* ]; then \
		mkdir -p $* ; \
	fi;
