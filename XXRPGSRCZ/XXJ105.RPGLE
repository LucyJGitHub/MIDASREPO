     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2007')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Pooling Accounts Maint Audit')                *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      ***SDJ105*-*Midas*SD*Pooling Accounts Maint Audit****************         JMI108
      *  XXJ105 - Midas SD Pooling Accounts Maint Audit               *         JMI108
      *                                                               *
      ***Function:**This*program*will*produce*the*report*SDJ105P1******         JMI108
      *  Function:  This program will produce the report XXJ105P1     *         JMI108
      *             automatically when the user exits the             *
      *             Pooling Accounts Maintenance function after       *
      *             amending, inserting or deleting an account record.*
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
      *****35*********Error in reading file SDJ101PP*******************         JMI108
      *****45*********End of file for SDJ101PP*************************         JMI108
      *    35         Error in reading file XXJ101PP                  *         JMI108
      *    45         End of file for XXJ101PP                        *         JMI108
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRPrint - Print details                                       *
      * SREnd   - Write trailer in report                             *
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
     F***SDJ101PP  IF   E           K DISK    INFSR(*PSSR)                      JMI108
     FXXJ101PP  IF   E           K DISK    INFSR(*PSSR)                         JMI108
      ** Midas GL Accounts by branch
      *
      *
      ** Pooling Account List printer file - Detail
     F***SDJ105P1  O    E             PRINTER INFDS(SPOOL1)                     JMI108
     FXXJ105P1  O    E             PRINTER INFDS(SPOOL1)                        JMI108
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
     D ID0001          DS           528
      ***File*Information*Data*Structure*for*SDJ105P1.**********                JMI108
      ** File Information Data Structure for XXJ105P1.                          JMI108
     D SPOOL1          DS
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0
      *
      ** File Information Data Structure for SDJ105PM.
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

     D WTIME           DS
     D   WHH                   1      2    INZ('00')
     D   WCOL                  3      3    INZ(':')
     D   WMM                   4      5    INZ('00')
     D WTIME2          DS
     D   WHH2                  1      2
     D   WMM2                  3      4
     D   WSS2                  5      6
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
     D PJob            S             10
     D PUser           S             10
     D Count           S              1  0
     D AmdSts          S              3
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
     C**** *LOVAL        SETLL     SDJ101PP                                     JMI108
     C****               READ      SDJ101PP                             3545    JMI108
     C     *LOVAL        SETLL     XXJ101PP                                     JMI108
     C                   READ      XXJ101PP                             3545    JMI108
      *
      ** Database error
      *
     C                   IF        ErrorOnFl = True
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = '*FIRST'
     C*****************  EVAL      DBFile = 'SDJ101PP'                          JMI108
     C                   EVAL      DBFile = 'XXJ101PP'                          JMI108
     C                   EVAL      DBase = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        EndOfFile = True
     C                   EVAL      *INLR ='1'
     C                   RETURN
     C                   EndIf
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
     C****************** READ      SDJ101PP                             3545    JMI108
     C                   READ      XXJ101PP                             3545    JMI108
      *
     C                   IF        ErrorOnFl = True
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = '*NEXT'
     C****************** EVAL      DBFile = 'SDJ101PP'                          JMI108
     C                   EVAL      DBFile = 'XXJ101PP'                          JMI108
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
     C****************** OPEN      SDJ105P1                                     JMI108
     C                   OPEN      XXJ105P1                                     JMI108
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
     C                   EVAL      RWSTN = PJob
     C                   EVAL      RUSER = PUser
     C                   WRITE     HEADP1
     C                   EVAL      WFIRST = 'N'
     C                   ENDIF
      *
      ** Write details to printer fields.
      *
     C                   CLEAR                   DETAIL
      * Action
     C                   EXSR      SRAction
      *
     C                   IF        Rem2 = *ZERO  AND
     C                             J1TYLC = 'A'
     C                   MOVE(P)   'AFT'         RACTN
     C                   EVAL      RCHMA = J1SCHA                               Scheme Actual
     C                   EVAL      RCHMS = J1SCHS                               Scheme Sweep
     C                   EVAL      RCHMT = J1SCHT                               Scheme Transfer
     C                   EVAL      RCHMI = J1SCHI                               Inter-Office
     C                   EVAL      RBRCH = J1IBRH                               Internal Branch
     C                   EVAL      Count = 0
      *
     C                   ELSE
      *
     C                   IF        J1TYLC = 'A'
     C                   MOVE      'BFR'         RACTN
     C                   ENDIF
      *
     C                   EVAL      DASH1 = '-'
     C                   EVAL      DASH2 = '-'
     C                   EVAL      DASH3 = '-'
     C                   EVAL      DASH4 = '-'
     C                   EVAL      WBRCA = J1BRCA                               Branch
     C                   MOVE      J1CNUM        WCNUM                          Customer
     C                   EVAL      WCCY  = J1CCY                                Currency
     C                   MOVE      J1ACOD        WACOD                          Account Code
     C                   MOVE      J1ACSQ        WACSQ                          Account Seq
     C                   MOVEL     J1ACNO        RACNO                          Account Number
     C                   EVAL      RANAM = J1ANAM                               Account Name
     C                   EVAL      RCHMA = J1SCHA                               Scheme Actual
     C                   EVAL      RCHMS = J1SCHS                               Scheme Sweep
     C                   EVAL      RCHMT = J1SCHT                               Scheme Transfer
     C                   EVAL      RCHMI = J1SCHI                               Inter-Office
     C                   EVAL      RBRCH = J1IBRH                               Internal Branch
     C                   MOVE      J1TIME        WTIME2
     C                   MOVEL     WHH2          WHH
     C                   MOVE      WMM2          WMM
     C                   MOVE      WTIME         RLTME                          Last change Time
     C                   ENDIF
      *
      ** Check if it exists on Accounts File
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
      *  SRAction - output Action                                     *
      *                                                               *
      *****************************************************************

     C     SRAction      BEGSR
      *
     C                   IF        J1TYLC = 'I'
     C                   EVAL      RACTN = 'INSERT'
     C                   ENDIF
     C                   IF        J1TYLC = 'D'
     C                   EVAL      RACTN = 'DELETE'
     C                   ENDIF
     C                   IF        J1TYLC = 'A'
     C                   EVAL      RACTN = 'AMEND'
     C                   EVAL      Count = Count + 1
     C     Count         DIV       2             Quo               1 0
     C                   MVR                     Rem               2 1
     C                   MOVE      Rem           Rem2              2 0
     C                   ENDIF
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
     C                   PARM                    PJob
     C                   PARM                    PUser
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
     C                   EVAL      Count = 0
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
     C                   EVAL      PRtcd = 'PSSR   '
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   EVAL      PRtcd = 'PSSR   '
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2018
