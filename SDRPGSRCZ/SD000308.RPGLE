     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2016')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD CRS Indicia Search Tool Enq and Rept')        *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000308 - Midas SD CRS Indicia Search Tool Enq and Rept     *
      *                                                               *
      *  Function:  This module reports all CRS Customer/NAHO with    *
      *             Indicia changes due to the CRS Indicia search tool*
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
      *    70         Information mode                                *
      *    81         Next                                            *
      *    82         Prev                                            *
      *    95         Subfile display                                 *
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
     FSD000308DFCF   E             WORKSTN
     F                                     SFILE(SD000308S0:DDSFRN)

     FSDCRDFL0  IF   E           K DISK    INFSR(*PSSR)

     FSDCRNFL0  IF   E           K DISK    INFSR(*PSSR)

      ** CRS Indicia Search Tool Customer Report
     FSD000308P1O    E             PRINTER INFSR(*PSSR)
     F                                     USROPN
     F                                     INFDS(SPOOL1)

      ** CRS Indicia Search Tool Non-Account Holder Report
     FSD000308P2O    E             PRINTER INFSR(*PSSR)
     F                                     USROPN
     F                                     INFDS(SPOOL2)

      ** CRS Indicia Search Tool Audit Report
     FSD000308AUO    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOLU)
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D*LDA           E DS           256    EXTNAME(LDA)
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
      ** Program Status Data Structure

      ** +-----------------------------------------------------------------+
      ** D specs of the following types should be inserted after the
      ** relevant box.  *** Remove this text afterwrds. ***
      ** +-----------------------------------------------------------------+

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
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **--------------------------------------------------------------------------------------------

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

     DMaxArray         C                   CONST(999)
     DIndiciaCount     C                   CONST(11)

      ** Define maximum number of FATCA Customer Types
      ** If this increases, need to add the new type as an additional
      ** compile time array entry
     DMaxType          C                   CONST(5)

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Run-time Array for Country Codes with FATCA Flag
     DCtryCodeArr      S              2    DIM(MaxArray)

      ** Run-time Array for FATCA Classitfication codes
     DClassArr         S              5A   DIM(MaxArray)

      ** Run-time Array for FATCA Customer Types
     DTypeArr          S              1A   DIM(MaxType)
     D                                     CTDATA

      ** Second DS for Access Programs, Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** External data structure for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** ZSFILE Parameters
     D ZSEQ            S              5
     D ZENTY           S              3
     D ZSERR           S              1
     D ZSNUM           S              6  0

      ** SPOOL Information Data Structure for ZSFILE
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OflLn1               188    189B 0
     D  PrtLn1               367    368B 0

      ** SPOOL Information Data Structure for ZSFILE
     D SPOOL2          DS
     D  SFILE2                83     92
     D  SFNUM2               123    124B 0
     D  OflLn2               188    189B 0
     D  PrtLn2               367    368B 0

      ** SPOOL Information Data Structure for ZSFILE - AU Report
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D @RUN            S              1
     D Index           S              3S 0 INZ(0)

     D WCardF          S              1A
     D WClassCnt       S              4S 0 INZ(0)

      ** Define Array Indices
     D WClassI         S              3S 0
     D WTypeI          S              1S 0

      ** Parameters
     D PReturn         S              7A
     D PTranID         S             10A
     D PSource         S              1A
     D PIndicia        S              1A
     D PMode           S              1A

     D PRetCode        S              7A
     D POption         S             10A
     D TEST            S              1S 0 INZ(0)
     D WTFCCD          S              5A
     D WTFCTP          S              1A
     D WTFCD1          S              5A
     D WTFCD2          S              5A
     D WRqdLin         S              4P 0
     D DDCTYP          S              1A
     D WNNHTY          S              1A
     D X               S              1S 0
     D WTYPE           S              5A
     D WCTYP           S              1A

     D WOpenP1         S              1A   INZ('N')
     D WOpenP2         S              1A   INZ('N')

     D PRTCD           S              7A
     D POPTN           S              7A
     D PCLAS           S              5A
     D PKey1           S             10A
     D PKySt           S              7A

      ** Current Keys
     D KCTYP           S              1A   INZ(' ')
     D KPCTYP          S              1A   INZ(' ')
     D KNTYP           S              1A   INZ(' ')
     D KCNUM           S              6A   INZ(' ')
     D KNAHO           S             10A   INZ(' ')

      *****************************************************************
      /EJECT
      *****************************************************************

     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT

     C                   IF        PMode = 'I'
     C                   EVAL      *IN70 = *ON
     C                   ELSE
     C                   EVAL      *IN70 = *OFF
     C                   ENDIF

     C                   EVAL      RNAHO = 0
     C                   EVAL      RCUST = 0

     C                   EXSR      SRProcReport
     C                   EXSR      SRProcEnquiry

     C                   SETON                                        LR
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRProcEnquiry - Process Enquiry                               *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: SRInitSFL, SrDisplay                                   *
      *                                                               *
      *****************************************************************

     C     SRProcEnquiry BEGSR

     C                   EXSR      SRInitSFL

     C                   EVAL      *IN82 = *OFF
     C                   EVAL      *IN81 = *ON
     C                   IF        %SUBST(WTYPE:2:1) = ' '
     C                   EVAL      *IN81 = *OFF
     C                   ENDIF

     C                   EVAL      X = 1

     C                   DOW       NOT *INKC = *ON
     C                             AND NOT *INKL = *ON

     C                   EVAL      KCTYP = %SUBST(WTYPE:X:1)

     C                   IF        WTYPE = *Blanks
     C                   EVAL      *IN81 = *OFF
     C                   EVAL      *IN82 = *OFF
     C                   ENDIF

     C                   EXSR      SRInitSFL
     C                   EXSR      SrDisplay

      ** If Next has been pressed
     C                   SELECT
     C                   WHEN      *INKH = *ON

     C                   IF        X < 5
     C                   EVAL      X = X + 1
     C                   ENDIF

     C                   IF        X < 5
     C                   EVAL      WCTYP = %SUBST(WTYPE:(X+1):1)
     C                   ENDIF

     C                   IF        WCTYP = ' '
     C                             OR X = 5
     C                   EVAL      *IN81 = *OFF
     C                   EVAL      *IN82 = *ON
     C                   ELSE
     C                   EVAL      *IN81 = *ON
     C                   EVAL      *IN82 = *ON
     C                   ENDIF

     C                   WHEN      *INKG = *ON

     C                   IF        X > 1
     C                   EVAL      X = X - 1
     C                   ENDIF

     C                   IF        X = 1
     C                   EVAL      *IN82 = *OFF
     C                   EVAL      *IN81 = *ON
     C                   ELSE
     C                   EVAL      *IN82 = *ON
     C                   EVAL      *IN81 = *ON
     C                   ENDIF

     C                   WHEN      *INKC
     C                             OR *INKL
     C                   ITER
     C                   ENDSL

     C                   ENDDO

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRLoadNSFile - Load Non Account Holders on the Subfile        *
      *                                                               *
      * Called by: SrDisplay                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRLoadNSFile  BEGSR

     C     KNahoKey1     SETLL     SDCRNFL0
     C                   READ      SDCRNFL0

     C                   DOW       NOT %EOF(SDCRNFL0)

     C                   IF        KCTYP = CGNTYP
     C                   EVAL      #1REFN = CGNAHO
     C                   EVAL      #1RNAM = CGRPTN
     C                   EVAL      #1CTRY = CGCTRY
     C                   EVAL      #1REPT = CGREPT

     C                   IF        CGCRSA = ' '
     C                   MOVE      '-'           #1CRSA
     C                   ELSE
     C                   MOVE      CGCRSA        #1CRSA
     C                   ENDIF

     C                   IF        CGTINI = ' '
     C                   MOVE      '-'           #1TINS
     C                   ELSE
     C                   MOVE      CGTINI        #1TINS
     C                   ENDIF

     C                   IF        CGCODO = ' '
     C                   MOVE      '-'           #1CODO
     C                   ELSE
     C                   MOVE      CGCODO        #1CODO
     C                   ENDIF

     C                   IF        CGJACM = ' '
     C                   MOVE      '-'           #1JACM
     C                   ELSE
     C                   MOVE      CGJACM        #1JACM
     C                   ENDIF

     C                   IF        CGMAIL = ' '
     C                   MOVE      '-'           #1MAIL
     C                   ELSE
     C                   MOVE      CGMAIL        #1MAIL
     C                   ENDIF

     C                   IF        CGPHON = ' '
     C                   MOVE      '-'           #1PHON
     C                   ELSE
     C                   MOVE      CGPHON        #1PHON
     C                   ENDIF

     C                   IF        CGRPAY = ' '
     C                   MOVE      '-'           #1REGP
     C                   ELSE
     C                   MOVE      CGRPAY        #1REGP
     C                   ENDIF

     C                   IF        CGAUHO = ' '
     C                   MOVE      '-'           #1AUHO
     C                   ELSE
     C                   MOVE      CGAUHO        #1AUHO
     C                   ENDIF

     C                   EVAL      DDSFRN = DDSFRN + 1
     C                   WRITE     SD000308S0
     C                   ENDIF

     C                   READ      SDCRNFL0
     C                   ENDDO

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRLoadCSFile - Load Customers on the Subfile                  *
      *                                                               *
      * Called by: SrDisplay                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRLoadCSFile  BEGSR

     C     KCustKey1     SETLL     SDCRDFL0
     C                   READ      SDCRDFL0

     C                   DOW       NOT %EOF(SDCRDFL0)

     C                   IF        KCTYP = CFCTYP
     C                   EVAL      #1REFN = CFCUST
     C                   EVAL      #1RNAM = CFRPTN
     C                   EVAL      #1CTRY = CFCTRY
     C                   EVAL      #1REPT = CFREPT

     C                   IF        CFTINI = ' '
     C                   MOVE      '-'           #1TINS
     C                   ELSE
     C                   MOVE      CFTINI        #1TINS
     C                   ENDIF

     C                   IF        CFCRSA = ' '
     C                   MOVE      '-'           #1CRSA
     C                   ELSE
     C                   MOVE      CFCRSA        #1CRSA
     C                   ENDIF

     C                   IF        CFCODO = ' '
     C                   MOVE      '-'           #1CODO
     C                   ELSE
     C                   MOVE      CFCODO        #1CODO
     C                   ENDIF

     C                   IF        CFJACM = ' '
     C                   MOVE      '-'           #1JACM
     C                   ELSE
     C                   MOVE      CFJACM        #1JACM
     C                   ENDIF

     C                   IF        CFMAIL = ' '
     C                   MOVE      '-'           #1MAIL
     C                   ELSE
     C                   MOVE      CFMAIL        #1MAIL
     C                   ENDIF

     C                   IF        CFPHON = ' '
     C                   MOVE      '-'           #1PHON
     C                   ELSE
     C                   MOVE      CFPHON        #1PHON
     C                   ENDIF

     C                   IF        CFRPAY = ' '
     C                   MOVE      '-'           #1REGP
     C                   ELSE
     C                   MOVE      CFRPAY        #1REGP
     C                   ENDIF

     C                   IF        CFAUHO = ' '
     C                   MOVE      '-'           #1AUHO
     C                   ELSE
     C                   MOVE      CFAUHO        #1AUHO
     C                   ENDIF

     C                   EVAL      DDSFRN = DDSFRN + 1
     C                   WRITE     SD000308S0
     C                   ENDIF

     C                   READ      SDCRDFL0
     C                   ENDDO

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRInitSFL  - Initialise Subfile                               *
      *                                                               *
      * Called by: SRProcEnquiry                                      *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrInitSFL     BEGSR

     C                   Z-ADD     0             DDSFRN
     C                   EVAL      *IN97 = *ON
     C                   WRITE     SD000308C0
     C                   EVAL      *IN97 = *OFF
     C                   EVAL      *IN96 = *OFF

      ** Clear program message queue

     C                   CALL      'ZA0250'

     C                   ENDSR

      *****************************************************************
      *****************************************************************
      *                                                               *
      * SRProcReport - Process Report                                 *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: SRProcCUSD, SRProcNAHO                                 *
      *                                                               *
      *****************************************************************

     C     SRProcReport  BEGSR

     C                   EXSR      SRProcCUSD
     C                   EXSR      SRProcNAHO
     C                   WRITE     CONTROL

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrProcNAHO  - Process Non-Account Holders' Indicia            *
      *                                                               *
      * Called by: SRProcReport                                       *
      *                                                               *
      * Calls: ZSFILE, SrNAHOHead, SrNAHODetl                         *
      *                                                               *
      *****************************************************************

     C     SrProcNAHO    BEGSR

     C     *LOVAL        SETLL     SDCRNFL0
     C                   READ      SDCRNFL0

     C                   DOW       NOT %EOF(SDCRNFL0)

     C                   IF        WOpenP2 = 'N'
     C                   OPEN      SD000308P2
     C                   EVAL      WOpenP2 = 'Y'

     C                   Z-ADD     SFNUM2        ZSNUM

     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       ZSEQ
     C                   PARM      *BLANKS       ZENTY
     C                   PARM                    SFILE2
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR

      ** Error during ZSFILE processing, return to calling program

     C                   IF        ZSERR = 'Y'
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 002
     C                   EVAL      DBFile = 'ZSFILE'
     C                   EVAL      DBKEY = SFILE2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   WRITE     SD308P2R0
     C
     C                   EXSR      SrNAHOHead
     C                   EVAL      WNNHTY = CGNTYP

     C                   ENDIF

      ** If record changed
      ** Print new  set of headers

     C                   IF        CGNTYP <> WNNHTY

     C                   EVAL      WNNHTY = CGNTYP

     C                   EVAL      WRqdLin = 8
     C                   IF        PrtLn2 + WRqdLin >= OflLn2
     C                   WRITE     SD308P2R0
     C                   ENDIF
     C                   EXSR      SrNAHOHead
     C                   ENDIF

      ** Prepare detail data for printing

     C                   EXSR      SrNAHODetl

     C                   EVAL      WRqdLin = 1

      ** Check for overflow
     C                   IF        PrtLn2 + WRqdLin >= OflLn2

     C                   WRITE     SD308P2R0

      ** Change Report Header
     C                   EXSR      SrNAHOHead
     C                   EVAL      WNNHTY = CGNTYP

     C                   ENDIF

      ** Write detail record to SD000308P2

     C                   WRITE     SD308P2R3

      ** Increment count of records for audit

     C                   EVAL      RNAHO = RNAHO + 1
     C                   READ      SDCRNFL0

     C                   ENDDO

     C                   IF        WOpenP2 = 'Y'
     C                   EVAL      WRqdLin = 3

      ** Check for overflow
     C                   IF        PrtLn2 + WRqdLin >= OflLn2
     C                   WRITE     SD308P2R0
     C                   ENDIF

     C                   WRITE     SD308P2R4

     C                   CLOSE     SD000308P2
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrProcCUSD  - Process Non-Account Holders' Indicia            *
      *                                                               *
      * Called by: SRProcReport                                       *
      *                                                               *
      * Calls: ZSFILE, SrCUSDHead, SrCUSDDetl                         *
      *                                                               *
      *****************************************************************

     C     SrProcCUSD    BEGSR

     C     *LOVAL        SETLL     SDCRDFL0
     C                   READ      SDCRDFL0

     C                   DOW       NOT %EOF(SDCRDFL0)

     C                   IF        WOpenP1 = 'N'
     C                   OPEN      SD000308P1
     C                   EVAL      WOpenP1 = 'Y'

     C                   Z-ADD     SFNUM1        ZSNUM

     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       ZSEQ
     C                   PARM      *BLANKS       ZENTY
     C                   PARM                    SFILE1
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR

      ** error during ZSFILE processing, return to calling program

     C                   IF        ZSERR = 'Y'
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 002
     C                   EVAL      DBFile = 'ZSFILE'
     C                   EVAL      DBKEY = SFILE1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   WRITE     SD308P1R0
     C
     C                   EXSR      SrCUSDHead
     C                   EVAL      WNNHTY = CFCTYP

     C                   ENDIF

      ** If record changed
      ** Print new set of headers

     C                   IF        CFCTYP <> WNNHTY

     C                   EVAL      WNNHTY = CFCTYP

     C                   EVAL      WRqdLin = 8
     C                   IF        PrtLn1 + WRqdLin >= OflLn1
     C                   WRITE     SD308P1R0
     C                   ENDIF
     C                   EXSR      SrCUSDHead
     C                   ENDIF

      ** Prepare detail data for printing

     C                   EXSR      SrCUSDDetl

     C                   EVAL      WRqdLin = 1

      ** Check for overflow
     C                   IF        PrtLn1 + WRqdLin >= OflLn1

     C                   WRITE     SD308P1R0

      ** Change Report Header
     C                   EXSR      SrCUSDHead
     C                   EVAL      WNNHTY = CFCTYP

     C                   ENDIF

      ** Write detail record to SD000308P1

     C                   WRITE     SD308P1R3

      ** Increment count of records for audit

     C                   EVAL      RCUST = RCUST + 1
     C                   READ      SDCRDFL0

     C                   ENDDO

     C                   IF        WOpenP1 = 'Y'
     C                   EVAL      WRqdLin = 3

      ** Check for overflow
     C                   IF        PrtLn1 + WRqdLin >= OflLn1
     C                   WRITE     SD308P1R0
     C                   ENDIF

     C                   WRITE     SD308P1R4

     C                   CLOSE     SD000308P1
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrDisplay  - Detail display for CUST/NAHO Reporting           *
      *                                                               *
      * Called by: SRProcEnquiry                                      *
      *                                                               *
      * Calls: SRLoadHead, SRLoadCSFile, SRLoadNSFile                 *
      *                                                               *
      *****************************************************************

     C     SrDisplay     BEGSR

      ** Display
     C                   EXSR      SRLoadHead
     C                   EXSR      SRLoadCSFile
     C                   EXSR      SRLoadNSFile

     C                   EVAL      *IN95 = *OFF
     C                   IF        DDSFRN <> 0
     C                   EVAL      *IN98 = *OFF
     C                   ELSE
     C                   EVAL      *IN96 = *ON
     C                   EVAL      DDSFRN = 1
     C                   EVAL      #1REFN = *Blanks
     C                   EVAL      #1RNAM = *Blanks
     C                   EVAL      #1CTRY = *Blanks
     C                   EVAL      #1REPT = *Blanks
     C                   EVAL      #1TINS = *Blanks
     C                   EVAL      #1CRSA = *Blanks
     C                   EVAL      #1CODO = *Blanks
     C                   EVAL      #1JACM = *Blanks
     C                   EVAL      #1MAIL = *Blanks
     C                   EVAL      #1PHON = *Blanks
     C                   EVAL      #1REGP = *Blanks
     C                   EVAL      #1AUHO = *Blanks
     C                   WRITE     SD000308S0
     C                   EVAL      *IN98 = *ON
     C                   ENDIF

     C                   WRITE     SD000308F1

     C                   IF        DDSFRN <> 0
     C                   EVAL      DDSFRN = 1
     C                   ENDIF

     C                   EXFMT     SD000308C0

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrNAHODetl  - Detail Line for NAHO Reporting                  *
      *                                                               *
      * Called by: SrProcNAHO                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrNAHODetl    BEGSR

     C                   EVAL      RRNAHO = CGNAHO
     C                   EVAL      RNREP  = CGRPTN
     C                   EVAL      RNCTRY = CGCTRY
     C                   EVAL      RNSUBJ = CGREPT
     C                   EVAL      RNCRSA = CGCRSA
     C                   EVAL      RNCDOM = CGCODO
     C                   EVAL      RNJACM = CGJACM
     C                   EVAL      RNMAIL = CGMAIL
     C                   EVAL      RNPHON = CGPHON
     C                   EVAL      RNREGP = CGRPAY
     C                   EVAL      RNTINN = CGTINI
     C                   EVAL      RNAUHO = CGAUHO

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrCUSDDetl  - Detail Line for Customer Reporting              *
      *                                                               *
      * Called by: SrProcCUSD                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrCUSDDetl    BEGSR

     C                   EVAL      RRCUST = CFCUST
     C                   EVAL      RCREP  = CFRPTN
     C                   EVAL      RCCTRY = CFCTRY
     C                   EVAL      RCSUBJ = CFREPT
     C                   EVAL      RCCRSA = CFCRSA
     C                   EVAL      RCCDOM = CFCODO
     C                   EVAL      RCJACM = CFJACM
     C                   EVAL      RCMAIL = CFMAIL
     C                   EVAL      RCPHON = CFPHON
     C                   EVAL      RCREGP = CFRPAY
     C                   EVAL      RCTINN = CFTINI
     C                   EVAL      RCAUHO = CFAUHO

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrNAHOHead  - Header Line for NAHO Reporting                  *
      *                                                               *
      * Called by: SrProcNAHO                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrNAHOHead    BEGSR

     C                   SELECT
     C                   WHEN      CGNTYP = 'F'
     C                   EVAL      RTYPE   = 'Financial Institution'
     C                   WHEN      CGNTYP = 'N'
     C                   EVAL      RTYPE   = 'Non-Financial Entity'
     C                   WHEN      CGNTYP = 'P'
     C                   EVAL      RTYPE   = 'Physical Person'
     C                   WHEN      CGNTYP = 'J'
     C                   EVAL      RTYPE   = 'Joint Account'
     C                   WHEN      CGNTYP = 'O'
     C                   EVAL      RTYPE   = 'Others'
     C                   ENDSL

     C                   WRITE     SD308P2R1

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrCUSDHead  - Header Line for CUST Reporting                  *
      *                                                               *
      * Called by: SrProcCUSD                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrCUSDHead    BEGSR

     C                   SELECT
     C                   WHEN      CFCTYP = 'F'
     C                   EVAL      RTYPE   = 'Financial Institution'
     C                   WHEN      CFCTYP = 'N'
     C                   EVAL      RTYPE   = 'Non-Financial Entity'
     C                   WHEN      CFCTYP = 'P'
     C                   EVAL      RTYPE   = 'Physical Person'
     C                   WHEN      CFCTYP = 'J'
     C                   EVAL      RTYPE   = 'Joint Account'
     C                   WHEN      CFCTYP = 'O'
     C                   EVAL      RTYPE   = 'Others'
     C                   ENDSL

     C                   WRITE     SD308P1R1

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrLoadHead - Load Header details during Enquiry Process       *
      *                                                               *
      * Called by: SRDisplay                                          *
      *                                                               *
      * Calls: SRInitSFL                                              *
      *                                                               *
      *****************************************************************

     C     SrLoadHead    BEGSR

     C                   EXSR      SRInitSFL
     C                   EVAL      DDTYPE = *Blanks

      ** CRS Customer Type

     C                   SELECT
     C                   WHEN      KCTYP = 'F'
     C                   EVAL      DDTYPE  = 'Financial Institution'
     C                   WHEN      KCTYP = 'N'
     C                   EVAL      DDTYPE  = 'Non-Financial Entity'
     C                   WHEN      KCTYP = 'P'
     C                   EVAL      DDTYPE  = 'Physical Person'
     C                   WHEN      KCTYP = 'J'
     C                   EVAL      DDTYPE  = 'Joint Account'
     C                   WHEN      KCTYP = 'O'
     C                   EVAL      DDTYPE  = 'Others'
     C                   ENDSL

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

     C     *ENTRY        PLIST
     C                   PARM                    PMode
     C                   PARM                    WType

     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSSDY

      ** Database error

     C     PRetCode      IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 001
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBKEY = '*FIRST'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      RRRUNA = BJMRDT

     C     KCustKey      KLIST
     C                   KFLD                    KCTYP
     C                   KFLD                    KCNUM

     C     KCustKey1     KLIST
     C                   KFLD                    KCTYP
     C                   KFLD                    KCNUM

     C     KNAHOKey      KLIST
     C                   KFLD                    KNTYP
     C                   KFLD                    KNAHO

     C     KNAHOKey1     KLIST
     C                   KFLD                    KNTYP
     C                   KFLD                    KNAHO

     C                   EVAL      DDWID  = PsJobName
     C                   EVAL      DDPGMQ = PSProcName
     C                   EVAL      DDUSER = PsUser

     C                   ENDSR

      *********************************************************************
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

      ********************************************************************
**CTDATA TYPEARR
F(FFI)
N(NFE)
J(Joint Account)
P(Physical Person)
O(Other)
