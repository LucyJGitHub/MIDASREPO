     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2009')
      *****************************************************************
/*S*D ***RPGBASEBND****************************************************                       CER070
/*STD *  RPGBASEMOD                                                   *                       CER070
/*EXI *  TEXT('Midas ER Bundesbank Off Balance Sheet Driver')         *
      *****************************************************************
      *                                                               *
      *  Midas - European Reporting Module                            *
      *                                                               *
      *  ER000195 - Midas ER Bundesbank Off Balance Sheet Driver      *
      *                                                               *
      *  Function: This program creates Off Balance Extract file      *
      *            for Midas Export Composite message.                *
      *                                                               *
      *  (c) Finastra International Limited 2009                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CER070             Date 19Aug14               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE064             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 BUG26748           Date 26Nov09               *
      *                 CER045  *CREATE    Date 20Jul09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0                      *
      *           Change compilation directive from RPGBASEBND to     *
      *           RPGBASEMOD and create associated program.           *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26748 - Issue on Flat File Output Splitting               *
      *  CER045 - German Features - Reporting Bundesbank              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    LR - Last record indicator (program termination)           *
      *    U7 and U8 - DB error processing indicator                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRProcess - Processing subroutine                            *
      *  SRFacility - Process Facility file                           *
      *  SRAccounts - Process Retail Accounts                         *
      *  SRAudit - Write audit report                                 *
      *  *INZSR  - Initialise                                         *
      *  *PSSR   - Error processing                                   *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Midas GL Accounts by branch

     FACCBR     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(AC)

      ** Midas LE Customer lending facility file

     FFCLTY     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(FCLTYHHF:FCLTYZZF:FCLTYFNF)

      ** Midas ER GRI Lending Commitments and Retail Account Overdrafts

     FERZUSIPD  O    E             DISK
                                                                                            BUG26748
      ** Midas ER GRI End of Message file                                                   BUG26748
                                                                                            BUG26748
     FEREOMSPD  O    E             DISK                                                     BUG26748

      ** Midas ER Bundesbank Off Balance Sheet Extract Audit

     FER000195AUO    E             PRINTER INFDS(SPOOLU)
     F                                     USROPN
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

      ** Externally described DS for Currency Codes

     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      ** Externally described DS for Additional Customer Details

     D SDACUS        E DS                  EXTNAME(SDACUSPD)

      ** Externally described DS for System Values

     D SDSVAL        E DS                  EXTNAME(SDSVALPD)

      ** DS for access objects - Long data structure

     D DSLDY         E DS                  EXTNAME(DSLDY)

      ** DS for access objects

     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** File Information Data Structure for ER000195AU.

     D SPOOLU          DS
     D   SFILEU               83     92
     D   SFNUMU              123    124B 0

      ** Indicator Array

     D Indicators      DS                  BASED(IndicatorP)
     D  EndOfFile             02     02
     D  RecNotFnd             03     03

      ** +--------------------------------------+
      ** ¦ D-specs: Named constants             ¦
      ** ¦ =======  ===============             ¦
      ** +--------------------------------------+

      ** Constants for system values

     D WKeySysVal1     C                   CONST('BundClientId')

      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+

      ** Parameters for access object programs

     D PRtcd           S              7
     D POptn           S              7
     D PCust           S              6
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

      ** Parameter list fields

     D PCurr           S              3

      ** Other fields used

     D WRun            S              1
     D RqdLn1          S              3  0
     D DifLn1          S              4  0
     D PrtLn1          S              4  0

      ** Pointer for the indicator Array

     D IndicatorP      S               *   INZ(%Addr(*IN))
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

     C                   EXSR      SRProcess
     C                   EVAL      *INLR  = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcess - Processing subroutine                            *
      *                                                               *
      *****************************************************************

     C     SRProcess     BEGSR

      ** Process Facility file
      ** Set file pointer to first record and do initial read.

     C     *LOVAL        SETLL     FCLTY
     C                   READ      FCLTY

     C                   DOW       NOT %EOF(FCLTY)

     C                   IF        FSTS = 'A' AND
     C                             RECI = 'D'
     C                   EXSR      SRFacility
     C                   ENDIF

      ** Read next record.

     C                   READ      FCLTY

     C                   ENDDO

      ** Process Accounts
      ** Set file pointer to first record and do initial read.

     C     *LOVAL        SETLL     ACCBR
     C                   READ      ACCBR

     C                   DOW       NOT %EOF(ACCBR)

     C                   IF        ACATYP = 'R' AND
     C                             ACRECI = 'D'

     C                   EXSR      SRAccount

     C                   ENDIF

      ** Read next record.

     C                   READ      ACCBR

     C                   ENDDO
                                                                                            BUG26748
      ** Write end of message dummy data                                                    BUG26748
                                                                                            BUG26748
     C                   EVAL      DUMMY = 'Y'                                              BUG26748
     C                   WRITE     EREOMSD0                                                 BUG26748

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFacility -  Process Facility records                       *
      *                                                               *
      *****************************************************************

     C     SRFacility    BEGSR

     C                   MOVE      CNUM          PCust
     C                   CALL      'AOACUSR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCust
     C     SDACUS        PARM      SDACUS        DSLDY

     C                   IF        PRtcd   = *BLANKS

     C                   IF        E5BEXT  = 'Y'

     C                   CLEAR                   ERZUSID0

     C                   EVAL      B7MDAN = PSVal1
     C**********         EVAL      B7CNUM = CNUM                                              CER059
     C                   MOVEL     CNUM          B7CNUM                                       CER059
     C                   EVAL      B7FACT = FACT
     C                   EVAL      B7FCNO = FCNO
     C                   EVAL      PCurr  = FCCY
     C                   EXSR      SRGetCurr
     C                   EVAL      B7NBDP = A6NBDP
     C                   MOVE      PZDate1       B7DLDT                                       CER070
     C                   EVAL      B7RISK = E5RIGR                                            CER070

     C                   WRITE     ERZUSID0

     C                   ENDIF

     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetCurr - Get Currency Code                                *
      *                                                               *
      *****************************************************************

     C     SRGetCurr     BEGSR

      ** Get Number of decimal places for the Currency

     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCurr
     C     SDCURR        PARM      SDCURR        DSSDY

     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY  = PCurr
     C                   EVAL      DBPGM  = 'ER000195'
     C                   EVAL      DBASE  = 003
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAccount  -  Process Retail Accounts                        *
      *                                                               *
      *****************************************************************

     C     SRAccount     BEGSR

     C                   MOVE      ACCNUM        PCust
     C                   CALL      'AOACUSR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCust
     C     SDACUS        PARM      SDACUS        DSLDY

     C                   IF        PRtcd   = *BLANKS

     C                   IF        E5BEXT  = 'Y'

     C                   CLEAR                   ERZUSID0

     C                   EVAL      B7MDAN = PSVal1
     C                   EVAL      B7KTON = ACACNO
     C                   EVAL      PCurr  = ACCCY
     C                   EXSR      SRGetCurr
     C                   EVAL      B7NBDP = A6NBDP
     C                   MOVE      PZDate1       B7DLDT                                       CER070
     C                   EVAL      B7RISK = E5RIGR                                            CER070

     C                   WRITE     ERZUSID0

     C                   ENDIF

     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit - Write audit report                                 *
      *                                                               *
      *****************************************************************

     C     SRAudit       BEGSR

     C                   OPEN      ER000195AU

     C                   WRITE     HEADAU

      ** If there is a DB Error, Output the DB Error Information.

     C                   IF        *INU7 = *ON
     C                   WRITE     DBERROR
     C                   ENDIF

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

     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA

     C                   CALL      'AOBANKR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database error.

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
                                                                                              CER070

      ** Retrieve system values.

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

      ** If the system value is not found then issue a database error.

     C                   IF        PRtcd    <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDSVALPD'
     C                   EVAL      DBase = 002

     C                   IF        PSVal1 = '*NRF'
     C                   EVAL      DBKey = PSValK1
     C                   ENDIF

     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Report Work fields.

     C                   EVAL      RqdLn1 = 0
     C                   EVAL      DifLn1 = 0
     C                   EVAL      PRTLN1 = 0

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
