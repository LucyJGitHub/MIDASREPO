     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas RE T&N Calculation of Period Start Date')
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE200101 - Calculation of Period Start Date                  *
      *                                                               *
      *  Function:  This program will calculate the Period Start Date *
      *             for Period and Penalty Details.                   *
      *                                                               *
      *  Called By: REC200101                                         *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. BUG27446           Date 12Apr10               *
      *                 CRE015  *CREATE    Date 18Dec09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG27446 - Error in the default Period Start Date if the     *
      *             event being created is greater B                  *
      *  CRE015 - Retail Term and Notice Accounts                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *  01 - 19      Input Control.                                  *
      *  20 - 29      I/O Conditioning (ie. CHAIN, LOKUP etc...)      *
      *   20          Record Not Found                                *
      *   21          File Error Occurred                             *
      *   22          Start/End Of File Reached                       *
      *   25          Lookup/Scan.                                    *
      *  30 - 39      Program Work Indicators                         *
      *  40 - 49      Output Control.                                 *
      *  50 - 89      Output Conditioning (ie. Cursor Positioning)    *
      *  90 - 99      Error Control.                                  *
      *    98         Date Format                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      ** +-----------------------------------------------------------------+
      ** D specs of the following types should be inserted after the
      ** relevant box.  *** Remove this text afterwards. ***
      ** +-----------------------------------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      ** Number of days in each month                                                       BUG27446
                                                                                            BUG27446
     D UFMD            S              2    DIM(12) CTDATA PERRCD(12)                        BUG27446
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * Definition: First DS for Access Programs, Short Data Structure
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      * Definition: Bank Details Accessed Via Access Program.
 
     D REPFWX        E DS                  EXTNAME(REPRPNPD)
     D                                     PREFIX(WX:2)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1A
 
      ** Entry Paramerter
 
     D PRTCD           S              7A
     D PTPRD           S              1A
     D PEVNT           S              1A
     D PCEDE           S              6A
     D PNDPD           S              3A
     D PNMPD           S              2A
     D PFREQ           S              1A
     D PDAYM           S              2A
     D PVDAT2          S              6A
 
      ** Access Object Parameters
     D POptn           S              7A
 
      ** ZDATE1 Parameters
 
     D ZERR            S              7A
     D ZDATE           S              6  0
     D ZDATFM          S              1A
     D ZDAYNO          S              5  0
 
      ** ZDATE2 Parameters
 
     D ZADATE          S              7A
 
      ** ZALIGN Parameters
 
     D ZRTN            S              7A
     D ZFIELD          S             16A
     D ZADEC           S              1  0
     D ZADIG           S              2  0
     D ZAFLD           S             16A
 
      ** ZSEDIT Parameters
 
     D ZFLD15          S             15  0
     D ZDECS           S              1  0
     D ZECODE          S              1A
     D ZOUT21          S             21A
     D ZAFLD1          S             16A
 
      ** RETNDAT1 Parameters
 
     D MAINT           S              7A
     D RUNCHG          S              5
     D PDATE           S              5  0
 
      ** Other Variables
     D WTERM           S              1A   INZ('N')
     D PVDAT2#         S              5  0
     D PCEDE#          S              5  0
     D PNDPD#          S              3  0
     D PNMPD#          S              2  0
     D PDAYM#          S              2  0
     D WTRM2           S              3  0                                                  BUG27446
     D X               S              3  0                                                  BUG27446
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** Check for simple defaulting of start date.
 
     C                   EXSR      SrSimple
 
      ** End date is not in date format but in number of terms.
 
     C                   IF        WTERM = 'Y'
     C                   EXSR      SrDefault
     C                   EXSR      SrCalDat
 
      ** Convert PDATE to date format
 
     C**********         Z-ADD     0             ZDAYNO                                     BUG27446
     C*****PDATE         ADD       1             ZDAYNO                                     BUG27446
 
     C                   EXSR      SrConvert
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrSimple - Check for simple defaulting of start date          *
      *                                                               *
      * Called by: Main Procedure                                     *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
     C     SrSimple      BEGSR
 
      ** If next event is equal to 'A' use rundate as start date.
 
     C                   IF        PEVNT = 'Z'
     C                   Z-ADD     BJRDNB        ZDAYNO
     C                   EXSR      SRConvert
     C                   ELSE
 
      ** Validate End date
 
 03  C                   EVAL      ZDATE = %DEC(PCEDE:6:0)
     C                   IF        ZDATE > 999
 03  C                   CALL      'ZDATE1'
 03  C                   PARM                    ZERR
 03  C                   PARM                    ZDATE
 03  C                   PARM      BJDFIN        ZDATFM
 03  C                   PARM      0             ZDAYNO
     C                   Z-ADD     ZDAYNO        PCEDE#
 
      ** Convert Current Value Date to Midas day number.
 
     C     PCEDE#        ADD       1             PVDAT2#
     C                   Z-ADD     PVDAT2#       ZDAYNO
     C                   EXSR      SRConvert
 
     C                   ELSE
     C                   IF        ZDATE > 0 AND
     C                             ZDATE < 999
     C**********         EVAL      PCEDE# = ZDATE                                           BUG27446
     C                   Z-ADD     ZDATE         WTRM2                                      BUG27446
     C                   EVAL      WTerm = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrDefault - Default fields                                    *
      *                                                               *
      * Called by: Main Procedure                                     *
      *                                                               *
      * Calls: SrValid                                                *
      *                                                               *
      *****************************************************************
     C     SrDefault     BEGSR
 
      ** Check if parameter passed are all valid, else use default.
 
     C                   EXSR      SRValid
 
      ** Move parameter to data structure
 
     C**********         MOVEL     PEVNT         WXEVNT                                     BUG27446
     C**********         Z-ADD     1             WXITEM                                     BUG27446
     C**********         Z-ADD     0             WXVDAT                                     BUG27446
     C**********         Z-ADD     0             WXMDAT                                     BUG27446
     C**********         Z-ADD     PCEDE#        WXCEDE                                     BUG27446
     C**********         Z-ADD     PNDPD#        WXNDPD                                     BUG27446
     C**********         Z-ADD     PNMPD#        WXNMPD                                     BUG27446
     C**********         MOVEL     PFREQ         WXFREQ                                     BUG27446
     C**********         MOVEL     ' '           WXIRLI                                     BUG27446
     C**********         MOVEL     PTPRD         WXTPRD                                     BUG27446
     C**********         MOVEL     *ZEROS        WXDRIB                                     BUG27446
     C**********         MOVEL     *ZEROS        WXDRIS                                     BUG27446
     C**********         MOVEL     *ZEROS        WXDICT                                     BUG27446
     C**********         MOVEL     *ZEROS        WXDCST                                     BUG27446
     C**********         MOVEL     '1'           WXDRIC                                     BUG27446
     C**********         MOVEL     'D'           WXDNIR                                     BUG27446
     C**********         MOVEL     'Z'           WXDRIF                                     BUG27446
     C**********         MOVEL     *BLANKS       WXDRBR                                     BUG27446
     C**********         MOVEL     *BLANKS       WXDACP                                     BUG27446
     C**********         MOVEL     *ZEROS        WXCRIB                                     BUG27446
     C**********         MOVEL     *ZEROS        WXCRIS                                     BUG27446
     C**********         MOVEL     *ZEROS        WXCICT                                     BUG27446
     C**********         MOVEL     *ZEROS        WXCCST                                     BUG27446
     C**********         MOVEL     '1'           WXCRIC                                     BUG27446
     C**********         MOVEL     'D'           WXCNIR                                     BUG27446
     C**********         MOVEL     'Z'           WXCRIF                                     BUG27446
     C**********         MOVEL     *BLANKS       WXCRBR                                     BUG27446
     C**********         MOVEL     *BLANKS       WXCACP                                     BUG27446
     C**********         MOVEL     *BLANKS       WXRTTD                                     BUG27446
     C**********         MOVEL     ' '           WXDYBD                                     BUG27446
     C**********         MOVEL     ' '           WXDRST                                     BUG27446
     C**********         MOVEL     *BLANKS       WXRTTC                                     BUG27446
     C**********         MOVEL     ' '           WXDYBC                                     BUG27446
     C**********         MOVEL     ' '           WXCRST                                     BUG27446
     C**********         Z-ADD     PDAYM#        WXDAYM                                     BUG27446
     C**********         Z-ADD     0             WXDTWD                                     BUG27446
     C**********         Z-ADD     26664         WXNDID                                     BUG27446
     C**********         Z-ADD     0             WXDRDY                                     BUG27446
     C**********         Z-ADD     26664         WXNCID                                     BUG27446
     C**********         Z-ADD     0             WXCRDY                                     BUG27446
     C**********         MOVEL     *BLANKS       WXKEY1                                     BUG27446
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValid - Validate Entry                                      *
      *                                                               *
      * Called by: SrDefault                                          *
      *                                                               *
      * Calls: SrNEdit                                                *
      *                                                               *
      *****************************************************************
     C     SRValid       BEGSR
 
      ** Number of Days
 
     C                   IF        PNDPD <> *BLANKS
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      PNDPD         ZFIELD
     C                   Z-ADD     3             ZADIG
     C                   Z-ADD     0             ZADEC
 
     C                   EXSR      SrNEdit
 
     C                   IF        ZRTN <> *BLANKS
     C                   Z-ADD     0             PNDPD#
     C                   ELSE
     C                   EVAL      PNDPD# = %DEC(ZAFLD1:6:0)
     C                   ENDIF
     C                   ENDIF
 
      ** Number of Months
 
     C                   IF        PNMPD <> *BLANKS
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      PNMPD         ZFIELD
     C                   Z-ADD     2             ZADIG
     C                   Z-ADD     0             ZADEC
 
     C                   EXSR      SrNEdit
 
     C                   IF        ZRTN <> *BLANKS
     C                   Z-ADD     0             PNMPD#
     C                   ELSE
     C                   EVAL      PNMPD# = %DEC(ZAFLD1:6:0)
     C                   ENDIF
     C                   ENDIF
 
      ** Day of the Month
 
     C                   IF        PDAYM <> *BLANKS
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      PDAYM         ZFIELD
     C                   Z-ADD     2             ZADIG
     C                   Z-ADD     0             ZADEC
 
     C                   EXSR      SrNEdit
 
     C                   IF        ZRTN <> *BLANKS
     C                   Z-ADD     0             PDAYM#
     C                   ELSE
     C                   EVAL      PDAYM# = %DEC(ZAFLD1:6:0)
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * SrNEdit - Standard Routine to Check and Format                *
      *                                                               *
      * Called by: SrValid                                            *
      *                                                               *
      * Calls: ZALIGN, ZSEDIT                                         *
      *                                                               *
      *****************************************************************
     C     SrNEdit       BEGSR
 
     C                   MOVE      ZFIELD        ZAFLD1
     C                   MOVE      *BLANKS       ZAFLD
     C                   CALL      'ZALIGN'
     C                   PARM      *BLANKS       ZRTN
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
     C                   PARM                    ZAFLD
 
     C                   IF        ZRTN = *BLANKS
     C                   MOVE      ZAFLD         ZFLD15
 
     C                   CALL      'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM      ZADEC         ZDECS
     C                   PARM      '3'           ZECODE
     C                   PARM                    ZOUT21
     C     16            SUBST     ZOUT21:5      ZAFLD1
     C                   ENDIF
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCalDat - Calculate Date                                     *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRCalDat      BEGSR
 
     C**********         MOVE      BJRDNB        RUNCHG                                     BUG27446
     C**********         MOVE      PCEDE         PDATE                                      BUG27446
     C**********         CALL      'RETNDAT1'                                               BUG27446
     C**********         PARM                    REPFWX                                     BUG27446
     C**********         PARM      '*NEW'        MAINT                                      BUG27446
     C**********         PARM                    RUNCHG                                     BUG27446
     C**********         PARM                    PDATE                                      BUG27446
     C**********         PARM                    PRTCD                                      BUG27446
     C                   EVAL      ZDATE = %DEC(PVDAT2:6:0)                                 BUG27446
     C                   CALL      'ZDATE1'                                                 BUG27446
     C                   PARM                    ZERR                                       BUG27446
     C                   PARM                    ZDATE                                      BUG27446
     C                   PARM      BJDFIN        ZDATFM                                     BUG27446
     C                   PARM      0             ZDAYNO                                     BUG27446
     C                   Z-ADD     ZDAYNO        WVDAT2            5 0                      BUG27446
                                                                                            BUG27446
     C                   Z-ADD     1             X                                          BUG27446
     C     X             DOWLE     WTRM2                                                    BUG27446
                                                                                            BUG27446
      ** If input date sensible i.e. < Midas limit date 31/12/44                            BUG27446
      **  advance forwards/backwards 1 term                                                 BUG27446
                                                                                            BUG27446
     C     WVDAT2        IFLT      26664                                                    BUG27446
                                                                                            BUG27446
     C     WVDAT2        SUB       1             WVDAT2                                     BUG27446
      ** If freq code used, call routine                                                    BUG27446
                                                                                            BUG27446
     C     PFREQ         IFNE      *BLANKS                                                  BUG27446
     C                   CALL      'ZFRQB5'                                                 BUG27446
     C                   PARM      PFREQ         ZFREQ             1                        BUG27446
     C                   PARM      WVDAT2        ZDAYNO            5 0                      BUG27446
     C                   PARM      PDAYM#        ZMDAY             2 0                      BUG27446
     C                   PARM      BJLCCY        ZCCY              3                        BUG27446
     C                   PARM      *BLANKS       ZLOC              3                        BUG27446
     C                   PARM      'F'           ZDIREC            1                        BUG27446
     C                   PARM      *BLANKS       ZRTRN             7                        BUG27446
     C                   Z-ADD     ZDAYNO        WVDAT2                                     BUG27446
                                                                                            BUG27446
      ** Else if frequency blank                                                            BUG27446
                                                                                            BUG27446
     C                   ELSE                                                               BUG27446
                                                                                            BUG27446
     C     PNMPD#        IFEQ      0                                                        BUG27446
     C     WVDAT2        ADD       PNDPD#        WVDAT2                                     BUG27446
     C                   ELSE                                                               BUG27446
                                                                                            BUG27446
     C                   Z-ADD     0             EDD               2 0                      BUG27446
     C                   Z-ADD     0             EMM               2 0                      BUG27446
     C                   Z-ADD     0             EYY               2 0                      BUG27446
     C                   Z-ADD     WVDAT2        ZDAYNO                                     BUG27446
     C                   EXSR      SRConvert                                                BUG27446
     C                   MOVEL     PVDAT2        UUWRK2            2                        BUG27446
     C                   MOVE      UUWRK2        EDD               2 0                      BUG27446
                                                                                            BUG27446
      ** Calculate date nmth no. of months ahead                                            BUG27446
                                                                                            BUG27446
     C                   Z-ADD     0             UMTH              3 0                      BUG27446
     C                   Z-ADD     0             UMTH2             2 0                      BUG27446
     C                   MOVEL     PVDAT2        UWRK4             4                        BUG27446
     C                   MOVE      UWRK4         UMTH2                                      BUG27446
     C     UMTH2         ADD       PNMPD#        UMTH                                       BUG27446
                                                                                            BUG27446
      ** Convert into months and years                                                      BUG27446
                                                                                            BUG27446
     C                   Z-ADD     UMTH          EMM                                        BUG27446
     C                   MOVE      PVDAT2        EYY               2 0                      BUG27446
     C     UMTH          IFGE      12                                                       BUG27446
     C     UMTH          ORLE      -12                                                      BUG27446
     C     UMTH          DIV       12            UMYR              2 0                      BUG27446
     C                   MVR                     UMY               2 0                      BUG27446
     C                   Z-ADD     UMY           EMM                                        BUG27446
     C     EYY           ADD       UMYR          EYY                                        BUG27446
     C                   END                                                                BUG27446
                                                                                            BUG27446
      ** If negative values of month and year, make valid values                            BUG27446
                                                                                            BUG27446
     C     EMM           IFLT      1                                                        BUG27446
     C     12            ADD       EMM           EMM                                        BUG27446
     C     EYY           SUB       1             EYY                                        BUG27446
     C                   ENDIF                                                              BUG27446
                                                                                            BUG27446
     C     EYY           IFLT      0                                                        BUG27446
     C     100           ADD       EYY           EYY                                        BUG27446
     C                   ENDIF                                                              BUG27446
                                                                                            BUG27446
      ** Check for leap year                                                                BUG27446
                                                                                            BUG27446
     C     EYY           DIV       4             ULYR              2 0                      BUG27446
     C                   MVR                     ULY               1 0                      BUG27446
                                                                                            BUG27446
      ** Check day number is within end of month                                            BUG27446
                                                                                            BUG27446
     C                   MOVE      UFMD(EMM)     UWRK2             2 0                      BUG27446
     C     EMM           IFEQ      2                                                        BUG27446
     C     ULY           ANDEQ     0                                                        BUG27446
     C                   Z-ADD     29            UWRK2                                      BUG27446
     C                   END                                                                BUG27446
                                                                                            BUG27446
     C     EDD           IFGT      UWRK2                                                    BUG27446
     C                   Z-ADD     UWRK2         EDD                                        BUG27446
     C                   END                                                                BUG27446
                                                                                            BUG27446
      **   Reformat date, DDMMYY, and convert to day number                                 BUG27446
                                                                                            BUG27446
     C                   MOVEL     EDD           ZWRK4             4 0                      BUG27446
     C                   MOVE      EMM           ZWRK4                                      BUG27446
     C                   MOVEL     ZWRK4         ZDATE                                      BUG27446
     C                   MOVE      EYY           ZDATE                                      BUG27446
                                                                                            BUG27446
     C                   CALL      'ZDATE1'                                                 BUG27446
     C                   PARM                    ZERR                                       BUG27446
     C                   PARM                    ZDATE                                      BUG27446
     C                   PARM      'D'           ZDATFM                                     BUG27446
     C                   PARM      0             ZDAYNO                                     BUG27446
                                                                                            BUG27446
     C                   Z-ADD     ZDAYNO        WVDAT2                                     BUG27446
     C                   ENDIF                                                              BUG27446
                                                                                            BUG27446
      ** End of Frequency condition                                                         BUG27446
                                                                                            BUG27446
     C                   ENDIF                                                              BUG27446
                                                                                            BUG27446
      ** End of sensible date condition                                                     BUG27446
                                                                                            BUG27446
     C                   ENDIF                                                              BUG27446
                                                                                            BUG27446
     C     WVDAT2        ADD       1             WVDAT2                                     BUG27446
                                                                                            BUG27446
     C                   ADD       1             X                                          BUG27446
     C                   ENDDO                                                              BUG27446
                                                                                            BUG27446
      ** Set to Midas limit date 31/12/44 if beyond it                                      BUG27446
                                                                                            BUG27446
     C     WVDAT2        IFGE      26664                                                    BUG27446
     C                   Z-ADD     26664         WVDAT2                                     BUG27446
     C                   ENDIF                                                              BUG27446
     C                   Z-ADD     WVDAT2        ZDAYNO                                     BUG27446
                                                                                            BUG27446
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * SRCalDat - Calculate Date                                     *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRConvert     BEGSR
 
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE
     C                   MOVEL     ZDATE         PVDAT2
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PRTCD
     C                   PARM                    PTPRD
     C                   PARM                    PEVNT
     C                   PARM                    PCEDE
     C                   PARM                    PNDPD
     C                   PARM                    PNMPD
     C                   PARM                    PFREQ
     C                   PARM                    PDAYM
 
     C                   PARM                    PVDAT2
      *
      ** Read in Installation Data
      *
     C     *DTAARA       DEFINE                  LDA
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA
 
      * Retrieve Bank Details.
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
     C                   CALL      'DBERRCTL'
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**CTDATA UFMD  -  NUMBER OF DAYS IN THE MONTH
312831303130313130313031
