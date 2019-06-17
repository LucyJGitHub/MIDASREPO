     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('G-AML Activity Extract Report Program')                *
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      ***SCJ00008*-*G-AML*Activity*Extracted*Report*Program************
      *  XX109009 - G-AML Activity Extracted Report Program           *
      *                                                               *
      *  Function:  This program will create the report showing       *
      *             the activity details extracted for the current    *
      ************  run of SCJ00007.                                  *                       JMI109
      *             run of XX109008.                                  *                       JMI109
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      *  Last Amend No. JMI109             Date 23May18               *
      *  Prev Amend No. JMI026  *CREATE    Date 30Apr08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  JMI109 - G-AML PreProcessor (Upgrade to FB Midas)            *
      *  JMI026 - G-AML PreProcessor                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Midas SD G-AML Activity Details Extract LF
     F*REACEFY0  IF   E           K DISK    INFSR(*PSSR)                                      JMI109
     FXXACEFL0  IF   E           K DISK    INFSR(*PSSR)                                       JMI109
      *
      ** Midas SD Currency codes update
     FSDCURRL0  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Midas Historic Spot Rates By Date
     FSDCUHSL0  IF   E           K DISK    INFSR(*PSSR)
      *
      ** G-AML Activity Details Not Extracted Audit Report
     F*SCJ00008P1O    E             PRINTER INFDS(SPOOL1)                                     JMI109
     FXX109009P1O    E             PRINTER INFDS(SPOOL1)                                      JMI109
     F                                     USROPN
     F                                     INFSR(*PSSR)
     F                                     OFLIND(*IN21)
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+
      *
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA)
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Externally described DS for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** DS for access objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Second DS for Access Programs, Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** File Information Data Structure for GLJ104P1.
     D SPOOL1          DS
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0
      *
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  ErrorOnFl             35     35
     D  EndOfFile             45     45
      *
      ** Currency & Spot Trade Array
     D                 DS
     D CcySprt                       16    dim(4)
     D  DCcy                          3    overlay(CcySprt:*Next)
     D  DSprt                        13  8 overlay(CcySprt:*Next)
      *
      ** Data passed as entry parameter
     D WDATA           DS           100
     D  WRERUN                 1      1
     D  WFDATE                 2      6
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Named constants             ¦
      ** ¦ =======  ===============             ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+
      *
      ** Parameters for ZSFILE
     D PSeq            S              5
     D SEnty           S              3
     D ZSnum           S              6  0
     D ZSnumU          S              6  0
     D ZSerr           S              1
      *
      ** Other fields used
     D WRun            S              1    INZ(' ')
     D WFirst          S              1    INZ('Y')
     D WEnd            S              1    INZ(' ')
     D RqdLn1          S              3  0
     D DifLn1          S              3  0
     D Ctr             S              6  0 Inz(1)
     D CCtr            S              6
     D RecCtr          S              1  0 Inz(0)
     D #BAMT1          S             16
     D #BAMT2          S             16
     D #FXAM1          S             16
     D #FXAM2          S             16
     D BankDec#        S              1  0
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
     C******LOVAL        SETLL     REACEFY0                                                   JMI109
     C*****              READ      REACEFY0                                                   JMI109
     C     *LOVAL        SETLL     XXACEFL0                                                   JMI109
     C                   READ      XXACEFL0                                                   JMI109
     C*****              OPEN      SCJ00008P1                                                 JMI109
     C                   OPEN      XX109009P1                                                 JMI109
      *
     C*****              DOW       not %eof(REACEFY0)                                         JMI109
     C                   DOW       not %eof(XXACEFL0)                                         JMI109
      *
      ** Process Report Lines.
     C                   EXSR      SRPrint
      *
      ** Read next record.
     C*****              READ      REACEFY0                                                   JMI109
     C                   READ      XXACEFL0                                                   JMI109
      *
     C                   ENDDO
      *
      ** Write Total Extracted at end of file
     C                   EVAL      WEnd = 'Y'
     C                   EXSR      SRPrint
     C                   EXSR      SRRates
      *
     C*****              CLOSE     SCJ00008P1                                                 JMI109
     C                   CLOSE     XX109009P1                                                 JMI109

     C                   EXSR      SREnd
      *
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrint - Print details of extracted activity                *
      *                                                               *
      *****************************************************************

     C     SRPrint       BEGSR

      ** Ensure Detail Spool File recorded by RCF.
      *
     C                   EVAL      ZSnum = SFNUM1
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *Blanks       SEnty
     C                   PARM                    SFILE1
     C                   PARM                    ZSnum
     C                   PARM      *Blank        ZSerr
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
      *
     C     ZSERR         IFEQ      'Y'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        WFirst = 'Y'
     C                   WRITE     HEADP1
     C                   EVAL      WFirst = 'N'
     C                   ENDIF
      *
      ** If EOF, write Totals
      *
     C                   IF        WEnd = 'Y'
      *
     C                   IF        *IN21 = *On
     C                   WRITE     HEADP1
     C                   EVAL      *IN21 = *Off
     C                   ENDIF
      *
      ** Write Total Activity Details extracted
      *
     C                   WRITE     TRAIL1
      *
     C                   LeaveSr
     C                   ENDIF
      *
      ** Write details to printer fields.
     C                   CLEAR                   DETAIL1
      *
     C                   EVAL      CCtr  = %Char(Ctr) + '.'
     C                   MOVEL     CCtr          RNUM
     C                   MOVEL     GTYPE         RTYPE
     C                   EVAL      RCNUM = GCNUM
     C                   EVAL      RACNO = GACNO
     C                   EVAL      RCASH = GCASH
      *
      * Format Base Amount
      ***Since*REACEFPP*are*already*formatted*with*the*correct*amount,                        JMI109
      ** Since XXACEFPD are already formatted with the correct amount,                        JMI109
      ** whatever the equivalent # of decimal of its base CCY (BJCYCD), get
      ***the*equivalent*value*from*REACEFPP                                                   JMI109
      ** the equivalent value from XXACEFPD                                                   JMI109
      ** (e.g. GFXAM = 999999.00, A6NBDP = 0, move only the value of 999999)
     C                   SELECT
     C                   WHEN      BankDec# = 0
     C                   MOVEL     GBAMT         #GBAMT           18
     C                   MOVEL     #GBAMT        #BAMT0           15
     C                   MOVE      #BAMT0        ##BAMT0          16 0
     C                   MOVE      ##BAMT0       ZFIELD           16
     C                   MOVE      BankDec#      ZDECS             1 0
     C                   CALL      'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZDECS
     C                   MOVE      ZFIELD        RBAMT
      *
     C                   WHEN      BankDec# = 1
     C                   MOVEL     GBAMT         #GBAMT
     C                   MOVEL     #GBAMT        #NUM             15
     C                   MOVE      #GBAMT        #DEC3             3
     C                   MOVEL     #DEC3         #DEC1             1
     C                   EVAL      #BAMT1 = #NUM + #DEC1
     C                   MOVE      #BAMT1        ##BAMT1          16 0
     C
     C                   MOVE      ##BAMT1       ZFIELD
     C                   MOVE      BankDec#      ZDECS
     C                   CALL      'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZDECS
     C                   MOVE      ZFIELD        RBAMT
      *
     C                   WHEN      BankDec# = 2
     C                   MOVEL     GBAMT         #GBAMT
     C                   MOVEL     #GBAMT        #NUM             15
     C                   MOVE      #GBAMT        #DEC3             3
     C                   MOVEL     #DEC3         #DEC2             2
     C                   EVAL      #BAMT2 = #NUM + #DEC1
     C                   MOVE      #BAMT2        ##BAMT2          16 0
     C
     C                   MOVE      ##BAMT2       ZFIELD
     C                   MOVE      BankDec#      ZDECS
     C                   CALL      'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZDECS
     C                   MOVE      ZFIELD        RBAMT
      *
     C                   WHEN      BankDec# = 3
     C                   MOVE      GBAMT         #BAMT3           13
     C                   MOVE      #BAMT3        ##BAMT3          16 0
     C
     C                   MOVE      ##BAMT3       ZFIELD
     C                   MOVE      BankDec#      ZDECS
     C                   CALL      'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZDECS
     C                   MOVE      ZFIELD        RBAMT
     C                   ENDSL
      *
     C                   MOVE      GRCPY         RRCPY
     C                   EVAL      RCURR = GCURR
      *
      * Format Fix Amount
      ** Retrieve number of decimal places
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @Rtcd             7
     C                   PARM      '*KEY   '     @Optn             7
     C                   PARM      GCURR         PCCY              3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   IF        @Rtcd <> ' '
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = GCURR
     C                   EVAL      DBFile = 'SDCURRPD'
     C                   EVAL      DBase = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ***Since*REACEFPP*are*already*formatted*with*the*correct*amount,                        JMI109
      ** Since XXACEFPD are already formatted with the correct amount,                        JMI109
      ** whatever the equivalent # of decimal of its CCY, get
      ***the*equivalent*value*from*REACEFPP                                                   JMI109
      ** the equivalent value from XXACEFPD                                                   JMI109
      ** (e.g. GFXAM = 999999.00, A6NBDP = 0, move only the value of 999999)
     C                   SELECT
     C                   WHEN      A6NBDP = 0
     C                   MOVEL     GFXAM         #GFXAM           18
     C                   MOVEL     #GFXAM        #FXAM0           15
     C                   MOVE      #FXAM0        ##FXAM0          16 0
     C                   MOVE      ##FXAM0       ZFIELD
     C                   MOVE      A6NBDP        ZDECS
     C                   CALL      'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZDECS
     C                   MOVE      ZFIELD        RFXAM
      *
     C                   WHEN      A6NBDP = 1
     C                   MOVEL     GFXAM         #GFXAM
     C                   MOVEL     #GFXAM        #NUM             15
     C                   MOVE      #GFXAM        #DEC3             3
     C                   MOVEL     #DEC3         #DEC1             1
     C                   EVAL      #FXAM1 = #NUM + #DEC1
     C                   MOVE      #FXAM1        ##FXAM1          16 0
     C
     C                   MOVE      ##FXAM1       ZFIELD
     C                   MOVE      A6NBDP        ZDECS
     C                   CALL      'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZDECS
     C                   MOVE      ZFIELD        RFXAM
      *
     C                   WHEN      A6NBDP = 2
     C                   MOVEL     GFXAM         #GFXAM
     C                   MOVEL     #GFXAM        #NUM             15
     C                   MOVE      #GFXAM        #DEC3             3
     C                   MOVEL     #DEC3         #DEC2             2
     C                   EVAL      #FXAM2 = #NUM + #DEC1
     C                   MOVE      #FXAM2        ##FXAM2          16 0
     C
     C                   MOVE      ##FXAM2       ZFIELD
     C                   MOVE      A6NBDP        ZDECS
     C                   CALL      'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZDECS
     C                   MOVE      ZFIELD        RFXAM
      *
     C                   WHEN      A6NBDP = 3
     C                   MOVE      GFXAM         #FXAM3           13
     C                   MOVE      #FXAM3        ##FXAM3          16 0
     C
     C                   MOVE      ##FXAM3       ZFIELD
     C                   MOVE      A6NBDP        ZDECS
     C                   CALL      'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZDECS
     C                   MOVE      ZFIELD        RFXAM
     C                   ENDSL
      *
     C                   EVAL      RVDAT = GVDAT
     C                   EVAL      RBDAT = GBDAT
     C                   EVAL      RREF  = GREF

      ** Write Detail
     C                   IF        *IN21 = *On
     C                   WRITE     HEADP1
     C                   EVAL      *IN21 = *Off
     C                   ENDIF

     C                   WRITE     DETAIL1

      ** Add to Totals
     C                   ADD       1             Ctr
     C                   ADD       1             RTNPOS

     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRates - Extract currency code and spot rate                *
      *                                                               *
      *****************************************************************

     C     SRRates       BEGSR
      *
     C                   EVAL      *IN21 = *On
     C                   WRITE     HEADP2
     C                   EVAL      *IN21 = *Off
      *
     C                   IF        WDATE = 0
     C     *LOVAL        SETLL     SDCURRL0
     C                   READ      SDCURRL0
      *
     C                   EVAL      RecCtr = 1
     C                   DOW       not %eof(SDCURRL0)
      *
     C                   SELECT
     C                   WHEN      RecCtr = 1
     C                   EVAL      DCcy(1)  = A6CYCD
     C                   EVAL      DSprt(1) = A6SPRT
     C                   EVAL      RecCtr = RecCtr + 1
     C                   WHEN      RecCtr = 2
     C                   EVAL      DCcy(2)  = A6CYCD
     C                   EVAL      DSprt(2) = A6SPRT
     C                   EVAL      RecCtr = RecCtr + 1
     C                   WHEN      RecCtr = 3
     C                   EVAL      DCcy(3)  = A6CYCD
     C                   EVAL      DSprt(3) = A6SPRT
     C                   EVAL      RecCtr = RecCtr + 1
     C                   WHEN      RecCtr = 4
     C                   EVAL      DCcy(4)  = A6CYCD
     C                   EVAL      DSprt(4) = A6SPRT
     C                   EVAL      RecCtr = RecCtr + 1
     C                   ENDSL
      *
     C                   IF        RecCtr > 4
      ** Process Report Lines for every four records read
     C                   EXSR      SRPrint2
     C                   EVAL      RecCtr = 1
     C                   CLEAR                   CcySprt
     C                   ENDIF
      *
      ** Read next record.
     C                   READ      SDCURRL0
      *
     C                   ENDDO
      *
      ** Check if there are still records read
     C                   IF        DCcy(3) <> ' '
     C                   EXSR      SRPrint2
     C                   ELSE
      *
     C                   IF        DCcy(2) <> ' '
     C                   EXSR      SRPrint2
     C                   ELSE
      *
     C                   IF        DCcy(1) <> ' '
     C                   EXSR      SRPrint2
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   IF        *IN21 = *On
     C                   WRITE     HEADP2
     C                   EVAL      *IN21 = *Off
     C                   ENDIF
      *
     C                   WRITE     TRAIL2
      *
     C                   ELSE
     C     WDATE         SETLL     SDCUHSL0
     C     WDATE         READE     SDCUHSL0
      *
     C                   EVAL      RecCtr = 1
     C                   DOW       not %eof(SDCUHSL0)
      *
     C                   SELECT
     C                   WHEN      RecCtr = 1
     C                   EVAL      DCcy(1)  = G2CYCD
     C                   EVAL      DSprt(1) = G2SPRT
     C                   EVAL      RecCtr = RecCtr + 1
     C                   WHEN      RecCtr = 2
     C                   EVAL      DCcy(2)  = G2CYCD
     C                   EVAL      DSprt(2) = G2SPRT
     C                   EVAL      RecCtr = RecCtr + 1
     C                   WHEN      RecCtr = 3
     C                   EVAL      DCcy(3)  = G2CYCD
     C                   EVAL      DSprt(3) = G2SPRT
     C                   EVAL      RecCtr = RecCtr + 1
     C                   WHEN      RecCtr = 4
     C                   EVAL      DCcy(4)  = G2CYCD
     C                   EVAL      DSprt(4) = G2SPRT
     C                   EVAL      RecCtr = RecCtr + 1
     C                   ENDSL
      *
     C                   IF        RecCtr > 4
      ** Process Report Lines for every four records read
     C                   EXSR      SRPrint2
     C                   EVAL      RecCtr = 1
     C                   CLEAR                   CcySprt
     C                   ENDIF
      *
      ** Read next record.
     C     WDATE         READE     SDCUHSL0
      *
     C                   ENDDO
      *
      ** Check if there are still records read
     C                   IF        DCcy(3) <> ' '
     C                   EXSR      SRPrint2
     C                   ELSE
      *
     C                   IF        DCcy(2) <> ' '
     C                   EXSR      SRPrint2
     C                   ELSE
      *
     C                   IF        DCcy(1) <> ' '
     C                   EXSR      SRPrint2
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   IF        *IN21 = *On
     C                   WRITE     HEADP2
     C                   EVAL      *IN21 = *Off
     C                   ENDIF
      *
     C                   WRITE     TRAIL2
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrint2 - Print details of currency and spot rate           *
      *                                                               *
      *****************************************************************

     C     SRPrint2      BEGSR
      *
      ** Write details to printer fields.
     C                   CLEAR                   DETAIL2
     C                   EVAL      *IN30 = *Off
     C                   EVAL      *IN31 = *Off
     C                   EVAL      *IN32 = *Off
     C                   EVAL      *IN33 = *Off
      *
     C                   IF        DCcy(1) <> ' '
     C                   EVAL      RCCY1 = DCcy(1) + ' ='
     C                   MOVE      DSprt(1)      RRATE1
     C                   EVAL      *IN30 = *On
     C                   ENDIF
     C                   IF        DCcy(2) <> ' '
     C                   EVAL      RCCY2 = DCcy(2) + ' ='
     C                   MOVE      DSprt(2)      RRATE2
     C                   EVAL      *IN31 = *On
     C                   ENDIF
     C                   IF        DCcy(3) <> ' '
     C                   EVAL      RCCY3 = DCcy(3) + ' ='
     C                   MOVE      DSprt(3)      RRATE3
     C                   EVAL      *IN32 = *On
     C                   ENDIF
     C                   IF        DCcy(4) <> ' '
     C                   EVAL      RCCY4 = DCcy(4) + ' ='
     C                   MOVE      DSprt(4)      RRATE4
     C                   EVAL      *IN33 = *On
     C                   ENDIF

      ** Write Detail
     C                   IF        *IN21 = *On
     C                   WRITE     HEADP2
     C                   EVAL      *IN21 = *Off
     C                   ENDIF

     C                   WRITE     DETAIL2
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREnd - Write trailer in report                              *
      *                                                               *
      *****************************************************************

     C     SREnd         BEGSR
      *
      ** End Program
     C                   EVAL      *INLR ='1'
     C                   RETURN

     C                   ENDSR
      *
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
      *
     C     *ENTRY        PLIST
     C                   PARM                    PRtcd             7
     C                   PARM                    PSeq              5
     C                   PARM                    PData           100
      *
     C     *DTAARA       DEFINE                  LDA
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*FIRST '     POptn             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error.
      *
     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Retrieve number of decimal places for the bank's currency code
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @Rtcd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM      BJCYCD        PCCY              3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   IF        @Rtcd <> ' '
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = BJCYCD
     C                   EVAL      DBFile = 'SDCURRPD'
     C                   EVAL      DBase = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      BankDec# = A6NBDP
      *
      ** Report Work fields.
      *
     C                   EVAL      RqdLn1 = 0
     C                   EVAL      DifLn1 = 0
     C                   EVAL      PRTLN1 = 0
     C                   EVAL      PSeq = ' '
     C                   EVAL      WDATA = PData
     C                   MOVEL     WFDATE        WDATE             5 0
      *
     C                   ENDSR
      *
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

     C                   IF        WRun = *Blank
     C                   EVAL      WRun = 'Y'
     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On
     C                   EVAL      PRtcd = '*ERROR'
     C                   DUMP
     C                   ENDIF
      *
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2008
