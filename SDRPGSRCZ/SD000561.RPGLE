     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2016')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD CRS Joint Account Indicia Processing')        *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000561 - Midas SD CRS Joint Account Indicia Processing     *
      *                                                               *
      *  Function:  This module checks for CRS Indicia for Customers  *
      *             and Non Account Holders.                          *
      *                                                               *
      *  (c) Finastra International Limited 2016                      *
      *                                                               *
      *  Last Amend No. CGL177  *CREATE    Date 11Jan16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL177 - CRS Reporting Phase 2                               *
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

     FSDCRSHL0  IF   E           K DISK    INFSR(*PSSR)

     FSDCRSDL1  UF A E           K DISK    INFSR(*PSSR)

      ** Midas SD Joint Account Member
     FSDJACCL1  IF   E           K DISK

     FSDJACCL2  IF   E           K DISK
     F                                     PREFIX(JS:2)
     F                                     RENAME(SDJACCD0:SDJACCD1)

     FSDCRSDL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(JQ:2)
     F                                     RENAME(SDCRSDD0:SDCRSDD2)

     FSDCRSNL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(JR:2)
     F                                     RENAME(SDCRSND0:SDCRSND2)

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

      ** +-----------------------------------------------------------------+
      ** D specs of the following types should be inserted after the
      ** relevant box.  *** Remove this text afterwards. ***
      ** +-----------------------------------------------------------------+

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

     D PMember         S              6A   DIM(999)

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Second DS for Access Programs, Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** External data structure for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** External data structure for CUSD
     D SDCUSD        E DS                  EXTNAME(SDCUSTPD)

      ** External data structure for SVAL
     D SDCRSH        E DS                  EXTNAME(SDCRSHPD)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D @RUN            S              1
     D KCust           S              6A
     D PRetcode        S              7A
     D POption         S              7A
     D PRTCD           S              7A   INZ(*BLANKS)
     D Poptn           S              7A
     D PKey1           S             10A
     D PKySt           S              7A

      ** Timestamp for the transaction
     D TimeStamp       S               Z
     D WTime           S               T
     D WWTIME          S              6A
     D DDCUST          S              6A
     D WCTRY           S              2A

     D WREPT           S              1A
     D KCTRY           S              2A
     D KJANO           S              6A
     D KMEMB           S              6A
     D WREAD           S              1A
     D WCUST           S              6A
     D PReturn         S              7A
     D N               S              3S 0
     D WIndicia        S              1A

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

      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

     C                   EVAL      PReturn = *BLANKS
     C                   EXSR      SrMltLvl

     C                   SETON                                        LR
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrMltLvl - Process multi level joint account                  *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: SrMltLvl2                                              *
      *                                                               *
      *****************************************************************

     C     SrMltLvl      BEGSR

     C                   EVAL      KJANO = *Blanks
     C                   EVAL      KMEMB = *Blanks
     C                   EVAL      Pmember(1) = *Blanks

      ** If joint account member is deleted
     C                   IF        WIndicia = ' '
     C                   EVAL      Pmember(1) = WCUST
     C                   EXSR      SrMltJDelete

     C                   ELSE

     C     WCUST         SETLL     SDJACCL2
     C     WCUST         READE     SDJACCL2

     C                   DOW       NOT %EOF(SDJACCL2)
     C                             AND WCUST = JSJANO

     C                   EVAL      Pmember(1) = JSJANO
     C                   EVAL      JCJANO = JSJANO
     C                   EVAL      JCCUST = JSCUST
     C                   EVAL      JCNAHO = JSNAHO
     C                   EXSR      SrMltLvl2

     C                   READ      SDJACCL2
     C                   ENDDO

     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrMltLvl2 - Process multi level joint account                 *
      *                                                               *
      * Called by: SrMltLvl                                           *
      *                                                               *
      * Calls: SrMltJUpdat                                            *
      *                                                               *
      *****************************************************************

     C     SrMltLvl2     BEGSR

     C                   GOTO      FirstProc

     C     CReposition   TAG

     C     KJAC1         SETLL     SDJACCL1
     C     NReposition   TAG
     C                   READ      SDJACCL1

      ** Read another record
     C                   IF        WREAD = 'Y'
     C                   READ      SDJACCL1
     C                   ENDIF
     C                   EVAL      WREAD = ' '

      ** End of End of File, quit
     C                   IF        %EOF(SDJACCL1)
     C                   GOTO      END
     C                   ENDIF

     C                   IF        KJANO = JCJANO

     C     FirstProc     TAG

     C                   EVAL      KJANO = JCJANO
     C                   IF        JCNAHO <> *Blanks

     C     JCNAHO        SETLL     SDCRSNL2
     C     JCNAHO        READE     SDCRSNL2

     C                   DOW       NOT %EOF(SDCRSNL2)
     C                             AND JCNAHO = JRNAHO
     C                   IF        JRREPT = 'Y'

      ** Set array pointer
     C                   EVAL      n = %LOOKUP('      ':Pmember)
     C                   EVAL      n = n - 1
     C                   EVAL      KCTRY = JRCTRY
     C                   EXSR      SrMltJUpdat
     C                   ENDIF

     C     JCNAHO        READE     SDCRSNL2
     C                   ENDDO

     C                   EVAL      KJANO = JCJANO

     C                   GOTO      NReposition
     C                   ENDIF

     C                   IF        JCCUST <> *Blanks

     C                   EVAL      n = %LOOKUP('      ':Pmember)
     C                   EVAL      Pmember(n) = JCCUST

     C     JCCUST        SETLL     SDCRSDL2
     C     JCCUST        READE     SDCRSDL2

     C                   DOW       NOT %EOF(SDCRSDL2)
     C                             AND JCCUST = JQCUST
     C                   IF        JQREPT = 'Y'

      ** Set array pointer
     C                   EVAL      n = %LOOKUP('      ':Pmember)
     C                   EVAL      n = n - 1
     C                   EVAL      KCTRY = JQCTRY
     C                   EXSR      SrMltJUpdat
     C                   ENDIF

     C     JCCUST        READE     SDCRSDL2
     C                   ENDDO

     C                   EVAL      KJANO = JCCUST
     C                   EVAL      KMEMB = *Blanks

     C                   ENDIF

     C                   ELSE
     C                   EVAL      n = %LOOKUP('      ':Pmember)
     C                   IF        n = 2
     C                   GOTO      END
     C                   ENDIF

     C                   EVAL      KJANO = Pmember(n-2)
     C                   EVAL      KMEMB = Pmember(n-1)
     C                   EVAL      Pmember(n-1) = *Blanks
     C                   EVAL      WREAD = 'Y'
     C                   ENDIF

     C                   GOTO      CReposition

     C     END           TAG

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrMltJDelete - Process multi level joint account delete       *
      *                                                               *
      * Called by: SrMltLvl                                           *
      *                                                               *
      * Calls: SrMltJUpdat                                            *
      *                                                               *
      *****************************************************************

     C     SrMltJDelete  BEGSR

     C                   IF        WCUST <> *Blanks

     C     WCUST         SETLL     SDCRSDL2
     C     WCUST         READE     SDCRSDL2

     C                   DOW       NOT %EOF(SDCRSDL2)
     C                             AND WCUST = JQCUST
     C                   IF        JQREPT = 'Y'
     C                   EVAL      N = 1
     C                   EVAL      KCTRY = JQCTRY
     C                   EXSR      SrMltJUpdat
     C                   ENDIF

     C     WCUST         READE     SDCRSDL2
     C                   ENDDO

     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrMltJUpdat - Update all customers involve                    *
      *                                                               *
      * Called by: SrMltLvl2                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrMltJUpdat   BEGSR

     C                   IF        n > 1
     C                   EVAL      n = n - 1
     C                   ENDIF
     C                   EVAL      KCUST = Pmember(n)
     C                   EVAL      DDCUST = KCUST

     C                   DOW       n <> 0

     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       Prtcd
     C                   PARM      '*KEY   '     Poptn
     C                   PARM      KCUST         Pkey1
     C                   PARM                    Pkyst
     C     SDCUSD        PARM      SDCUSD        DSSDY

     C                   CLEAR                   SDCRSH
     C     KCUST         CHAIN     SDCRSHL0

     C     KCRD2         CHAIN     SDCRSDL1
     C                   IF        %FOUND(SDCRSDL1)
     C                   EVAL      WREPT = ' '
     C                   IF        CDREPT = ' '
     C                   EVAL      WREPT = 'Y'
     C                   EVAL      CDREPT = 'Y'
     C                   EVAL      CDREPR = *Blanks
     C                   EVAL      CDREPD = BJRDNB

     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
     C                   MOVE      TimeStamp     WTime
     C     *HMS0         MOVE      WTime         WWTIME
     C                   EVAL      CDREPM = WWTIME
     C                   EVAL      CDREPU = PSUSER
     C                   ENDIF

     C                   EVAL      CDJACM = WIndicia
     C                   UPDATE    SDCRSDD0
     C                   ELSE
     C                   EVAL      CDCUST = Pmember(n)
     C                   EVAL      CDCTRY = KCTRY
     C                   EVAL      WCTRY = CDCTRY
     C                   EVAL      CDREPT = 'Y'
     C                   EVAL      CDREPR = *Blanks
     C                   EVAL      CDREPD = BJRDNB

     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
     C                   MOVE      TimeStamp     WTime
     C     *HMS0         MOVE      WTime         WWTIME
     C                   EVAL      CDREPM = WWTIME

     C                   EVAL      CDREPU = PSUSER
     C                   EVAL      CDEVE1 = *Blanks
     C                   EVAL      CDEVS1 = *Zero
     C                   EVAL      CDEVE2 = *Blanks
     C                   EVAL      CDEVS2 = *Zero
     C                   EVAL      CDEVE3 = *Blanks
     C                   EVAL      CDEVS3 = *Zero
     C                   EVAL      CDEVE4 = *Blanks
     C                   EVAL      CDEVS4 = *Zero
     C                   EVAL      CDEVE5 = *Blanks
     C                   EVAL      CDEVS5 = *Zero
     C                   EVAL      CDTINN = *Blanks
     C                   EVAL      CDEFFD = *Zero
     C                   EVAL      CDEXPD = *Zero
     C                   EVAL      CDCODO = *Blanks
     C                   EVAL      CDJACM = WIndicia
     C                   EVAL      CDMAIL = *Blanks
     C                   EVAL      CDPHON = *Blanks
     C                   EVAL      CDRPAY = *Blanks
     C                   EVAL      CDTINS = *Blanks
     C                   EVAL      CDAUHO = *Blanks
     C                   WRITE     SDCRSDD0
     C                   ENDIF

     C                   EVAL      n = n - 1
     C                   IF        n > 0
     C                   EVAL      KCUST = Pmember(n)
     C                   ENDIF
     C                   ENDDO

     C                   ENDSR

      *****************************************************************
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

     C     *DTAARA       DEFINE                  LDA

     C     *ENTRY        PLIST

     C                   PARM                    PReturn
     C                   PARM                    WCUST
     C                   PARM                    WIndicia

     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSSDY

      ** Database error

     C                   IF        PRetCode <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 001
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBMOD  =  PSProcMod
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C     KCRD2         KLIST
     C                   KFLD                    KCUST
     C                   KFLD                    KCTRY

     C     KJAC1         KLIST
     C                   KFLD                    KJANO
     C                   KFLD                    KMEMB

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

     C     *PSSR         BEGSR

     C                   DUMP

     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'

     C                   CALLB     'DBERRCTL'

     C                   ENDIF

     C                   EVAL      PRetCode = '*ERROR'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR

      *****************************************************************
