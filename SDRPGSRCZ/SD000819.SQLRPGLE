     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGSQLMOD                                                    *
/*EXI *  TEXT('Midas SD Tax Deducted for Customer Defined Non-Tax')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000819  - Midas SD Tax Deducted for Customers Defined as   *
      *              Non-Taxable                                      *
      *                                                               *
      *  Function:  This daily program will run in COB                *
      *             This program will list customers who have had     *
      *             tax deducted on account or deposit interest       *
      *             payments despite being defined as Non-Taxable     *
      *             (This is due to expiry date of certificate being  *
      *             earlier than Interest payment date)               *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER069  *CREATE    Date 03Jul14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER069 - German Tax Enhancement                              *
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
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** SD Tax Deducted for Cust Defined Non-Tax - Input
     FSDTSCHPD  IF   E           K DISK    INFSR(*PSSR)

      ** Tax Deducted for Cust Defined Non-Tax - Detail
     FSD000819P1O    E             PRINTER INFDS(SPOOL1)
     F                                     USROPN
     F                                     INFSR(*PSSR)

      ** Tax Deducted for Cust Defined Non-Tax - Audit
     FSD000819AUO    E             PRINTER INFDS(SPOOLU)
     F                                     USROPN
     F                                     INFSR(*PSSR)

      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+
      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA)
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc

      ** External DS for Bank Details
     D SDBANK        E DS                  Extname(SDBANKPD)

      ** External DS for Additional Customer Details
     D SDACUS        E DS                  Extname(SDACUSPD)

      ** External DS for Customer Details
     D SDCUST        E DS                  Extname(SDCUSTPD)

      ** Standing data - Currencies
     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      **  Short DS for access programs
     D DSFDY         E DS                  Extname(DSFDY)
      *
      ** Long DS for access programs
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** DS for access objects - short data structure
     D DSLDY         E DS                  EXTNAME(DSLDY)

      ** File Information Data Structure for SD000819P1
     D SPOOL1          DS
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0

      ** File Information Data Structure for SD000819AU
     D SPOOLU          DS
     D   SFILEU               83     92
     D   SFNUMU              123    124B 0

      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+

      ** Parameters for access object programs
     D PRtCd           S              7A
     D POptn           S              7A
     D PKey1           S             10A
     D PKySt           S              7A
     D PCusn           S              6A
     D PField          S             16A
     D PField15        S             15  0 Inz
     D PDecimals       S              1  0
     D PCode           S              1A
     D POut21          S             21A   Inz
     D PRName          S             10
     D PSeq            S              5
     D ZDAYNO          S              5  0
     D ZDATE           S              6  0
     D ZADATE          S              7
      ** Other fields used
     D WRun            S              1    Inz
     D WCurr_RunDay    S              5  0 Inz
     D FirstRec        S              1    Inz
     D WDayNo          S              5  0 Inz
     D WCcy            S              3    Inz
     D WLoc            S              3    Inz
     D WDays           S              2  0 Inz
     D WFlag           S              1
     D PKeySt          S              7A
     D PCust           S             10A
     D WOpen           S              1    INZ('N')
     D WFirst          S              1    INZ('Y')
     D WNoRec          S              7  0
     D RqdLn1          S              3  0
     D DifLn1          S              4  0
     D SEnty           S              3
     D ZSnum           S              6  0
     D ZSnumU          S              6  0
     D ZSerr           S              1
     D NET_INT         S             15  0 INZ(*Zeros)


      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *InzSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

      ** Set file pointer to first record and do initial read.

     C     *Loval        SETLL     SDTSCHPD

     C                   READ      SDTSCHPD

      ** Read Details until end of file

     C                   DOW       Not %EOF(SDTSCHPD)

     C                   EXSR      SRPrint1

     C                   READ      SDTSCHPD

     C                   ENDDO

     C                   IF        WNoRec > 0
     C                   EVAL      RqdLn1 = 4
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF

      ** Write out report trailer.
     C                   WRITE     TRAILP1
     C                   ENDIF

     C                   EXSR      SRAudit
      *
     C                   EVAL      *InLR = *On
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrint1 - Print Details                                     *
      *                                                               *
      *****************************************************************
     C     SRPrint1      BEGSR

      ** Output details on report
     C                   IF        WOpen <> 'Y'
     C                   EVAL      WOpen = 'Y'
     C                   OPEN      SD000819P1

      ** Ensure Detail Spool File recorded by RCF.

     C                   EVAL      ZSnum = SFNUM1

     C                   CALL      'ZSFILE2'
     C                   PARM                    PSeq
     C                   PARM      'SD000819'    PRName
     C                   PARM      *Blanks       SEnty
     C                   PARM                    SFILE1
     C                   PARM                    ZSnum
     C                   PARM      *Blank        ZSerr

      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.

     C                   IF        ZSERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF

     C                   ENDIF

     C                   EVAL      RqdLn1 = 3
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1

      ** For initial print of details or overflow has occured, print the Header
      ** of the report.

     C                   IF        DifLn1 <= RqdLn1 OR
     C                             WFirst = 'Y'
     C                   WRITE     HEADP1
     C                   EVAL      WFIRST = 'N'
     C                   ENDIF

      ** Write Details to Print fields

      ** Customer Number
     C                   EVAL      RCUST = TRCUST

      ** Customer Report Name
     C                   EVAL      RCRNM = TRCRNM

      ** Customer Town
     C                   EVAL      RCRTN = TRCRTN

      ** Country of Location
     C                   EVAL      RCOLC = TRCOLC

      ** Certificate Value Date
     C                   EVAL      ZDAYNO = TRCVDT
     C                   EXSR      SRZDate2
     C                   EVAL      RCVDT = ZADATE
      *
      ** Certificate Expiry Date
     C                   EVAL      ZDAYNO = TRCEEX
     C                   EXSR      SRZDate2
     C                   EVAL      RCEEX = ZADATE
      *
      ** European Tax Status
     C                   EVAL      RETXS = TRETXS
      *
      ** Deposit / Account Ref
     C                   EVAL      RDREF = TRDREF
      *
      ** Interest Due Date
     C                   EVAL      ZDAYNO = TRDDAT
     C                   EXSR      SRZDate2
     C                   EVAL      RDDAT = ZADATE
      *
      ** Currency
     C                   EVAL      RCCY = TRCCY

     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    TRCCY
     C     SDCURR        PARM      SDCURR        DSSDY

     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 002
     C                   EVAL      DBKEY = TRCCY
     C                   ENDIF
      *
      ** Gross Interest
     C                   EVAL      PField15 = TRGINT
     C                   CALLB     'ZSEDIT'
     C                   PARM                    PField15
     C                   PARM      A6NBDP        PDecimals
     C                   PARM      'J'           PCode
     C                   PARM      *Blanks       POut21
     C                   EVAL      RGINT = %Trim(POut21)
      *
      ** Total Tax
     C                   EVAL      PField15 = TRTTAX
     C                   CALLB     'ZSEDIT'
     C                   PARM                    PField15
     C                   PARM      A6NBDP        PDecimals
     C                   PARM      'J'           PCode
     C                   PARM      *Blanks       POut21
     C                   EVAL      RTTAX = %Trim(POut21)
      *
      ** Net Interest
     C                   EVAL      NET_INT = TRGINT - TRTTAX
     C                   EVAL      PField15 = NET_INT
     C                   CALLB     'ZSEDIT'
     C                   PARM                    PField15
     C                   PARM      A6NBDP        PDecimals
     C                   PARM      'J'           PCode
     C                   PARM      *Blanks       POut21
     C                   EVAL      RNINT = %Trim(POut21)
      *
     C                   WRITE     DETAIL
      *
     C                   EVAL      WNoRec = WNoRec + 1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRZDate2 - Format a date for output                           *
      *                                                               *
      *****************************************************************
     C     SRZDate2      BEGSR

     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit - Write audit report                                 *
      *                                                               *
      *****************************************************************
     C     SRAudit       BEGSR

     C                   OPEN      SD000819AU

      ** Ensure Audit Spool File recorded by RCF.

     C                   EVAL      ZSnumU = SFNUMU

     C                   CALL      'ZSFILE2'
     C                   PARM                    PSeq
     C                   PARM      'SD000819'    PRName
     C                   PARM      *Blanks       SEnty
     C                   PARM                    SFILEU
     C                   PARM                    ZSnumU
     C                   PARM      *Blank        ZSerr

      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.

     C                   IF        ZSERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF

     C                   WRITE     HEADAU

      ** If there is a DB Error, Output the DB Error Information.

     C                   IF        *INU7 = *ON
     C                   WRITE     DBERROR
     C                   WRITE     FOOTER
     C                   ELSE
      *
     C                   IF        WNoRec > 0
     C                   EVAL      RECNUM = WNoRec
     C                   WRITE     SUMMRY
     C                   WRITE     FOOTER
     C                   ELSE
     C                   WRITE     NODTLS
     C                   WRITE     FOOTER
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *InzSr - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
     C     *InzSr        BEGSR

     C     *DTAARA       DEFINE                  LDA

      ** Initialize variables

     C                   EVAL      WCurr_RunDay = 0
     C                   EVAL      FirstRec = 'Y'

      ** Access Bank details

     C                   CALL      'AOBANKR0'
     C                   PARM      *Blanks       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY

     C                   IF        PRtCd <> *Blanks
     C     *Lock         IN        LDA
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WCurr_RunDay = BJRDNB
     C                   ENDIF

     C                   EVAL      RqdLn1 = 0
     C                   EVAL      DifLn1 = 0
     C                   EVAL      PrtLn1 = 0

      ** Database fields

     C                   EVAL      DBKey  = *Blanks
     C                   EVAL      DBFile = *Blanks
     C                   EVAL      DBase  = *Zeros
     C                   EVAL      DBPgm  = 'SD000819'

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *  Called by:                                                   *
      *                                                               *
      *  Calls:          None                                         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   IF        WRun = *Blanks
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   EXSR      SRAudit
     C                   ENDIF

     C                   EVAL      *InU7 = *On
     C                   EVAL      *InU8 = *On
     C                   EVAL      *InLR = *On

     C                   RETURN

     C                   ENDSR
