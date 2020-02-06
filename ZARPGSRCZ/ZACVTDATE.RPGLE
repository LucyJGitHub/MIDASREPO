     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Fmts Midas day nmbr to date fmt data type')
      *****************************************************************
      *                                                               *
      *  Midas - Standard Subprograms                                 *
      *                                                               *
      *  ZACVTDATE - Convert Midas day number to date format as       *
      *             defined on D specs                                *
      *                                                               *
      *  Function:  This module accepts Midas day number and converts *
      *             it to date format as defined on Data specification*
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG7519            Date 09Jun05               *
      *                 CSD015  *CREATE    Date 14Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG7519- Format OUTDATE field based on the Date Format ind - *
      *           'D' = YYMMDD; 'M' = YYDDMM.                         *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of indicator                           *
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
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Short data structure for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     ** input parameters
     DMidasDayNumber   S              5A
     DAMDATE           S               D
     DConvertedDate    S             10A
 
      ** Working variables
     DDateF            S               D
     DDayA             S              5A
     DDayN             S              5  0
     DReturnCode       S              7A
     DOption           S              7A
     D@RUN             S              1A
 
      ** Converts Midas Run Date to a date
     DMidasDate        PR             8
     D  DayNum                        5  0 VALUE
 
      ** Formats a Midas Run day 99999 into an XML date CCYY-MM-DD
     DXMLDate          PR            10
     D  DayA                          5    VALUE
 
      ** Adjust characters to the right
     DRightAdjust      PR            15
     D  NumberAlph                   15    VALUE
 
      **********************************************************************
      * M A I N   P R O C E S S I N G
      **********************************************************************
 
      ** Date
     C                   IF        MidasDayNumber <> *blanks
     C                   EVALR     MidasDayNumber=RightAdjust(MidasDayNumber)
     C                   MOVEL     MidasDayNumberDayN
     C                   MOVEL     DayN          DayA
     C                   EVAL      ConvertedDate = XMLDate(DayA)
 
     C                   IF        DayN = *Zeros
     C                   MOVE      DateF         ConvertedDate
     C                   ENDIF
 
     C                   MOVEL     ConvertedDate DateF
     C                   EVAL      AMDATE = DateF
     C                   ENDIF
 
     C                   MOVEL     *ON           *INLR
 
     C                   RETURN
 
      **********************************************************************
      * INITIALISATION SUBROUTINE
      **********************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    ReturnCode
     C                   PARM                    MidasDayNumber
     C                   PARM                    AMDATE
     C                   PARM                    ConvertedDate
 
      ** Call access program for bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM      '*FIRST '     Option
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        ReturnCode <> *Blanks
     C                   eval      DBFILE = 'SDBANKPD'
     C                   eval      DBASE = 911
     C                   eval      DBKEY = Option
     C                   exsr      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      **********************************************************************
      * Converts Midas Run date
      **********************************************************************
     PMidasDate        B
     DMidasDate        PI             8
     D  DayNum                        5  0 VALUE
 
      *
     DDtDDMMCCYY       DS
     D  DDMMCCYY                      8  0
      *
     DDate             S              8
     DpmRetn           S              1
     DpmDayNum         S              5  0
     DpmDatFmt         S              1
     DpmDate           S              6  0
     DpmData           S              7
     DpmDate8          S              8  0
     DpmDate8F         S              8  0
      *
     C                   CALLB     'ZA0140M'
     C                   PARM                    pmRetn
     C                   PARM      DayNum        pmDayNum
     C                   PARM      BJDFIN        pmDatFmt
     C                   PARM      0             pmDate
     C                   PARM      *BLANK        pmData
     C                   PARM      0             pmDate8
     C     DDMMCCYY      PARM      0             pmDate8F
 
     C                   IF        pmRetn <> '0'
     C                   EVAL      Date = '*ERROR'
     C                   ELSE
     C                   EVAL      Date = DtDDMMCCYY
     C                   ENDIF
 
     C                   RETURN    Date
     P                 E
      **********************************************************************
      * Formats a Midas Run day 99999 into an XML date CCYY-MM-DD
      **********************************************************************
     PXMLDate          B
     DXMLDate          PI            10
     D  DayA                          5    VALUE
      *
     DDIGITS           C                         CONST('0123456789')
     DNotDig           S              3  0
     DDayN             S              5  0
      *
     DDtDDMMCCYY       DS
     D  DDMMCCYY                      8  0
     D  DD                            2    OVERLAY(DDMMCCYY:1)
     D  MM                            2    OVERLAY(DDMMCCYY:3)
     D  CC                            2    OVERLAY(DDMMCCYY:5)
     D  YY                            2    OVERLAY(DDMMCCYY:7)
      *
     DOutDate          S             10
      *
      ** Must be numeric
     C     DIGITS        CHECK     DayA          NotDig
     C                   IF        NotDig = 0
     C                   MOVE      DayA          DayN
     C                   EVAL      DtDDMMCCYY = MidasDate(DayN)
      *
     C                   IF        DtDDMMCCYY = '*ERROR'
     C                   EVAL      OutDate = '*ERROR'
     C                   ELSE
      *                                                                                      BUG7519
     C                   IF        BJDFIN = 'D'                                              BUG7519
     C                   EVAL      OutDate = CC+YY+'-'+MM+'-'+DD
     C                   ELSE                                                                BUG7519
     C                   EVAL      OutDate = CC+YY+'-'+DD+'-'+MM                             BUG7519
     C                   ENDIF                                                               BUG7519
      *                                                                                      BUG7519
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      OutDate = '*ERROR'
     C                   ENDIF
 
     C                   RETURN    OutDate
     P                 E
      **********************************************************************
      * Adjust characters to the right
      **********************************************************************
     PRightAdjust      B
     DRightAdjust      PI            15
     D  NumberAlph                   15    VALUE
      *
     DWrkArr           S              1    DIM(15)
     DRightValue       S             15
     Di                S              2  0
     Dj                S              2  0
     Dlen              S              2  0
      *
     C     ' '           CHECKR    NumberAlph    Len
      ** No need to right adjust if the lengh is maximum
     C                   IF        Len = %ELEM(WrkArr)
     C                   EVAL      RightValue = NumberAlph
     C                   ELSE
     C                   MOVEA     NumberAlph    WrkArr
     C                   EVAL      j = %ELEM(WrkArr)
     C                   EVAL      i = Len
 
     C                   DOW       i >= 1
     C                   EVAL      WrkArr(j) = WrkArr(i)
     C                   EVAL      WrkArr(i) = *BLANK
     C                   EVAL      i = i - 1
     C                   EVAL      j = j - 1
     C                   ENDDO
 
     C                   MOVEA     WrkArr        RightValue
     C                   ENDIF
      *
     C                   RETURN    RightValue
     P                 E
