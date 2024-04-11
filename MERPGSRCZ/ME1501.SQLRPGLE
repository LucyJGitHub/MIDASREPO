     H***DEBUG**                                                                            MD060125
     H DEBUG FIXNBR(*ZONED)                                                     MD060125
     F*****************************************************************
/**** *  RPGBASE                                                      *                     MD056560
/*STD *  RPGSQLBND                                                    *                     MD056560
/*EXI *  TEXT('Midas ME Auto-gen criteria analysis')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Message Management Module                            *
      *                                                               *
      *  ME1501 - Auto-Gen Criteria Analysis                          *
      *                                                               *
      *  Function:  This program extracts the required fields from    *
      *             the translation process and checks against the    *
      *             user-defined auto-gen criteria to set up the      *
      *             FT transactions.                                  *
      *                                                               *
      *  Called By: FT0300  - FT Auto Generation                      *
      *  Calls : Programs in MEUCHKPD                                 *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD058687           Date 09Jul21               *
      *  Prev Amend No. CFT162             Date 16Dec20               *
      *                 217679             Date 04Feb13               *
      *                 AR918987A          Date 04Feb13               *
      *                 AR918987           Date 09Feb12               *
      *                 MD058081           Date 11May21               *
      *                 MD060125           Date 21Jun22               *
      *                 MD056560           Date 31Aug20               *
      *                 CSD103             Date 10Aug20               *
      *                 AR936976           Date 13Apr12               *
      *                 AR928996A          Date 03May12               *
      *                 AR928996           Date 27Mar12               *
      *                 MD046248           Date 27Oct17               *
      *                 MD022652           Date 07Oct13               *
      *                 CER059             Date 19Jul10               *
      *                 CER045             Date 20Jul09               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG24998           Date 17Jul09               *
      *                 CSW209             Date 01Apr09               *
      *                 BUG24039           Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CSW207             Date 19Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 CRE008             Date 10Apr02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 197953             Date 28Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 25Aug00               *
      *                 CFT014             Date 22Jun00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 177678             Date 25Apr00               *
      *                 CFT007             Date 17Nov99               *
      *                 CFT006             Date 20Oct99               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CFT005             Date 08Jul99               *
      *                 CFT004             DATE 27Jul99               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CGL009             Date 26Jul99               *
      *                 165126             Date 26Jul99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 162508             Date 22Jun99               *
      *                 162490             Date 16Jun99               *
      *                 162380             Date 14Jun99               *
      *                 CFT002  *Create    Date 05May98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058687 - Formalise 217679/AR918987A/AR918987 for CFT162    *
      *  CFT162 - MT900 and MT910 Message Generation                  *
      *           Applied 217679/AR918987A/AR918987 and conditioned to*
      *           CFT162                                              *
      *  217679 - Condition all access on UUC068 being switched on    *
      *         - Amendment to AR918987A                              *
      *         - Do not print report if only CRE008 is on and        *
      *           if it is not a Cash Management message              *
      *         - Applied for AR1068690 (Child: AR1069087)            *
      *  AR918987A - Missing code to access Lf/MEGNCRX0               *
      *  AR918987 - Missing MT900/MT910 extension details in STP for  *
      *             CAR UUC068. Recompile.                            *
      *           - Pass generation criteria as parms.                *
      *             (Child: AR922598)                                 *
      *  MD058081 - Deliverable Data Split for ME and MS              *
      *  MD060125 - STP job ME_FT_IMM on MSGW with decimal data error *
      *             in ME1501.                                        *
      *           - Include FIXNBR(*ZONED), avoid decimal data error. *
      *  MD056560 - Deliverable Data Split for SDMTAGPD               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  AR936976 - STP Rules not being processed. Variables used     *
      *             in SRUCHK to keep array limits corrupted          *
      *             in SRECHK. WB and WE in SRECHK renamed.           *
      *             (Child: AR936977)                                 *
      *  AR928996A- Data truncation error. Amended PDATA and PDAT2    *
      *             data structure field to have the correct length.  *
      *             (Child: AR928997A)                                *
      *  AR928996 - Data lost due to rate field :36: being truncated. *
      *             (Child: AR928997)                                 *
      *  MD046248 - Finastra Rebranding                               *
      *  MD022652 - Excluded Phase Processing                         *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER045 - German Features - Reporting Bundesbank (Recompile)  *
      *  CER030 - Multicash German Feature                            *
      *  BUG24998 - Bank operation code is missing (Recompile)        *
      *  CSW209 - SWIFT 2009 Changes                                  *
      *  BUG24039 - Field P70 error                                   *
      *  CSW207 - SWIFT 2007 Changes                                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *           (Recompile)                                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CRE008 - Cash Management                                     *
      *           Recognise MT101 and MT103 for routing to Cash Mgt   *
      *           Also, if is set to be reported, log test failure    *
      *           for reporting to FT0310.                            *
      *  197953 - Increase Vostro accound code array from 20 to 100   *
      *  CFT009 - FT Fees and Charge Development                      *
      *  CFT014 - Addition of MT103 messages                          *
      *  CFT014 - Straight-through processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
      *  177678 - Error in autogen analysis exception report          *
      *  CFT007 - BIC Database Plus Integration                       *
      *  CFT006 - MT101/2 message addtion for outgoing/incoming RFT   *
      *  CFT005 - Straight Through Processing Phase 2                 *
      *           Auto-authorisation of STP payments (Recompile)      *
      *  CFT004 - International Bank Account Number                   *
      *  CGL009 - FONTIS IAT/TPP interface                            *
      *  165126 - Allow for the network when selecting a criteria     *
      *  162508 - Allows suffix and operators GT GE LE LT in          *
      *           in user defined checking function                   *
      *  162490 - Field 32 reported wrong in ME1501P1 + tidy up format*
      *  162380 - Allow lower case Compare Value names                *
      *  CFT002 - Straight Through Processing Phase 1 Enhancements    *
      *  CFT002 - Straight Through Processing Phase 1                 *
      *           Based on MEH022 original references:                *
      *           DJBPK3/DJBPK2/S01482/DBF242/DBF215/DBF165/DBF164    *
      *           DBF156/DBF142/DBF083/DBF082/DBF081/DBF080/HUB001    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Indicator usage                                              *
      *  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯                                              *
      *                                                               *
      *  50    First cycle completed                                  *
      *  60    EOF on MEGNCRL0                                        *
      *  61    EOF on MEGNDTL0                                        *
      *  63    Match found on table LOKUP                             *
      *  90    Chain fail                                             *
      *  99    EOF on Read                                            *
      *                                                               *
      *  U7/U8 Error Ocurred                                          *
      *  LR    End program                                            *
      *                                                               *
      *****************************************************************
     F/EJECT
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *   #HINIT   - Initialise and define fields                     *
      *   #HSLCT   - Select message for Auto-Gen. Process             *
      *   #HMATH   - Match the message details against the criteria   *
      *   #HAUDT   - Produce audit list                               *
      *   #HFDDT   - Validate Field Details                           *
      *   #H1AMT   - Validate the First Amount                        *
      *   STRFNC   - *STR function                                    *
      *   SRUCHK   - User defined function check                      *
      *                                                               *
      *****************************************************************
     F/EJECT
      *
      *  Auto-Gen Criteria Control
      *
     FMEGNCRL0  IF   E           K DISK    INFSR(SRFILE)
      *
      *  Auto-Gen Criteria Details
      *
     FMEGNDTL0  IF   E           K DISK    INFSR(SRFILE)
      *
      *  Incoming Message Detail - multiple formats
      *
     FMEINDTS2  IF   E           K DISK    INFSR(SRFILE)
      *
      *  Account master file
      *
     FACCNT     IF   E           K DISK    INFSR(SRFILE)
      *
      *  Account code extension file
      *
     FSDACODL3  IF   E           K DISK
      *
      *  Vostro Account codes
      *
     FSDBRCHL5  IF   E           K DISK
      *
      *  Customer master extension file
      *
     FMEBICDL2  IF   E           K DISK
      *
      *  Message Management Bic Directory
      *
     FMEINMPL1  IF   E           K DISK
      *
      *  Message Management Incoming, Parts
      *
     F*SDMTAGL0* IF   E           K DISK                                                    MD056560
      *
      * Message Tags
      *
     FMEINCRL1  IF   E           K DISK
      *
      * User check programm
      *
     FMEUCHKPD  IT   F   15        DISK
      *                                                                                       CRE008
      * User check programm - Extended use                                                    CRE008
      *                                                                                       CRE008
     F*MEECHKPD* IT   F   15        DISK                                                    MD058081
     FMECHKJW0  IT   F   15        DISK                                                     MD058081
      *
      * SD Country codes                                                                      CFT004
      *                                                                                       CFT004
     FSDCTRYL2  IF   E           K DISK
      *                                                                                       CFT004
      *  Exception Audit List
      *
     F/COPY WNCPYSRC,ME1501F001
     FMEGNCRX0  IF   E           K DISK    USROPN                                           AR918987
     F**  GENERATION CRITERIA HEADER EXTENSION FILE                                         AR918987
      *                                                                                     AR918987
     F*E1501P1O***E********************PRINTER                        UC  CFT006
     FME1501P1  O    E             PRINTER OFLIND(*IN25)                        CFT006
     F                                     USROPN
     F/COPY WNCPYSRC,ME1501F002
      /EJECT
     D*********           HK1        20  4 0A            Vostro A/c code                      197953
     D**********          HK1       100  4 0A            Vostro A/c code               197953 CGL029
     D HK1             S             10  0 DIM(100) ASCEND
     D HK4             S            100    DIM(28)
     D HK6             S            100    DIM(28)
     D @CK             S             15    DIM(200) FROMFILE(MEUCHKPD)
     D                                     PERRCD(1)
     D*@CE******       S             15    DIM(200) FROMFILE(MEECHKPD)                      MD058081
     D @CE             S             15    DIM(200) FROMFILE(MECHKJW0)                      MD058081
     D                                     PERRCD(1)
     D/COPY WNCPYSRC,ME1501E001
     D*COPY*ZSRSRC,ZDATE1Z1                                                                 MD056560
     D*COPY*ZSRSRC,ZHOLE                                                                    MD056560
     D/COPY ZSRSRC,ZHOLELE                                                                  MD056560
     D*COPY*MECPYSRC,SRERRE                                                                 MD056560
     D/COPY MECPYSRC,SRERRELE                                                               MD056560
      /EJECT
      *
     D CPYR@#          DS
      *
      *  Data structure for compilation  - Copyright insertion
      *
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)              Copyright table
     D  CPY@##                 1     20
      *
     D/COPY ZSRSRC,ZDATE2Z1LE                                                               MD056560
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
      *
      *  Define rundat data area
      *
      *
      *  Incoming message details data structures copy member
      *
     D*COPY*MECPYSRC,SME1100P                                                               MD056560
     D/COPY MECPYSRC,SME1100PLE                                                             MD056560
     D/COPY WNCPYSRC,ME1501I001
     DPCRITX         E DS                  EXTNAME(MEGNCRX0)                                AR918987
      *                                                                                     AR918987
      *                                                                   CRE008
     D INLF          E DS                  EXTNAME(MEINLFPD)                    CRE008
      *
     D************PCRIT     E DSMEGNCRPD                    256           CFT009
     D PCRIT         E DS                  EXTNAME(MEGNCRPD)                    CFT009
      *
      *  Return Criteria Details to calling program
      *
     D                 DS
      *
      *  Split the detail fields into field tag name and contents
      *
     D  WUFDDT                 1    256
     D  WUMTAG                 1      5
     D  WUFDIN                 6      6
     D  WUTGCK                 6    256
     D  WUTGVL                 7    256
     D**********                              7  24 WUACCO                                    CGL029
     D  WUACCO                 7     30
     D**********                              7  120WUCNUM                                    CSD027
     D  WUCNUM                 7     12
     D  WUCNUA                 7     12
     D  WUCURR                13     15
     D**********                             16  190WUACCD                                    CGL029
     D**********                             16  19 WUACCA                                    CGL029
     D**********                             20  210WUACSQ                                    CGL029
     D**********                             20  21 WUACSA                                    CGL029
     D**********                             22  24 WUBRCA                                    CGL029
     D**********                             25 256 WUORIG                                    CGL029
     D**********                             25 256 WUO                                       CGL029
     D  WUACCD                16     25  0
     D  WUACCA                16     25
     D  WUACSQ                26     27  0
     D  WUACSA                26     27
     D  WUBRCA                28     30
     D  WUORIG                31    256
     D  WUO                   31    256
      ** For FONTIS tag 72 is bigger (no translation possible)            CGL009
     D  F72                    7    246                                         CGL009
     D**********                             25  35 WUSWFT                                    CGL029
     D**********                             36 256 WUNSWF                                    CGL029
     D**********                             60  70 WUSWF2                                    CGL029
     D**********                             71 256 WUNSW2                                    CGL029
     D  WUSWFT                31     41
     D  WUNSWF                42    256
     D  WUSWF2                66     76
     D  WUNSW2                77    256
      *
     D                 DS
      *
      *  Split the detail fields into field tag name and contents
      *
     D  WCFDDT                 1    256
     D  WCMTAG                 1      5
     D  WCFDIN                 6      6
     D**********                              7  24 WCACCO                                    CGL029
     D  WCACCO                 7     30
     D  WCCNUM                 7     12  0
     D  WCCNUA                 7     12
     D  WCCURR                13     15
     D**********                             16  190WCACCD                                    CGL029
     D**********                             16  19 WCACCA                                    CGL029
     D**********                             20  210WCACSQ                                    CGL029
     D**********                             20  21 WCACSA                                    CGL029
     D**********                             22  24 WCBRCA                                    CGL029
     D**********                             25 256 WCORIG                                    CGL029
     D**********                             25  35 WCSWFT                                    CGL029
     D**********                             36 256 WCNSWF                                    CGL029
     D**********                             60  70 WCSWF2                                    CGL029
     D**********                             71 256 WCNSW2                                    CGL029
     D  WCACCD                16     25  0
     D  WCACCA                16     25
     D  WCACSQ                26     27  0
     D  WCACSA                26     27
     D  WCBRCA                28     30
     D  WCORIG                31    256
     D  WCSWFT                31     41
     D  WCNSWF                42    256
     D  WCSWF2                66     76
     D  WCNSW2                77    256
      *
      *  Split SWIFT date format into YYMMDD
      *  for Midas date conversion
      *
     D                 DS
     D  SWDT                   1      6
     D  SYY                    1      2
     D  SMM                    3      4
     D  SDD                    5      6
      *
      *  Split Criteria Compare Value
      *
     D                 DS
     D  WUCRIT                 1     35
     D  WUASTK                 1      1
     D  WUFUNC                 1      5
     D  WUFUN2                 1      2
     D  WUFUN3                 1      3
     D  WUFUN4                 1      4
     D  WUFUN6                 1      6
     D  WUFUN7                 1      7
     D  WIBANV                 8     35
     D  WUSLEA                 5      7
     D  WUSLEN                 5      7  0
     D  WUBLNK                 8      8
     D  WUSCMP                 9     35
     D  WUCODE                 6     35
     D  WUHOUR                 7      8  0
     D  WUMINS                10     11  0
      *
      * Received date and time as 12 long field
      *
     D RCCOMP          DS            14
     D  RCCNTY                 1      2
     D  RCDATE                 3      8  0
     D  RCYEAR                 3      4  0
     D  RCDATA                 3      8
     D  RCTIME                 9     12  0
     D  RCSECS                13     14  0
      *
      * System date and time as 12 long field
      *
     D SYCOMP          DS            14
     D  SYDATE                 1      8  0
     D  SYTIME                 9     14  0
     D  SYHOUR                 9     10  0
     D  SYMINS                11     12  0
     D  SYSECS                13     14  0
      *
      *  Combine 6 Criteria Compare Values from the record
      *  into an array
      *
     D                 DS
     D  HK2                    1    210
     D                                     DIM(6)                               Criteria array
     D  WUCRIA                 1    210
     D  GDCMP1                 1     35
     D  GDCMP2                36     70
     D  GDCMP3                71    105
     D  GDCMP4               106    140
     D  GDCMP5               141    175
     D  GDCMP6               176    210
     D                 DS
     D  WUHK3                  1    140
     D  HK3                    1    140
     D                                     DIM(28)                              Msg Hdr/Trailer
     D                 DS
     D  WUHK5                  1    140
     D  HK5                    1    140
     D                                     DIM(28)                              Msg Other dtls
     D MEDTA           DS
     D  O#MTPY                 1      3
     D  O#MSET                 4      6  0
     D  O#DESC                 7     36
     D  O#DES2                37     66
     D LGDTA           DS
     D  L#MTPY                 1      3
     D  L#MSET                 4      6  0
     D  L#CSEQ                 7      9  0
     D  L#CRIT                10    240
     D @CKDS           DS
     D  @CKFNC                 1      5
     D  @CKPGM                 6     15
      *
      ** To check wether a field is numeric
     D WNUMB           C                   CONST('0123456789')
      *
     D LW              C                   CONST('abcdefghijklmnopqrst-
     D                                     uvwxyz')
     D UP              C                   CONST('ABCDEFGHIJKLMNOPQRST-
     D                                     UVWXYZ')
      *
      *  Data Structures used by Access Objects
      *
     D/COPY WNCPYSRC,ME1501I002
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
     D*                                                                   CFT004
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CFT007
     D DSMTAG        E DS                  EXTNAME(SDMTGJW0)                                MD056560
     D DSSDY         E DS                  EXTNAME(DSSDY)                                   MD056560
     I* External data structure for SAR file details                      CFT004
      *
      *  Data structures used by holiday checking
      *
     I*COPY*ZSRSRC,ZHOLI                                                                    MD056560
     I/COPY ZSRSRC,ZHOLILE                                                                  MD056560
     I*COPY*ZSRSRC,ZHOLDS                                                                   MD056560
      *
      *  End of Program Error Processing copysource member
      *
     D*COPY*MECPYSRC,SRERRI                                                                 MD056560
     D/COPY MECPYSRC,SRERRILE                                                               MD056560
      *
      /EJECT
      *****************************************************************
      *                 M A I N L I N E
      *****************************************************************
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'MAIN'        @STK(Q)
      *
      *  Define entry parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    W0ACT             8            Action code
     C                   PARM                    PHEAD                          General Details
     C                   PARM                    PDATA                          Message Details
     C                   PARM                    PDAT2
     C/COPY WNCPYSRC,ME1501C004
     C                   PARM                    PCRIT                          CriteriaDetails
     C                   PARM                    W0RTN             7            Return Code
     C                   PARM                    W0CPGM           10            Program for msgs
     C                   PARM                    P@RETV          256            Return value
     C/COPY WNCPYSRC,ME1501C009
     C                   PARM                    PCRITX                                     AR918987
      *                                                                                     AR918987
      *
      * Initialise program
      *
     C     *IN50         IFEQ      '0'
     C                   EXSR      #HINIT
     C                   ENDIF
      *
      *  Determine whether Auto-Gen of FT transaction is required :-
      *
     C                   EXSR      #HSLCT
      *
      *  set up return code
      *
     C     WUPYTP        IFEQ      *BLANKS
     C                   MOVEL     'MIN0083'     W0RTN
     C                   ELSE
     C                   MOVEL     'MIN0096'     W0RTN
     C                   ENDIF
      *
      *  Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
      *  Return to calling program
      *
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      *  #HSLCT   : Select message for Auto-Gen. Process              *
      *                                                               *
      *  CALLED BY: Main processing section                           *
      *                                                               *
      *  CALLS    : MATCH   - Check the details against criteria      *
      *                                                               *
      *****************************************************************
     CSR   #HSLCT        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     '#HSLCT'      @STK(Q)
      *
      *  Initialise the return parameter of the subroutine
      *
     C                   MOVE      *BLANKS       WUPYTP            2
     C                   MOVE      *BLANKS       WUPYST            2                           CRE00
     C/COPY WNCPYSRC,ME1501C010
      *
      *  Position to first Criteria Set
      *
     C                   Z-ADD     *ZEROS        GNMSET
     C     KYGNCR        SETLL     @GNCRPD                            60
     C     *IN60         IFEQ      '0'
     C     KYGNC2        READE     @GNCRPD                                60
     C                   END
      *
      *  If record not found - should not be auto-gen
      *
     C     *IN60         IFEQ      '1'
     C                   MOVE      *BLANKS       WUPYTP
     C                   ELSE
      *
      *  Loop until all criteria within the Set are processed
      *
     C     KYGNCR        SETLL     @GNCRPD                            60
     C     *IN60         DOWEQ     '0'
     C     WUPYTP        ANDEQ     *BLANKS
      *
      *  Access Auto-Gen Criteria Control File
      *
     C     KYGNC2        READE     @GNCRPD                                60
      *                                                                   CRE008
     C                   MOVE      *BLANKS       WFRULE            1                           CRE00
      *
      *  If record found - continue analysis
      *
     C     *IN60         IFEQ      '0'
      *                                                                                    AR918987A
      *  Access criteria extension details                                                 AR918987A
      *                                                                                    AR918987A
     C*****UUC068        IFEQ      'Y'                                                 217679 CFT162
     C     CFT162        IFEQ      'Y'                                                        CFT162
     C     KYGNCR        CHAIN     MEGNCRX0                           89                   AR918987A
     C                   ENDIF                                                                217679
      *                                                                   CGL009
     C/COPY WNCPYSRC,MEH00018
      * FONTIS and SWIFT can have the same message type (100) so          CGL009
      * we take account of the network in the criteria selection          165126
     C     GNNWRK        IFNE      PNWRK                                                       16512
      * Read next criterion                                               165126
     C                   ITER                                                                  16512
     C                   ENDIF                                                                 16512
      *                                                                   165126
      *
      *  Set up Payment type beforehand
      *  and subtype too...                                               CRE008
      *
     C                   MOVE      GNPYTP        WUPYTP
     C                   MOVE      GNPYST        WUPYST                                        CRE00
      *
      *  Position to first tag in the Criteria Set
      *
     C                   Z-ADD     GNMSET        GDMSET
     C                   Z-ADD     *ZEROS        GDCSEQ
     C     KYGNDT        SETLL     @GNDTPD                            61
     C     *IN61         IFEQ      '0'
     C     KYGNCR        READE     @GNDTPD                                61
     C                   END
      *
      *  If record found - continue analysis
      *
     C     *IN61         IFEQ      '0'
      *
      *  Loop until all criteria within the Set are processed
      *  or any of the criteria is not satisfied
      *
     C                   Z-ADD     1             H3                2 0
     C                   Z-ADD     1             H4                2 0
     C                   MOVEA     *BLANKS       HK3
     C                   MOVEA     *BLANKS       HK4
     C     KYGNDT        SETLL     @GNDTPD                            61
     C     *IN61         DOUEQ     '1'
     C     WUPYTP        OREQ      *BLANKS
      *
      *  Access Auto-Gen Criteria Details File
      *
     C     KYGNCR        READE     @GNDTPD                                61
      *
      *  If record found - Check whether the criteria is matched
      *
     C     *IN61         IFEQ      '0'
      *                                                                   CRE008
      ** But first, check if test needs logging...                        CRE008
     C     WFRULE        IFNE      'Y'                                                         CRE00
     C     GDREPT        ANDEQ     'Y'                                                         CRE00
     C                   MOVEL     GNMTPY        O#MTPY                                        CRE00
     C                   MOVEL     GNMSET        O#MSET                                        CRE00
     C                   MOVEL     GNDESC        O#DESC                                        CRE00
     C                   MOVEL     GNDES2        O#DES2                                        CRE00
     C                   MOVEL(P)  MEDTA         MEMSDT                                        CRE00
     C                   MOVEL     W0CPGM        MEPGMQ                                        CRE00
     C                   MOVEL     'MIN0505'     MEMSID                                        CRE00
     C                   MOVEL     'MEMSG'       MEMSGF                         Msg file       CRE00
     C                   EXSR      MESNMS                                                      CRE00
     C                   MOVEL     'Y'           WFRULE                                        CRE00
     C                   ENDIF                                                                 CRE00
      *                                                                   CRE008
      ** Now check proceed with checking....                              CRE008
     C                   EXSR      #HMATH
     C                   ENDIF
      *
     C                   ENDDO
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
      *
      *  Set up return action code
      *
     C                   SELECT
     C     WUPYTP        WHENEQ    'IN'
     C                   MOVEL     '*INC FT '    W0ACT
      *
      * Send message for rule that was found
      *
     C                   MOVEL     GNMTPY        O#MTPY
     C                   MOVEL     GNMSET        O#MSET
     C                   MOVEL     GNDESC        O#DESC
     C                   MOVEL     GNDES2        O#DES2
     C                   MOVEL(P)  MEDTA         MEMSDT
     C                   MOVEL     W0CPGM        MEPGMQ
     C                   MOVEL     'MIN0260'     MEMSID
     C                   MOVEL     'MEMSG'       MEMSGF                         Msg file
     C                   EXSR      MESNMS
      *
     C     WUPYTP        WHENEQ    'OP'
     C                   MOVEL     '*OUT FT '    W0ACT
      *
      * Send message for rule that was found
      *
     C                   MOVEL     GNMTPY        O#MTPY
     C                   MOVEL     GNMSET        O#MSET
     C                   MOVEL     GNDESC        O#DESC
     C                   MOVEL     GNDES2        O#DES2
     C                   MOVEL(P)  MEDTA         MEMSDT
     C                   MOVEL     W0CPGM        MEPGMQ
     C                   MOVEL     'MIN0261'     MEMSID
     C                   MOVEL     'MEMSG   '    MEMSGF                         Msg file
     C                   EXSR      MESNMS
      *                                                                   CFT006
      ** If the switchable feature, CFT006, is on then do new processing  CFT006
      *                                                                   CFT006
      ** If message type is MT101 'RI' set up return action               CFT006
      *                                                                   CFT006
     C     WUPYTP        WHENEQ    'RI'                                                        CFT00
     C     CFT006        ANDEQ     'Y'                                                         CFT00
     C                   MOVEL     '*RFT IN '    W0ACT                                         CFT00
      *                                                                   CFT006
      * Send message for rule that was found                              CFT006
      *                                                                   CFT006
     C                   MOVEL     GNMTPY        O#MTPY                                        CFT00
     C                   MOVEL     GNMSET        O#MSET                                        CFT00
     C                   MOVEL     GNDESC        O#DESC                                        CFT00
     C                   MOVEL     GNDES2        O#DES2                                        CFT00
     C                   MOVEL(P)  MEDTA         MEMSDT                                        CFT00
     C                   MOVEL     W0CPGM        MEPGMQ                                        CFT00
     C                   MOVEL     'MIN0260'     MEMSID                                        CFT00
     C                   MOVEL     'MEMSG'       MEMSGF                         Msg file       CFT00
     C                   EXSR      MESNMS                                                      CFT00
      *                                                                   CFT006
      ** If message type is MT102 'BI' set up return action               CFT006
      *                                                                   CFT006
     C     WUPYTP        WHENEQ    'BI'                                                        CFT00
     C     CFT008        ANDEQ     'Y'                                                         CFT00
     C                   MOVEL     '*CCT IN '    W0ACT                                         CFT00
      *                                                                   CFT006
      * Send message for rule that was found                              CFT006
      *                                                                   CFT006
     C                   MOVEL     GNMTPY        O#MTPY                                        CFT00
     C                   MOVEL     GNMSET        O#MSET                                        CFT00
     C                   MOVEL     GNDESC        O#DESC                                        CFT00
     C                   MOVEL     GNDES2        O#DES2                                        CFT00
     C                   MOVEL(P)  MEDTA         MEMSDT                                        CFT00
     C                   MOVEL     W0CPGM        MEPGMQ                                        CFT00
     C                   MOVEL     'MIN0260'     MEMSID                                        CFT00
     C                   MOVEL     'MEMSG'       MEMSGF                         Msg file       CFT00
     C                   EXSR      MESNMS                                                      CFT00
      *
      ** If message type is MT101 'CM' set up return action               CRE008
      *                                                                   CRE008
     C     WUPYTP        WHENEQ    'CM'                                                        CRE00
     C     CRE008        ANDEQ     'Y'                                                         CRE00
     C*                                                                   CRE008
     C                   SELECT                                                                CRE00
     C     WUPYST        WHENEQ    'MT'                                                        CRE00
     C                   MOVEL     '*CM 101 '    W0ACT                                         CRE00
     C     WUPYST        WHENEQ    'MR'                                                        CRE00
     C                   MOVEL     '*CM 103R'    W0ACT                                         CRE00
     C     WUPYST        WHENEQ    'MS'                                                        CRE00
     C                   MOVEL     '*CM 103S'    W0ACT                                         CRE00
     C                   ENDSL                                                                 CRE00
      *                                                                   CRE008
      * Send message for rule that was found                              CRE008
      *                                                                   CRE008
     C                   MOVEL     GNMTPY        O#MTPY                                        CRE00
     C                   MOVEL     GNMSET        O#MSET                                        CRE00
     C                   MOVEL     GNDESC        O#DESC                                        CRE00
     C                   MOVEL     GNDES2        O#DES2                                        CRE00
     C                   MOVEL(P)  MEDTA         MEMSDT                                        CRE00
     C                   MOVEL     W0CPGM        MEPGMQ                                        CRE00
     C                   MOVEL     'MIN0504'     MEMSID                                        CRE00
     C                   MOVEL     'MEMSG'       MEMSGF                                        CRE00
     C                   EXSR      MESNMS                                                      CRE00
      *                                                                   CRE008
      * If Payment type is '**' then action is ignore
      *
     C     WUPYTP        WHENEQ    '**'
     C                   MOVEL     '*IGNORE '    W0ACT
      *
      * Send message for rule that was found
      *
     C                   MOVEL     GNMTPY        O#MTPY
     C                   MOVEL     GNMSET        O#MSET
     C                   MOVEL     GNDESC        O#DESC
     C                   MOVEL     GNDES2        O#DES2
     C                   MOVEL(P)  MEDTA         MEMSDT
     C                   MOVEL     W0CPGM        MEPGMQ
     C                   MOVEL     'MIN0262'     MEMSID
     C                   MOVEL     'MEMSG'       MEMSGF                         Msg file
     C                   EXSR      MESNMS
      *
      * If Payment type is '++' then action is manually process
      *
     C     WUPYTP        WHENEQ    '++'
     C                   MOVEL     *BLANKS       W0ACT
      *
      * Send message for rule that was found
      *
     C                   MOVEL     GNMTPY        O#MTPY
     C                   MOVEL     GNMSET        O#MSET
     C                   MOVEL     GNDESC        O#DESC
     C                   MOVEL     GNDES2        O#DES2
     C                   MOVEL(P)  MEDTA         MEMSDT
     C                   MOVEL     W0CPGM        MEPGMQ
     C                   MOVEL     'MIN0263'     MEMSID
     C                   MOVEL     'MEMSG'       MEMSGF                         Msg file
     C                   EXSR      MESNMS
     C                   OTHER
     C                   MOVEL     *BLANKS       W0ACT
     C                   ENDSL
      *
      *  Produce audit list
      *
     C     GNEXCP        IFEQ      'Y'
     C     WUPYTP        ANDNE     *BLANKS                                                    217679
     C     W0ACT         OREQ      *BLANKS
     C     WUPYTP        ANDEQ     *BLANKS                                                    217679
     C                   EXSR      #HAUDT
     C                   ENDIF
      *
      *  Unwind subroutine stack name
      *
     C     #HXSLC        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  #HMATH   : Match the message details against the criteria    *
      *                                                               *
      *  CALLED BY: SELECT                                            *
      *                                                               *
      *  CALLS    :                                                   *
      *                                                               *
      *****************************************************************
     CSR   #HMATH        BEGSR
      ** CAUTION :
      ** =========
      ** Part of this subroutine has been duplicated in program ME1503
      ** Therefore any amendments here are to be reported in the other
      ** program.
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     '#HMATH'      @STK(Q)
      *
      *  Initialise the work fields
      *
     C                   MOVE      *BLANKS       WUMATH            1
     C                   MOVE      *BLANKS       WUFDDT
     C                   MOVE      *LOVAL        WKPART
     C/COPY WNCPYSRC,ME1501C005
      *
      *  Depends on the message tag
      *  set up details
      *  and
      *  pass to validation routine
      *
     C                   SELECT
     C/COPY WNCPYSRC,ME1501C011
      *
     C     GDMTAG        WHENEQ    ':20: '                                      Trans Ref
     C     GDMTAG        OREQ      'BJ20 '                                      Trans Ref
      *                                                                   CFT006
     C     GDHDTG        IFEQ      'N'                                                         CFT00
     C                   MOVEL     P20           WUFDDT
     C                   ELSE                                                                  CFT00
     C                   MOVEL     PH20          WUFDDT                                        CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   EXSR      #HFDDT
      *
     C     GDMTAG        WHENEQ    ':21: '                                      Related Ref
     C     GDMTAG        OREQ      'BJ21 '                                      Related Ref
     C                   MOVEL     P21           WUFDDT
     C                   EXSR      #HFDDT
      *
     C     GDMTAG        WHENEQ    ':32A:'                                      1st amount A
     C     GDMTAG        OREQ      ':32B:'                                      1st amount A
     C     GDMTAG        OREQ      ':32C:'                                      1st amount C
     C     GDMTAG        OREQ      ':32D:'                                      1st amount D
     C     GDMTAG        OREQ      ':32P:'                                      1st amount P
     C     GDMTAG        OREQ      ':32R:'                                      1st amount R
     C     GDMTAG        OREQ      'BJ32 '                                      1st amount BOJ
      *                                                                   CFT006
     C     GDHDTG        IFEQ      'N'                                                         CFT00
      *                                                                   CFT006
     C     GDMTAG        IFEQ      ':32B:'                                                     CFT00
      *                                                                   CFT006
     C     GDMTPY        IFEQ      '101'                                                       CFT00
     C     GDMTPY        OREQ      '102'                                                       CFT00
     C                   MOVEL     P32B          WUFDDT                                        CFT00
     C                   ELSE                                                                  CFT00
     C                   MOVEL     PDCA          WUFDDT
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   ELSE                                                                  CFT00
     C                   MOVEL     PDCA          WUFDDT                                        CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   ELSE                                                                  CFT00
     C                   MOVEL     PH32A         WUFDDT                                        CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   EXSR      #H1AMT
      *
     C     GDMTAG        WHENEQ    ':50: '                                      Ord Cust
     C     GDMTAG        OREQ      ':50H:'                                      Ord Cust       CFT00
     C     GDMTAG        OREQ      ':50A:'                                      Ord Cust       CFT01
     C     GDMTAG        OREQ      ':50K:'                                      Ord Cust       CFT01
     C     GDMTAG        OREQ      ':50F:'                                      Ord Cust       CSW20
     C     GDMTAG        OREQ      'BJ50D'                                      Ord Cust
      *                                                                   CFT006
     C     GDMSEQ        IFEQ      'B'
     C     CSW209        ANDEQ     'Y'
     C                   MOVEL     PB50          WUFDDT
     C                   ELSE
     C     GDHDTG        IFEQ      'N'                                                         CFT00
     C                   MOVEL     P50           WUFDDT
     C                   ELSE                                                                  CFT00
     C                   MOVEL     PH50          WUFDDT                                        CFT00
     C                   ENDIF                                                                 CFT00
     C                   ENDIF
      *                                                                   CFT006
     C                   EXSR      #HFDDT
      *
     C     GDMTAG        WHENEQ    ':52A:'                                      Ord Bank
     C     GDMTAG        OREQ      ':52B:'                                      Ord Bank       CFT00
     C     GDMTAG        OREQ      ':52C:'                                      Ord Bank       CFT00
     C     GDMTAG        OREQ      ':52D:'                                      Ord Bank
     C     GDMTAG        OREQ      'BJ52D'                                      Ord Bank
      *                                                                   CFT006
     C     GDMSEQ        IFEQ      'B'
     C     CSW209        ANDEQ     'Y'
     C                   MOVEL     PB52          WUFDDT
     C                   ELSE
     C     GDHDTG        IFEQ      'N'                                                         CFT00
     C                   MOVEL     P52           WUFDDT
     C                   ELSE                                                                  CFT00
     C                   MOVEL     PH52          WUFDDT                                        CFT00
     C                   ENDIF                                                                 CFT00
     C                   ENDIF
      *                                                                   CFT006
     C                   EXSR      #HFDDT
      *
     C     GDMTAG        WHENEQ    ':53A:'                                      Sndr Corr
     C     GDMTAG        OREQ      ':53B:'                                      Sndr Corr
     C     GDMTAG        OREQ      ':53C:'                                      Sndr Corr      CFT00
     C     GDMTAG        OREQ      ':53D:'                                      Sndr Corr
      *                                                                   CFT006
     C     GDHDTG        IFEQ      'N'                                                         CFT00
     C                   MOVEL     P53           WUFDDT
     C                   ELSE                                                                  CFT00
     C                   MOVEL     PH53          WUFDDT                                        CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   EXSR      #HFDDT
      *
     C     GDMTAG        WHENEQ    ':54A:'                                      Rcvr Corr
     C     GDMTAG        OREQ      ':54B:'                                      Rcvr Corr
     C     GDMTAG        OREQ      ':54D:'                                      Rcvr Corr
      *                                                                   CFT006
     C     GDHDTG        IFEQ      'N'                                                         CFT00
     C                   MOVEL     P54           WUFDDT
     C                   ELSE                                                                  CFT00
     C                   MOVEL     PH54          WUFDDT                                        CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   EXSR      #HFDDT
      *                                                                   CFT014
     C     GDMTAG        WHENEQ    ':55A:'                                      3rd Reim Inst  CFT01
     C     GDMTAG        OREQ      ':55B:'                                      3rd Reim Inst  CFT01
     C     GDMTAG        OREQ      ':55D:'                                      3rd Reim Inst  CFT01
     C                   MOVEL     P55           WUFDDT                                        CFT01
     C                   EXSR      #HFDDT                                                      CFT01
      *
     C     GDMTAG        WHENEQ    ':56A:'                                      Intermediary
     C     GDMTAG        OREQ      ':56C:'                                      Intermediary   CFT00
     C     GDMTAG        OREQ      ':56D:'                                      Intermediary
     C     GDMSEQ        IFEQ      'B'
     C     CSW209        ANDEQ     'Y'
     C                   MOVEL     PB56          WUFDDT
     C                   ELSE
     C                   MOVEL     P56           WUFDDT
     C                   ENDIF
     C                   EXSR      #HFDDT
      *
     C     GDMTAG        WHENEQ    ':57A:'                                      A/c with Inst
     C     GDMTAG        OREQ      ':57B:'                                      A/c with Inst
     C     GDMTAG        OREQ      ':57C:'                                      A/c with Inst  CFT00
     C     GDMTAG        OREQ      ':57D:'                                      A/c with Inst
     C     GDMTAG        OREQ      'BJ57D'                                      A/c with Inst
     C     GDMSEQ        IFEQ      'B'
     C     CSW209        ANDEQ     'Y'
     C                   MOVEL     PB57          WUFDDT
     C                   ELSE
     C                   MOVEL     P57           WUFDDT
     C                   ENDIF
     C                   EXSR      #HFDDT
      *
     C     GDMTAG        WHENEQ    ':58A:'                                      Beneficiary
     C     GDMTAG        OREQ      ':58D:'                                      Beneficiary Bank
     C     GDMTAG        OREQ      'BJ58D'                                      Beneficiary Bank
     C                   MOVEL     P58           WUFDDT
     C                   EXSR      #HFDDT
      *
     C     GDMTAG        WHENEQ    ':59: '                                      Beneficiary Cust
     C     GDMTAG        OREQ      ':59A:'                                      Beneficiary Cust CFT
     C     GDMTAG        OREQ      'BJ59D'                                      Beneficiary Cust
     C     GDMSEQ        IFEQ      'B'
     C     CSW209        ANDEQ     'Y'
     C                   MOVEL     PB59          WUFDDT
     C                   ELSE
     C                   MOVEL     P59           WUFDDT
     C                   ENDIF
     C                   EXSR      #HFDDT
      *
     C     GDMTAG        WHENEQ    ':72: '                                      Bank-bank info
     C     GDMTAG        OREQ      'BJ72 '                                      Bank-bank info
      *                                                                   CFT006
     C     GDMSEQ        IFEQ      'B'
     C     CSW209        ANDEQ     'Y'
     C                   MOVEL     PB72          WUFDDT
     C                   ELSE
     C     GDHDTG        IFEQ      'N'                                                         CFT00
     C                   MOVEL     P72           WUFDDT
     C                   ELSE                                                                  CFT00
     C                   MOVEL     PH72          WUFDDT                                        CFT00
     C                   ENDIF                                                                 CFT00
     C                   ENDIF
      *                                                                   CFT006
     C                   EXSR      #HFDDT
     C/COPY WNCPYSRC,ME1501C001
      *
     C     GDMTAG        WHENEQ    'SNDR '                                      Sender
     C                   MOVEL     PSN           WUFDDT
     C                   EXSR      #HFDDT
     C/COPY WNCPYSRC,ME1501C012
      *                                                                   CFT006
     C     GDMTAG        WHENEQ    ':21R:'                                      Cust ref       CFT00
      *                                                                   CFT006
     C     GDHDTG        IFEQ      'Y'                                                         CFT00
     C                   MOVEL     PH21R         WUFDDT                                        CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   EXSR      #HFDDT                                                      CFT00
      *                                                                   CFT006
     C     GDMTAG        WHENEQ    ':50L:'                                      Inst Party     CFT00
      *                                                                   CFT006
     C     GDHDTG        IFEQ      'N'                                                         CFT00
     C                   MOVEL     P50L          WUFDDT                                        CFT00
     C                   ELSE                                                                  CFT00
     C                   MOVEL     PH50L         WUFDDT                                        CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   EXSR      #HFDDT                                                      CFT00
      *                                                                   CFT006
     C     GDMTAG        WHENEQ    ':51A:'                                      Sending Ins    CFT00
      *                                                                   CFT006
     C     GDHDTG        IFEQ      'Y'                                                         CFT00
     C                   MOVEL     PH51A         WUFDDT                                        CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   EXSR      #HFDDT                                                      CFT00
      *                                                                   CFT006
     C     GDMTAG        WHENEQ    ':30: '                                      Exec date      CFT00
      *                                                                   CFT006
     C     GDHDTG        IFEQ      'Y'                                                         CFT00
     C                   MOVEL     PH30          WUFDDT                                        CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   EXSR      #HFDDT                                                      CFT00
      *                                                                   CFT006
     C     GDMTAG        WHENEQ    ':25: '                                      Authoris.      CFT00
      *                                                                   CFT006
     C     GDHDTG        IFEQ      'Y'                                                         CFT00
     C                   MOVEL     PH25          WUFDDT                                        CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   EXSR      #HFDDT                                                      CFT00
      *                                                                   CFT006
     C     GDMTAG        WHENEQ    ':21F:'                                      Fx Ref         CFT00
      *                                                                   CFT006
     C                   MOVEL     P21F          WUFDDT                                        CFT00
      *                                                                   CFT006
     C                   EXSR      #HFDDT                                                      CFT00
      *                                                                   CFT014
     C     GDMTAG        WHENEQ    ':23B:'                                      Bnk Op Cde     CFT01
      *                                                                   CFT014
     C                   MOVEL     P23B          WUFDDT                                        CFT01
      *                                                                   CFT014
     C                   EXSR      #HFDDT                                                      CFT01
      *                                                                   CFT006
     C     GDMTAG        WHENEQ    ':23E:'                                      Inst Code      CFT00
      *                                                                   CFT006
     C                   MOVEL     P23E          WUFDDT                                        CFT00
      *                                                                   CFT006
     C                   EXSR      #HFDDT                                                      CFT00
      *                                                                   CFT006
     C     GDMTAG        WHENEQ    ':77B:'                                      Reg Report.    CFT00
      *                                                                   CFT006
     C     GDHDTG        IFEQ      'N'                                                         CFT00
     C                   MOVEL     P77B          WUFDDT                                        CFT00
     C                   ELSE                                                                  CFT00
     C                   MOVEL     PH77B         WUFDDT                                        CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   EXSR      #HFDDT                                                      CFT00
      *                                                                   CFT006
     C     GDMTAG        WHENEQ    ':33B:'                                      Orig Amount    CFT00
     C     GDMSEQ        IFEQ      'B'
     C     CSW209        ANDEQ     'Y'
     C                   MOVEL     PB33B         WUFDDT
     C                   ELSE
     C                   MOVEL     P33B          WUFDDT                                        CFT00
     C                   ENDIF
     C                   EXSR      #H1AMT                                                      CFT00
      *                                                                   CFT006
     C     GDMTAG        WHENEQ    ':25A:'                                      Charges acc    CFT00
     C                   MOVEL     P25A          WUFDDT                                        CFT00
     C                   EXSR      #HFDDT                                                      CFT00
      *                                                                   CFT006
     C     GDMTAG        WHENEQ    ':36: '                                      Exchg Rate     CFT00
      *                                                                   CFT006
     C     GDHDTG        IFEQ      'N'                                                         CFT00
     C                   MOVEL     P36           WUFDDT                                        CFT00
     C                   ELSE                                                                  CFT00
     C                   MOVEL     PH36          WUFDDT                                        CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   EXSR      #HFDDT                                                      CFT00
      *                                                                   CFT006
     C     GDMTAG        WHENEQ    ':23: '                                      Bank Opcd      CFT00
      *                                                                   CFT006
     C     GDHDTG        IFEQ      'Y'                                                         CFT00
     C                   MOVEL     PH23          WUFDDT                                        CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   EXSR      #HFDDT                                                      CFT00
      *                                                                   CFT006
     C     GDMTAG        WHENEQ    ':26T:'                                      Trns Code      CFT00
      *                                                                   CFT006
     C     GDHDTG        IFEQ      'N'                                                         CFT00
     C                   MOVEL     P26T          WUFDDT                                        CFT00
     C                   ELSE                                                                  CFT00
     C                   MOVEL     PH26T         WUFDDT                                        CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   EXSR      #HFDDT                                                      CFT00
      *                                                                   CFT006
     C     GDMTAG        WHENEQ    ':71F:'                                      Sender Charg   CFT00
      *                                                                   CFT006
     C     GDHDTG        IFEQ      'N'                                                         CFT00
      ** FT field: Senders Charges can have multiples lines               CFT014
      ** (e.g. MT103)                                                     CFT014
     C     P71FX         IFEQ      *BLANK                                                      CFT01
     C                   MOVEL     P71F          WUFDDT                                        CFT00
     C                   ELSE                                                                  CFT01
     C                   MOVEL     P71FX         WUFDDT                                        CFT01
     C                   ENDIF                                                                 CFT01
     C                   ELSE                                                                  CFT00
     C                   MOVEL     PH71F         WUFDDT                                        CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   EXSR      #H1AMT                                                      CFT00
      *                                                                   CFT006
     C     GDMTAG        WHENEQ    ':71G:'                                      Recv Charg     CFT00
      *                                                                   CFT006
     C     GDHDTG        IFEQ      'N'                                                         CFT00
     C                   MOVEL     P71G          WUFDDT                                        CFT00
     C                   ELSE                                                                  CFT00
     C                   MOVEL     PH71G         WUFDDT                                        CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   EXSR      #H1AMT                                                      CFT00
      *                                                                   CRE008
     C     GDMTAG        WHENEQ    ':70: '                                      Det of Pay     CRE00
      *                                                                   CRE008
     C                   MOVEL     P70           WUFDDT                                        CRE00
      *                                                                   CRE008
     C                   EXSR      #HFDDT                                                      CRE00
      *                                                                                       CER030
     C     GDMTAG        WHENEQ    'PEXN'
      *                                                                                       CER030
     C     CER031        IFEQ      'Y'
     C                   MOVEL     PEXN          WUFDDT
     C                   EXSR      #HFDDT
     C                   ENDIF
      *                                                                   CFT006
     C     GDMTAG        WHENEQ    ':19: '                                      Sum Amt        CFT00
      *                                                                   CFT006
     C     GDHDTG        IFEQ      'Y'                                                         CFT00
     C                   MOVEL     PH19          WUFDDT                                        CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   EXSR      #HFDDT                                                      CFT00
      *                                                                   CFT006
     C     GDMTAG        WHENEQ    ':71:'                                       Detl of Chrge  CFT00
     C     GDMTAG        OREQ      ':71A:'                                      Detl of Chrge  CFT00
      *                                                                   CFT006
     C     GDHDTG        IFEQ      'N'                                                         CFT00
     C                   MOVEL     P71           WUFDDT                                        CFT00
     C                   ELSE                                                                  CFT00
     C                   MOVEL     PH71          WUFDDT                                        CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   EXSR      #HFDDT                                                      CFT00
      *
     C     GDMTAG        WHENEQ    ':70:'
     C     GDMSEQ        IFEQ      'B'
     C     CSW209        ANDEQ     'Y'
     C                   MOVEL     PB70          WUFDDT
     C                   ELSE
     C                   MOVEL     P70           WUFDDT
     C                   ENDIF
     C                   EXSR      #HFDDT
      *                                                                                     BUG24039
     C     GDMTAG        WHENEQ    '103:'
     C     CSW209        ANDEQ     'Y'
     C                   MOVEL     P103          WUFDDT
      *                                                                                       CSW209
     C                   EXSR      #HFDDT
      *                                                                                       CSW209
     C     GDMTAG        WHENEQ    '1:   '                                      Header Blk 1
     C     GDMTAG        OREQ      '2:   '                                      Header Blk 2
     C     GDMTAG        OREQ      '3:   '                                      Header Blk 3
     C     GDMTAG        OREQ      '4:   '                                      Header Blk 4
     C     GDMTAG        OREQ      '5:   '                                      Header Blk 5
     C     GDMTAG        OREQ      'BJ06 '                                      Authen'n Code
     C     GDMTAG        OREQ      'S:   '                                      Trailer Blk S
     C     GDMTAG        OREQ      'CHK: '                                      Checksum
     C     GDMTAG        OREQ      'COP: '                                      COP???
     C     GDMTAG        OREQ      'DLM: '                                      Delayed message
     C     GDMTAG        OREQ      'ENC: '                                      Encryption
     C     GDMTAG        OREQ      'MAC: '                                      Authen'n Code
     C     GDMTAG        OREQ      'PDE: '                                      Possible Dup.
     C     GDMTAG        OREQ      'PDM: '                                      Possible Dup.
     C     GDMTAG        OREQ      'QTA: '                                      Interruption
     C     GDMTAG        OREQ      'REJ: '                                      Rejection
     C     GDMTAG        OREQ      'RTV: '                                      Retrieved msg
     C     GDMTAG        OREQ      'SUP: '                                      Supervisor msg
     C     GDMTAG        OREQ      'SAB: '                                      Auth'n bypassed
     C     GDMTAG        OREQ      'SAC: '                                      Auth'n correct
     C     GDMTAG        OREQ      'SAI: '                                      Auth'n incorrec
     C     GDMTAG        OREQ      'SAO: '                                      Auth'n correct
     C     GDMTAG        OREQ      'SPD: '                                      Sys Poss Dup
     C     GDMTAG        OREQ      'SYS: '                                      Sys Originated
     C     GDMTAG        OREQ      'TNG: '                                      Training
     C     GDMTAG        OREQ      'TRN: '                                      Trans Ref
     C     GDMTAG        OREQ      'UND: '                                      Unroutable msg
     C     GDMTAG        OREQ      '11R: '                                      Original msg
     C     GDMTAG        OREQ      '11S: '                                      Original msg
     C     GDMTAG        OREQ      '108: '
     C     CSW209        ANDEQ     'Y'
     C     GDMTAG        OREQ      '113: '
     C     CSW209        ANDEQ     'Y'
     C     GDMTAG        OREQ      '115: '
     C     CSW209        ANDEQ     'Y'
     C     GDMTAG        OREQ      '119: '
     C     CSW209        ANDEQ     'Y'
     C                   Z-ADD     0             WKPART
     C     KYINDT        SETLL     MEINDTS2                               99
     C     *IN99         IFEQ      '1'
     C     KYINDT        READE     MEINDTS2                               99
     C     *IN99         IFEQ      '0'
     C     GDMTAG        IFEQ      '2:   '
     C                   MOVEL     DTMFLD        WUFDDT
     C                   ELSE
     C                   MOVEL     DSMF35        WUFDDT
     C                   ENDIF
     C                   MOVE      WUMTAG        HK3(H3)
     C                   MOVE      WUORIG        HK4(H3)
     C                   ENDIF
     C                   ELSE
     C                   MOVE      *BLANKS       WUFDDT
     C                   ENDIF
     C                   EXSR      #HFDDT
      *
     C                   OTHER                                                  Other details
     C     KYINDT        SETLL     MEINDTS2                               99
     C     *IN99         IFEQ      '1'
     C     KYINDT        READE     MEINDTS2                               99
     C     *IN99         IFEQ      '0'
     C     GDMTAG        IFEQ      '2:   '
     C                   MOVEL     DTMFLD        WUFDDT
     C                   ELSE
     C                   MOVEL     DSMF35        WUFDDT
     C                   ENDIF
     C                   MOVE      WUMTAG        HK5(H4)
     C                   MOVE      WUORIG        HK6(H4)
     C                   ENDIF
     C                   ENDIF
     C                   EXSR      #HFDDT
      *
     C                   ENDSL
      *
      *  If criteria not match, blank out Payment type
      *
     C     WUMATH        IFEQ      *BLANK
     C                   MOVE      *BLANKS       WUPYTP
     C                   MOVE      *BLANKS       WUPYST                                        CRE00
      *                                                                   CRE008
      *  and blank out P#RETV                                             CRE008
     C                   MOVE      *BLANKS       P@RETV                                        CRE00
      *                                                                   CRE008
      ** then log if required                                             CRE008
     C     GDREPT        IFEQ      'Y'                                                         CRE00
     C                   MOVE      *BLANKS       LGDTA                                         CRE00
     C                   MOVEL     GDMTPY        L#MTPY                                        CRE00
     C                   MOVEL     GDMSET        L#MSET                                        CRE00
     C                   MOVEL     GDCSEQ        L#CSEQ                                        CRE00
     C     L#CRIT        CAT       GDMTAG:0      L#CRIT                                        CRE00
     C                   CAT       GDOPER:1      L#CRIT                                        CRE00
     C                   CAT       GDCMP1:1      L#CRIT                                        CRE00
     C     GDCMP2        IFNE      *BLANK                                                      CRE00
     C                   CAT       'OR':1        L#CRIT                                        CRE00
     C                   CAT       GDCMP2:1      L#CRIT                                        CRE00
     C                   ENDIF                                                                 CRE00
     C     GDCMP3        IFNE      *BLANK                                                      CRE00
     C                   CAT       'OR':1        L#CRIT                                        CRE00
     C                   CAT       GDCMP3:1      L#CRIT                                        CRE00
     C                   ENDIF                                                                 CRE00
     C     GDCMP4        IFNE      *BLANK                                                      CRE00
     C                   CAT       'OR':1        L#CRIT                                        CRE00
     C                   CAT       GDCMP4:1      L#CRIT                                        CRE00
     C                   ENDIF                                                                 CRE00
     C     GDCMP5        IFNE      *BLANK                                                      CRE00
     C                   CAT       'OR':1        L#CRIT                                        CRE00
     C                   CAT       GDCMP5:1      L#CRIT                                        CRE00
     C                   ENDIF                                                                 CRE00
     C     GDCMP6        IFNE      *BLANK                                                      CRE00
     C                   CAT       'OR':1        L#CRIT                                        CRE00
     C                   CAT       GDCMP6:1      L#CRIT                                        CRE00
     C                   ENDIF                                                                 CRE00
     C                   MOVEL(P)  LGDTA         MEMSDT                                        CRE00
     C                   MOVEL     W0CPGM        MEPGMQ                                        CRE00
     C                   MOVEL     'MIN0507'     MEMSID                                        CRE00
     C                   MOVEL     'MEMSG'       MEMSGF                         Msg file       CRE00
     C                   EXSR      MESNMS                                                      CRE00
     C                   ENDIF                                                                 CRE00
      *                                                                   CRE008
     C                   ENDIF
      *
      *  Unwind subroutine stack name
      *
     C     #HXMAT        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  #HFDDT   : Validate Field Details                            *
      *                                                               *
      *  CALLED BY: MATCH                                             *
      *                                                               *
      *  CALLS    :                                                   *
      *                                                               *
      *****************************************************************
     CSR   #HFDDT        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     '#HFDDT'      @STK(Q)
      *
      *  Check criteria
      *
     C                   Z-ADD     1             H2                1 0
     C                   MOVEL     HK2(H2)       WUCRIT
      *
      *
     C     H2            DOWLE     WUCRNO
      *
     C     WUCRIT        IFNE      *BLANKS
      *
      *  General checking - no special value used
      *
     C     WUASTK        IFNE      '*'
      *
     C     WUACCO        IFEQ      WUCRIT
     C     WUORIG        OREQ      WUCRIT
     C                   MOVE      'Y'           WUMATH
     C                   ENDIF
      *
     C                   ELSE
      *
      *
      * Convert lower case to upper case in Compare Value name                                162380
     C     ' '           SCAN      WUFUNC        WLF                    90
     C     *IN90         IFEQ      '0'
     C     WLF           IFEQ      0
     C     WLF           ORGT      5
     C     LW:UP         XLATE     WUFUNC        WUFUNC
     C                   ELSE
     C                   SELECT
     C     WLF           WHENEQ    3
     C     LW:UP         XLATE     WUFUN2        WUFUN2
     C     WLF           WHENEQ    4
     C     LW:UP         XLATE     WUFUN3        WUFUN3
     C     WLF           WHENEQ    5
     C     LW:UP         XLATE     WUFUN4        WUFUN4
     C                   ENDSL
     C                   ENDIF
     C                   ENDIF
      *
     C                   SELECT
      *
      *
      * Test time that message was received
      *
      * If *TIME used then date is assumed to be system date
      * and not Midas Run date.
      *
     C     WUFUNC        WHENEQ    '*TIME'
      *
      * Get received date and time from control record
      *
     C     PHMSGR        CHAIN     @INCRL1                            90
      *
      * Construct Received time and date into YYMMDDHHMM00 format
      *
     C                   Z-ADD     CRMODE        RCDATE
      *
      * Y2K => Received time and date into CCYYMMDDHHMM00 format
     C                   MOVE      CRMDEC        RCCNTY
      *
     C                   Z-ADD     CRMOTM        RCTIME
     C                   Z-ADD     0             RCSECS
      *
      * Get System Date and time and place in CCYYMMDDHHMM00 format
      *
     C                   TIME                    SYDTTM           14 0
     C                   Z-ADD     SYDTTM        SYDATE
     C                   Z-ADD     WUHOUR        SYHOUR
     C                   Z-ADD     WUMINS        SYMINS
     C                   Z-ADD     0             SYSECS
      *
      * Test time against GT and LT only
      *
     C                   SELECT
     C     GDOPER        WHENEQ    'GT'
     C     RCCOMP        IFGT      SYCOMP
     C                   MOVE      'Y'           WUMATH
     C                   ENDIF
      *
     C     GDOPER        WHENEQ    'LT'
     C     RCCOMP        IFLT      SYCOMP
     C                   MOVE      'Y'           WUMATH
     C                   ENDIF
     C                   ENDSL
      *
     C     WUFUNC        WHENEQ    '*ACC '
     C     '/ACC/'       SCAN      WUORIG                                 90
     C     *IN90         IFEQ      '1'
     C                   MOVE      'Y'           WUMATH
     C                   ENDIF
      *
      * Test for //FW and /FW
      *
     C     WUFUNC        WHENEQ    '*FEDW'
     C                   MOVEL     WUORIG        ##003A
     C                   MOVEL     WUORIG        ##004A            4
     C     ##003A        IFEQ      '/FW'
     C     ##004A        OREQ      '//FW'
     C                   MOVE      'Y'           WUMATH
     C                   ENDIF
      *
      * Test for BIC Code Match (extact match)
      *
     C     WUFUNC        WHENEQ    '*BIC '
      *
      * Only check if network swift and type A flag
      *
     C     1             SUBST     GDMTAG:4      ##001A            1
     C     PNWRK         IFEQ      'SWIFT'
     C     ##001A        ANDEQ     'A'
     C     3             SUBST     WUCRIT:14     ##003A            3
     C     8             SUBST     WUCRIT:6      ##008A            8
     C     1             SUBST     WUORIG:1      ##001A
      *
      * If account line extract from second line
      *
     C     ##001A        IFEQ      '/'
     C     3             SUBST     WUORIG:44     ##003B            3
     C     8             SUBST     WUORIG:36     ##008B            8
     C                   ELSE
     C     3             SUBST     WUORIG:9      ##003B            3
     C     8             SUBST     WUORIG:1      ##008B            8
     C                   ENDIF
      *
      * Set match flag depending on contents
      *
     C                   SELECT
      *
      * Extact match
      *
     C     ##008A        WHENEQ    ##008B
     C     ##003A        ANDEQ     ##003B
     C                   MOVE      'Y'           WUMATH
      *
      * XXX in one but blanks in the other
      *
     C     ##008A        WHENEQ    ##008B
     C     ##003A        ANDEQ     *BLANKS
     C     ##003B        ANDEQ     'XXX'
     C     ##008A        OREQ      ##008B
     C     ##003A        ANDEQ     'XXX'
     C     ##003B        ANDEQ     *BLANKS
     C                   MOVE      'Y'           WUMATH
      *
      * xxx therefor on first 8 characters need match
      *
     C     ##008A        WHENEQ    ##008B
     C     ##003A        ANDEQ     'xxx'
     C                   MOVE      'Y'           WUMATH
     C                   ENDSL
     C                   ENDIF
      *
      * Test for Customer Number
      *
     C     WUFUNC        WHENEQ    '*CNUM'
     C********** WUCNUM    IFNE 0                                                             CSD027
     C     WUCNUM        IFNE      *BLANKS
     C     WUCNUA        ANDNE     *BLANKS
     C     6             SUBST     WUCRIT:7      ##006A            6
     C     WUCNUA        IFEQ      ##006A
     C                   MOVE      'Y'           WUMATH
     C                   ENDIF
     C                   ENDIF
      *
      * Test for Account is in message currency
      *
     C     WUFUNC        WHENEQ    '*MCCY'
     C     WUACCD        IFNE      *ZEROS
     C     WUACCA        ANDNE     *BLANK
     C     KYMPL1        CHAIN     @INMPL1                            90
     C     *IN90         IFEQ      '0'
     C     MPCYCD        ANDEQ     WUCURR
     C                   MOVE      'Y'           WUMATH
     C                   ENDIF
     C                   ENDIF
      *
      * Test for Account line specification
      *
     C     WUFUNC        WHENEQ    '*ACLN'
     C     1             SUBST     WUORIG:1      ##001A
     C     ##001A        IFEQ      '/'
     C                   MOVE      'Y'           WUMATH
     C                   ENDIF
      *
      * Test for Swift Bic on supplied Bic directory
      *
     C     WUFUNC        WHENEQ    '*SWFT'
     C     1             SUBST     WUORIG:1      ##001A
      *
      * No account line
      *
     C     WUORIG        IFNE      *BLANKS
     C     WUSWFT        ANDNE     *BLANKS
     C     WUNSWF        ANDEQ     *BLANKS
     C     ##001A        ANDNE     '/'
     C                   MOVEL     WUSWFT        BDBICC
     C                   MOVE      WUSWFT        BDBICB
     C     BDBICB        IFEQ      *BLANKS
     C                   MOVEL     'XXX'         BDBICB
     C                   ENDIF
     C     KYBICD        CHAIN     @BICDL2                            90
     C     *IN90         IFEQ      '0'
     C                   MOVE      'Y'           WUMATH
     C                   ENDIF
     C                   ENDIF
      *
      * If account line extract from second line
      *
     C     WUORIG        IFNE      *BLANKS
     C     ##001A        ANDEQ     '/'
     C     WUSWF2        ANDNE     *BLANKS
     C     WUNSW2        ANDEQ     *BLANKS
     C                   MOVEL     WUSWF2        BDBICC
     C                   MOVE      WUSWF2        BDBICB
     C     BDBICB        IFEQ      *BLANKS
     C                   MOVEL     'XXX'         BDBICB
     C                   ENDIF
     C     KYBICD        CHAIN     @BICDL2                            90
     C     *IN90         IFEQ      '0'
     C                   MOVE      'Y'           WUMATH
     C                   ENDIF
     C                   ENDIF
      *
      * Test to see if a Nostro
      *
     C     WUFUNC        WHENEQ    '*NOST'
      *
      * Find Nostro details
      *
     C                   CALL      'AONOSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      WUCNUA        @CUST             6
     C                   PARM      WUCURR        @CYCD             3
     C**********           PARM WUACCA    @ACCD   4                                           CGL029
     C                   PARM      WUACCA        @ACCD            10
     C                   PARM      WUACSA        @ACSN             2
     C                   PARM      *BLANKS       @NONB             2
     C                   PARM      WUBRCA        @BRCD             3
     C                   PARM      *BLANKS       @CSSN            10
     C                   PARM      *BLANKS       @PNOI             1
     C     SDNOST        PARM      *BLANKS       DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           WUMATH
     C                   END
      *
      * Check tags are the same
      *
     C     WUFUNC        WHENEQ    '*TAGD'
     C     5             SUBST     WUCODE:2      ##005A            5
     C                   MOVEL     *BLANKS       WCFDDT
     C/COPY WNCPYSRC,ME1501C006
      *
      * Get data of tag specified
      *
     C                   SELECT
     C     ##005A        WHENEQ    ':50: '                                      Ord Cust
     C                   MOVEL     P50           WCFDDT
      *
     C     ##005A        WHENEQ    ':52A:'                                      Ord Bank
     C                   MOVEL     P52           WCFDDT
      *
     C     ##005A        WHENEQ    ':53A:'                                      Sndr Corr
     C                   MOVEL     P53           WCFDDT
      *
     C     ##005A        WHENEQ    ':54A:'                                      Rcvr Corr
     C                   MOVEL     P54           WCFDDT
      *
     C     ##005A        WHENEQ    ':56A:'                                      Intermediary
     C                   MOVEL     P56           WCFDDT
      *
     C     ##005A        WHENEQ    ':57A:'                                      A/c with Inst
     C                   MOVEL     P57           WCFDDT
      *
     C     ##005A        WHENEQ    ':58A:'                                      Beneficiary
     C                   MOVEL     P58           WCFDDT
      *
     C     ##005A        WHENEQ    ':59: '                                      Beneficiary Cust
     C                   MOVEL     P59           WCFDDT
      *
     C     ##005A        WHENEQ    ':72: '                                      Bank-bank info
     C                   MOVEL     P72           WCFDDT
     C/COPY WNCPYSRC,ME1501C002
      *
     C     ##005A        WHENEQ    'SNDR '                                      Sender
     C                   MOVEL     PSN           WCFDDT
     C                   ENDSL
     C/COPY WNCPYSRC,ME1501C007
      *
      * if customer numbers or data is the same set the match field
      *
     C********** WUCNUM    IFNE *ZEROS                                                        CSD027
     C     WUCNUM        IFNE      *BLANKS
     C     WUCNUA        ANDNE     *BLANKS
     C     WCCNUM        ANDNE     *ZEROS
     C     WCCNUA        ANDNE     *BLANKS
     C     WUCNUA        ANDEQ     WCCNUA
     C     WUORIG        OREQ      WCORIG
     C     WCORIG        ANDNE     *BLANKS
     C     WUORIG        ANDNE     *BLANKS
     C                   MOVE      'Y'           WUMATH
     C                   ENDIF
      *
     C     WUFUNC        WHENEQ    '*A/C '
     C     KYACCO        CHAIN     ACCNTABF                           90
     C     *IN90         IFEQ      '0'
     C     RECI          ANDEQ     'D'
     C                   MOVE      'Y'           WUMATH
     C                   ENDIF
      *
     C     WUFUNC        WHENEQ    '*BANK'
     C********** WUCNUM    IFNE *ZEROS                                                        CSD027
     C     WUCNUM        IFNE      *BLANKS
     C     WUCNUA        ANDNE     *BLANKS
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      WUCNUA        @KEY1            10
     C                   PARM      *BLANK        @KYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
     C     BBBNBI        IFEQ      'Y'
     C                   MOVE      'Y'           WUMATH
     C                   ENDIF
     C                   ENDIF
      *
     C     WUFUNC        WHENEQ    '*BICN'
     C********** WUCNUM    IFNE *ZEROS                                                        CSD027
     C     WUCNUM        IFNE      *BLANKS
     C     WUCNUA        ANDNE     *BLANKS
     C     WUCNUA        CHAIN     SDBRCHL5                           90
     C     *IN90         IFEQ      '0'
     C                   MOVE      'Y'           WUMATH
     C                   ENDIF
     C                   ENDIF
      *
     C     WUFUNC        WHENEQ    '*BOJ '
     C********** WUCNUM    IFNE *ZEROS                                                        CSD027
     C     WUCNUM        IFNE      *BLANKS
     C     WUCNUA        ANDNE     *BLANKS
      *
      * /COPY for BOJ Extension file check
      *
      *COPY WNCPYSRC, MEH022CBOJ
     C     BBBFIC        IFEQ      'Y'
     C                   MOVE      'Y'           WUMATH
     C                   ENDIF
     C                   ENDIF
      *
     C     WUFUNC        WHENEQ    '*CCY '
     C     WUCODE        IFEQ      WUCURR
     C                   MOVE      'Y'           WUMATH
     C                   ENDIF
      *
     C     WUFUNC        WHENEQ    '*CUST'
     C********** WUCNUM    IFNE *ZEROS                                                        CSD027
     C     WUCNUM        IFNE      *BLANKS
     C     WUCNUA        ANDNE     *BLANKS
     C                   MOVE      'Y'           WUMATH
     C                   ENDIF
      *
     C     WUFUNC        WHENEQ    '*GRP '
     C********** WUCNUM    IFNE *ZEROS                                                        CSD027
     C     WUCNUM        IFNE      *BLANKS
     C     WUCNUA        ANDNE     *BLANKS
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      WUCNUA        @KEY1            10
     C                   PARM      *BLANK        @KYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
     C     BBBSIN        IFNE      *BLANKS
     C                   MOVE      'Y'           WUMATH
     C                   ENDIF
     C                   ENDIF
      *
     C     WUFUNC        WHENEQ    '*LCCY'
     C     BJLCCY        IFEQ      WUCURR
     C                   MOVE      'Y'           WUMATH
     C                   ENDIF
      *
     C     WUFUNC        WHENEQ    '*LOC '
     C********** WUCNUM    IFNE *ZEROS                                                        CSD027
     C     WUCNUM        IFNE      *BLANKS
     C     WUCNUA        ANDNE     *BLANKS
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      WUCNUA        @KEY1            10
     C                   PARM      *BLANK        @KYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
     C     BBLCCD        IFEQ      WUCODE
     C                   MOVE      'Y'           WUMATH
     C                   ENDIF
     C                   ENDIF
      *
     C     WUFUNC        WHENEQ    '*NONE'
     C     WKPART        IFEQ      *LOVAL
     C     WUTGVL        IFEQ      *BLANKS
     C                   MOVE      'Y'           WUMATH
     C                   ENDIF
     C                   ELSE
      ** Tag value has been retrieved in file MEINDTS2
     C     WUFDDT        IFEQ      *BLANKS
     C                   MOVE      'Y'           WUMATH
     C                   ENDIF
     C                   ENDIF
      *
     C     WUFUNC        WHENEQ    '*REC '
     C     '/REC/'       SCAN      WUORIG                                 90
     C     *IN90         IFEQ      '1'
     C                   MOVE      'Y'           WUMATH
     C                   ENDIF
      *
     C     WUFUNC        WHENEQ    '*RETL'
     C     KYACCO        CHAIN     ACCNTABF                           90
     C     *IN90         IFEQ      '0'
     C     RECI          ANDEQ     'D'
     C     ATYP          ANDEQ     'R'
     C                   MOVE      'Y'           WUMATH
     C                   ENDIF
      *
     C     WUFUNC        WHENEQ    '*SEND'
     C                   MOVEL     PSN           U1W12A           12
     C**********           MOVE U1W12A    U1W6N   60                                          CSD027
     C                   MOVE      U1W12A        U1W6N             6
     C                   MOVE      U1W12A        U1W6A             6
     C     WUCNUM        IFEQ      U1W6N
     C     WUCNUA        ANDNE     *BLANKS
     C     U1W6A         ANDNE     *BLANKS
     C                   MOVE      'Y'           WUMATH
     C                   ENDIF
      *
     C     WUFUNC        WHENEQ    '*VOST'
     C     WUACCD        IFNE      *ZEROS
     C     WUACCA        ANDNE     *BLANK
     C     WUACCD        LOOKUP    HK1                                    63
     C     *IN63         IFEQ      '1'
     C     KYACCO        CHAIN     ACCNTABF                           90
     C     *IN90         IFEQ      '0'
     C     RECI          ANDEQ     'D'
     C                   MOVE      'Y'           WUMATH
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Process function *STRxxx   where xxx = 000,...,999
     C     WUFUN4        WHENEQ    '*STR'
     C     WUMTAG        ANDNE     *BLANK
     C                   EXSR      STRFNC
      *                                                                                      CFT004
      * Check if this is IBAN number                                                         CFT004
     C     WUFUN7        WHENEQ    '*IBAN  '
     C     CFT004        ANDEQ     'Y'
     C     1             SUBST     WUORIG:1      ##001A
     C     2             SUBST     WUORIG:2      ##002A            2
      * Caracter 2 & 3 must be a valid ISO country code                                      CFT004
     C     ##002A        CHAIN     SDCTRYL2                           90
     C     ##001A        IFEQ      '/'
     C     *IN90         ANDEQ     *OFF
     C                   MOVE      'Y'           WUMATH
     C                   ENDIF
      *                                                                                      CFT004
      * Test for a 'bad' IBAN                                                                CFT004
     C     WUFUN7        WHENEQ    '*IBANF '
     C     CFT004        ANDEQ     'Y'
     C     1             SUBST     WUORIG:1      ##001A
     C     2             SUBST     WUORIG:2      ##002A            2
     C     34            SUBST     WUORIG:2      P@IBN1           34
      * Character 2 & 3 must be a valid ISO country code                                     CFT004
     C     ##002A        CHAIN     SDCTRYL2                           90
     C     ##001A        IFEQ      '/'
     C     *IN90         ANDEQ     *OFF
      * Check Valid External IBAN                                                            CFT004
     C                   CALL      'AOIBANR5'
     C                   PARM                    @RTCD
     C                   PARM                    P@IBN1                         I:IBAN
      *                                                                                      CFT004
      * If IBAN is invalid set WUMATH to 'Y'                                                 CFT004
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'Y'           WUMATH
     C                   ENDIF
     C                   ENDIF
      * Test if IBAN is equal to the value specified in criteria                             CFT004
     C     WUFUN6        WHENEQ    '*IBANV'
     C     CFT004        ANDEQ     'Y'
     C     34            SUBST     WUORIG:2      P@IBN1
     C     P@IBN1        IFEQ      WIBANV
     C                   MOVE      'Y'           WUMATH
     C                   ENDIF
      *                                                                                      CFT004
      * Test if the IBAN is a valid MIDAS account                                            CFT004
     C     WUFUN7        WHENEQ    '*IBANAC'
     C     CFT004        ANDEQ     'Y'
     C     34            SUBST     WUORIG:2      P@IBN1
     C                   CALL      'AOIBANR4'
     C                   PARM                    @RTCD
     C                   PARM      '*VERIFY'     @OPTN                          I:Option
     C                   PARM                    P@IBN1                         I:IBAN
     C                   PARM                    DSSDY
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           WUMATH
     C                   ENDIF
      *
      *                                                                   CFT007
      * 'Special Function' is *BICP and BIC DB+ Integration is on         CFT007
      *                                                                   CFT007
     C     WUFUNC        WHENEQ    '*BICP'                                                     CFT00
     C     CFT007        ANDEQ     *ON                                                         CFT00
      *                                                                   CFT007
     C                   MOVE      GDMTAG        WUFLOP            2                           CFT00
     C                   MOVEL     WUFLOP        @IOPTN                                        CFT00
      *                                                                   CFT007
     C     @IOPTN        IFNE      'A'                                                         CFT00
     C     @IOPTN        ANDNE     'B'                                                         CFT00
     C     @IOPTN        ANDNE     'C'                                                         CFT00
     C     @IOPTN        ANDNE     'D'                                                         CFT00
     C                   MOVE      *BLANKS       @IOPTN                                        CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT007
      * Determine the currency of the message                             CFT007
      *                                                                   CFT007
     C                   MOVEL     PDCA          DSTRAN                                        CFT00
     C                   MOVE      TVCCY         @ICCY                                         CFT00
     C                   MOVEL     WUTGCK        @ITGVL                                        CFT00
      *                                                                   CFT007
      * Call the BIC Plus repair program                                  CFT007
      *                                                                   CFT007
     C                   CALL      'ME1610'                                                    CFT00
     C                   PARM                    @ITGVL          251                           CFT00
     C                   PARM                    @IOPTN            1                           CFT00
     C                   PARM                    @ICCY             3                           CFT00
     C                   PARM      *BLANK        @ORPFL          251                           CFT00
     C                   PARM      *BLANK        @ORTCD            7                           CFT00
      *                                                                   CFT007
     C     @ORTCD        IFEQ      '*MAP'                                                      CFT00
     C                   MOVE      'Y'           WUMATH                                        CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT007
      *                                                                   CFT007
      ** Process function CHK (user defined)
      ** TO BE PROCESSED ONLY IF NO OTHER HARD CODED FUNCTIONS
      ** WERE FOUND
     C                   OTHER
     C                   EXSR      SRUCHK
      *
     C                   ENDSL
     C                   ENDIF
     C                   ENDIF
      *
     C                   ADD       1             H2
     C     H2            IFLE      WUCRNO
     C                   MOVEL     HK2(H2)       WUCRIT
     C                   ENDIF
     C                   ENDDO
      *
      *  In case of negation, reverse the result
      *
     C     GDOPER        IFEQ      'NE'
     C     WUMATH        IFEQ      'Y'
     C                   MOVE      *BLANK        WUMATH
     C                   ELSE
     C                   MOVE      'Y'           WUMATH
     C                   ENDIF
     C                   ENDIF
      *
      *  Unwind subroutine stack name
      *
     C     #HXFDD        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  #H1AMT   : Validate the First Amount                         *
      *                                                               *
      *  CALLED BY: MATCH                                             *
      *                                                               *
      *  CALLS    :                                                   *
      *                                                               *
      *****************************************************************
     CSR   #H1AMT        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     '#H1AMT'      @STK(Q)
      *
      *  Check criteria
      *
     C                   Z-ADD     1             H2
     C                   MOVEL     HK2(H2)       WUCRIT
      *
      *
     C     H2            DOWLE     WUCRNO
      *
     C     WUCRIT        IFNE      *BLANKS
      *
      *  General checking - no special value used
      *
     C     WUASTK        IFNE      '*'
     C     WUORIG        IFEQ      WUCRIT
     C                   MOVE      'Y'           WUMATH
     C                   ENDIF
      *
     C                   ELSE
      *
      *
      * Convert lower case to upper case in Compare Value name                                162380
     C     ' '           SCAN      WUFUNC        WLF                    90
     C     *IN90         IFEQ      '0'
     C     WLF           IFEQ      0
     C     WLF           ORGT      5
     C     LW:UP         XLATE     WUFUNC        WUFUNC
     C                   ELSE
     C                   SELECT
     C     WLF           WHENEQ    3
     C     LW:UP         XLATE     WUFUN2        WUFUN2
     C     WLF           WHENEQ    4
     C     LW:UP         XLATE     WUFUN3        WUFUN3
     C     WLF           WHENEQ    5
     C     LW:UP         XLATE     WUFUN4        WUFUN4
     C                   ENDSL
     C                   ENDIF
     C                   ENDIF
      *                                                                   CFT006
     C     GDMTAG        IFEQ      ':32B:'                                                     CFT00
     C     GDMTAG        OREQ      ':33B:'                                                     CFT00
     C     GDMTAG        OREQ      ':71F:'                                                     CFT00
     C     GDMTAG        OREQ      ':71G:'                                                     CFT00
      *                                                                   CFT006
      *  Reformat into ccy/amount                                         CFT006
      *                                                                   CFT006
     C                   MOVEL     WUORIG        TTCA                                          CFT00
      *                                                                   CFT006
     C                   ELSE                                                                  CFT00
      *
      *  Reformat into date/ccy/amount
      *
     C                   MOVEL     WUORIG        TVDCA
      *
      *  Turn date into Midas date format
      *
     C     WUDFF         IFEQ      'M'
      * MMDDYY Format
     C                   MOVEL     TVVDAT        SWDT
     C                   MOVE      SDD           DD                2 0
     C                   MOVE      SYY           SDD
     C                   MOVE      SMM           SYY
     C                   MOVE      DD            SMM
     C                   MOVE      SWDT          WUSLDT            6 0
     C                   ELSE
      * DDMMYY Format
     C                   MOVEL     TVVDAT        SWDT
     C                   MOVE      SDD           DD
     C                   MOVE      SYY           SDD
     C                   MOVE      DD            SYY
     C                   MOVE      SWDT          WUSLDT
     C                   ENDIF
      *
     C                   MOVE      WUSLDT        ZDATE
     C                   EXSR      ZDATE1
     C                   Z-ADD     ZDAYNO        WUSLDN            5 0
      *                                                                   CFT006
     C                   ENDIF                                                                 CFT00
      *
     C                   SELECT
      *
      * Test for curreny is in message currency
      *
     C     WUFUNC        WHENEQ    '*MCCY'
     C     KYMPL1        CHAIN     @INMPL1                            90
      *                                                                   CFT006
     C     GDMTAG        IFEQ      ':32B:'                                                     CFT00
     C     GDMTAG        OREQ      ':33B:'                                                     CFT00
     C     GDMTAG        OREQ      ':71F:'                                                     CFT00
     C     GDMTAG        OREQ      ':71G:'                                                     CFT00
      *                                                                   CFT006
     C     *IN90         IFEQ      *OFF                                                        CFT00
     C     MPCYCD        ANDEQ     TTCCY                                                       CFT00
     C                   MOVE      'Y'           WUMATH                                        CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   ELSE                                                                  CFT00
      *                                                                   CFT006
     C     *IN90         IFEQ      '0'
     C     MPCYCD        ANDEQ     TVCCY
     C                   MOVE      'Y'           WUMATH
     C                   ENDIF
      *                                                                   CFT006
     C                   ENDIF                                                                 CFT00
      *
      *  Date checking
      *
     C     WUFUNC        WHENEQ    '*TODY'
      *
     C     GDMTAG        IFNE      ':32B:'                                                     CFT00
     C     GDMTAG        ANDNE     ':33B:'                                                     CFT00
     C     GDMTAG        ANDNE     ':71F:'                                                     CFT00
     C     GDMTAG        ANDNE     ':71G:'                                                     CFT00
      *                                                                   CFT006
     C                   SELECT
     C     GDOPER        WHENEQ    'EQ'
     C     GDOPER        OREQ      'NE'
     C     WUSLDN        IFEQ      WURDNB
     C                   MOVE      'Y'           WUMATH
     C                   ENDIF
     C     GDOPER        WHENEQ    'GT'
     C     WUSLDN        IFGT      WURDNB
     C                   MOVE      'Y'           WUMATH
     C                   ENDIF
     C     GDOPER        WHENEQ    'GE'
     C     WUSLDN        IFGE      WURDNB
     C                   MOVE      'Y'           WUMATH
     C                   ENDIF
     C     GDOPER        WHENEQ    'LT'
     C     WUSLDN        IFLT      WURDNB
     C                   MOVE      'Y'           WUMATH
     C                   ENDIF
     C     GDOPER        WHENEQ    'LE'
     C     WUSLDN        IFLE      WURDNB
     C                   MOVE      'Y'           WUMATH
     C                   ENDIF
     C                   ENDSL
      *                                                                   CFT006
     C                   ENDIF                                                                 CFT00
      *
      *  Ccy checking
      *
     C     WUFUNC        WHENEQ    '*CCY '
      *                                                                   CFT006
     C     GDMTAG        IFEQ      ':32B:'                                                     CFT00
     C     GDMTAG        OREQ      ':33B:'                                                     CFT00
     C     GDMTAG        OREQ      ':71F:'                                                     CFT00
     C     GDMTAG        OREQ      ':71G:'                                                     CFT00
      *                                                                   CFT006
     C     WUCODE        IFEQ      TTCCY                                                       CFT00
     C                   MOVE      'Y'           WUMATH                                        CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   ELSE                                                                  CFT00
      *                                                                   CFT006
     C     WUCODE        IFEQ      TVCCY
     C                   MOVE      'Y'           WUMATH
     C                   ENDIF
      *                                                                   CFT006
     C                   ENDIF                                                                 CFT00
      *
     C     WUFUNC        WHENEQ    '*LCCY'
      *                                                                   CFT006
     C     GDMTAG        IFEQ      ':32B:'                                                     CFT00
     C     GDMTAG        OREQ      ':33B:'                                                     CFT00
     C     GDMTAG        OREQ      ':71F:'                                                     CFT00
     C     GDMTAG        OREQ      ':71G:'                                                     CFT00
      *                                                                   CFT006
     C     BJLCCY        IFEQ      TTCCY                                                       CFT00
     C                   MOVE      'Y'           WUMATH                                        CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   ELSE                                                                  CFT00
      *                                                                   CFT006
     C     BJLCCY        IFEQ      TVCCY
     C                   MOVE      'Y'           WUMATH
     C                   ENDIF
      *                                                                   CFT006
     C                   ENDIF                                                                 CFT00
      *
      *  Working day checking (Ccy + date checking)
      *
      *
      *  Local ccy working day
      *
     C     WUFUNC        WHENEQ    '*LWKD'
      *                                                                   CFT006
     C     GDMTAG        IFNE      ':32B:'                                                     CFT00
     C     GDMTAG        ANDNE     ':33B:'                                                     CFT00
     C     GDMTAG        ANDNE     ':71F:'                                                     CFT00
     C     GDMTAG        ANDNE     ':71G:'                                                     CFT00
      *                                                                   CFT006
     C                   MOVE      BJLCCY        ZCCY
     C                   MOVE      *BLANKS       ZLOC
     C                   EXSR      ZCHKH
     C     ZIND          IFNE      'H'
     C                   MOVE      'Y'           WUMATH
     C                   ENDIF
      *                                                                   CFT006
     C                   ENDIF                                                                 CFT00
      *
      *  Transaction ccy working day
      *
     C     WUFUNC        WHENEQ    '*CWKD'
      *                                                                   CFT006
     C     GDMTAG        IFNE      ':32B:'                                                     CFT00
     C     GDMTAG        ANDNE     ':33B:'                                                     CFT00
     C     GDMTAG        ANDNE     ':71F:'                                                     CFT00
     C     GDMTAG        ANDNE     ':71G:'                                                     CFT00
      *                                                                   CFT006
     C                   MOVE      TVCCY         ZCCY
     C                   MOVE      *BLANKS       ZLOC
     C                   EXSR      ZCHKH
     C     ZIND          IFNE      'H'
     C                   MOVE      'Y'           WUMATH
     C                   ENDIF
      *                                                                   CFT006
     C                   ENDIF                                                                 CFT00
      *
      *
      ** Process function *STRxxx   where xxx = 000,...,999
     C     WUFUN4        WHENEQ    '*STR'
     C     WUMTAG        ANDNE     *BLANK
     C                   EXSR      STRFNC
      *
      ** Process function CHK (user defined)
      ** TO BE PROCESSED ONLY IF NO OTHER HARD CODED FUNCTIONS
      ** WERE FOUND
     C                   OTHER
     C                   EXSR      SRUCHK
      *
     C                   ENDSL
     C                   ENDIF
     C                   ENDIF
      *
     C                   ADD       1             H2
     C     H2            IFLE      WUCRNO
     C                   MOVEL     HK2(H2)       WUCRIT
     C                   ENDIF
     C                   ENDDO
      *
      *  In case of negation, reverse the result
      *
     C     GDOPER        IFEQ      'NE'
     C     WUMATH        IFEQ      'Y'
     C                   MOVE      *BLANK        WUMATH
     C                   ELSE
     C                   MOVE      'Y'           WUMATH
     C                   ENDIF
     C                   ENDIF
      *
      *  Unwind subroutine stack name
      *
     C     #HX1AM        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  #HAUDT   : Produce audit list                                *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *  CALLS    :        -                                          *
      *                                                               *
      *****************************************************************
     CSR   #HAUDT        BEGSR
     C     CSW209        IFEQ      'Y'
     C                   MOVEL     *BLANKS       WMSEQ
     C                   ENDIF
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     '#HAUDT'      @STK(Q)
      *
      * Open printer file
      *
     C                   OPEN      ME1501P1
      *
      *  Write Report Header
      *
     C                   WRITE     HEADER
      *
      *  Write Message Header
      *
     C                   WRITE     MSGHDR
     C/COPY WNCPYSRC,ME1501C008
      *                                                                   CFT006
      *  Sum of Amounts - Header (if there is any)                        CFT006
      *                                                                   CFT006
     C     PH19          IFNE      *BLANKS                                                     CFT00
     C                   MOVEL     *BLANKS       WUFDDT                                        CFT00
     C                   MOVEL     PH19          WUFDDT                                        CFT00
     C                   MOVEL     WUMTAG        HPRTG                                         CFT00
     C                   MOVEL     WUACCO        HPRDT                                         CFT00
     C                   MOVEL     WUORIG        HPROR1                                        CFT00
     C                   MOVE      WUORIG        HPROR2                                        CFT00
     C***********KYDESC    CHAIN@EFREJ4              99            CFT006 CFT014
     C                   EXSR      RTVTGD                                                      CFT01
     C     *IN99         IFEQ      *OFF                                                        CFT00
     C                   MOVEL     EFSCFD        HPRDS                                         CFT00
     C                   ELSE                                                                  CFT00
     C                   MOVEL     *BLANKS       HPRDS                                         CFT00
     C                   ENDIF                                                                 CFT00
     C     HPROR1        IFNE      *BLANKS                                                     CFT00
     C                   MOVE      *ON           *IN51                                         CFT00
     C                   ENDIF                                                                 CFT00
     C     HPROR2        IFNE      *BLANKS                                                     CFT00
     C                   MOVE      *ON           *IN52                                         CFT00
     C                   ENDIF                                                                 CFT00
     C                   WRITE     MSGDTL                                                      CFT00
      *                                                                   CFT006
     C     *IN25         IFEQ      *ON                                                         CFT00
     C                   WRITE     HEADER                                                      CFT00
     C                   MOVE      *OFF          *IN25                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   MOVE      *OFF          *IN51                                         CFT00
     C                   MOVE      *OFF          *IN52                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
      *  Transaction Reference - Header (if there is any)                 CFT006
      *                                                                   CFT006
     C     PH20          IFNE      *BLANKS                                                     CFT00
     C                   MOVEL     *BLANKS       WUFDDT                                        CFT00
     C                   MOVEL     PH20          WUFDDT                                        CFT00
     C                   MOVEL     WUMTAG        HPRTG                                         CFT00
     C                   MOVEL     WUACCO        HPRDT                                         CFT00
     C                   MOVEL     WUORIG        HPROR1                                        CFT00
     C                   MOVE      WUORIG        HPROR2                                        CFT00
     C***********KYDESC    CHAIN@EFREJ4              99            CFT006 CFT014
     C                   EXSR      RTVTGD                                                      CFT01
     C     *IN99         IFEQ      *OFF                                                        CFT00
     C                   MOVEL     EFSCFD        HPRDS                                         CFT00
     C                   ELSE                                                                  CFT00
     C                   MOVEL     *BLANKS       HPRDS                                         CFT00
     C                   ENDIF                                                                 CFT00
     C     HPROR1        IFNE      *BLANKS                                                     CFT00
     C                   MOVE      *ON           *IN51                                         CFT00
     C                   ENDIF                                                                 CFT00
     C     HPROR2        IFNE      *BLANKS                                                     CFT00
     C                   MOVE      *ON           *IN52                                         CFT00
     C                   ENDIF                                                                 CFT00
     C                   WRITE     MSGDTL                                                      CFT00
      *                                                                   CFT006
     C     *IN25         IFEQ      *ON                                                         CFT00
     C                   WRITE     HEADER                                                      CFT00
     C                   MOVE      *OFF          *IN25                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   MOVE      *OFF          *IN51                                         CFT00
     C                   MOVE      *OFF          *IN52                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
      *  Customer Reference - Header (if there is any)                    CFT006
      *                                                                   CFT006
     C     PH21R         IFNE      *BLANKS                                                     CFT00
     C                   MOVEL     *BLANKS       WUFDDT                                        CFT00
     C                   MOVEL     PH21R         WUFDDT                                        CFT00
     C                   MOVEL     WUMTAG        HPRTG                                         CFT00
     C                   MOVEL     WUACCO        HPRDT                                         CFT00
     C                   MOVEL     WUORIG        HPROR1                                        CFT00
     C                   MOVE      WUORIG        HPROR2                                        CFT00
     C***********KYDESC    CHAIN@EFREJ4              99            CFT006 CFT014
     C                   EXSR      RTVTGD                                                      CFT01
     C     *IN99         IFEQ      *OFF                                                        CFT00
     C                   MOVEL     EFSCFD        HPRDS                                         CFT00
     C                   ELSE                                                                  CFT00
     C                   MOVEL     *BLANKS       HPRDS                                         CFT00
     C                   ENDIF                                                                 CFT00
     C     HPROR1        IFNE      *BLANKS                                                     CFT00
     C                   MOVE      *ON           *IN51                                         CFT00
     C                   ENDIF                                                                 CFT00
     C     HPROR2        IFNE      *BLANKS                                                     CFT00
     C                   MOVE      *ON           *IN52                                         CFT00
     C                   ENDIF                                                                 CFT00
     C                   WRITE     MSGDTL                                                      CFT00
      *                                                                   CFT006
     C     *IN25         IFEQ      *ON                                                         CFT00
     C                   WRITE     HEADER                                                      CFT00
     C                   MOVE      *OFF          *IN25                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   MOVE      *OFF          *IN51                                         CFT00
     C                   MOVE      *OFF          *IN52                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
      *  Bank Operation Code - Header (if there is any)                   CFT006
      *                                                                   CFT006
     C     PH23          IFNE      *BLANKS                                                     CFT00
     C                   MOVEL     *BLANKS       WUFDDT                                        CFT00
     C                   MOVEL     PH23          WUFDDT                                        CFT00
     C                   MOVEL     WUMTAG        HPRTG                                         CFT00
     C                   MOVEL     WUACCO        HPRDT                                         CFT00
     C                   MOVEL     WUORIG        HPROR1                                        CFT00
     C                   MOVE      WUORIG        HPROR2                                        CFT00
     C***********KYDESC    CHAIN@EFREJ4              99            CFT006 CFT014
     C                   EXSR      RTVTGD                                                      CFT01
     C     *IN99         IFEQ      *OFF                                                        CFT00
     C                   MOVEL     EFSCFD        HPRDS                                         CFT00
     C                   ELSE                                                                  CFT00
     C                   MOVEL     *BLANKS       HPRDS                                         CFT00
     C                   ENDIF                                                                 CFT00
     C     HPROR1        IFNE      *BLANKS                                                     CFT00
     C                   MOVE      *ON           *IN51                                         CFT00
     C                   ENDIF                                                                 CFT00
     C     HPROR2        IFNE      *BLANKS                                                     CFT00
     C                   MOVE      *ON           *IN52                                         CFT00
     C                   ENDIF                                                                 CFT00
     C                   WRITE     MSGDTL                                                      CFT00
      *                                                                   CFT006
     C     *IN25         IFEQ      *ON                                                         CFT00
     C                   WRITE     HEADER                                                      CFT00
     C                   MOVE      *OFF          *IN25                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   MOVE      *OFF          *IN51                                         CFT00
     C                   MOVE      *OFF          *IN52                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
      *  Authorisation - Header (if there is any)                         CFT006
      *                                                                   CFT006
     C     PH25          IFNE      *BLANKS                                                     CFT00
     C                   MOVEL     *BLANKS       WUFDDT                                        CFT00
     C                   MOVEL     PH25          WUFDDT                                        CFT00
     C                   MOVEL     WUMTAG        HPRTG                                         CFT00
     C                   MOVEL     WUACCO        HPRDT                                         CFT00
     C                   MOVEL     WUORIG        HPROR1                                        CFT00
     C                   MOVE      WUORIG        HPROR2                                        CFT00
     C***********KYDESC    CHAIN@EFREJ4              99            CFT006 CFT014
     C                   EXSR      RTVTGD                                                      CFT01
     C     *IN99         IFEQ      *OFF                                                        CFT00
     C                   MOVEL     EFSCFD        HPRDS                                         CFT00
     C                   ELSE                                                                  CFT00
     C                   MOVEL     *BLANKS       HPRDS                                         CFT00
     C                   ENDIF                                                                 CFT00
     C     HPROR1        IFNE      *BLANKS                                                     CFT00
     C                   MOVE      *ON           *IN51                                         CFT00
     C                   ENDIF                                                                 CFT00
     C     HPROR2        IFNE      *BLANKS                                                     CFT00
     C                   MOVE      *ON           *IN52                                         CFT00
     C                   ENDIF                                                                 CFT00
     C                   WRITE     MSGDTL                                                      CFT00
      *                                                                   CFT006
     C     *IN25         IFEQ      *ON                                                         CFT00
     C                   WRITE     HEADER                                                      CFT00
     C                   MOVE      *OFF          *IN25                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   MOVE      *OFF          *IN51                                         CFT00
     C                   MOVE      *OFF          *IN52                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
      *  Transaction Type Code - Header (if there is any)                 CFT006
      *                                                                   CFT006
     C     PH26T         IFNE      *BLANKS                                                     CFT00
     C                   MOVEL     *BLANKS       WUFDDT                                        CFT00
     C                   MOVEL     PH26T         WUFDDT                                        CFT00
     C                   MOVEL     WUMTAG        HPRTG                                         CFT00
     C                   MOVEL     WUACCO        HPRDT                                         CFT00
     C                   MOVEL     WUORIG        HPROR1                                        CFT00
     C                   MOVE      WUORIG        HPROR2                                        CFT00
     C***********KYDESC    CHAIN@EFREJ4              99            CFT006 CFT014
     C                   EXSR      RTVTGD                                                      CFT01
     C     *IN99         IFEQ      *OFF                                                        CFT00
     C                   MOVEL     EFSCFD        HPRDS                                         CFT00
     C                   ELSE                                                                  CFT00
     C                   MOVEL     *BLANKS       HPRDS                                         CFT00
     C                   ENDIF                                                                 CFT00
     C     HPROR1        IFNE      *BLANKS                                                     CFT00
     C                   MOVE      *ON           *IN51                                         CFT00
     C                   ENDIF                                                                 CFT00
     C     HPROR2        IFNE      *BLANKS                                                     CFT00
     C                   MOVE      *ON           *IN52                                         CFT00
     C                   ENDIF                                                                 CFT00
     C                   WRITE     MSGDTL                                                      CFT00
      *                                                                   CFT006
     C     *IN25         IFEQ      *ON                                                         CFT00
     C                   WRITE     HEADER                                                      CFT00
     C                   MOVE      *OFF          *IN25                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   MOVE      *OFF          *IN51                                         CFT00
     C                   MOVE      *OFF          *IN52                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
      *  Requested Execution Date - Header (if there is any)              CFT006
      *                                                                   CFT006
     C     PH30          IFNE      *BLANKS                                                     CFT00
     C                   MOVEL     *BLANKS       WUFDDT                                        CFT00
     C                   MOVEL     PH30          WUFDDT                                        CFT00
     C                   MOVEL     WUMTAG        HPRTG                                         CFT00
     C                   MOVEL     WUACCO        HPRDT                                         CFT00
     C                   MOVEL     WUORIG        HPROR1                                        CFT00
     C                   MOVE      WUORIG        HPROR2                                        CFT00
     C***********KYDESC    CHAIN@EFREJ4              99            CFT006 CFT014
     C                   EXSR      RTVTGD                                                      CFT01
     C     *IN99         IFEQ      *OFF                                                        CFT00
     C                   MOVEL     EFSCFD        HPRDS                                         CFT00
     C                   ELSE                                                                  CFT00
     C                   MOVEL     *BLANKS       HPRDS                                         CFT00
     C                   ENDIF                                                                 CFT00
     C     HPROR1        IFNE      *BLANKS                                                     CFT00
     C                   MOVE      *ON           *IN51                                         CFT00
     C                   ENDIF                                                                 CFT00
     C     HPROR2        IFNE      *BLANKS                                                     CFT00
     C                   MOVE      *ON           *IN52                                         CFT00
     C                   ENDIF                                                                 CFT00
     C                   WRITE     MSGDTL                                                      CFT00
      *                                                                   CFT006
     C     *IN25         IFEQ      *ON                                                         CFT00
     C                   WRITE     HEADER                                                      CFT00
     C                   MOVE      *OFF          *IN25                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   MOVE      *OFF          *IN51                                         CFT00
     C                   MOVE      *OFF          *IN52                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
      *  Value date/ccy/amount - Header (if there is any)                 CFT006
      *                                                                   CFT006
     C     PH32A         IFNE      *BLANKS                                                     CFT00
     C                   MOVEL     *BLANKS       WUFDDT                                        CFT00
     C                   MOVEL     PH32A         WUFDDT                                        CFT00
     C                   MOVEL     WUMTAG        HPRTG                                         CFT00
     C                   MOVEL     WUORIG        TVDCA                                         CFT00
     C                   MOVE      *BLANKS       HPROR1                                        17767
     C                   MOVE      *BLANKS       HPROR2                                        17767
     C                   MOVEL     TVDCA         HPROR1                                        CFT00
     C***********KYDESC    CHAIN@EFREJ4              99            CFT006 CFT014
     C                   EXSR      RTVTGD                                                      CFT01
     C     *IN99         IFEQ      *OFF                                                        CFT00
     C                   MOVEL     EFSCFD        HPRDS                                         CFT00
     C                   ELSE                                                                  CFT00
     C                   MOVEL     *BLANKS       HPRDS                                         CFT00
     C                   ENDIF                                                                 CFT00
     C     HPROR1        IFNE      *BLANKS                                                     CFT00
     C                   MOVE      *ON           *IN51                                         CFT00
     C                   ENDIF                                                                 CFT00
     C                   WRITE     MSGDTL                                                      CFT00
      *                                                                   CFT006
     C     *IN25         IFEQ      *ON                                                         CFT00
     C                   WRITE     HEADER                                                      CFT00
     C                   MOVE      *OFF          *IN25                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
      *  Exchange Rate - Header (if there is any)                         CFT006
      *                                                                   CFT006
     C     PH36          IFNE      *BLANKS                                                     CFT00
     C                   MOVEL     *BLANKS       WUFDDT                                        CFT00
     C                   MOVEL     PH36          WUFDDT                                        CFT00
     C                   MOVEL     WUMTAG        HPRTG                                         CFT00
     C                   MOVEL     WUACCO        HPRDT                                         CFT00
     C                   MOVEL     WUORIG        HPROR1                                        CFT00
     C                   MOVE      WUORIG        HPROR2                                        CFT00
     C***********KYDESC    CHAIN@EFREJ4              99            CFT006 CFT014
     C                   EXSR      RTVTGD                                                      CFT01
     C     *IN99         IFEQ      *OFF                                                        CFT00
     C                   MOVEL     EFSCFD        HPRDS                                         CFT00
     C                   ELSE                                                                  CFT00
     C                   MOVEL     *BLANKS       HPRDS                                         CFT00
     C                   ENDIF                                                                 CFT00
     C     HPROR1        IFNE      *BLANKS                                                     CFT00
     C                   MOVE      *ON           *IN51                                         CFT00
     C                   ENDIF                                                                 CFT00
     C     HPROR2        IFNE      *BLANKS                                                     CFT00
     C                   MOVE      *ON           *IN52                                         CFT00
     C                   ENDIF                                                                 CFT00
     C                   WRITE     MSGDTL                                                      CFT00
      *                                                                   CFT006
     C     *IN25         IFEQ      *ON                                                         CFT00
     C                   WRITE     HEADER                                                      CFT00
     C                   MOVE      *OFF          *IN25                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   MOVE      *OFF          *IN51                                         CFT00
     C                   MOVE      *OFF          *IN52                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
      *  Ordering Customer - Header (if there is any)                     CFT006
      *                                                                   CFT006
     C     PH50          IFNE      *BLANKS                                                     CFT00
     C                   MOVEL     *BLANKS       WUFDDT                                        CFT00
     C                   MOVEL     PH50          WUFDDT                                        CFT00
     C                   MOVEL     WUMTAG        HPRTG                                         CFT00
     C                   MOVEL     WUACCO        HPRDT                                         CFT00
     C                   MOVEL     WUORIG        HPROR1                                        CFT00
     C                   MOVE      WUORIG        HPROR2                                        CFT00
     C***********KYDESC    CHAIN@EFREJ4              99            CFT006 CFT014
     C                   EXSR      RTVTGD                                                      CFT01
     C     *IN99         IFEQ      *OFF                                                        CFT00
     C                   MOVEL     EFSCFD        HPRDS                                         CFT00
     C                   ELSE                                                                  CFT00
     C                   MOVEL     *BLANKS       HPRDS                                         CFT00
     C                   ENDIF                                                                 CFT00
     C     HPROR1        IFNE      *BLANKS                                                     CFT00
     C                   MOVE      *ON           *IN51                                         CFT00
     C                   ENDIF                                                                 CFT00
     C     HPROR2        IFNE      *BLANKS                                                     CFT00
     C                   MOVE      *ON           *IN52                                         CFT00
     C                   ENDIF                                                                 CFT00
     C                   WRITE     MSGDTL                                                      CFT00
      *                                                                   CFT006
     C     *IN25         IFEQ      *ON                                                         CFT00
     C                   WRITE     HEADER                                                      CFT00
     C                   MOVE      *OFF          *IN25                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   MOVE      *OFF          *IN51                                         CFT00
     C                   MOVE      *OFF          *IN52                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
      *  Instructing Party - Header (if there is any)                     CFT006
      *                                                                   CFT006
     C     PH50L         IFNE      *BLANKS                                                     CFT00
     C                   MOVEL     *BLANKS       WUFDDT                                        CFT00
     C                   MOVEL     PH50L         WUFDDT                                        CFT00
     C                   MOVEL     WUMTAG        HPRTG                                         CFT00
     C                   MOVEL     WUACCO        HPRDT                                         CFT00
     C                   MOVEL     WUORIG        HPROR1                                        CFT00
     C                   MOVE      WUORIG        HPROR2                                        CFT00
     C***********KYDESC    CHAIN@EFREJ4              99            CFT006 CFT014
     C                   EXSR      RTVTGD                                                      CFT01
     C     *IN99         IFEQ      *OFF                                                        CFT00
     C                   MOVEL     EFSCFD        HPRDS                                         CFT00
     C                   ELSE                                                                  CFT00
     C                   MOVEL     *BLANKS       HPRDS                                         CFT00
     C                   ENDIF                                                                 CFT00
     C     HPROR1        IFNE      *BLANKS                                                     CFT00
     C                   MOVE      *ON           *IN51                                         CFT00
     C                   ENDIF                                                                 CFT00
     C     HPROR2        IFNE      *BLANKS                                                     CFT00
     C                   MOVE      *ON           *IN52                                         CFT00
     C                   ENDIF                                                                 CFT00
     C                   WRITE     MSGDTL                                                      CFT00
      *                                                                   CFT006
     C     *IN25         IFEQ      *ON                                                         CFT00
     C                   WRITE     HEADER                                                      CFT00
     C                   MOVE      *OFF          *IN25                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   MOVE      *OFF          *IN51                                         CFT00
     C                   MOVE      *OFF          *IN52                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
      *  Sending Institution - Header (if there is any)                   CFT006
      *                                                                   CFT006
     C     PH51A         IFNE      *BLANKS                                                     CFT00
     C                   MOVEL     *BLANKS       WUFDDT                                        CFT00
     C                   MOVEL     PH51A         WUFDDT                                        CFT00
     C                   MOVEL     WUMTAG        HPRTG                                         CFT00
     C                   MOVEL     WUACCO        HPRDT                                         CFT00
     C                   MOVEL     WUORIG        HPROR1                                        CFT00
     C                   MOVE      WUORIG        HPROR2                                        CFT00
     C***********KYDESC    CHAIN@EFREJ4              99            CFT006 CFT014
     C                   EXSR      RTVTGD                                                      CFT01
     C     *IN99         IFEQ      *OFF                                                        CFT00
     C                   MOVEL     EFSCFD        HPRDS                                         CFT00
     C                   ELSE                                                                  CFT00
     C                   MOVEL     *BLANKS       HPRDS                                         CFT00
     C                   ENDIF                                                                 CFT00
     C     HPROR1        IFNE      *BLANKS                                                     CFT00
     C                   MOVE      *ON           *IN51                                         CFT00
     C                   ENDIF                                                                 CFT00
     C     HPROR2        IFNE      *BLANKS                                                     CFT00
     C                   MOVE      *ON           *IN52                                         CFT00
     C                   ENDIF                                                                 CFT00
     C                   WRITE     MSGDTL                                                      CFT00
      *                                                                   CFT006
     C     *IN25         IFEQ      *ON                                                         CFT00
     C                   WRITE     HEADER                                                      CFT00
     C                   MOVE      *OFF          *IN25                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   MOVE      *OFF          *IN51                                         CFT00
     C                   MOVE      *OFF          *IN52                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
      *  Ordering Institution - Header (if there is any)                  CFT006
      *                                                                   CFT006
     C     PH52          IFNE      *BLANKS                                                     CFT00
     C                   MOVEL     *BLANKS       WUFDDT                                        CFT00
     C                   MOVEL     PH52          WUFDDT                                        CFT00
     C                   MOVEL     WUMTAG        HPRTG                                         CFT00
     C                   MOVEL     WUACCO        HPRDT                                         CFT00
     C                   MOVEL     WUORIG        HPROR1                                        CFT00
     C                   MOVE      WUORIG        HPROR2                                        CFT00
     C***********KYDESC    CHAIN@EFREJ4              99            CFT006 CFT014
     C                   EXSR      RTVTGD                                                      CFT01
     C     *IN99         IFEQ      *OFF                                                        CFT00
     C                   MOVEL     EFSCFD        HPRDS                                         CFT00
     C                   ELSE                                                                  CFT00
     C                   MOVEL     *BLANKS       HPRDS                                         CFT00
     C                   ENDIF                                                                 CFT00
     C     HPROR1        IFNE      *BLANKS                                                     CFT00
     C                   MOVE      *ON           *IN51                                         CFT00
     C                   ENDIF                                                                 CFT00
     C     HPROR2        IFNE      *BLANKS                                                     CFT00
     C                   MOVE      *ON           *IN52                                         CFT00
     C                   ENDIF                                                                 CFT00
     C                   WRITE     MSGDTL                                                      CFT00
      *                                                                   CFT006
     C     *IN25         IFEQ      *ON                                                         CFT00
     C                   WRITE     HEADER                                                      CFT00
     C                   MOVE      *OFF          *IN25                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   MOVE      *OFF          *IN51                                         CFT00
     C                   MOVE      *OFF          *IN52                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
      *  Sender's Correspondent - Header (if there is any)                CFT006
      *                                                                   CFT006
     C     PH53          IFNE      *BLANKS                                                     CFT00
     C                   MOVEL     *BLANKS       WUFDDT                                        CFT00
     C                   MOVEL     PH53          WUFDDT                                        CFT00
     C                   MOVEL     WUMTAG        HPRTG                                         CFT00
     C                   MOVEL     WUACCO        HPRDT                                         CFT00
     C                   MOVEL     WUORIG        HPROR1                                        CFT00
     C                   MOVE      WUORIG        HPROR2                                        CFT00
     C***********KYDESC    CHAIN@EFREJ4              99            CFT006 CFT014
     C                   EXSR      RTVTGD                                                      CFT01
     C     *IN99         IFEQ      *OFF                                                        CFT00
     C                   MOVEL     EFSCFD        HPRDS                                         CFT00
     C                   ELSE                                                                  CFT00
     C                   MOVEL     *BLANKS       HPRDS                                         CFT00
     C                   ENDIF                                                                 CFT00
     C     HPROR1        IFNE      *BLANKS                                                     CFT00
     C                   MOVE      *ON           *IN51                                         CFT00
     C                   ENDIF                                                                 CFT00
     C     HPROR2        IFNE      *BLANKS                                                     CFT00
     C                   MOVE      *ON           *IN52                                         CFT00
     C                   ENDIF                                                                 CFT00
     C                   WRITE     MSGDTL                                                      CFT00
      *                                                                   CFT006
     C     *IN25         IFEQ      *ON                                                         CFT00
     C                   WRITE     HEADER                                                      CFT00
     C                   MOVE      *OFF          *IN25                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   MOVE      *OFF          *IN51                                         CFT00
     C                   MOVE      *OFF          *IN52                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
      *  Receiver's Correspondent - Header (if there is any)              CFT006
      *                                                                   CFT006
     C     PH54          IFNE      *BLANKS                                                     CFT00
     C                   MOVEL     *BLANKS       WUFDDT                                        CFT00
     C                   MOVEL     PH54          WUFDDT                                        CFT00
     C                   MOVEL     WUMTAG        HPRTG                                         CFT00
     C                   MOVEL     WUACCO        HPRDT                                         CFT00
     C                   MOVEL     WUORIG        HPROR1                                        CFT00
     C                   MOVE      WUORIG        HPROR2                                        CFT00
     C***********KYDESC    CHAIN@EFREJ4              99            CFT006 CFT014
     C                   EXSR      RTVTGD                                                      CFT01
     C     *IN99         IFEQ      *OFF                                                        CFT00
     C                   MOVEL     EFSCFD        HPRDS                                         CFT00
     C                   ELSE                                                                  CFT00
     C                   MOVEL     *BLANKS       HPRDS                                         CFT00
     C                   ENDIF                                                                 CFT00
     C     HPROR1        IFNE      *BLANKS                                                     CFT00
     C                   MOVE      *ON           *IN51                                         CFT00
     C                   ENDIF                                                                 CFT00
     C     HPROR2        IFNE      *BLANKS                                                     CFT00
     C                   MOVE      *ON           *IN52                                         CFT00
     C                   ENDIF                                                                 CFT00
     C                   WRITE     MSGDTL                                                      CFT00
      *                                                                   CFT006
     C     *IN25         IFEQ      *ON                                                         CFT00
     C                   WRITE     HEADER                                                      CFT00
     C                   MOVE      *OFF          *IN25                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   MOVE      *OFF          *IN51                                         CFT00
     C                   MOVE      *OFF          *IN52                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
      *  Details of charges - Header (if there is any)                    CFT006
      *                                                                   CFT006
     C     PH71          IFNE      *BLANKS                                                     CFT00
     C                   MOVEL     *BLANKS       WUFDDT                                        CFT00
     C                   MOVEL     PH71          WUFDDT                                        CFT00
     C                   MOVEL     WUMTAG        HPRTG                                         CFT00
     C                   MOVEL     WUACCO        HPRDT                                         CFT00
     C                   MOVEL     WUORIG        HPROR1                                        CFT00
     C                   MOVE      WUORIG        HPROR2                                        CFT00
     C***********KYDESC    CHAIN@EFREJ4              99            CFT006 CFT014
     C                   EXSR      RTVTGD                                                      CFT01
     C     *IN99         IFEQ      *OFF                                                        CFT00
     C                   MOVEL     EFSCFD        HPRDS                                         CFT00
     C                   ELSE                                                                  CFT00
     C                   MOVEL     *BLANKS       HPRDS                                         CFT00
     C                   ENDIF                                                                 CFT00
     C     HPROR1        IFNE      *BLANKS                                                     CFT00
     C                   MOVE      *ON           *IN51                                         CFT00
     C                   ENDIF                                                                 CFT00
     C     HPROR2        IFNE      *BLANKS                                                     CFT00
     C                   MOVE      *ON           *IN52                                         CFT00
     C                   ENDIF                                                                 CFT00
     C                   WRITE     MSGDTL                                                      CFT00
      *                                                                   CFT006
     C     *IN25         IFEQ      *ON                                                         CFT00
     C                   WRITE     HEADER                                                      CFT00
     C                   MOVE      *OFF          *IN25                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   MOVE      *OFF          *IN51                                         CFT00
     C                   MOVE      *OFF          *IN52                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
      *  Sum of Sender's Charges/amount - Header (if there is any)        CFT006
      *                                                                   CFT006
     C     PH71F         IFNE      *BLANKS                                                     CFT00
     C                   MOVEL     *BLANKS       WUFDDT                                        CFT00
     C                   MOVEL     PH71F         WUFDDT                                        CFT00
     C                   MOVEL     WUMTAG        HPRTG                                         CFT00
     C                   MOVEL     WUORIG        TTCA                                          CFT00
     C                   MOVE      *BLANKS       HPROR1                                        17767
     C                   MOVE      *BLANKS       HPROR2                                        17767
     C                   MOVEL     TTCA          HPROR1                                        CFT00
     C***********KYDESC    CHAIN@EFREJ4              99            CFT006 CFT014
     C                   EXSR      RTVTGD                                                      CFT01
     C     *IN99         IFEQ      *OFF                                                        CFT00
     C                   MOVEL     EFSCFD        HPRDS                                         CFT00
     C                   ELSE                                                                  CFT00
     C                   MOVEL     *BLANKS       HPRDS                                         CFT00
     C                   ENDIF                                                                 CFT00
     C     HPROR1        IFNE      *BLANKS                                                     CFT00
     C                   MOVE      *ON           *IN51                                         CFT00
     C                   ENDIF                                                                 CFT00
     C                   WRITE     MSGDTL                                                      CFT00
      *                                                                   CFT006
     C     *IN25         IFEQ      *ON                                                         CFT00
     C                   WRITE     HEADER                                                      CFT00
     C                   MOVE      *OFF          *IN25                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
      *  Sum of Receiver's Charges/amount - Header (if there is any)      CFT006
      *                                                                   CFT006
     C     PH71G         IFNE      *BLANKS                                                     CFT00
     C                   MOVEL     *BLANKS       WUFDDT                                        CFT00
     C                   MOVEL     PH71G         WUFDDT                                        CFT00
     C                   MOVEL     WUMTAG        HPRTG                                         CFT00
     C                   MOVEL     WUORIG        TTCA                                          CFT00
     C                   MOVE      *BLANKS       HPROR1                                        17767
     C                   MOVE      *BLANKS       HPROR2                                        17767
     C                   MOVEL     TTCA          HPROR1                                        CFT00
     C***********KYDESC    CHAIN@EFREJ4              99            CFT006 CFT014
     C                   EXSR      RTVTGD                                                      CFT01
     C     *IN99         IFEQ      *OFF                                                        CFT00
     C                   MOVEL     EFSCFD        HPRDS                                         CFT00
     C                   ELSE                                                                  CFT00
     C                   MOVEL     *BLANKS       HPRDS                                         CFT00
     C                   ENDIF                                                                 CFT00
     C     HPROR1        IFNE      *BLANKS                                                     CFT00
     C                   MOVE      *ON           *IN51                                         CFT00
     C                   ENDIF                                                                 CFT00
     C                   WRITE     MSGDTL                                                      CFT00
      *                                                                   CFT006
     C     *IN25         IFEQ      *ON                                                         CFT00
     C                   WRITE     HEADER                                                      CFT00
     C                   MOVE      *OFF          *IN25                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
      *  Sender to Receiver Information - Header (if there is any)        CFT006
      *                                                                   CFT006
     C     PH72          IFNE      *BLANKS                                                     CFT00
     C                   MOVEL     *BLANKS       WUFDDT                                        CFT00
     C                   MOVEL     PH72          WUFDDT                                        CFT00
     C                   MOVEL     WUMTAG        HPRTG                                         CFT00
     C                   MOVEL     WUACCO        HPRDT                                         CFT00
     C                   MOVEL     WUORIG        HPROR1                                        CFT00
     C                   MOVE      WUORIG        HPROR2                                        CFT00
     C***********KYDESC    CHAIN@EFREJ4              99            CFT006 CFT014
     C                   EXSR      RTVTGD                                                      CFT01
     C     *IN99         IFEQ      *OFF                                                        CFT00
     C                   MOVEL     EFSCFD        HPRDS                                         CFT00
     C                   ELSE                                                                  CFT00
     C                   MOVEL     *BLANKS       HPRDS                                         CFT00
     C                   ENDIF                                                                 CFT00
     C     HPROR1        IFNE      *BLANKS                                                     CFT00
     C                   MOVE      *ON           *IN51                                         CFT00
     C                   ENDIF                                                                 CFT00
     C     HPROR2        IFNE      *BLANKS                                                     CFT00
     C                   MOVE      *ON           *IN52                                         CFT00
     C                   ENDIF                                                                 CFT00
     C                   WRITE     MSGDTL                                                      CFT00
      *                                                                   CFT006
     C     *IN25         IFEQ      *ON                                                         CFT00
     C                   WRITE     HEADER                                                      CFT00
     C                   MOVE      *OFF          *IN25                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   MOVE      *OFF          *IN51                                         CFT00
     C                   MOVE      *OFF          *IN52                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
      *  Regulatory Reporting - Header (if there is any)                  CFT006
      *                                                                   CFT006
     C     PH77B         IFNE      *BLANKS                                                     CFT00
     C                   MOVEL     *BLANKS       WUFDDT                                        CFT00
     C                   MOVEL     PH77B         WUFDDT                                        CFT00
     C                   MOVEL     WUMTAG        HPRTG                                         CFT00
     C                   MOVEL     WUACCO        HPRDT                                         CFT00
     C                   MOVEL     WUORIG        HPROR1                                        CFT00
     C                   MOVE      WUORIG        HPROR2                                        CFT00
     C***********KYDESC    CHAIN@EFREJ4              99            CFT006 CFT014
     C                   EXSR      RTVTGD                                                      CFT01
     C     *IN99         IFEQ      *OFF                                                        CFT00
     C                   MOVEL     EFSCFD        HPRDS                                         CFT00
     C                   ELSE                                                                  CFT00
     C                   MOVEL     *BLANKS       HPRDS                                         CFT00
     C                   ENDIF                                                                 CFT00
     C     HPROR1        IFNE      *BLANKS                                                     CFT00
     C                   MOVE      *ON           *IN51                                         CFT00
     C                   ENDIF                                                                 CFT00
     C     HPROR2        IFNE      *BLANKS                                                     CFT00
     C                   MOVE      *ON           *IN52                                         CFT00
     C                   ENDIF                                                                 CFT00
     C                   WRITE     MSGDTL                                                      CFT00
      *                                                                   CFT006
     C     *IN25         IFEQ      *ON                                                         CFT00
     C                   WRITE     HEADER                                                      CFT00
     C                   MOVE      *OFF          *IN25                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   MOVE      *OFF          *IN51                                         CFT00
     C                   MOVE      *OFF          *IN52                                         CFT00
     C                   ENDIF                                                                 CFT00
      *
      *  Transaction Reference (if there is any)
      *
     C     P20           IFNE      *BLANKS
     C                   MOVEL     P20           WUFDDT
     C                   MOVEL     WUMTAG        HPRTG
     C                   MOVEL     WUACCO        HPRDT
     C                   MOVEL     WUORIG        HPROR1
     C                   MOVE      WUORIG        HPROR2
     C***********KYDESC    CHAIN@EFREJ4              99                   CFT014
     C                   EXSR      RTVTGD                                                      CFT01
     C     *IN99         IFEQ      '0'
     C                   MOVEL     EFSCFD        HPRDS
     C                   ELSE
     C                   MOVEL     *BLANKS       HPRDS
     C                   END
     C     HPROR1        IFNE      *BLANKS
     C                   SETON                                        51
     C                   ENDIF
     C     HPROR2        IFNE      *BLANKS
     C                   SETON                                        52
     C                   ENDIF
     C/COPY WNCPYSRC,ME1501C013
     C                   WRITE     MSGDTL
      *                                                                   CFT006
     C     *IN25         IFEQ      *ON                                                         CFT00
     C                   WRITE     HEADER                                                      CFT00
     C                   MOVE      *OFF          *IN25                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   SETOFF                                       5152
     C                   ENDIF
      *
      *  Related Reference (if there is any)
      *
     C     P21           IFNE      *BLANKS
     C                   MOVEL     P21           WUFDDT
     C                   MOVEL     WUMTAG        HPRTG
     C                   MOVEL     WUACCO        HPRDT
     C                   MOVEL     WUORIG        HPROR1
     C                   MOVE      WUORIG        HPROR2
     C***********KYDESC    CHAIN@EFREJ4              99                   CFT014
     C                   EXSR      RTVTGD                                                      CFT01
     C     *IN99         IFEQ      '0'
     C                   MOVEL     EFSCFD        HPRDS
     C                   ELSE
     C                   MOVEL     *BLANKS       HPRDS
     C                   END
     C     HPROR1        IFNE      *BLANKS
     C                   SETON                                        51
     C                   ENDIF
     C     HPROR2        IFNE      *BLANKS
     C                   SETON                                        52
     C                   ENDIF
     C/COPY WNCPYSRC,ME1501C014
     C                   WRITE     MSGDTL
      *                                                                   CFT006
     C     *IN25         IFEQ      *ON                                                         CFT00
     C                   WRITE     HEADER                                                      CFT00
     C                   MOVE      *OFF          *IN25                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   SETOFF                                       5152
     C                   ENDIF
      *                                                                   CFT006
      *  F/X Deal Reference (if there is any)                             CFT006
      *                                                                   CFT006
     C     P21F          IFNE      *BLANKS                                                     CFT00
     C                   MOVEL     *BLANKS       WUFDDT                                        CFT00
     C                   MOVEL     P21F          WUFDDT                                        CFT00
     C                   MOVEL     WUMTAG        HPRTG                                         CFT00
     C                   MOVEL     WUACCO        HPRDT                                         CFT00
     C                   MOVEL     WUORIG        HPROR1                                        CFT00
     C                   MOVE      WUORIG        HPROR2                                        CFT00
     C***********KYDESC    CHAIN@EFREJ4              99            CFT006 CFT014
     C                   EXSR      RTVTGD                                                      CFT01
     C     *IN99         IFEQ      *OFF                                                        CFT00
     C                   MOVEL     EFSCFD        HPRDS                                         CFT00
     C                   ELSE                                                                  CFT00
     C                   MOVEL     *BLANKS       HPRDS                                         CFT00
     C                   ENDIF                                                                 CFT00
     C     HPROR1        IFNE      *BLANKS                                                     CFT00
     C                   MOVE      *ON           *IN51                                         CFT00
     C                   ENDIF                                                                 CFT00
     C     HPROR2        IFNE      *BLANKS                                                     CFT00
     C                   MOVE      *ON           *IN52                                         CFT00
     C                   ENDIF                                                                 CFT00
     C                   WRITE     MSGDTL                                                      CFT00
      *                                                                   CFT006
     C     *IN25         IFEQ      *ON                                                         CFT00
     C                   WRITE     HEADER                                                      CFT00
     C                   MOVE      *OFF          *IN25                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   MOVE      *OFF          *IN51                                         CFT00
     C                   MOVE      *OFF          *IN52                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT014
      *  Bank Operation Code (if there is any)                            CFT014
      *                                                                   CFT014
     C     P23B          IFNE      *BLANKS                                                     CFT01
     C                   MOVEL     *BLANKS       WUFDDT                                        CFT01
     C                   MOVEL     P23B          WUFDDT                                        CFT01
     C                   MOVEL     WUMTAG        HPRTG                                         CFT01
     C                   MOVEL     WUACCO        HPRDT                                         CFT01
     C                   MOVEL     WUORIG        HPROR1                                        CFT01
     C                   MOVE      WUORIG        HPROR2                                        CFT01
     C                   EXSR      RTVTGD                                                      CFT01
     C     *IN99         IFEQ      *OFF                                                        CFT01
     C                   MOVEL     EFSCFD        HPRDS                                         CFT01
     C                   ELSE                                                                  CFT01
     C                   MOVEL     *BLANKS       HPRDS                                         CFT01
     C                   ENDIF                                                                 CFT01
     C     HPROR1        IFNE      *BLANKS                                                     CFT01
     C                   MOVE      *ON           *IN51                                         CFT01
     C                   ENDIF                                                                 CFT01
     C     HPROR2        IFNE      *BLANKS                                                     CFT01
     C                   MOVE      *ON           *IN52                                         CFT01
     C                   ENDIF                                                                 CFT01
     C                   WRITE     MSGDTL                                                      CFT01
      *                                                                   CFT014
     C     *IN25         IFEQ      *ON                                                         CFT01
     C                   WRITE     HEADER                                                      CFT01
     C                   MOVE      *OFF          *IN25                                         CFT01
     C                   ENDIF                                                                 CFT01
      *                                                                   CFT014
     C                   MOVE      *OFF          *IN51                                         CFT01
     C                   MOVE      *OFF          *IN52                                         CFT01
     C                   ENDIF                                                                 CFT01
      *                                                                   CFT006
      *  Instruction Code (if there is any)                               CFT006
      *                                                                   CFT006
     C     P23E          IFNE      *BLANKS                                                     CFT00
     C                   MOVEL     *BLANKS       WUFDDT                                        CFT00
     C                   MOVEL     P23E          WUFDDT                                        CFT00
     C                   MOVEL     WUMTAG        HPRTG                                         CFT00
     C                   MOVEL     WUACCO        HPRDT                                         CFT00
     C                   MOVEL     WUORIG        HPROR1                                        CFT00
     C                   MOVE      WUORIG        HPROR2                                        CFT00
     C***********KYDESC    CHAIN@EFREJ4              99            CFT006 CFT014
     C                   EXSR      RTVTGD                                                      CFT01
     C     *IN99         IFEQ      *OFF                                                        CFT00
     C                   MOVEL     EFSCFD        HPRDS                                         CFT00
     C                   ELSE                                                                  CFT00
     C                   MOVEL     *BLANKS       HPRDS                                         CFT00
     C                   ENDIF                                                                 CFT00
     C     HPROR1        IFNE      *BLANKS                                                     CFT00
     C                   MOVE      *ON           *IN51                                         CFT00
     C                   ENDIF                                                                 CFT00
     C     HPROR2        IFNE      *BLANKS                                                     CFT00
     C                   MOVE      *ON           *IN52                                         CFT00
     C                   ENDIF                                                                 CFT00
     C                   WRITE     MSGDTL                                                      CFT00
      *                                                                   CFT006
     C     *IN25         IFEQ      *ON                                                         CFT00
     C                   WRITE     HEADER                                                      CFT00
     C                   MOVE      *OFF          *IN25                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   MOVE      *OFF          *IN51                                         CFT00
     C                   MOVE      *OFF          *IN52                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
      *  Charges Account (if there is any)                                CFT006
      *                                                                   CFT006
     C     P25A          IFNE      *BLANKS                                                     CFT00
     C                   MOVEL     *BLANKS       WUFDDT                                        CFT00
     C                   MOVEL     P25A          WUFDDT                                        CFT00
     C                   MOVEL     WUMTAG        HPRTG                                         CFT00
     C                   MOVEL     WUACCO        HPRDT                                         CFT00
     C                   MOVEL     WUORIG        HPROR1                                        CFT00
     C                   MOVE      WUORIG        HPROR2                                        CFT00
     C***********KYDESC    CHAIN@EFREJ4              99            CFT006 CFT014
     C                   EXSR      RTVTGD                                                      CFT01
     C     *IN99         IFEQ      *OFF                                                        CFT00
     C                   MOVEL     EFSCFD        HPRDS                                         CFT00
     C                   ELSE                                                                  CFT00
     C                   MOVEL     *BLANKS       HPRDS                                         CFT00
     C                   ENDIF                                                                 CFT00
     C     HPROR1        IFNE      *BLANKS                                                     CFT00
     C                   MOVE      *ON           *IN51                                         CFT00
     C                   ENDIF                                                                 CFT00
     C     HPROR2        IFNE      *BLANKS                                                     CFT00
     C                   MOVE      *ON           *IN52                                         CFT00
     C                   ENDIF                                                                 CFT00
     C                   WRITE     MSGDTL                                                      CFT00
      *                                                                   CFT006
     C     *IN25         IFEQ      *ON                                                         CFT00
     C                   WRITE     HEADER                                                      CFT00
     C                   MOVE      *OFF          *IN25                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   MOVE      *OFF          *IN51                                         CFT00
     C                   MOVE      *OFF          *IN52                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
      *  Transaction Type Code (if there is any)                          CFT006
      *                                                                   CFT006
     C     P26T          IFNE      *BLANKS                                                     CFT00
     C                   MOVEL     *BLANKS       WUFDDT                                        CFT00
     C                   MOVEL     P26T          WUFDDT                                        CFT00
     C                   MOVEL     WUMTAG        HPRTG                                         CFT00
     C                   MOVEL     WUACCO        HPRDT                                         CFT00
     C                   MOVEL     WUORIG        HPROR1                                        CFT00
     C                   MOVE      WUORIG        HPROR2                                        CFT00
     C***********KYDESC    CHAIN@EFREJ4              99            CFT006 CFT014
     C                   EXSR      RTVTGD                                                      CFT01
     C     *IN99         IFEQ      *OFF                                                        CFT00
     C                   MOVEL     EFSCFD        HPRDS                                         CFT00
     C                   ELSE                                                                  CFT00
     C                   MOVEL     *BLANKS       HPRDS                                         CFT00
     C                   ENDIF                                                                 CFT00
     C     HPROR1        IFNE      *BLANKS                                                     CFT00
     C                   MOVE      *ON           *IN51                                         CFT00
     C                   ENDIF                                                                 CFT00
     C     HPROR2        IFNE      *BLANKS                                                     CFT00
     C                   MOVE      *ON           *IN52                                         CFT00
     C                   ENDIF                                                                 CFT00
     C                   WRITE     MSGDTL                                                      CFT00
      *                                                                   CFT006
     C     *IN25         IFEQ      *ON                                                         CFT00
     C                   WRITE     HEADER                                                      CFT00
     C                   MOVE      *OFF          *IN25                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   MOVE      *OFF          *IN51                                         CFT00
     C                   MOVE      *OFF          *IN52                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
      *  Currency/Transaction amount (if there is any)                    CFT006
      *                                                                   CFT006
     C     P32B          IFNE      *BLANKS                                                     CFT00
     C                   MOVEL     *BLANKS       WUFDDT                                        CFT00
     C                   MOVEL     P32B          WUFDDT                                        CFT00
     C                   MOVEL     WUMTAG        HPRTG                                         CFT00
     C                   MOVEL     WUORIG        TTCA                                          CFT00
     C                   MOVE      *BLANKS       HPROR1                                        17767
     C                   MOVE      *BLANKS       HPROR2                                        17767
     C                   MOVEL     TTCA          HPROR1                                        CFT00
     C***********KYDESC    CHAIN@EFREJ4              99            CFT006 CFT014
     C                   EXSR      RTVTGD                                                      CFT01
     C     *IN99         IFEQ      *OFF                                                        CFT00
     C                   MOVEL     EFSCFD        HPRDS                                         CFT00
     C                   ELSE                                                                  CFT00
     C                   MOVEL     *BLANKS       HPRDS                                         CFT00
     C                   ENDIF                                                                 CFT00
     C     HPROR1        IFNE      *BLANKS                                                     CFT00
     C                   MOVE      *ON           *IN51                                         CFT00
     C                   ENDIF                                                                 CFT00
     C                   WRITE     MSGDTL                                                      CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
      *  Original Ordered Amount (if there is any)                        CFT006
      *                                                                   CFT006
     C     P33B          IFNE      *BLANKS                                                     CFT00
     C                   MOVEL     *BLANKS       WUFDDT                                        CFT00
     C                   MOVEL     P33B          WUFDDT                                        CFT00
     C                   MOVEL     WUMTAG        HPRTG                                         CFT00
     C                   MOVEL     WUORIG        TTCA                                          CFT00
     C                   MOVE      *BLANKS       HPROR1                                        17767
     C                   MOVE      *BLANKS       HPROR2                                        17767
     C                   MOVEL     TTCA          HPROR1                                        CFT00
     C***********KYDESC    CHAIN@EFREJ4              99            CFT006 CFT014
     C                   EXSR      RTVTGD                                                      CFT01
     C     *IN99         IFEQ      *OFF                                                        CFT00
     C                   MOVEL     EFSCFD        HPRDS                                         CFT00
     C                   ELSE                                                                  CFT00
     C                   MOVEL     *BLANKS       HPRDS                                         CFT00
     C                   ENDIF                                                                 CFT00
     C     HPROR1        IFNE      *BLANKS                                                     CFT00
     C                   MOVE      *ON           *IN51                                         CFT00
     C                   ENDIF                                                                 CFT00
     C                   WRITE     MSGDTL                                                      CFT00
      *                                                                   CFT006
     C     *IN25         IFEQ      *ON                                                         CFT00
     C                   WRITE     HEADER                                                      CFT00
     C                   MOVE      *OFF          *IN25                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   ENDIF                                                                 CFT00
      *
      *  Value date/ccy/amount (if there is any)
      *
     C     PDCA          IFNE      *BLANKS
     C                   MOVEL     PDCA          WUFDDT
     C                   MOVEL     WUMTAG        HPRTG
     C                   MOVEL     WUORIG        TVDCA
     C*********************MOVELTVDCA     HPRDT                                               162490
     C                   MOVE      *BLANKS       HPROR1                                        17767
     C                   MOVE      *BLANKS       HPROR2                                        17767
     C                   MOVEL     TVDCA         HPROR1
     C***********KYDESC    CHAIN@EFREJ4              99                   CFT014
     C                   EXSR      RTVTGD                                                      CFT01
     C     *IN99         IFEQ      '0'
     C                   MOVEL     EFSCFD        HPRDS
     C                   ELSE
     C                   MOVEL     *BLANKS       HPRDS
     C                   END
     C     HPROR1        IFNE      *BLANKS
     C                   SETON                                        51
     C                   ENDIF
     C/COPY WNCPYSRC,ME1501C015
     C                   WRITE     MSGDTL
      *                                                                   CFT006
     C     *IN25         IFEQ      *ON                                                         CFT00
     C                   WRITE     HEADER                                                      CFT00
     C                   MOVE      *OFF          *IN25                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   ENDIF
      *                                                                   CFT006
      *  Exchange Rate (if there is any)                                  CFT006
      *                                                                   CFT006
     C     P36           IFNE      *BLANKS                                                     CFT00
     C                   MOVEL     *BLANKS       WUFDDT                                        CFT00
     C                   MOVEL     P36           WUFDDT                                        CFT00
     C                   MOVEL     WUMTAG        HPRTG                                         CFT00
     C                   MOVEL     WUACCO        HPRDT                                         CFT00
     C                   MOVEL     WUORIG        HPROR1                                        CFT00
     C                   MOVE      WUORIG        HPROR2                                        CFT00
     C***********KYDESC    CHAIN@EFREJ4              99            CFT006 CFT014
     C                   EXSR      RTVTGD                                                      CFT01
     C     *IN99         IFEQ      *OFF                                                        CFT00
     C                   MOVEL     EFSCFD        HPRDS                                         CFT00
     C                   ELSE                                                                  CFT00
     C                   MOVEL     *BLANKS       HPRDS                                         CFT00
     C                   ENDIF                                                                 CFT00
     C     HPROR1        IFNE      *BLANKS                                                     CFT00
     C                   MOVE      *ON           *IN51                                         CFT00
     C                   ENDIF                                                                 CFT00
     C     HPROR2        IFNE      *BLANKS                                                     CFT00
     C                   MOVE      *ON           *IN52                                         CFT00
     C                   ENDIF                                                                 CFT00
     C                   WRITE     MSGDTL                                                      CFT00
      *                                                                   CFT006
     C     *IN25         IFEQ      *ON                                                         CFT00
     C                   WRITE     HEADER                                                      CFT00
     C                   MOVE      *OFF          *IN25                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   MOVE      *OFF          *IN51                                         CFT00
     C                   MOVE      *OFF          *IN52                                         CFT00
     C                   ENDIF                                                                 CFT00
      *
      *  Ordering Customer (if there is any)
      *
     C     P50           IFNE      *BLANKS
     C                   MOVEL     P50           WUFDDT
     C                   MOVEL     WUMTAG        HPRTG
     C                   MOVEL     WUACCO        HPRDT
     C                   MOVEL     WUORIG        HPROR1
     C                   MOVE      WUORIG        HPROR2
     C***********KYDESC    CHAIN@EFREJ4              99                   CFT014
     C                   EXSR      RTVTGD                                                      CFT01
     C     *IN99         IFEQ      '0'
     C                   MOVEL     EFSCFD        HPRDS
     C                   ELSE
     C                   MOVEL     *BLANKS       HPRDS
     C                   END
     C     HPROR1        IFNE      *BLANKS
     C                   SETON                                        51
     C                   ENDIF
     C     HPROR2        IFNE      *BLANKS
     C                   SETON                                        52
     C                   ENDIF
     C/COPY WNCPYSRC,ME1501C016
     C                   WRITE     MSGDTL
      *                                                                   CFT006
     C     *IN25         IFEQ      *ON                                                         CFT00
     C                   WRITE     HEADER                                                      CFT00
     C                   MOVE      *OFF          *IN25                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   SETOFF                                       5152
     C                   ENDIF
      *                                                                   CFT006
      *  Instructing Party (if there is any)                              CFT006
      *                                                                   CFT006
     C     P50L          IFNE      *BLANKS                                                     CFT00
     C                   MOVEL     *BLANKS       WUFDDT                                        CFT00
     C                   MOVEL     P50L          WUFDDT                                        CFT00
     C                   MOVEL     WUMTAG        HPRTG                                         CFT00
     C                   MOVEL     WUACCO        HPRDT                                         CFT00
     C                   MOVEL     WUORIG        HPROR1                                        CFT00
     C                   MOVE      WUORIG        HPROR2                                        CFT00
     C***********KYDESC    CHAIN@EFREJ4              99            CFT006 CFT014
     C                   EXSR      RTVTGD                                                      CFT01
     C     *IN99         IFEQ      *OFF                                                        CFT00
     C                   MOVEL     EFSCFD        HPRDS                                         CFT00
     C                   ELSE                                                                  CFT00
     C                   MOVEL     *BLANKS       HPRDS                                         CFT00
     C                   ENDIF                                                                 CFT00
     C     HPROR1        IFNE      *BLANKS                                                     CFT00
     C                   MOVE      *ON           *IN51                                         CFT00
     C                   ENDIF                                                                 CFT00
     C     HPROR2        IFNE      *BLANKS                                                     CFT00
     C                   MOVE      *ON           *IN52                                         CFT00
     C                   ENDIF                                                                 CFT00
     C                   WRITE     MSGDTL                                                      CFT00
     C                   MOVE      *OFF          *IN51                                         CFT00
      *                                                                   CFT006
     C     *IN25         IFEQ      *ON                                                         CFT00
     C                   WRITE     HEADER                                                      CFT00
     C                   MOVE      *OFF          *IN25                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   MOVE      *OFF          *IN52                                         CFT00
     C                   ENDIF                                                                 CFT00
      *
      *  Ordering Institution (if there is any)
      *
     C     P52           IFNE      *BLANKS
     C                   MOVEL     P52           WUFDDT
     C                   MOVEL     WUMTAG        HPRTG
     C                   MOVEL     WUACCO        HPRDT
     C                   MOVEL     WUORIG        HPROR1
     C                   MOVE      WUORIG        HPROR2
     C***********KYDESC    CHAIN@EFREJ4              99                   CFT014
     C                   EXSR      RTVTGD                                                      CFT01
     C     *IN99         IFEQ      '0'
     C                   MOVEL     EFSCFD        HPRDS
     C                   ELSE
     C                   MOVEL     *BLANKS       HPRDS
     C                   END
     C     HPROR1        IFNE      *BLANKS
     C                   SETON                                        51
     C                   ENDIF
     C     HPROR2        IFNE      *BLANKS
     C                   SETON                                        52
     C                   ENDIF
     C/COPY WNCPYSRC,ME1501C017
     C                   WRITE     MSGDTL
      *                                                                   CFT006
     C     *IN25         IFEQ      *ON                                                         CFT00
     C                   WRITE     HEADER                                                      CFT00
     C                   MOVE      *OFF          *IN25                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   SETOFF                                       5152
     C                   ENDIF
      *
      *  Sender's Correspondent (if there is any)
      *
     C     P53           IFNE      *BLANKS
     C                   MOVEL     P53           WUFDDT
     C                   MOVEL     WUMTAG        HPRTG
     C                   MOVEL     WUACCO        HPRDT
     C                   MOVEL     WUORIG        HPROR1
     C                   MOVE      WUORIG        HPROR2
     C***********KYDESC    CHAIN@EFREJ4              99                   CFT014
     C                   EXSR      RTVTGD                                                      CFT01
     C     *IN99         IFEQ      '0'
     C                   MOVEL     EFSCFD        HPRDS
     C                   ELSE
     C                   MOVEL     *BLANKS       HPRDS
     C                   END
     C     HPROR1        IFNE      *BLANKS
     C                   SETON                                        51
     C                   ENDIF
     C     HPROR2        IFNE      *BLANKS
     C                   SETON                                        52
     C                   ENDIF
     C/COPY WNCPYSRC,ME1501C018
     C                   WRITE     MSGDTL
      *                                                                   CFT006
     C     *IN25         IFEQ      *ON                                                         CFT00
     C                   WRITE     HEADER                                                      CFT00
     C                   MOVE      *OFF          *IN25                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   SETOFF                                       5152
     C                   ENDIF
      *
      *  Receiver's Correspondent (if there is any)
      *
     C     P54           IFNE      *BLANKS
     C                   MOVEL     P54           WUFDDT
     C                   MOVEL     WUMTAG        HPRTG
     C                   MOVEL     WUACCO        HPRDT
     C                   MOVEL     WUORIG        HPROR1
     C                   MOVE      WUORIG        HPROR2
     C***********KYDESC    CHAIN@EFREJ4              99                   CFT014
     C                   EXSR      RTVTGD                                                      CFT01
     C     *IN99         IFEQ      '0'
     C                   MOVEL     EFSCFD        HPRDS
     C                   ELSE
     C                   MOVEL     *BLANKS       HPRDS
     C                   END
     C     HPROR1        IFNE      *BLANKS
     C                   SETON                                        51
     C                   ENDIF
     C     HPROR2        IFNE      *BLANKS
     C                   SETON                                        52
     C                   ENDIF
     C/COPY WNCPYSRC,ME1501C019
     C                   WRITE     MSGDTL
      *                                                                   CFT006
     C     *IN25         IFEQ      *ON                                                         CFT00
     C                   WRITE     HEADER                                                      CFT00
     C                   MOVE      *OFF          *IN25                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   SETOFF                                       5152
     C                   ENDIF
      *                                                                   CFT014
      *  Third Reimb Institution (if there is any)                        CFT014
      *                                                                   CFT014
     C     P55           IFNE      *BLANKS                                                     CFT01
     C                   MOVEL     P55           WUFDDT                                        CFT01
     C                   MOVEL     WUMTAG        HPRTG                                         CFT01
     C                   MOVEL     WUACCO        HPRDT                                         CFT01
     C                   MOVEL     WUORIG        HPROR1                                        CFT01
     C                   MOVE      WUORIG        HPROR2                                        CFT01
     C                   EXSR      RTVTGD                                                      CFT01
     C     *IN99         IFEQ      '0'                                                         CFT01
     C                   MOVEL     EFSCFD        HPRDS                                         CFT01
     C                   ELSE                                                                  CFT01
     C                   MOVEL     *BLANKS       HPRDS                                         CFT01
     C                   END                                                                   CFT01
     C     HPROR1        IFNE      *BLANKS                                                     CFT01
     C                   SETON                                        51                       CFT01
     C                   ENDIF                                                                 CFT01
     C     HPROR2        IFNE      *BLANKS                                                     CFT01
     C                   SETON                                        52                       CFT01
     C                   ENDIF                                                                 CFT01
     C                   WRITE     MSGDTL                                                      CFT01
      *                                                                   CFT014
     C     *IN25         IFEQ      *ON                                                         CFT01
     C                   WRITE     HEADER                                                      CFT01
     C                   MOVE      *OFF          *IN25                                         CFT01
     C                   ENDIF                                                                 CFT01
      *                                                                   CFT014
     C                   SETOFF                                       5152                     CFT01
     C                   ENDIF                                                                 CFT01
      *
      *  Intermediary (if there is any)
      *
     C/COPY WNCPYSRC,ME1501C020
     C     P56           IFNE      *BLANKS
     C/COPY WNCPYSRC,ME1501C021
     C                   MOVEL     P56           WUFDDT
     C/COPY WNCPYSRC,ME1501C022
     C                   MOVEL     WUMTAG        HPRTG
     C                   MOVEL     WUACCO        HPRDT
     C                   MOVEL     WUORIG        HPROR1
     C                   MOVE      WUORIG        HPROR2
     C***********KYDESC    CHAIN@EFREJ4              99                   CFT014
     C                   EXSR      RTVTGD                                                      CFT01
     C     *IN99         IFEQ      '0'
     C                   MOVEL     EFSCFD        HPRDS
     C                   ELSE
     C                   MOVEL     *BLANKS       HPRDS
     C                   END
     C     HPROR1        IFNE      *BLANKS
     C                   SETON                                        51
     C                   ENDIF
     C     HPROR2        IFNE      *BLANKS
     C                   SETON                                        52
     C                   ENDIF
     C/COPY WNCPYSRC,ME1501C023
     C                   WRITE     MSGDTL
      *                                                                   CFT006
     C     *IN25         IFEQ      *ON                                                         CFT00
     C                   WRITE     HEADER                                                      CFT00
     C                   MOVE      *OFF          *IN25                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   SETOFF                                       5152
     C                   ENDIF
      *
      *  Account with Institution (if there is any)
      *
     C     P57           IFNE      *BLANKS
     C/COPY WNCPYSRC,ME1501C024
     C                   MOVEL     P57           WUFDDT
     C/COPY WNCPYSRC,ME1501C025
     C                   MOVEL     WUMTAG        HPRTG
     C                   MOVEL     WUACCO        HPRDT
     C                   MOVEL     WUORIG        HPROR1
     C                   MOVE      WUORIG        HPROR2
     C***********KYDESC    CHAIN@EFREJ4              99                   CFT014
     C                   EXSR      RTVTGD                                                      CFT01
     C     *IN99         IFEQ      '0'
     C                   MOVEL     EFSCFD        HPRDS
     C                   ELSE
     C                   MOVEL     *BLANKS       HPRDS
     C                   END
     C     HPROR1        IFNE      *BLANKS
     C                   SETON                                        51
     C                   ENDIF
     C     HPROR2        IFNE      *BLANKS
     C                   SETON                                        52
     C                   ENDIF
     C/COPY WNCPYSRC,ME1501C026
     C                   WRITE     MSGDTL
      *                                                                   CFT006
     C     *IN25         IFEQ      *ON                                                         CFT00
     C                   WRITE     HEADER                                                      CFT00
     C                   MOVE      *OFF          *IN25                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   SETOFF                                       5152
     C                   ENDIF
      *
      *  Beneficiary Institution (if there is any)
      *
     C     P58           IFNE      *BLANKS
     C                   MOVEL     P58           WUFDDT
     C                   MOVEL     WUMTAG        HPRTG
     C                   MOVEL     WUACCO        HPRDT
     C                   MOVEL     WUORIG        HPROR1
     C                   MOVE      WUORIG        HPROR2
     C***********KYDESC    CHAIN@EFREJ4              99                   CFT014
     C                   EXSR      RTVTGD                                                      CFT01
     C     *IN99         IFEQ      '0'
     C                   MOVEL     EFSCFD        HPRDS
     C                   ELSE
     C                   MOVEL     *BLANKS       HPRDS
     C                   END
     C     HPROR1        IFNE      *BLANKS
     C                   SETON                                        51
     C                   ENDIF
     C     HPROR2        IFNE      *BLANKS
     C                   SETON                                        52
     C                   ENDIF
     C/COPY WNCPYSRC,ME1501C027
     C                   WRITE     MSGDTL
      *                                                                   CFT006
     C     *IN25         IFEQ      *ON                                                         CFT00
     C                   WRITE     HEADER                                                      CFT00
     C                   MOVE      *OFF          *IN25                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   SETOFF                                       5152
     C                   ENDIF
      *
      *  Beneficiary Customer (if there is any)
      *
     C     P59           IFNE      *BLANKS
     C                   MOVEL     P59           WUFDDT
     C                   MOVEL     WUMTAG        HPRTG
     C                   MOVEL     WUACCO        HPRDT
     C                   MOVEL     WUORIG        HPROR1
     C                   MOVE      WUORIG        HPROR2
     C***********KYDESC    CHAIN@EFREJ4              99                   CFT014
     C                   EXSR      RTVTGD                                                      CFT01
     C     *IN99         IFEQ      '0'
     C                   MOVEL     EFSCFD        HPRDS
     C                   ELSE
     C                   MOVEL     *BLANKS       HPRDS
     C                   END
     C     HPROR1        IFNE      *BLANKS
     C                   SETON                                        51
     C                   ENDIF
     C     HPROR2        IFNE      *BLANKS
     C                   SETON                                        52
     C                   ENDIF
     C/COPY WNCPYSRC,ME1501C028
     C                   WRITE     MSGDTL
      *                                                                   CFT006
     C     *IN25         IFEQ      *ON                                                         CFT00
     C                   WRITE     HEADER                                                      CFT00
     C                   MOVE      *OFF          *IN25                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   SETOFF                                       5152
     C                   ENDIF
      *
      *  Details of Payment (if there is any)
      *
     C     P70           IFNE      *BLANKS
     C                   MOVEL     P70           WUFDDT
     C                   MOVEL     WUMTAG        HPRTG
     C                   MOVEL     WUACCO        HPRDT
     C                   MOVEL     WUORIG        HPROR1
     C                   MOVE      WUORIG        HPROR2
     C***********KYDESC    CHAIN@EFREJ4              99                   CFT014
     C                   EXSR      RTVTGD                                                      CFT01
     C     *IN99         IFEQ      '0'
     C                   MOVEL     EFSCFD        HPRDS
     C                   ELSE
     C                   MOVEL     *BLANKS       HPRDS
     C                   END
     C     HPROR1        IFNE      *BLANKS
     C                   SETON                                        51
     C                   ENDIF
     C     HPROR2        IFNE      *BLANKS
     C                   SETON                                        52
     C                   ENDIF
     C/COPY WNCPYSRC,ME1501C029
     C                   WRITE     MSGDTL
      *                                                                   CFT006
     C     *IN25         IFEQ      *ON                                                         CFT00
     C                   WRITE     HEADER                                                      CFT00
     C                   MOVE      *OFF          *IN25                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   SETOFF                                       5152
     C                   ENDIF
      *                                                                                       CER030
      ** Processing of Extended narratives                                                    CER030
      *                                                                                       CER030
     C     CER031        IFEQ      'Y'
     C     PEXN          ANDNE     *BLANKS
     C                   MOVEL     PEXN          WUFDDT
     C                   MOVEL     WUMTAG        HPRTG
     C                   MOVEL     WUACCO        HPRDT
     C                   MOVEL     WUORIG        HPROR1
     C                   MOVE      WUORIG        HPROR2
     C                   EXSR      RTVTGD
     C     *IN99         IFEQ      *OFF
     C                   MOVEL     EFSCFD        HPRDS
     C                   ELSE
     C                   MOVEL     *BLANKS       HPRDS
     C                   END
     C     HPROR1        IFNE      *BLANKS
     C                   MOVE      *ON           *IN51
     C                   ENDIF
     C     HPROR2        IFNE      *BLANKS
     C                   MOVE      *ON           *IN52
     C                   ENDIF
      *                                                                                       CER030
     C                   WRITE     MSGDTL
      *                                                                                       CER030
     C     *IN25         IFEQ      *ON
     C                   WRITE     HEADER
     C                   MOVE      *OFF          *IN25
     C                   ENDIF
      *                                                                                       CER030
     C                   MOVE      *OFF          *IN51
     C                   MOVE      *OFF          *IN52
     C                   ENDIF
      *
      *  Details of Charges (if there is any)
      *
     C     P71           IFNE      *BLANKS
     C                   MOVEL     P71           WUFDDT
     C                   MOVEL     WUMTAG        HPRTG
     C                   MOVEL     WUACCO        HPRDT
     C                   MOVEL     WUORIG        HPROR1
     C                   MOVE      WUORIG        HPROR2
     C***********KYDESC    CHAIN@EFREJ4              99                   CFT014
     C                   EXSR      RTVTGD                                                      CFT01
     C     *IN99         IFEQ      '0'
     C                   MOVEL     EFSCFD        HPRDS
     C                   ELSE
     C                   MOVEL     *BLANKS       HPRDS
     C                   END
     C     HPROR1        IFNE      *BLANKS
     C                   SETON                                        51
     C                   ENDIF
     C     HPROR2        IFNE      *BLANKS
     C                   SETON                                        52
     C                   ENDIF
     C/COPY WNCPYSRC,ME1501C030
     C                   WRITE     MSGDTL
      *                                                                   CFT006
     C     *IN25         IFEQ      *ON                                                         CFT00
     C                   WRITE     HEADER                                                      CFT00
     C                   MOVE      *OFF          *IN25                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   SETOFF                                       5152
     C                   ENDIF
      *                                                                   CFT006
      *  Sender's Charges/Amount (if there is any)                        CFT006
      *                                                                   CFT006
     C     P71F          IFNE      *BLANKS                                                     CFT00
     C                   MOVEL     *BLANKS       WUFDDT                                        CFT00
     C                   MOVEL     P71F          WUFDDT                                        CFT00
     C                   MOVEL     WUMTAG        HPRTG                                         CFT00
     C                   MOVEL     WUORIG        TTCA                                          CFT00
     C                   MOVE      *BLANKS       HPROR1                                        17767
     C                   MOVE      *BLANKS       HPROR2                                        17767
     C                   MOVEL     TTCA          HPROR1                                        CFT00
     C***********KYDESC    CHAIN@EFREJ4              99            CFT006 CFT014
     C                   EXSR      RTVTGD                                                      CFT01
     C     *IN99         IFEQ      *OFF                                                        CFT00
     C                   MOVEL     EFSCFD        HPRDS                                         CFT00
     C                   ELSE                                                                  CFT00
     C                   MOVEL     *BLANKS       HPRDS                                         CFT00
     C                   ENDIF                                                                 CFT00
     C     HPROR1        IFNE      *BLANKS                                                     CFT00
     C                   MOVE      *ON           *IN51                                         CFT00
     C                   ENDIF                                                                 CFT00
     C                   WRITE     MSGDTL                                                      CFT00
      *                                                                   CFT006
     C     *IN25         IFEQ      *ON                                                         CFT00
     C                   WRITE     HEADER                                                      CFT00
     C                   MOVE      *OFF          *IN25                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
      *  Receiver's Charges/Amount (if there is any)                      CFT006
      *                                                                   CFT006
     C     P71G          IFNE      *BLANKS                                                     CFT00
     C                   MOVEL     *BLANKS       WUFDDT                                        CFT00
     C                   MOVEL     P71G          WUFDDT                                        CFT00
     C                   MOVEL     WUMTAG        HPRTG                                         CFT00
     C                   MOVEL     WUORIG        TTCA                                          CFT00
     C                   MOVE      *BLANKS       HPROR1                                        17767
     C                   MOVE      *BLANKS       HPROR2                                        17767
     C                   MOVEL     TTCA          HPROR1                                        CFT00
     C***********KYDESC    CHAIN@EFREJ4              99            CFT006 CFT014
     C                   EXSR      RTVTGD                                                      CFT01
     C     *IN99         IFEQ      *OFF                                                        CFT00
     C                   MOVEL     EFSCFD        HPRDS                                         CFT00
     C                   ELSE                                                                  CFT00
     C                   MOVEL     *BLANKS       HPRDS                                         CFT00
     C                   ENDIF                                                                 CFT00
     C     HPROR1        IFNE      *BLANKS                                                     CFT00
     C                   MOVE      *ON           *IN51                                         CFT00
     C                   ENDIF                                                                 CFT00
     C                   WRITE     MSGDTL                                                      CFT00
      *                                                                   CFT006
     C     *IN25         IFEQ      *ON                                                         CFT00
     C                   WRITE     HEADER                                                      CFT00
     C                   MOVE      *OFF          *IN25                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   ENDIF                                                                 CFT00
      *
      *  Bank to Bank information (if there is any)
      *
     C     P72           IFNE      *BLANKS
     C                   MOVEL     P72           WUFDDT
     C                   MOVEL     WUMTAG        HPRTG
     C                   SELECT                                                                CGL00
      *  For FONTIS                                                       CGL009
      *  We don't allow for the decoded field because tag 72              CGL009
      *  is not formated in the same way. (The first line can be          CGL009
      *  65 chars long and the other 35 chars)                            CGL009
     C     PNWRK         WHENEQ    'FONTIS'                                                    CGL00
     C                   MOVEL     F72           HPROR1                                        CGL00
     C                   MOVE      F72           HPROR2                                        CGL00
      *  Other Networks                                                   CGL009
     C                   OTHER                                                                 CGL00
     C                   MOVEL     WUACCO        HPRDT                                         CGL00
     C                   MOVEL     WUORIG        HPROR1                                        CGL00
     C                   MOVE      WUORIG        HPROR2                                        CGL00
     C                   ENDSL                                                                 CGL00
     C***********KYDESC    CHAIN@EFREJ4              99                   CFT014
     C                   EXSR      RTVTGD                                                      CFT01
     C     *IN99         IFEQ      '0'
     C                   MOVEL     EFSCFD        HPRDS
     C                   ELSE
     C                   MOVEL     *BLANKS       HPRDS
     C                   END
     C     HPROR1        IFNE      *BLANKS
     C                   SETON                                        51
     C                   ENDIF
     C     HPROR2        IFNE      *BLANKS
     C                   SETON                                        52
     C                   ENDIF
     C/COPY WNCPYSRC,ME1501C031
     C                   WRITE     MSGDTL
      *                                                                   CFT006
     C     *IN25         IFEQ      *ON                                                         CFT00
     C                   WRITE     HEADER                                                      CFT00
     C                   MOVE      *OFF          *IN25                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   SETOFF                                       5152
     C                   ENDIF
      *                                                                   CFT006
      *  Regulatory Reporting (if there is any)                           CFT006
      *                                                                   CFT006
     C     P77B          IFNE      *BLANKS                                                     CFT00
     C                   MOVEL     *BLANKS       WUFDDT                                        CFT00
     C                   MOVEL     P77B          WUFDDT                                        CFT00
     C                   MOVEL     WUMTAG        HPRTG                                         CFT00
     C                   MOVEL     WUACCO        HPRDT                                         CFT00
     C                   MOVEL     WUORIG        HPROR1                                        CFT00
     C                   MOVE      WUORIG        HPROR2                                        CFT00
     C***********KYDESC    CHAIN@EFREJ4              99            CFT006 CFT014
     C                   EXSR      RTVTGD                                                      CFT01
     C     *IN99         IFEQ      *OFF                                                        CFT00
     C                   MOVEL     EFSCFD        HPRDS                                         CFT00
     C                   ELSE                                                                  CFT00
     C                   MOVEL     *BLANKS       HPRDS                                         CFT00
     C                   ENDIF                                                                 CFT00
     C     HPROR1        IFNE      *BLANKS                                                     CFT00
     C                   MOVE      *ON           *IN51                                         CFT00
     C                   ENDIF                                                                 CFT00
     C     HPROR2        IFNE      *BLANKS                                                     CFT00
     C                   MOVE      *ON           *IN52                                         CFT00
     C                   ENDIF                                                                 CFT00
     C                   WRITE     MSGDTL                                                      CFT00
      *                                                                   CFT006
     C     *IN25         IFEQ      *ON                                                         CFT00
     C                   WRITE     HEADER                                                      CFT00
     C                   MOVE      *OFF          *IN25                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   MOVE      *OFF          *IN51                                         CFT00
     C                   MOVE      *OFF          *IN52                                         CFT00
     C                   ENDIF                                                                 CFT00
      *
      *  Sender Address Information (if there is any)
      *
     C     PSN           IFNE      *BLANKS
     C                   MOVEL     PSN           WUFDDT
     C                   MOVEL     WUMTAG        HPRTG
     C                   MOVEL     WUACCO        HPRDT
     C                   MOVEL     WUORIG        HPROR1
     C                   MOVE      WUORIG        HPROR2
     C***********KYDESC    CHAIN@EFREJ4              99                   CFT014
     C                   EXSR      RTVTGD                                                      CFT01
     C     *IN99         IFEQ      '0'
     C                   MOVEL     EFSCFD        HPRDS
     C                   ELSE
     C                   MOVEL     *BLANKS       HPRDS
     C                   END
     C     HPROR1        IFNE      *BLANKS
     C                   SETON                                        51
     C                   ENDIF
     C     HPROR2        IFNE      *BLANKS
     C                   SETON                                        52
     C                   ENDIF
     C/COPY WNCPYSRC,ME1501C032
     C                   WRITE     MSGDTL
      *                                                                   CFT006
     C     *IN25         IFEQ      *ON                                                         CFT00
     C                   WRITE     HEADER                                                      CFT00
     C                   MOVE      *OFF          *IN25                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   SETOFF                                       5152
     C                   ENDIF
     C/COPY WNCPYSRC,ME1501C033
     C     CSW209        IFEQ      'Y'
     C     PB50          IFNE      *BLANKS
     C                   MOVEL     *BLANKS       WUFDDT
     C                   MOVEL     PB50          WUFDDT
     C                   MOVEL     WUMTAG        HPRTG
     C                   MOVEL     WUACCO        HPRDT
     C                   MOVEL     WUORIG        HPROR1
     C                   MOVE      WUORIG        HPROR2
     C                   MOVE      'B'           WMSEQ
     C                   EXSR      RTVTGD
     C     *IN99         IFEQ      '0'
     C                   MOVEL     EFSCFD        HPRDS
     C                   ELSE
     C                   MOVEL     *BLANKS       HPRDS
     C                   END
     C     HPROR1        IFNE      *BLANKS
     C                   SETON                                        51
     C                   ENDIF
     C     HPROR2        IFNE      *BLANKS
     C                   SETON                                        52
     C                   ENDIF
     C                   WRITE     MSGDTL
      *                                                                                       CSW209
     C     *IN25         IFEQ      *ON
     C                   WRITE     HEADER
     C                   MOVE      *OFF          *IN25
     C                   ENDIF
      *                                                                                       CSW209
     C                   SETOFF                                       5152
     C                   ENDIF
      *
     C     PB52          IFNE      *BLANKS
     C                   MOVEL     *BLANKS       WUFDDT
     C                   MOVEL     PB52          WUFDDT
     C                   MOVEL     WUMTAG        HPRTG
     C                   MOVEL     WUACCO        HPRDT
     C                   MOVEL     WUORIG        HPROR1
     C                   MOVE      WUORIG        HPROR2
     C                   MOVE      'B'           WMSEQ
     C                   EXSR      RTVTGD
     C     *IN99         IFEQ      '0'
     C                   MOVEL     EFSCFD        HPRDS
     C                   ELSE
     C                   MOVEL     *BLANKS       HPRDS
     C                   END
     C     HPROR1        IFNE      *BLANKS
     C                   SETON                                        51
     C                   ENDIF
     C     HPROR2        IFNE      *BLANKS
     C                   SETON                                        52
     C                   ENDIF
     C                   WRITE     MSGDTL
      *                                                                                       CSW209
     C     *IN25         IFEQ      *ON
     C                   WRITE     HEADER
     C                   MOVE      *OFF          *IN25
     C                   ENDIF
      *                                                                                       CSW209
     C                   SETOFF                                       5152
     C                   ENDIF
      *                                                                                       CSW209
     C     PB56          IFNE      *BLANKS
     C                   MOVEL     *BLANKS       WUFDDT
     C                   MOVEL     PB56          WUFDDT
     C                   MOVEL     WUMTAG        HPRTG
     C                   MOVEL     WUACCO        HPRDT
     C                   MOVEL     WUORIG        HPROR1
     C                   MOVE      WUORIG        HPROR2
     C                   MOVE      'B'           WMSEQ
     C                   EXSR      RTVTGD
     C     *IN99         IFEQ      '0'
     C                   MOVEL     EFSCFD        HPRDS
     C                   ELSE
     C                   MOVEL     *BLANKS       HPRDS
     C                   END
     C     HPROR1        IFNE      *BLANKS
     C                   SETON                                        51
     C                   ENDIF
     C     HPROR2        IFNE      *BLANKS
     C                   SETON                                        52
     C                   ENDIF
     C                   WRITE     MSGDTL
      *                                                                                       CSW209
     C     *IN25         IFEQ      *ON
     C                   WRITE     HEADER
     C                   MOVE      *OFF          *IN25
     C                   ENDIF
      *                                                                                       CSW209
     C                   SETOFF                                       5152
     C                   ENDIF
      *                                                                                       CSW209
     C     PB57          IFNE      *BLANKS
     C                   MOVEL     *BLANKS       WUFDDT
     C                   MOVEL     PB57          WUFDDT
     C                   MOVEL     WUMTAG        HPRTG
     C                   MOVEL     WUACCO        HPRDT
     C                   MOVEL     WUORIG        HPROR1
     C                   MOVE      WUORIG        HPROR2
     C                   MOVE      'B'           WMSEQ
     C                   EXSR      RTVTGD
     C     *IN99         IFEQ      '0'
     C                   MOVEL     EFSCFD        HPRDS
     C                   ELSE
     C                   MOVEL     *BLANKS       HPRDS
     C                   END
     C     HPROR1        IFNE      *BLANKS
     C                   SETON                                        51
     C                   ENDIF
     C     HPROR2        IFNE      *BLANKS
     C                   SETON                                        52
     C                   ENDIF
     C                   WRITE     MSGDTL
      *                                                                                       CSW209
     C     *IN25         IFEQ      *ON
     C                   WRITE     HEADER
     C                   MOVE      *OFF          *IN25
     C                   ENDIF
      *                                                                                       CSW209
     C                   SETOFF                                       5152
     C                   ENDIF
      *                                                                                       CSW209
     C     PB59          IFNE      *BLANKS
     C                   MOVEL     *BLANKS       WUFDDT
     C                   MOVEL     PB59          WUFDDT
     C                   MOVEL     WUMTAG        HPRTG
     C                   MOVEL     WUACCO        HPRDT
     C                   MOVEL     WUORIG        HPROR1
     C                   MOVE      WUORIG        HPROR2
     C                   MOVE      'B'           WMSEQ
     C                   EXSR      RTVTGD
     C     *IN99         IFEQ      '0'
     C                   MOVEL     EFSCFD        HPRDS
     C                   ELSE
     C                   MOVEL     *BLANKS       HPRDS
     C                   END
     C     HPROR1        IFNE      *BLANKS
     C                   SETON                                        51
     C                   ENDIF
     C     HPROR2        IFNE      *BLANKS
     C                   SETON                                        52
     C                   ENDIF
     C                   WRITE     MSGDTL
      *                                                                                       CSW209
     C     *IN25         IFEQ      *ON
     C                   WRITE     HEADER
     C                   MOVE      *OFF          *IN25
     C                   ENDIF
      *                                                                                       CSW209
     C                   SETOFF                                       5152
     C                   ENDIF
      *                                                                                       CSW209
     C     PB70          IFNE      *BLANKS
     C                   MOVEL     *BLANKS       WUFDDT
     C                   MOVEL     PB70          WUFDDT
     C                   MOVEL     WUMTAG        HPRTG
     C                   MOVEL     WUACCO        HPRDT
     C                   MOVEL     WUORIG        HPROR1
     C                   MOVE      WUORIG        HPROR2
     C                   MOVE      'B'           WMSEQ
     C                   EXSR      RTVTGD
     C     *IN99         IFEQ      '0'
     C                   MOVEL     EFSCFD        HPRDS
     C                   ELSE
     C                   MOVEL     *BLANKS       HPRDS
     C                   END
     C     HPROR1        IFNE      *BLANKS
     C                   SETON                                        51
     C                   ENDIF
     C     HPROR2        IFNE      *BLANKS
     C                   SETON                                        52
     C                   ENDIF
     C                   WRITE     MSGDTL
      *                                                                                       CSW209
     C     *IN25         IFEQ      *ON
     C                   WRITE     HEADER
     C                   MOVE      *OFF          *IN25
     C                   ENDIF
      *                                                                                       CSW209
     C                   SETOFF                                       5152
     C                   ENDIF
      *                                                                                       CSW209
     C     PB72          IFNE      *BLANKS
     C                   MOVEL     *BLANKS       WUFDDT
     C                   MOVEL     PB72          WUFDDT
     C                   MOVEL     WUMTAG        HPRTG
     C                   MOVEL     WUACCO        HPRDT
     C                   MOVEL     WUORIG        HPROR1
     C                   MOVE      WUORIG        HPROR2
     C                   MOVE      'B'           WMSEQ
     C                   EXSR      RTVTGD
     C     *IN99         IFEQ      '0'
     C                   MOVEL     EFSCFD        HPRDS
     C                   ELSE
     C                   MOVEL     *BLANKS       HPRDS
     C                   END
     C     HPROR1        IFNE      *BLANKS
     C                   SETON                                        51
     C                   ENDIF
     C     HPROR2        IFNE      *BLANKS
     C                   SETON                                        52
     C                   ENDIF
     C                   WRITE     MSGDTL
      *                                                                                       CSW209
     C     *IN25         IFEQ      *ON
     C                   WRITE     HEADER
     C                   MOVE      *OFF          *IN25
     C                   ENDIF
      *                                                                                       CSW209
     C                   SETOFF                                       5152
     C                   ENDIF
      *                                                                                       CSW209
     C     PB33B         IFNE      *BLANKS
     C                   MOVEL     *BLANKS       WUFDDT
     C                   MOVEL     PB33B         WUFDDT
     C                   MOVEL     WUMTAG        HPRTG
     C                   MOVEL     WUORIG        TTCA
     C                   MOVE      *BLANKS       HPROR1
     C                   MOVE      *BLANKS       HPROR2
     C                   MOVE      TTCA          HPROR1
     C                   MOVE      'B'           WMSEQ
     C                   EXSR      RTVTGD
     C     *IN99         IFEQ      '0'
     C                   MOVEL     EFSCFD        HPRDS
     C                   ELSE
     C                   MOVEL     *BLANKS       HPRDS
     C                   END
     C     HPROR1        IFNE      *BLANKS
     C                   SETON                                        51
     C                   ENDIF
     C                   WRITE     MSGDTL
      *                                                                                       CSW209
     C     *IN25         IFEQ      *ON
     C                   WRITE     HEADER
     C                   MOVE      *OFF          *IN25
     C                   ENDIF
      *                                                                                       CSW209
     C                   SETOFF                                       51
      *                                                                                       CSW209
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSW209
      *  Message Header/Trailer (if there is any)
      *
     C     WUHK3         IFNE      *BLANKS
     C                   Z-ADD     1             H3
     C     HK3(H3)       DOWNE     *BLANKS
     C     H3            ANDLE     WUHDNO
     C                   MOVEL     HK3(H3)       HPRTG
     C                   MOVEL     HK4(H3)       HPROR1
     C***********KYDESC    CHAIN@EFREJ4              99                   CFT014
     C                   EXSR      RTVTGD                                                      CFT01
     C     *IN99         IFEQ      '0'
     C                   MOVEL     EFSCFD        HPRDS
     C                   ELSE
     C                   MOVEL     *BLANKS       HPRDS
     C                   END
     C     HPROR1        IFNE      *BLANKS
     C                   SETON                                        51
     C                   ENDIF
     C/COPY WNCPYSRC,ME1501C034
     C                   WRITE     MSGDTL                               99
     C                   SETOFF                                       51
     C                   ADD       1             H3
      *
      *  Write Report Header if overflow
      *
     C     *IN99         IFEQ      '1'
     C                   WRITE     HEADER
     C                   SETOFF                                       99
     C                   ENDIF
      *
     C                   ENDDO
     C                   ENDIF
      *
      *  Other details (if there is any)
      *
     C     WUHK5         IFNE      *BLANKS
     C                   Z-ADD     1             H4
     C     HK5(H4)       DOWNE     *BLANKS
     C     H4            ANDLE     WUHDNO
     C                   MOVEL     HK5(H4)       HPRTG
     C                   MOVEL     HK6(H4)       HPROR1
     C***********KYDESC    CHAIN@EFREJ4              99                   CFT014
     C                   EXSR      RTVTGD                                                      CFT01
     C     *IN99         IFEQ      '0'
     C                   MOVEL     EFSCFD        HPRDS
     C                   ELSE
     C                   MOVEL     *BLANKS       HPRDS
     C                   END
     C     HPROR1        IFNE      *BLANKS
     C                   SETON                                        51
     C                   ENDIF
     C/COPY WNCPYSRC,ME1501C035
     C                   WRITE     MSGDTL                               99
     C                   SETOFF                                       51
     C                   ADD       1             H4
      *
      *  Write Report Header if overflow
      *
     C     *IN99         IFEQ      '1'
     C                   WRITE     HEADER
     C                   SETOFF                                       99
     C                   ENDIF
      *
     C                   ENDDO
     C                   ENDIF
      *
      *  Footer
      *
     C                   WRITE     FOOTER
      *
      * Close printer file
      *
     C                   CLOSE     ME1501P1
      *
      *  Unwind subroutine stack name
      *
     C     #HXAUD        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUCHK   : CHECK FUNCTION (USER DEFINED)                     *
      *                                                               *
      *  CALLED BY: #HFDDT #H1AMT                                     *
      *                                                               *
      *  CALLS    :        -                                          *
      *                                                               *
      *****************************************************************
     CSR   SRUCHK        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRUCHK'      @STK(Q)
      *
      ** Must look like a function
     C     WUASTK        IFNE      '*'
     C                   GOTO      SRUCKF
     C                   ENDIF
      *
      ** Check that the user defined function exists
      ** (So as to be abble to call the programm tied to it)
      *
      ** Its no use performing the search if the array is empty
     C     WEMPCK        IFEQ      *BLANKS
     C     @CK(1)        IFEQ      *BLANKS
     C                   MOVEL     'Y'           WEMPCK            1
     C                   GOTO      SRUCKF
     C                   ELSE
     C                   MOVEL     'N'           WEMPCK
     C                   ENDIF
     C                   ELSE
     C     WEMPCK        IFEQ      'Y'
     C                   GOTO      SRUCKF
     C                   ENDIF
     C                   ENDIF
      *
      ** Before performing a dichotomic search we ensure that
      ** the array is sorted and the beginning and the end are
      ** known
     C     WSRTCK        IFEQ      *BLANK
     C                   MOVEL     'Y'           WSRTCK            1
      *
      ** Length of @CK = end of the array
     C                   Z-ADD     200           WE                3 0
     C     *LIKE         DEFINE    WE            WB
     C     *LIKE         DEFINE    WE            WS
     C     *LIKE         DEFINE    WE            WF
     C     *LIKE         DEFINE    WE            WP
     C     *LIKE         DEFINE    WE            WEB
      *
     C                   SORTA     @CK
      *
      ** Determine the beginning of the Array
     C                   Z-ADD     1             WB
     C     WB            DOWLT     WE
     C     @CK(WB)       IFNE      *BLANK
     C                   LEAVE
     C                   ENDIF
     C                   ADD       1             WB
     C                   ENDDO
      *
     C                   ENDIF
      *
      ** SEARCH
      *
      ** Extract Function (e.g *MYFNC, *M ... )                                               162508
     C     *LIKE         DEFINE    WUFUNC        WUFNCT
     C                   Z-ADD     0             WLF               2 0
     C                   MOVEL     *BLANK        WUFNCT
     C                   MOVEL     *BLANK        P#PTTN
     C     ' '           SCAN      WUFUNC        WLF                    90
     C     *IN90         IFEQ      '1'
     C                   GOTO      SRUCKF
     C                   ENDIF
     C     WLF           IFEQ      0
      ** Special case where the name of the function fills                                    162508
      ** all the file field (e.g 5 digits)                                                    162508
     C                   Z-ADD     5             WLF               2 0
     C                   MOVEL     WUFUNC        WUFNCT
     C                   ADD       2             WLF
     C                   ELSE
     C     WLF           SUBST     WUFUNC        WUFNCT                 90
     C                   ADD       1             WLF
     C                   ENDIF
      ** Extract pattern (e.g *MYFNC <PATTERN> )                                              162508
     C                   SUBST     WUCRIT:WLF    P#PTTN                 90
     C     *IN90         IFEQ      '1'
     C                   GOTO      SRUCKF
     C                   ENDIF
      *                                                                                       162508
     C                   Z-ADD     WB            WS
     C                   Z-ADD     WE            WF
     C     WS            DOWLE     WF
      ** WP = (WS + WF) / 2
     C     WS            ADD       WF            WP
     C     WP            MULT      0.5           WP
     C                   MOVEA     @CK(WP)       @CKDS
     C                   SELECT
      ** Search succeeds
     C***********@CKFNC    WHEQ WUFUNC                                                        162508
     C     @CKFNC        WHENEQ    WUFNCT
     C     *LIKE         DEFINE    WUTGCK        P#CHKP
     C/COPY WNCPYSRC,ME1501C037
     C                   CALL      @CKPGM                               90
     C                   PARM      *BLANK        P#RETN            7
     C                   PARM                    PHEAD
     C                   PARM                    PDATA
     C                   PARM                    PDAT2
     C                   PARM      WUTGCK        P#CHKP
     C                   PARM                    P#PTTN           32
     C                   PARM                    GDOPER
     C/COPY WNCPYSRC,ME1501C038
     C     P#RETN        IFEQ      'T'
     C     *IN90         ANDEQ     '0'
     C                   MOVE      'Y'           WUMATH
     C                   ENDIF
     C                   LEAVE
      *
     C***********@CKFNC    WHLT WUFUNC                                                        162508
     C     @CKFNC        WHENLT    WUFNCT
      ** Search will be performed at the right side of pivot
      ** WS = WP + 1
     C     WP            ADD       1             WS
      *
     C***********@CKFNC    WHGT WUFUNC                                                        162508
     C     @CKFNC        WHENGT    WUFNCT
      ** Search will be performed at the left side of pivot
      ** WF = WP - 1
     C     WP            SUB       1             WF
      *
     C                   ENDSL
     C                   ENDDO
      *
      *
      ***Unwind subroutine stack name*******                                                  CRE008
      *
     C     SRUCKF        TAG
      *                                                                                       CRE008
      **  Process function from extended user check file                                      CRE008
     C                   EXSR      SRECHK
      *                                                                                       CRE008
      *  Unwind subroutine stack name                                                         CRE008
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     CSR                 ENDSR
      *****************************************************************   CRE008
      /EJECT                                                              CRE008
      *****************************************************************   CRE008
      *                                                               *   CRE008
      *  SRECHK   : CHECK FUNCTION (USER DEFINED) -Extended use       *   CRE008
      *             This subroutine works in the same principle as    *   CRE008
      *             SRUCHK, except that it uses the check programs    *   CRE008
      *             defined in MEECHKPD rather than MEUCHKPD.         *   CRE008
      *             When found in MECHKPD, the exit program allows    *   CRE008
      *             a more extensive field comparison by matching     *   CRE008
      *             the test field against other fields in the same   *   CRE008
      *             message.  Also, it is able to pass back any       *   CRE008
      *             significant fields to the calling program.        *   CRE008
      *                                                               *   CRE008
      *  CALLED BY: SRUCHK                                            *   CRE008
      *                                                               *   CRE008
      *  CALLS    :        -                                          *   CRE008
      *                                                               *   CRE008
      *****************************************************************   CRE008
     CSR   SRECHK        BEGSR                                                                 CRE00
      *                                                                   CRE008
      *  Set up subroutine stack name                                     CRE008
      *                                                                   CRE008
     C                   ADD       1             Q                 5 0                         CRE00
     C                   MOVEL     'SRECHK'      @STK(Q)                                       CRE00
      *                                                                   CRE008
      ** Must look like a function                                        CRE008
     C     WUASTK        IFNE      '*'                                                         CRE00
     C                   GOTO      SRECKF                                                      CRE00
     C                   ENDIF                                                                 CRE00
      *                                                                   CRE008
      ** Check that the user defined function exists                      CRE008
      ** (So as to be abble to call the programm tied to it)              CRE008
      *                                                                   CRE008
      ** Its no use performing the search if the array is empty           CRE008
     C     WEMPCE        IFEQ      *BLANKS                                                     CRE00
     C     @CE(1)        IFEQ      *BLANKS                                                     CRE00
     C                   MOVEL     'Y'           WEMPCE            1                           CRE00
     C                   GOTO      SRECKF                                                      CRE00
     C                   ELSE                                                                  CRE00
     C                   MOVEL     'N'           WEMPCE                                        CRE00
     C                   ENDIF                                                                 CRE00
     C                   ELSE                                                                  CRE00
     C     WEMPCE        IFEQ      'Y'                                                         CRE00
     C                   GOTO      SRECKF                                                      CRE00
     C                   ENDIF                                                                 CRE00
     C                   ENDIF                                                                 CRE00
      *                                                                   CRE008
      ** Before performing a dichotomic search we ensure that             CRE008
      ** the array is sorted and thf wsrtcking and the end are            CRE008
      ** known                                                            CRE008
     C     WSRTCE        IFEQ      *BLANK                                                      CRE00
     C                   MOVEL     'Y'           WSRTCE            1                           CRE00
      *                                                                   CRE008
      ** Length of @CE = end of the array                                 CRE008
     C**********           Z-ADD200       WE      30                                 CRE008 AR936976
     C                   Z-ADD     200           WEE               3 0
      *                                                                   CRE008
     C                   SORTA     @CE                                                         CRE00
      *                                                                   CRE008
      ** Determine the beginning of the Array                             CRE008
     C**********           Z-ADD1         WB                                         CRE008 AR936976
     C********** WB        DOWLTWE                                                   CRE008 AR936976
     C********** @CE,WB    IFNE *BLANK                                               CRE008 AR936976
     C                   Z-ADD     1             WEB
     C     WEB           DOWLT     WEE
     C     @CE(WEB)      IFNE      *BLANK
     C                   LEAVE                                                                 CRE00
     C                   ENDIF                                                                 CRE00
     C**********           ADD  1         WB                                         CRE008 AR936976
     C                   ADD       1             WEB
     C                   ENDDO                                                                 CRE00
      *                                                                   CRE008
     C                   ENDIF                                                                 CRE00
      *                                                                   CRE008
      ** SEARCH                                                           CRE008
      *                                                                   CRE008
      ** Extract Function (e.g *MYFNC, *M ... )                           CRE008
     C                   Z-ADD     0             WLF               2 0                         CRE00
     C                   MOVEL     *BLANK        WUFNCT                                        CRE00
     C                   MOVEL     *BLANK        P#PTTN                                        CRE00
     C     ' '           SCAN      WUFUNC        WLF                    90                     CRE00
     C     *IN90         IFEQ      '1'                                                         CRE00
     C                   GOTO      SRECKF                                                      CRE00
     C                   ENDIF                                                                 CRE00
     C     WLF           IFEQ      0                                                           CRE00
      ** Special case where the name of the function fills                CRE008
      ** all the file field (e.g 5 digits)                                CRE008
     C                   Z-ADD     5             WLF               2 0                         CRE00
     C                   MOVEL     WUFUNC        WUFNCT                                        CRE00
     C                   ADD       2             WLF                                           CRE00
     C                   ELSE                                                                  CRE00
     C     WLF           SUBST     WUFUNC        WUFNCT                 90                     CRE00
     C                   ADD       1             WLF                                           CRE00
     C                   ENDIF                                                                 CRE00
      ** Extract pattern (e.g *MYFNC <PATTERN> )                          CRE008
     C                   SUBST     WUCRIT:WLF    P#PTTN                 90                     CRE00
     C     *IN90         IFEQ      '1'                                                         CRE00
     C                   GOTO      SRECKF                                                      CRE00
     C                   ENDIF                                                                 CRE00
      *                                                                   CRE008
     C**********           Z-ADDWB        WS                                         CRE008 AR936976
     C**********           Z-ADDWE        WF                                         CRE008 AR936976
     C                   Z-ADD     WEB           WS
     C                   Z-ADD     WEE           WF
     C     WS            DOWLE     WF                                                          CRE00
      ** WP = (WS + WF) / 2                                               CRE008
     C     WS            ADD       WF            WP                                            CRE00
     C     WP            MULT      0.5           WP                                            CRE00
     C                   MOVEA     @CE(WP)       @CKDS                                         CRE00
     C                   SELECT                                                                CRE00
      ** Search succeeds                                                  CRE008
     C     @CKFNC        WHENEQ    WUFNCT                                                      CRE00
     C                   CALL      @CKPGM                               90                     CRE00
     C                   PARM      *BLANK        P#RETN            7                           CRE00
     C                   PARM                    PHEAD                                         CRE00
     C                   PARM                    PDATA                                         CRE00
     C                   PARM                    PDAT2
     C                   PARM      WUTGCK        P#CHKP                                        CRE00
     C                   PARM                    P#PTTN           32                           CRE00
     C                   PARM                    GDOPER                                        CRE00
     C                   PARM                    GDMTAG                                        CRE00
     C                   PARM                    GDREPT                                        CRE00
     C                   PARM                    W0CPGM                                        CRE00
     C     RETFLD        PARM      *BLANK        RETFLD          256                           CRE00
      *                                                                   CRE008
     C     P#RETN        IFEQ      'T'                                                         CRE00
     C     *IN90         ANDEQ     '0'                                                         CRE00
     C                   MOVE      'Y'           WUMATH                                        CRE00
     C* If RETFLD <> blank, accumulate to P@RETV                          CRE008
     C     RETFLD        IFNE      *BLANK                                                      CRE00
     C     P@RETV        CAT       '/':0         P@RETV                                        CRE00
     C     P@RETV        CAT       RETFLD:0      P@RETV                                        CRE00
     C                   ENDIF                                                                 CRE00
     C                   ENDIF                                                                 CRE00
     C                   LEAVE                                                                 CRE00
      *                                                                   CRE008
     C     @CKFNC        WHENLT    WUFNCT                                                      CRE00
      ** Search will be performed at the right side of pivot              CRE008
      ** WS = WP + 1                                                      CRE008
     C     WP            ADD       1             WS                                            CRE00
      *                                                                   CRE008
     C     @CKFNC        WHENGT    WUFNCT                                                      CRE00
      ** Search will be performed at the left side of pivot               CRE008
      ** WF = WP - 1                                                      CRE008
     C     WP            SUB       1             WF                                            CRE00
      *                                                                   CRE008
     C                   ENDSL                                                                 CRE00
     C                   ENDDO                                                                 CRE00
      *                                                                   CRE008
      *  Unwind subroutine stack name                                     CRE008
      *                                                                   CRE008
     C     SRECKF        TAG                                                                   CRE00
      *                                                                   CRE008
     C                   MOVEA     *BLANKS       @STK(Q)                                       CRE00
     C                   SUB       1             Q                                             CRE00
     CSR                 ENDSR                                                                 CRE00
      /EJECT
      *****************************************************************   CFT014
      *                                                               *   CFT014
      *  RTVTGD   : RETRIEVE TAG DESCRIPTION                          *   CFT014
      *                                                               *   CFT014
      *  CALLED BY: #HAUDT                                            *   CFT014
      *                                                               *   CFT014
      *  CALLS    :        -                                          *   CFT014
      *                                                               *   CFT014
      *****************************************************************   CFT014
     CSR   RTVTGD        BEGSR                                                                 CFT01
      *                                                                   CFT014
      *  Set up subroutine stack name                                     CFT014
      *                                                                   CFT014
     C                   ADD       1             Q                 5 0                         CFT01
     C                   MOVEL     'RTVTGD'      @STK(Q)                                       CFT01
     C*****KYDSC1        CHAIN     @EFREJ4                            99                    MD056560
     C/EXEC SQL                                                                             MD056560
     C+ SELECT *                                                                            MD056560
     C+ into :DSMTAG                                                                        MD056560
     C+ from SDMTGJW0                                                                       MD056560
     C+ where EFMTAG = :HPRTG  and EFMTPY = :PMTPY  and EFMSEQ = :WMSEQ                     MD056560
     C/END-EXEC                                                                             MD056560
     C******IN99         IFEQ      '1'                                                      MD056560
     C                   IF        SQLCODE = 100                                            MD056560
      *                                                                   CFT014
      *  Find first the tag description tied to the specific              CFT014
      *  message type, if not found then find the tag desciption          CFT014
      *  applicable for ALL the message type                              CFT014
     C*****KYDSC2        CHAIN     @EFREJ4                            99              CFT01 MD056560
     C/EXEC SQL                                                                             MD056560
     C+ SELECT *                                                                            MD056560
     C+ into :DSMTAG                                                                        MD056560
     C+ from SDMTGJW0                                                                       MD056560
     C+ where EFMTAG = :HPRTG  and EFMTPY = :PMTPY  and EFMSEQ = :WBMSEQ                    MD056560
     C/END-EXEC                                                                             MD056560
     C******IN99         IFEQ      '1'                                                      MD056560
     C                   IF        SQLCODE = 100                                            MD056560
     C*****KYDESC        CHAIN     @EFREJ4                            99              CFT01 MD056560
     C/EXEC SQL                                                                             MD056560
     C+ SELECT *                                                                            MD056560
     C+ into :DSMTAG                                                                        MD056560
     C+ from SDMTGJW0                                                                       MD056560
     C+ where EFMTAG = :HPRTG  and EFMTPY = :A#MTPY and EFMSEQ = :WBMSEQ                    MD056560
     C/END-EXEC                                                                             MD056560
     C                   ENDIF                                                                 CFT01
     C                   ENDIF
      *                                                                   CFT014
     C                   IF        SQLCODE = 100                                            MD056560
     C                   seton                                        99                    MD056560
     C                   Endif                                                              MD056560
      *  Unwind subroutine stack name                                     CFT014
      *                                                                   CFT014
     C     RTTGDF        TAG                                                                   CFT01
     C                   MOVEA     *BLANKS       @STK(Q)                                       CFT01
     C                   SUB       1             Q                                             CFT01
     CSR                 ENDSR                                                                 CFT01
      /EJECT                                                              CFT014
      *****************************************************************
      *                                                               *
      *  STRFNC   : *STR FUNCTION                                     *
      *                                                               *
      *  CALLED BY: #HFDDT #H1AMT                                     *
      *                                                               *
      *  CALLS    :        -                                          *
      *                                                               *
      *****************************************************************
     CSR   STRFNC        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'STRFNC'      @STK(Q)
      ** *STRXXX <pattern> check there s a blank between XXX and
      ** <pattern>
     C     WUBLNK        IFNE      *BLANK
     C                   GOTO      STRFNF
     C                   ENDIF
      ** only test :tag: EQ *STRXXX <pattern>
      **           :tag: NE *STRXXX <pattern>
      ** are allowed
     C     GDOPER        IFNE      'EQ'
     C     GDOPER        ANDNE     'NE'
     C                   GOTO      STRFNF
     C                   ENDIF
      *
      ** *STRXXX XXX numeric ?
     C     WNUMB         CHECK     WUSLEA                                 90
     C     *IN90         IFEQ      '0'
     C                   Z-ADD     0             WPTTN             3 0
     C                   Z-ADD     0             WLC               2 0
      ** Determine the length of the comparison string
     C     ' '           CHECKR    WUSCMP        WLC
     C     WLC           IFGT      0
     C     WUSLEN        IFEQ      0
      ** All the :tag: will be scanned
     C     PNWRK         IFEQ      'FONTIS'                                                    CGL00
     C     GDMTAG        ANDEQ     ':72:'                                                      CGL00
     C     WUSCMP:WLC    SCAN      F72           WPTTN                  90                     CGL00
     C                   ELSE                                                                  CGL00
     C     WUSCMP:WLC    SCAN      WUO           WPTTN                  90
     C                   ENDIF                                                                 CGL00
     C                   ELSE
      ** The :tag: will be scanned partially
     C     PNWRK         IFEQ      'FONTIS'                                                    CGL00
     C     GDMTAG        ANDEQ     ':72:'                                                      CGL00
     C     WUSCMP:WLC    SCAN      F72:WUSLEN    WPTTN                  90                     CGL00
     C                   ELSE                                                                  CGL00
     C     WUSCMP:WLC    SCAN      WUO:WUSLEN    WPTTN                  90
     C                   ENDIF                                                                 CGL00
     C                   ENDIF
     C     *IN90         IFEQ      '0'
     C     WPTTN         ANDNE     0
     C                   MOVE      'Y'           WUMATH
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      *  Unwind subroutine stack name
      *
     C     STRFNF        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     CSR                 ENDSR
      /EJECT
     C/COPY WNCPYSRC,ME1501C036
      *****************************************************************
      *                                                               *
      *  #HINIT   : Initialise and define fields                      *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *  CALLS    :        -                                          *
      *                                                               *
      *****************************************************************
     CSR   #HINIT        BEGSR
      *
      *  Set up copyright statement
      *
     C                   MOVEA     CPY@          BIS@             80
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     '#HINIT'      @STK(Q)
      *
      *  Set up no. of entries per criteria table record
      *
     C                   Z-ADD     6             WUCRNO            1 0
      *
      *  Set up no. of entries per Header/Trailer array
      *
     C                   Z-ADD     28            WUHDNO            2 0
      *
      *  Set up Overflow line no.
      *
     C                   Z-ADD     60            WUOVFL            2 0
      *
      *  Set up max. no. of entries on Vostro A/c code array
      *
     C**********           Z-ADD20        WUVOAC  20                                          197953
     C                   Z-ADD     100           WUVOAC            3 0
      *
      * Set keylist for Auto-Gen Criteria Control File
      *
     C     KYGNCR        KLIST
     C                   KFLD                    PMTPY
     C                   KFLD                    GNMSET
      *
     C     KYGNC2        KLIST
     C                   KFLD                    PMTPY
      *
      * Set keylist for Auto-Gen Criteria Details File
      *
     C     KYGNDT        KLIST
     C                   KFLD                    PMTPY
     C                   KFLD                    GDMSET
     C                   KFLD                    GDCSEQ
      *
      * Set keylist for Message Details File
      *
     C     KYINDT        KLIST
     C                   KFLD                    PHMSGR
     C                   KFLD                    WKPART
     C                   KFLD                    GDMTAG
     C     *LIKE         DEFINE    PHPART        WKPART
      *
      * Set keylist for Account master File
      *
     C     KYACCO        KLIST
     C                   KFLD                    WUCNUM
     C                   KFLD                    WUCURR
     C                   KFLD                    WUACCD
     C                   KFLD                    WUACSQ
     C                   KFLD                    WUBRCA
     C                   MOVEL     *BLANKS       WBMSEQ
      *
      * Set keylist for Message tag description
      *
     C     KYDESC        KLIST
     C                   KFLD                    HPRTG
     C                   KFLD                    A#MTPY
     C                   KFLD                    WBMSEQ
     C     *LIKE         DEFINE    EFMSEQ        WMSEQ
     C     *LIKE         DEFINE    EFMSEQ        WBMSEQ
     C     *LIKE         DEFINE    PMTPY         A#MTPY
     C                   MOVEL     'ALL'         A#MTPY
      *                                                                                       CSW209
      ** Set keylist for Message tag description 1                                            CSW209
      *                                                                                       CSW209
     C     KYDSC1        KLIST
     C                   KFLD                    HPRTG
     C                   KFLD                    PMTPY
     C                   KFLD                    WMSEQ
      *                                                                   CFT014
      ** Set keylist for Message tag description                          CFT014
      *                                                                   CFT014
     C     KYDSC2        KLIST                                                                 CFT01
     C                   KFLD                    HPRTG                                         CFT01
     C                   KFLD                    PMTPY                                         CFT01
     C                   KFLD                    WBMSEQ
      *
      * Set keylist for Bic Directory
      *
     C     KYBICD        KLIST
     C                   KFLD                    BDBICC
     C                   KFLD                    BDBICB
      *
      * Set keylist for Message parts
      *
     C     KYMPL1        KLIST
     C                   KFLD                    PHMSGR
     C                   KFLD                    PHPART
      *
      ** Extract bank details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *                                                                   CFT006
      ** Access SAR details file to determine if CFT006 is switched ON    CFT006
      *                                                                   CFT006
     C                   MOVE      'N'           CFT006                                        CFT00
     C                   CALL      'AOSARDR0'                                                  CFT00
     C                   PARM      *BLANKS       @RTCD             7                           CFT00
     C                   PARM      '*VERIFY'     @OPTN             7                           CFT00
     C                   PARM      'CFT006'      @SARD             6                           CFT00
     C     SCSARD        PARM      SCSARD        DSFDY                                         CFT00
      *                                                                   CFT006
      ** If core feature is switched ON, set a variable to condition      CFT006
      ** the rest of the processing                                       CFT006
      *                                                                   CFT006
     C     @RTCD         IFEQ      *BLANKS                                                     CFT00
     C                   MOVE      'Y'           CFT006            1                           CFT00
     C                   ELSE                                                                  CFT00
      *                                                                   CFT006
     C                   MOVE      'N'           CFT006            1                           CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
      ** Access SAR details file to determine if CFT008 is switched ON    CFT006
      *                                                                   CFT006
     C                   MOVE      'N'           CFT008            1                           CFT00
     C                   CALL      'AOSARDR0'                                                  CFT00
     C                   PARM      *BLANKS       @RTCD             7                           CFT00
     C                   PARM      '*VERIFY'     @OPTN             7                           CFT00
     C                   PARM      'CFT008'      @SARD             6                           CFT00
     C     SCSARD        PARM      SCSARD        DSFDY                                         CFT00
      *                                                                   CFT006
      ** If core feature is switched ON, set a variable to condition      CFT006
      ** the rest of the processing                                       CFT006
      *                                                                   CFT006
     C     @RTCD         IFEQ      *BLANKS                                                     CFT00
     C                   MOVE      'Y'           CFT008                                        CFT00
     C                   ELSE                                                                  CFT00
      *                                                                   CFT006
     C                   MOVE      'N'           CFT008                                        CFT00
     C                   ENDIF                                                                 CFT00
      *
      *  Access SAR details file to see if CFT007 is installed.           CFT007
      *                                                                   CFT007
     C                   CALL      'AOSARDR0'                                                  CFT00
     C                   PARM      *BLANKS       P@RTCD            7                           CFT00
     C                   PARM      '*VERIFY'     P@OPTN            7                           CFT00
     C                   PARM      'CFT007'      @SARD             6                           CFT00
     C     SCSARD        PARM      *BLANKS       DSFDY                                         CFT00
      *                                                                   CFT007
      *  Allow BIC Database Plus Integration                              CFT007
      *                                                                   CFT007
     C     P@RTCD        IFEQ      *BLANKS                                                     CFT00
     C                   MOVE      *ON           CFT007            1                           CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT007
      *                                                                                     MD022652
      ** Access SAR details file to see if CFT050 is installed.                             MD022652
      *                                                                                     MD022652
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY'     POPTN             7
     C                   PARM      'CFT050'      PSARD             6
     C     SCSARD        PARM      *BLANKS       DSFDY
      *                                                                                     MD022652
      ** CFT007 process will take place when CFT050 is switched on                          MD022652
      *                                                                                     MD022652
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      *ON           CFT007
     C                   ENDIF
      *                                                                                     MD022652
      *  Get Rundate information
      *
     C     *DTAARA       DEFINE    RUNDAT        RUNDTA
     C                   IN        RUNDTA
     C                   MOVE      AGMRDT        WUMRDT            7            Midas Run date
     C                   MOVE      AGRDNB        WURDNB            5 0          Run day number
     C                   MOVE      AGSUC         WUSUC             1            Set up complete
     C                   MOVE      AGDFF         WUDFF             1            Date Format
     C                   MOVE      AGMBIN        WUMBIN            1            Multi Branched
     C     WUDFF         COMP      'M'                                    98
      *
      *  Convert Midas date to YYMMDD format
      *
     C                   CALL      'ZM0060'
     C                   PARM      WURDNB        P@RDNB            5 0
     C                   PARM      *BLANKS       ##YMD             6
      *
      *  Load Vostro A/c code array
      *
     C     *LOVAL        SETLL     @A5REA6
     C                   Z-ADD     *ZERO         H1                5 0
     C                   READ      @A5REA6                                99
     C     *IN99         DOWEQ     '0'
     C     H1            ANDLT     WUVOAC
     C                   ADD       1             H1
     C                   MOVEL     A5ACCD        HK1(H1)
     C                   READ      @A5REA6                                99
     C                   END
      *                                                                   CFT004
      ** Access SAR details file to see if CFT004 is installed.           CFT004
      *                                                                   CFT004
     C                   CALL      'AOSARDR0'                                                  CFT00
     C                   PARM      *BLANKS       P@RTCD            7                           CFT00
     C                   PARM      '*VERIFY'     P@OPTN            7                           CFT00
     C                   PARM      'CFT004'      P@SARD            6                           CFT00
     C     SCSARD        PARM      *BLANKS       DSFDY                                         CFT00
      *                                                                   CFT004
      ** Allow IBAN processing                                            CFT004
      *                                                                   CFT004
     C     P@RTCD        IFEQ      *BLANKS                                                     CFT00
     C                   MOVE      'Y'           CFT004            1                           CFT00
     C                   ELSE                                                                  CFT00
     C                   MOVE      'N'           CFT004                                        CFT00
     C                   END                                                                   CFT00
      *                                                                                       CSW209
     C                   CALL      'SWIF2009'
     C                   PARM                    P@RTCD
     C     P@RTCD        IFEQ      'CSW2009'
     C                   MOVE      'Y'           CSW209            1
     C                   ELSE
     C                   MOVE      'N'           CSW209
     C                   ENDIF
      *                                                                                       CSW209
      *                                                                   CRE008
      ** Access SAR details file to see if CRE008 is installed.           CRE008
      *                                                                   CRE008
     C                   CALL      'AOSARDR0'                                                  CRE00
     C                   PARM      *BLANKS       P@RTCD            7                           CRE00
     C                   PARM      '*VERIFY'     P@OPTN            7                           CRE00
     C                   PARM      'CRE008'      P@SARD            6                           CRE00
     C     SCSARD        PARM      *BLANKS       DSFDY                                         CRE00
      *                                                                   CRE008
      ** Allow IBAN processing                                            CRE008
      *                                                                   CRE008
     C     P@RTCD        IFEQ      *BLANKS                                                     CRE00
     C                   MOVE      'Y'           CRE008            1                           CRE00
     C                   ELSE                                                                  CRE00
     C                   MOVE      'N'           CRE008                                        CRE00
     C                   END                                                                   CRE00
      *                                                                                       CER030
      ** Check the switchable feature CER031                                                  CER030
      *                                                                                       CER030
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY'     POPTN             7
     C                   PARM      'CER031'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CER030
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CER031            1
     C                   ELSE
     C                   MOVEL     'N'           CER031
     C                   ENDIF
     C/COPY WNCPYSRC,ME1501C003
      *                                                                                     AR918987
      ***ACCESS*SAR*DETAILS*FILE*TO*SEE*IF*UUC068*IS*INSTALLED.                      AR918987 CFT162
      ** ACCESS SAR DETAILS FILE TO SEE IF CFT162 IS INSTALLED.                               CFT162
      *                                                                                     AR918987
     C                   CALL      'AOSARDR0'                                               AR918987
     C                   PARM      *BLANKS       P@RTCD            7                        AR918987
     C                   PARM      '*VERIFY'     P@OPTN            7                        AR918987
     C*****              PARM      'UUC068'      P@SARD            6                 AR918987 CFT162
     C                   PARM      'CFT162'      P@SARD            6                          CFT162
     C     SCSARD        PARM      *BLANKS       DSFDY                                      AR918987
      *                                                                                     AR918987
     C     P@RTCD        IFEQ      *BLANKS                                                  AR918987
     C*****              MOVE      'Y'           UUC068            1                 AR918987 CFT162
     C                   MOVE      'Y'           CFT162            1                        AR918987
     C                   OPEN      MEGNCRX0                                                 AR918987
     C                   ELSE                                                               AR918987
     C*****              MOVE      'N'           UUC068                              AR918987 CFT162
     C                   MOVE      'N'           CFT162                                     AR918987
     C                   END                                                                AR918987
      *
      *  Indicate that set up is complete
      *
     C                   SETON                                        50
      *
      *  Unwind subroutine stack name
      *
     C     #HXINI        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      /EJECT
     C*COPY*ZSRSRC,ZACCH                                                                    MD056560
     C/COPY ZSRSRC,ZACCHLE                                                                  MD056560
      /EJECT
     C*COPY*ZSRSRC,ZCHKH                                                                    MD056560
     C/COPY ZSRSRC,ZCHKHLE                                                                  MD056560
      /EJECT
     C*COPY*ZSRSRC,ZDATE1Z2                                                                 MD056560
     C/COPY ZSRSRC,ZDATE1Z2LE                                                               MD056560
      /EJECT
     C*COPY*MECPYSRC,SRERRC                                                                 MD056560
     C/COPY MECPYSRC,SRERRCLE                                                               MD056560
      /EJECT
     C*COPY*MECPYSRC,SMESNMSC                                                               MD056560
     C/COPY MECPYSRC,SMESNMSCLE                                                             MD056560
      /EJECT
**  CPY@ table
(c) Finastra International Limited 2001
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
