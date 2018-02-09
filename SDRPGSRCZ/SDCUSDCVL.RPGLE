     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2007')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Customer Cheques and Cards details Validation')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDCUSDCVL - Customer Cheques and Cards details Validation    *
      *                                                               *
      *  (c) Finastra International Limited 2007                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. CSD079  *CREATE    Date 05Feb07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD079 - Enhanced Customer Maintenance API                   *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Hook to enable non-core files to be included
      /COPY WNCPYSRC,SDCHECV001
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **----------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **----------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Transaction Details in screen format
     D TrnDets       E DS                  EXTNAME(SDCHECPD)
 
      ** Transaction Details OK indicators
     D OKTrnDets     E DS                  EXTNAME(SDECHECPD)
 
      ** Valid Transaction Details layout
     D ValidCHEC     E DS                  EXTNAME(SDVCHECPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D ZMUSER          DS            17
     D  USRBCH                11     13
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Work fields for bank data
     D WKDFIN          S                   LIKE(BJDFIN)
     D WKRDNB          S                   LIKE(BJRDNB)
     D WKCYCD          S                   LIKE(BJCYCD)
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
 
      ** Work variables
     D DDCACX          S             10A
     D DDDISK          S              6A
     D DDDREX          S              6A
     D DDCQFX          S             10A
     D DDCQTX          S             10A
     D DDCQQX          S              3A
     D DDCQIX          S              6A
     D DDCANX          S              1A
     D DDCALX          S             20A
     D DDCAIX          S              6A
     D DDCAEX          S              6A
     D DDDISX          S              6A
     D FldName         S             10A
     D FldNme1         S             10A
     D FldNme2         S             10A
     D CCDISX          S              5P 0
     D CCDREX          S              5P 0
     D CCCQIX          S              5P 0
     D CCCAIX          S              5P 0
     D CCCAEX          S              5P 0
     D DDCACXOK        S              1A
     D DDDISXOK        S              1A
     D DDDREXOK        S              1A
     D DDCQFXOK        S              1A
     D DDCQTXOK        S              1A
     D DDCQQXOK        S              1A
     D DDCQIXOK        S              1A
     D DDCANXOK        S              1A
     D DDCALXOK        S              1A
     D DDCAIXOK        S              1A
     D DDCAEXOK        S              1A
     D I               S              3P 0
     D Respmode        S              1A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SDCHECV002
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      *
      /COPY WNCPYSRC,SDCHECV003
 
      ** Validate Cheque Card 1
 
      /COPY WNCPYSRC,SDCHECV004
     C                   EVAL      DDCACX = DDCAC1
     C                   EVAL      DDDISX = DDDIS1
     C                   EVAL      DDDREX = DDDRE1
     C                   EVAL      FldName= 'DDCAC1   '
     C                   EVAL      DDCACXOK = 'Y'
     C                   EXSR      VCACXSR
      /COPY WNCPYSRC,SDCHECV005
 
      ** Validate Cheque Card 2
 
      /COPY WNCPYSRC,SDCHECV006
     C                   EVAL      DDCACX = DDCAC2
     C                   EVAL      DDDISX = DDDIS2
     C                   EVAL      DDDREX = DDDRE2
     C                   EVAL      FldName= 'DDCAC2   '
     C                   EVAL      DDCACXOK = 'Y'
     C                   EXSR      VCACXSR
      /COPY WNCPYSRC,SDCHECV007
 
      ** Validate Cheque Card 3
 
      /COPY WNCPYSRC,SDCHECV008
     C                   EVAL      DDCACX = DDCAC3
     C                   EVAL      DDDISX = DDDIS3
     C                   EVAL      DDDREX = DDDRE3
     C                   EVAL      FldName= 'DDCAC3   '
     C                   EVAL      DDCACXOK = 'Y'
     C                   EXSR      VCACXSR
      /COPY WNCPYSRC,SDCHECV009
 
      ** Validate Cheque Card 4
 
      /COPY WNCPYSRC,SDCHECV010
     C                   EVAL      DDCACX = DDCAC4
     C                   EVAL      DDDISX = DDDIS4
     C                   EVAL      DDDREX = DDDRE4
     C                   EVAL      FldName= 'DDCAC4   '
     C                   EVAL      DDCACXOK = 'Y'
     C                   EXSR      VCACXSR
      /COPY WNCPYSRC,SDCHECV011
 
      ** Validate Cheque Card 5
 
      /COPY WNCPYSRC,SDCHECV012
     C                   EVAL      DDCACX = DDCAC5
     C                   EVAL      DDDISX = DDDIS5
     C                   EVAL      DDDREX = DDDRE5
     C                   EVAL      FldName= 'DDCAC5   '
     C                   EVAL      DDCACXOK = 'Y'
     C                   EXSR      VCACXSR
      /COPY WNCPYSRC,SDCHECV013
 
      ** Validate  Cheque Card Date 1
 
      /COPY WNCPYSRC,SDCHECV014
     C                   EVAL      DDCACX = DDCAC1
     C                   EVAL      DDDISX = DDDIS1
     C                   EVAL      DDDREX = DDDRE1
     C                   EVAL      FldNme1= 'DDDIS1   '
     C                   EVAL      FldNme2= 'DDDRE1   '
     C                   EVAL      DDDISXOK = 'Y'
     C                   EVAL      DDDREXOK = 'Y'
     C                   EXSR      VCCDTXSR
     C                   EVAL      CCDIS1 = CCDISX
     C                   EVAL      CCDRE1 = CCDREX
      /COPY WNCPYSRC,SDCHECV015
 
      ** Validate  Cheque Card Date 2
 
      /COPY WNCPYSRC,SDCHECV016
     C                   EVAL      DDCACX = DDCAC2
     C                   EVAL      DDDISX = DDDIS2
     C                   EVAL      DDDREX = DDDRE2
     C                   EVAL      FldNme1= 'DDDIS2   '
     C                   EVAL      FldNme2= 'DDDRE2   '
     C                   EVAL      DDDISXOK = 'Y'
     C                   EVAL      DDDREXOK = 'Y'
     C                   EXSR      VCCDTXSR
     C                   EVAL      CCDIS2 = CCDISX
     C                   EVAL      CCDRE2 = CCDREX
      /COPY WNCPYSRC,SDCHECV017
 
      ** Validate  Cheque Card Date 3
 
      /COPY WNCPYSRC,SDCHECV018
     C                   EVAL      DDCACX = DDCAC3
     C                   EVAL      DDDISX = DDDIS3
     C                   EVAL      DDDREX = DDDRE3
     C                   EVAL      FldNme1= 'DDDIS3   '
     C                   EVAL      FldNme2= 'DDDRE3   '
     C                   EVAL      DDDISXOK = 'Y'
     C                   EVAL      DDDREXOK = 'Y'
     C                   EXSR      VCCDTXSR
     C                   EVAL      CCDIS3 = CCDISX
     C                   EVAL      CCDRE3 = CCDREX
      /COPY WNCPYSRC,SDCHECV019
 
      ** Validate  Cheque Card Date 4
 
      /COPY WNCPYSRC,SDCHECV020
     C                   EVAL      DDCACX = DDCAC4
     C                   EVAL      DDDISX = DDDIS4
     C                   EVAL      DDDREX = DDDRE4
     C                   EVAL      FldNme1= 'DDDIS4   '
     C                   EVAL      FldNme2= 'DDDRE4   '
     C                   EVAL      DDDISXOK = 'Y'
     C                   EVAL      DDDREXOK = 'Y'
     C                   EXSR      VCCDTXSR
     C                   EVAL      CCDIS4 = CCDISX
     C                   EVAL      CCDRE4 = CCDREX
      /COPY WNCPYSRC,SDCHECV021
 
      ** Validate  Cheque Card Date 5
 
      /COPY WNCPYSRC,SDCHECV022
     C                   EVAL      DDCACX = DDCAC5
     C                   EVAL      DDDISX = DDDIS5
     C                   EVAL      DDDREX = DDDRE5
     C                   EVAL      FldNme1= 'DDDIS5   '
     C                   EVAL      FldNme2= 'DDDRE5   '
     C                   EVAL      DDDISXOK = 'Y'
     C                   EVAL      DDDREXOK = 'Y'
     C                   EXSR      VCCDTXSR
     C                   EVAL      CCDIS5 = CCDISX
     C                   EVAL      CCDRE5 = CCDREX
      /COPY WNCPYSRC,SDCHECV023
 
      ** Validate  Cheque Number 1
 
      /COPY WNCPYSRC,SDCHECV024
     C                   EVAL      DDCQFX = DDCQF1
     C                   EVAL      DDCQTX = DDCQT1
     C                   EVAL      DDCQQX = DDCQQ1
     C                   EVAL      DDCQIX = DDCQI1
     C                   EVAL      FldNme1= 'DDCQF1   '
     C                   EVAL      FldNme2= 'DDCQT1   '
     C                   EVAL      DDCQFXOK = 'Y'
     C                   EVAL      DDCQTXOK = 'Y'
     C                   EXSR      VCQFXSR
      /COPY WNCPYSRC,SDCHECV025
 
      ** Validate  Cheque Number 2
 
      /COPY WNCPYSRC,SDCHECV026
     C                   EVAL      DDCQFX = DDCQF2
     C                   EVAL      DDCQTX = DDCQT2
     C                   EVAL      DDCQQX = DDCQQ2
     C                   EVAL      DDCQIX = DDCQI2
     C                   EVAL      FldNme1= 'DDCQF2   '
     C                   EVAL      FldNme2= 'DDCQT2   '
     C                   EVAL      DDCQFXOK = 'Y'
     C                   EVAL      DDCQTXOK = 'Y'
     C                   EXSR      VCQFXSR
      /COPY WNCPYSRC,SDCHECV027
 
      ** Validate  Cheque Number 3
 
      /COPY WNCPYSRC,SDCHECV028
     C                   EVAL      DDCQFX = DDCQF3
     C                   EVAL      DDCQTX = DDCQT3
     C                   EVAL      DDCQQX = DDCQQ3
     C                   EVAL      DDCQIX = DDCQI3
     C                   EVAL      FldNme1= 'DDCQF3   '
     C                   EVAL      FldNme2= 'DDCQT3   '
     C                   EVAL      DDCQFXOK = 'Y'
     C                   EVAL      DDCQTXOK = 'Y'
     C                   EXSR      VCQFXSR
      /COPY WNCPYSRC,SDCHECV029
 
      ** Validate  Cheque Number 4
 
      /COPY WNCPYSRC,SDCHECV030
     C                   EVAL      DDCQFX = DDCQF4
     C                   EVAL      DDCQTX = DDCQT4
     C                   EVAL      DDCQQX = DDCQQ4
     C                   EVAL      DDCQIX = DDCQI4
     C                   EVAL      FldNme1= 'DDCQF4   '
     C                   EVAL      FldNme2= 'DDCQT4   '
     C                   EVAL      DDCQFXOK = 'Y'
     C                   EVAL      DDCQTXOK = 'Y'
     C                   EXSR      VCQFXSR
      /COPY WNCPYSRC,SDCHECV031
 
      ** Validate  Cheque Number 5
 
      /COPY WNCPYSRC,SDCHECV032
     C                   EVAL      DDCQFX = DDCQF5
     C                   EVAL      DDCQTX = DDCQT5
     C                   EVAL      DDCQQX = DDCQQ5
     C                   EVAL      DDCQIX = DDCQI5
     C                   EVAL      FldNme1= 'DDCQF5   '
     C                   EVAL      FldNme2= 'DDCQT5   '
     C                   EVAL      DDCQFXOK = 'Y'
     C                   EVAL      DDCQTXOK = 'Y'
     C                   EXSR      VCQFXSR
      /COPY WNCPYSRC,SDCHECV033
 
      ** Validate  Cheque Number Quantity 1
 
      /COPY WNCPYSRC,SDCHECV034
     C                   EVAL      DDCQFX = DDCQF1
     C                   EVAL      DDCQTX = DDCQT1
     C                   EVAL      DDCQQX = DDCQQ1
     C                   EVAL      FldName= 'DDCQQ1   '
     C                   EVAL      DDCQQXOK = 'Y'
     C                   EXSR      VCQQXSR
     C                   EVAL      DDCQQ1 = DDCQQX
      /COPY WNCPYSRC,SDCHECV035
 
      ** Validate  Cheque Number Quantity 2
 
      /COPY WNCPYSRC,SDCHECV036
     C                   EVAL      DDCQFX = DDCQF2
     C                   EVAL      DDCQTX = DDCQT2
     C                   EVAL      DDCQQX = DDCQQ2
     C                   EVAL      FldName= 'DDCQQ2   '
     C                   EVAL      DDCQQXOK = 'Y'
     C                   EXSR      VCQQXSR
     C                   EVAL      DDCQQ2 = DDCQQX
 
      /COPY WNCPYSRC,SDCHECV037
 
      ** Validate  Cheque Number Quantity 3
 
      /COPY WNCPYSRC,SDCHECV038
     C                   EVAL      DDCQFX = DDCQF3
     C                   EVAL      DDCQTX = DDCQT3
     C                   EVAL      DDCQQX = DDCQQ3
     C                   EVAL      FldName= 'DDCQQ3   '
     C                   EVAL      DDCQQXOK = 'Y'
     C                   EXSR      VCQQXSR
     C                   EVAL      DDCQQ3 = DDCQQX
 
      /COPY WNCPYSRC,SDCHECV039
 
      ** Validate  Cheque Number Quantity 4
 
      /COPY WNCPYSRC,SDCHECV040
     C                   EVAL      DDCQFX = DDCQF4
     C                   EVAL      DDCQTX = DDCQT4
     C                   EVAL      DDCQQX = DDCQQ4
     C                   EVAL      FldName= 'DDCQQ4   '
     C                   EVAL      DDCQQXOK = 'Y'
     C                   EXSR      VCQQXSR
     C                   EVAL      DDCQQ4 = DDCQQX
 
      /COPY WNCPYSRC,SDCHECV041
 
      ** Validate  Cheque Number Quantity 5
 
      /COPY WNCPYSRC,SDCHECV042
     C                   EVAL      DDCQFX = DDCQF5
     C                   EVAL      DDCQTX = DDCQT5
     C                   EVAL      DDCQQX = DDCQQ5
     C                   EVAL      FldName= 'DDCQQ5   '
     C                   EVAL      DDCQQXOK = 'Y'
     C                   EXSR      VCQQXSR
     C                   EVAL      DDCQQ5 = DDCQQX
 
      /COPY WNCPYSRC,SDCHECV043
 
      ** Validate  Cheque Number Date 1
 
      /COPY WNCPYSRC,SDCHECV044
     C                   EVAL      DDCQFX = DDCQF1
     C                   EVAL      DDCQTX = DDCQT1
     C                   EVAL      DDCQIX = DDCQI1
     C                   EVAL      FldName= 'DDCQI1   '
     C                   EVAL      DDCQIXOK = 'Y'
     C                   EXSR      VCQIXSR
     C                   EVAL      CCCQI1 = CCCQIX
      /COPY WNCPYSRC,SDCHECV045
 
      ** Validate  Cheque Number Date 2
 
      /COPY WNCPYSRC,SDCHECV046
     C                   EVAL      DDCQFX = DDCQF2
     C                   EVAL      DDCQTX = DDCQT2
     C                   EVAL      DDCQIX = DDCQI2
     C                   EVAL      FldName= 'DDCQI2   '
     C                   EVAL      DDCQIXOK = 'Y'
     C                   EXSR      VCQIXSR
     C                   EVAL      CCCQI2 = CCCQIX
      /COPY WNCPYSRC,SDCHECV047
 
      ** Validate  Cheque Number Date 3
 
      /COPY WNCPYSRC,SDCHECV048
     C                   EVAL      DDCQFX = DDCQF3
     C                   EVAL      DDCQTX = DDCQT3
     C                   EVAL      DDCQIX = DDCQI3
     C                   EVAL      FldName= 'DDCQI3   '
     C                   EVAL      DDCQIXOK = 'Y'
     C                   EXSR      VCQIXSR
     C                   EVAL      CCCQI3 = CCCQIX
      /COPY WNCPYSRC,SDCHECV049
 
      ** Validate  Cheque Number Date 4
 
      /COPY WNCPYSRC,SDCHECV050
     C                   EVAL      DDCQFX = DDCQF4
     C                   EVAL      DDCQTX = DDCQT4
     C                   EVAL      DDCQIX = DDCQI4
     C                   EVAL      FldName= 'DDCQI4   '
     C                   EVAL      DDCQIXOK = 'Y'
     C                   EXSR      VCQIXSR
     C                   EVAL      CCCQI4 = CCCQIX
      /COPY WNCPYSRC,SDCHECV051
 
      ** Validate  Cheque Number Date 5
 
      /COPY WNCPYSRC,SDCHECV052
     C                   EVAL      DDCQFX = DDCQF5
     C                   EVAL      DDCQTX = DDCQT5
     C                   EVAL      DDCQIX = DDCQI5
     C                   EVAL      FldName= 'DDCQI5   '
     C                   EVAL      DDCQIXOK = 'Y'
     C                   EXSR      VCQIXSR
     C                   EVAL      CCCQI5 = CCCQIX
      /COPY WNCPYSRC,SDCHECV053
 
      ** Validate  Credit Card 1
 
      /COPY WNCPYSRC,SDCHECV054
     C                   EVAL      DDCANX = DDCAN1
     C                   EVAL      DDCALX = DDCAL1
     C                   EVAL      DDCAIX = DDCAI1
     C                   EVAL      DDCAEX = DDCAE1
     C                   EVAL      FldName= 'DDCAN1   '
     C                   EVAL      DDCANXOK = 'Y'
     C                   EXSR      VCANXSR
      /COPY WNCPYSRC,SDCHECV055
 
      ** Validate  Credit Card 2
 
      /COPY WNCPYSRC,SDCHECV056
     C                   EVAL      DDCANX = DDCAN2
     C                   EVAL      DDCALX = DDCAL2
     C                   EVAL      DDCAIX = DDCAI2
     C                   EVAL      DDCAEX = DDCAE2
     C                   EVAL      FldName= 'DDCAN2   '
     C                   EVAL      DDCANXOK = 'Y'
     C                   EXSR      VCANXSR
      /COPY WNCPYSRC,SDCHECV057
 
      ** Validate  Credit Card 3
 
      /COPY WNCPYSRC,SDCHECV058
     C                   EVAL      DDCANX = DDCAN3
     C                   EVAL      DDCALX = DDCAL3
     C                   EVAL      DDCAIX = DDCAI3
     C                   EVAL      DDCAEX = DDCAE3
     C                   EVAL      FldName= 'DDCAN3   '
     C                   EVAL      DDCANXOK = 'Y'
     C                   EXSR      VCANXSR
      /COPY WNCPYSRC,SDCHECV059
 
      ** Validate  Credit Card 4
 
      /COPY WNCPYSRC,SDCHECV060
     C                   EVAL      DDCANX = DDCAN4
     C                   EVAL      DDCALX = DDCAL4
     C                   EVAL      DDCAIX = DDCAI4
     C                   EVAL      DDCAEX = DDCAE4
     C                   EVAL      FldName= 'DDCAN4   '
     C                   EVAL      DDCANXOK = 'Y'
     C                   EXSR      VCANXSR
      /COPY WNCPYSRC,SDCHECV061
 
      ** Validate  Credit Card 5
 
      /COPY WNCPYSRC,SDCHECV062
     C                   EVAL      DDCANX = DDCAN5
     C                   EVAL      DDCALX = DDCAL5
     C                   EVAL      DDCAIX = DDCAI5
     C                   EVAL      DDCAEX = DDCAE5
     C                   EVAL      FldName= 'DDCAN5   '
     C                   EVAL      DDCANXOK = 'Y'
     C                   EXSR      VCANXSR
      /COPY WNCPYSRC,SDCHECV063
 
      ** Validate  Credit Card Text 1
 
      /COPY WNCPYSRC,SDCHECV064
     C                   EVAL      DDCANX = DDCAN1
     C                   EVAL      DDCALX = DDCAL1
     C                   EVAL      FldName= 'DDCAL1   '
     C                   EVAL      DDCALXOK = 'Y'
     C                   EXSR      VCALXSR
      /COPY WNCPYSRC,SDCHECV065
 
      ** Validate  Credit Card Text 2
 
      /COPY WNCPYSRC,SDCHECV066
     C                   EVAL      DDCANX = DDCAN2
     C                   EVAL      DDCALX = DDCAL2
     C                   EVAL      FldName= 'DDCAL2   '
     C                   EVAL      DDCALXOK = 'Y'
     C                   EXSR      VCALXSR
      /COPY WNCPYSRC,SDCHECV067
 
      ** Validate  Credit Card Text 3
 
      /COPY WNCPYSRC,SDCHECV068
     C                   EVAL      DDCANX = DDCAN3
     C                   EVAL      DDCALX = DDCAL3
     C                   EVAL      FldName= 'DDCAL3   '
     C                   EVAL      DDCALXOK = 'Y'
     C                   EXSR      VCALXSR
      /COPY WNCPYSRC,SDCHECV069
 
      ** Validate  Credit Card Text 4
 
      /COPY WNCPYSRC,SDCHECV070
     C                   EVAL      DDCANX = DDCAN4
     C                   EVAL      DDCALX = DDCAL4
     C                   EVAL      FldName= 'DDCAL4   '
     C                   EVAL      DDCALXOK = 'Y'
     C                   EXSR      VCALXSR
      /COPY WNCPYSRC,SDCHECV071
 
      ** Validate  Credit Card Text 5
      /COPY WNCPYSRC,SDCHECV072
     C                   EVAL      DDCANX = DDCAN5
     C                   EVAL      DDCALX = DDCAL5
     C                   EVAL      FldName= 'DDCAL5   '
     C                   EVAL      DDCALXOK = 'Y'
     C                   EXSR      VCALXSR
      /COPY WNCPYSRC,SDCHECV073
 
      ** Validate  Credit Card Date 1
 
      /COPY WNCPYSRC,SDCHECV074
     C                   EVAL      DDCANX = DDCAN1
     C                   EVAL      DDCAIX = DDCAI1
     C                   EVAL      DDCAEX = DDCAE1
     C                   EVAL      FldNme1= 'DDCAI1   '
     C                   EVAL      FldNme2= 'DDCAE1   '
     C                   EVAL      DDCAIXOK = 'Y'
     C                   EVAL      DDCAEXOK = 'Y'
     C                   EXSR      VCADTXSR
     C                   EVAL      CCCAI1 = CCCAIX
     C                   EVAL      CCCAE1 = CCCAEX
      /COPY WNCPYSRC,SDCHECV075
 
      ** Validate  Credit Card Date 2
 
      /COPY WNCPYSRC,SDCHECV076
     C                   EVAL      DDCANX = DDCAN2
     C                   EVAL      DDCAIX = DDCAI2
     C                   EVAL      DDCAEX = DDCAE2
     C                   EVAL      FldNme1= 'DDCAI2   '
     C                   EVAL      FldNme2= 'DDCAE2   '
     C                   EVAL      DDCAIXOK = 'Y'
     C                   EVAL      DDCAEXOK = 'Y'
     C                   EXSR      VCADTXSR
     C                   EVAL      CCCAI2 = CCCAIX
     C                   EVAL      CCCAE2 = CCCAEX
      /COPY WNCPYSRC,SDCHECV077
 
      ** Validate  Credit Card Date 3
 
      /COPY WNCPYSRC,SDCHECV078
     C                   EVAL      DDCANX = DDCAN3
     C                   EVAL      DDCAIX = DDCAI3
     C                   EVAL      DDCAEX = DDCAE3
     C                   EVAL      FldNme1= 'DDCAI3   '
     C                   EVAL      FldNme2= 'DDCAE3   '
     C                   EVAL      DDCAIXOK = 'Y'
     C                   EVAL      DDCAEXOK = 'Y'
     C                   EXSR      VCADTXSR
     C                   EVAL      CCCAI3 = CCCAIX
     C                   EVAL      CCCAE3 = CCCAEX
      /COPY WNCPYSRC,SDCHECV079
 
      ** Validate  Credit Card Date 4
 
      /COPY WNCPYSRC,SDCHECV080
     C                   EVAL      DDCANX = DDCAN4
     C                   EVAL      DDCAIX = DDCAI4
     C                   EVAL      DDCAEX = DDCAE4
     C                   EVAL      FldNme1= 'DDCAI4   '
     C                   EVAL      FldNme2= 'DDCAE4   '
     C                   EVAL      DDCAIXOK = 'Y'
     C                   EVAL      DDCAEXOK = 'Y'
     C                   EXSR      VCADTXSR
     C                   EVAL      CCCAI4 = CCCAIX
     C                   EVAL      CCCAE4 = CCCAEX
      /COPY WNCPYSRC,SDCHECV081
 
      ** Validate  Credit Card Date 5
 
      /COPY WNCPYSRC,SDCHECV082
     C                   EVAL      DDCANX = DDCAN5
     C                   EVAL      DDCAIX = DDCAI5
     C                   EVAL      DDCAEX = DDCAE5
     C                   EVAL      FldNme1= 'DDCAI5   '
     C                   EVAL      FldNme2= 'DDCAE5   '
     C                   EVAL      DDCAIXOK = 'Y'
     C                   EVAL      DDCAEXOK = 'Y'
     C                   EXSR      VCADTXSR
     C                   EVAL      CCCAI5 = CCCAIX
     C                   EVAL      CCCAE5 = CCCAEX
      /COPY WNCPYSRC,SDCHECV083
 
     C                   RETURN
 
      ** Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SDCHECV084
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * VCACXSR - Validate Cheque Card Number                         *
      *                                                               *
      *****************************************************************
      *
     C     VCACXSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Cheque Card Number
 
     C                   CALLB     'SDVCAC'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Cheque Card
 
     C                   PARM                    DDCACX
 
      ** Issued Date
 
     C                   PARM                    DDDISX
 
      ** Expiry Date
 
     C                   PARM                    DDDREX
 
      ** Field Name
 
     C                   PARM                    FldName
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Cheque Card - OK
 
     C                   PARM                    DDCACXOK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   IF        DDCACXOK = 'N'
     C                   SELECT
     C                   WHEN      FldName = 'DDCAC1   '
     C                   EVAL      DDCAC1OK = 'N'
     C                   WHEN      FldName = 'DDCAC2   '
     C                   EVAL      DDCAC2OK = 'N'
     C                   WHEN      FldName = 'DDCAC3   '
     C                   EVAL      DDCAC3OK = 'N'
     C                   WHEN      FldName = 'DDCAC4   '
     C                   EVAL      DDCAC4OK = 'N'
     C                   WHEN      FldName = 'DDCAC5   '
     C                   EVAL      DDCAC5OK = 'N'
     C                   ENDSL
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  VCCDTXSR - Validate Cheque Card Dates                        *
      *                                                               *
      *****************************************************************
 
     C     VCCDTXSR      BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Cheque Card Dates
 
     C                   CALLB     'SDVCCDT'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Cheque Card
 
     C                   PARM                    DDCACX
 
      ** Issued Date
 
     C                   PARM                    DDDISX
 
      ** Expiry Date
 
     C                   PARM                    DDDREX
 
      ** Field Name 1
 
     C                   PARM                    FldNme1
 
      ** Field Name 2
 
     C                   PARM                    FldNme2
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Issued Date - OK
 
     C                   PARM                    DDDISXOK
 
      ** Expiry Date - OK
 
     C                   PARM                    DDDREXOK
 
      ** Issued Date
 
     C                   PARM      *Zeros        CCDISX
 
      ** Expiry Date
 
     C                   PARM      *Zeros        CCDREX
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
     C                   IF        DDDISXOK = 'N'
     C                   SELECT
     C                   WHEN      FldNme1 = 'DDDIS1   '
     C                   EVAL      DDDIS1OK = 'N'
     C                   WHEN      FldNme1 = 'DDDIS2   '
     C                   EVAL      DDDIS2OK = 'N'
     C                   WHEN      FldNme1 = 'DDDIS3   '
     C                   EVAL      DDDIS3OK = 'N'
     C                   WHEN      FldNme1 = 'DDDIS4   '
     C                   EVAL      DDDIS4OK = 'N'
     C                   WHEN      FldNme1 = 'DDDIS5   '
     C                   EVAL      DDDIS5OK = 'N'
     C                   ENDSL
     C                   ENDIF
 
     C                   IF        DDDREXOK = 'N'
     C                   SELECT
     C                   WHEN      FldNme2 = 'DDDRE1   '
     C                   EVAL      DDDRE1OK = 'N'
     C                   WHEN      FldNme2 = 'DDDRE2   '
     C                   EVAL      DDDRE2OK = 'N'
     C                   WHEN      FldNme2 = 'DDDRE3   '
     C                   EVAL      DDDRE3OK = 'N'
     C                   WHEN      FldNme2 = 'DDDRE4   '
     C                   EVAL      DDDRE4OK = 'N'
     C                   WHEN      FldNme2 = 'DDDRE5   '
     C                   EVAL      DDDRE5OK = 'N'
     C                   ENDSL
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  VCQFXSR - Validate Cheque Numbers                            *
      *                                                               *
      *****************************************************************
      *
     C     VCQFXSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Cheque Card Numbers
 
     C                   CALLB     'SDVCQF'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Cheque Number From
 
     C                   PARM                    DDCQFX
 
      ** Cheque Number To
 
     C                   PARM                    DDCQTX
 
      ** Quantity
 
     C                   PARM                    DDCQQX
 
      ** Cheque Number Issue Date
 
     C                   PARM                    DDCQIX
 
      ** Field Name 1
 
     C                   PARM                    FldNme1
 
      ** Field Name 2
 
     C                   PARM                    FldNme2
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Cheque Number from - OK
 
     C                   PARM                    DDCQFXOK
 
      ** Cheque Number to - OK
 
     C                   PARM                    DDCQTXOK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
     C                   IF        DDCQFXOK = 'N'
     C                   SELECT
     C                   WHEN      FldNme1 = 'DDCQF1   '
     C                   EVAL      DDCQF1OK = 'N'
     C                   WHEN      FldNme1 = 'DDCQF2   '
     C                   EVAL      DDCQF2OK = 'N'
     C                   WHEN      FldNme1 = 'DDCQF3   '
     C                   EVAL      DDCQF3OK = 'N'
     C                   WHEN      FldNme1 = 'DDCQF4   '
     C                   EVAL      DDCQF4OK = 'N'
     C                   WHEN      FldNme1 = 'DDCQF5   '
     C                   EVAL      DDCQF5OK = 'N'
     C                   ENDSL
     C                   ENDIF
 
     C                   IF        DDCQTXOK = 'N'
     C                   SELECT
     C                   WHEN      FldNme2 = 'DDCQT1   '
     C                   EVAL      DDCQT1OK = 'N'
     C                   WHEN      FldNme2 = 'DDCQT2   '
     C                   EVAL      DDCQT2OK = 'N'
     C                   WHEN      FldNme2 = 'DDCQT3   '
     C                   EVAL      DDCQT3OK = 'N'
     C                   WHEN      FldNme2 = 'DDCQT4   '
     C                   EVAL      DDCQT4OK = 'N'
     C                   WHEN      FldNme2 = 'DDCQF5   '
     C                   EVAL      DDCQT5OK = 'N'
     C                   ENDSL
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  VCQQXSR - Validate Cheque Numbers Quantity                   *
      *                                                               *
      *****************************************************************
 
     C     VCQQXSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Cheque Card Numbers Quantity
 
     C                   CALLB     'SDVCQQ'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Cheque Number From
 
     C                   PARM                    DDCQFX
 
      ** Cheque Number To
 
     C                   PARM                    DDCQTX
 
      ** Quantity
 
     C                   PARM                    DDCQQX
 
      ** Field Name
 
     C                   PARM                    FldName
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Quantity- OK
 
     C                   PARM                    DDCQQXOK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   IF        DDCQQXOK = 'N'
     C                   SELECT
     C                   WHEN      FldName = 'DDCQQ1   '
     C                   EVAL      DDCQQ1OK = 'N'
     C                   WHEN      FldName = 'DDCQQ2   '
     C                   EVAL      DDCQQ2OK = 'N'
     C                   WHEN      FldName = 'DDCQQ3   '
     C                   EVAL      DDCQQ3OK = 'N'
     C                   WHEN      FldName = 'DDCQQ4   '
     C                   EVAL      DDCQQ4OK = 'N'
     C                   WHEN      FldName = 'DDCQQ5   '
     C                   EVAL      DDCQQ5OK = 'N'
     C                   ENDSL
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  VCQIXSR - Validate Cheque Numbers Issue Dates                *
      *                                                               *
      *****************************************************************
 
     C     VCQIXSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Date that Cheques were issued
 
     C                   CALLB     'SDVCQI'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Cheque Number From
 
     C                   PARM                    DDCQFX
 
      ** Cheque Number To
 
     C                   PARM                    DDCQTX
 
      ** Issue Date
 
     C                   PARM                    DDCQIX
 
      ** Field Name
 
     C                   PARM                    FldName
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Issue Date- OK
 
     C                   PARM                    DDCQIXOK
 
      ** Issue Date
 
     C                   PARM      *Zeros        CCCQIX
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   IF        DDCQIXOK = 'N'
     C                   SELECT
     C                   WHEN      FldName = 'DDCQI1   '
     C                   EVAL      DDCQI1OK = 'N'
     C                   WHEN      FldName = 'DDCQI2   '
     C                   EVAL      DDCQI2OK = 'N'
     C                   WHEN      FldName = 'DDCQI3   '
     C                   EVAL      DDCQI3OK = 'N'
     C                   WHEN      FldName = 'DDCQI4   '
     C                   EVAL      DDCQI4OK = 'N'
     C                   WHEN      FldName = 'DDCQI5   '
     C                   EVAL      DDCQI5OK = 'N'
     C                   ENDSL
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  VCANXSR - Validate Credit Card                               *
      *                                                               *
      *****************************************************************
 
     C     VCANXSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Credit Card 1
 
     C                   CALLB     'SDVCAN'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Credit Card
 
     C                   PARM                    DDCANX
 
      ** Credit Card Text
 
     C                   PARM                    DDCALX
 
      ** Issued Date
 
     C                   PARM                    DDCAIX
 
      ** Expiry Date
 
     C                   PARM                    DDCAEX
 
      ** Field Name
 
     C                   PARM                    FldName
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Credit Card - OK
 
     C                   PARM                    DDCANXOK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   IF        DDCANXOK = 'N'
     C                   SELECT
     C                   WHEN      FldName = 'DDCAN1   '
     C                   EVAL      DDCAN1OK = 'N'
     C                   WHEN      FldName = 'DDCAN2   '
     C                   EVAL      DDCAN2OK = 'N'
     C                   WHEN      FldName = 'DDCAN3   '
     C                   EVAL      DDCAN3OK = 'N'
     C                   WHEN      FldName = 'DDCAN4   '
     C                   EVAL      DDCAN4OK = 'N'
     C                   WHEN      FldName = 'DDCAN5   '
     C                   EVAL      DDCAN5OK = 'N'
     C                   ENDSL
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  VCALXSR - Validate Credit Card Text                          *
      *                                                               *
      *****************************************************************
 
     C     VCALXSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Credit Card Text
 
     C                   CALLB     'SDVCAL'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Credit Card
 
     C                   PARM                    DDCANX
 
      ** Credit Card Text
 
     C                   PARM                    DDCALX
 
      ** Field Name
 
     C                   PARM                    FldName
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Credit Card Text- OK
 
     C                   PARM                    DDCALXOK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
     C                   IF        DDCALXOK = 'N'
     C                   SELECT
     C                   WHEN      FldName = 'DDCAL1   '
     C                   EVAL      DDCAL1OK = 'N'
     C                   WHEN      FldName = 'DDCAL2   '
     C                   EVAL      DDCAL2OK = 'N'
     C                   WHEN      FldName = 'DDCAL3   '
     C                   EVAL      DDCAL3OK = 'N'
     C                   WHEN      FldName = 'DDCAL4   '
     C                   EVAL      DDCAL4OK = 'N'
     C                   WHEN      FldName = 'DDCAL5   '
     C                   EVAL      DDCAL5OK = 'N'
     C                   ENDSL
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  VCADTXSR - Validate Credit Card Dates                        *
      *                                                               *
      *****************************************************************
 
     C     VCADTXSR      BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Credit Card Dates 1
 
     C                   CALLB     'SDVCADT'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Credit Card
 
     C                   PARM                    DDCANX
 
      ** Issued Date
 
     C                   PARM                    DDCAIX
 
      ** Expiry Date
 
     C                   PARM                    DDCAEX
 
      ** Field Name 1
 
     C                   PARM                    FldNme1
 
      ** Field Name 2
 
     C                   PARM                    FldNme2
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Issued Date - OK
 
     C                   PARM                    DDCAIXOK
 
      ** Expiry Date - OK
 
     C                   PARM                    DDCAEXOK
 
      ** Issued Date
 
     C                   PARM      *Zeros        CCCAIX
 
      ** Expiry Date
 
     C                   PARM      *Zeros        CCCAEX
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
     C                   IF        DDCAIXOK = 'N'
     C                   SELECT
     C                   WHEN      FldNme1 = 'DDCAI1   '
     C                   EVAL      DDCAI1OK = 'N'
     C                   WHEN      FldNme1 = 'DDCAI2   '
     C                   EVAL      DDCAI2OK = 'N'
     C                   WHEN      FldNme1 = 'DDCAI3   '
     C                   EVAL      DDCAI3OK = 'N'
     C                   WHEN      FldNme1 = 'DDCAI4   '
     C                   EVAL      DDCAI4OK = 'N'
     C                   WHEN      FldNme1 = 'DDCAI5   '
     C                   EVAL      DDCAI5OK = 'N'
     C                   ENDSL
     C                   ENDIF
 
     C                   IF        DDCAEXOK = 'N'
     C                   SELECT
     C                   WHEN      FldNme2 = 'DDCAE1   '
     C                   EVAL      DDCAE1OK = 'N'
     C                   WHEN      FldNme2 = 'DDCAE2   '
     C                   EVAL      DDCAE2OK = 'N'
     C                   WHEN      FldNme2 = 'DDCAE3   '
     C                   EVAL      DDCAE3OK = 'N'
     C                   WHEN      FldNme2 = 'DDCAE4   '
     C                   EVAL      DDCAE4OK = 'N'
     C                   WHEN      FldNme2 = 'DDCAE5   '
     C                   EVAL      DDCAE5OK = 'N'
     C                   ENDSL
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * RESETERRS - Reset error information that is received back     *
      *    from each validation module.                               *
      *                                                               *
      *****************************************************************
     C     RESETERRS     BEGSR
 
     C                   EVAL      RetCodeOut = *Blanks
 
      ** Reset error & warning fields/message IDs/message data (arrays)
 
     C                   EVAL      FldNamXAr = *BLANK
     C                   EVAL      MsgIDXAr  = *BLANK
     C                   EVAL      MsgDtaXAr = *BLANK
     C                   EVAL      WFldNmXAr = *BLANK
     C                   EVAL      WMsgIDXAr = *BLANK
     C                   EVAL      WMsgDtXAr = *BLANK
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * UPDATERRS - Update error information with that received back  *
      *    from each validation module.                               *
      *                                                               *
      *****************************************************************
     C     UPDATERRS     BEGSR
 
      ** Update error fields/message IDs/message data (arrays)
 
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C                   IF        *IN99 = *ON
     C                   MOVEA     FldNamXAr     FlDNameArr(I)
     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
     C                   ENDIF
 
      ** Set Error Index
 
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     I             SUB       1             Idx
 
      ** Update warning fields/message IDs/message data (arrays)
 
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C                   IF        *IN99 = *ON
     C                   MOVEA     WFldNmXAr     WFldNamArr(I)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(I)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(I)
     C                   ENDIF
 
      ** Set Warning Index
 
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     I             SUB       1             WIdx
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
 
      ** Inputs
      ** Response mode
     C                   PARM                    RespMode
 
      ** Cheques and Cards details Details
 
     C                   PARM                    TrnDets
 
 
      ** Cheques and Cards details OK inds
     C                   PARM                    OKTrnDets
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM                    Idx
 
      ** Warning fields/message IDs/message data (arrays) from/to
      ** caller
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      **  Array index (3P0) from/to caller
 
     C                   PARM                    WIdx
 
      ** Valid Cheques and Cards details layout (DS) from/to caller
 
     C                   PARM                    ValidCHEC
 
      ** Access Bank Details
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  =  900
     C                   EVAL      DBKEY  = @OPTN
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WKDFIN = BJDFIN
     C                   EVAL      WKRDNB = BJRDNB
     C                   EVAL      WKCYCD = BJCYCD
     C                   ENDIF
      *
      **------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **----------------------------------------------------------------
 
      ** Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SDCHECV085
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      **----------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **----------------------------------------------------------------
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2007
