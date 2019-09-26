     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2009')
      *****************************************************************
/*S*D ***RPGBASEBND****************************************************                       CER070
/*STD *  RPGBASEMOD                                                   *                       CER070
/*EXI *  TEXT('Midas ER Bundesbank FX Deals Driver')                  *
      *****************************************************************
      *                                                               *
      *  Midas - European Reporting Module                            *
      *                                                               *
      *  ER000196 - Midas ER Bundesbank FX Deals Driver               *
      *                                                               *
      *  Function: This program extracts all Foreign Exchange deals   *
      *            for GRI reporting                                  *
      *                                                               *
      *  (c) Finastra International Limited 2009                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CDL099             Date 06Oct17               *
      *                 CER070             Date 19Aug14               *
      *                 CDL094             Date 11Jun14               *
      *                 CLE134             Date 01Aug12               *
      *                 CER059             Date 19Jul10               *
      *                 CER045   *CREATE   Date 20Jul09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0                      *
      *           Change compilation directive from RPGBASEBND to     *
      *           RPGBASEMOD and create associated program.           *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
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
      * SRProcess - Main Processing                                   *
      * SRAudit - Write audit report                                  *
      * *INZSR  - Initialise                                          *
      * *PSSR   - Error processing                                    *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Midas DL Foreign exchange deals file

     FDEALSDB   IF   E           K DISK    INFSR(*PSSR)

      ** Midas ER Transaction Type Decision Table

     FERDETTL0  IF   E           K DISK    INFSR(*PSSR)

      ** Midas ER GRI FX Deals Driver

     FERDVTIPD  O    E           K DISK    INFSR(*PSSR)

      ** Midas ER Bundesbank FX Deals Driver Audit

     FER000196AUO    E             PRINTER INFDS(SPOOLU)
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

      ** Externally described DS for Bank details

     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Externally described DS for Additional Customer details

     D SDACUS        E DS                  EXTNAME(SDACUSPD)

      ** Externally described DS for System Values

     D SDSVAL        E DS                  EXTNAME(SDSVALPD)

      ** First DS for access objects - short data structure

     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Third DS for access objects - very long data structure

     D DSLDY         E DS                  EXTNAME(DSLDY)

      ** File Information Data Structure for ER000196AU

     D SPOOLU          DS
     D   SFILEU               83     92
     D   SFNUMU              123    124B 0

      ** +--------------------------------------+
      ** ¦ D-specs: Named constants             ¦
      ** ¦ =======  ===============             ¦
      ** +--------------------------------------+

      ** Constants

     D WKeySysVal1     C                   CONST('BundClientId')

      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+

      ** Parameters for acces object programs

     D PRtcd           S              7A
     D POptn           S              7A
     D PCustNo         S              6A

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

      ** Other fields used

     D KModuleId       S              2A
     D KType           S              2A
     D KSubType        S              2A
     D KClass          S              4A

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

      ** Process Deals file

     C                   READ      DEALSDB

     C                   DOW       NOT %EOF(DEALSDB)

     C                   IF        RECI = 'D'

     C                   MOVE      CNUM          PCustNo

     C                   CALL      'AOACUSR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCustNo
     C     SDACUS        PARM      SDACUS        DSLDY

      ** Check whether customer is subject for extraction

     C                   IF        PRtcd = *BLANKS AND
     C                             E5BEXT = 'Y'

      ** Setup key field list for ERDETTL0

     C                   EVAL      KModuleId = 'FX'
     C                   EVAL      KType     = DTYP
     C                   EVAL      KSubType  = DLST
     C                   EVAL      KClass    = CLAS

      ** Access Decision Table file and
      ** check whether subject for extraction

     C     KDettL0       CHAIN     ERDETTL0

     C                   IF        %FOUND AND
     C                             N4GRI = 'Y'

     C                   MOVE      DLNO          B8DLNO

      ** Write to driver file

     C                   WRITE     ERDVTID0
     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

      ** Read next record

     C                   READ      DEALSDB
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

     C                   WRITE     DBERROR

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
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     KDettL0       KLIST
     C                   KFLD                    KModuleId
     C                   KFLD                    KType
     C                   KFLD                    KSubType
     C                   KFLD                    KClass

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
                                                                                              CER070
     C                   IF        PErrorFlag = '0'                                           CER070
     C                   MOVE      PZDate1       B8DLDT                                       CER070
     C                   ENDIF                                                                CER070

      ** Retrieve system values

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

      ** GRI Client Id

     C                   EVAL      B8MDAN = PSVal1

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
