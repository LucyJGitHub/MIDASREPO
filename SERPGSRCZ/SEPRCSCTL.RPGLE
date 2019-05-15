     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD
/*EXI *  TEXT('Midas SE Market prices interface controller')          *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEPRCSCTL - SE Market Prices Interface Controller            *
      *                                                               *
      *  Function: This Program Validates the Prices Input into the   *
      *            Midas database for valuation of Unrealised Profit, *
      *            Mark to Market revaluation and the overriding of   *
      *            system calculated Prices.                          *
      *            Even though no data is passed in the action code,  *
      *            the implied action code of this function is always *
      *            I (=Insert) = overwrite existing data if it        *
      *                          already exists for security.         *
      *            The decision as to whether to write to the Valid   *
      *            or Invalid file and the call to the Message        *
      *            Handler will take place in this module.            *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 233235             Date 03Oct06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL031             Date 05Jul04               *
      *                 CSE071             Date 19Jul05               *
      *                 229135             Date 27Sep04               *
      *                 BUG2812            Date 01Jun04               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSD010             Date 03May02               *
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 189506             Date 02Feb01               *
      *                 CSD006             Date 02Nov00               *
      *                 CAP060             Date 02May01               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CAP030  *CREATE    Date 23Feb99               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  233235 - Checking of switchable feature CGL031 was not done. *
      *           Note GEMS fix 233570 resolved an issue with 233235  *
      *           where wrong Return Code field was checked (i.e.     *
      *           PRetcode instead of PRtcd). That GEMS 233570 was    *
      *           included in this delivery under 233235.             *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL031 - Taxation on Savings Income                          *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  229135 - Credit risk spread not updated correctly.           *
      *  BUG2812 - Commitment Control Changes for MidasPlus (CSC022)  *
      *  CAS006 - Hedge Accounting Phase B                            *
      *  CSD010 - Collateralised Lending (Securities and FX Pricing)  *
      *  CSC011 - 24x7 Midas Availability                             *
      *  189506 - Securities Prices API could not update extel fields *
      *  CSD006 - Market Data Feed                                    *
      *  CAP060 - Conversion of Midas Screen Input Program into full  *
      *           API, including repair program which CAP030 does not *
      *           include                                             *
      *  CAP030 - API for SE Price input                              *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
      * Valid Prices Records
     FSEVPRCSPD UF A E             DISK    INFSR(*pssr)
     F                                     COMMIT
 
      * Valid EXTEL fields (written to when CAP060 is on)                                     CAP060
     FSEVEXVLPD UF A E             DISK    INFSR(*pssr)                                       CAP060
     F                                     COMMIT                                             CAP060
 
      * Valid Extra Data Price validation details
     FSEVPRXTPD UF A E             DISK    INFSR(*pssr)
     F                                     COMMIT
 
     FSEVPRCSL1 IF   E           K DISK    RENAME(SEVPRCSD0:SEVPRCSCHK)
     F                                     INFSR(*PSSR)                                       CAP060
     FSEVPRCSL0 IF   E           K DISK    RENAME(SEVPRCSD0:SEVPRCSCH0)                       CAP060
     F                                     INFSR(*PSSR)                                       CAP060
 
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
      * Invalid Transactions
     FSEIPRCSPD UF A E             DISK    INFSR(*pssr)                                       CAP060
     F                                     COMMIT                                             CAP060
                                                                                              CAP060
      ** Securities Details file                                                              CSC011
     FSECTY     IF   E           K DISK    INFSR(*PSSR)                                       CSC011
     F/COPY WNCPYSRC,SEH00126
                                                                                              CSC011
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,SEPRCSC001
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structure.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes definitions for thefields
      ** #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member.
     D/COPY ZACPYSRC,PROCPARMS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for arrays
      ** specific to API *CTL modules.
     D/COPY ZACPYSRC,APICTLARR
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** used in checking whether there are messages on the data queue.
     D/COPY ZACPYSRC,DTAQCHKDCL
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
 
      ** String for error messages to the operator
     D ProcErr         C                   CONST('Error in module')
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
                                                                                             BUG2812
     D WCmtJobArr      S             10A   DIM(10)                                           BUG2812
      ** Array for commitment job names                                                      BUG2812
 
      * Incoming Header
     D HeadIn        E DS                  EXTNAME(APHEADPD)
 
      * Incoming Price Record
     D TranIn        E DS                  EXTNAME(SEPRCSPD)
 
      * Valid Price layout
     D ValidPRCS     E DS                  EXTNAME(SEVPRCSPD)
     D                                     PREFIX(V_)                                         CAP060
 
      * Valid Extra Data Price validation details layout
     D ValidPRXT     E DS                  EXTNAME(SEVPRXTPD)
 
 
      * (Current) Price record in File Format
     D PRCSFilFmt    E DS                  EXTNAME(PRICE)
 
      * (Current) EXTEL Price record in File Format
     D*PRXTFilFmt****E DS                  EXTNAME(SEPRXTPD)                                  189506
 
 
      ** Flags to indicate whether Price fields are valid
     D OKFlagsDS     E DS                  EXTNAME(SEEPRCSPD)
 
 
      * Prices Extra Data - File (D/B) format
     D ExtData       E DS                  EXTNAME(SEPREXPD)
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * First DS for Access programs - short data structure
 
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)                                  CAP060
     D** Security Trading Detail                                                              CAP060
                                                                                              CAP060
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                                  CAP060
      ** Midas Modules details accessed via access program                                    CAP060
     D SDAPI         E DS                  EXTNAME(SDAPIPD)                                   CAP060
      ** External DS for API ICD                                                              CAP060
                                                                                              CAP060
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CAP060
                                                                                              CAP060
     D SCA_LCD       E                     EXTFLD(LCD)                                        CAP060
      ** EXTERNAL DS FOR SAR DETAILS                                                          CAP060
                                                                                              CAP060
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CAP060
      * Second DS for Access programs - long data structure                                   CAP060
      * (Current) Transaction in Screen Format - Main Details                                 CAP060
                                                                                              CAP060
     D CURTRPRCS     E DS                  EXTNAME(SEPRCSPD)                                  CAP060
     D                                     PREFIX(@)                                          CAP060
      ** New Extel Details in file format                                                     CAP060
     D VALIDEXTEL    E DS                  EXTNAME(SEVEXVLPD)                                 CAP060
                                                                                              CSC011
      ** 24x7 Status Data Area                                                                CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
                                                                                              CSC011
      ** SD Data Area                                                                         CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
                                                                                             BUG2812
     D SCCMTJOB      E DS           256    DTAARA(SCCMTJOB)                                  BUG2812
     D  ComitJob               4    103                                                      BUG2812
      ** Midas SC Jobs handling commitment control data area                                 BUG2812
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
 
      ** Field (500A) to receive the incoming Prices record
     D Trans500        S            500A
 
      ** Field (500A) to receive the incoming Extra Data
     D ExtData500      S            500A
 
      ** Index for arrays of error message ids etc in Amend validation
     D AmIdx           S              3P 0
 
      ** Indicies for arrays used to set up corresponding sequence numbers
      **  for the fields that are in error
     D Ix              S              3P 0
     D Iy              S              3P 0
 
      ** The transaction's status
     D TranStatus      S              1A
 
      ** Module ID, to be passed to the Message Handler
     D ModuleID        S              2A   INZ('SE')
 
      ** Timestamp for the transaction
     D TimeStamp       S               Z
 
      ** Fields for data area locking
     D Object          S             10A   INZ('SEPRCSUPC')
     D Lib             S             10A   INZ('*LIBL')
     D ObjType         S              7A   INZ('*DTAARA')
     D LockState       S              7A   INZ('*SHRRD')
     D Member          S             10A
     D WaitTime        S              6A   INZ('0     ')
     D Dlcobj          S              1A   INZ('Y')
     D Return          S              7A
 
      ** Parameters and work fields for ZAMSGTOOPR
     D LongError       S            132A
 
      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A
 
      ** Whether or not to clear the program message queue (this is not
      ** actually used, but is required by the message handler's parameter
      ** list.
     D ClrPgmMsgQ      S              1A   INZ('Y')
 
      ** Flags to indicate whether substitution is required in                                CAP060
      ** each of the various parts the transaction                                            CAP060
     D REPPRCS         S              1A   inz('N')                                           CAP060
                                                                                              CAP060
     D HPPRC           S                   LIKE(PPRC)                                         CAP060
     D FCR997          S                   LIKE(@CR997)                                       CAP060
                                                                                              CAP060
     D* Market Data Feed                                                                      CSD006
     D CSD006          S              1A                                                      CSD006
     D* Full Sec Prices API                                                                   CAP060
     D CAP060F         S              1A                                                      CAP060
                                                                                              CAP060
     D* Profit Centre Switchable Feature                                                      CAP060
     D CAC005          S              1A                                                      CAP060
                                                                                              CSC011
     D CSC011          S              1A                                                      CSC011
     D TRANSDTL        S           5800A                                                      CSC011
     D PDealNumber     S             18A                                                      CSC011
     D PADealNo        S             18A                                                      CSC011
     D PRetCode        S              7A                                                      CSC011
     D POption         S              7A                                                      CSC011
     D PKey            S              6A                                                      CSC011
 
     D CSD010          S              1A                                                      CSD010
     D HBDPR           S                   LIKE(PRBDPR)                                       CSD010
     D HOFPR           S                   LIKE(PROFPR)                                       CSD010
     D HCLPR           S                   LIKE(PRCLPR)                                       CSD010
                                                                                              CSD010
      ** Taxation on Savings Income                                                           CGL031
     D CGL031          S              1A                                                      CGL031
                                                                                              CGL031
      ** Parameter and work variable declarations                                             CGL031
     D PSARd           S              6A                                                      CGL031
     D PRtcd           S              7A                                                      CGL031
     D POptn           S              7A                                                      CGL031
                                                                                              CGL031
      ** Hedge Accounting Phase B Switchable Feature                                          CAS006
     D CAS006          S              1A                                                      CAS006
                                                                                             BUG2812
     D CSC022          S              1A                                                     BUG2812
                                                                                             BUG2812
     D WCommitSkip     S              1A                                                     BUG2812
      ** Commitment Skip Field                                                               BUG2812
                                                                                              CAS006
     D/COPY WNCPYSRC,SEH00127
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SEPRCSC002
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C     Start         TAG
      ** Note: the above tag is only there to force the first comments in
      ** the C-specs to appear after the D- or I-specs in compiled listings.
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      /COPY WNCPYSRC,SEPRCSC003
 
      * Incoming Price record is in a 500A field, so that a common CLP
      * can be used between this module and the one that read the MQ queue.
      * This module needs to break that 500A by loading it into the
      * appropriate (externally described) data structure.
     C                   MOVEL     Trans500      TranIn
     C                   MOVEL     Extdata500    Extdata
 
      ** Generate a timestamp for this transaction
 
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
 
      ** Reset variables gradually updated
 
     C                   EXSR      RESETCYCLE
 
      /COPY WNCPYSRC,SEPRCSC004
 
     C                   IF        CAP060F= 'Y'                                               CAP060
                                                                                              CAP060
      *  Check if Price record is valid - front office ID validation                          CAP060
                                                                                              CAP060
     C                   EXSR      CHKFRTPRCS                                                 CAP060
      *                                                                                       CAP060
      *  If valid Prices do exist (even after delay), fail this input                         CAP060
      *                                                                                       CAP060
     C     Idx           IFNE      0                                                          CAP060
     C                   GOTO      INVALID                                                    CAP060
     C                   ENDIF                                                                CAP060
     C                   ENDIF                                                                CAP060
 
      *  Check if Price record is valid
 
     C                   EXSR      ChkValPRCS
      *
      *  if valid Prices do exist (even after delay), fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   END
 
      * Reset variables again in case the details have been corrupted
      * by previous chain to valid prices file.
 
     C                   EXSR      RESETCYCLE
 
      /COPY WNCPYSRC,SEPRCSC005
 
      *  Validate Action Code
 
     C                   EXSR      ValidateAc
 
      * Call defaulting sub-routine                                                           CAP060
     C                   IF        CAP060F= 'Y'                                               CAP060
     C                   EXSR      SRDFT                                                      CAP060
     C                   ENDIF                                                                CAP060
      *
      /COPY WNCPYSRC,SEPRCSC006
 
      *  If error in validation of action code, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   END
 
      * Default in values for EXTEL fields if they have been omitted from the incoming        CAP060
      * message, CAP060 is on and the price type and extel fields are set accordingly         CAP060
     C                   IF        CAP060F= 'Y'                                               CAP060
     C                   IF           @DDPSRC<> *BLANKS AND                                   CAP060
     C                                DDPSRC = *BLANKS                                        CAP060
     C                   MOVEL     @DDPSRC       DDPSRC                                       CAP060
     C                   ENDIF                                                                CAP060
     C                   IF           @DDAPND<> *BLANKS AND                                   CAP060
     C                                DDAPND = *BLANKS                                        CAP060
     C                   MOVEL     @DDAPND       DDAPND                                       CAP060
     C                   ENDIF                                                                CAP060
     C                   IF           @DDLPRI<> *BLANKS AND                                   CAP060
     C                                DDLPRI = *BLANKS                                        CAP060
     C                   MOVEL     @DDLPRI       DDLPRI                                       CAP060
     C                   ENDIF                                                                CAP060
     C                   IF           @DDUPRI<> *BLANKS AND                                   CAP060
     C                                DDUPRI = *BLANKS                                        CAP060
     C                   MOVEL     @DDUPRI       DDUPRI                                       CAP060
     C                   ENDIF                                                                CAP060
     C                   IF           @DDPCEN<> *BLANKS AND                                   CAP060
     C                                DDPCEN = *BLANKS                                        CAP060
     C                   MOVEL     @DDPCEN       DDPCEN                                       CAP060
     C                   ENDIF                                                                CAP060
     C                   ENDIF                                                                CAP060
 
      ** Validate the main details of the transaction
 
      *  Processing depends upon Action Code
                                                                                              CAP060
     C                   SELECT                                                               CAP060
                                                                                              CAP060
     C                   WHEN         DDACTN = 'I'                                            CAP060
                                                                                              CAP060
      *  Processing for Inserts                                                               CAP060
      /COPY WNCPYSRC,SEPRCSC007
     C                   EXSR      ValidateTr
 
      /COPY WNCPYSRC,SEPRCSC008
                                                                                              CAP060
     C                   WHEN         DDACTN = 'A'                                            CAP060
     C                             OR DDACTN = 'D'                                            CAP060
                                                                                              CAP060
      *  Processing for Amends or Changes                                                     CAP060
      /COPY WNCPYSRC,SEPRCSC015                                                               CAP060
      * Check for the existence of the replacement character; If this is                      CAP060
      * used, only the changed data has been sent, and all occurrences of                     CAP060
      * the replacement character must be replaced with the corresponding                     CAP060
      * character from the original transaction.                                              CAP060
     C                   IF        DDACTN = 'A' AND GHSUBS <> *blank                          CAP060
                                                                                              CAP060
     C     GHSUBS        SCAN      TRANIN                                 99                  CAP060
     C                   IF        *in99                                                      CAP060
     C                   EVAL      REPPRCS = 'Y'                                              CAP060
     C                   EXSR      DtaSubs                                                    CAP060
     C                   ENDIF                                                                CAP060
                                                                                              CAP060
     C                   ENDIF                                                                CAP060
      **                 (End of "IF DDACTN = 'A' and GHSUBS <> *blank")                      CAP060
                                                                                              CAP060
     C                   EXSR      SetupAmd                                                   CAP060
      /COPY WNCPYSRC,SEPRCSC016                                                               CAP060
     C                   EXSR      ValidateTr                                                 CAP060
      /COPY WNCPYSRC,SEPRCSC017                                                               CAP060
                                                                                              CAP060
     C                   ENDSL                                                                CAP060
      *
     C     INVALID       TAG
 
      *  Check for exception error from any program lower in the stack
      *  If error detected, send message to system operator and
      *  return to calling program without updating database or
      ** prompting the database update program (LogError SR
      ** includes a RETURN).
     C                   IN        APDUMP
 
      /COPY WNCPYSRC,SEPRCSC009
 
     C                   IF        ARERRMOD <> *blank
     C                   EXSR      LogError
     C                   ENDIF
 
      *  Processing for Error checking/write to database
      /COPY WNCPYSRC,SEPRCSC010
     C                   EXSR      CheckWrite
 
      /COPY WNCPYSRC,SEPRCSC011
 
      ** If valid, send data queue entry to prompt DB update program
     C                   IF        Idx = 0
     C                   EXSR      SndPrompt
     C                   ENDIF
 
      **--------------------------------------------------------------------------------------------
      ** The return code is set in the following /COPY:
     C/COPY ZACPYSRC,SETRETCDE
      **--------------------------------------------------------------------------------------------
     C                   RETURN
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SEPRCSC012
 
      *****************************************************************
      /EJECT
      *****************************************************************                       CAP060
      *                                                               *                       CAP060
      * CHKFRTPRCS - Routine to check if valid security exists        *                       CAP060
      * for Front Office ID                                           *                       CAP060
      *                                                               *                       CAP060
      *****************************************************************                       CAP060
     C     CHKFRTPRCS    BEGSR                                                                CAP060
                                                                                              CAP060
      * Check for Secuirity on Valid file                                                     CAP060
     C     APFOTranID    CHAIN     SEVPRCSL0                          99                      CAP060
                                                                                              CAP060
      * If record found...                                                                    CAP060
     C     *IN99         IFEQ      '0'                                                        CAP060
                                                                                              CAP060
      * ..delay, then repeat check                                                            CAP060
     C                   CALLB     'ZACDELAY'                                                 CAP060
                                                                                              CAP060
     C     APFOTranId    CHAIN     SEVPRCSL0                          99                      CAP060
                                                                                              CAP060
      * Error if still present                                                                CAP060
     C     *IN99         IFEQ      '0'                                                        CAP060
     C                   ADD       1             Idx                                          CAP060
     C                   EVAL      FldNameArr(Idx) = 'DDPSSN'                                 CAP060
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'                                  CAP060
     C                   ENDIF                                                                CAP060
     C                   ENDIF                                                                CAP060
                                                                                              CAP060
     C                   ENDSR                                                                CAP060
      *****************************************************************                       CAP060
      /EJECT                                                                                  CAP060
      *****************************************************************
      *                                                               *
      * ChkValPRCS - Routine to check if valid Price record exits     *
      *              for security.                                    *
      *                                                               *
      *****************************************************************
 
     C     ChkValPRCS    BEGSR
 
      * Check for Prices record on Valid file
     C****************** MOVEL     DDPSSN        PRPSSN                                       CAP060
     C****************** MOVEL     DDPPRT        PRPPRT                                       CAP060
     C****************** MOVEL     DDPVDT        PRPVDT                                       CAP060
     C                   MOVEL     DDPSSN        V_PRPSSN                                     CAP060
     C                   MOVEL     DDPPRT        V_PRPPRT                                     CAP060
     C                   MOVEL     DDPVDT        V_PRPVDT                                     CAP060
     C     PRCSK1        CHAIN     SEVPRCSL1                          99
 
      * if record found...
     C     *IN99         IFEQ      '0'
 
      * ..delay, then repeat check
     C                   CALLB     'ZACDELAY'
 
     C     PRCSK1        CHAIN     SEVPRCSL1                          99
 
      * Error if still present
     C     *IN99         IFEQ      '0'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'PRPSSN'
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'
     C                   ENDIF
     C                   ENDIF
 
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CAP060
      *                                                               *                       CAP060
      * SRDFT      - Subroutine for defaulting EXVALD fields IF       *                       CAP060
      *              price type is 'V' and BVEXOP = 'Y'               *                       CAP060
      *                                                               *                       CAP060
      *****************************************************************                       CAP060
                                                                                              CAP060
     C     SRDFT         BEGSR                                                                CAP060
                                                                                              CAP060
     C                   CALLB     'SEPRCSDFT'                                                CAP060
      *                                                                                       CAP060
      * INPUTS                                                                                CAP060
      *                                                                                       CAP060
      * Return Code                                                                           CAP060
     C                   PARM                    RetCodeIn                                    CAP060
      ** Action Code                                                                          CAP060
     C                   PARM                    DDACTN            1                          CAP060
      ** Security Shortname                                                                   CAP060
     C                   PARM                    DDPSSN           10                          CAP060
      ** Price Type                                                                           CAP060
     C                   PARM                    DDPPRT            2                          CAP060
                                                                                              CAP060
      * Account in file format                                                                CAP060
     C                   PARM                    PRCSFilFmt                                   CAP060
      * ICD                                                                                   CAP060
     C                   PARM                    BVEXOP                                       CAP060
                                                                                              CAP060
      * OUTPUTS                                                                               CAP060
      * Screen Output                                                                         CAP060
      *                                                                                       CAP060
      ** Price Source                                                                         CAP060
     C                   PARM                    @DDPSRC                                      CAP060
      ** Auto-Price Indicator                                                                 CAP060
     C                   PARM                    @DDAPND                                      CAP060
      ** Lower Price Boundary                                                                 CAP060
     C                   PARM                    @DDLPRI                                      CAP060
      ** Upper Price Boundary                                                                 CAP060
     C                   PARM                    @DDUPRI                                      CAP060
      ** Percentage                                                                           CAP060
     C                   PARM                    @DDPCEN                                      CAP060
      *                                                                                       CAP060
      * Error fields/message IDs/message data (arrays) from/to caller                         CAP060
     C                   PARM                    FldNameArr                                   CAP060
     C                   PARM                    MsgIdArr                                     CAP060
     C                   PARM                    MsgDtaArr                                    CAP060
      * Array index (3P0) from/to caller                                                      CAP060
     C                   PARM                    IDX                                          CAP060
      ** Security shortname OK flag                                                           CAP060
     C                   PARM      *BLANK        DDSSNOK                                      CAP060
                                                                                              CAP060
     C                   ENDSR                                                                CAP060
      *****************************************************************
      *                                                               *
      * ValidateAc - Routine to validate action code versus the       *
      *              Security short name  supplied.                   *
      *              Implied action code is always 'I', therefore,    *
      *              simply validate that security exists.            *
      *****************************************************************
 
     C     ValidateAc    BEGSR
     C**Validate*action*code versus security short name supplied.                             CAP060
     C**The*Prices*record in file format from the SE database is                              CAP060
     C**retrieved*as*well.                                                                    CAP060
     C*******************                                                                     CAP060
     C*******************RESET                   ReturnCode                                   CAP060
     C*******************                                                                     CAP060
     C*******************CALLB     'SEPRCSRTV'                                                CAP060
     C*******************                                                                     CAP060
     C**INPUTS***********                                                                     CAP060
     C*******************                                                                     CAP060
     C**Return*code******                                                                     CAP060
     C*******************PARM                    ReturnCode                                   CAP060
     C*******************                                                                     CAP060
     C**Mode*=*'*FRONT'*(FRONT OFFICE TRANSACTION INTERFACE)                                  CAP060
     C*******************PARM      '*FRONT'      ModeofOp          6                          CAP060
     C*******************                                                                     CAP060
     C**Response*mode****                                                                     CAP060
     C*******************PARM                    APRESPMODE                                   CAP060
     C*******************                                                                     CAP060
     C**Action*Code******                                                                     CAP060
     C*******************PARM                    DDACTN                                       CAP060
     C*******************                                                                     CAP060
     C**Security*********                                                                     CAP060
     C*******************PARM                    DDPSSN                                       CAP060
     C*******************                                                                     CAP060
     C**Price*type*******                                                                     CAP060
     C*******************PARM                    DDPPRT                                       CAP060
     C*******************                                                                     CAP060
     C**OUTPUTS**********                                                                     CAP060
     C*******************                                                                     CAP060
     C**(Current)*Price*record in file format                                                 CAP060
     C*******************PARM                    PRCSFilFmt                                   CAP060
     C*******************                                                                     CAP060
     C**OK*-*Action*code*                                                                     CAP060
     C*******************PARM                    DDActnOK                                     CAP060
     C*******************                                                                     CAP060
     C**OK*-*Security****                                                                     CAP060
     C*******************PARM                    DDSSNOK                                      CAP060
     C*******************                                                                     CAP060
     C**OK*-*Price*Type**                                                                     CAP060
     C*******************PARM                    DDPRTOK                                      CAP060
     C*******************                                                                     CAP060
     C**Error*fields/message IDs/message data (arrays) from/to caller                         CAP060
     C*******************PARM                    FldNameArr                                   CAP060
     C*******************PARM                    MsgIDArr                                     CAP060
     C*******************PARM                    MsgDtaArr                                    CAP060
     C*******************                                                                     CAP060
     C**Array*index*(3P0) from/to caller                                                      CAP060
     C*******************PARM                    Idx                                          CAP060
                                                                                              CAP060
      *
      * Set retrieve mode to '*FRONT' (Access using Front Office ID)                          CAP060
      *  if insert                                                                            CAP060
      *  if not insert and Midas transaction ID is not present                                CAP060
      * Otherwise                                                                             CAP060
      *  Set retrieve mode to blank  (Access using Security shortname).                       CAP060
      *                                                                                       CAP060
      ** Check for the existence of the replacement character at the                          CAP060
      ** Transaction Id level.                                                                CAP060
     C                   IF        CAP060F = 'Y'                                              CAp060
     C                   IF        GHSUBS <> *blank                                           CAP060
     C     GHSUBS        SCAN      DDPSSN        SubForTRNN        2 0                        CAP060
     C                   ENDIF                                                                CAP060
                                                                                              CAP060
     C     DDACTN        IFEQ      'I'                                                        CAP060
     C                   MOVEL     '*FRONT'      ModeofOp                                     CAP060
     C                   ELSE                                                                 CAP060
     C     DDPSSN        IFEQ      *BLANK                                                     CAP060
     C     SubForTRNN    ORNE      0                                                          CAP060
     C                   MOVEL     '*FRONT'      ModeofOp                                     CAP060
     C                   ELSE                                                                 CAP060
     C                   MOVEL     '      '      ModeofOp                                     CAP060
     C                   ENDIF                                                                CAP060
     C                   ENDIF                                                                CAP060
     C                   ELSE                                                                 CAP060
     C                   MOVEL     '*FRONT'      ModeofOp                                     CAP060
     C                   ENDIF                                                                CAP060
                                                                                              CAP060
      * Validate action code versus security short name supplied.                             CAP060
      * The Prices record in file format from the SE database is                              CAP060
      * retrieved as well.                                                                    CAP060
                                                                                              CAP060
     C                   RESET                   ReturnCode                                   CAP060
     C                                                                                        CAP060
     C                   CALLB     'SEPRCSRTV'                                                CAP060
     C*                                                                                       CAP060
     C* INPUTS                                                                                CAP060
     C*                                                                                       CAP060
     C* Return code                                                                           CAP060
     C                   PARM                    ReturnCode                                   CAP060
     C*                                                                                       CAP060
     C* Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)                                  CAP060
     C* MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)                              CAP060
     C*                                                                                       CAP060
     C                   PARM                    MODEOFOP          6                          CAP060
     C*                                                                                       CAP060
     C* Response mode                                                                         CAP060
     C                   PARM                    APRESPMODE                                   CAP060
     C*                                                                                       CAP060
     C* Front Office Transaction ID                                                           CAP060
     C                   PARM                    APFOTRANID                                   CAP060
     C*                                                                                       CAP060
     C* Action Code                                                                           CAP060
     C     @DDACTN       PARM                    DDACTN            1                          CAP060
     C*                                                                                       CAP060
     C* Security                                                                              CAP060
     C     @DDPSSN       PARM                    DDPSSN           10                          CAP060
     C*                                                                                       CAP060
     C* Customer Shortname                                                                    CAP060
     C     @DDPCNM       PARM                    DDPCNM           10                          CAP060
     C*                                                                                       CAP060
     C* Market                                                                                CAP060
     C     @DDPMKT       PARM                    DDPMKT            1                          CAP060
     C*                                                                                       CAP060
     C* Branch                                                                                CAP060
     C     @DDPBRA       PARM                    DDPBRA            3                          CAP060
     C*                                                                                       CAP060
     C* Book                                                                                  CAP060
     C     @DDPBOK       PARM                    DDPBOK            2                          CAP060
     C*                                                                                       CAP060
     C* Profit Centre                                                                         CAP060
     C     @DDPRFC       PARM                    DDPRFC            4                          CAP060
     C*                                                                                       CAP060
     C* Price Type                                                                            CAP060
     C     @DDPPRT       PARM                    DDPPRT            2                          CAP060
     C*                                                                                       CAP060
     C* Portfolio Reference                                                                   CAP060
     C     @DDPTFR       PARM                    DDPTFR            4                          CAP060
     C* ICD                                                                                   CAP060
     C* Extel Indicator                                                                       CAP060
     C                   PARM                    BVEXOP                                       CAP060
     C*                                                                                       CAP060
     C* OUTPUTS                                                                               CAP060
     C*                                                                                       CAP060
     C* (Current) deal in file format                                                         CAP060
     C                   PARM                    PRCSFilFmt                                   CAP060
     C* If CAC005 is on, this is the book code the user entered on the screen (file format)   CAP060
     C                   PARM                    PBCD              2                          CAP060
     C* If CAC005 is on, this is the pseudo book ( the book stored on file on PRICED )        CAP060
     C* If CAC005 is off, this is the book the user entered on the screen (file format)       CAP060
     C                   PARM                    PBOK              2                          CAP060
     C* profit centre, in file format                                                         CAP060
     C                   PARM                    PRFC              4                          CAP060
      * Customer number in file format                                                        CAP060
     C                   PARM                    PCNM                                         CAP060
     C* Current Price retrieved, depending on price type                                      CAP060
     C                   PARM                    DDCURP           16                          CAP060
     C*                                                                                       CAP060
     C* OK - Action code                                                                      CAP060
     C                   PARM                    DDACTNOK                                     CAP060
     C*                                                                                       CAP060
     C* OK - Security                                                                         CAP060
     C                   PARM                    DDSSNOK                                      CAP060
     C*                                                                                       CAP060
     C* OK - Customer Shortname                                                               CAP060
     C                   PARM                    DDPCNMOK                                     CAP060
     C*                                                                                       CAP060
     C* OK - Market                                                                           CAP060
     C                   PARM                    DDPMKTOK                                     CAP060
     C*                                                                                       CAP060
     C* OK - Branch                                                                           CAP060
     C                   PARM                    DDPBRAOK                                     CAP060
     C*                                                                                       CAP060
     C* OK - Book                                                                             CAP060
     C                   PARM                    DDPBOKOK                                     CAP060
     C*                                                                                       CAP060
     C* OK - Profit Centre                                                                    CAP060
     C                   PARM                    DDPRFCOK                                     CAP060
     C*                                                                                       CAP060
     C* OK - Price Type                                                                       CAP060
     C                   PARM                    DDPRTOK                                      CAP060
     C*                                                                                       CAP060
     C* OK - Portfolio Reference                                                              CAP060
     C                   PARM                    DDPTFROK                                     CAP060
     C                                                                                        CAP060
     C* Error fields/message IDs/message data (arrays) from/to caller                         CAP060
     C                   PARM                    FldNameArr                                   CAP060
     C                   PARM                    MsgIdArr                                     CAP060
     C                   PARM                    MsgDtaArr                                    CAP060
     C*                                                                                       CAP060
     C** Warnings                                                                             CAP060
     C*                                                                                       CAP060
     C                   PARM                    WFldNamArr                                   CAP060
     C                   PARM                    WMsgIdArr                                    CAP060
     C                   PARM                    WMsgDtaArr                                   CAP060
     C*                                                                                       CAP060
     C* Array index (3P0) from/to caller                                                      CAP060
     C                   PARM                    Idx                                          CAP060
     C                   PARM                    WIdx                                         CAP060
     C                   PARM      FCR997        @CR997            4                          CAP060
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateTr - Routine to validate the main Prices details      *
      *                                                               *
      *****************************************************************
 
     C     ValidateTr    BEGSR
 
     C                   EXSR      SRMVVL                                                     CAP060
     C                   CALLB     'SEPRCSVAL'
      * Response mode (1A), from source system common header
     C                   PARM                    APRespMode
      * Transaction information (DS) from source system
     C                   PARM                    TranIn
     C                   PARM                    ExtData
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKFlagsDS
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx
      * Valid Prices layout (DS) from/to caller
     C                   PARM                    ValidPRCS
     C                   PARM                    VALIDEXTEL                                   CAP060
     C                   PARM                    ValidPRXT
     C                   PARM                    HPPRC                                        CAP060
      * CAC005 switchable feature on (Y / N)
     C                   PARM                    CAC005                                       CAP060
                                                                                              CGL031
      ** Taxation on Savings Income                                                           CGL031
                                                                                              CGL031
     C                   PARM                    CGL031                                       CGL031
 
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SndPrompt - Send a message to prompt the database updater     *
      *                                                               *
      *****************************************************************
 
     C     SndPrompt     BEGSR
 
      ** Check If update program active using Allocate Object API
      ** No prompting necessary if program is running
     C                   CLEAR                   Return
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockState
     C                   PARM                    Member
     C                   PARM                    WaitTime
     C                   PARM                    Dlcobj
     C                   PARM                    Return
 
     C                   IF        Return = *blank
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes a check for whether there
      ** are messages on the server/updater data queue, and sends a 'GO'.
      ** message to the data queue IF there are not.
     D/COPY ZACPYSRC,DTAQCHK
      **--------------------------------------------------------------------------------------------
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Check/Write - Routine to control checking of error status and *
      *    sending of messages/writing to the database                *
      *                                                               *
      *****************************************************************
 
     C     CheckWrite    BEGSR
 
      *  if no errors were found:
      *   - set up additional data
      *   - write a record to the Valid file
      *   - use std message handler to report Price record status
      *  if any errors were found:
      *  - write a record to the Invalid file
      *  - call the message handler to pass the errors back
      *  - use std message handler to report Price record status
      *  The index to the error arrays is checked for presence/absence of
      *   errors
     
      ** +--- Note for a later release -------------------------------+
      ** |                                                            |
      ** | At a later date this routine will have to cater for        |
      ** | warning messages.  The following logic will have to be     |
      ** | inserted before "If no errors were found", in the          |
      ** | above comments (and the code):                             |
      ** |                                                            |
      ** | if 'Ignore warning messages' (from API ICD) is 'N', AND    |
      ** | any warning messages were returned (WIdx <> 0)             |
      ** |                                                            |
      ** | -   if errors exist                                        |
      ** |     -     Add the warning array index to the error array   |
      ** |           index                                            |
      ** |     -     Append the contents of the warning arrays to the |
      ** |           end of the error arrays                          |
      ** | -   Else                                                   |
      ** |     -     Set the error array index equal to the warning   |
      ** |           array index                                      |
      ** |     -     Copy the contents of the warning arrays to the   |
      ** |           error arrays                                     |
      ** | -   ENDIF                                                  |
      ** |                                                            |
      ** | ENDIF                                                      |
      ** |                                                            |
      ** | Note that the "If errors exist ... Else ... " block above  |
      ** | can probably be implemented unconditionally (ie the same   |
      ** | logic will apply whether errors exist as well as warnings  |
      ** | or not).  It is shown in the above form for clarity.       |
      ** |                                                            |
      ** +------------------------------------------------------------+
 
     C     Idx           IFEQ      0
     C                   EXSR      SETUPVALID
     C                   WRITE     SEVPRCSD0
     C                   IF        CAP060F= 'N'                                               CAP060
     C                   WRITE     SEVPRXTD0
     C                   ELSE                                                                 CAP060
     C                   WRITE     SEVEXVLD0                                                  CAP060
     C                   ENDIF                                                                CAP060
     C                   EXSR      CallMsgHdl
     C                   ENDIF
 
     C     Idx           IFGT      0
     C                   EVAL      TranStatus = 'F'
 
      * When CAP060 is off...                                                                 CAP060
      * N.B. Repair location is front office for Prices.
      * Therefore, do NOT write to invalid files.
      *
      * Execute message handling routine.
 
      * When CAP060 is on ...                                                                 CAP060
      * Repair location will depend on what has been specified on the header                  CAP060
      *                                                                                       CAP060
     C                   IF        CAP060F= 'Y'                                               CAP060
     C                   EXSR      SETUPINVAL                                                 CAP060
      *                                                                                       CAP060
      * Only write to invalid files if repair in back office                                  CAP060
     C                   IF        APRprLocn = 'B'                                            CAP060
                                                                                              CAP060
     C                   WRITE     SEIPRCSD0                                                  CAP060
                                                                                              CSC011
      ** If CSC011 is installed and user is in the support system                             CSC011
      ** Write a record in APLOGTRAN                                                          CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y' and S1SUPP = LIBR                             CSC011
                                                                                              CSC011
     C     DDPSSN        CHAIN     SECTY                              01                      CSC011
     C                   IF        *IN01 = *Off                                               CSC011
     C                   EVAL      APFOTRANID = SPID                                          CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   EVAL      TRANSDTL = TranIn + ExtData                                CSC011
     C                   EVAL      APTGTTYPE = 'SEPRCS'                                       CSC011
                                                                                              CSC011
     C                   CALLB     'APLOGTRAN'                                                CSC011
     C                   PARM      *BLANKS       RetCodeOut                                   CSC011
     C                   PARM                    HeadIn                                       CSC011
     C                   PARM                    TRANSDTL                                     CSC011
     C                   PARM                    TimeStamp                                    CSC011
     C                   PARM                    PDealNumber                                  CSC011
     C                   PARM      *BLANKS       PADealNo                                     CSC011
                                                                                              CSC011
     C                   IF        RetCodeOut <> *Blanks                                      CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBFILE = 'APLOGTRAN'                                       CSC011
     C                   EVAL      DBKEY = PDealNumber                                        CSC011
     C                   EVAL      DBASE = 3                                                  CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CAP060
     C                   ENDIF                                                                CAP060
     C                   ENDIF                                                                CAP060
 
     C                   EXSR      CallMsgHdl
     C                   ENDIF
 
     C                   If        (CSC022 <> 'Y')                                           BUG2812
     C                             or (CSC022 = 'Y' and WCommitSkip <> 'Y')                  BUG2812
     C                   COMMIT
     C                   EndIf                                                               BUG2812
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *                       CAP060
      * SETUPINVAL - Set up additional fields that are needed on the  *                       CAP060
      *        Valid file record.                                     *                       CAP060
      *                                                               *                       CAP060
      *****************************************************************                       CAP060
                                                                                              CAP060
     C     SETUPINVAL    BEGSR                                                                CAP060
                                                                                              CAP060
      * Include Header fields that need to be o/p to the Invalid files                        CAP060
     C                   EVAL      DDFOtranID = APFOTranID                                    CAP060
     C                   EVAL      DDFOAsocID = APFOAsocID                                    CAP060
     C                   EVAL      DDRprLocn  = APRprLocn                                     CAP060
     C                   EVAL      DDTMESTMP = TimeStamp                                      CAP060
                                                                                              CAP060
     C                   EVAL      TranStatus = 'F'                                           CAP060
                                                                                              CAP060
     C                   ENDSR                                                                CAP060
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RESETCYCLE- Reset error information that is gradually         *
      *    updated during each run of this program                    *
      *                                                               *
      *****************************************************************
     C     RESETCYCLE    BEGSR
 
     C                   RESET                   FldNameArr
     C                   RESET                   MsgIDArr
     C                   RESET                   MsgDtaArr
     C                   RESET                   Idx
 
     C                   RESET                   WFldNamArr
     C                   RESET                   WMsgIDArr
     C                   RESET                   WMsgDtaArr
     C                   RESET                   WIdx
 
     C                   RESET                   AmFldNamAr
     C                   RESET                   AmMsgIDArr
     C                   RESET                   AmMsgDtaAr
     C                   RESET                   AmIdx
 
     C                   RESET                   FldNoArr
 
     C                   MOVE      *ALL'Y'       OKFlagsDS
 
     C                   CLEAR                   ValidPRCS
     C                   CLEAR                   ValidPRXT
 
     C                   CLEAR                   VALIDEXTEL                                   CAP060
     C                   CLEAR                   CURTRPRCS                                    CAP060
 
      * Output only fields                                                                    CAP060
     C                   EVAL      DDCURP = *BLANKS                                           CAP060
     C                   EVAL      DDPSRC = *BLANKS                                           CAP060
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPVALID - Set up additional fields that are needed on the  *
      *    Valid file record.                                         *
      *                                                               *
      *****************************************************************
 
     C     SETUPVALID    BEGSR
 
      * Include Header fields that need to be o/p to the Valid file
     C                   EVAL      PRTMESTMP = TimeStamp
     C                   EVAL      XTTMESTMP = TimeStamp
     C                   EVAL      EXVMESTMP = TimeStamp                                      CAP060
 
      * Set Valid file field(s) that are needed for all Action Codes
     C                   MOVE      'D'           PRRECI                                       CAP060
     C                   MOVE      DDACTN        PRCHTP                                       CAP060
     C                   MOVE      DDPSSN        PRPSSN                                       CAP060
     C                   MOVE      V_PRPPRT      PRPPRT                                       CAP060
     C                   MOVE      V_PRPVDT      PRPVDT                                       CAP060
     C                   MOVE      V_PRPCNM      PRPCNM                                       CAP060
     C                   MOVE      V_PRPMKT      PRPMKT                                       CAP060
     C                   MOVE      V_PRPBRA      PRPBRA                                       CAP060
     C                   MOVE      V_PRPBOK      PRPBOK                                       CAP060
     C                   MOVE      V_PRPPRC      PRPPRC                                       CAP060
     C                   MOVE      V_PRPNTV      PRPNTV                                       CAP060
     C                   MOVE      V_PRLCD       PRLCD                                        CAP060
     C                   MOVE      V_PRCHTP      PRCHTP                                       CAP060
     C                   MOVE      V_PRTNLU      PRTNLU                                       CAP060
     C                   MOVE      V_PRPSRC      PRPSRC                                       CAP060
     C                   MOVE      V_PRPBWN      PRPBWN                                       CAP060
     C                   MOVE      V_PRPPWN      PRPPWN                                       CAP060
     C                   MOVE      V_PRPTFR      PRPTFR                                       CAP060
     C                   MOVE      V_PRNPXR      PRNPXR                                       CAP060
     C                   MOVE      V_PRNPMD      PRNPMD                                       CAP060
     C                   MOVE      V_PRPBCD      PRPBCD                                       CAP060
     C                   MOVE      V_PRPRFC      PRPRFC                                       CAP060
     C                   MOVE      V_PRDFTS      PRDFTS                                       CAP060
     C                   MOVE      V_PRFRNT      PRFRNT                                       CAP060
     C                   MOVE      V_PRAFRT      PRAFRT                                       CAP060
     C                   MOVE      V_PRREPA      PRREPA                                       CAP060
     C                   MOVE      V_PRDTFR      PRDTFR                                       CAP060
     C                   MOVE      V_PRTLEX      PRTLEX                                       CAP060
                                                                                              CGL031
     C                   IF        CGL031 = 'Y'                                               CGL031
     C                   EVAL      PRPEXI = V_PRPEXI                                          CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CAS006
      ** If Hedge Accounting Phase B is installed. move Credit Risk                           CAS006
      ** Spread and Liquidity Premium fields to Price Valid File.                             CAS006
                                                                                              CAS006
     C**********         IF        CAS006 = 'Y' AND (PPRT = 'V'                        CAS006 229135
     C**********                   OR PPRT = 'DT' OR PPRT = 'DV')                      CAS006 229135
     C                   IF        CAS006 = 'Y' AND (V_PRPPRT = 'V'                           229135
     C                             OR V_PRPPRT = 'DT' OR V_PRPPRT = 'DV')                     229135
     C                   EVAL      PRCRSK = V_PRCRSK                                          CAS006
     C                   EVAL      PRLQPR = V_PRLQPR                                          CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CSD010
     C                   IF        CSD010 = 'Y'                                               CSD010
     C                   MOVE      V_PRBDPR      PRBDPR                                       CSD010
     C                   MOVE      V_PROFPR      PROFPR                                       CSD010
     C                   MOVE      V_PRCLPR      PRCLPR                                       CSD010
     C                   ENDIF                                                                CSD010
                                                                                              CAP060
      * Include Header fields that need to be o/p to the Valid file                           CAP060
     C                   EVAL      PRFRNT = APFOTranID                                        CAP060
     C                   EVAL      PRAFRT = APFOAsocID                                        CAP060
     C                   EVAL      PRREPA = APRprLocn                                         CAP060
 
     C                   EVAL      TranStatus = 'S'
 
      /COPY WNCPYSRC,SEPRCSC013
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * LogError - Send a message to the system operator for invalid  *
      *            transactions, and exit.                            *
      *                                                               *
      *****************************************************************
     C     LogError      BEGSR
 
      ** Set up the message to send to the operator
     C                   CLEAR                   LongError
     C                   RESET                   ReturnCode
     C                   EVAL      LongError = ProcErr + '   ' + ARERRMOD
 
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    ReturnCode
     C                   PARM                    LongError
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
 
      ** Indicate the failing module to the caller
     C                   EVAL      APRETCODE = ARERRMOD
 
      ** Remove the failing module's details from the dump information
      ** data area.
     C     *LOCK         IN        APDUMP
     C                   CLEAR                   ARERRMOD
     C                   OUT       APDUMP
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CallMsgHdl - Call the Message Handling module                 *
      *                                                               *
      *****************************************************************
     C     CallMsgHdl    BEGSR
 
      ** Set up an array of sequence numbers that correspond to the fields
      **  with errors
 
     C                   Z-ADD     1             Ix
     C                   DO        ArrayMax
 
     C     FldNameArr(Ix)IFNE      *BLANKS
 
     C                   Z-ADD     1             Iy
     C     FldNameArr(Ix)LOOKUP    FieldArr(Iy)                           20
     C                   EVAL      FldNoArr(Ix) = FldSeqArr(Iy)
 
     C                   ELSE
 
     C                   LEAVE
 
     C                   ENDIF
 
     C                   ADD       1             Ix
     C                   ENDDO
 
     C                   RESET                   ReturnCode
 
     C                   MOVE      *BLANKS       CCY6A
     C                   MOVEL     DDPSSN        CCY6A             6
 
     C                   CALLB     'ZAMSGHNDLE'
      ** Return code (10A, returned to this procedure)
     C                   PARM                    ReturnCode
      ** Repair location (1A, from caller)
     C                   PARM                    APRprLocn
      ** Confirm validity to front office (1A, from caller)
     C                   PARM                    APCnfValFO
      ** List of messages (Array of <ArrayMax>x7A message ids - from caller )
     C                   PARM                    MsgIDArr
      ** List of field numbers (Array of <ArrayMax>x2 unsigned integers - from caller)
     C                   PARM                    FldNoArr
      ** List of field names (Array of <ArrayMax>x10A names - from caller)
     C                   PARM                    FldNameArr
      ** List of message data entries (Array of <ArrayMax>x45 - from caller)
     C                   PARM                    MsgDtaArr
      ** Front office transaction identifier (20A, from caller)
     C*******************PARM      *BLANKS       APFOTranID                                   CAP060
     C                   PARM                    APFOTranID                                   CAP060
      ** Midas module ID (2A)                                                                 CAP060
     C                   Parm                    ModuleID                                     CAP060
      ** Midas transaction ID (6A, from caller)                                               CAP060
     C                   PARM                    CCY6A                                        CAP060
      ** Message file (10A, from caller)                                                      CAP060
     C                   PARM                    #MsgFile                                     CAP060
      ** Action code of transaction (1A, from transaction)                                    CAP060
     C                   PARM                    DDACTN                                       CAP060
      ** Status of transaction (1A, F=Failure, S=Success)                                     CAP060
     C                   PARM                    TranStatus                                   CAP060
      ** Response mode (1A, from caller (A=Asynchronous, S=Synchronous))
     C                   PARM                    APRespMode
      ** The following three parameters are needed when messages are to
      ** be displayed on a screen
      ** Screen-handling program (10A, from caller)
     C                   PARM                    #ProcPgm
      ** Screen-handling module (10A, from caller)
     C                   PARM                    #ProcMod
      ** Screen-handling procedure (10A, from caller)
     C                   PARM                    #ProcName
      ** The MQSeries queue to send replies to
     C                   PARM                    APRpyQueue
      ** The transaction's timestamp
     C                   PARM                    TimeStamp
      ** Additional message files to check (Array of <MsgFArrMax> x 10)
     C                   PARM                    MsgFArray
      ** Whether or not to clear the program message queue (1A)
     C                   PARM                    ClrPgmMsgQ
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CAP060
      *                                                               *                       CAP060
      * DtaSubs - Data Substitution                                   *                       CAP060
      *                                                               *                       CAP060
      *****************************************************************                       CAP060
                                                                                              CAP060
     C     DtaSubs       begsr                                                                CAP060
                                                                                              CAP060
      ** Convert file fields to screen format                                                 CAP060
     C                   reset                   ReturnCode                                   CAP060
     C                   CALLB     'SEPRCSCVT'                                                CAP060
      *                                                                                       CAP060
      * INPUTS                                                                                CAP060
      *                                                                                       CAP060
      * Return Code                                                                           CAP060
     C                   PARM                    DDSTS             8                          CAP060
     C                   PARM      *BLANK        ReturnCode                                   CAP060
      *                                                                                       CAP060
      * Deal in file format                                                                   CAP060
     C                   PARM                    PRCSFilFmt                                   CAP060
      * If CAC005 is on, this is the pseudo book ( the book stored on file on PRICED )        CAP060
      * If CAC005 is off, this is the book the user entered on the screen (file format)       CAP060
     C                   PARM                    PBOK                                         CAP060
                                                                                              CGL031
      ** Taxation on Savings Income                                                           CGL031
                                                                                              CGL031
     C                   PARM                    CGL031                                       CGL031
      *                                                                                       CAP060
      * OUTPUTS                                                                               CAP060
      *                                                                                       CAP060
      * Deal in screen format                                                                 CAP060
     C                   PARM                    CURTRPRCS                                    CAP060
     C                   PARM                    HPPRC                                        CAP060
                                                                                              CSD010
      ** Switchable feature CSD010 parameters                                                 CSD010
     C                   PARM                    HBDPR                                        CSD010
     C                   PARM                    HOFPR                                        CSD010
     C                   PARM                    HCLPR                                        CSD010
     C                   PARM                    CSD010                                       CSD010
 
     C                   EVAL      DDCURP = @DDCURP                                           CAP060
      *                                                                                       CAP060
      ** Substitute the data for the various parts of the transaction,                        CAP060
      ** dependent on the flags that were set earlier.                                        CAP060
                                                                                              CAP060
     C                   IF        REPPRCS = 'Y'                                              CAP060
                                                                                              CAP060
     C                   clear                   IncData                                      CAP060
     C                   clear                   CurData                                      CAP060
     C                   RESET                   ReturnCode                                   CAP060
     C                   CALLB     'APDTASUBS'                                                CAP060
      * Return Code                                                                           CAP060
     C                   PARM                    ReturnCode                                   CAP060
      * Substitution character                                                                CAP060
     C                   PARM                    GHSUBS                                       CAP060
      * Incoming Data                                                                         CAP060
     C                   PARM      TRANIN        IncData        2000                          CAP060
      * Current Data                                                                          CAP060
     C                   PARM      CURTRPRCS     CurData        2000                          CAP060
                                                                                              CAP060
     C                   MOVEL     IncDATA       TRANIN                                       CAP060
                                                                                              CAP060
     C                   ENDIF                                                                CAP060
                                                                                              CAP060
     C                   ENDSR                                                                CAP060
                                                                                              CAP060
      *****************************************************************                       CAP060
      /EJECT                                                                                  CAP060
      *****************************************************************                       CAP060
      *                                                               *                       CAP060
      * SETUPAMD - Set up fields that are needed in the validation    *                       CAP060
      *    of amendments and changes.                                 *                       CAP060
      *                                                               *                       CAP060
      *****************************************************************                       CAP060
     C     SetupAmd      BEGSR                                                                CAP060
                                                                                              CAP060
      *                                                                                       CAP060
      * Call program to fill screen fields with data from FXDEALPP                            CAP060
      *                                                                                       CAP060
     C                   CALLB     'SEPRCSCVT'                                                CAP060
      *                                                                                       CAP060
      * INPUTS                                                                                CAP060
      *                                                                                       CAP060
      * Return Code                                                                           CAP060
     C                   PARM                    DDSTS                                        CAP060
     C                   PARM      *BLANK        ReturnCode                                   CAP060
      *                                                                                       CAP060
      * Deal in file format                                                                   CAP060
     C                   PARM                    PRCSFilFmt                                   CAP060
      * If CAC005 is on, this is the pseudo book ( the book stored on file on PRICED )        CAP060
      * If CAC005 is off, this is the book the user entered on the screen (file format)       CAP060
     C                   PARM                    PBOK                                         CAP060
                                                                                              CGL031
      ** Taxation on Savings Income                                                           CGL031
                                                                                              CGL031
     C                   PARM                    CGL031                                       CGL031
      *                                                                                       CAP060
      * OUTPUTS                                                                               CAP060
      *                                                                                       CAP060
      * Deal in screen format                                                                 CAP060
     C                   PARM                    CURTRPRCS                                    CAP060
     C                   PARM                    HPPRC                                        CAP060
                                                                                              CSD010
      ** Switchable feature CSD010 parameters                                                 CSD010
     C                   PARM                    HBDPR                                        CSD010
     C                   PARM                    HOFPR                                        CSD010
     C                   PARM                    HCLPR                                        CSD010
     C                   PARM                    CSD010                                       CSD010
      *                                                                                       CAP060
     C                   EVAL      DDCURP = @DDCURP                                           CAP060
     C                   ENDSR                                                                CAP060
      *****************************************************************                       CAP060
      * SRMVVL - MOVE DATABASE FIELDS TO VALID FILE                                           CAP060
      *****************************************************************                       CAP060
     C     SRMVVL        BEGSR                                                                CAP060
      * Usually, the move of data from the data base file to the valid file                   CAP060
      * can be done in one step:                                                              CAP060
      **                                                                                      CAP060
      ***   e.g.,      MOVEL     CrDlFilFmt    NwDlFilFmt                                     CAP060
      **                                                                                      CAP060
      * However, if CAC005 is on, two files are updated: SEPRICPD and PRICED.                 CAP060
      * We need to add profit centre and pseudo book to the latter file.                      CAP060
      * We also need these fields to appear on the Valid Errors file, which is compiled       CAP060
      * with the same format as the Valid file. These fields need to be moved manually.       CAP060
      *                                                                                       CAP060
     C                                                                                        CAP060
     C                   MOVE      RECI          V_PRRECI                                     CAP060
     C                   MOVEL(P)  PSSN          V_PRPSSN                                     CAP060
     C                   MOVEL(P)  PPRT          V_PRPPRT                                     CAP060
     C                   Z-ADD     PVDT          V_PRPVDT                                     CAP060
     C**********         Z-ADD     PCNM          V_PRPCNM                              CAP060 CSD027
     C                   EVAL      V_PRPCNM = PCNM                                            CSD027
     C                   MOVEL     PMKT          V_PRPMKT                                     CAP060
     C                   MOVEL     PBRA          V_PRPBRA                                     CAP060
     C                   MOVEL     PBOK          V_PRPBOK                                     CAP060
     C                   Z-ADD     PPRC          V_PRPPRC                                     CAP060
     C                   MOVEL     PNTV          V_PRPNTV                                     CAP060
     C                   Z-ADD     LCD           V_PRLCD                                      CAP060
     C                   MOVE      CHTP          V_PRCHTP                                     CAP060
     C                   Z-ADD     TNLU          V_PRTNLU                                     CAP060
     C                   MOVE      PSRC          V_PRPSRC                                     CAP060
     C                   MOVE      PBWN          V_PRPBWN                                     CAP060
     C                   MOVE      PPWN          V_PRPPWN                                     CAP060
     C                   MOVEL     PTFR          V_PRPTFR                                     CAP060
     C                   Z-ADD     NPXR          V_PRNPXR                                     CAP060
     C                   MOVE      NPMD          V_PRNPMD                                     CAP060
     C                   MOVE      PRTMST        V_PRTMESTMP                                  CAP060
     C                   Z-ADD     PRDFTS        V_PRDFTS                                     CAP060
     C                   MOVEL     PRFRNT        V_PRFRNT                                     CAP060
     C                   MOVEL     PRAFRT        V_PRAFRT                                     CAP060
     C                   MOVEL     PRREPA        V_PRREPA                                     CAP060
     C                   MOVEL     PRDTFR        V_PRDTFR                                     CAP060
     C                   MOVEL     PRTLEX        V_PRTLEX                                     CAP060
     C                   MOVEL     PRFC          V_PRPRFC                                     CAP060
     C                   MOVEL     PBCD          V_PRPBCD                                     CAP060
     C                   MOVEL(P)  PSSN          EXVSESN                                      CAP060
     C                   MOVEL     'D'           EXVRECI                                      CAP060
                                                                                              CGL031
     C                   IF        CGL031 = 'Y'                                               CGL031
     C                   Z-ADD     PEXI          V_PRPEXI                                     CGL031
     C                   ENDIF                                                                CGL031
     C                                                                                        CAP060
                                                                                              CAS006
      ** If Hedge Accounting Phase B is installed. move Credit Risk                           CAS006
      ** Spread and Liquidity Premium fields to Price Valid File.                             CAS006
                                                                                              CAS006
     C                   IF        CAS006 = 'Y' AND (PPRT = 'V'                               CAS006
     C                             OR PPRT = 'DT' OR PPRT = 'DV')                             CAS006
     C                   EVAL      V_PRCRSK = PRCRSK                                          CAS006
     C                   EVAL      V_PRLQPR = PRLQPR                                          CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   IF        CSD010 = 'Y'                                               CSD010
     C                   Z-ADD     PRBDPR        V_PRBDPR                                     CSD010
     C                   Z-ADD     PROFPR        V_PROFPR                                     CSD010
     C                   Z-ADD     PRCLPR        V_PRCLPR                                     CSD010
     C                   ENDIF                                                                CSD010
     C                                                                                        CAP060
     C     ENWDL         ENDSR                                                                CAP060
      /EJECT
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      * Common header information (DS) from source system
     C                   PARM                    HeadIn
      * Transaction information in a single large field from source system
     C                   PARM                    Trans500
     C                   PARM                    ExtData500
      ** Ultimate calling Program/Module/Procedure
     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName
 
      ** Key list for SEVPRCSL1
 
     C*****PRCSK1********KLIST
     C*******************KFLD                    PRPSSN                                       CAP060
     C*******************KFLD                    PRPPRT                                       CAP060
     C*******************KFLD                    PRPVDT                                       CAP060
     C     PRCSK1        KLIST                                                                CAP060
     C                   KFLD                    V_PRPSSN                                     CAP060
     C                   KFLD                    V_PRPPRT                                     CAP060
     C                   KFLD                    V_PRPVDT                                     CAP060
 
      ***Key*list*for*SEVPRXTL1                                                               189506
                                                                                              189506
     C*****PRXTK*********KLIST                                                                189506
     C*******************KFLD                    XTSESN                                       189506
     C*******************KFLD                    XTPVDT                                       189506
 
      *
      *  Set up the name of the MSGF from which the message handler will
      *   get the messages
     C                   EVAL      #MsgFile = 'DRSMM'
 
      ** Access Bank details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
      ** Access API ICD via access program                                                    CAP060
     C                   CALLB     'AOAPIR0'                                                  CAP060
     C                   PARM      '*DBERR '     @RTCD                                        CAP060
     C                   PARM      '*FIRST '     @OPTN                                        CAP060
     C     SDAPI         PARM      SDAPI         DSFDY                                        CAP060
      *                                                                                       CAP060
      ** Access SAR details file to determine if CAP060                                       CAP060
      ** is switched on                                                                       CAP060
      *                                                                                       CAP060
     C                   CALLB     'AOSARDR0'                                                 CAP060
     C                   PARM      *BLANKS       @RTCD                                        CAP060
     C                   PARM      '*VERIFY'     @OPTN                                        CAP060
     C                   PARM      'CAP060'      @SARD             6                          CAP060
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP060
     C     @RTCD         IFEQ      *BLANK                                                     CAP060
     C                   MOVEL     'Y'           CAP060F           1                          CAP060
     C                   ELSE                                                                 CAP060
     C                   MOVEL     'N'           CAP060F                                      CAP060
     C                   END                                                                  CAP060
                                                                                              CAP060
      ***  Check if CAC005 is on                                                              CAP060
      *                                                                                       CAP060
     C                   CALL      'AOSARDR0'                                                 CAP060
     C                   PARM      *BLANKS       @RTCD                                        CAP060
     C                   PARM      '*VERIFY'     @OPTN                                        CAP060
     C                   PARM      'CAC005'      @SARD             6                          CAP060
      *                                                                                       CAP060
     C     @RTCD         IFEQ      *BLANKS                                                    CAP060
     C                   MOVE      'Y'           CAC005                                       CAP060
     C                   ELSE                                                                 CAP060
     C                   MOVE      'N'           CAC005                                       CAP060
     C                   ENDIF                                                                CAP060
                                                                                              CSC011
      ** Check if 24x7 Midas Availability is installed                                        CSC011
                                                                                              CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
     C                   CALL      'AOSARDR0'                                                 CSC011
     C                   PARM      *Blanks       PRetCode                                     CSC011
     C                   PARM      '*VERIFY'     POption                                      CSC011
     C                   PARM      'CSC011'      PKey                                         CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRetCode = *Blanks                                         CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   ELSE                                                                 CSC011
     C                   IF        PRetCode <> '*NRF   '                                      CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBKEY  = 'CSC011'                                          CSC011
     C                   EVAL      DBASE  = 2                                                 CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSD010
      ** Access switchable features file - Collateralised Lending (CSD010)                    CSD010
                                                                                              CSD010
     C                   CALL      'AOSARDR0'                                                 CSD010
     C                   PARM      *BLANKS       PRetCode                                     CSD010
     C                   PARM      '*VERIFY'     POption                                      CSD010
     C                   PARM      'CSD010'      PKey                                         CSD010
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD010
                                                                                              CSD010
     C                   IF        PRetCode <> *BLANKS AND                                    CSD010
     C                             PRetCode <> '*NRF   '                                      CSD010
     C                   EVAL      DBASE = 3                                                  CSD010
     C                   EVAL      DBKEY = 'CSD010'                                           CSD010
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD010
     C                   EXSR      *PSSR                                                      CSD010
     C                   ENDIF                                                                CSD010
     C                                                                                        CSD010
     C                   IF        PRetCode = *BLANKS                                         CSD010
     C                   EVAL      CSD010 = 'Y'                                               CSD010
     C                   ELSE                                                                 CSD010
     C                   EVAL      CSD010 = 'N'                                               CSD010
     C                   ENDIF                                                                CSD010
                                                                                              CAS006
      ** Access switchable features file - Hedge Accounting Phase B (CAS006)                  CAS006
                                                                                              CAS006
     C                   CALL      'AOSARDR0'                                                 CAS006
     C                   PARM      *BLANKS       PRetCode                                     CAS006
     C                   PARM      '*VERIFY'     POption                                      CAS006
     C                   PARM      'CAS006'      PKey                                         CAS006
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS006
                                                                                              CAS006
     C                   IF        PRetCode <> *BLANKS AND                                    CAS006
     C                             PRetCode <> '*NRF   '                                      CAS006
     C     *LOCK         IN        LDA                                                        CAS006
     C                   EVAL      DBASE = 4                                                  CAS006
     C                   EVAL      DBKEY = 'CAS006'                                           CAS006
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS006
     C                   EVAL      DBMOD = 'SEPRCSCTL'                                        CAS006
     C                   EVAL      DBPGM = 'SEPRCSCTL'                                        CAS006
     C                   OUT       LDA                                                        CAS006
     C                   EXSR      *PSSR                                                      CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   IF        PRetCode = *BLANKS                                         CAS006
     C                   EVAL      CAS006 = 'Y'                                               CAS006
     C                   ELSE                                                                 CAS006
     C                   EVAL      CAS006 = 'N'                                               CAS006
     C                   ENDIF                                                                CAS006
                                                                                              233235
      ** Check if CGL031 is installed                                                         233235
                                                                                              233235
     C                   CALL      'AOSARDR0'                                                 233235
     C                   PARM      *BLANKS       PRtcd                                        233235
     C                   PARM      '*VERIFY'     POptn                                        233235
     C                   PARM      'CGL031'      PSard                                        233235
     C     SCSARD        PARM      SCSARD        DSFDY                                        233235
                                                                                              233235
     C                   IF        PRtcd <> *BLANKS AND                                       233235
     C                             PRtcd <> '*NRF   '                                         233235
     C                   EVAL      DBASE = 4                                                  233235
     C                   EVAL      DBKEY = 'CGL031'                                           233235
     C                   EVAL      DBFILE = 'SCSARDPD'                                        233235
     C                   EXSR      *PSSR                                                      233235
     C                   ENDIF                                                                233235
                                                                                              233235
     C                   IF        PRtcd = *BLANKS                                            233235
     C                   EVAL      CGL031 = 'Y'                                               233235
     C                   ELSE                                                                 233235
     C                   EVAL      CGL031 = 'N'                                               233235
     C                   ENDIF                                                                233235
      *                                                                                       CAP060
      ** Access Module Details                                                                CAP060
      *                                                                                       CAP060
     C                   CALL      'AOMMODR0'                                                 CAP060
     C                   PARM      *BLANKS       @RTCD                                        CAP060
     C                   PARM      '*FIRST '     @OPTN                                        CAP060
     C     SDMMOD        PARM      SDMMOD        DSFDY                                        CAP060
      *                                                                                       CAP060
      * DATABASE ERROR                                                                        CAP060
      *                                                                                       CAP060
     C     @RTCD         IFNE      *BLANKS                                                    CAP060
     C                   MOVEL     'SDMMODPD'    DBFILE                         ************  CAP060
     C                   MOVEL     '001'         DBASE                          * DBERR 001*  CAP060
     C                   MOVEL     @OPTN         DBKEY                          ************  CAP060
     C                   EXSR      *PSSR                                                      CAP060
     C                   END                                                                  CAP060
                                                                                              CAP060
                                                                                              CAP060
      * Check if EXTEL indicator is on, BVEXOP                                                CAP060
                                                                                              CAP060
     C                   CALL      'AOSTRDR0'                                                 CAP060
     C                   PARM      '*DBERR '     @RTCD             7                          CAP060
     C                   PARM      '*FIRST '     @OPTN             7                          CAP060
     C     SDSTRD        PARM      SDSTRD        DSSDY                                        CAP060
 
      ** Set up the name of the server/database updater data queue.
     C                   EVAL      DtaQName = 'APPRCSDTQ'
 
      *                                                                                      BUG2812
      ** Access Switchable Features File, for CSC022                                         BUG2812
      *                                                                                      BUG2812
     C                   EVAL      CSC022 = 'N'                                              BUG2812
     C                   CallB     'AOSARDR0'                                                BUG2812
     C                   Parm      *BLANKS       @RTCD                                       BUG2812
     C                   Parm      '*VERIFY'     @OPTN                                       BUG2812
     C                   Parm      'CSC022'      @SARD                                       BUG2812
     C     SCSARD        PArm      SCSARD        DSFDY                                       BUG2812
      *                                                                                      BUG2812
     C                   If        @RTCD = *Blanks                                           BUG2812
     C                   Eval      CSC022 = 'Y'                                              BUG2812
     C                   Eval      WCommitSkip = 'N'                                         BUG2812
      *                                                                                      BUG2812
     C                   In        SCCMTJOB                                                  BUG2812
     C                   If        ComitNum > 0                                              BUG2812
     C                   MoveA     ComitJob      WCmtJobArr                                  BUG2812
      *                                                                                      BUG2812
     C     PSJOBNAME     LOOKUP    WCmtJobArr                             87                 BUG2812
     C                   If        *IN87 = *ON                                               BUG2812
     C                   Eval      WCommitSkip = 'Y'                                         BUG2812
     C                   EndIf                                                               BUG2812
     C                   EndIf                                                               BUG2812
      *                                                                                      BUG2812
     C                   Else                                                                BUG2812
      *                                                                                      BUG2812
      ** If return code <> *NRF, call program exception error routine                        BUG2812
      *                                                                                      BUG2812
     C                   If        @RTCD <> '*NRF'                                           BUG2812
     C     *LOCK         IN        LDA                                                       BUG2822
     C                   EVAL      DBKEY = 'CSC022'                                          BUG2812
     C                   EVAL      DBFILE = 'SCSARDPD'                                       BUG2812
     C                   EVAL      DBASE = 5                                                 BUG2812
     C                   OUT       LDA                                                       BUG2812
     C                   Exsr      *PSSR                                                     BUG2812
     C                   EndIf                                                               BUG2812
     C                   EndIf                                                               BUG2812
      *                                                                                      BUG2812
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SEPRCSC014
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
