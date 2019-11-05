     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGSQLMOD                                                    *
/*EXI *  TEXT('Midas SD Customer Tax Status Upd on Cert Expiry')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000818 - Customer Tax Status Upd on Certificate Expiry     *
      *                                                               *
      *  Function:  This daily program will run in I/C Initiation     *
      *             phase of COB.                                     *
      *             This program will change the customer tax status  *
      *             when exemption certifcate expiry date is          *
      *             less than current run date.                       *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER069C01          Date 07Nov14               *
      *                 CER069  *CREATE    Date 03Jul14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER069C01 - Retain Certificate of Exemption Details          *
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

      ** SD Customer Details by Country of Tax - Input
     FSDACTXL9  UF   E           K DISK    INFSR(*PSSR)

      ** Customer Tax Status Upd Printer File - Details
     FSD000818P1O    E             PRINTER INFDS(SPOOL1)
     F                                     USROPN
     F                                     INFSR(*PSSR)

      ** Customer Tax Status Upd Printer File - Audit
     FSD000818AUO    E             PRINTER INFDS(SPOOLU)
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

      **  Short DS for access programs
     D DSFDY         E DS                  Extname(DSFDY)
      *
      ** Long DS for access programs
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** DS for access objects - short data structure
     D DSLDY         E DS                  EXTNAME(DSLDY)

      ** File Information Data Structure for SD000818P1
     D SPOOL1          DS
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0

      ** File Information Data Structure for SD000818AU
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
     D PDecimals       S              1  0
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

     C     *Loval        SETLL     SDACTXL9

     C                   READ      SDACTXL9

      ** Read Customer Details by Country of Tax until end of file

     C                   DOW       Not %EOF(SDACTXL9)

      ** Change the Customer Tax Status if
      **   Certificate Expiry Date < Current Run Day

     C                   IF        AXCEEX < WCurr_RunDay
     C                   EXSR      SRChgSts
     C                   ENDIF

     C                   READ      SDACTXL9

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
      *  SRChgSts - Change Customer Status Routine                    *
      *                                                               *
      *****************************************************************
     C     SRChgSts      BEGSR

      ** Access Customer Details to ensure valid customer
     C                   MOVEL     AXCUST        PKey1
     C                   CALL      'AOCUSTR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PKey1
     C                   PARM                    PKySt
     C     SDCUST        PARM      SDCUST        DSSDY

     C                   IF        PRtcd = *Blanks
      *
      ** Access Additional Customer details to obtain Exemption Threshold
      ** details
     C                   CALL      'AOACUSR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      AXCUST        PCusn
     C     SDACUS        PARM      SDACUS        DSLDY
      *
     C                   IF        PRtcd = *Blanks
      *
      ** If Exemption Threshold Value date defined set Tax Status = 'T'
      ** otherwise set to 'Y'
     C                   IF        E5EVDT <> 0
     C                   EVAL      AXETXS = 'T'
     C                   ELSE
     C                   EVAL      AXETXS = 'Y'
     C                   ENDIF
      *
      ** Output details on report
     C                   EXSR      SRPrint1
      *
      ***Blank*out*Certificate*Details                                                     CER069C01
     C**********         Z-ADD     0             AXCEEX                                    CER069C01
     C**********         Z-ADD     0             AXCADT                                    CER069C01
     C**********         Z-ADD     0             AXCVDT                                    CER069C01
     C**********         EVAL      AXCERF = *BLANKS                                        CER069C01
     C**********         EVAL      AXCRTP = *BLANKS                                        CER069C01
     C                   UPDATE    SDACTXD0

     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrint1 - Change Customer Status Routine                    *
      *                                                               *
      *****************************************************************
     C     SRPrint1      BEGSR

     C                   IF        WOpen <> 'Y'
     C                   EVAL      WOpen = 'Y'
     C                   OPEN      SD000818P1

      ** Ensure Detail Spool File recorded by RCF.

     C                   EVAL      ZSnum = SFNUM1

     C                   CALL      'ZSFILE2'
     C                   PARM                    PSeq
     C                   PARM      'SD000818 '   PRName
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

     C                   EVAL      RqdLn1 = 2
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
     C                   EVAL      RCUST = BBCUST

      ** Customer Report Name
     C                   EVAL      RCRNM = BBCRNM

      ** Customer Town
     C                   EVAL      RCRTN = BBCRTN

      ** Country of Location
     C                   EVAL      RCOLC = BBCOLC

      ** Exemption Threshold
     C                   MOVE      E5EXTH        PField
     C                   CALLB     'ZEDIT'
     C                   PARM                    PField
     C                   PARM      0             PDecimals
     C                   EVAL      REXTH = %Trim(PField)

      ** Exemption Threshold Value Date
     C                   EVAL      ZDAYNO = E5EVDT
     C                   EXSR      SRZDate2
     C                   EVAL      REVDT = %Trim(ZADATE)

      ** Certificate Type
     C                   EVAL      RCRTP = AXCRTP

      ** Certificate Reference
     C                   EVAL      RCERF = AXCERF
      *
      ** Certificate Value Date
     C                   EVAL      ZDAYNO = AXCVDT
     C                   EXSR      SRZDate2
     C                   EVAL      RCVDT = %Trim(ZADATE)
      *
      ** Certificate Expiry Date
     C                   EVAL      ZDAYNO = AXCEEX
     C                   EXSR      SRZDate2
     C                   EVAL      RCEEX = %Trim(ZADATE)
      *
      ** European Tax Status
     C                   EVAL      RETXS = AXETXS
     C                   WRITE     DETAIL
      *
     C                   EVAL      WNoRec = WNoRec + 1

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

     C                   OPEN      SD000818AU

      ** Ensure Audit Spool File recorded by RCF.

     C                   EVAL      ZSnumU = SFNUMU

     C                   CALL      'ZSFILE2'
     C                   PARM                    PSeq
     C                   PARM      'SD000818 '   PRName
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

     C                   ENDIF

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
     C                   EVAL      DBPgm  = 'SD000818 '

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
