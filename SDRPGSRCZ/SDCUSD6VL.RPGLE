     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Customer Details Base Rate Tax Validation')
      *****************************************************************
      *                                                               *
      *  Midas - Customer Details Module.                             *
      *                                                               *
      *  SDCUSD6VL - Customer Base Rate Tax Validation               *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD055446           Date 04Apr20               *
      *  Prev Amend No. MD040876           Date 13Sep16               *
      *                 MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CRE007             Date 01Mar01               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP034             Date 22Jun99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      * MD055446 - There are parties and fields missing from the BRT  *	
      *            details tab in Customer Input plus date of birth   *	
      *            issues.                                            *	
      *          - format DDXDOB to DDMMYYYY format before SDVPADT.   *
      *  MD040876 - CRS MQ (Recompile)                                *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CRE007 - Base Rate Tax 2001                                  *
      *  CAP034 - Conversion of SD inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      * Interest Payment File 8
     FINTPSL8   IF   E           K DISK    RENAME(INTPSDDF:INTPSLF8)
     F                                     PREFIX(C_)

      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,SDCUDBV001

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **--------------------------------------------------------------------------------------------

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


     D                 DS
     D TDATE                   1      6
     D TDAY                    1      2
     D TMONTH                  3      4
     D TYEAR                   5      6

     D                 DS
     D  DATE                   1      6
     D  DAY                    1      2  0
     D  MONTH                  3      4  0
     D  YEAR                   5      6  0


      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Customer Base Rate Tax in screen format
     D CuBrt         E DS                  EXTNAME(SDCUBRPD)

      ** Customer Base Rate Tax OK indicators
     D OKCuBrt       E DS                  EXTNAME(SDECUBRPD)

      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)

      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)


     D ValidBrt      E DS                  EXTNAME(SDVCUBRPD)
      * Valid Base Rate Tax participant details layout

      ** External DS for SAR details                                                          CSC011
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC011
                                                                                              CSC011
      ** 24X7 status data area                                                                CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
                                                                                              CSC011
      ** SD data area                                                                         CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
                                                                                              CSC011
      ** ** Customer Base Rate Tax in screen format (Century)                               MD055446
     D CuBrtCent       DS                                                                   MD055446
     D  DDD1DOB                       2S 0                                                  MD055446
     D  DDD2DOB                       2S 0                                                  MD055446
     D  DDD3DOB                       2S 0                                                  MD055446
     D  DDD4DOB                       2S 0                                                  MD055446
     D  DDD5DOB                       2S 0                                                  MD055446
      ** Valid Customer BRT (Century) details layout                                        MD055446
     D ValidBrtCent    DS                                                                   MD055446
     D  BR1DBC                        2S 0                                                  MD055446
     D  BR2DBC                        2S 0                                                  MD055446
     D  BR3DBC                        2S 0                                                  MD055446
     D  BR4DBC                        2S 0                                                  MD055446
     D  BR5DBC                        2S 0                                                  MD055446
     D                 DS                                                                   MD055446
     D  DDXDOBDD                      2A                                                    MD055446
     D  DDXDOBMM                      2A                                                    MD055446
     D  DDXDOBYY                      2A                                                    MD055446
     D  DDXDOB                 1      6A
     D                 DS                                                                   MD055446
     D  DDXDOBCDD                     2A                                                    MD055446
     D  DDXDOBCMM                     2A                                                    MD055446
     D  DDXDOBCCC                     2A                                                    MD055446
     D  DDXDOBCYY                     2A                                                    MD055446
     D  DDXDOBCENT             1      8A
      ** Changed Party Names Array
     D ChgNamArr       S              1    DIM(5)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0

     D CSC011          S              1A                                                      CSC011
     D PRtCd           S              7A                                                      CSC011
     D POptn           S              7A                                                      CSC011
     D PSard           S              6A                                                      CSC011
     D WRunDay         S                   LIKE(BJRDNB)                                       CSC011
                                                                                              CSC011
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SDCUDBV002

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+


      ** Pass fields not requiring validation to BrtFilFmt fields
      *
      ** Participant 1 Title
      ** Participant 1 Initials
      ** Participant 1 National Insurance Number
      ** Participant 1 Post Code 1
     C                   MOVE      DD1TTL        BR1TIT
     C                   MOVE      DD1INI        BR1INI
     C                   MOVE      DD1NIN        BR1NIN
     C                   MOVE      DD1PC1        BR1PC1
      ** Participant 2 Title
      ** Participant 2 Initials
      ** Participant 2 National Insurance Number
      ** Participant 2 Post Code 1
     C                   MOVE      DD2TTL        BR2TIT
     C                   MOVE      DD2INI        BR2INI
     C                   MOVE      DD2NIN        BR2NIN
     C                   MOVE      DD2PC1        BR2PC1
      ** Participant 3 Title
      ** Participant 3 Initials
      ** Participant 3 National Insurance Number
      ** Participant 3 Post Code 1
     C                   MOVE      DD3TTL        BR3TIT
     C                   MOVE      DD3INI        BR3INI
     C                   MOVE      DD3NIN        BR3NIN
     C                   MOVE      DD3PC1        BR3PC1
      ** Participant 4 Title
      ** Participant 4 Initials
      ** Participant 4 National Insurance Number
      ** Participant 4 Post Code 1
     C                   MOVE      DD4TTL        BR4TIT
     C                   MOVE      DD4INI        BR4INI
     C                   MOVE      DD4NIN        BR4NIN
     C                   MOVE      DD4PC1        BR4PC1
      ** Participant 5 Title
      ** Participant 5 Initials
      ** Participant 5 National Insurance Number
      ** Participant 5 Post Code 1
     C                   MOVE      DD5TTL        BR5TIT
     C                   MOVE      DD5INI        BR5INI
     C                   MOVE      DD5NIN        BR5NIN
     C                   MOVE      DD5PC1        BR5PC1
      *
     C                   MOVE      DDACTN        BRCHTP
      *
      /COPY WNCPYSRC,SDCUDBV003

      * Call Validation Modules in Sequence


      ** Validate Account Holder Type Parties (Cross Validation)
      *
      ** NOTE - LIMITATION
      *  Deletion of participants through API server message limitation
      *  Deletion can result in incorrect participant sequence numbers
      *  being written to files.
      *  Deletion of participants through Screen Input (SDCUSDSIN) is OK
      ** END OF NOTE
      *
      /COPY WNCPYSRC,SDCUDBV004
     C                   EXSR      VCAHLT
      /COPY WNCPYSRC,SDCUDBV005
      *
      ** Validate BRT Tax Indicator
      *
      /COPY WNCPYSRC,SDCUDBV006
     C                   EXSR      VCBTAX
      /COPY WNCPYSRC,SDCUDBV007
      *
      ** Validate Party 1 Name
      *
      /COPY WNCPYSRC,SDCUDBV008
     C                   EVAL      DDXNAM = DD1NAM
     C                   EVAL      ErrFldNam = 'DD1NAM'
     C                   EVAL      NameNum = '1'
     C                   EVAL      DDXNAMOK = 'Y'
     C                   EXSR      VCXNAM
     C                   EVAL      BR1NAM = DDXNAM
      /COPY WNCPYSRC,SDCUDBV009


      ** Validate Party 1 Address Line 1
      *
      /COPY WNCPYSRC,SDCUDBV010
     C                   EVAL      DDXNAM = DD1NAM
     C                   EVAL      ErrFldNam = 'DD1AD1'
     C                   EVAL      DDXAD1 = DD1AD1
     C                   EVAL      DDXAD1OK = 'Y'
     C                   EXSR      VCXAD1
     C                   EVAL      BR1AD1 = DDXAD1
      /COPY WNCPYSRC,SDCUDBV011
      *

      ** Validate Party 1 Address Line 2
      *
      /COPY WNCPYSRC,SDCUDBV012
     C                   EVAL      DDXNAM = DD1NAM
     C                   EVAL      DDXAD1 = DD1AD1
     C                   EVAL      DDXAD2 = DD1AD2
     C                   EVAL      ErrFldNam = 'DD1AD2'
     C                   EVAL      DDXAD2OK = 'Y'
     C                   EXSR      VCXAD2
     C                   EVAL      BR1AD2 = DDXAD2
      /COPY WNCPYSRC,SDCUDBV013
      *

      ** Validate Party 1 Address Line 3
      *
      /COPY WNCPYSRC,SDCUDBV014
     C                   EVAL      DDXNAM = DD1NAM
      ** Applied fix of 260405A                                                             MD055446
     C**********         EVAL      DDXAD1 = DD1AD2                                          MD055446
     C**********         EVAL      DDXAD2 = DD1AD3                                          MD055446
     C                   EVAL      DDXAD2 = DD1AD2                                          MD055446
     C                   EVAL      DDXAD3 = DD1AD3                                          MD055446
     C                   EVAL      ErrFldNam = 'DD1AD3'
     C                   EVAL      DDXAD3OK = 'Y'
     C                   EXSR      VCXAD3
     C                   EVAL      BR1AD3 = DDXAD3
      /COPY WNCPYSRC,SDCUDBV015
      *

      ** Validate Party 1 Postcode 2
      *
      /COPY WNCPYSRC,SDCUDBV016
     C                   EVAL      DDXNAM = DD1NAM
     C                   EVAL      DDXPC1 = DD1PC1
     C                   EVAL      DDXPC2 = DD1PC2
     C                   EVAL      ErrFldNam = 'DD1PC2'
     C                   EVAL      DDXPC2OK = 'Y'
     C                   EXSR      VCXPC2
     C                   EVAL      BR1PC2 = DDXPC2
      /COPY WNCPYSRC,SDCUDBV017
      *

      ** Validate Party 1 BRT Liable
      *
      /COPY WNCPYSRC,SDCUDBV018
     C                   EVAL      DDXNAM = DD1NAM
     C                   EVAL      DDXBRT = DD1BRT
     C                   EVAL      ErrFldNam = 'DD1BRT'
     C                   EVAL      DDXBRTOK = 'Y'
     C                   EXSR      VCXBRT
     C                   EVAL      BR1BRL = DDXBRT
      /COPY WNCPYSRC,SDCUDBV019
      *

      ** Validate Party 1 Date of Birth
      *
      /COPY WNCPYSRC,SDCUDBV020
     C                   EVAL      DDXNAM = DD1NAM
     C                   EVAL      DDXDOB = DD1DOB
     C                   EXSR      CVTDATE6ATO8A                                            MD055446
     C                   MOVE      DDD1DOB       DDXDOBCCC                                  MD055446
     C                   EVAL      ErrFldNam = 'DD1DOB'
     C                   EVAL      DDXDOBOK = 'Y'
     C                   EXSR      VCXDOB
     C**********         EVAL      BR1DOB = BRXDOB                                          MD055446
     C                   MOVE      DD1DOB        BR1DOB                                     MD055446
     C                   EVAL      BR1DBC = DDD1DOB                                         MD055446
      /COPY WNCPYSRC,SDCUDBV021
      *
      *
      ** Validate Party 2 Name
      *
      /COPY WNCPYSRC,SDCUDBV022
     C                   EVAL      DDXNAM = DD2NAM
     C                   EVAL      ErrFldNam = 'DD2NAM'
     C                   EVAL      NameNum = '2'
     C                   EVAL      DDXNAMOK = 'Y'
     C                   EXSR      VCXNAM
     C                   EVAL      BR2NAM = DDXNAM
      /COPY WNCPYSRC,SDCUDBV023
      *
      *
      ** Validate Party 2 Address Line 1
      *
      /COPY WNCPYSRC,SDCUDBV024
     C                   EVAL      DDXNAM = DD2NAM
     C                   EVAL      ErrFldNam = 'DD2AD1'
     C                   EVAL      DDXAD1 = DD2AD1
     C                   EVAL      DDXAD1OK = 'Y'
     C                   EXSR      VCXAD1
     C                   EVAL      BR2AD1 = DDXAD1
      /COPY WNCPYSRC,SDCUDBV025
      *
      *
      ** Validate Party 2 Address Line 2
      *
      /COPY WNCPYSRC,SDCUDBV026
     C                   EVAL      DDXNAM = DD2NAM
     C                   EVAL      DDXAD1 = DD2AD1
     C                   EVAL      DDXAD2 = DD2AD2
     C                   EVAL      ErrFldNam = 'DD2AD2'
     C                   EVAL      DDXAD2OK = 'Y'
     C                   EXSR      VCXAD2
     C                   EVAL      BR2AD2 = DDXAD2
      /COPY WNCPYSRC,SDCUDBV027
      *
      *
      ** Validate Party 2 Address Line 3
      *
      /COPY WNCPYSRC,SDCUDBV028
     C                   EVAL      DDXNAM = DD2NAM
     C                   EVAL      DDXAD2 = DD2AD2
     C                   EVAL      DDXAD3 = DD2AD3
     C                   EVAL      ErrFldNam = 'DD2AD3'
     C                   EVAL      DDXAD3OK = 'Y'
     C                   EXSR      VCXAD3
     C                   EVAL      BR2AD3 = DDXAD3
      /COPY WNCPYSRC,SDCUDBV029
      *
      *
      ** Validate Party 2 Postcode 2
      *
      /COPY WNCPYSRC,SDCUDBV030
     C                   EVAL      DDXNAM = DD2NAM
     C                   EVAL      DDXPC1 = DD2PC1
     C                   EVAL      DDXPC2 = DD2PC2
     C                   EVAL      DDXPC2OK = 'Y'
     C                   EVAL      ErrFldNam = 'DD2PC2'
     C                   EXSR      VCXPC2
     C                   EVAL      BR2PC2 = DDXPC2
      /COPY WNCPYSRC,SDCUDBV031
      *
      *
      ** Validate Party 2 BRT Liable
      *
      /COPY WNCPYSRC,SDCUDBV032
     C                   EVAL      DDXNAM = DD2NAM
     C                   EVAL      DDXBRT = DD2BRT
     C                   EVAL      ErrFldNam = 'DD2BRT'
     C                   EVAL      DDXBRTOK = 'Y'
     C                   EXSR      VCXBRT
     C                   EVAL      BR2BRL = DDXBRT
      /COPY WNCPYSRC,SDCUDBV033
      *
      *
      ** Validate Party 2 Date of Birth
      *
      /COPY WNCPYSRC,SDCUDBV034
     C                   EVAL      DDXNAM = DD2NAM
     C                   EVAL      DDXDOB = DD2DOB
     C                   EXSR      CVTDATE6ATO8A                                            MD055446
     C                   MOVE      DDD2DOB       DDXDOBCCC                                  MD055446
     C                   EVAL      ErrFldNam = 'DD2DOB'
     C                   EVAL      DDXDOBOK = 'Y'
     C                   EXSR      VCXDOB
     C**********         EVAL      BR2DOB = BRXDOB                                          MD055446
     C                   MOVE      DD2DOB        BR2DOB                                     MD055446
     C                   EVAL      BR2DBC = DDD2DOB                                         MD055446
      /COPY WNCPYSRC,SDCUDBV035
      *
      *
      ** Validate Party 3 Name
      *
      /COPY WNCPYSRC,SDCUDBV036
     C                   EVAL      DDXNAM = DD3NAM
     C                   EVAL      ErrFldNam = 'DD3NAM'
     C                   EVAL      NameNum = '3'
     C                   EVAL      DDXNAMOK = 'Y'
     C                   EXSR      VCXNAM
     C                   EVAL      BR3NAM = DDXNAM
      /COPY WNCPYSRC,SDCUDBV037
      *
      *
      ** Validate Party 3 Address Line 1
      *
      /COPY WNCPYSRC,SDCUDBV038
     C                   EVAL      DDXNAM = DD3NAM
     C                   EVAL      ErrFldNam = 'DD3AD1'
     C                   EVAL      DDXAD1 = DD3AD1
     C                   EVAL      DDXAD1OK = 'Y'
     C                   EXSR      VCXAD1
     C                   EVAL      BR3AD1 = DDXAD1
      /COPY WNCPYSRC,SDCUDBV039
      *
      *
      ** Validate Party 3 Address Line 2
      *
      /COPY WNCPYSRC,SDCUDBV040
     C                   EVAL      DDXNAM = DD3NAM
     C                   EVAL      DDXAD1 = DD3AD1
     C                   EVAL      DDXAD2 = DD3AD2
     C                   EVAL      ErrFldNam = 'DD3AD2'
     C                   EVAL      DDXAD2OK = 'Y'
     C                   EXSR      VCXAD2
     C                   EVAL      BR3AD2 = DDXAD2
      /COPY WNCPYSRC,SDCUDBV041
      *
      *
      ** Validate Party 3 Address Line 3
      *
      /COPY WNCPYSRC,SDCUDBV042
     C                   EVAL      DDXNAM = DD3NAM
     C                   EVAL      DDXAD2 = DD3AD2
     C                   EVAL      DDXAD3 = DD3AD3
     C                   EVAL      ErrFldNam = 'DD3AD3'
     C                   EVAL      DDXAD3OK = 'Y'
     C                   EXSR      VCXAD3
     C                   EVAL      BR3AD3 = DDXAD3
      /COPY WNCPYSRC,SDCUDBV043
      *
      *
      ** Validate Party 3 Postcode 2
      *
      /COPY WNCPYSRC,SDCUDBV044
     C                   EVAL      DDXNAM = DD3NAM
     C                   EVAL      DDXPC1 = DD3PC1
     C                   EVAL      DDXPC2 = DD3PC2
     C                   EVAL      DDXPC2OK = 'Y'
     C                   EVAL      ErrFldNam = 'DD3PC2'
     C                   EXSR      VCXPC2
     C                   EVAL      BR3PC2 = DDXPC2
      /COPY WNCPYSRC,SDCUDBV045
      *
      *
      ** Validate Party 3 BRT Liable
      *
      /COPY WNCPYSRC,SDCUDBV046
     C                   EVAL      DDXNAM = DD3NAM
     C                   EVAL      DDXBRT = DD3BRT
     C                   EVAL      ErrFldNam = 'DD3BRT'
     C                   EVAL      DDXBRTOK = 'Y'
     C                   EXSR      VCXBRT
     C                   EVAL      BR3BRL = DDXBRT
      /COPY WNCPYSRC,SDCUDBV047
      *
      *
      ** Validate Party 3 Date of Birth
      *
      /COPY WNCPYSRC,SDCUDBV048
     C                   EVAL      DDXNAM = DD3NAM
     C                   EVAL      DDXDOB = DD3DOB
     C                   EXSR      CVTDATE6ATO8A                                            MD055446
     C                   MOVE      DDD3DOB       DDXDOBCCC                                  MD055446
     C                   EVAL      ErrFldNam = 'DD3DOB'
     C                   EVAL      DDXDOBOK = 'Y'
     C                   EXSR      VCXDOB
     C**********         EVAL      BR3DOB = BRXDOB                                          MD055446
     C                   MOVE      DD3DOB        BR3DOB                                     MD055446
     C                   EVAL      BR3DBC = DDD3DOB                                         MD055446
      /COPY WNCPYSRC,SDCUDBV049
      *
      *
      ** Validate Party 4 Name
      *
      /COPY WNCPYSRC,SDCUDBV050
     C                   EVAL      DDXNAM = DD4NAM
     C                   EVAL      ErrFldNam = 'DD4NAM'
     C                   EVAL      NameNum = '4'
     C                   EVAL      DDXNAMOK = 'Y'
     C                   EXSR      VCXNAM
     C                   EVAL      BR4NAM = DDXNAM
      /COPY WNCPYSRC,SDCUDBV051
      *
      *
      ** Validate Party 4 Address Line 1
      *
      /COPY WNCPYSRC,SDCUDBV052
     C                   EVAL      DDXNAM = DD4NAM
     C                   EVAL      ErrFldNam = 'DD4AD1'
     C                   EVAL      DDXAD1 = DD4AD1
     C                   EVAL      DDXAD1OK = 'Y'
     C                   EXSR      VCXAD1
     C                   EVAL      BR4AD1 = DDXAD1
      /COPY WNCPYSRC,SDCUDBV053
      *
      *
      ** Validate Party 4 Address Line 2
      *
      /COPY WNCPYSRC,SDCUDBV054
     C                   EVAL      DDXNAM = DD4NAM
     C                   EVAL      DDXAD1 = DD4AD1
     C                   EVAL      DDXAD2 = DD4AD2
     C                   EVAL      ErrFldNam = 'DD4AD2'
     C                   EVAL      DDXAD2OK = 'Y'
     C                   EXSR      VCXAD2
     C                   EVAL      BR4AD2 = DDXAD2
      /COPY WNCPYSRC,SDCUDBV055
      *
      *
      ** Validate Party 4 Address Line 3
      *
      /COPY WNCPYSRC,SDCUDBV056
     C                   EVAL      DDXNAM = DD4NAM
     C                   EVAL      DDXAD2 = DD4AD2
     C                   EVAL      DDXAD3 = DD4AD3
     C                   EVAL      ErrFldNam = 'DD4AD3'
     C                   EVAL      DDXAD3OK = 'Y'
     C                   EXSR      VCXAD3
     C                   EVAL      BR4AD3 = DDXAD3
      /COPY WNCPYSRC,SDCUDBV057
      *
      *
      ** Validate Party 4 Postcode 2
      *
      /COPY WNCPYSRC,SDCUDBV058
     C                   EVAL      DDXNAM = DD4NAM
     C                   EVAL      DDXPC1 = DD4PC1
     C                   EVAL      DDXPC2 = DD4PC2
     C                   EVAL      DDXPC2OK = 'Y'
     C                   EVAL      ErrFldNam = 'DD4PC2'
     C                   EXSR      VCXPC2
     C                   EVAL      BR4PC2 = DDXPC2
      /COPY WNCPYSRC,SDCUDBV059
      *
      *
      ** Validate Party 4 BRT Liable
      *
      /COPY WNCPYSRC,SDCUDBV060
     C                   EVAL      DDXNAM = DD4NAM
     C                   EVAL      DDXBRT = DD4BRT
     C                   EVAL      ErrFldNam = 'DD4BRT'
     C                   EVAL      DDXBRTOK = 'Y'
     C                   EXSR      VCXBRT
     C                   EVAL      BR4BRL = DDXBRT
      /COPY WNCPYSRC,SDCUDBV061
      *
      *
      ** Validate Party 4 Date of Birth
      *
      /COPY WNCPYSRC,SDCUDBV062
     C                   EVAL      DDXNAM = DD4NAM
     C                   EVAL      DDXDOB = DD4DOB
     C                   EXSR      CVTDATE6ATO8A                                            MD055446
     C                   MOVE      DDD4DOB       DDXDOBCCC                                  MD055446
     C                   EVAL      ErrFldNam = 'DD4DOB'
     C                   EVAL      DDXDOBOK = 'Y'
     C                   EXSR      VCXDOB
     C**********         EVAL      BR4DOB = BRXDOB                                          MD055446
     C                   MOVE      DD4DOB        BR4DOB                                     MD055446
     C                   EVAL      BR4DBC = DDD4DOB                                         MD055446
      /COPY WNCPYSRC,SDCUDBV063
      *
      *
      ** Validate Party 5 Name
      *
      /COPY WNCPYSRC,SDCUDBV064
     C                   EVAL      DDXNAM = DD5NAM
     C                   EVAL      ErrFldNam = 'DD5NAM'
     C                   EVAL      NameNum = '5'
     C                   EVAL      DDXNAMOK = 'Y'
     C                   EXSR      VCXNAM
     C                   EVAL      BR5NAM = DDXNAM
      /COPY WNCPYSRC,SDCUDBV065
      *
      *
      ** Validate Party 5 Address Line 1
      *
      /COPY WNCPYSRC,SDCUDBV066
     C                   EVAL      DDXNAM = DD5NAM
     C                   EVAL      ErrFldNam = 'DD5AD1'
     C                   EVAL      DDXAD1 = DD5AD1
     C                   EVAL      DDXAD1OK = 'Y'
     C                   EXSR      VCXAD1
     C                   EVAL      BR5AD1 = DDXAD1
      /COPY WNCPYSRC,SDCUDBV067
      *
      *
      ** Validate Party 5 Address Line 2
      *
      /COPY WNCPYSRC,SDCUDBV068
     C                   EVAL      DDXNAM = DD5NAM
     C                   EVAL      DDXAD1 = DD5AD1
     C                   EVAL      DDXAD2 = DD5AD2
     C                   EVAL      ErrFldNam = 'DD5AD2'
     C                   EVAL      DDXAD2OK = 'Y'
     C                   EXSR      VCXAD2
     C                   EVAL      BR5AD2 = DDXAD2
      /COPY WNCPYSRC,SDCUDBV069
      *
      *
      ** Validate Party 5 Address Line 3
      *
      /COPY WNCPYSRC,SDCUDBV070
     C                   EVAL      DDXNAM = DD5NAM
     C                   EVAL      DDXAD2 = DD5AD2
     C                   EVAL      DDXAD3 = DD5AD3
     C                   EVAL      ErrFldNam = 'DD5AD3'
     C                   EVAL      DDXAD3OK = 'Y'
     C                   EXSR      VCXAD3
     C                   EVAL      BR5AD3 = DDXAD3
      /COPY WNCPYSRC,SDCUDBV071
      *
      *
      ** Validate Party 5 Postcode 2
      *
      /COPY WNCPYSRC,SDCUDBV072
     C                   EVAL      DDXNAM = DD5NAM
     C                   EVAL      DDXPC1 = DD5PC1
     C                   EVAL      DDXPC2 = DD5PC2
     C                   EVAL      DDXPC2OK = 'Y'
     C                   EVAL      ErrFldNam = 'DD5PC2'
     C                   EXSR      VCXPC2
     C                   EVAL      BR5PC2 = DDXPC2
      /COPY WNCPYSRC,SDCUDBV073
      *
      *
      ** Validate Party 5 BRT Liable
      *
      /COPY WNCPYSRC,SDCUDBV074
     C                   EVAL      DDXNAM = DD5NAM
     C                   EVAL      DDXBRT = DD5BRT
     C                   EVAL      ErrFldNam = 'DD5BRT'
     C                   EVAL      DDXBRTOK = 'Y'
     C                   EXSR      VCXBRT
     C                   EVAL      BR5BRL = DDXBRT
      /COPY WNCPYSRC,SDCUDBV075
      *
      *
      ** Validate Party 5 Date of Birth
      *
      /COPY WNCPYSRC,SDCUDBV076
     C                   EVAL      DDXNAM = DD5NAM
     C                   EVAL      DDXDOB = DD5DOB
     C                   EXSR      CVTDATE6ATO8A                                            MD055446
     C                   MOVE      DDD5DOB       DDXDOBCCC                                  MD055446
     C                   EVAL      ErrFldNam = 'DD5DOB'
     C                   EVAL      DDXDOBOK = 'Y'
     C                   EXSR      VCXDOB
     C**********         EVAL      BR5DOB = BRXDOB                                          MD055446
     C                   MOVE      DD5DOB        BR5DOB                                     MD055446
     C                   EVAL      BR5DBC = DDD5DOB                                         MD055446
      /COPY WNCPYSRC,SDCUDBV077
      *
      *
      ** Check for Name Change among Participants
      *
      /COPY WNCPYSRC,SDCUDBV078
     C                   EXSR      VCNEWP
      /COPY WNCPYSRC,SDCUDBV079
      *
      *
      *
      /COPY WNCPYSRC,SDCUDBV080
     C                   EXSR      VCNSTS
      /COPY WNCPYSRC,SDCUDBV081
      *
      /COPY WNCPYSRC,SDCUDBV082
     C                   EXSR      VCS352
      /COPY WNCPYSRC,SDCUDBV083
      *
     C                   RETURN
      *
      *
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SDCUDBV084

      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Validate Account Holder Type Parties
      *****************************************************************
     C     VCAHLT        BEGSR

      * Reset variables updated by validation

     C                   EXSR      RESETERRS
      *
      ** Validate BRT Tax Indicator
      *
     C                   CALLB     'SDVACTY'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      * Base Rate Tax details
     C                   PARM                    CuBrt
      ** Account Holder Type
     C                   PARM                    DDAHLT
      ** Action Code
     C                   PARM                    DDACTN
      *
      * Valid Base Rate Tax layout (DS) from/to caller
     C                   PARM                    ValidBrt
      *
      *
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Party Name 1 OK
     C                   PARM                    DD1NAMOK          1
      *
      *
      * Update error info with that returned from validation

     C                   EXSR      UPDATERRS
      *
     C     RetCodeOut    IFEQ      'Error'
     C                   RETURN
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Validate BRT Tax Indicator
      *****************************************************************
     C     VCBTAX        BEGSR

      * Reset variables updated by validation

     C                   EXSR      RESETERRS
      *
      ** Validate BRT Tax Indicator
      *
     C                   CALLB     'SDVTXIN01'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Account Holder Type
     C     BR1BRL        PARM                    DDAHLT            1
      ** Party 1 BRT Tax
     C     BR1BRL        PARM                    DD1BRT            1
      ** Party 2 BRT Tax
     C     BR2BRL        PARM                    DD2BRT            1
      ** Party 3 BRT Tax
     C     BR3BRL        PARM                    DD3BRT            1
      ** Party 4 BRT Tax
     C     BR4BRL        PARM                    DD4BRT            1
      ** Party 5 BRT Tax
     C     BR5BRL        PARM                    DD5BRT            1
      ** BRT Tax Indicator
     C     BRTXIN        PARM                    DDTXIN            1
      ** Post 5/4/01 R105                                                                     CRE007
     C     BRPSTR        PARM                    DDPSTR            1                          CRE007
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** BRT Tax Indicator
     C                   PARM                    DDTXINOK          1
     C                   PARM                    DD1BRTOK          1
      ** Post 5/4/01 R105                                                                     CRE007
     C                   PARM                    DDPSTROK          1                          CRE007
      *
      *
      * Update error info with that returned from validation

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Validate Party Name
      *****************************************************************
     C     VCXNAM        BEGSR

      * Reset variables updated by validation

     C                   EXSR      RESETERRS
      *
      ** Validate Party 1 Name
      *
     C                   CALLB     'SDVPANM'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Party  Name
     C                   PARM                    DDXNAM           23
      *
      ** Party  Number
     C                   PARM                    NameNum           1
      *
      ** Error field name
     C                   PARM                    ErrFldNam         6
      *
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Party 1 Name OK Indicator
     C                   PARM                    DDXNAMOK          1
     C                   IF        DDXNAMOK = 'N'
     C                   SELECT
     C                   WHEN      NameNum = '1'
     C                   EVAL      DD1NAMOK = 'N'
     C                   WHEN      NameNum = '2'
     C                   EVAL      DD2NAMOK = 'N'
     C                   WHEN      NameNum = '3'
     C                   EVAL      DD3NAMOK = 'N'
     C                   WHEN      NameNum = '4'
     C                   EVAL      DD4NAMOK = 'N'
     C                   WHEN      NameNum = '5'
     C                   EVAL      DD5NAMOK = 'N'
     C                   ENDSL
     C                   ENDIF
      *
      *
      * Update error info with that returned from validation

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Validate Party Address Line 1
      *****************************************************************
     C     VCXAD1        BEGSR

      * Reset variables updated by validation

     C                   EXSR      RESETERRS
      *
      ** Validate Party Address Line 1
      *
     C                   CALLB     'SDVPAAD01'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Party  Address Line 1
     C                   PARM                    DDXAD1           28
      *
      ** Party Name
     C                   PARM                    DDXNAM
      *
      ** Error Field Name
     C                   PARM                    ErrFldNam
      *
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Party Address Line 1 OK Indicator
     C                   PARM                    DDXAD1OK          1
     C                   IF        DDXAD1OK = 'N'
     C                   SELECT
     C                   WHEN      ErrFldNam = 'DD1AD1'
     C                   EVAL      DD1AD1OK = 'N'
     C                   WHEN      ErrFldNam = 'DD2AD1'
     C                   EVAL      DD2AD1OK = 'N'
     C                   WHEN      ErrFldNam = 'DD3AD1'
     C                   EVAL      DD3AD1OK = 'N'
     C                   WHEN      ErrFldNam = 'DD4AD1'
     C                   EVAL      DD4AD1OK = 'N'
     C                   WHEN      ErrFldNam = 'DD5AD1'
     C                   EVAL      DD5AD1OK = 'N'
     C                   ENDSL
     C                   ENDIF
      *
      *
      * Update error info with that returned from validation

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Validate Party Address Line 2
      *****************************************************************
     C     VCXAD2        BEGSR

      * Reset variables updated by validation

     C                   EXSR      RESETERRS
      *
      ** Validate Party Address Line 2
      *
     C                   CALLB     'SDVPAAD02'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Party Address Line 1
      ** Party Address Line 2
     C                   PARM                    DDXAD1
     C                   PARM                    DDXAD2           28
      *
      ** Party Name
     C                   PARM                    DDXNAM
      *
      ** Error Field Name
     C                   PARM                    ErrFldNam
      *
      *
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Party Address Line 2 OK Indicator
     C                   PARM                    DDXAD2OK          1
     C                   IF        DDXAD2OK = 'N'
     C                   SELECT
     C                   WHEN      ErrFldNam = 'DD1AD2'
     C                   EVAL      DD1AD2OK = 'N'
     C                   WHEN      ErrFldNam = 'DD2AD2'
     C                   EVAL      DD2AD2OK = 'N'
     C                   WHEN      ErrFldNam = 'DD3AD2'
     C                   EVAL      DD3AD2OK = 'N'
     C                   WHEN      ErrFldNam = 'DD4AD2'
     C                   EVAL      DD4AD2OK = 'N'
     C                   WHEN      ErrFldNam = 'DD5AD2'
     C                   EVAL      DD5AD2OK = 'N'
     C                   ENDSL
     C                   ENDIF
      *
      *
      * Update error info with that returned from validation

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Validate Party Address Line 3
      *****************************************************************
     C     VCXAD3        BEGSR

      * Reset variables updated by validation

     C                   EXSR      RESETERRS
      *
      ** Validate Party 1 Address Line 3
      *
     C                   CALLB     'SDVPAAD03'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Party Address Line 2
      ** Party Address Line 3
     C                   PARM                    DDXAD2
     C                   PARM                    DDXAD3           28
      *
      ** Party Name
     C                   PARM                    DDXNAM
      *
      ** Error Field Name
     C                   PARM                    ErrFldNam
      *
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Party Address Line 3 OK Indicator
     C                   PARM                    DDXAD3OK          1
     C                   IF        DDXAD3OK = 'N'
     C                   SELECT
     C                   WHEN      ErrFldNam = 'DD1AD3'
     C                   EVAL      DD1AD3OK = 'N'
     C                   WHEN      ErrFldNam = 'DD2AD3'
     C                   EVAL      DD2AD3OK = 'N'
     C                   WHEN      ErrFldNam = 'DD3AD3'
     C                   EVAL      DD3AD3OK = 'N'
     C                   WHEN      ErrFldNam = 'DD4AD3'
     C                   EVAL      DD4AD3OK = 'N'
     C                   WHEN      ErrFldNam = 'DD5AD3'
     C                   EVAL      DD5AD3OK = 'N'
     C                   ENDSL
     C                   ENDIF
      *
      *
      * Update error info with that returned from validation

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Validate Party Post Code 2
      *****************************************************************
     C     VCXPC2        BEGSR

      * Reset variables updated by validation

     C                   EXSR      RESETERRS
      *
      ** Validate Party Post Code 2
      *
     C                   CALLB     'SDVPADE'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Party Post Code 1
      ** Party Post Code 2
     C                   PARM                    DDXPC1            4
     C                   PARM                    DDXPC2            3
      *
      ** Party Name
     C                   PARM                    DDXNAM
      *
      ** Error Field Name
     C                   PARM                    ErrFldNam
      *
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Party Post Code 2 OK Indicator
     C                   PARM                    DDXPC2OK          1
     C                   IF        DDXPC2OK = 'N'
     C                   SELECT
     C                   WHEN      ErrFldNam = 'DD1PC2'
     C                   EVAL      DD1PC2OK = 'N'
     C                   WHEN      ErrFldNam = 'DD2PC2'
     C                   EVAL      DD2PC2OK = 'N'
     C                   WHEN      ErrFldNam = 'DD3PC2'
     C                   EVAL      DD3PC2OK = 'N'
     C                   WHEN      ErrFldNam = 'DD4PC2'
     C                   EVAL      DD4PC2OK = 'N'
     C                   WHEN      ErrFldNam = 'DD5PC2'
     C                   EVAL      DD5PC2OK = 'N'
     C                   ENDSL
     C                   ENDIF
      *
      *
      * Update error info with that returned from validation

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Validate Party Base Rate Tax Liable
      *****************************************************************
     C     VCXBRT        BEGSR

      * Reset variables updated by validation

     C                   EXSR      RESETERRS
      *
      ** Validate Party Base Rate Tax Liable
      *
     C                   CALLB     'SDVTXIN02'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Party 1 Base Rate Tax Liable
     C                   PARM                    DDXBRT            1
      *
      ** Party Name
     C                   PARM                    DDXNAM
      *                                                                                       CRE007
      ** Acount Holder Type                                                                   CRE007
     C                   PARM                    DDAHLT                                       CRE007
      *
      ** Error Field Name
     C                   PARM                    ErrFldNam
      *
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Party Base Rate Tax OK Indicator
     C                   PARM                    DDXBRTOK          1
     C                   IF        DDXBRTOK = 'N'
     C                   SELECT
     C                   WHEN      ErrFldNam = 'DD1BRT'
     C                   EVAL      DD1BRTOK = 'N'
     C                   WHEN      ErrFldNam = 'DD2BRT'
     C                   EVAL      DD2BRTOK = 'N'
     C                   WHEN      ErrFldNam = 'DD3BRT'
     C                   EVAL      DD3BRTOK = 'N'
     C                   WHEN      ErrFldNam = 'DD4BRT'
     C                   EVAL      DD4BRTOK = 'N'
     C                   WHEN      ErrFldNam = 'DD5BRT'
     C                   EVAL      DD5BRTOK = 'N'
     C                   ENDSL
     C                   ENDIF
      *
      *
      * Update error info with that returned from validation

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Validate Party Date of Birth
      *****************************************************************
     C     VCXDOB        BEGSR

      * Reset variables updated by validation

     C                   EXSR      RESETERRS
      ** Clear century field if '00                                                         MD055446
     C                   IF        DDXDOBCCC = '00'                                         MD055446
     C                   EVAL      DDXDOBCCC = *BLANKS                                      MD055446
     C                   ENDIF                                                              MD055446
      *
      ** Validate Party Date of Birth
      *
     C                   CALLB     'SDVPADT'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Party Date of Birth
      ** Party Base Rate Tax Liable
     C**********         PARM                    DDXDOB            6                        MD055446
     C                   PARM                    DDXDOBCENT                                 MD055446
     C                   PARM                    DDXBRT
      *
      ** Party Name
     C                   PARM                    DDXNAM
      *
      ** Date Format
     C                   PARM                    BJDFIN            1
      *                                                                                       CRE007
      ** Acount Holder Type                                                                   CRE007
     C                   PARM                    DDAHLT                                       CRE007
      *
      ** Error Field Name
     C                   PARM                    ErrFldNam
      *
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Party Date of Birth
     C**********         PARM                    BRXDOB            6 0                      MD055446
     C                   PARM                    BRXDOB            8 0                      MD055446
      *
      ** Party Date of Birth OK Indicator
     C                   PARM                    DDXDOBOK          1
     C                   IF        DDXDOBOK = 'N'
     C                   SELECT
     C                   WHEN      ErrFldNam = 'DD1DOB'
     C                   EVAL      DD1DOBOK = 'N'
     C                   WHEN      ErrFldNam = 'DD2DOB'
     C                   EVAL      DD2DOBOK = 'N'
     C                   WHEN      ErrFldNam = 'DD3DOB'
     C                   EVAL      DD3DOBOK = 'N'
     C                   WHEN      ErrFldNam = 'DD4DOB'
     C                   EVAL      DD4DOBOK = 'N'
     C                   WHEN      ErrFldNam = 'DD5DOB'
     C                   EVAL      DD5DOBOK = 'N'
     C                   ENDSL
     C                   ENDIF
      *
      *
      * Update error info with that returned from validation

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Check for Name Change among Parties
      *****************************************************************
     C     VCNEWP        BEGSR

      *
      ** Check Name Change among Parties
      *
     C                   CALLB     'SDVNWPA'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      * Customer Number
     C                   PARM                    DDCUSN            6
      *
      * Base Rate Tax details
     C                   PARM                    CuBrt
      *
      ** Screen validation
     C                   PARM                    SinVal            1
      *
      * Main Validation Error Count
     C                   PARM                    Idx
      *
      * OUTPUTS
      *
      * Changed Party Names Array
     C                   PARM                    ChgNamArr
      *

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Validate Participant Status Fields
      *****************************************************************
     C     VCNSTS        BEGSR

      *
      ** Validate Participant Status Fields
      *
     C                   CALLB     'SDVPASS02'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      * Base Rate Tax details
     C                   PARM                    CuBrt
      *
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Participant 1 Status OK
      ** Participant 2 Status OK
      ** Participant 3 Status OK
      ** Participant 4 Status OK
      ** Participant 5 Status OK
     C                   PARM                    DD1STSOK          1
     C                   PARM                    DD2STSOK          1
     C                   PARM                    DD3STSOK          1
     C                   PARM                    DD4STSOK          1
     C                   PARM                    DD5STSOK          1

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Check for S352 warning
      *****************************************************************
     C     VCS352        BEGSR

      * Reset variables updated by checking

     C                   EXSR      RESETERRS
      *
     C**********         MOVE      DDCUSN        XCNUM             6 0                        CSD027
     C                   MOVE      DDCUSN        XCNUM             6                          CSD027
     C                   Z-ADD     00000         KDATE
     C     INTKEY        KLIST
     C                   KFLD                    XCNUM
     C                   KFLD                    KDATE             5 0
     C
     C**   CALCULATE DAY NUMBER OF APRIL 6TH FOR CURRENT TAX YEAR
     C**
     C                   MOVE      '0'           *IN98
     C**********         Z-ADD     BJRDNB        ZDAYNO                                       CSC011
     C                   Z-ADD     WRunDay       ZDAYNO                                       CSC011
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATEB        DATE
     C**
     C     MONTH         IFLT      4
     C     MONTH         OREQ      4
     C     DAY           ANDLT     6
     C                   SUB       1             YEAR
     C                   END
     C**
     C                   MOVE      '06'          TDAY
     C                   MOVE      '04'          TMONTH
     C                   MOVE      YEAR          TYEAR
     C**
     C                   MOVE      TDATE         ZDATEA
     C                   EXSR      ZDATE1
     C                   Z-ADD     ZDAYNO        APR6CY            5 0
     C*

     C**  If any participant BRT is 'N' and there is an interest payment
     C**  for which no S352 statement has been issued, send warning

     C     DD1BRT        IFEQ      'N'
     C     DD2BRT        OREQ      'N'
     C     DD3BRT        OREQ      'N'
     C     DD4BRT        OREQ      'N'
     C     DD5BRT        OREQ      'N'
     C     INTKEY        SETLL     INTPSLF8
     C                   READ      INTPSLF8                               89
     C     *IN89         IFEQ      '0'
     C     XCNUM         ANDEQ     C_CNUM
     C     C_IPDT        ANDGE     APR6CY
     C                   MOVEL     '*any'        WFldNmXAr(1)
     C                   MOVE      'USR4171'     WMsgIdXAr(1)
     C                   ENDIF
     C                   ENDIF

      * Update error info with that returned from checking

     C                   EXSR      UPDATERRS
      *
     C     EndS352       ENDSR
     C/EJECT                                                                                MD055446
      *****************************************************************                     MD055446
      ** Convert DOB from 6A to 8A                                                          MD055446
      *****************************************************************                     MD055446
     C     CVTDATE6ATO8A BEGSR                                                              MD055446
      *                                                                                     MD055446
     C                   EVAL      DDXDOBCENT = *BLANKS                                     MD055446
     C                   EVAL      DDXDOBCDD = DDXDOBDD                                     MD055446
     C                   EVAL      DDXDOBCMM = DDXDOBMM                                     MD055446
     C                   EVAL      DDXDOBCYY = DDXDOBYY                                     MD055446
      *                                                                                     MD055446
     C                   ENDSR                                                              MD055446
      *                                                                                     MD055446
      *****************************************************************
     C/EJECT
      *****************************************************************
      * RESETERRS - Reset error information that is received back     *
      *    from each validation module.                               *
      *****************************************************************
     C     RESETERRS     BEGSR

     C                   EVAL      RetCodeOut = *Blanks
      *
      * Reset error & warning fields/message IDs/message data (arrays)
     C                   MOVEL     *BLANK        FldNamXAr
     C                   MOVEL     *BLANK        MsgIDXAr
     C                   MOVEL     *BLANK        MsgDtaXAr
     C                   MOVEL     *BLANK        WFldNmXAr
     C                   MOVEL     *BLANK        WMsgIDXAr
     C                   MOVEL     *BLANK        WMsgDtXAr

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATERRS - Update error information with that received back  *
      *    from each validation module.                               *
      *****************************************************************
     C     UPDATERRS     BEGSR
      *
      * Update error fields/message IDs/message data (arrays)
      *
     C                   Z-ADD     1             I                 3 0
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     *IN99         IFEQ      '1'
     C                   MOVEA     FldNamXAr     FlDNameArr(I)
     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
     C                   END
      *
      * Set Error Index
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     I             SUB       1             Idx
      *
      * Update warning fields/message IDs/message data (arrays)
      *
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     *IN99         IFEQ      '1'
     C                   MOVEA     WFldNmXAr     WFldNamArr(I)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(I)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(I)
     C                   END
      *
      * Set Warning Index
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     I             SUB       1             WIdx
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *inzsr        BEGSR

     C     *entry        PLIST

      * INPUTS

      * Response mode
     C                   PARM                    RespMode          1
      *
      * Action Code
      * Customer Number
      * Account Holder Type
     C                   PARM                    DDACTN            1
     C                   PARM                    DDCUSN
     C                   PARM                    DDAHLT

      ** Customer Base Rate Tax
     C                   PARM                    CuBrt
      *
      ** Screen validation
     C                   PARM                    SinVal            1
      ** Customer Base Rate Tax - Century                                                   MD055446
     C                   PARM                    CuBrtCent                                  MD055446



      ** OUTPUTS

      ** Customer Base Rate Tax     OK inds
     C                   PARM                    OKCuBrt

      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr

      * Array index (3P0) from/to caller
     C                   PARM                    Idx

      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr

      * Array index (3P0) from/to caller
     C                   PARM                    WIdx

      * Valid Base Rate Tax layout (DS) from/to caller
     C                   PARM                    ValidBrt
      *
      * Changed Party Name Array
     C                   PARM                    ChgNamArr
      * Valid Base Rate Tax layout (DS) from/to caller - Century                            MD055446
     C                   PARM                    ValidBrtCent                               MD055446
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
                                                                                              CSC011
     C                   EVAL      WRunDay = BJRDNB                                           CSC011
                                                                                              CSC011
      ** Check if switchable feature CSC011 is switched on.                                   CSC011
                                                                                              CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
                                                                                              CSC011
     C                   CALL      'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRtCd                                        CSC011
     C                   PARM      '*VERIFY'     POptn                                        CSC011
     C                   PARM      'CSC011'      PSard                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
      ** Database error                                                                       CSC011
                                                                                              CSC011
     C                   IF        (PRtCd <> *BLANKS) and                                     CSC011
     C                             (PRtCd <> '*NRF   ')                                       CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE = 902                                                CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   IF        PRtCd = *BLANKS                                            CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IF        LIBR = S1SUPP                                              CSC011
     C                   EVAL      WRunDay = S1DATE                                           CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
      *
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
      *
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SDCUDBV085
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZDATE1 - Validate & convert date to a day number             *
      *                                                               *
      *****************************************************************
     C     ZDATE1        BEGSR

     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATEA            6
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag         1

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZDATE2 - Format a date for output                             *
      *                                                               *
      *****************************************************************
     C     ZDATE2        BEGSR

     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATEB            6 0
     C                   PARM                    ZADATE            7

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRERR - EXCEPTION ERRORS                                      *
      *                                                               *
      *****************************************************************
     C     SRERR         BEGSR
      *
     C                   MOVEL     'SDCUSD6VL'   DBPGM
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   DUMP
      *
      **  Terminate the program
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
