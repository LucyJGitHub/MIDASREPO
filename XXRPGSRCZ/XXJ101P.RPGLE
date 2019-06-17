     H DEBUG
     H COPYRIGHT('(c) Finsatra International Limited 2018')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Pooling Accounts List')                       *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      ***SDJ101P*-*Midas*SD Account Pooling List***********************         JMI108
      *  XXJ101P - Midas SD Account Pooling List                      *         JMI108
      *                                                               *
      *  Function:  This program reports the Account Pooling details  *
      *             by Last Amend Date, Last Amend Time and Account   *
      *                                                               *
      ***(c)*Misys*International*Banking*Systems*Ltd.*2007*************         JMI108
      *  (c) Finastra International Limited 2018                      *         JMI108
      *                                                               *
      *  Last Amend No. JMI108             Date 31May18               *
      *  Prev Amend No. TFJ011  *CREATE    Date 23Jan07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  JMI108 - Account Balance Pooling. Upgrade to FBM 2.1         *
      *  TFJ011 - Account Balance Pooling                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *****35*********Error in reading file SDPLACV2*******************         JMI108
      *****45*********End of file for SDPLACV2*************************         JMI108
      *    35         Error in reading file XXPLACV2                  *         JMI108
      *    45         End of file for XXPLACV2                        *         JMI108
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRPrint - Print details                                       *
      * SREnd   - Write trailer in report                             *
      * SRAudit - Write audit report                                  *
      * *INZSR  - Initialise                                          *
      * *PSSR   - Error processing                                    *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** SD Pooling Account Details
     F***SDPLACV2  IF   E           K DISK    INFSR(*PSSR)
     FXXPLACV2  IF   E           K DISK    INFSR(*PSSR)                         JMI108
      *                                                                         JMI108
      ** Accounts by Branch
     FACCBR     IF   E           K DISK    INFSR(*PSSR)
      *
      ** Pooling Account List printer file - Detail
     F***SDJ101P1  O    E             PRINTER INFDS(SPOOL1)                     JMI108
     FXXJ101P1  O    E             PRINTER INFDS(SPOOL1)                        JMI108
     F                                     USROPN
     F                                     INFSR(*PSSR)
      *
      ** Pooling Account List printer file - Audit
     F***SDJ101PM  O    E             PRINTER INFDS(SPOOLU)                     JMI108
     FXXJ101PM  O    E             PRINTER INFDS(SPOOLU)                        JMI108
     F                                     USROPN
     F                                     INFSR(*PSSR)
      *
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
      ** DS for access objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ***File*Information*Data*Structure*for*SDJ101P1.*****                     JMI108
      ** File Information Data Structure for XXJ101P1.                          JMI108
     D SPOOL1          DS
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0
      *
      ***File Information Data Structure for SDJ101PM.                          JMI108
      ** File Information Data Structure for XXJ101PM.                          JMI108
     D SPOOLU          DS
     D   SFILEU               83     92
     D   SFNUMU              123    124B 0
      *
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  ErrorOnFl             35     35
     D  EndOfFile             45     45
      *
      ** Data Structure for Account
     D                 DS
     D  RACNT                  1     28
     D   WBRCA                 1      3
     D   DASH1                 4      4
     D   WCNUM                 5     10
     D   DASH2                11     11
     D   WCCY                 12     14
     D   DASH3                15     15
     D   WACOD                16     25
     D   DASH4                26     26
     D   WACSQ                27     28
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Named constants             ¦
      ** ¦ =======  ===============             ¦
      ** +--------------------------------------+
      *
      ** True and False can be used for indicators being on or off.
     D True            C                   *On
     D False           C                   *Off
      *
      ** Label for Account
     D ACLOSE          C                   CONST('ACCOUNT IS CLOSED')
     D AEXIST          C                   CONST('ACCOUNT DOES NOT EXIST')
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+
      *
      ** Parameters for ZDATE2
     D ZDayNo          S              5P 0
     D ZDate           S              6P 0
     D ZADate          S              7A
      *
      ** Parameters for ZSFILE
     D PSeq            S              5
     D SEnty           S              3
     D ZSnum           S              6  0
     D ZSnumU          S              6  0
     D ZSerr           S              1
      *
      ** Parameters for access object programs
     D PRtcd           S              7
     D POptn           S              7
      *
      ** Parameter list fields
     D PMode           S              1
     D PLevl           S              1
     D PEnty           S              3
      *
      ** Other fields used
     D WRun            S              1
     D WOpen           S              1    INZ('N')
     D WFirst          S              1    INZ('Y')
     D WNoRec          S              5  0 INZ(0)
     D RqdLn1          S              3  0
     D DifLn1          S              3  0
      *
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
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
     C******HIVAL        SETLL     SDPLACV2                                     JMI108
     C****************** READ      SDPLACV2                             3545    JMI108
     C     *HIVAL        SETLL     XXPLACV2                                     JMI108
     C                   READ      XXPLACV2                             3545    JMI108
      *
      ** Database error
      *
     C                   IF        ErrorOnFl = True
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = '*FIRST'
     C****************** EVAL      DBFile = 'SDPLACV2'                          JMI108
     C                   EVAL      DBFile = 'XXPLACV2'                          JMI108
     C                   EVAL      DBase = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        EndOfFile = True
     C                   EXSR      SRAudit
     C                   ENDIF
      *
     C                   DOU       EndOfFile = True
      *
      ** Count no. of records processed.
      *
     C                   EVAL      WNoRec = WNoRec + 1
      *
      ** Process Report Lines.
      *
     C                   EXSR      SRPrint
      *
      ** Read next record.
      *
     C****************** READ      SDPLACV2                             3545    JMI108
     C                   READ      XXPLACV2                             3545    JMI108
      *
     C                   IF        ErrorOnFl = True
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = '*NEXT'
     C****************** EVAL      DBFile = 'SDPLACV2'                          JMI108
     C                   EVAL      DBFile = 'XXPLACV2'                          JMI108
     C                   EVAL      DBase = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDDO

     C                   EXSR      SREnd
      *
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrnt - Print details                                       *
      *                                                               *
      *****************************************************************

     C     SRPrint       BEGSR

     C                   IF        WOpen <> 'Y'
     C                   EVAL      WOpen = 'Y'
     C****************** OPEN      SDJ101P1                                     JMI108
     C                   OPEN      XXJ101P1                                     JMI108
      *
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
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   EVAL      RqdLn1 = 1
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
      *
     C                   IF        DifLn1 <= RqdLn1 OR
     C                             WFirst = 'Y'
     C                   WRITE     HEADP1
     C                   EVAL      WFIRST = 'N'
     C                   ENDIF
      *
      ** Write details to printer fields.
      *
     C                   CLEAR                   DETAIL

     C                   EVAL      DASH1 = '-'
     C                   EVAL      DASH2 = '-'
     C                   EVAL      DASH3 = '-'
     C                   EVAL      DASH4 = '-'
     C                   EVAL      WBRCA = JBRCA                                Branch
     C                   MOVEL     JCNUM         WCNUM                          Customer
     C                   EVAL      WCCY  = JCCY                                 Currency
     C                   MOVEL     JACOD         WACOD                          Account Code
     C                   MOVEL     JACSQ         WACSQ                          Account Seq
     C                   MOVEL     JACNO         RACNO                          Account Number
     C                   EVAL      RANAM = JANAM                                Account Name
     C                   EVAL      RCHMA = JSCHMA                               Scheme Actual
     C                   EVAL      RCHMS = JSCHMS                               Scheme Sweep
     C                   EVAL      RCHMT = JSCHMT                               Scheme Transfer
     C                   EVAL      RCHMI = JSCHMI                               Inter-Office
     C                   EVAL      RBRCH = JBRCH                                Internal Branch
     C                   EVAL      RTYLC = JTYLC                                Last Change Type
     C                   EVAL      RLTME = JLTME                                Last change Time
      *
     C                   EVAL      ZDayNo = JLCD
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDayNo
     C                   PARM                    BJDFIN
     C                   PARM      *Zero         ZDate
     C                   PARM      *BLanks       ZADate
      *
     C                   IF        ZADate <> *Blanks
     C                   EVAL      RLCD = ZADate                                Last Change Date
     C                   ELSE
     C                   EVAL      RLCD = *Blanks
     C                   ENDIF
      *
      ** Check if it exists on Accounts File
      *
     C     KPOS          CHAIN     ACCBR                              60
     C                   IF        (*IN60 = '0') and RECI = 'C'
     C                   EVAL      RANAM = ACLOSE
     C                   ENDIF
     C                   IF        *IN60 = '1'
     C                   EVAL      RANAM = AEXIST
     C                   ENDIF
      *
      ** Write Detail
      *
     C                   WRITE     DETAIL

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
     C                   EVAL      RqdLn1 = 4
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF
      *
      ** Write out report trailer.
      *
     C                   WRITE     TRAILP1
      *
      ** End Program
      *
     C                   EVAL      *INLR ='1'
     C                   RETURN


     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit - Write audit report                                 *
      *                                                               *
      *****************************************************************

     C     SRAudit       BEGSR
      *
     C****************** OPEN      SDJ101PM                                     JMI108
     C                   OPEN      XXJ101PM                                     JMI108
      *
      ** Ensure Audit Spool File recorded by RCF.
      *
     C                   EVAL      ZSnumU = SFNUMU
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *Blanks       SEnty
     C                   PARM                    SFILEU
     C                   PARM                    ZSnumU
     C                   PARM      *Blank        ZSerr
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
      *
     C     ZSERR         IFEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF
      *
     C                   WRITE     HEADAU
      *
      ** If there is a DB Error, Output the DB Error Information.
      *
     C                   IF        *INU7 = *ON
     C                   WRITE     DBERROR
     C                   ELSE
      *
     C                   IF        WNoRec = 0
      *
      ** Or, if no records read, Output "No Details" message.
      *
     C                   WRITE     NODTLS
     C                   ENDIF
      *
     C                   ENDIF
      *
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
     C                   PARM                    PRtcd
     C                   PARM                    PMode
     C                   PARM                    PSeq
     C                   PARM                    PLevl
     C                   PARM                    PEnty
      *
     C     *DTAARA       DEFINE                  LDA
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error.
      *
     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 003
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Report Work fields.
      *
     C                   EVAL      RqdLn1 = 0
     C                   EVAL      DifLn1 = 0
     C                   EVAL      PRTLN1 = 0
      *
      ** Set up Key Lists
      *
     C     KPOS          KLIST
     C                   KFLD                    JBRCA                          Branch
     C                   KFLD                    JCNUM                          Customer
     C                   KFLD                    JCCY                           Currency
     C                   KFLD                    JACOD                          Account Code
     C                   KFLD                    JACSQ                          Account Seq

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
     C                   DUMP
     C                   EXSR      SRAudit
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2018
