     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Non-Account Holder - Retrieve')               *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDNAHLRTV - Non-A/C Holders Details Retrieve                 *
      *                                                               *
      *  Function:  This module retrieves a Non-A/C holder from       *
      *             the database. As it does so, it validates the     *
      *             action code and Non-A/C Holder reference.         *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. CSD100             Date 03Aug17               *
      *  Prev Amend No. CGL177             Date 11Jan16               *
      *                 MD036311           Date 01Nov15               *
      *                 CGL157             Date 17Aug15               *
      *                 MD046248           Date 27Oct17               *
      *                 MD027671A          Date 15Sep14               *
      *                 CGL132             Date 01May13               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 BUG22580           Date 02Feb09               *
      *                 CER048             Date 19May08               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 CSW207             Date 08Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 232543             Date 31Mar05               *
      *                 CGL032  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD100 - Patronymic and Gender Fields for Non-Account Holder *
      *           (Recompile)                                         *      
      *  CGL177 - CRS Reporting Phase 2                               *
      *  MD036311 - Database error on existing Customer and Non-Acct  *
      *             Holder                                            *
      *  CGL157 - CRS Reporting (Recompile)                           *
      *  MD046248 - Finastra Rebranding                               *
      *  MD027671A - FATCA classification descriptions of an enquired *
      *              NAHO is retained in display when a new NAHO is   *
      *              created. Apply Fix MD028786A                     *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  BUG22580 - Fields incorrectly labeled and lengths            *
      *             (Recompile)                                       *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *           (Recompile)                                         *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207 - Swift 2007 Standard Changes (Recompile)             *
      *  232543 - Fix to CGL031 (Recompile)                           *
      *  CGL032 - Automatic Exchange of Information.                  *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDNAHOL1  IF   E           K Disk    Infsr(*PSSR)
 
     FSDNAHOL2  IF   E           K Disk    Infsr(*PSSR)
     F                                     Rename(SDNAHOD0:SDNAHFOI)
 
     FSDJACCL7  IF   E           K Disk    Infsr(*PSSR)
                                                                                              CGL132
      ** FATCA Customer details file                                                          CGL132
     FSDFTNHL1  IF   E           K DISK    INFSR(*PSSR)                                       CGL132
                                                                                              CGL132
      ** FATCA Customer details file by Front office ID                                       CGL132
     FSDFTNHL2  IF   E           K DISK    INFSR(*PSSR)                                       CGL132
     F                                     PREFIX(A_)                                         CGL132
     F                                     RENAME(SDFTNHD0:SDFTNHD1)                          CGL132
                                                                                              CGL132
     FSDCRNHL1  IF   E           K Disk    Infsr(*PSSR)                                       CGL157
                                                                                              CGL157
      * Midas SD CRS Details File                                                             CGL157
     FSDCRSNL0  IF   E           K DISK    INFSR(*PSSR)                                       CGL157
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
                                                                                              CGL132
     D SysVal1         C                   'FATCADftCLsNewCustNH'                             CGL132
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** External DS for bank detials ICD retrieval
     D SDBANK        E DS                  Extname(SDBANKPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  Extname(DSFDY)
 
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  Extname(DSSDY)
 
      ** Non-A/C Holder in File Format
     D NahoFilFmt    E DS                  Extname(SDNAHOPD)
                                                                                              CGL157
      ** CRS Non-Account Holder Details File Format                                           CGL157
     D CuCrhFlFmt    E DS                  EXTNAME(SDCRNHPD)                                  CGL157
                                                                                              CGL157
      ** External DS for CRS Details                                                          CGL157
     D SDVCRSN       E DS                  EXTNAME(SDVCRSNPD)                                 CGL157
                                                                                              CGL157
                                                                                              CGL132
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CGL132
                                                                                              CGL132
      ** FATCA Customer Details in file format                                                CGL132
     D CuFaFilFmt    E DS                  EXTNAME(SDFTNHPD)                                  CGL132
                                                                                              CGL132
      ** Midas FATCA Classification Code                                                      CGL132
     D SDFATC        E DS                  EXTNAME(SDFATCPD)                                  CGL132
     D                                     PREFIX(C_)                                         CGL132
                                                                                              CGL132
     D CuFoFilFmt      DS                                                                     CGL132
     D  WCDESC                 1     50                                                       CGL132
     D  WPDESC                51    100                                                       CGL132
     D  WWBRTH               101    105                                                       CGL132
     D  WWCBTH               106    107                                                       CGL132
     D  WWBTHT               108    142                                                       CGL132
     D  WWCNCZ               143    144                                                       CGL132
     D  WWCDOM               145    146                                                       CGL132
     D  WWACCZ               147    148                                                       CGL132
     D  WWTINO               149    173                                                       CGL132
                                                                                              CGL132
     D PCrsdF          S            222A   DIM(30)                                            CGL177
 
     D RUNDAT          DS
     D  @MBIN                 13     13
 
     D ZMUSER          DS
     D  DBRN                  11     13
     D  BANK                  17     17
 
      ** Index for arrays of of error message ids etc
     D Ix              S              3P 0
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
                                                                                              CGL132
      ** Parameter variables for AOSVALR0 string                                              CGL132
     D PRtcd           S              7                                                       CGL132
     D SValK1          S             20                                                       CGL132
     D SVal1           S            200                                                       CGL132
     D SValK2          S             20                                                       CGL132
     D SVal2           S            200                                                       CGL132
     D SValK3          S             20                                                       CGL132
     D SVal3           S            200                                                       CGL132
     D SValK4          S             20                                                       CGL132
     D SVal4           S            200                                                       CGL132
     D SValK5          S             20                                                       CGL132
     D SVal5           S            200                                                       CGL132
     D SValK6          S             20                                                       CGL132
     D SVal6           S            200                                                       CGL132
     D SValK7          S             20                                                       CGL132
     D SVal7           S            200                                                       CGL132
     D SValK8          S             20                                                       CGL132
     D SVal8           S            200                                                       CGL132
     D SValK9          S             20                                                       CGL132
     D SVal9           S            200                                                       CGL132
     D SValK0          S             20                                                       CGL132
     D SVal10          S            200                                                       CGL132
 
      ** Parameter fields for ZVACTBU
     D ZACTN           S              1
     D ZBR             S              3
 
      ** Entry Parameter fields
     D ModeofOp        S              6
     D RespMode        S              1
     D DDACTN          S              1
     D FOTRID          S             20
     D DDNAHO          S             10
     D @IN36           S              1
     D OKACTN          S              1
     D OKNAHO          S              1
     D PSARD           S              6A                                                      CGL132
     D CGL132          S              1A                                                      CGL132
     D CGL157          S              1A                                                      CGL157
     D DDDATE          S              5P 0                                                    CGL132
     D DDSEQN          S              3S 0                                                    CGL132
     D @CLAC           S              5A                                                      CGL132
     D PCustNo         S              6A                                                      CGL132
     D DDCRTT          S              2A                                                      CGL132
     D X               S              2S 0                                                    CGL157
 
     D Err             S              1  0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      **************************************************************
 
      ** Initialisation
 
     C                   EXSR      SRInit
 
      ** If the mode is 'Front Office Transaction Interface'
      ** Do (extra) validation for front office Transaction Interface
 
     C     ModeofOp      IFEQ      '*FRONT'
     C                   EXSR      SRVfrnt
 
      **  Carry out no further validation if errors have occurred.
 
     C     OKACTN        IFEQ      'N'
     C     OKNAHO        OREQ      'N'
     C                   RETURN
     C                   ENDIF
 
     C                   ENDIF
 
      ** Validate Action Code
 
     C                   EXSR      SRValcde
 
      **  Carry out no further validation if errors have occurred.
 
     C     OKACTN        IFEQ      'N'
     C     OKNAHO        OREQ      'N'
     C                   RETURN
     C                   ENDIF
 
      ** Access Security Checking
 
     C     RespMode      IFEQ      'S'
     C                   EVAL      ZACTN = DDACTN
 
      ** If single branching
      ** Access Security Checking - Single Branching
 
     C     BJSBRC        IFNE      *BLANK
     C     RESPMODE      ANDEQ     'S'
     C                   EXSR      SRAcsses
     C                   ENDIF
 
      ** If multibranching
      ** Access Security Checking - Multi-Branching
 
     C     BJSBRC        IFEQ      *BLANK
     C     DDACTN        ANDNE     'I'
     C     RESPMODE      ANDEQ     'S'
     C                   EXSR      SRAcsseM
     C                   ENDIF
 
     C                   ENDIF
 
      **  Carry out no further validation if errors have occurred.
 
     C     OKACTN        IFEQ      'N'
     C                   RETURN
     C                   ENDIF
 
     C                   SELECT
 
      ** Validation for Action Code 'I'
 
     C                   WHEN      DDACTN = 'I'
     C                   EXSR      SRValaci
 
      ** Validation for Action Code 'E', 'A' or 'D'
 
     C                   WHEN      DDACTN = 'E' or
     C                             DDACTN = 'A' or
     C                             DDACTN = 'D'
     C                   EXSR      SRRtvNah
     C                   ENDSL
 
      **  Carry out no further validation if errors occurred.
 
     C     OKACTN        IFEQ      'N'
     C     OKNAHO        OREQ      'N'
     C                   RETURN
     C                   ENDIF
                                                                                              CGL132
     C                   IF        CGL132 = 'Y'                                               CGL132
     C                   EXSR      RTVFTC                                                     CGL132
     C                   ENDIF                                                                CGL132
 
      ** Return
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRAcsseS - Access Security Checking - Single Branching
      *****************************************************************
     C     SRAcsseS      BEGSR
 
      **  Check user's authority for the action.
 
     C                   CALL      'ZVACTU'
     C                   PARM                    ZACTN
     C                   PARM                    Err
 
      **  If action invalid for user
 
     C     Err           IFEQ      1
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
 
     C                   SELECT
     C                   WHEN      DDACTN = 'E'
     C                   MOVEL     'RE7105B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN = 'I'
     C                   MOVEL     'RE7102B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN = 'A'
     C                   MOVEL     'RE7103B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN = 'D'
     C                   MOVEL     'RE7104B'     MsgIdArr(Ix)
     C                   ENDSL
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** SSAcsseM - Access Security Checking - Multi-Branching
      *****************************************************************
     C     SRAcsseM      BEGSR
 
      **  Check user's authority for the action & Booking Branch.
 
     C                   CALL      'ZVACTBU'
     C                   PARM                    ZACTN
     C                   PARM      DBRN          ZBR
     C                   PARM                    ERR
 
      **   If action invalid for user
 
     C     ERR           IFEQ      1
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'RE71070'     MsgIdArr(Ix)
 
     C                   ELSE
 
     C     ERR           IFEQ      2
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
 
     C                   SELECT
     C                   WHEN      DDACTN = 'E'
     C                   MOVEL     'RE7105B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN = 'I'
     C                   MOVEL     'RE7102B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN = 'A'
     C                   MOVEL     'RE7103B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN = 'D'
     C                   MOVEL     'RE7104B'     MsgIdArr(Ix)
     C                   ENDSL
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRRtvNah - Retrieve Non-A/C Holder if action code 'A', 'E' OR 'D'
      *****************************************************************
     C     SRRtvNah      BEGSR
 
      ** Access Non-A/C Holder from the Non-A/C Holders file
 
     C     DDNAHO        CHAIN     SDNAHOL1                           44
 
      ** Non-A/C Holder details not found
 
     C     *In44         IFEQ      *On
     C                   MOVEL     'N'           OKNAHO
     C                   ADD       1             Ix
     C                   MOVEL     'DDNAHO'      FldNameArr(Ix)
     C                   MOVEL     'USR0081'     MsgIdArr(Ix)
     C                   ENDIF
 
      ** Retrieve CRS Customer Details if CGL157 is ON                                        CGL157
     C                   IF        CGL157 = 'Y'                                               CGL157
     C     DDNAHO        CHAIN     SDCRNHL1                           96                    MD036311
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
                                                                                              CGL157
     C                   IF        CGL157 = 'Y'                                               CGL157
     C                   EVAL      X = 1                                                      CGL157
     C     DDNAHO        SETLL     SDCRSNL0                                                   CGL157
     C     DDNAHO        READE     SDCRSNL0                                                   CGL157
     C                   DOW       NOT %EOF(SDCRSNL0)                                         CGL157
     C                             AND DDNAHO = CNNAHO                                        CGL157
     C                             AND X < 31                                                 CGL157
     C                   EVAL      RVCTRY = CNCTRY                                            CGL157
     C                   EVAL      RVREPT = CNREPT                                            CGL157
     C                   EVAL      RVREPR = CNREPR                                            CGL157
     C                   EVAL      RVREPD = CNREPD                                            CGL157
     C                   EVAL      RVREPM = CNREPM                                            CGL157
     C                   EVAL      RVREPU = CNREPU                                            CGL157
     C                   EVAL      RVEVE1 = CNEVE1                                            CGL157
     C                   EVAL      RVEVS1 = CNEVS1                                            CGL157
     C                   EVAL      RVEVE2 = CNEVE2                                            CGL157
     C                   EVAL      RVEVS2 = CNEVS2                                            CGL157
     C                   EVAL      RVEVE3 = CNEVE3                                            CGL157
     C                   EVAL      RVEVS3 = CNEVS3                                            CGL157
     C                   EVAL      RVEVE4 = CNEVE4                                            CGL157
     C                   EVAL      RVEVS4 = CNEVS4                                            CGL157
     C                   EVAL      RVEVE5 = CNEVE5                                            CGL157
     C                   EVAL      RVEVS5 = CNEVS5                                            CGL157
     C                   EVAL      RVTINN = CNTINN                                            CGL157
     C                   EVAL      RVEFFD = CNEFFD                                            CGL157
     C                   EVAL      RVEXPD = CNEXPD                                            CGL157
     C                   EVAL      RVCODO = CNCODO                                            CGL157
     C                   EVAL      RVJACM = CNJACM                                            CGL157
     C                   EVAL      RVMAIL = CNMAIL                                            CGL157
     C                   EVAL      RVPHON = CNPHON                                            CGL157
     C                   EVAL      RVRPAY = CNRPAY                                            CGL157
     C                   EVAL      RVTINS = CNTINS                                            CGL177
                                                                                              CGL157
     C                   EVAL      PCrsdF(X) = SDVCRSN                                        CGL157
     C                   EVAL      X = X + 1                                                  CGL157
     C     DDNAHO        READE     SDCRSNL0                                                   CGL157
     C                   ENDDO                                                                CGL157
     C                   ENDIF                                                                CGL157
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRVfrnt - Validation for Front Office Transaction Interface
      *****************************************************************
     C     SRVfrnt       BEGSR
 
      ** Error if action code is not 'I','A','E' OR 'D'
 
     C     DDACTN        IFNE      'I'
     C     DDACTN        ANDNE     'A'
     C     DDACTN        ANDNE     'E'
     C     DDACTN        ANDNE     'D'
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0200'     MsgIdArr(Ix)
     C                   ENDIF
 
      ** Error if Front Office Transaction ID is Blank
 
     C     FOTRID        IFEQ      *BLANK
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0201'     MsgIdArr(Ix)
     C                   GOTO      EVFRNT
     C                   ENDIF
 
      ** Access Non-A/C Holder with Front Office Transaction ID
 
     C     FOTRID        CHAIN     SDNAHFOI                           99
 
      ** If Insert
 
     C     DDACTN        IFEQ      'I'
 
      ** Front Office Transaction ID can't be present already
 
     C     *In99         IFEQ      *Off
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0202'     MsgIdArr(Ix)
     C                   MOVEL     FOTRID        MsgDtaArr(Ix)
     C                   GOTO      EVFRNT
     C                   ENDIF
 
     C                   ELSE
 
      ** If not Insert, Front Office Transaction ID must be present
 
     C     *In99         IFEQ      *On
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0203'     MsgIdArr(Ix)
     C                   MOVEL     FOTRID        MsgDtaArr(Ix)
     C                   GOTO      EVFRNT
     C                   ENDIF
 
      ** If not Insert, Update Midas Non-A/C Holder Reference
 
     C                   MOVEL     NHNAHO        DDNAHO
 
     C                   ENDIF
                                                                                              CGL132
      ** Access FATCA customer with Front office transaction ID                               CGL132
                                                                                              CGL132
     C     FOTRID        CHAIN     SDFTNHL2                           99                      CGL132
                                                                                              CGL132
      ** if insert                                                                            CGL132
                                                                                              CGL132
     C     DDACTN        IFEQ      'I'                                                        CGL132
                                                                                              CGL132
      ** Front office transaction ID can't be present already                                 CGL132
                                                                                              CGL132
     C     *IN99         IFEQ      '0'                                                        CGL132
     C                   MOVE      'N'           OKACTN                                       CGL132
     C                   ADD       1             Ix                                           CGL132
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                               CGL132
     C                   MOVEL     'APM0202'     MsgIdArr(Ix)                                 CGL132
     C                   MOVEL     FOTRID        MsgDtaArr(Ix)                                CGL132
     C                   GOTO      EVFRNT                                                     CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   ELSE                                                                 CGL132
                                                                                              CGL132
      ** If not insert, Front office transaction ID must be present                           CGL132
                                                                                              CGL132
     C     *IN99         IFEQ      '1'                                                        CGL132
     C                   MOVE      'N'           OKACTN                                       CGL132
     C                   ADD       1             Ix                                           CGL132
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                               CGL132
     C                   MOVEL     'APM0203'     MsgIdArr(Ix)                                 CGL132
     C                   MOVEL     FOTRID        MsgDtaArr(Ix)                                CGL132
     C                   GOTO      EVFRNT                                                     CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** If not insert, update Midas Non-A/C Holder Reference                                 CGL132
                                                                                              CGL132
     C                   MOVEL     NHNAHO        DDNAHO                                       CGL132
                                                                                              CGL132
     C                   ENDIF                                                                CGL132
 
     C     EVFRNT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRValcde - Validation of Action code
      *****************************************************************
     C     SRValcde      BEGSR
 
      ** Validate Action Code
 
      ** must be 'I','A','D' or 'E'
 
     C     DDACTN        IFNE      'I'
     C     DDACTN        ANDNE     'A'
     C     DDACTN        ANDNE     'D'
     C     DDACTN        ANDNE     'E'
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'SDA0001'     MsgIdArr(Ix)
     C                   ENDIF
 
      ** If enquiry, action code must be 'E' only.
 
     C                   IF        *In36 = *On
     C                   IF        DDACTN = 'A'  or
     C                             DDACTN = 'I'  or
     C                             DDACTN = 'D'
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'CSF9854'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
 
      ** Do not allow deletion if non-a/c holder is member of a joint account
 
     C     DDNAHO        CHAIN     SDJACCL7                           20
     C                   IF        DDACTN = 'D' and
     C                             *In20 = *Off
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'USR4788'     MsgIdArr(Ix)
     C                   ENDIF
 
     C     EVAL          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRValaci - Validation of Action Code 'I'
      *****************************************************************
     C     SRValaci      BEGSR
 
      ** Validate Non-A/C Holder Reference
 
     C                   CALLB     'SDVNAHL01'
      **                 ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      ** INPUTS :
      ** Return Code
      ** Non-A/C Holder Reference
      ** Error Field Name
 
     C                   PARM                    RetCodeOut
     C     NHNAHO        PARM                    DDNAHO
 
      ** OUTPUTS :
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** Non-A/C Holder Reference - OK
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Ix
     C                   PARM                    OKNAHO
 
     C     EVALAI        ENDSR
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      * RTVFTC - Retrieve FATCA customer details if CGL132 = 'Y'                              CGL132
      *****************************************************************                       CGL132
                                                                                              CGL132
     C     RTVFTC        BEGSR                                                                CGL132
                                                                                              CGL132
      ** Access FATCA customer details                                                        CGL132
                                                                                              CGL132
     C     DDNAHO        CHAIN     SDFTNHL1                           45                      CGL132
                                                                                              CGL132
      **  If insert and live record found - error                                             CGL132
                                                                                              CGL132
     C     DDACTN        IFEQ      'I'                                                        CGL132
                                                                                              CGL132
     C     *IN45         IFEQ      '0'                                                        CGL132
     C                   MOVEL     'N'           OKNAHO                                       CGL132
     C                   ADD       1             Ix                                           CGL132
     C                   MOVEL     'DDNAHO'      FldNameArr(Ix)                               CGL132
     C                   MOVEL     'Y2U0003'     MsgIdArr(Ix)                                 CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   CLEAR                   CuFaFilFmt                                   CGL132
     C                   EVAL      FNNAHO = DDNAHO                                            CGL132
     C                   EVAL      FNCLAC = SVal1                                             CGL132
     C                   EVAL      WCDESC = ' '                                            MD028786A
     C                   EVAL      WPDESC = ' '                                            MD028786A
                                                                                              CGL132
      ** Retrieve classification description                                                  CGL132
                                                                                              CGL132
     C**********         CALL      'AOFATCR0'                                       CGL132 MD028786A
     C**********         PARM      *BLANKS       @RTCD                              CGL132 MD028786A
     C**********         PARM      '*KEY    '    @OPTN                              CGL132 MD028786A
     C**********         PARM      FNCLAC        @CLAC                              CGL132 MD028786A
     C*****SDFATC        PARM      SDFATC        DSFDY                              CGL132 MD028786A
      **********                                                                    CGL132 MD028786A
      ***If*value*entered*by*user*is*not*found*on*the*FATCA*********                CGL132 MD028786A
      ***classification*code*file*then*return*an*error**************                CGL132 MD028786A
      **********                                                                    CGL132 MD028786A
     C**********         IF        @RTCD = '*NRF' OR                                CGL132 MD028786A
     C**********                   @RTCD <> *BLANKS                                 CGL132 MD028786A
     C**********         MOVEL     'N'           OKNAHO                             CGL132 MD028786A
     C**********         ADD       1             Ix                                 CGL132 MD028786A
     C**********         MOVEL     'DDNAHO'      FldNameArr(Ix)                     CGL132 MD028786A
     C**********         MOVEL     'USS0173'     MsgIdArr(Ix)                       CGL132 MD028786A
     C**********         ELSE                                                       CGL132 MD028786A
     C**********         EVAL      WCDESC = C_FCDESC                                CGL132 MD028786A
     C**********         ENDIF                                                      CGL132 MD028786A
                                                                                              CGL132
      **  If delete, amend or enquire                                                         CGL132
     C                   ELSE                                                                 CGL132
                                                                                              CGL132
      **  If record not found - ERROR                                                         CGL132
                                                                                              CGL132
     C     *IN45         IFEQ      '1'                                                        CGL132
     C                   MOVEL     'N'           OKNAHO                                       CGL132
     C                   ADD       1             Ix                                           CGL132
     C                   MOVEL     'DDNAHO'      FldNameArr(Ix)                               CGL132
     C                   MOVEL     'USS0172'     MsgIdArr(Ix)                                 CGL132
     C                   ELSE                                                                 CGL132
                                                                                              CGL132
     C                   IF        FNCLAC <> *BLANKS                                          CGL132
                                                                                              CGL132
      ** Retrieve classification description                                                  CGL132
                                                                                              CGL132
     C                   CALL      'AOFATCR0'                                                 CGL132
     C                   PARM      *BLANKS       @RTCD                                        CGL132
     C                   PARM      '*KEY    '    @OPTN                                        CGL132
     C                   PARM      FNCLAC        @CLAC                                        CGL132
     C     SDFATC        PARM      SDFATC        DSFDY                                        CGL132
                                                                                              CGL132
      ** If value entered by user is not found on the FATCA                                   CGL132
      ** classification code file then return an error                                        CGL132
                                                                                              CGL132
     C                   IF        @RTCD = '*NRF' OR                                          CGL132
     C                             @RTCD <> *BLANKS                                           CGL132
     C                   MOVEL     'N'           OKNAHO                                       CGL132
     C                   ADD       1             Ix                                           CGL132
     C                   MOVEL     'DDNAHO'      FldNameArr(Ix)                               CGL132
     C                   MOVEL     'USS0173'     MsgIdArr(Ix)                                 CGL132
     C                   ELSE                                                                 CGL132
     C                   EVAL      WCDESC = C_FCDESC                                          CGL132
     C                   ENDIF                                                                CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        FNPCLA <> *BLANKS                                          CGL132
      ** Retrieve classification description                                                  CGL132
                                                                                              CGL132
     C                   CALL      'AOFATCR0'                                                 CGL132
     C                   PARM      *BLANKS       @RTCD                                        CGL132
     C                   PARM      '*KEY    '    @OPTN                                        CGL132
     C                   PARM      FNPCLA        @CLAC                                        CGL132
     C     SDFATC        PARM      SDFATC        DSFDY                                        CGL132
                                                                                              CGL132
      ** If value entered by user is not found on the FATCA                                   CGL132
      ** classification code file then return an error                                        CGL132
                                                                                              CGL132
     C                   IF        @RTCD = '*NRF' OR                                          CGL132
     C                             @RTCD <> *BLANKS                                           CGL132
     C                   MOVEL     'N'           OKNAHO                                       CGL132
     C                   ADD       1             Ix                                           CGL132
     C                   MOVEL     'DDNAHO'      FldNameArr(Ix)                               CGL132
     C                   MOVEL     'USS0173'     MsgIdArr(Ix)                                 CGL132
     C                   ELSE                                                                 CGL132
     C                   EVAL      WPDESC = C_FCDESC                                          CGL132
     C                   ENDIF                                                                CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   ENDSR                                                                CGL132
                                                                                              CGL132
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRInit - Initialisation
      *****************************************************************
     C     SRInit        BEGSR
 
      ** Clear Outputs
 
     C                   CLEAR                   NahoFilFmt
     C                   CLEAR                   PCrsdF                                       CGL157
     C                   MOVEL     'Y'           OKACTN
     C                   MOVEL     'Y'           OKNAHO
     C                   EVAL      *In36 = @IN36
 
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      ** *INZSR - Initial Processing
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Parameters
 
     C     *ENTRY        PLIST
 
      ** INPUTS :
      ** Return code
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (NOT Front Office Transaction Interface)
      ** Response mode
      ** Action Code
      ** Front Office Transaction ID
      ** (Midas) Non-A/C Holder reference
 
     C                   PARM                    RetCodeIn
     C                   PARM                    ModeofOp
     C                   PARM                    RespMode
     C                   PARM                    DDACTN
     C                   PARM                    FOTRID
     C                   PARM                    DDNAHO
     C                   PARM                    @IN36
 
      ** OUTPUTS :
      ** (Current) Non-A/C Holder in file format
      ** OK - Action code
      ** OK - Non-A/C Holder reference
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    NahoFilFmt
     C                   PARM                    CuFaFilFmt                                   CGL132
     C                   PARM                    CuFoFilFmt                                   CGL132
     C                   PARM                    CuCrhFlFmt                                   CGL157
     C                   PARM                    PCrsdF                                       CGL157
     C                   PARM                    OKACTN
     C                   PARM                    OKNAHO
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Ix
 
      ** Initialize program name
 
     C                   MOVEL     'SDNAHLRTV'   DBPGM
 
      **  Get RUNDAT to access Multi-branching flag.
 
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
                                                                                              CGL132
     C     KEY1          KLIST                                                                CGL132
     C                   KFLD                    DDNAHO                                       CGL132
     C                   KFLD                    DDDATE                                       CGL132
     C                   KFLD                    DDSEQN                                       CGL132
                                                                                              CGL132
     C     KEY2          KLIST                                                                CGL132
     C                   KFLD                    DDNAHO                                       CGL132
     C                   KFLD                    DDCRTT                                       CGL132
                                                                                              CGL132
     C                   CLEAR                   CuFaFilFmt                                   CGL132
     C                   MOVEL     *BLANK        CuFoFilFmt                                   CGL132
     C                   CLEAR                   CuCrhFlFmt                                   CGL157
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                              CGL157
      ** Check if enhancement CGL157 is on                                                    CGL157
                                                                                              CGL157
     C                   CALLB     'AOSARDR0'                                                 CGL157
     C                   PARM      *BLANKS       @RTCD                                        CGL157
     C                   PARM      '*VERIFY'     @OPTN                                        CGL157
     C                   PARM      'CGL157'      PSARD                                        CGL157
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL157
                                                                                              CGL157
     C                   IF        @RTCD <> *BLANKS AND                                       CGL157
     C                             @RTCD <> '*NRF   '                                         CGL157
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGL157
     C                   EVAL      DBKEY  = 'CGL157'                                          CGL157
     C                   EVAL      DBASE  = 903                                               CGL157
     C                   EXSR      *PSSR                                                      CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   IF        @RTCD = *BLANKS                                            CGL157
     C                   EVAL      CGL157 = 'Y'                                               CGL157
     C                   ELSE                                                                 CGL157
     C                   EVAL      CGL157 = 'N'                                               CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL132
      ** Check if enhancement CGL132 is on                                                    CGL132
                                                                                              CGL132
     C                   CALLB     'AOSARDR0'                                                 CGL132
     C                   PARM      *BLANKS       @RTCD                                        CGL132
     C                   PARM      '*VERIFY'     @OPTN                                        CGL132
     C                   PARM      'CGL132'      PSARD                                        CGL132
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL132
                                                                                              CGL132
     C                   IF        @RTCD <> *BLANKS AND                                       CGL132
     C                             @RTCD <> '*NRF   '                                         CGL132
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGL132
     C                   EVAL      DBKEY  = 'CGL132'                                          CGL132
     C                   EVAL      DBASE  = 920                                               CGL132
     C                   EXSR      *PSSR                                                      CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        @RTCD = *BLANKS                                            CGL132
     C                   EVAL      CGL132 = 'Y'                                               CGL132
     C                   ELSE                                                                 CGL132
     C                   EVAL      CGL132 = 'N'                                               CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        CGL132 = 'Y'                                               CGL132
                                                                                              CGL132
     C                   CALL      'AOSVALR0'                                                 CGL132
     C                   PARM      *BLANKS       PRtcd                                        CGL132
     C                   PARM      SysVal1       SValK1                                       CGL132
     C                   PARM                    SVal1                                        CGL132
     C                   PARM                    SValK2                                       CGL132
     C                   PARM                    SVal2                                        CGL132
     C                   PARM                    SValK3                                       CGL132
     C                   PARM                    SVal3                                        CGL132
     C                   PARM                    SValK4                                       CGL132
     C                   PARM                    SVal4                                        CGL132
     C                   PARM                    SValK5                                       CGL132
     C                   PARM                    SVal5                                        CGL132
     C                   PARM                    SValK6                                       CGL132
     C                   PARM                    SVal6                                        CGL132
     C                   PARM                    SValK7                                       CGL132
     C                   PARM                    SVal7                                        CGL132
     C                   PARM                    SValK8                                       CGL132
     C                   PARM                    SVal8                                        CGL132
     C                   PARM                    SValK9                                       CGL132
     C                   PARM                    SVal9                                        CGL132
     C                   PARM                    SValK0                                       CGL132
     C                   PARM                    SVal10                                       CGL132
                                                                                              CGL132
     C                   IF        PRtcd <> *Blanks  AND                                      CGL132
     C                             PRtcd <> '*NRF   '                                         CGL132
     C                   EVAL      DBFILE = 'SDSVALPD'                                        CGL132
     C                   EVAL      DBKEY = SValK1                                             CGL132
     C                   EVAL      DBASE = 902                                                CGL132
     C                   EVAL      DBPGM = 'SDNAHLRTV'                                        CGL132
     C                   EXSR      *PSSR                                                      CGL132
     C                   ENDIF                                                                CGL132
     C                   ENDIF                                                                CGL132
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also DEFINEs LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2004
