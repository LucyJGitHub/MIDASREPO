     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Customer details dbase update controller')    *
      *****************************************************************
      *                                                               *
      *  Midas - SD Standing Data ILE Module                          *
      *                                                               *
      *  SDCUSDUPC - SD CUSTOMERS DATABASE UPDATE CONTROLLER          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD055446           Date 04Apr20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 LLN022A            Date 03Jun15               *
      *                 LLN022             Date 03Jun15               *
      *                 CER070             Date 25Nov14               *
      *                 MD030956           Date 09Oct14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 CSW207A            Date 05Aug07               *
      *                 CSW207             Date 08Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CER001             Date 25Apr05               *
      *                 CSD028             Date 22Aug05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3362            Date 30Jul04               *
      *                 CFX001             Date 20Oct03               *
      *                 CLE025             Date 20Oct03               *
      *                 222373             Date 24Oct03               *
      *                 220650             Date 18Aug03               *
      *                 CGP001             Date 23May03               *
      *                 CSD012             Date 15Oct02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 201011             Date 28Nov01               *
      *                 193883             Date 20Nov01               *
      *                 201589             Date 03Jan02               *
      *                 CSW024             Date 31Aug01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CRE007             Date 01Mar01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSD007             Date 28Aug00               *
      *                 CDL008             Date 02May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      * Midas DBA 3.02 Patch Z ---------------------------------------*
      *                 176883             Date 28Mar00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP034  *CREATE    Date 18May99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055446 - There are parties and fields missing from the BRT *
      *             details tab in Customer Input plus date of birth  *
      *             issues.                                           *
      *           - Recompile over changes in SDCBRTPD.               *
      *  MD046248 - Finastra Rebranding                               *
      *  LLN022A- BOE Upgrade to MidasPlus - incorporate code from    *
      *           /COPY members and add switchability.                *
      *  LLN022 - BOE Upgrade to MidasPlus.                           *
      *           Recompiled over changes in /COPY                    *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207A - SWIFT 2007 Changes                                 *
      *  CSW207 - SWIFT 2007 Changes (Recompile)                      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  CSD028 - KYC (Standing Data Authorisations )                 *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3362 - Add TI details for CSD012(Standing Data Authori-   *
      *            sation.                                            *
      *  CFX001 - FX Margin Trading                                   *
      *  CLE025 - Credit Lines                                        *
      *  222373 - Parameter Mismatch                                  *
      *  220650 - WaitTime variable initializes to '*CLS', must be    *
      *           numeric                                             *
      *  CGP001 - Global Processing                                   *
      *  CSD012 - Standing Data Authorisation                         *
      *  201011 - Not able to insert/amend customer details when      *
      *           account holder type is not I, J or R.               *
      *  193883 - Recompile over changed SDCUSDUPD.                   *
      *  201589 - Change to check a new locking dataarea SDCUSDLCK    *
      *           to determine whether this DBU is already active.    *
      *  CSW024 - S.W.I.F.T. MT3xx Field 82/83/87.                    *
      *  CRE007 - Base Rate Tax 2001 - Recompiled.                    *
      *  CSD007 - Customer Closing: Recompile.                        *
      *  CDL008 - Continuous Linked Settlement (Recompiled)           *
      *  176883 - In case of update error, read the record in the     *
      *        valid files prior to deletion in SDVCUPBL0 & SDVCUBRL1 *
      *  CAP034 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
     FSDVCUSDPD UF   E             DISK
     F                                     COMMIT
     FSDVCUSDL1 UF   E           K DISK
     F                                     RENAME(SDVCUSDD0:SDVCUSDD1)
     FSDVCUBRL1 UF   E           K DISK
     F                                     COMMIT
     F                                     RENAME(SDVCUBRPD0:SDVCUBRD1)
     FSDVCUPBL0 UF   E           K DISK
     F                                     COMMIT
     F                                     RENAME(SDVCUPBPD0:SDVCUPBD1)
     FSDVSWFDL1 UF   E           K DISK                                                      CSW207A
     F                                     COMMIT                                            CSW207A
     F                                     RENAME(SDVSWSDD0:SDVSWSDD1)                       CSW207A

     FSDVECUSDPDO    E             DISK
     F                                     RENAME(SDVCUSDD0:SDVCUSDERR)
     FSDVECUBRPDO    E             DISK
     F                                     RENAME(SDVCUBRPD0:SDVCUBRERR)
     FSDVECUPBPDO    E             DISK
     F                                     RENAME(SDVCUPBPD0:SDVCUPBERR)

      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,SDCUSDU001
                                                                                             LLN022A
      * Valid Customers BoE details                                                          LLN022A
     FSDVCUSDE1 UF A E           K DISK                                                      LLN022A
     F                                     RENAME(SDVCUSDD0:VCUSDD0)                         LLN022A
      * Valid Customers Error BoE details                                                    LLN022A
     FSDVECUSDPEUF A E             DISK                                                      LLN022A
     F                                     RENAME(SDVCUSDD0:VECUSDD0)                        LLN022A
      * BoE Extension file                                                                   LLN022A
     FBYCUSTY0  IF   E           K DISK                                                      LLN022A
                                                                                              CER001
     FSDVCULX2L1UF   E           K DISK    USROPN                                             CER001
     F                                     COMMIT                                             CER001
     FSDVECUX2PDO    E             DISK    USROPN                                             CER001
     F                                     RENAME(SDVCULXD6:SDVCULXD6R)                       CER001
                                                                                              CER001
     FSDVCULX1L0UF   E           K DISK    USROPN                                             CER001
     F                                     COMMIT                                             CER001
     FSDVECUX1PDO    E             DISK    USROPN                                             CER001
     F                                     RENAME(SDVCULXDL:SDVCULXDLR)                       CER001

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)

     D/COPY ZACPYSRC,STD_D_SPEC

      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** used in checking whether there are messages on the data queue.
     D/COPY ZACPYSRC,DTAQCHKDCL
      **--------------------------------------------------------------------------------------------

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
     D DBerrUpd        C                   CONST('DB error in CUSD API update')

      *****************************************************************

      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR VALID CUSTOMER
     D SDVCUD        E DS                  EXTNAME(SDVCUSDPD)

      **  EXTERNALLY DESCRIBED DS FOR VALID CUSTOMER BRT details
     D SDVBRT        E DS                  EXTNAME(SDVCUBRPD)

      **  EXTERNALLY DESCRIBED DS FOR VALID CUSTOMER PB details
     D SDVPRB        E DS                  EXTNAME(SDVCUPBPD)
                                                                                             CSW207A
      **  EXTERNALLY DESCRIBED DS FOR VALID CUSTOMER PB details                              CSW207A
     D SDVSWSD       E DS                  EXTNAME(SDVSWSDPD)                                CSW207A

     D SDVTID        E DS                  EXTNAME(SDVTICDPD)                                BUG3362
      *                                                                                      BUG3362
     D SDCUSDUPC       DS             1    DTAARA(SDCUSDUPC)

      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)

     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)
      ** EXTERNAL DS FOR SAR DETAILS
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
                                                                                              CSD012
      **  Data Structure for AOSVALR0 string                                                  CSD012
     DSVAL1            DS           200                                                       CSD012
     DSVAL11                   1      1                                                       CSD012


     D Object          S             10A   INZ('SDCUSDUPC')
     D LockObj         S             10A   INZ('SDCUSDLCK')                                   201589
     D Lib             S             10A   INZ('*LIBL')
     D ObjType         S              7A   INZ('*DTAARA')
     D LockStateE      S              7A   INZ('*EXCL')
     D LockStateS      S              7A   INZ('*SHRRD')
     D Member          S             10A
     D*WaitTime*       S              6A   INZ('*CLS')                                        220650
     D WaitTime        S              6A   INZ('0   ')                                        220650
     D Dlcobj          S              1A
     D Return          S              7A
     D Return2         S              7A                                                      201589
     D Endjob          S              1A   INZ('Y')                                           201589
     D @Timestamp      S             26Z

      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A

      ** Command length for QCMDEXC
     D CommandLen      S             15P 5 INZ(26)

      ** Data queue details
      ** ------------------
     D DtqLen          S              5P 0 INZ(10)
     D DtqWait         S              5P 0 INZ(-1)
     D DtqNam          S             10A   INZ('APCUSDDTQ')
     D DtqLib          S             10A   INZ('*LIBL')
     D DtqDta          S             10A


      ** Override Database Table
     D ##OX1           S              1    DIM(50) CTDATA PERRCD(50)
     D ##OX2           S              1    DIM(50) CTDATA PERRCD(50)
     D ##OX3           S              1    DIM(50) CTDATA PERRCD(50)
     D ##OX4           S              1    DIM(50) CTDATA PERRCD(50)
     D*##OX5*********  S              1    DIM(51) CTDATA PERRCD(51)                  CGP001 BUG3362
     D ##OX5           S              1    DIM(50) CTDATA PERRCD(50)                         BUG3362
     D ##OX6           S              1    DIM(51) CTDATA PERRCD(51)                         BUG3362
                                                                                              CSD012
      * Defined Fields for CSD012                                                             CSD012
     D CSD012          S              1A                                                      CSD012
     D SVALKK          C                   CONST('AuthReqCustomerMaint')                      CSD012
                                                                                              CSD012
      ** Override SDAULGL2                                                                    CSD012
     D CMD             S              1    DIM(50) CTDATA PERRCD(50)                          CSD012

     D CGP001          S              1                                                       CGP001
     D V_DDGCUS        S             10                                                       CGP001
                                                                                              CGP001
     D CLE025          S              1                                                       CLE025
     D CFX001          S              1                                                       CFX001
     D PRTCD           S              7                                                       CLE025
     D POPTN           S              7                                                       CLE025
     D PSARD           S              6                                                       CLE025
     D PMODE           S              1                                                       CLE025
                                                                                              CLE025
     D PTransType      S              4                                                       CSD028
                                                                                             CSW207A
      ** Swift installed flag                                                                CSW207A
     D CSW207          S              1A                                                     CSW207A
                                                                                             CSW207A
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SDCUSDU002
                                                                                             LLN022A
      * Details from Valid file                                                              LLN022A
     D ValidDet      E DS                  EXTNAME(SDVCUSDPE)                                LLN022A
                                                                                             LLN022A
      * Details from Extension file                                                          LLN022A
     D FileDet       E DS                  EXTNAME(BYCUSTX0)                                 LLN022A
                                                                                             LLN022A
      ** New valid extended SD Customer File                                                  CER001
     D SDVCULX6      E DS                  EXTNAME(SDVCULX2L0)                                CER001
     D SDVCULX6S     E DS                  EXTNAME(SDVCULX2L0)                                CER001
     D                                     PREFIX(SS)                                         CER001
                                                                                              CER001
      ** New valid extended SD Customer File                                                  CER001
     D SDVCULXL      E DS                  EXTNAME(SDVCULX1L0)                                CER001
     D SDVCULXLS     E DS                  EXTNAME(SDVCULX1L0)                                CER001
     D                                     PREFIX(SS)                                         CER001

      *******************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *******************************************************************

      /COPY WNCPYSRC,SDCUSDU003

      ** Set up the name of the server/database updater data queue.
     C                   EVAL      DtaQName = 'APCUSDDTQ'

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes a check for whether there
      ** are messages on the server/updater data queue, and sends a 'GO'.
      ** message to the data queue if there are not.
     D/COPY ZACPYSRC,DTAQCHK
      **--------------------------------------------------------------------------------------------

      ** Wait for data queue prompt
      ** Server program will send data queue entry when record is
      ** written to the valid transactions file
     C                   DOW       DtqDta <> 'END'

     C                   CALL      'QRCVDTAQ'
     C                   PARM                    DtqNam
     C                   PARM                    DtqLib
     C                   PARM                    DtqLen
     C                   PARM                    DtqDta
     C                   PARM                    DtqWait

      ** If data queue entry is 'END', leave the DOW loop at this point
     C                   IF        DtqDta = 'END'
     C                   LEAVE
     C                   ENDIF

      ** If data queue entry says run, first lock allocation data area
     C     DtqDta        IFEQ      'GO'

      ** Allocate with exclusive lock state
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateE
     C                   PARM                    Member
     C                   PARM                    WaitTime
     C                   PARM                    Dlcobj
     C                   PARM                    Return

      ** Ensure the U7 and U8 indicators are off, to prevent problems
      ** caused by earlier errors.
     C                   CLEAR                   *inu7
     C                   CLEAR                   *inu8


      /COPY WNCPYSRC,SDCUSDU004

      ** Position file cursor to start of file to prevent problems on
      ** later calls
     C     1             SETLL     SDVCUSDPD

      ** READ VALID SD CUSTOMER
     C                   READ      SDVCUSDD0                              99    *
     C     *IN99         DOWEQ     '0'

      /COPY WNCPYSRC,SDCUSDU005

      ** Load the API Dump data area with as many fields from the message
      **  header as are available, so that dumps in any lower level modules
      **  will include the key information
     C                   EVAL      ARFOTranID = CUFRNT
     C                   EVAL      ARFOAsocID = CUAFRT
     C                   EVAL      ARRprLocn  = CUREPA
     C                   MOVEL     CUCUST        @BrCust
     C                   MOVEL     CUCUST        @PbCust
     C                   MOVEL     CUCUST        @SwCust                                     CSW207A
     C                   MOVEL     CUBRCD        @SwBrCh                                     CSW207A
     C                   EVAL      @Timestamp = CUTMST

      /COPY WNCPYSRC,SDCUSDU006

      ** GET EXTENSION FILE DETAILS (BRT Details & Particpator History)

     C                   CLEAR                   SDVBRT
     C                   CLEAR                   SDVPRB
     C                   CLEAR                   SDVSWSD                                     CSW207A
     C                   CLEAR                   SDVTID                                     BUG3362


      /COPY WNCPYSRC,SETRADU007

     C     S01383        IFEQ      'Y'
     C**********         IF        CUTAIN = 'I' or                                           201011
     C**********                   CUTAIN = 'J'                                              201011
     C     @KeyBrtL1     CHAIN     SDVCUBRL1                          98
     C**********         ENDIF                                                               201011
     C                   ENDIF


      /COPY WNCPYSRC,SETRADU007

     C     BGN4ST        IFEQ      'Y'
     C     @KeyPrbL1     CHAIN     SDVCUPBL0                          97
     C                   END

     C     BGN4ST        IFEQ      'Y'                                                       CSW207A
     C     CSW207        OREQ      'Y'                                                       CSW207A
     C     @KeySwftl1    CHAIN     SDVSWSDD1                          96                     CSW207A
     C                   ENDIF                                                               CSW207A

      /COPY WNCPYSRC,SDCUSDU008

      ** If Bank of England switched on then CHAIN to BoE details on valid                   LLN022A
      * file.                                                                                LLN022A
                                                                                             LLN022A
     C     LLN007        IfEq      'Y'                                                       LLN022A
                                                                                             LLN022A
     C                   Move      *IN98         UL98              1                         LLN022A
     C                   EVAL      @CuCust = CUCUST                                          LLN022A
     C                   EVAL      @Timestamp = CUTMST                                       LLN022A
     C     @KeyCusdL1    Chain     SDVCUSDE1                          98                     LLN022A
                                                                                             LLN022A
      ** DATABASE ERROR IF RECORD NOT FOUND                                                  LLN022A
      *                                                                                      LLN022A
     C     *IN98         IFEQ      '1'                                                       LLN022A
     C                   MOVEL     CUCUST        DBKEY                                       LLN022A
     C                   MOVEL     'SDVCUSDPE'   DBFILE                                      LLN022A
     C                   MOVEL     '500'         DBASE                                       LLN022A
     C                   EXSR      SRERR                                                     LLN022A
     C                   END                                                                 LLN022A
     C                   Move      UL98          *IN98                                       LLN022A
                                                                                             LLN022A
     C                   EndIf                                                               LLN022A

      ** SD DATABASE UPDATE
     C                   CALLB     'SDCUSDUPD'
     C                   PARM      *BLANK        @@RTCD            7
     C                   PARM                    SDVCUD
     C                   PARM                    SDVBRT
     C                   PARM                    SDVPRB
     C                   PARM                    SDVTID                                      BUG3362
     C                   PARM                    SDVSWSD                                     CSW207A
      * Base Rate Auth req                                                                    CSD012
     C                   PARM                    AUTHRQ            1                          CSD012
      * Authorisation Mode                                                                    CSD012
     C                   PARM                    AUTHMD            1                          CSD012
     C                   PARM      *BLANKS       V_DDGCUS                                     CGP001
     C                   PARM                    S01383            1
     C                   PARM                    CSW024                                       CSW024
     C**********         PARM                    BGN4ST                                       222373
     C                   PARM                    CGP001                                       CGP001
     C                   PARM                    CLE025                                       CLE025
     C                   PARM                    CFX001                                       CFX001
      ** KYC: Transaction Type                                                                CSD028
     C                   PARM      *BLANKS       PTransType                                   CSD028
     C                   PARM                    DACTN             1                        MD030956
     C                   PARM                    CTI006            1                        MD030956

     C/COPY WNCPYSRC,SDCUSDUC01
                                                                                             LLN022A
      ** If Bank of England switched on then call database updater module                    LLN022A
     C     LLN007        IFEQ      'Y'                                                       LLN022A
                                                                                             LLN022A
     C                   MOVE      *IN98         UL98                                        LLN022A
      * If record found then obtain details from extension file if they                      LLN022A
      * exist and pass as Saved details. If they don't exist blanks will be                  LLN022A
      * passed.                                                                              LLN022A
                                                                                             LLN022A
     C     CUCUST        CHAIN     BYCUSTY0                           98                     LLN022A
      *                                                                                      LLN022A
     C     *IN98         IFEQ      *ON                                                       LLN022A
     C                   CLEAR                   FileDet                                     LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                      LLN022A
     C                   MOVE      UL98          *IN98                                       LLN022A
                                                                                             LLN022A
     C                   CALLB     'BYCUSDW0UP'                                              LLN022A
     C                   PARM                    CUTYLC                                      LLN022A
     C                   PARM      *BLANKS       DUMMYST         256                         LLN022A
     C                   PARM      *BLANKS       @@RETN            7                         LLN022A
     C                   PARM      *BLANKS       WFIND             1                         LLN022A
     C                   PARM                    ValidDet                                    LLN022A
     C                   PARM                    FileDet                                     LLN022A
                                                                                             LLN022A
      * If Return Code from main file updates blank then move the return                     LLN022A
      * code form this update to that field.                                                 LLN022A
     C     @@RTCD        IFEQ      *BLANKS                                                   LLN022A
     C                   MOVE      @@RETN        @@RTCD                                      LLN022A
     C                   ENDIF                                                               LLN022A
                                                                                             LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                       CER001
      ** ULX609 - API Luxembourg - Function SDCUSD                                            CER001
      *                                                                                       CER001
     C     ULX609        IFEQ      'Y'                                                        CER001
      *                                                                                       CER001
     C     @@RTCD        IFEQ      '*ERROR '                                                  CER001
     C     @@RTCD        OREQ      '*RECUPD'                                                  CER001
     C                   ROLBK                                                                CER001
     C                   ELSE                                                                 CER001
      *                                                                                       CER001
      ** Retrieve extended valid record                                                       CER001
      *                                                                                       CER001
     C     ULX609        IFEQ      'Y'                                                        CER001
     C     ULX004        ANDEQ     'Y'                                                        CER001
      *                                                                                       CER001
     C                   CLEAR                   SDVCULX6                                     CER001
     C                   CLEAR                   SDVCULX6S                                    CER001
      *                                                                                       CER001
     C     ARFOTranID    CHAIN     SDVCULX2L1                         89                      CER001
      *                                                                                       CER001
      **  Do not update extended file if the action code is amend and                         CER001
      **  action is done via Meridian                                                         CER001
      *                                                                                       CER001
     C     CUTYLC        IFEQ      'A'                                                        CER001
     C     @TYPE         ANDEQ     '0'                                                        CER001
     C                   MOVE      *BLANK        @@RTCD                                       CER001
     C                   ELSE                                                                 CER001
      *                                                                                       CER001
      ** SD Extended database update                                                          CER001
      *                                                                                       CER001
     C                   CALLB     'SDCUSD2UP'                                                CER001
     C                   PARM                    CUTYLC                                       CER001
     C                   PARM      *BLANK        @@RTCD                                       CER001
     C                   PARM      *BLANK        @@FIND            1                          CER001
     C                   PARM                    SDVCULX6                                     CER001
     C                   PARM                    SDVCULX6S                                    CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C     @@RTCD        IFEQ      *BLANK                                                     CER001
     C                   DELETE    SDVCULXD6                                                  CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
                                                                                              CER001
     C     ULX043        IFEQ      'Y'                                                        CER001
      *                                                                                       CER001
      ** SD Extended database update                                                          CER001
      *                                                                                       CER001
     C                   CLEAR                   SDVCULXL                                     CER001
     C                   CLEAR                   SDVCULXLS                                    CER001
      *                                                                                       CER001
     C     CUCUST        CHAIN     SDVCULX1L0                         89                      CER001
      *                                                                                       CER001
     C     CUTYLC        IFEQ      'A'                                                        CER001
     C     @TYPE         ANDEQ     '0'                                                        CER001
     C                   MOVE      *BLANK        @@RTCD                                       CER001
     C                   ELSE                                                                 CER001
     C                   CALLB     'SDCUSD3UP'                                                CER001
     C                   PARM                    CUTYLC                                       CER001
     C                   PARM      *BLANK        @@RTCD                                       CER001
     C                   PARM      *BLANK        @@FIND            1                          CER001
     C                   PARM                    SDVCULXL                                     CER001
     C                   PARM                    SDVCULXLS                                    CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C     @@RTCD        IFEQ      *BLANK                                                     CER001
     C                   DELETE    SDVCULXDL                                                  CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      * COMIT UPDATES IF NO ERROR
     C     @@RTCD        IFEQ      '*ERROR '
     C     @@RTCD        OREQ      '*RECUPD'
     C                   ROLBK
     C                   ELSE
     C                   DELETE    SDVCUSDD0
     C     S01383        IFEQ      'Y'
     C     *IN98         IFEQ      '0'
     C**********         IF        CUTAIN = 'I' or                                            201011
     C**********                   CUTAIN = 'J'                                               201011
     C                   DELETE    SDVCUBRD1
     C**********         ENDIF                                                                201011
     C                   ENDIF
     C                   ENDIF
     C     BGN4ST        IFEQ      'Y'
     C     *IN97         IFEQ      '0'
     C                   DELETE    SDVCUPBD1
     C                   ENDIF
     C                   ENDIF
                                                                                             CSW207A
     C                   IF        (BGN4ST = 'Y' OR CSW207 = 'Y')                            CSW207A
     C     @KeySwftl1    CHAIN     SDVSWSDD1                          96                     CSW207A
     C     *IN96         IFEQ      '0'                                                       CSW207A
     C                   DELETE    SDVSWSDD1                                                 CSW207A
     C                   ENDIF                                                               CSW207A
     C                   ENDIF                                                               CSW207A
                                                                                             CSW207A
     C/COPY WNCPYSRC,SDCUSDUC02
                                                                                             LLN022A
      ** If Bank of England switched on then delete record from valid                        LLN022A
      ** record file.                                                                        LLN022A
                                                                                             LLN022A
     C     LLN007        IFEQ      'Y'                                                       LLN022A
     C     @KeyCusdL1    Chain     SDVCUSDE1                          98                     LLN022A
     C     *IN98         IfEq      *OFF                                                      LLN022A
     C                   DELETE    VCUSDD0                                                   LLN022A
     C                   EndIf                                                               LLN022A
     C                   ENDIF                                                               LLN022A
                                                                                             LLN022A
     C                   COMMIT
     C                   ENDIF

      /COPY WNCPYSRC,SDCUSDU009
      *                                                                                       CER001
      ** If an error has occurred, remove record in error from                                CER001
      ** the file and write details of record to error valid file                             CER001
      *                                                                                       CER001
     C     ULX609        IFEQ      'Y'                                                        CER001
     C     ULX004        ANDEQ     'Y'                                                        CER001
      *                                                                                       CER001
     C     @@RTCD        IFEQ      '*ERROR '                                                  CER001
     C     @@RTCD        OREQ      '*RECUPD'                                                  CER001
      *                                                                                       CER001
     C                   WRITE     SDVCULXD6R                                                 CER001
     C                   DELETE    SDVCULXD6                                                  CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C     ULX609        IFEQ      'Y'                                                        CER001
     C     ULX043        ANDEQ     'Y'                                                        CER001
      *                                                                                       CER001
     C     @@RTCD        IFEQ      '*ERROR '                                                  CER001
     C     @@RTCD        OREQ      '*RECUPD'                                                  CER001
      *                                                                                       CER001
     C                   WRITE     SDVCULXDLR                                                 CER001
     C                   DELETE    SDVCULXDL                                                  CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001

     ** If an error has occurred, reaccess record in error and remove from
     ** the file to prevent program processing the same record again
     C     @@RTCD        IFEQ      '*ERROR '
     C     @@RTCD        OREQ      '*RECUPD'
     C                   EVAL      @CuCust = CUCUST
     C                   EVAL      @Timestamp = CUTMST
     C     @KeyCusdL1    CHAIN     SDVCUSDL1                          89
     ** Write details of record to error file (same format as SDVCUSDPD)
     C                   WRITE     SDVCUSDERR
     C                   DELETE    SDVCUSDD1
     C     S01383        IFEQ      'Y'
     C                   WRITE     SDVCUBRERR
     C******IN98*********IFEQ      '0'                                          176883
     C**********         IF        CUTAIN = 'I' or                                            201011
     C**********                   CUTAIN = 'J'                                               201011
     C                   MOVEL     CUCUST        @BrCust                        176883
     C                   EVAL      @Timestamp = CUTMST                          176883
     C     @KeyBrtL1     CHAIN     SDVCUBRL1                          98        176883
     C     *IN98         IFEQ      '0'                                          176883
     C                   DELETE    SDVCUBRD1
     C                   ENDIF
     C**********         ENDIF                                                                201011
     C                   ENDIF
     C     BGN4ST        IFEQ      'Y'
     C                   WRITE     SDVCUPBERR
     C                   MOVEL     CUCUST        @PbCust                        176883
     C                   EVAL      @Timestamp = CUTMST                          176883
     C     @KeyPrbL1     CHAIN     SDVCUPBL0                          97        176883
     C     *IN97         IFEQ      '0'
     C                   DELETE    SDVCUPBD1
     C                   ENDIF
     C                   ENDIF
     C/COPY WNCPYSRC,SDCUSDUC03
                                                                                             LLN022A
      ** If Bank of England switched on and error in update, write                           LLN022A
      ** record to Valid Error file and delete record from valid file.                       LLN022A
                                                                                             LLN022A
     C     LLN007        IFEQ      'Y'                                                       LLN022A
                                                                                             LLN022A
     C                   WRITE     VECUSDD0                                                  LLN022A
      * Use same keylist as CHAIN to main Customer file.                                     LLN022A
     C     @KeyCusdL1    CHAIN     SDVCUSDE1                          98                     LLN022A
     C     *IN98         IFEQ      '0'                                                       LLN022A
     C                   DELETE    VCUSDD0                                                   LLN022A
     C                   ENDIF                                                               LLN022A
                                                                                             LLN022A
     C                   ENDIF                                                               LLN022A
                                                                                             LLN022A
     ** Send message to system operator
     C                   MOVEL     DBerrUpd      DBError          28
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MsgSndRtn        10
     C                   PARM                    DBError
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF

     C                   ENDIF

      ** READ VALID SD CUSTOMERS
     C                   READ      SDVCUSDD0                              99    *
     C                   END
     ** Unlock allocation data area
     C                   CALLB     'APCDLCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateE
     C                   PARM                    Member
     C                   PARM                    Return
     C                   END
      ** End loop for data queue prompt
     C                   END

      /COPY WNCPYSRC,SDCUSDU010

      * EXIT FROM PROGRAM
     C                   RETURN

      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SDCUSDU011

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
                                                                                              CSD012
      * Override SDAULGL2                                                                     CSD012
     C                   Z-ADD     50            CMDLEN           15 5                        CSD012
     C                   CALL      'QCMDEXC'                                                  CSD012
     C                   PARM                    CMD                                          CSD012
     C                   PARM                    CMDLEN                                       CSD012
      *                                                                                       CER001
      ** Determine whether program is running interactively or in batch                       CER001
      **  ( 0 = batch   1 = interactive)                                                      CER001
      *                                                                                       CER001
     C                   CALLB     'ZARTVJOBA'                                                CER001
     C                   PARM                    @Return           6                          CER001
     C                   PARM                    @type             1                          CER001

      *  Define key list for SDVCUSDL1
     C     @KeyCusdL1    KLIST
     C                   KFLD                    @CuCust           6
     C                   KFLD                    @Timestamp

      *  Define key list for SDVCUBRL1
     C     @KeyBrtL1     KLIST
     C*****              KFLD                    @BrCust           6 0                        CSD027
     C                   KFLD                    @BrCust           6                          CSD027
     C                   KFLD                    @Timestamp

      *  Define key list for SDVCUPBL0
     C     @KeyPrbL1     KLIST
     C*****              KFLD                    @PbCust           6 0                        CSD027
     C                   KFLD                    @PbCust           6                          CSD027
     C                   KFLD                    @Timestamp
                                                                                             CSW207A
      *  Define key list for SDVSWSDD1                                                       CSW207A
     C     @KeySwftl1    KLIST                                                               CSW207A
     C                   KFLD                    @SwCust           6                         CSW207A
     C                   KFLD                    @SwBrch           3                         CSW207A

      *  Check if an existing DBU_CUSD job is active in the subsystem.                        201589
                                                                                              201589
     C                   CALL      'SCC0520'                                                  201589
     C                   PARM                    LockObj                                      201589
     C                   PARM                    Lib                                          201589
     C                   PARM                    ObjType                                      201589
     C                   PARM                    LockStateE                                   201589
     C                   PARM                    Member                                       201589
     C                   PARM                    Endjob                                       201589
     C                   PARM                    Return2                                      201589
                                                                                              201589
      *  Lock allocation data area

      *   The data area is allocated *SHRRD here and *EXCL whilst processing
      *    of the valid file is actually taking place.
      *   The function to submit this updater tries to get a *EXCL lock.
      *   The controller tries to get a *SHRRD lock.

      *                         Submitter             Controller
      *                 Lock      Lock     Submitter     Lock     Controller
      *      Status    Status   Successful   Action   Successful    Action
      *      ------    ------   ---------- ---------  ----------  ----------
      *   Not running  None        Yes      Submit       Yes        Prompt
      *                                     updater                 updater

      *   Running not  *SHRRD      No        None        Yes        Prompt
      *    processing                                               updater

      *   Processing   *EXCL       No        None        No         None

     C                   CALLB     'APCALCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateS
     C                   PARM                    Member
     C                   PARM                    WaitTime
     C                   PARM                    Dlcobj
     C                   PARM                    Return

      ** Create required QTEMP objects
     C                   CALL      'APCCRTQTO'
     C                   PARM                    ReturnCde        10
      *
      ** GET MODULE DETAILS
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST '     DBKEY
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   EXSR      SRERR
     C                   END
      *
      ** Access SAR details file to determine if S01383
      ** (Base Rate Tax) is switched on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'S01383'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01383            1
     C                   ELSE
     C                   MOVEL     'N'           S01383
     C                   END
      *                                                                                       CSW024
      ** Access SAR details file to determine if CSW024                                       CSW024
      ** S.W.I.F.T. MT3xx Field 82/83/87 is installed.                                        CSW024
      *                                                                                       CSW024
     C                   CALLB     'AOSARDR0'                                                 CSW024
     C                   PARM      *BLANKS       @RTCD                                        CSW024
     C                   PARM      '*VERIFY'     @OPTN                                        CSW024
     C                   PARM      'CSW024'      @SARD                                        CSW024
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSW024
      *                                                                                       CSW024
     C     @RTCD         IFEQ      *BLANK                                                     CSW024
     C                   MOVEL     'Y'           CSW024            1                          CSW024
     C                   ELSE                                                                 CSW024
     C                   MOVEL     'N'           CSW024                                       CSW024
     C                   ENDIF                                                                CSW024
      *                                                                                       CSD012
      ** Access SAR details file to determine if CSD012                                       CSD012
      ** (Standing Data Authorisation) is on.                                                 CSD012
     C                   CALLB     'AOSARDR0'                                                 CSD012
     C                   PARM      *BLANKS       @RTCD                                        CSD012
     C                   PARM      '*VERIFY'     @OPTN                                        CSD012
     C                   PARM      'CSD012'      @Sard                                        CSD012
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC012
      *                                                                                       CSD012
     C     @RTCD         IFEQ      *BLANK                                                     CSD012
     C                   MOVE      'Y'           CSD012                                       CSD012
     C                   ELSE                                                                 CSD012
     C                   MOVE      'N'           CSD012                                       CSD012
     C                   ENDIF                                                                CSD012
                                                                                              CSD012
      ** If CSD012 is ON, Check if Customer Details Authorisation is ON                       CSD012
 B1  C     CSD012        IFEQ      'Y'                                                        CSD012
      *                                                                                       CSD012
     C                   CALL      'AOSVALR0'                                                 CSD012
     C                   PARM                    @RTCD                                        CSD012
     C                   PARM      SVALKK        SVALK1           20                          CSD012
     C                   PARM                    SVAL1           200                          CSD012
     C                   PARM                    SVALK2           20                          CSD012
     C                   PARM                    SVAL2           200                          CSD012
     C                   PARM                    SVALK3           20                          CSD012
     C                   PARM                    SVAL3           200                          CSD012
     C                   PARM                    SVALK4           20                          CSD012
     C                   PARM                    SVAL4           200                          CSD012
     C                   PARM                    SVALK5           20                          CSD012
     C                   PARM                    SVAL5           200                          CSD012
     C                   PARM                    SVALK6           20                          CSD012
     C                   PARM                    SVAL6           200                          CSD012
     C                   PARM                    SVALK7           20                          CSD012
     C                   PARM                    SVAL7           200                          CSD012
     C                   PARM                    SVALK8           20                          CSD012
     C                   PARM                    SVAL8           200                          CSD012
     C                   PARM                    SVALK9           20                          CSD012
     C                   PARM                    SVAL9           200                          CSD012
     C                   PARM                    SVALK0           20                          CSD012
     C                   PARM                    SVAL10          200                          CSD012
      *                                                                                       CSD012
     C     @RTCD         IFNE      *BLANKS                                                    CSD012
                                                                                              CSD012
     C     SVAL10        IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK0        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL9         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK9        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL8         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK8        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL7         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK7        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL6         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK6        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL5         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK5        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL4         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK4        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL3         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK3        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL2         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK2        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL1         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK1        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
                                                                                              CSD012
     C     *LOCK         IN        LDA                                                        CSD012
     C                   Z-ADD     902           DBASE                                        CSD012
     C                   MOVE      'SDSVALPD'    DBFILE                                       CSD012
     C                   MOVE      'SDCUSDUPC'   DBPGM                                        CSD012
     C                   OUT       LDA                                                        CSD012
     C                   EXSR      *PSSR                                                      CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
      ** If Customer Details Authorisation is On set to Authorise                             CSD012
     C     SVAL11        IFEQ      'Y'                                                        CSD012
     C                   MOVE      'Y'           AUTHRQ            1                          CSD012
     C                   ELSE                                                                 CSD012
     C                   MOVE      'N'           AUTHRQ                                       CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
 E1  C                   ENDIF                                                                CSD012
                                                                                              CGP001
      ** Check if Global Data Layout Enhancement (CGP001) is on.                              CGP001
                                                                                              CGP001
     C                   EVAL      CGP001 = 'N'                                               CGP001
                                                                                              CGP001
     C                   CALLB     'AOSARDR0'                                                 CGP001
     C                   PARM      *BLANKS       @RTCD                                        CGP001
     C                   PARM      '*VERIFY'     @OPTN                                        CGP001
     C                   PARM      'CGP001'      @SARD                                        CGP001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGP001
                                                                                              CGP001
     C                   IF        @RTCD = *BLANKS                                            CGP001
     C                   EVAL      CGP001 = 'Y'                                               CGP001
     C                   ENDIF                                                                CGP001
                                                                                              CGP001
     C                   IF        @RTCD <> *BLANKS and                                       CGP001
     C                             @RTCD <> '*NRF   '                                         CGP001
     C     *LOCK         IN        LDA                                                        CGP001
     C                   EVAL      DBKEY = 'CGP001'                                           CGP001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGP001
     C                   EVAL      DBASE = 902                                                CGP001
     C                   OUT       LDA                                                        CGP001
     C                   EXSR      *PSSR                                                      CGP001
     C                   ENDIF                                                                CGP001
                                                                                              CLE025
      ** Check if enhancement CLE025 (Multi-Option Facilities) is on                          CLE025
                                                                                              CLE025
     C                   CALLB     'AOSARDR0'                                                 CLE025
     C                   PARM      *BLANKS       PRTCD                                        CLE025
     C                   PARM      '*VERIFY'     POPTN                                        CLE025
     C                   PARM      'CLE025'      PSARD                                        CLE025
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE025
                                                                                              CLE025
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CLE025
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CLE025
     C                   EVAL      DBKEY  = 'CLE025'                                          CLE025
     C                   EVAL      DBASE  = 902                                               CLE025
     C                   EXSR      *PSSR                                                      CLE025
     C                   ENDIF                                                                CLE025
      *                                                                                       CLE025
     C                   IF        PRTCD = *BLANKS                                            CLE025
     C                   EVAL      CLE025 = 'Y'                                               CLE025
     C                   ELSE                                                                 CLE025
     C                   EVAL      CLE025 = 'N'                                               CLE025
     C                   ENDIF                                                                CLE025
                                                                                              CGP001
      ** Check if enhancement CFX001 (FX Margin Trading) is on                                CFX001
                                                                                              CFX001
     C                   CALLB     'AOSARDR0'                                                 CFX001
     C                   PARM      *BLANKS       PRTCD                                        CFX001
     C                   PARM      '*VERIFY'     POPTN                                        CFX001
     C                   PARM      'CFX001'      PSARD                                        CFX001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFX001
                                                                                              CFX001
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CFX001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CFX001
     C                   EVAL      DBKEY  = 'CFX001'                                          CFX001
     C                   EVAL      DBASE  = 903                                               CFX001
     C                   EXSR      *PSSR                                                      CFX001
     C                   ENDIF                                                                CFX001
      *                                                                                       CFX001
     C                   IF        PRTCD = *BLANKS                                            CFX001
     C                   EVAL      CFX001 = 'Y'                                               CFX001
     C                   ELSE                                                                 CFX001
     C                   EVAL      CFX001 = 'N'                                               CFX001
     C                   ENDIF                                                                CFX001
      *
     C* Overrride SDCUSTLR
     C                   Z-ADD     50            MESLEN           15 5
     C                   CALL      'QCMDEXC'
     C                   PARM                    ##OX1
     C                   PARM                    MESLEN
     C* Overrride SDCBRTLR
     C                   CALL      'QCMDEXC'
     C                   PARM                    ##OX2
     C                   PARM                    MESLEN
     C* Overrride PTYHSTLR
     C                   CALL      'QCMDEXC'
     C                   PARM                    ##OX3
     C                   PARM                    MESLEN
     C* Overrride SDPBDSLR
     C                   CALL      'QCMDEXC'
     C                   PARM                    ##OX4
     C                   PARM                    MESLEN

      ** Overrride SDTICSLR                                                                  BUG3362
      *                                                                                      BUG3362
     C                   CALL      'QCMDEXC'                                                 BUG3362
     C                   PARM                    ##OX5                                       BUG3362
     C                   PARM                    MESLEN                                      BUG3362
     C                   Z-ADD     51            MESLEN           15 5                        CGP001
      ** Overrride GPCUSTXLR                                                                  CGP001
     C                   CALL      'QCMDEXC'                                                  CGP001
     C**********         PARM                    ##OX5                                CGP001 BUG3362
     C                   PARM                    ##OX6                                       BUG3362
     C                   PARM                    MESLEN                                       CGP001

      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SDCUSDU012
                                                                                             LLN022A
      ** Access SAR details file to determine if Bank of England is                          LLN022A
      ** switched on                                                                         LLN022A
      *                                                                                      LLN022A
     C                   CALLB     'AOSARDR0'                                                LLN022A
     C                   PARM      *BLANKS       @RTCD             7                         LLN022A
     C                   PARM      '*VERIFY'     @OPTN             7                         LLN022A
     C                   PARM      'LLN007'      @SARD             6                         LLN022A
     C     SCSARD        PARM      SCSARD        DSFDY                                       LLN022A
     C     @RTCD         IFEQ      *BLANK                                                    LLN022A
     C                   MOVEL     'Y'           LLN007            1                         LLN022A
     C                   ELSE                                                                LLN022A
     C                   MOVEL     'N'           LLN007                                      LLN022A
     C                   END                                                                 LLN022A
      *                                                                                       CER001
      ** ULX004 - European Reporting as Feature                                               CER001
      *                                                                                       CER001
     C                   MOVEL     'N'           ULX004            1                          CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX004'      @SARD                                        CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
      *                                                                                       CER001
     C                   IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '                  CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   EVAL      DBKEY  = 'ULX004'                                          CER001
     C                   EVAL      DBASE  = 904                                               CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C     @RTCD         IFEQ      *BLANKS                                                    CER001
     C                   MOVEL     'Y'           ULX004                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** ULU002 - New IBLC as feature                                                         CER001
      *                                                                                       CER001
     C                   MOVEL     'N'           ULU002            1                          CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULU002'      @SARD                                        CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
      *                                                                                       CER001
     C                   IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '                  CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   EVAL      DBKEY  = 'ULU002'                                          CER001
     C                   EVAL      DBASE  = 905                                               CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C     @RTCD         IFEQ      *BLANKS                                                    CER001
     C                   MOVEL     'Y'           ULU002                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** ULX609 - API Luxembourg - Function SDCUSD                                            CER001
      *                                                                                       CER001
     C                   MOVEL     'N'           ULX609            1                          CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX609'      @SARD                                        CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
      *                                                                                       CER001
     C                   IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '                  CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   EVAL      DBKEY  = 'ULX609'                                          CER001
     C                   EVAL      DBASE  = 906                                               CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C     @RTCD         IFEQ      *BLANKS                                                    CER001
     C                   MOVEL     'Y'           ULX609                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C     ULX609        IFEQ      'Y'                                                        CER001
     C     ULX004        ANDEQ     'Y'                                                        CER001
     C                   OPEN      SDVCULX2L1                                                 CER001
     C                   OPEN      SDVECUX2PD                                                 CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** ULX043 - IBLC 2002                                                                   CER001
      *                                                                                       CER001
     C                   MOVEL     'N'           ULX043            1                          CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX043'      @SARD                                        CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
      *                                                                                       CER001
     C                   IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '                  CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   EVAL      DBKEY  = 'ULX043'                                          CER001
     C                   EVAL      DBASE  = 907                                               CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C     @RTCD         IFEQ      *BLANKS                                                    CER001
     C                   MOVEL     'Y'           ULX043                                       CER001
     C                   OPEN      SDVCULX1L0                                                 CER001
     C                   OPEN      SDVECUX1PD                                                 CER001
     C                   ENDIF                                                                CER001
                                                                                             CSW207A
      ** Check if SWIFT 2007 is installed                                                    CSW207A
                                                                                             CSW207A
     C                   CALL      'SWIF2007'                                                CSW207A
     C                   PARM      *BLANKS       PRtCd                                       CSW207A
                                                                                             CSW207A
     C                   IF        PRtCd = 'CSW2007'                                         CSW207A
     C                   EVAL      CSW207 = 'Y'                                              CSW207A
     C                   ELSE                                                                CSW207A
     C                   EVAL      CSW207 = 'N'                                              CSW207A
     C                   ENDIF                                                               CSW207A
                                                                                             CSW207A

     C                   ENDSR
     C****************************************************************
      /EJECT
      *****************************************************************
     C*                                                              *
     C* SRERR - EXCEPTION ERRORS                                     *
     C*                                                              *
     C****************************************************************
     C     SRERR         BEGSR
     C*
     C                   MOVEL     '*ERROR '     @@RTCD
     C                   MOVEL     'SDCUSDUPD'   DBPGM            10
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   DUMP
     C*
     C**  TERMINATE THE PROGRAM
     C*
     C                   RETURN
     C*
     C                   ENDSR
     C****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      /EJECT
**  CPY@
(c) Finastra International Limited 2001
** ##OX1
OVRDBF FILE(SDCUSTLR) TOFILE(SDCUSTL0) SHARE(*NO)
** ##OX2
OVRDBF FILE(SDCBRTLR) TOFILE(SDCBRTL1) SHARE(*NO)
** ##OX3
OVRDBF FILE(PTYHSTPR) TOFILE(PTYHSTPD) SHARE(*NO)
** ##OX4
OVRDBF FILE(SDPBDSLR) TOFILE(SDPBDSL0) SHARE(*NO)
** ##OX5                                                                                      CGP001
OVRDBF FILE(SDTICSLR) TOFILE(SDTICSL0) SHARE(*NO)                                            BUG3362
** ##OX6                                                                                     BUG3362
OVRDBF FILE(GPCUSTXLR) TOFILE(GPCUSTXL0) SHARE(*NO)                                           CGP001
** CMD
OVRDBF FILE(SDAULGL2) TOFILE(SDAULGL2) SHARE(*NO)
