     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Customer loans display 3')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LECLIP3DP  - LE Customer Loans Display                       *
      *                                                               *
      *  Function:  This module displays the third details screen     *
      *             of the Customer Loans screen input function.      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      *  Prev Amend No. CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 246178             Date 05Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG10391R          Date 17Feb06               *
      *                 BUG3721 (CLE028)   Date 09Aug04               *
      *                 225959             Date 23Mar04               *
      *                 CGL029             Date 01Sep03               *
      *                 224261             Date 09Jan04               *
      *                 CAP074  *CREATE    Date 29Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  246178 - Could not display message other than GBLERMSGF      *
      *  BUG10391R - Funding Rate and Funding Spread Rate fields      *
      *              should be shown separately when CLE036 is *ON    *
      *              (Recompile)                                      *
      *  BUG3721 - Flat Rate Personal Loans (Rule of 78s) (CLE028).   *
      *  225959 - Missing CAS00x changes                              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  224261 - Funding spread/rate still being shown in certain    *
      *           conditions                                          *
      *  CAP074 - Lending API enhancements - Loans input.             *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      **   F-specs                               
      **   =======                               
      ** +--------------------------------------+
     FLECLIP3DDFCF   E             WORKSTN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      **   Automatically included D-specs        
      **   ==============================        
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
      *
      ** +--------------------------------------+
      **   End of automatically included D-specs 
      **   ===================================== 
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      **   Manually included D-specs             
      **   =========================             
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      **   Named constants                       
      **   ===============                       
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      **   Arrays and Data Structures            
      **   ==========================            
      ** +--------------------------------------+
      *
      * This array has been reduced as error indicators do not go up to 70 to free additional inds
      * NOTE: Array at bottom of code has been reduced but cannot be commented
     D @Z0             S              1    DIM(50) CTDATA PERRCD(50)
     D @NAR            S             40    DIM(2) CTDATA PERRCD(1)
      *
     D @EI             S              1    DIM(60)
      *
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ***  External DS for general ledger details
      *
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ***  External DS for midas modules details
      *
     D SDCLND        E DS                  EXTNAME(SDCLNDPD)
      ***  External DS for Lending ICD
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ***  External DS for bank details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  First DS for access programs, SHORT data structure
      *
     D Clip03        E DS                  EXTNAME(LECLI3PD)
     D OKClip03      E DS                  EXTNAME(LEECLI3PD)
      *
     D                 DS
     D  DDFOTX                 1     40
     D  DDSIDN                10     15
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
      *
      ** +--------------------------------------+
      **   Declared variables                    
      **   ==================                    
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      **   End of D-specs                        
      **   ==============                        
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      **                                                                   
      **   Initial processing is performed automatically: the *INZSR is    
      **   executed at program activation.                                 
      **                                                                   
      ** +----------------------------------------------------------------+
      *
      **   Initial processing
      *
     C                   EXSR      INIT
      *
      ***  Main processing
      *
     C                   EXSR      MAIN
      *
      ***  Return
      *
     C     @INKC         IFEQ      '1'
     C                   SETON                                        LR
     C                   END
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT  - Initial processing                                    *
      *****************************************************************
     C     INIT          BEGSR
      *
      ***  Check type of processing
      *
     C                   MOVE      '0'           *IN82
     C                   MOVE      '0'           *IN83
     C                   SELECT
     C     LoanType      WHENEQ    'PTPU'
     C                   MOVE      '1'           *IN82
     C     LoanType      WHENEQ    'PTSO'
     C                   MOVE      '1'           *IN83
     C                   END
      *
     C                   MOVE      '0'           *IN89
     C     *IN82         IFEQ      '1'
     C     *IN83         OREQ      '1'
     C                   MOVE      '1'           *IN89
     C                   END
      *
      ***  Funding details for analytical accounting will be
      ***  made available when the following are satisfied:
      ***  for loans, when processing type is 61 or 62
      ***  for parts purchased, when processing type is 64
      ***  for parts sold, when processing type is 66
      ***  Funding details for Revenue Analysis will be available for
      ***  all funding type loans i.e. processing types 61 to 69.
      ***  It should never be available for risk loans, types 70, 71
      ***  or 72 whether CDE002 is on or off.
      ***  (*IN64 is set on to enable funding details input)
      *
     C     BGN0ST        IFEQ      'Y'
     C     CDE002        OREQ      'Y'
     C                   MOVE      *ON           *IN64
      *
     C                   SELECT
     C     *IN82         WHENEQ    *ON
     C     LoanPtyp      IFNE      64
     C     LoanPtyp      ANDNE     68
     C     CDE002        ANDEQ     'N'
      *
     C     LoanPtyp      ORNE      64
     C     LoanPtyp      ANDNE     65
     C     LoanPtyp      ANDNE     68
     C     CDE002        ANDEQ     'Y'
     C     LoanPtyp      OREQ      68
     C     CLE005        ANDEQ     'N'
     C                   MOVE      *OFF          *IN64
     C                   ENDIF
      *
     C     *IN83         WHENEQ    *ON
     C     LoanPtyp      IFNE      66
     C     LoanPtyp      ANDNE     69
     C     CDE002        ANDEQ     'N'
      *
     C     LoanPtyp      ORNE      66
     C     LoanPtyp      ANDNE     67
     C     LoanPtyp      ANDNE     69
     C     CDE002        ANDEQ     'Y'
      *
     C     LoanPtyp      OREQ      69
     C     CLE005        ANDEQ     'N'
     C                   MOVE      *OFF          *IN64
     C                   ENDIF
      *
     C                   OTHER
     C     LoanPtyp      IFNE      61
     C     LoanPtyp      ANDNE     62
     C     CDE002        ANDEQ     'N'
      *
     C     LoanPtyp      ORNE      61
     C     LoanPtyp      ANDNE     62
     C     LoanPtyp      ANDNE     63
     C     CDE002        ANDEQ     'Y'
                                                                                             BUG3721
     C     CLE028        IFEQ      'Y'                                                       BUG3721
     C     LoanPtyp      ANDNE     80                                                        BUG3721
     C                   MOVE      *OFF          *IN64
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C                   ENDIF
     C                   ENDSL
     C                   ENDIF
      *
      ***  Protect profit centre
      *
     C     DDACT3        IFEQ      'R'
     C                   MOVE      *ON           *IN63
     C                   ENDIF
      *
      ***  When CAS001 enhancement is installed
      *
     C     CAS001        IFEQ      'Y'
      *
      ***  Display Yield Curve and Forward Yield Curve if
      ***  loan processing subtype is not defined as
      ***  Guarantess Issued. Also do not display fields if
      ***  loan is not linked to a base rate.
      *
     C                   MOVE      *OFF          *IN93
     C                   MOVE      *OFF          *IN94
      *
     C     LoanPtyp      IFEQ      70
     C     LoanPtyp      OREQ      71
     C     LoanPtyp      OREQ      72
     C                   MOVE      *ON           *IN93
     C                   MOVE      *ON           *IN94
     C*******************ELSE                                                   225959
     C*****PBRTT         IFEQ      '00'                                         225959
     C*****PBRTT         OREQ      *BLANKS                                      225959
     C*****              MOVE      *ON           *IN94                          225959
     C*****              ENDIF                                                  225959
     C                   ENDIF
      *
     C                   ELSE
     C                   MOVE      *ON           *IN93
     C                   MOVE      *ON           *IN94
      *
     C                   ENDIF
 
     C                   IF        PActionCode = 'I'  OR PActionCode = 'A'      224261
     C                   EVAL      *IN91 = *OFF                                 224261
     C                   ELSE                                                   224261
     C                   EVAL      *IN91 = *ON                                  224261
     C                   ENDIF                                                  224261
                                                                                224261
     C                   MOVE      *OFF          *IN71                          224261
     C                   IF        PActionCode <> 'I'                           224261
     C     BGN0ST        IFEQ      'Y'                                          224261
     C     CDE002        OREQ      'Y'                                          224261
     C     LOANPTYP      ANDLT     70                                           224261
     C     LOANPTYP      IFEQ      61                                           224261
     C     LOANPTYP      OREQ      62                                           224261
     C     LOANPTYP      OREQ      64                                           224261
     C     LOANPTYP      OREQ      66                                           224261
     C     LOANPTYP      OREQ      68                                           224261
     C     CLE005        ANDEQ     'Y'                                          224261
     C     LOANPTYP      OREQ      69                                           224261
     C     CLE005        ANDEQ     'Y'                                          224261
     C     LOANPTYP      OREQ      63                                           224261
     C     CDE002        ANDEQ     'Y'                                          224261
     C     LOANPTYP      OREQ      65                                           224261
     C     CDE002        ANDEQ     'Y'                                          224261
     C     LOANPTYP      OREQ      67                                           224261
     C     CDE002        ANDEQ     'Y'                                          224261
                                                                                224261
     C     CLORED        IFNE      BJRDNB                                       224261
     C                   MOVE      *ON           *IN71                          224261
     C                   ENDIF                                                  224261
                                                                                224261
     C                   ENDIF                                                  224261
     C                   ENDIF                                                  224261
     C                   ENDIF                                                  224261
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN - MAIN processing                                        *
      *****************************************************************
     C     MAIN          BEGSR
      *
      ***  Move 'OK' flags into array (for checking)
      *
     C                   MOVEA     OKClip03      @EI
      *
      ***  Initialize action code
      ***  Set the action code to 'E' in case of action code '3'
      *
     C     PActionCode   IFEQ      '3'
     C                   MOVEL     'E'           DDACT3
     C                   ELSE
     C                   MOVEL     PActionCode   DDACT3
     C                   END
      *
      ***  Set screen error indicators according to status of 'OK' flags
      *
     C                   Z-ADD     1             C                 2 0
     C                   Z-ADD     10            E                 2 0
      *
     C     C             DOUGT     60
     C     @EI(C)        IFEQ      'N'
     C     @EI(C)        OREQ      'W'
     C                   MOVEL     '1'           *IN(E)
     C                   END
     C                   ADD       1             C
     C                   ADD       1             E
     C                   END
      *
      ***  Do while error messages found
      ***  write error messages (with or without data) to sub-file
      *
     C                   Z-ADD     1             C
     C     C             DOWLE     ArrayMax
     C     FldNameArr(C) ANDNE     *BLANKS
     C                   MOVEL     MsgIdArr(C)   ZMSID
     C                   MOVEL     MsgDtaArr(C)  ZMSDA
     C                   EXSR      ERRMSG
     C                   ADD       1             C
     C                   END
      *
      ***  Do while warning messages found
      ***  Write warning messages (with or without data) to sub-file
      *
     C                   Z-ADD     1             C
     C     C             DOWLE     ArrayMax
     C     WFldNamArr(C) ANDNE     *BLANKS
     C                   MOVEL     WMsgIdArr(C)  ZMSID
     C                   MOVEL     WMsgDtaArr(C) ZMSDA
     C                   EXSR      ERRMSG
     C                   ADD       1             C
     C                   END
      *
      ***  Enable detail fields (all fields except action code & loan number)
      *
     C     @EDTFD        COMP      'Y'                                7070
      *
      ***  Enable function keys
      *
     C     @EINKI        COMP      'Y'                                    75    F09
     C     @EINKJ        COMP      'Y'                                    76    F10
     C     @EINKN        COMP      'Y'                                    72    F14
      *
      ***  Text = CONFIRM DELETE
      *
     C     @EINKJ        IFEQ      'Y'
     C                   MOVEL     @NAR(2)       DDFOTX
     C                   ELSE
     C                   MOVEL     *BLANKS       DDFOTX
     C                   END
      *
      ***  Write message sub-file, details and footer screen
      *
     C                   WRITE     LECLIPC3
     C                   WRITE     LECLIPD3
     C                   WRITE     LECLIPF3
      *
      ***  Read details screen,
      *
      ***  If not write only
      *
     C     WriteOnly     IFNE      'Y'
     C                   READ      LECLIPD3                               99    *
     C                   ENDIF
      *
      ***  If rolldown set F12 to on
      *
     C     *IN78         IFEQ      '1'
     C                   MOVE      '1'           *INKL
     C                   MOVE      '1'           @PGUP
     C                   ENDIF
      *
      ***  Clear message subfile
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      DDPGMQ        ZAPGMQ
     C                   PARM      '*SAME'       ZAPGRL
      *
      ***  Set screen error indicators OFF
      *
     C                   MOVEA     @Z0           *IN(10)
      *
      ***  Set return keys
      *
     C                   MOVE      *INKC         @INKC
     C                   MOVE      *INKL         @INKL
     C                   MOVE      *INKN         @INKN
     C                   MOVE      *INKI         @INKI
     C                   MOVE      *INKJ         @INKJ
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ERRMSG  - Output error messages                               *
      *****************************************************************
     C     ERRMSG        BEGSR
      *
      ***  Display error message
      *** 246178 - in Input message could be LERMSGF, Y2USRMSG or DRSMM and XXUSRMSG          246178
      *                                                                                       246178
     C                   Z-ADD     1             Index             1 0                        246178
     C                   DoW       Index < 5                                                  246178
     C                   SELECT                                                               246178
     C     Index         WhenEq    1                                                          246178
     C                   Movel(p)  'GBLERMSGF'   ZMSGF                                        246178
     C     Index         WhenEq    2                                                          246178
     C                   Movel(p)  'GBDRSMM'     ZMSGF                                        246178
     C     Index         WhenEq    3                                                          246178
     C                   Movel(p)  'GBY2USRMSG'  ZMSGF                                        246178
     C     Index         WhenEq    4                                                          246178
     C                   Movel(p)  'GBXXUSRMSG'  ZMSGF                                        246178
     C                   ENDSL                                                                246178
      *                                                                                       246178
     C                   CALL      'SDRTVTXT'                                                 246178
     C                   PARM                    ZMSID                                        246178
     C                   PARM                    ZMSGF                                        246178
     C                   PARM      *blanks       MSGTXT           80                          246178
     C                   if        %subst(MSGTXT:1:18) <>                                     246178
     C                             'Text not available'                                       246178
     C                             and MSGTXT <> *BLANKS                                      246178
     C                   Z-ADD     9             index                                        246178
     C                   Else                                                                 246178
     C                   Eval      Index = Index +1                                           246178
     C                   Endif                                                                246178
     C                   EndDo                                                                246178
      *
     C                   CALL      'Y2SNMGC'
     C                   PARM      'LECLIP3DP'   ZAPGMQ           10            Program queue
     C                   PARM                    ZAPGRL                         Rel queue
     C                   PARM                    ZMSID             7            Message Id.
     C                   PARM                    ZMSGF                          Message file.
     C                   PARM                    ZMSDA           132            Message data.
     C                   PARM                    ZMSTP             7            Message type.
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial processing.                                  *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ***  Parameters
      *
     C     *ENTRY        PLIST
      *
      ***  INPUT PARAMETERS
      *
      ***  Return code
     C                   PARM                    RetCodeIn
      *
      ***  Loan (in screen format)
     C                   PARM                    Clip03
      *
      ***  Fields in error
     C                   PARM                    OKClip03
      *
      ***  Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ***  Warnings
      *
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ***  Enabled key & detail fields
      *
     C                   PARM                    @EKYFD            1
     C                   PARM                    @EDTFD            1
      *
      ***  Enabled function keys
      *
     C                   PARM                    @EINKI            1
     C                   PARM                    @EINKJ            1
     C                   PARM                    @EINKN            1
      *
      * Loan Processing Type
     C                   PARM                    LoanPtyp          2 0
      *
      * Loan Type
     C                   PARM                    LoanType          4
      *
      ***  Action code
      *
     C                   PARM                    PActionCode       1
      *
      ***  Base rate code
      *
     C                   PARM                    PBRTT             2
      *
      ***  OUTPUT PARAMETERS
      *
      ***  Function keys
      *
     C                   PARM                    @INKC             1
     C                   PARM                    @INKI             1
     C                   PARM                    @INKJ             1
     C                   PARM                    @INKL             1
     C                   PARM                    @INKN             1
     C                   PARM                    @PGUP             1
      *
      ***  Write screen with no read indicator
      *
     C                   PARM                    WriteOnly         1
     C                   PARM                    CLORED            5 0          224261
      *
      ***  Initialize program name
      *
     C                   MOVEL     'LECLIP3DP'   DBPGM
      *
      ***  Move user and workstation ID to screen fields.
      *
     C                   MOVEL     PsUser        DDUSER
     C                   MOVEL     PsJobName     DDWID
      *
      ***  Access bank details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ***  Database error
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   MOVEL     '001'         DBASE                          * DBERR 001 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
      *
      ***  Access midas module details
      *
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDMMODPD'    DBFILE                         *************
     C                   MOVEL     '002'         DBASE                          * DBERR 002 *
     C                   EXSR      *PSSR                                        *************
     C                   END
      *
      ***  Retrieve general ledger details
      *
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDGELRPD'    DBFILE                         *************
     C                   MOVEL     '003'         DBASE                          * DBERR 003 *
     C                   EXSR      *PSSR                                        *************
     C                   END
      *
      ***  Retrieve lending ICD
      *
     C                   CALL      'AOCLNDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDCLND        PARM      SDCLND        DSFDY                                        CLE134
     C     SDCLND        PARM      SDCLND        DSSDY                                        CLE134
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDCLNDPD'    DBFILE                         *************
     C                   MOVEL     '004'         DBASE                          * DBERR 004 *
     C                   EXSR      *PSSR                                        *************
     C                   END
      *
      ***  Determine if BLI Lending Enhancements feature is installed
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01465'      @SARD             6
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      *ON           *IN80
     C                   ELSE
     C     @RTCD         IFNE      '*NRF    '
     C     *LOCK         IN        LDA
     C                   MOVEL     'S01465'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE                         *************
     C                   MOVEL     '005'         DBASE                          * DBERR 005 *
     C                   EXSR      *PSSR                                        *************
     C                   END
     C                   END
      *
      ***  Access SAR details file to determine if CDE002 is switched on
      *
     C                   MOVEL     'N'           CDE002            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CDE002'      @SARD
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CDE002
     C                   END
      *
      ***  Access SAR details file to determine if CLE005 is switched on
      *
     C                   MOVEL     'N'           CLE005            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE005'      @SARD
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CLE005
     C                   END
                                                                                             BUG3721
      ** Access SAR details file to determine if CLE028 is switched on                       BUG3721
                                                                                             BUG3721
     C                   MOVEL     'N'           CLE028            1                         BUG3721
     C                   CALLB     'AOSARDR0'                                                BUG3721
     C                   PARM      *BLANKS       @RTCD                                       BUG3721
     C                   PARM      '*VERIFY'     @OPTN                                       BUG3721
     C                   PARM      'CLE028'      @SARD                                       BUG3721
                                                                                             BUG3721
     C     @RTCD         IFEQ      *BLANKS                                                   BUG3721
     C                   MOVEL     'Y'           CLE028                                      BUG3721
     C                   END                                                                 BUG3721
      *
      ***  Determine if CAS001 is installed
      *
     C                   MOVEL     'N'           CAS001            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CAS001'      @SARD
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CAS001
     C                   END
      *
      ***  Enable branch
      *
     C     BGMBIN        IFEQ      'Y'
     C                   MOVE      *ON           *IN81
     C                   ENDIF
      *
      ***  Enable portfolio reference
      *
     C     BGN4ST        IFEQ      'Y'
     C     BGPFMG        OREQ      'Y'
     C                   MOVE      *ON           *IN87
     C                   ENDIF
      *
      ***  Enable originating branch
      *
     C     BKOBRU        IFEQ      'Y'
     C                   MOVE      *ON           *IN62
     C                   ENDIF
      *
      ***  Enable profit centre
      *
     C     BKPRCU        IFEQ      'N'
     C     BKPRCA        OREQ      'N'
     C                   MOVE      *ON           *IN86
     C                   ENDIF
      *
      ***  Enable guarantee receiver
      *
     C     BPGIAV        IFEQ      'Y'
     C                   MOVE      *ON           *IN90
     C                   ENDIF
      *
      ***  Message subfile control
      *
     C                   MOVE      '1'           *IN97
     C                   MOVEL     '*'           DDPGMQ
     C                   MOVEL     '*SAME'       ZAPGRL            5
     C                   MOVEL     'GBLERMSGF'   ZMSGF            10
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2002
** @Z0
00000000000000000000000000000000000000000000000000
** @NAR
Loan No. 999999 successfully inserted.
F10=CONFIRM DELETE
