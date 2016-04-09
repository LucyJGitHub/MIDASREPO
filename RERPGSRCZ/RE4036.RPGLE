     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2009')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas RE T&N rate changes at rollover - Prompt')
      *****************************************************************
      *                                                               *
      *  Midas - Retail T&N Accounts                                  *
      *                                                               *
      *  RE4036 - Midas RE T&N rate changes at rollover - Prompt      *
      *                                                               *
      *  Function:  This program is used to prompt for parameters for *
      *             T&N rate changes at rollover.                     *
      *                                                               *
      *  Called By: REC4036 - Midas RE T&N rate changes at rollover - *
      *             Prompt                                            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2009            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. CRE015 *CREATE     Date 18Dec09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE015 - Retail T&N Accounts                                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    10         Message File subfile                            *
      *    61         Start Date control                              *
      *    62         End Date control                                *
      *    63         Mode of Processing control                      *
      *    98         Date Format                                     *
      *    KC         Display Exit control                            *
      *    LR         Last Record                                     *
      *    U7         *PSSR error                                     *
      *    U8         *PSSR error                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRDEFT - Set Defaults                                         *
      * SRPROC - Main Processing                                      *
      * XSPMSQ - Send Messages to Program Message Queue               *
      * SRVALD - Validate Fields                                      *
      * ENDPGM - End Program                                          *
      * XCPMSQ - Clear Program Message Queue                          *
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
 
     FRE4036DF  CF   E             WORKSTN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
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
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
     D #PARM           DS           100
     D  STDATE                 1      6
     D  ENDATE                 7     12
     D  OPMODE                13     17
      *
      ** Entry parameter DS for #PARM
      *
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
     D WKERR           S              1    INZ('N')
 
     D PRTCD           S              7
     D DATEX           S              6  0
     D DFMT            S              1
     D DAYNO           S              5  0
      *
      ** ZDATE1 parameters
      *
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
      *
      ** Read in Installation Data
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDAT
      *
      ** Set Date Format Indicator *IN98  on if date format is MMDDYY
      *
     C                   IF        AGDFF = 'M'
     C                   EVAL      *IN98 = *ON
     C                   ENDIF
      *
      ** Set Defaults
      *
     C                   EXSR      SRDEFT
      *
      ** Main Processing
      *
     C                   EXSR      SRPROC
 
     C                   Return
 
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDEFT - Set Defaults                                         *
      *                                                               *
      * Called By: MAIN                                               *
      *                                                               *
      * Calls:     None                                               *
      *                                                               *
      *****************************************************************
 
     C     SRDEFT        BEGSR
 
     C                   EVAL      STDATE = 'PRVRUN'
     C                   EVAL      ENDATE = 'RUNDAT'
     C                   EVAL      OPMODE = 'AUDIT'
 
     C                   ENDSR
 
     C/EJECT
      *****************************************************************
      *                                                               *
      * SRPROC - Main Processing                                      *
      *                                                               *
      * Called By: MAIN                                               *
      *                                                               *
      * Calls:     XCPMSQ, SRVALD                                     *
      *                                                               *
      *****************************************************************
 
     C     SRPROC        BEGSR
 
     C                   DOU       *INKC = *ON OR
     C                             WKERR = 'N'
 
     C                   WRITE     RE4036HH
     C                   WRITE     RE4036FF
     C                   WRITE     MSGCTL
     C                   EXFMT     RE4036DD
 
     C                   EXSR      XCPMSQ
 
     C                   EXSR      SRVALD
 
     C                   ENDDO
 
     C                   ENDSR
 
     C/EJECT
      *****************************************************************
      *                                                               *
      * XSPMSQ - Send Messages to Program Message Queue               *
      *                                                               *
      * Called By: SRVALD                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     XSPMSQ        BEGSR
 
     C                   CALL      'Y2SNMGC'
     C                   PARM      PSPROCNAME    P@PMSQ           10
     C                   PARM      '*SAME'       P@PMSL            5
     C                   PARM                    P@MSGI            7
     C                   PARM      'REUSRMSG'    P@MSGF           10
     C                   PARM                    P@MDTA          132
     C                   PARM      '*INFO'       P@MTYP            7
 
     C                   ENDSR
 
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRVALD - Validate Fields                                     *
      *                                                               *
      *  Called By: SRPROC                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRVALD        BEGSR
      *
      ** Start Date
      *
     C                   IF        STDATE <> 'PRVRUN'
     C                   MOVE      STDATE        DATEX
 
     C                   CALL      'ZDATE1'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM                    DATEX
     C                   PARM      'D'           DFMT
     C                   PARM                    DAYNO
 
     C                   IF        PRTCD = '*ERROR*'
     C                   MOVEL     'RE77111'     P@MSGI
 
     C                   EXSR      XSPMSQ
 
     C                   EVAL      *IN61 = *ON
     C                   EVAL      WKERR = 'Y'
     C                   ENDIF
     C                   ENDIF
      *
      ** End Date
      *
     C                   IF        ENDATE <> 'RUNDAT'
     C                   MOVE      ENDATE        DATEX
 
     C                   CALL      'ZDATE1'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM                    DATEX
     C                   PARM      'D'           DFMT
     C                   PARM                    DAYNO
 
     C                   IF        PRTCD = '*ERROR*'
     C                   MOVEL     'RE77112'     P@MSGI
 
     C                   EXSR      XSPMSQ
 
     C                   EVAL      *IN62 = *ON
     C                   EVAL      WKERR = 'Y'
     C                   ENDIF
     C                   ENDIF
      *
      ** Mode of Operation
      *
     C                   If        OPMODE <> 'UPDAT' AND
     C                             OPMODE <> 'AUDIT'
     C                   MOVEL     'RE77113'     P@MSGI
 
     C                   EXSR      XSPMSQ
 
     C                   EVAL      *IN63 = *ON
     C                   EVAL      WKERR = 'Y'
     C                   ENDIF
 
     C                   ENDSR
 
     C/EJECT
      *****************************************************************
      *                                                               *
      *  XCPMSQ - Clear Program Message Queue                         *
      *                                                               *
      *  Called By: SRPROC                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     XCPMSQ        BEGSR
 
     C                   CALL      'Y2CLMSC'
     C                   PARM      PSPROCNAME    P@PMSQ
     C                   PARM      '*SAME'       P@PMSL
 
     C                   MOVEA     '000'         *IN(61)
     C                   EVAL      WKERR = 'N'
 
     C                   ENDSR
 
     C/EJECT
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
     C                   PARM                    #SEQ              5
     C                   PARM                    #LEV              1
     C                   PARM                    #ENT              3
     C                   PARM                    #PARM
 
     C                   EVAL      *IN10 = *ON
 
     C                   ENDSR
 
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
 
     C     *PSSR         BEGSR
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
 
     C                   CALL      'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      /EJECT
