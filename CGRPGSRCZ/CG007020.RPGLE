     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas CG Int Scale Enqry & Reprint - Selection')       *
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG007020 - Midas CG Int Scale Enqry & Reprint - Selection    *
      *                                                               *
      *  Function:  This program displays all Interest Scale records  *
      *             which has a function to display both header and   *
      *             detail information.  It also has a functionality  *
      *             to reprint selected item id                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. CLE148             Date 23Jul12               *
      *  Prev Amend No. AR797795 *CREATE   Date 19Jul11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE148 - Alpha Loan Reference                                *
      *  AR797795 - Interest Scale Report Enquiry is missing in       *
      *             BFMidas                                           *
      *                                                               *
      *****************************************************************
     FCG007020DFCF   E             WORKSTN USROPN
     F                                     SFILE(CG007020S0:#0RLRN)
     F                                     INFDS(INFDS1)
     F                                     INFSR(*PSSR)
     FCGISHXL0  IF   E           K DISK    INFSR(*PSSR)
      ** CG Interest Scale Enquiry and Reprint - header extract
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
     D PGMDS         E DS                  EXTNAME(Y2PGDSP)
 
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      ** File information data structure
     D LDA           E DS           256    EXTNAME(LDA)
 
     D                 DS
      ** Message Data
     D  ZAMSDA                 1    132
     D  ZA0001                 1      1
     D  ZA0002                 1      1
     D  ZA0003                 1      1
     D  ZA0004                 1      1
     D  ZA0005                 1      1
     D  ZA0006                 1      1
 
     D CharLO          C                   'abcdefghijklmnopqrstuvwxyz'
     D CharUP          C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
     D KIBANX          S                   LIKE(T9IBAN)
     D IBANX           S                   LIKE(HXIBAN)
     D WPOS            S              3S 0
     D WSFPG           S              3S 0
     D W0RSF           S              1A
     D WCnt            S              3S 0
     D WLRCD           S              4S 0
     D WNODAT          S              1A
     D WHXPDAT         S              7A
     D WRCTR           S              5S 0
     D WRFlag          S              1A
     D W9PDAT          S              7A
     D POptn           S              7A
     D PSard           S              6A
     D PParm           S             15A
     D PRtcd           S              7A
     D PACTN           S              1A
     D PItem           S              8  0
     D PNSTS           S              4A
     D CFT004          S              1A
 
     D ZAPGMQ          S             10A
     D ZAPGRL          S              5A
     D ZAMSID          S              7A
     D ZAMSGF          S             10A
     D ZAMSTP          S              7A
 
     D KBRCA           S                   LIKE(HXBRCA)
     D KCNUM           S                   LIKE(HXCNUM)
     D KACOD           S                   LIKE(HXACOD)
     D KDLTP           S                   LIKE(HXDLTP)
     D KDLST           S                   LIKE(HXDLST)
     D KDLNO           S                   LIKE(HXDLNO)
     D KITEM           S                   LIKE(HXITEM)
     D KIBAN           S                   LIKE(HXIBAN)
     D KPDAT           S                   LIKE(HXPDAT)
 
     D Prev_BRCA       S                   LIKE(T9BRCA)
     D Prev_CNUM       S                   LIKE(T9CNUM)
     D Prev_ACOD       S                   LIKE(T9ACOD)
     D Prev_DLTP       S                   LIKE(T9DLTP)
     D Prev_DLST       S                   LIKE(T9DLST)
     D Prev_DLNO       S                   LIKE(T9DLNO)
     D Prev_ITEM       S                   LIKE(T9ITEM)
     D Prev_IBAN       S                   LIKE(T9IBAN)
     D Prev_PDAT       S                   LIKE(T9PDAT)
      ** Parameters for ZALIGN
     D ZRTN            S              7A
     D ZFIELD          S             16A
     D ZADEC           S              1S 0
     D ZADIG           S              2S 0
     D ZAFLD           S             16A
 
      ** Parameters for FC0040X
     D O#RTN           S              7A
     D O#PRG           S             10A
     D O#CPRG          S             10A
     D O#CSEQ          S              5A
     D O#PARM          S            100A
     D O#MBIN          S              1A
     D O#LVL           S              1A
     D O#ENTY          S              3A
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Long data structure for access objects
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External data structures for Bank Details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** External DS for Access Programs
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External data structures for Currency Details
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** External data structures for Switchable Features Details
     D RUNDAT        E DS
      ** Rundate
 
     D #WPARM          DS           100
     D  #WITEM                 1      8  0
     D  #WDCOR                 9     18
     D  #WGPTR                64     71
     D  #WFINL                93     93
     D  #WARCH                94     94
 
     D PKEYI           DS           100
     D  PArch                  1     10
     D  PPgm                  11     20
 
     D #LParm          DS            15
     D  LItem                  1      5P 0
     D  LDCor                  6     15
 
      ** Perform Initialisation
     C                   EXSR      SRINIT
 
     C                   DO        *HIVAL
 
      ** Initialise and load subfile page
     C                   EXSR      SRIZSF
 
      ** Initialise reset field
     C                   MOVEL     'N'           W0RSF
     C                   MOVE      'N'           WRFlag
     C                   Z-ADD     *ZEROS        WCnt
 
      ** Display screen
     C     W0RSF         DOWEQ     'N'
 
      ** Screen Display routine
     C                   EXSR      SRDSPS
 
      ** Process response
     C                   SELECT
 
      ** F3 is pressed
     C                   WHEN      *IN03 = *ON
     C                   EXSR      SREXIT
 
      ** F5 is pressed
     C                   WHEN      *IN05 = *ON
     C                   EXSR      SRCMF5
     C                   EVAL      T9BRCA = *BLANKS
     C                   EVAL      T9CNUM = *BLANKS
     C                   EVAL      T9ACOD = *BLANKS
     C                   EVAL      T9DLTP = *BLANKS
     C                   EVAL      T9DLST = *BLANKS
     C                   EVAL      T9DLNO = *BLANKS
     C                   EVAL      T9ITEM = *BLANKS
     C                   EVAL      T9IBAN = *BLANKS
     C                   EVAL      T9PDAT = *BLANKS
     C                   EXSR      SRIZSF
 
      ** F12 is pressed
     C                   WHEN      *IN12 = *ON
     C                   EXSR      SRPREV
 
      ** Roll up is pressed
     C                   WHEN      *IN22 = *ON
     C                   EXSR      SRLOAD
 
      ** ENTER key is pressed
     C                   OTHER
     C                   EXSR      SRPROC
      * Process if no error is found during validation
     C                   IF        WRFlag <> 'Y'
     C                   IF        *IN34 <> *ON Or *IN35 <> *ON
     C                   IF        T9BRCA <> *BLANKS
     C                             OR T9CNUM <> *BLANKS
     C                             OR T9ACOD <> *BLANKS
     C                             OR T9DLTP <> *BLANKS
     C                             OR T9DLST <> *BLANKS
     C                             OR T9DLNO <> *BLANKS
     C                             OR T9ITEM <> *BLANKS
     C                             OR T9PDAT <> *BLANKS
     C                             OR T9IBAN <> *BLANKS
     C                   EXSR      SRIZSF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDDO
 
     C                   ENDDO
 
      *****************************************************************
      *                                                               *
      *  SRINIT - Subroutine to do Program Initialisation.            *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls:                                                       *
      *  AOBANKR0   Access Object for Bank Details                    *
      *  AOSARDR0   Access Object for Switchable Feature              *
      *  SRCLR    - Use to clear messages in program queue            *
      *                                                               *
      *****************************************************************
 
     C     SRINIT        BEGSR
 
      ** Obtain default message file
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
 
      ** Initialize LDA
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVE      *BLANKS       DBFILE
     C                   MOVE      *BLANKS       DBKEY
     C                   MOVE      *BLANKS       DBPGM
     C                   MOVE      'CG007020'    DBPGM
     C                   OUT       LDA
 
      ** Call Access Program for Bank Details
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSSDY
      ** Handle Database Error
     C     PRtcd         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      'SDBANKPD'    DBFILE
     C                   MOVEL     POptn         DBKEY
     C                   Z-ADD     001           DBASE
     C                   MOVEL     'CG007020'    DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access SAR details file to determine if CFT004 switchable feature
      ** is switched on
     C                   MOVE      'N'           CFT004
     C                   EVAL      *IN36 = *OFF
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CFT004'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
     C     PRtcd         IFEQ      *BLANKS
     C                   MOVE      'Y'           CFT004
     C                   EVAL      *IN36 = *ON
     C                   ENDIF
      ** Non-Display Stat (Archive or Current)
     C                   EVAL      *IN37 = *ON
 
      ** Initialise Header Screen
     C                   OPEN      CG007020DF
     C                   Z-ADD     6             WSFPG
     C                   MOVEL     PSJobName     #0WSID
     C                   MOVEL     PSUser        #0USER
     C                   MOVEL     BJMRDT        #0RUNA
     C                   MOVEL     'CG007020'    #0PGMN
     C                   MOVEL     'CG007020'    PPgm
     C                   TIME                    #0TIME
 
     C                   MOVEL     *BLANKS       ZAMSDA
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  SRIZSF - Subfile Initialisation and Load routine.            *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls:                                                       *
      *  SRLOAD   - Load one page of subfile                          *
      *  ZALIGN   - Align screen fields                               *
      *  SRCLR    - Clear messages in program queue                   *
      *                                                               *
      *****************************************************************
     C     SRIZSF        BEGSR
 
      ** Clear subfile
     C                   MOVE      *ON           *IN50
     C                   WRITE     CG007020C0
     C                   MOVE      *OFF          *IN50
 
      ** Reset no of records in subfile
     C                   Z-ADD     0             WLRCD
      ** Enable F5 key
     C                   MOVE      *ON           *IN25
 
      ** Clear selection fields and setup command text line
     C                   MOVE      *BLANK        T7ACT
 
      ** Initialise No data work field
     C                   MOVE      'N'           WNODAT
      ** Enquiry mode
     C                   MOVE      *OFF          *IN30
     C                   MOVE      *OFF          *IN31
     C                   MOVE      *OFF          *IN32
     C                   MOVE      *OFF          *IN71
 
      ** Selection Mode
     C     *LOVAL        SETLL     CGISHXL0
     C     *IN34         IFEQ      *ON
     C                   EXSR      SRCLR
     C                   ENDIF
 
      ** If Selection criteria is used
     C                   EVAL      KBRCA = T9BRCA
     C                   EVAL      KCNUM = T9CNUM
 
     C                   IF        T9ACOD <> *BLANKS
     C                   EVAL      ZFIELD = %TRIM(T9ACOD)
     C                   CALL      'ZALIGN'
     C                   PARM      *BLANKS       ZRTN
     C                   PARM                    ZFIELD
     C                   PARM      0             ZADEC
     C                   PARM      10            ZADIG
     C                   PARM                    ZAFLD
 
     C                   IF        ZRTN = *BLANKS
     C                   MOVE      ZAFLD         KACOD
     C                   MOVE      ZAFLD         T9ACOD
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      KACOD = 0
     C                   ENDIF
 
     C                   EVAL      KDLTP = T9DLTP
     C                   EVAL      KDLST = T9DLST
     C                   IF        T9DLNO <> *BLANKS
     C                   EVAL      ZFIELD = %TRIM(T9DLNO)
     C                   CALL      'ZALIGN'
     C                   PARM      *BLANKS       ZRTN
     C                   PARM                    ZFIELD
     C                   PARM      0             ZADEC
     C                   PARM      6             ZADIG
     C                   PARM                    ZAFLD
     C                   IF        ZRTN = *BLANKS
     C                   MOVE      ZAFLD         KDLNO
     C                   MOVE      ZAFLD         T9DLNO
     C                   ENDIF
     C                   ELSE
     C**********         EVAL      KDLNO = 0                                                  CLE148
     C                   EVAL      KDLNO = T9DLNO                                             CLE148
     C                   ENDIF
 
     C                   IF        T9ITEM <> *BLANKS
     C                   EVAL      ZFIELD = %TRIM(T9ITEM)
     C                   CALL      'ZALIGN'
     C                   PARM      *BLANKS       ZRTN
     C                   PARM                    ZFIELD
     C                   PARM      0             ZADEC
     C                   PARM      8             ZADIG
     C                   PARM                    ZAFLD
     C                   IF        ZRTN = *BLANKS
     C                   MOVE      ZAFLD         KITEM
     C                   MOVE      ZAFLD         T9ITEM
     C                   ENDIF
     C                   ELSE
     C                   EVAL      KITEM = 0
     C                   ENDIF
     C                   EVAL      KIBAN = T9IBAN
     C                   EVAL      KPDAT = T9PDAT
     C                   IF        T9CNUM <> *BLANKS
     C     KCNUM         SETLL     CGISHXL0
     C                   ENDIF
 
      ** Save previous keys
     C                   MOVEL     T9BRCA        Prev_BRCA
     C                   MOVEL     T9CNUM        Prev_CNUM
     C                   MOVEL     T9ACOD        Prev_ACOD
     C                   MOVEL     T9DLTP        Prev_DLTP
     C                   MOVEL     T9DLST        Prev_DLST
     C                   MOVEL     T9DLNO        Prev_DLNO
     C                   MOVE      T9ITEM        Prev_ITEM
     C                   MOVEL     T9IBAN        Prev_IBAN
     C                   MOVE      T9PDAT        Prev_PDAT
 
      ** Load subfile page
     C                   EXSR      SRLOAD
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRLOAD - Load one page of subfile.                           *
      *                                                               *
      *  Called By: SRIZSF and main processing                        *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRLOAD        BEGSR
 
      ** Reset SFLEND indicator and record counter
     C                   MOVE      *BLANK        T7ACT
     C                   MOVE      *OFF          *IN51
     C                   Z-ADD     1             WRCTR
     C                   Z-ADD     WLRCD         #0RLRN
 
     C                   READ      CGISHXL0
     C                   EXSR      SRCLR
 
      *  CGISHXLO
      ** Load records until EOF
     C                   DOW       NOT %EOF(CGISHXL0) and WRCTR <= WSFPG
 
      ** If filter fields are filled, use it
     C                   IF        T9BRCA <> *BLANKS AND HXBRCA <> *BLANKS
     C     HXBRCA        CABNE     KBRCA         SKIP
     C                   ENDIF
 
     C                   IF        T9CNUM <> *BLANKS AND HXCNUM <> *BLANKS
     C     HXCNUM        CABNE     KCNUM         SKIP
     C                   ENDIF
 
     C                   IF        T9ACOD <> *BLANKS
     C     HXACOD        CABNE     KACOD         SKIP
     C                   ENDIF
 
     C                   IF        T9DLTP <> *BLANKS
     C     HXDLTP        CABNE     KDLTP         SKIP
     C                   ENDIF
 
     C                   IF        T9DLST <> *BLANKS
     C     HXDLST        CABNE     KDLST         SKIP
     C                   ENDIF
 
     C                   IF        T9DLNO <> *BLANKS
     C     HXDLNO        CABNE     KDLNO         SKIP
     C                   ENDIF
 
     C                   IF        T9ITEM <> *BLANKS AND HXITEM <> 0
     C     HXITEM        CABNE     KITEM         SKIP
     C                   ENDIF
 
     C                   IF        T9PDAT <> *BLANKS
     C                   EVAL      W9PDAT = %TRIM(T9PDAT)
     C                   EVAL      WHXPDAT = %TRIM(HXPDAT)
     C     WHXPDAT       CABNE     W9PDAT        SKIP
     C                   ENDIF
 
     C                   IF        T9IBAN <> *BLANKS
     C                   EVAL      KIBANX = %XLATE(CharLO:CharUP:KIBAN)
     C                   EVAL      IBANX = %XLATE(CharLO:CharUP:HXIBAN)
     C                   EVAL      WPOS = %SCAN(%TRIM(KIBANX):IBANX)
     C     WPOS          CABEQ     0             SKIP
     C                   ENDIF
 
      ** Update the screen fields with CGISHXL0 field values
     C                   MOVEL     HXBRCA        T7BRCH
     C                   MOVEL     HXCNUM        T7CNUM
     C                   MOVE      HXACOD        T7ACOD
     C                   MOVEL     HXDLTP        T7DLTP
     C                   MOVEL     HXDLST        T7DLST
     C                   MOVE      HXDLNO        T7DLNO
     C                   IF        HXACOD = 0
     C                   MOVE      *BLANKS       T7ACOD
     C                   ENDIF
     C**********         IF        HXDLNO = 0                                                 CLE148
     C**********         MOVE      *BLANKS       T7DLNO                                       CLE148
     C**********         ENDIF                                                                CLE148
 
     C                   MOVE      HXITEM        T7ITEM
     C                   MOVEL     HXIBAN        T7IBAN
     C                   MOVE      HXPDAT        T7PDAT
     C                   MOVE      HXSTAT        T7STAT
 
      ** Write records to SFL
     C                   ADD       1             #0RLRN
     C                   ADD       1             WRCTR
     C                   WRITE     CG007020S0
     C     SKIP          TAG
 
      ** Read next record
     C                   READ      CGISHXL0
     C                   ENDDO
 
     C                   IF        #0RLRN = *ZEROS
     C                   MOVE      *ON           *IN34
     C                   MOVE      *OFF          *IN53
     C                   MOVEL     'USR7620'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN50
     C                   ELSE
 
      ** Seton SFLDSP
     C                   MOVE      *ON           *IN53
     C                   ENDIF
 
      ** Seton SFLEND indicator if EOF
     C                   IF        %EOF(CGISHXL0)
     C                   MOVE      *ON           *IN51
     C                   ELSE
     C                   READP     CGISHXL0
     C                   ENDIF
 
      ** No records on subfile
     C     #0RLRN        IFEQ      0
     C                   MOVE      'Y'           WNODAT
     C                   ELSE
     C                   MOVE      'N'           WNODAT
     C                   ENDIF
 
      ** Save last relative record number to workfield
     C                   Z-ADD     #0RLRN        WLRCD
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  SRDSPS - Display of initial screen                           *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *****************************************************************
     C     SRDSPS        BEGSR
 
      ** Only to initialize when Refresh (F5) pressed
     C                   IF        *IN05 = *ON
     C                   EVAL      T9BRCA = *BLANKS
     C                   EVAL      T9CNUM = *BLANKS
     C                   EVAL      T9ACOD = *BLANKS
     C                   EVAL      T9DLTP = *BLANKS
     C                   EVAL      T9DLST = *BLANKS
     C                   EVAL      T9DLNO = *BLANKS
     C                   EVAL      T9ITEM = *BLANKS
     C                   EVAL      T9IBAN = *BLANKS
     C                   EVAL      T9PDAT = *BLANKS
     C                   ENDIF
 
      ** Update screen time
     C                   TIME                    #0TIME
 
      ** Display subfile page
     C                   IF        #0RLRN > 0
     C                   WRITE     CG007020H0
     C                   WRITE     CG007020F0
     C                   WRITE     CG007020C1
     C                   ENDIF
 
     C                   IF        #0RLRN > 0
     C                   EXFMT     CG007020C0
     C                   ELSE
 
      ** Move selection fields (Main screen to No Data screen)
     C                   EVAL      #0POS1 = T9BRCA
     C                   EVAL      #0POS2 = T9CNUM
     C                   EVAL      #0POS3 = T9ACOD
     C                   EVAL      #0POS4 = T9DLTP
     C                   EVAL      #0POS42 = T9DLST
     C                   EVAL      #0POS8 = T9DLNO
     C                   EVAL      #0POS5 = T9ITEM
     C                   EVAL      #0POS6 = T9IBAN
     C                   EVAL      #0POS7 = T9PDAT
     C                   EXFMT     CG007020D1
      ** Move selection fields (No Data screen to Main screen)
     C                   EVAL      T9BRCA = #0POS1
     C                   EVAL      T9CNUM = #0POS2
     C                   EVAL      T9ACOD = #0POS3
     C                   EVAL      T9DLTP = #0POS4
     C                   EVAL      T9DLST = #0POS42
     C                   EVAL      T9DLNO = #0POS8
     C                   EVAL      T9ITEM = #0POS5
     C                   EVAL      T9PDAT = #0POS7
     C                   EVAL      T9IBAN = #0POS6
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  SRPROC - Screen Input Processing                             *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls:                                                       *
      *  SRVALS   - Validate selection field on subfile               *
      *  SRSFPR   - Subfile processing                                *
      *                                                               *
      *****************************************************************
     C     SRPROC        BEGSR
 
      ** Change in selection criteria, exit subroutine
     C                   IF           T9BRCA <> Prev_BRCA AND T9BRCA <> *BLANKS
     C                             OR T9CNUM <> Prev_CNUM AND T9CNUM <> *BLANKS
     C                             OR T9ACOD <> Prev_ACOD AND T9ACOD <> *BLANKS
     C                             OR T9DLTP <> Prev_DLTP AND T9DLTP <> *BLANKS
     C                             OR T9DLST <> Prev_DLST AND T9DLST <> *BLANKS
     C                             OR T9DLNO <> Prev_DLNO AND T9DLNO <> *BLANKS
     C                             OR T9ITEM <> Prev_ITEM AND T9ITEM <> *BLANKS
     C                             OR T9PDAT <> Prev_PDAT AND T9PDAT <> *BLANKS
     C                             OR T9IBAN <> Prev_IBAN AND T9IBAN <> *BLANKS
     C                   MOVE      'Y'           W0RSF
     C                   GOTO      PREXIT
     C                   ENDIF
 
      ** Validate selection fields
     C     WNODAT        IFEQ      'N'
     C                   EXSR      SRVALS
 
      ** Invalid subfile entry
     C     *IN34         IFEQ      *ON
     C                   GOTO      PREXIT
     C                   ENDIF
 
      ** Process subfile records
     C                   EXSR      SRSFPR
 
      ** Error in subfile processing
     C     *IN34         IFEQ      *ON
     C                   GOTO      PREXIT
     C                   ENDIF
     C                   ENDIF
 
     C     PREXIT        ENDSR
      *****************************************************************
      *                                                               *
      *  SRVALS - Validate selection field on subfile                 *
      *                                                               *
      *  Called By: SRPROC subroutine                                 *
      *                                                               *
      *  Calls:                                                       *
      *  ZASNMS   - Sends error message to program queue              *
      *                                                               *
      *****************************************************************
     C     SRVALS        BEGSR
 
     C                   Z-ADD     *ZEROS        WCnt
     C                   MOVE      'N'           WRFlag
 
      ** Clear messages from program message queue
     C     *IN34         IFEQ      *ON
     C                   EXSR      SRCLR
     C                   ENDIF
 
      ** Set subfile record pointer to top of subfile
     C                   Z-ADD     1             #0RLRN
     C                   READC     CG007020S0                             70
     C     *IN70         DOWEQ     *OFF
 
     C                   ADD       1             WCnt
     C                   EVAL      *IN35 = *OFF
 
      ** For Enquiry mode, if selection field not 'E' send error message
     C     T7ACT         IFNE      'E'
     C     T7ACT         ANDNE     'D'
     C     T7ACT         ANDNE     'R'
     C     T7ACT         ANDNE     *BLANK
     C                   MOVE      *ON           *IN34
     C                   MOVE      *ON           *IN35
     C                   MOVEL     T7ACT         ZA0002
     C                   MOVEL     'USR1677'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
 
      ** Switch *ON SFLNXTCHG
     C                   MOVE      *ON           *IN52
     C                   UPDATE    CG007020S0
     C                   READC     CG007020S0                             70
 
     C                   ENDDO
     C                   MOVE      *OFF          *IN52
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  SRSFPR - Subfile processing                                  *
      *                                                               *
      *  Called By: SRPROC subroutine                                 *
      *                                                               *
      *  Calls:                                                       *
      *  SRHeader                                                     *
      *  SRDetail                                                     *
      *  SRReprint                                                    *
      *                                                               *
      *****************************************************************
 
     C     SRSFPR        BEGSR
 
      ** Initialise general error indicator
     C                   MOVE      *OFF          *IN34
 
      ** Set subfile record pointer to top of subfile
     C                   Z-ADD     1             #0RLRN
 
      ** Scan for selection field
     C                   READC     CG007020S0                             70
 
     C     *IN70         DOWEQ     *OFF
 
     C                   SELECT
 
      ** 'E' entered on selection field
     C                   WHEN      T7ACT = 'E'
     C                   EXSR      SRHeader
     C                   WHEN      T7ACT = 'D'
     C                   EXSR      SRDetail
     C                   WHEN      T7ACT = 'R'
     C                   EXSR      SRReprint
 
     C                   ENDSL
 
     C                   MOVE      *BLANK        T7ACT
      ** Update subfile record
     C                   UPDATE    CG007020S0
     C                   READC     CG007020S0                             70
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRHeader - Subrouting to Display Header                      *
      *                                                               *
      *  Called By: SRSFPR subroutine                                 *
      *                                                               *
      *****************************************************************
 
     C     SRHeader      BEGSR
 
     C                   IF        T7STAT = 'A'
     C                   EVAL      PArch = 'ARCHIVE'
     C                   ELSE
     C                   EVAL      PArch = *BLANKS
     C                   ENDIF
     C                   Z-ADD     0             LItem
     C                   MOVE      T7ITEM        LItem
     C                   MOVEL     T7CNUM        LDCor
     C                   MOVE      #LPARM        PParm
     C                   CALL      'CG5010'                             9090
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      'E'           PACTN
     C                   PARM                    PParm
     C                   PARM      *BLANKS       PNSTS
     C                   PARM                    PKEYI
     C                   IF        PRtcd = 'Y2U9999'
     C                   EXSR      SREXIT
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRDetail - Subrouting to Display Detail                      *
      *                                                               *
      *  Called By:                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRDetail      BEGSR
 
     C                   Z-ADD     0             PItem
     C                   MOVE      T7ITEM        PItem
     C                   CALL      'CG007021'                           9191
     C                   PARM                    PItem
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRReprint - Calls the core Reprint Program                   *
      *                                                               *
      *  Called By: SRSFPR                                            *
      *                                                               *
      *****************************************************************
 
     C     SRReprint     BEGSR
     C
     C                   CLEAR                   #WPARM
     C                   MOVE      T7ITEM        #WITEM
     C                   MOVEL     T7CNUM        #WDCOR
     C                   MOVE      'N'           #WFINL
     C                   MOVE      T7STAT        #WARCH
     C                   MOVEL     #WPARM        O#PARM
 
     C                   CALL      'FC0040X'                            90
     C                   PARM      *BLANKS       O#RTN
     C                   PARM      'CG3000'      O#PRG
     C                   PARM      'CGC5220'     O#CPRG
     C                   PARM      '10001'       O#CSEQ
     C                   PARM                    O#PARM
     C                   PARM      AGMBIN        O#MBIN
     C                   PARM      'B'           O#LVL
     C                   PARM      KBRCA         O#ENTY
 
     C                   IF        O#RTN = *BLANKS
     C                   MOVE      *ON           *IN34
     C                   MOVE      'Y'           WRFlag
     C                   MOVEL     'CGD1911'     ZAMSID
     C                   MOVEL     'CGUSRMSG'    ZAMSGF
     C                   MOVEL     T7ITEM        ZAMSDA
     C                   EXSR      ZASNMS
     C                   ENDIF
 
     C     EXPRNT        TAG
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SREXIT - Exit of Program Processing                          *
      *                                                               *
      *  Called By: Main Processing, SRHeader subroutines             *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SREXIT        BEGSR
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * SRPREV - Go to previous screen if F12 is pressed
      *
      * Called By : Main Processing
      * Calls     : SR/END
      *****************************************************************
      *
     C     SRPREV        BEGSR
 
      **   Set F12 return code and end program
 
     C                   MOVE      'USR0790'     PRTCD
     C                   EXSR      SRCLR
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRCMF5 - F5 (Refresh)                                        *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRCMF5        BEGSR
 
     C                   MOVE      'Y'           W0RSF
     C                   EXSR      SRCLR
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  SRCLR  - Use to clear messages in program queue.             *
      *                                                               *
      *  Called By: SRVALS, SRCMF5, SRIZSF subroutines                *
      *                                                               *
      *  Calls:                                                       *
      *  Y2CLMSC   - Clear messages from program queue                *
      *                                                               *
      *****************************************************************
     C     SRCLR         BEGSR
 
      ** Initialize error indicators
     C                   EVAL      *IN34 = *OFF
     C                   EVAL      *IN35 = *OFF
     C                   EVAL      *IN37 = *OFF
     C                   EVAL      ##PGM = 'CG007020'
 
      ** Clear messages from program message queue
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ
     C                   PARM      '*SAME'       ZAPGRL
     C                   WRITE     CG007020C1
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  ZASNMS - Use to send message to program queue. Used for      *
      *           sending messages or other information.              *
      *                                                               *
      *  Called By: SRLOAD, SRVALS, SRVALI subroutines                *
      *                                                               *
      *  Calls:                                                       *
      *  Y2SNMGC   - Send messages to program queue                   *
      *                                                               *
      *****************************************************************
 
     C     ZASNMS        BEGSR
 
     C     ZAPGMQ        IFEQ      *BLANK
     C                   MOVEL     ##PGM         ZAPGMQ
     C                   ENDIF
 
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ
     C                   PARM                    ZAPGRL
     C                   PARM                    ZAMSID
     C                   PARM                    ZAMSGF
     C                   PARM                    ZAMSDA
     C                   PARM                    ZAMSTP
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  *PSSR  - Standard DB Error processing                        *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   DUMP
     C                   MOVE      *ON           *INLR
     C                   CALL      'DBERRCTL'
 
     C                   ENDSR
      *****************************************************************
