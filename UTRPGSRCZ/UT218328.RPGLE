     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Utility to correct DLDTSCPD COHO')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module.                                      *
      *                                                               *
      *  UT218328 - DL Utility to correct confirmed holiday.          *
      *                                                               *
      *  Function: This program corrects COHO records in DLDTSCPD.    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      *  Last Amend No. AR218328 *CREATE   Date 24Mar10               *
      *  Prev Amend No. xxxxxx             Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR218328 - Populate DLDTSCPD COHO if date is a holiday.      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FDLDTSCPD  UF   E           K DISK    PREFIX(@)
      ** Date Schedule
      *
     FDLDLDGLE  IF   E           K DISK
      ** IRS Master File
      *
     FUT218328P1O    E             PRINTER OFLIND(*IN20)
 
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
      ** The following /COPY includes the LE standard declares:
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
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /SPACE 5
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Bank Details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      ** Array for Business Day Convention currencies
     DBDCCcyArr                       3A   DIM(10)
 
     DCcyArr         E DS                  EXTNAME(DLDLDGLE)
     DUPayCcy               2063   2092A
     DURatCcy               2097   2126A
     DTPayCcy               2127   2156A
     DTRatCcy               2161   2190A
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
 
      *****************************************************************
      /SPACE 5
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *
      ** Initialize work variable and set indicators
      *
     C                   Z-ADD     0             WTOT              6 0
     C                   Z-ADD     0             WRK153           15 3
     C                   Z-ADD     0             WRK30             3 0
     C                   MOVE      *BLANK        WHOLI             1
     C                   MOVE      *BLANK        WCCY              3
     C                   MOVE      *BLANK        WPRDT
      *
      ** Select Audit or Update mode
      *
     C     WMODE         IFEQ      'U'
     C     WMODE         OREQ      'u'
     C                   MOVE      '1'           *IN11
     C                   ENDIF
      *
      ** Update COHO in DLDTSCPD if its a holiday.
      *
     C                   EXSR      UPDCHO
      *
     C                   SETON                                        LR
     C                   RETURN
      *
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *                                                               *
      * SR/UPDCHO - Update COHO in DLDTSCPD if its a holiday.         *
      *                                                               *
      *****************************************************************
     C     UPDCHO        BEGSR
      *
     C                   WRITE     UT218328H
     C                   READ      DLDTSCD0                               01
     C     *IN01         DOWEQ     '0'
      *
      ** Get deal currency
      *
     C                   MOVE      @DLNO         WDLNO
     C     KDLNO         CHAIN     DEALSDGF                           02
      *
     C     *IN02         IFEQ      '0'
     C                   EXSR      CHKHOL
      *
      ** If holiday but is not tagged as 'Y' in file
      *
     C     WHOLI         IFEQ      'Y'
     C     @COHO         ANDEQ     *BLANK
      *
     C                   MOVE      @PRDT         ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZADATE        WPRDT
      *
     C                   WRITE     UT218328D
     C                   ADD       1             WTOT
     C     *IN11         IFEQ      '1'
     C                   MOVE      'Y'           @COHO
     C                   UPDATE    DLDTSCD0
     C                   ENDIF
     C                   ENDIF
      *
      ** Overflow
      *
     C     *IN20         IFEQ      '1'
     C                   WRITE     UT218328H
     C                   MOVE      '0'           *IN20
     C                   ENDIF
     C                   ENDIF
      *
      ** Read next record
      *
     C                   READ      DLDTSCD0                               01
     C     *IN01         IFEQ      '1'
     C                   WRITE     UT218328T
     C                   ENDIF
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *                                                               *
      * SR/CHKHOL - Check if its holiday.                             *
      *                                                               *
      *****************************************************************
     C     CHKHOL        BEGSR
     C                   MOVE      *BLANK        WHOLI
     C                   MOVEA     *BLANK        BDCCcyArr
      *
      ** If CIR005 is ON, put business day convention currencies into array
      ** depending if its OUR or THEIR
      *
     C     CIR005        IFEQ      'Y'
     C     @OTIN         IFEQ      'U'
      *
     C     @RCIP         IFEQ      'P'
     C                   MOVEA     UPayCcy       BDCCcyArr
     C                   ELSE
     C                   MOVEA     URatCcy       BDCCcyArr
     C                   ENDIF
      *
     C                   ELSE
      *
     C     @RCIP         IFEQ      'P'
     C                   MOVEA     TPayCcy       BDCCcyArr
     C                   ELSE
     C                   MOVEA     TRatCcy       BDCCcyArr
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** If CIR005 is OFF, just check against currency
      ** Or CIR005 is ON but BDC currencies are blank
      *
     C     CIR005        IFEQ      'N'
     C     CIR005        OREQ      'Y'
     C     BDCCcyArr(1)  ANDEQ     *BLANK
      *
     C     @OTIN         IFEQ      'U'
     C                   MOVE      UCUCY         WCCY
     C                   ELSE
     C                   MOVE      TCUCY         WCCY
     C                   ENDIF
      *
     C                   CALLB     'ZCHKH'
     C                   PARM      @PRDT         PZDateIn          5 0
     C                   PARM      WCCY          PZCcy             3
     C                   PARM      *BLANK        PZLoc             3
     C                   PARM      *BLANK        PZHol             1
      *
     C     PZHol         IFEQ      'H'
     C                   MOVE      'Y'           WHOLI
     C                   ELSE
     C                   MOVE      'N'           WHOLI
     C                   ENDIF
     C                   ELSE
      *
      ** Check using business day conventions currencies
      *
     C     1             DO        10            Y                 2 0
     C                   IF        BDCCcyArr(Y) <> *BLANK
     C                   CALLB     'ZCHKH'
     C                   PARM      @PRDT         PZDateIn
     C                   PARM      BDCCcyArr(Y)  PZCcy
     C                   PARM      *BLANK        PZLoc
     C                   PARM      *BLANK        PZHol
     C                   IF        PZHol = 'H'
     C                   EVAL      WHOLI    = 'Y'
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
     C     WHOLI         IFNE      'Y'
     C     @OTIN         IFEQ      'U'
     C                   MOVE      UCUCY         WCCY
     C                   ELSE
     C                   MOVE      TCUCY         WCCY
     C                   ENDIF
      *
     C                   CALLB     'ZCHKH'
     C                   PARM      @PRDT         PZDateIn          5 0
     C                   PARM      WCCY          PZCcy             3
     C                   PARM      *BLANK        PZLoc             3
     C                   PARM      *BLANK        PZHol             1
      *
     C     PZHol         IFEQ      'H'
     C                   MOVE      'Y'           WHOLI
     C                   ELSE
     C                   MOVE      'N'           WHOLI
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Check against sat or sunday
      *
     C                   EVAL      WRK153 = @PRDT / 7
     C                   MOVE      WRK153        WRK30
     C                   IF        (WRK30 = 142) OR (WRK30 = 285)
     C                   MOVE      'Y'           WHOLI
     C                   ENDIF
      *
     C                   ENDSR
     ******************************************************************
     C/SPACE 5
      *****************************************************************
     C     ZDATE2        BEGSR
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        ZDATE             6 0
     C                   PARM                    ZADATE            7
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      * Mode
     C                   PARM                    WMODE             1
 
      *
      ** Access Bank Details
      *  ~~~~~~~~~~~~~~~~~~~
     C                   CALLB     'AOBANKR0'
     C                   PARM      '       '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*ERROR '     RetCodeIn
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '900'         DBASE
     C                   MOVEL     '*FIRST  '    DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access SAR details file to determine if FRA/IRS Business Day
      ** Day Convention is switched on.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CIR005'      @SARD
     C                   PARM                    DSFDY
      *
     C                   IF        (@RTCD <> *BLANKS) And (@RTCD <> '*NRF   ')
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '906'         DBASE
     C                   MOVEL     'CIR005'      DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        @RTCD = *BLANKS
     C                   MOVEL     'Y'           CIR005            1
     C                   ELSE
     C                   MOVEL     'N'           CIR005
     C                   ENDIF
      *
      ** Key lists
      *
     C     KDLNO         KLIST
     C                   KFLD                    WDLNO             6 0
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2010
