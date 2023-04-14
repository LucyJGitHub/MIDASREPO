     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2018')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Pooling Data Error Report')                   *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      ***GLJ113*-*Midas*GL*Pooling*Data Error Report*******************         EML110
      *  XXJ123 - Midas GL Pooling Data Error Report                  *         EML110
      *                                                               *
      *  Function:  This program reports the Incoming Details with    *
      *             Non-000 in the Result Code then deletes these     *
      **************records before GLJ106 is called.*******************         EML110
      *             records before XXJ116 is called.                  *         EML110
      *                                                               *
      ***Called By: SDJ103  - Pooling Account Status*******************         EML110
      ***           GLCJ102 - Account Pooling receive background job***         EML110
      *  Called By: XXJ103  - Pooling Account Status                  *         EML110
      *             XXCJ112 - Account Pooling receive background job  *         EML110
      *                                                               *
      ***(c)*Misys*International*Banking*Systems*Ltd.*2007*************         EML110
      *  (c) Finastra International Limited 2018                      *         EML110
      *                                                               *
      *  Last Amend No. EML110             Date 20Jan20               *
      *  Prev Amend No. TFJ011  (CHG141)   Date 23Jan07               *
      *                 TFJ011  *CREATE    Date 26Aug05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  EML110 - Account Balance Pooling. Upgrade to FBM 2.1         *
      *  TFJ011 - (CHG141) Further Requirements by client             *
      *  TFJ011 - (CHG014) Create a Data Error Report                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *****35*********Error in reading file GLPIDLPP                  *         EML110
      *****45*********End of file for GLPIDLPP                        *         EML110
      *    35         Error in reading file XXPIDLPP                  *         EML110
      *    45         End of file for XXPIDLPP                        *         EML110
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
      ** GL Account Pooling Incoming Details File
     F***GLPIDLPP  UF   E             DISK    INFSR(*PSSR)                      EML110
     FXXPIDLPP  UF   E             DISK    INFSR(*PSSR)                         EML110
      *
      ** Pooling Data Error Report - Detail
     F***GLJ113P1  O    E             PRINTER INFDS(SPOOL1)                     EML110
     FXXJ123P1  O    E             PRINTER INFDS(SPOOL1)                        EML110
     F                                     USROPN
     F                                     INFSR(*PSSR)
      *
      ** Pooling Data Error Report - Audit
     F***GLJ113AU  O    E             PRINTER INFDS(SPOOLU)                     EML110
     FXXJ123AU  O    E             PRINTER INFDS(SPOOLU)                        EML110
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

      ** Data structure for Header record
     DHEADER           DS
     D JHREC                   1      1  0                                      Header = 1
     D JHCC                    2      3  0                                      Century
     D JHYY                    4      5  0                                      Year
     D JHMO                    6      7  0                                      Month
     D JHDD                    8      9  0                                      Day
     D JHSCHEM                10     19                                         Scheme Number
     D JHTYPE                 20     22                                         Transaction Type
     D JHHH                   23     24  0                                      Hour
     D JHMM                   25     26  0                                      Minute
     D JHISEQ                 27     31  0                                      Instruction Seq
     D JHIBRCH                32     34                                         Receiver's Int Br
     D JFIL1                  35    400                                         Filler

      ** Data structure for Detail Record
     DDETAILP          DS
     D JREC                    1      1  0                                      Header = 2
     D JREST                 167    169                                         Result
     D JDAT1                   1    100                                         Incoming Data 1
     D JDAT2                 101    200                                         Incoming Data 2
     D JDAT3                 201    300                                         Incoming Data 3
     D JDAT4                 301    400                                         Incoming Data 4

      *
      ** File Information Data Structure for GLJ113P1.
     D SPOOL1          DS
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0
      *
      ** File Information Data Structure for GLJ113AU.
     D SPOOLU          DS
     D   SFILEU               83     92
     D   SFNUMU              123    124B 0
      *
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  ErrorOnFl             35     35
     D  EndOfFile             45     45
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
      ** Parameters for access object programs
     D PRtcd           S              7
     D POptn           S              7
      *
      ** Parameter list fields
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
     C**** 1             SETLL     GLPIDLPP                                     EML110
     C****               READ      GLPIDLPP                             3545    EML110
     C     1             SETLL     XXPIDLPP                                     EML110
     C                   READ      XXPIDLPP                             3545    EML110

     C                   IF        EndOfFile <> True
     C                   MOVEL     JINDL         HEADER
     C                   IF        JHREC = 1
     C                   IF        JHTYPE = '002'
     C                   EVAL      *IN40 = '0'
     C                   ELSE
     C                   EVAL      *IN40 = '1'
     C                   ENDIF
     C                   ELSE
      *
      ** Database error
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = '*FIRST'
     C****************** EVAL      DBFile = 'GLPIDLPP'                          EML110
     C                   EVAL      DBFile = 'XXPIDLPP'                          EML110
     C                   EVAL      DBase = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        EndOfFile = True
     C**********         EXSR      SRAudit                                                    CHG141
     C                   EXSR      SREnd                                                      CHG141
     C                   ENDIF
      *
     C****************** READ      GLPIDLPP                             3545    EML110
     C                   READ      XXPIDLPP                             3545    EML110
     C                   MOVEL     JINDL         HEADER
     C                   IF        JHREC = 9
     C**********         EXSR      SRAudit                                                    CHG141
     C                   EXSR      SREnd                                                      CHG141
     C                   ELSE
     C                   MOVEL     JINDL         DETAILP
     C                   ENDIF
      *
     C                   DOU       EndOfFile = True
     C                   IF        (JREC = 2) and (JREST <> '000')
      *
      ** Count no. of records processed.
      *
     C                   EVAL      WNoRec = WNoRec + 1
      *
      ** Process Report Lines.
      *
     C                   EXSR      SRPrint
     C                   ENDIF
      *
      ** Read next record.
      *
     C****************** READ      GLPIDLPP                             3545    EML110
     C                   READ      XXPIDLPP                             3545    EML110
     C                   MOVEL     JINDL         DETAILP
      *
     C                   IF        ErrorOnFl = True
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = '*NEXT'
     C****************** EVAL      DBFile = 'GLPIDLPP'                          EML110
     C                   EVAL      DBFile = 'XXPIDLPP'                          EML110
     C                   EVAL      DBase = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDDO

     C**********         IF        WNoRec = 0                                                 CHG141
     C**********         EXSR      SRAudit                                                    CHG141
     C**********         EndIF                                                                CHG141

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
     C****************** OPEN      GLJ113P1                                     EML110
     C                   OPEN      XXJ123P1                                     EML110
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
     C                   EVAL      RSEQ = PSeqNo                                              CHG141
      *
     C                   EVAL      RqdLn1 = 5
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
      *
     C                   IF        DifLn1 <= RqdLn1 OR
     C                             WFirst = 'Y'
     C                   WRITE     HEADP1
     C                   WRITE     HEADP2                                                     CHG141
     C                   EVAL      WFIRST = 'N'
     C                   ENDIF
      *
      ** Write details to printer fields.
      *
     C                   CLEAR                   DETAIL

     C                   EVAL      RERCD = JREST
     C                   EVAL      RDAT1 = JDAT1
     C                   EVAL      RDAT2 = JDAT2
     C                   EVAL      RDAT3 = JDAT3
     C                   EVAL      RDAT4 = JDAT4

      *
      ** Write Detail
      *
     C                   WRITE     DETAIL

      *
      ** Delete Detail Record in Incoming File
      *
     C****************** DELETE    GLPIDLD0                                     EML110
     C                   DELETE    XXPIDLD0                                     EML110

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
     C                   IF        WNoRec <> 0                                                CHG141
     C                   EVAL      RqdLn1 = 4
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   WRITE     HEADP2                                                     CHG141
     C                   ENDIF
      *
      ** Write out report trailer.
      *
     C                   WRITE     TRAILP1
     C                   ENDIF                                                                CHG141
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
     C****************** OPEN      GLJ113AU                                     EML110
     C                   OPEN      XXJ123AU                                     EML110
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
     C                   WRITE     TRAILAU
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
     C                   PARM                    PSeq
     C                   PARM                    PLevl
     C                   PARM                    PEnty
     C                   PARM                    PSeqNo            3                          CHG141
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
