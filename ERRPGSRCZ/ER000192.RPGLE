     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2009')
      *****************************************************************
/*S*D ***RPGBASEBND****************************************************                       CER070
/*STD *  RPGBASEMOD                                                   *                       CER070
/*EXI *  TEXT('Midas ER Bundesbank Standing Data Extract')            *
      *****************************************************************
      *                                                               *
      *  Midas - European Reporting Module                            *
      *                                                               *
      *  ER000192 - Midas ER Bundesbank Standing Data Driver File     *
      *             Extract                                           *
      *                                                               *
      *  Function: This program creates Standing Data Driver File     *
      *             Update for GRI reporting                          *
      *                                                               *
      *  (c) Finastra International Limited 2009                      *
      *                                                               *
      *  Last Amend No. MD054605           Date 17Oct19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CER071             Date 01Aug16               *
      *                 CER070             Date 19Aug14               *
      *                 CLE134             Date 01Aug12               *
      *                 CER059             Date 19Jul10               *
      *                 CER045   *CREATE   Date 20Jul09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054605 - Deliverable Data Split for SDSVALPD               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER071 - BAIS - Legal Form field (Recompile)                 *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0                      *
      *           Change compilation directive from RPGBASEBND to     *
      *           RPGBASEMOD and create associated program.           *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER045 - German Features - Reporting Bundesbank              *
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
      * SRExtrCust - Extract Customer Data Driver File                *
      * SRExtrCcy  - Extract Currency Data Driver File                *
      * SRAudit - Write audit report                                  *
      * *INZSR  - Initialisation sub-routine                          *
      * *PSSR   - Error processing                                    *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Midas SD Customer Details
     FSDCUSTL1  IF   E           K DISK    INFSR(*PSSR)

      ** Midas SD Additional Customer Details
     FSDACUSL1  IF   E           K DISK    INFSR(*PSSR)

      ** Midas SD Currency Codes
     FSDCURRL1  IF   E           K DISK    INFSR(*PSSR)

      ** Midas ER GRI Customer Driver File
     FERKNEIPD  O    E           K DISK    INFSR(*PSSR)

      ** Midas ER GRI Currency and Rates Driver File
     FERWHGIPD  O    E           K DISK    INFSR(*PSSR)

      ** Midas ER Bundesbank Cash Flow Extract Audit
     FER000192AUO    E             PRINTER INFDS(SPOOLU)
     F                                     INFSR(*PSSR)

      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+

      ** Array containing Copyright statement

     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)

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

      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Externally described DS for System Values
     D*SDSVAL***     E DS                  EXTNAME(SDSVALPD)                                MD054605

      ** DS for access objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** File Information Data Structure for ER000192AU
     D SPOOLU          DS
     D   SFILEU               83     92
     D   SFNUMU              123    124B 0

      ** +--------------------------------------+
      ** ¦ D-specs: Named constants             ¦
      ** ¦ =======  ===============             ¦
      ** +--------------------------------------+

      ** Constant
     D WKeySysVal1     C                   CONST('BundClientId')

      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+

      ** Entry Parameter
     D POption         S              1A

      ** Parameters for access object programs
     D PRtcd           S              7A
     D POptn           S              7A

     D PSValK1         S             20A
     D PSVal1          S            200A
     D PSValK2         S             20A
     D PSVal2          S            200A
     D PSValK3         S             20A
     D PSVal3          S            200A
     D PSValK4         S             20A
     D PSVal4          S            200A
     D PSValK5         S             20A
     D PSVal5          S            200A
     D PSValK6         S             20A
     D PSVal6          S            200A
     D PSValK7         S             20A
     D PSVal7          S            200A
     D PSValK8         S             20A
     D PSVal8          S            200A
     D PSValK9         S             20A
     D PSVal9          S            200A
     D PSValK0         S             20A
     D PSVal0          S            200A

      ** Other field used
     D WRun            S              1A
      *                                                                                       CER070
      ** Parameters for ZDATE9                                                                CER070
      *                                                                                       CER070
     D PZDayNo         S              5P 0                                                    CER070
     D PZDate1         S              8S 0                                                    CER070
     D PErrorFlag      S              1A                                                      CER070

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

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

      ** Extract Customer Driver File
     C                   EXSR      SRExtrCust

      ** Extract Currency Driver File
     C                   EXSR      SRExtrCcy

     C                   EVAL      *INLR  = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRExtrCust  - Extract Customer Data                          *
      *                                                               *
      *****************************************************************

     C     SRExtrCust    BEGSR

     C     *LOVAL        SETLL     SDCUSTL1
     C                   READ      SDCUSTL1
     C                   DOW       NOT %EOF(SDCUSTL1)

     C                   IF        BBTYLC <> 'D'

      ** Check against Additional Customer Details
     C     BBCUST        CHAIN     SDACUSL1
     C                   IF        %FOUND() AND
     C                             E5BEXT = 'Y'   AND
     C                             (E5TYLC <> 'C' AND E5TYLC <> 'D')

     C                   IF        POption = 'I' OR
     C                             (POption = 'X' AND (BBLCD = BJRDNB OR
     C                                                E5LCD = BJRDNB))
     C                   EVAL      B1MDAN   = PSVal1
     C                   EVAL      B1KDNR   = BBCUST
     C                   MOVE      PZDate1       B1DLDT                                       CER070

      ** Write to Extract Customer Table
     C                   WRITE     ERKNEID0
     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

     C                   READ      SDCUSTL1
     C                   ENDDO

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRExtrCcy  - Extract Currency Driver File                    *
      *                                                               *
      *****************************************************************

     C     SRExtrCcy     BEGSR

     C     *LOVAL        SETLL     SDCURRL1
     C                   READ      SDCURRL1
     C                   DOW       NOT %EOF(SDCURRL1)

     C                   IF        POption = 'I' OR
     C                             (POption = 'X' AND A6TYLC <> 'D' AND
     C                                               A6LCD = BJRDNB )
     C                   EVAL      B2MDAN   = PSVal1
     C                   EVAL      B2WHIS   = A6CYCD
     C                   MOVE      PZDate1       B2DLDT                                       CER070
     C                   WRITE     ERWHGID0
     C                   ENDIF

     C                   READ      SDCURRL1
     C                   ENDDO

     C                   ENDSR

      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit - Write audit report                                 *
      *                                                               *
      *****************************************************************

     C     SRAudit       BEGSR

     C                   IF        *INU7   = *ON

     C                   WRITE     HEADAU

      ** If there is a DB Error, Output the DB Error Information.

     C                   IF        *INU7 = *ON
     C                   WRITE     DBERROR
     C                   ENDIF

     C                   ENDIF

     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

      ** Parameter Option : 'I-nitialisation'
      **                    'X-extract
     C     *ENTRY        PLIST
     C                   PARM                    POption

     C     *DTAARA       DEFINE                  LDA

     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA
     C                   CALL      'AOBANKR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database error
     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                              CER070
     C                   EVAL      PZDayNo = BJRDNB                                           CER070
                                                                                              CER070
     C                   CALLB     'ZDATE9'                                                   CER070
     C                   PARM                    PZDayNo                                      CER070
     C                   PARM      *ZEROS        PZDate1                                      CER070
     C                   PARM      *BLANKS       PErrorFlag                                   CER070

      ** Retrieve system value
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      WKeySysVal1   PSValK1
     C                   PARM                    PSVal1
     C                   PARM                    PSValK2
     C                   PARM                    PSVal2
     C                   PARM                    PSValK3
     C                   PARM                    PSVal3
     C                   PARM                    PSValK4
     C                   PARM                    PSVal4
     C                   PARM                    PSValK5
     C                   PARM                    PSVal5
     C                   PARM                    PSValK6
     C                   PARM                    PSVal6
     C                   PARM                    PSValK7
     C                   PARM                    PSVal7
     C                   PARM                    PSValK8
     C                   PARM                    PSVal8
     C                   PARM                    PSValK9
     C                   PARM                    PSVal9
     C                   PARM                    PSValK0
     C                   PARM                    PSVal0

      ** If the system value is not found then issue a database error

     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDSVALPD'
     C                   EVAL      DBase = 002
     C                   EVAL      DBKey = PSValK1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

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

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2009
