     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Deal amendment retr + act/repo validation')   *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMRPMCRTV - DEAL AMENDMENTS RETRIEVE                         *
      *              (WITH ACTION CODE VERSUS DEAM NUMBER VALIDATION  *
      *                                                               *
      *  Function:  This module retrieves a deal amendment from       *
      *             the database for Repo Margin Calls. As it does    *
      *             it validates the action code, deal number etc.    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CDL096             Date 22Sep14               *
      *  Prev Amend No. CDL094             Date 11Jun14               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 11Jul06               *
      *                 BUG8550            Date 16Jun06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 BUG7411            Date 01Jun05               *
      *                 CDL028             Date 07Feb05               *
      *                 229544             Date 15Sep04               *
      *                 CDL022             Date 03Feb04               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 222373             Date 27Oct03               *
      *                 CDL010             Date 02Aug02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 185131             Date 18Oct00               *
      *                 187323             Date 11Jul01               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSE006  *CREATE    Date 22Jul99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  BUG8550 - Reposition capture of ZMUSER data area             *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  BUG7411- CDL028 fields missing from DLGHISPD (Recompile)     *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  229544 - Recompiled due to inserted fields in DLCHISPD.      *
      *  CDL022 - Deal Amendment Changes (Recompile)                  *
      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *           (Recompile)                                         *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CDL016 - Automatic rollover of Fixed Term Loans/Deposits     *
      *           (Recompile)                                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  222373 - Parameter Mismatch                                  *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.Recompile due to changes in MMDELDPP *
      *           MMDEAMPP, MMDENBPP and MMDENSPP .                   *
      *  185131 - Program loop when Amend or Delete a repo, bond      *
      *           lending or pledge deposit if it does not have a     *
      *           deal amendment of type PI or PD                     *
      *  187323 - DB Error 002 if Value date is a holiday             *
      *  CSE006 - Repurchase agreements                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FMMDEAML0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(MMDEAMP0:MMDEAMOI)
     FMMDEALL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(MMDELDP0)
     F                                     INCLUDE(MMDENBP0)
     F                                     RENAME(MMDELDP0:MMDELFOI)
     F                                     RENAME(MMDENBP0:MMDENBOI)
     FMMDEALLL  IF   E           K DISK    INFSR(*PSSR)
     F                                     INFDS(INFDS)
     FMMDEAMLL  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(MMDEAMP0:MMDEAMP2)
     FMMLVDMLL  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(MMDEAMP0:MMDEAMP4)
     FFDDLNMLL  IF   E             DISK    INFSR(*PSSR)
     FDEALSH    IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(DEALSDBF:DEALSHBF)
     F                                     RENAME(DEALSDCF:DEALSHCF)
     F                                     RENAME(DEALSDDF:DEALSHDF)
     F                                     RENAME(DEALSDEF:DEALSHEF)
     F                                     RENAME(DEALSDGF:DEALSHGF)
 
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
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D @DT2            S              2    DIM(15) CTDATA PERRCD(15)
     D**  ARRAY TO LOOK UP MIDAS DEAL TYPE FOR VALIDATION.
     D*
      **  Data structure for file status of MM deals file.
     D INFDS           DS
     D  RECORD           *RECORD
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
 
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      ** EXTERNAL DS FOR DEALING DETAILS
     D  QQACCD1      E                     EXTFLD(QQACCD)                                     CGL029
 
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** EXTERNAL DS FOR BRANCH DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D ZMUSER          DS            17
     D  BRC                   11     13
     D  DEPT                  14     16
 
     D DeamFilFmt    E DS                  EXTNAME(MMDEAMPP)
      ** Deam in File Format
     D  @DMVYR                51     52
     D  @DMVMT                53     54
     D  @DMVDY                55     56
 
      **  Data Structure to split value date used in key to deams file
     D                 DS
     D  @KVALD                 1      8  0 INZ(0)
     D  @VDYY                  1      4  0
     D  @VYEAR                 3      4  0
     D  @VDMM                  5      6  0
     D  @VDDD                  7      8  0
     D                 DS
     D**  Data Structure for input start/last interest date
     D  H@SLDT                 1      8  0 INZ(0)
     D  H@SLYY                 1      4  0
     D  H@SLMM                 5      6  0
     D  H@SLDD                 7      8  0
     D*
     D                 DS
     D**  Data Structure for input interest accrual control date
     D  H@IADT                 1      8  0 INZ(0)
     D  H@IAYY                 1      4  0
     D  H@IAMM                 5      6  0
     D  H@IADD                 7      8  0
     D*
     D                 DS
     D**  Data Structure for input maturity date
     D  H@MATD                 1      8  0 INZ(0)
     D  H@MDYY                 1      4  0
     D  H@MDMM                 5      6  0
     D  H@MDDD                 7      8  0
     D*
     D                 DS
     D**  Data structure for convertion of YYMMDD to DDMMYY
     D  @DMVDT                 1      6
     D  @DMVD                  1      2
     D  @DMVM                  3      4
     D  @DMVY                  5      6
 
      ** Valid Value Date reformatted returned as a parameter from MMVVLDT
     D IGVDYY          S              4S 0
     D IGVDMM          S              2S 0
     D IGVDDD          S              2S 0
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Ix              S              3P 0
 
      ** Fields used by Module ZDATE10 to change date format.
     D DateIn          S              8S 0
     D DateOut         S              5  0
 
      ** Error message code 1 sent as a parameter
     D Msgid1          S                   LIKE(#MSGID)
     D Msgid2          S                   LIKE(#MSGID)
 
      ** Warning message code 1 sent as a parameter
     D WMsgid1         S                   LIKE(#MSGID)
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
 
 
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
     I*
     I** Rename fields on deals file with common names
     I** to simplify processing
     IMMDELDP0
     I              HKRCID                      H@RCID
     I              HKDSTS                      H@DSTS
     I              HKDLTF                      H@DLTF
     I              HKDN38                      H@DN38
     I              HKDDLT                      H@DDLT
     I              HKMTYP                      H@MTYP
     I              HKAMNP                      H@AMNP
     I              HKBRCA                      H@BRCA
     I              HKSLYY                      H@SLYY
     I              HKSLMM                      H@SLMM
     I              HKSLDD                      H@SLDD
     I              HKIAYY                      H@IAYY
     I              HKIAMM                      H@IAMM
     I              HKIADD                      H@IADD
     I              HKTYPE                      H@TYPE
     I              HKMDYY                      H@MDYY
     I              HKMDMM                      H@MDMM
     I              HKMDDD                      H@MDDD
     I              HKORBR                      H@ORBR
     I*
     IMMDENBP0
     I              HLRCID                      H@RCID
     I              HLDSTS                      H@DSTS
     I              HLDLTF                      H@DLTF
     I              HLDN38                      H@DN38
     I              HLDDLT                      H@DDLT
     I              HLMTYP                      H@MTYP
     I              HLAMNP                      H@AMNP
     I              HLBRCA                      H@BRCA
     I              HLLIYY                      H@SLYY
     I              HLLIMM                      H@SLMM
     I              HLLIDD                      H@SLDD
     I              HLIAYY                      H@IAYY
     I              HLIAMM                      H@IAMM
     I              HLIADD                      H@IADD
     I              HLTYPE                      H@TYPE
     I              HLORBR                      H@ORBR
     I*
      /EJECT
     C**************************************************************
      *
      * INITIALIZATION
      *
      *                                                                                      BUG8550
      **  GET ZMUSER to access default branch.                                               BUG8550
      *                                                                                      BUG8550
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG8550
     C                   IN        ZMUSER                                                    BUG8550
     C                   UNLOCK    ZMUSER                                                    BUG8550
      *                                                                                      BUG8550
     C                   EXSR      INIT
      *
      * IF THE MODE IS 'FRONT OFFICE TRANSACTION INTERFACE'
      * DO (EXTRA) VALIDATION FOR FRONT OFFICE TRANSACTION INTERFACE
      *
     C     ModeofOp      IFEQ      '*FRONT'
     C                   EXSR      VFRNT
      *
      **  Carry out no further validation if errors have occurred.
      *
     C     OKACTN        IFEQ      'N'
     C     OKDLNO        OREQ      'N'
     C                   RETURN
     C                   END
     C                   END
      *
      * VALIDATE ACTION CODE, DEAL NUMBER, VALUE DATE & SEQUENCE NUMBER
      *
     C                   EXSR      VAL
      *
      **  Carry out no further validation if errors have occurred.
      *
     C     OKACTN        IFEQ      'N'
     C     OKDLNO        OREQ      'N'
     C     OKVDAT        OREQ      'N'
     C     OKSEQN        OREQ      'N'
     C                   RETURN
     C                   END
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'E' *
      *  *--------------------------------*
      *
     C     DDACTN        IFEQ      'E'
     C                   EXSR      VALACE
     C                   END
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'X' *
      *  *--------------------------------*
      *
     C     DDACTN        IFEQ      'X'
     C                   EXSR      VALACX
     C                   END
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'I' *
      *  *--------------------------------*
      *
     C     DDACTN        IFEQ      'I'
     C                   EXSR      VALACI
     C                   END
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'A' *
      *  *--------------------------------*
      *
     C     DDACTN        IFEQ      'A'
     C                   EXSR      VALACA
     C                   END
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'D' *
      *  *--------------------------------*
      *
     C     DDACTN        IFEQ      'D'
     C                   EXSR      VALACD
     C                   END
      *
      **  Carry out no further validation if errors occurred.
      *
     C     OKACTN        IFEQ      'N'
     C     OKDLNO        OREQ      'N'
     C                   RETURN
     C                   END
      *
      ** Set up Value Date
      *
     C     OKVDAT        IFEQ      'Y'
     C                   MOVE      @VDYNO        HNDVSD
     C                   ENDIF
      *
      *  *-----------------------------------------------*
      *  * Access Security Checking                      *
      *  *-----------------------------------------------*
      *
     C     RespMode      IFEQ      'S'
     C                   EXSR      ACSSEC
     C                   END
      *
      * Return
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * VFRNT - VALIDATION FOR FRONT OFFICE TRANSACTION INTERFACE
      *****************************************************************
     C     VFRNT         BEGSR
      *
      * ERROR IF ACTION CODE IS NOT 'I', 'A, 'D' or 'X'
      *
     C     DDACTN        IFNE      'I'
     C     DDACTN        ANDNE     'A'
     C     DDACTN        ANDNE     'D'
     C     DDACTN        ANDNE     'X'
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0100'     MsgIdArr(Ix)
     C                   GOTO      EVFRNT
     C                   END
      *
      * ERROR IF FRONT OFFICE TRANSACTION ID IS BLANK
      *
     C     FOTRID        IFEQ      *BLANK
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0101'     MsgIdArr(Ix)
     C                   GOTO      EVFRNT
     C                   END
      *
      * ERROR IF FRONT OFFICE ASSOCIATED TRANS ID (ORIGINAL DEAL NO)
      * IS BLANK
      *
     C     FOASID        IFEQ      *BLANK
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0105'     MsgIdArr(Ix)
     C                   GOTO      EVFRNT
     C                   END
      *
      * ACCESS DEAL AMENDMENT WITH FRONT OFFICE TRANSACTION ID
      *
     C                   MOVE      FOASID        OrigDealNo       20
     C                   MOVE      FOTRID        UniqDeamID       20
 
     C     FrntOfKey     CHAIN     MMDEAMOI                           99
      *
      * IF INSERT
      *
     C     DDACTN        IFEQ      'I'
      *
      * FRONT OFFICE TRANSACTION ID CAN'T BE PRESENT ALREADY
      *
     C     *IN99         IFEQ      '0'
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0102'     MsgIdArr(Ix)
     C                   MOVEL     FOTRID        MsgDtaArr(Ix)
     C                   GOTO      EVFRNT
     C                   END
      *
     C                   ELSE
      *
      * IF NOT INSERT, FRONT OFFICE TRANSACTION ID MUST BE PRESENT
      *
     C     *IN99         IFEQ      '1'
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0103'     MsgIdArr(Ix)
     C                   MOVEL     FOTRID        MsgDtaArr(Ix)
     C                   GOTO      EVFRNT
     C                   END
      *
      * IF NOT INSERT, UPDATE SEQUENCE NUMBER
      *
     C                   MOVEL     HNDS38        DDDS38
     C                   END
      *
      * FRONT OFFICE ASSOCIATED TRANSACTION ID
      * MUST POINT TO A MIDAS DEAL
      *
     C     FOASID        CHAIN     MMDELFOI                           99
     C     *IN99         IFEQ      '1'
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0104'     MsgIdArr(Ix)
     C                   MOVEL     FOASID        MsgDtaArr(Ix)
     C                   GOTO      EVFRNT
     C                   END
      *
     C                   MOVEL     HKDN38        DDDLNO
      *
     C     EVFRNT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL - VALIDATION OF ACTION CODE AND DEAL NUMBER/VALUE DATE/SEQUENCE
      *****************************************************************
     C     VAL           BEGSR
     C*
     C**  Check that the action code is valid; if authorizations are
     C**  not in the system, then action code X is not allowed.
     C*
     C     BNMMAU        IFEQ      'N'
     C     DDACTN        ANDNE     'I'
     C     DDACTN        ANDNE     'A'
     C     DDACTN        ANDNE     'D'
     C     DDACTN        ANDNE     'E'
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'MMM0161'     MsgIdArr(Ix)
     C                   END
     C*
     C     BNMMAU        IFNE      'N'
     C     DDACTN        ANDNE     'I'
     C     DDACTN        ANDNE     'A'
     C     DDACTN        ANDNE     'D'
     C     DDACTN        ANDNE     'E'
     C     DDACTN        ANDNE     'X'
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'MMM0160'     MsgIdArr(Ix)
     C                   END
     C*
     C**  Validate that key fields are numeric or blank.
     C*
     C**  Validate that deal number is numeric & not blank.
     C*
     C                   TESTN                   DDDLNO               98
     C                   MOVE      DDDLNO        @@TEST            1
     C                   TESTZ                   @@TEST                   99
     C*
     C     DDDLNO        IFEQ      *BLANK
     C     *IN98         OREQ      '0'
     C     *IN99         OREQ      '0'
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0145'     MsgIdArr(Ix)
     C                   END
     C*
     C**  Set up the deal number as a numeric field.
     C*
     C                   MOVE      DDDLNO        @@DLNO            6 0
     C*
     C**  Set up the deal number on MMDEAMPP
     C*
     C                   MOVE      DDDLNO        HNDA38
     C*
     C** Ensure that Repo indicator is 'R', 'P' or 'B'
     C*
     C     OKDLNO        IFNE      'N'
     C     @@DLNO        CHAIN     MMDEALLL                           89
     C     *IN89         IFNE      *OFF
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMA0737'     MsgIdArr(Ix)
     C                   ELSE
     C*
     C                   IF        HKDRID <> 'R' and HKDRID <> 'P'
     C                             and HKDRID <> 'B'
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMA0727'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C*
     C** Format the Transaction Type
     C                   IF        H@MTYP = 'IT' or H@MTYP = 'CD'
     C                             or H@MTYP = 'TD'
     C
     C                   IF        HKDRID = 'R'
     C                   EVAL      DDRTYP = 'REPO'
     C                   ENDIF
     C
     C                   IF        HKDRID = 'B'
     C                   EVAL      DDRTYP = 'BOND LENDING'
     C                   ENDIF
     C
     C                   IF        HKDRID = 'P'
     C                   EVAL      DDRTYP = 'PLEDGE DEPOSIT'
     C                   ENDIF
     C
     C                   ENDIF
     C
     C                   IF        H@MTYP = 'IP' or H@MTYP = 'CL'
     C                             or H@MTYP = 'TI'
     C
     C                   IF        HKDRID = 'R'
     C                   EVAL      DDRTYP = 'REVERSE REPO'
     C                   ENDIF
     C
     C                   IF        HKDRID = 'B'
     C                   EVAL      DDRTYP = 'BOND BORROWING'
     C                   ENDIF
     C
     C                   IF        HKDRID = 'P'
     C                   EVAL      DDRTYP = 'PLEDGE LOAN'
     C                   ENDIF
     C
     C                   ENDIF
      *
      **  Validate that the value date is a valid date.
      *
     C                   MOVE      HKNTCE        P#NTCE
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'MMVVLDT'
     C                   PARM                    ReturnCode
     C                   PARM                    Msgid1
     C                   PARM                    WMsgid1
     C                   PARM                    DDVDAT
     C                   PARM                    DDMTYP            2
     C                   PARM                    DDACTN
     C                   PARM                    DDDLNO
     C                   PARM                    H@RCID
     C                   PARM                    HKCCY
     C                   PARM                    P#NTCE            3
     C                   PARM                    BJRDNB
     C                   PARM                    BJLCCY
     C                   PARM                    BJDFIN
     C                   PARM                    BJSLCD
     C                   PARM                    @RLOC             3
     C                   PARM                    @VDYNO            5 0
     C                   PARM                    IGVDYY
     C                   PARM                    IGVDMM
     C                   PARM                    IGVDDD
     C                   PARM                    DDCASE                                       222373
     C
     C     WMsgid1       IFNE      *Blanks
     C***********        MOVE      'N'           OKVDAT                                       187323
     C                   MOVEL     'DDVDAT'      WFldNamArr(1)
     C                   MOVEL     'MMA0738'     WMsgIdArr(1)
     C                   ENDIF
     C
     C     Msgid1        IFNE      *Blanks
     C                   MOVE      'N'           OKVDAT
     C                   ADD       1             Ix
     C                   MOVEL     'DDVDAT'      FldNameArr(Ix)
     C                   MOVEL     'MMA0728'     MsgIdArr(Ix)
     C                   ELSE
     C                   MOVE      IGVDYY        HNVDYY
     C                   MOVE      IGVDMM        HNVDMM
     C                   MOVE      IGVDDD        HNVDDD
     C                   MOVE      @VDYNO        HNDVSD
     C                   MOVE      IGVDYY        @VDYY
     C                   MOVE      IGVDMM        @VDMM
     C                   MOVE      IGVDDD        @VDDD
     C                   ENDIF
      *
     C                   EXSR      RESETERRS
      *
      **  Validate Cash/Securities field
      *
     C                   CALLB     'MMVSEIN'
     C                   PARM                    ReturnCode
     C                   PARM                    Msgid1
     C                   PARM                    Msgid2
     C                   PARM                    DDCASE
     C                   PARM                    H@MTYP
     C
     C     Msgid1        IFNE      *Blanks
     C                   MOVE      'N'           OKCASE
     C                   ADD       1             Ix
     C                   MOVEL     'DDCASE'      FldNameArr(Ix)
     C                   MOVEL     'MMA0729'     MsgIdArr(Ix)
     C                   ENDIF
     C
     C     Msgid2        IFNE      *Blanks
     C                   MOVE      'N'           OKCASE
     C                   ADD       1             Ix
     C                   MOVEL     'DDCASE'      FldNameArr(Ix)
     C                   MOVEL     'MMA0730'     MsgIdArr(Ix)
     C                   ENDIF
     C*
     C** If cash/securites indicator is 'S' action code can only be 'I' or
     C** 'E'.
     C*
     C     DDCASE        IFEQ      'S'
     C     DDACTN        IFNE      'I'
     C     DDACTN        ANDNE     'E'
     C*
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'MMA0726'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
     C*
     C     EVAL          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACE - VALIDATION OF ACTION CODE 'E'
      *****************************************************************
     C     VALACE        BEGSR
     C*
     C**  If the deal number is blank, it is an error.
     C*
     C     DDDLNO        IFEQ      *BLANKS
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0111'     MsgIdArr(Ix)
     C                   GOTO      EVALAE
     C                   END
     C*
     C**  If there is no valid record on MMDEAMLL, it is an error.
     C*
     C                   IF        DDCASE <> 'S'
     C*
     C                   Z-ADD     999           @DEAMS
     C     @DEAMK        SETGT     MMDEAMLL                           65
     C                   DOU       HNMTYP = 'PI' or HNMTYP = 'PD'
     C                             or *IN65 = *On
     C                   READP     MMDEAMLL                               65
     C                   ENDDO
     C*
     C**  Check for a valid record.
     C*
     C     *IN65         IFEQ      '1'
     C     HNDDLT        ORNE      *BLANKS
     C     *IN65         OREQ      '0'
     C     @@DLNO        ANDNE     HNDA38
     C     *IN65         OREQ      '0'
     C     @VDYY         ANDNE     HNVDYY
     C     *IN65         OREQ      '0'
     C     @VDMM         ANDNE     HNVDMM
     C     *IN65         OREQ      '0'
     C     @VDDD         ANDNE     HNVDDD
     C                   MOVE      'N'           OKDLNO
     C                   MOVE      'N'           OKVDAT
     C                   MOVE      'N'           OKSEQN
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0157'     MsgIdArr(Ix)
     C                   GOTO      EVALAE
     C                   ELSE
     C*
     C**  If the deal status is not C,A or R, it is an error.
     C*
     C     HNDSTS        IFNE      'C'
     C     HNDSTS        ANDNE     'A'
     C     HNDSTS        ANDNE     'R'
     C                   MOVE      'N'           OKDLNO
     C                   MOVE      'N'           OKVDAT
     C                   MOVE      'N'           OKSEQN
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0148'     MsgIdArr(Ix)
     C                   GOTO      EVALAE
     C                   END
     C                   END
     C                   END
     C*
     C     EVALAE        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACX - VALIDATION OF ACTION CODE 'X'
      *****************************************************************
     C     VALACX        BEGSR
     C*
     C**  If the deal number is blank, it is an error.
     C*
     C     DDDLNO        IFEQ      *BLANKS
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0111'     MsgIdArr(Ix)
     C                   GOTO      EVALAX
     C                   END
     C*
     C* CHECK IF PREVIOUS DEAMS ARE AUTHORISED OR DELETED
     C*
     C                   Z-ADD     999           @DEAMS
     C     @DEAMK        SETGT     MMDEAMLL                           65
     C                   DOU       HNMTYP = 'PI' or HNMTYP = 'PD'
     C                             or *IN65 = *On
     C                   READP     MMDEAMLL                               65
     C                   ENDDO
     C                   MOVE      HNDS38        @DEAMS
     C     @DEAMY        READPE    MMDEAMLL                               65
B2   C     *IN65         DOWEQ     '0'
B3   C     HNDSTS        IFNE      'A'
     C     HNDDLT        ANDEQ     ' '
     C                   MOVE      'N'           OKDLNO
     C                   MOVE      'N'           OKVDAT
     C                   MOVE      'N'           OKSEQN
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM015A'     MsgIdArr(Ix)
     C                   GOTO      EVALAX
X3   C                   ELSE
     C     @DEAMY        READPE    MMDEAMLL                               65
E3   C                   ENDIF
E2   C                   ENDDO
     C*
     C**  If there is no valid, undeleted record on MMDEAMLL, it is an
     C**  error.
     C*
     C     @DEAMK        CHAIN     MMDEAMLL                           65
     C*
     C     *IN65         IFEQ      '1'
     C     HNDLTF        ORNE      *BLANK
     C     HNDDLT        ORNE      *BLANK
     C                   MOVE      'N'           OKDLNO
     C                   MOVE      'N'           OKVDAT
     C                   MOVE      'N'           OKSEQN
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0147'     MsgIdArr(Ix)
     C                   GOTO      EVALAX
     C                   ELSE
     C*
     C** Deam status indicator  must be 'C' or 'R'
     C*
     C     HNDSTS        IFNE      'C'
     C     HNDSTS        ANDNE     'R'
     C                   MOVE      'N'           OKDLNO
     C                   MOVE      'N'           OKVDAT
     C                   MOVE      'N'           OKSEQN
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0290'     MsgIdArr(Ix)
     C                   ELSE
     C*
     C**  Access Original Deal:
     C**  If no valid record is found, or the record does not have a
     C**  status of 'A' or 'R', it is an error.
     C*
     C     HNDA38        CHAIN     MMDEALLL                           65
     C*
     C     *IN65         IFEQ      '1'
     C     H@DSTS        ORNE      'A'
     C     H@DSTS        ANDNE     'R'
     C                   MOVE      'N'           OKDLNO
     C                   MOVE      'N'           OKVDAT
     C                   MOVE      'N'           OKSEQN
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0173'     MsgIdArr(Ix)
     C                   GOTO      EVALAX
     C                   END
     C*
     C                   END
     C                   END
     C*
     C     EVALAX        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACI - VALIDATION OF ACTION CODE 'I'
      *****************************************************************
     C     VALACI        BEGSR
     C*
     C**  Check that the deal does not exist on the
     C**  MMDEAMLL  file; if it does it is an error.
     C                   Z-ADD     999           @DEAMS
     C     @DEAMK        SETGT     MMDEAMLL                           65
     C*
     C                   DOU       HNMTYP = 'PI' or HNMTYP = 'PD'
     C                             or *IN65 = *On
     C                   READP     MMDEAMLL                               65
     C                   ENDDO
     C*
     C     *IN65         IFEQ      '0'
     C     @@DLNO        ANDEQ     HNDA38
     C     @VDYY         ANDEQ     HNVDYY
     C     @VDMM         ANDEQ     HNVDMM
     C     @VDDD         ANDEQ     HNVDDD
     C
     C*
     C** Record already exists unless this is a securities amendment
     C     HNDDLT        IFEQ      *BLANKS
     C     DDCASE        ANDNE     'S'
     C                   MOVE      'N'           OKDLNO
     C                   MOVE      'N'           OKVDAT
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0149'     MsgIdArr(Ix)
     C                   GOTO      EVALAI
     C                   ELSE
     C                   IF        DDCASE <> 'S'
     C                   CLEAR                   DeamFilFmt
     C                   ENDIF
     C                   END
     C                   ELSE
     C                   CLEAR                   DeamFilFmt
     C                   END
     C*
     C** check that the Original Deal record exists
     C     @@DLNO        CHAIN     MMDEALLL                           65
     C*
     C** Check deal type is valid
     C*
     C** INITIALISE INDICATORS
     C                   Z-ADD     1             @N                2 0
     C                   MOVE      '0'           *IN75
     C*
     C     H@MTYP        LOOKUP    @DT2(@N)                               75
     C*
     C     *IN65         IFEQ      '1'
     C     *IN75         OREQ      '0'
     C     H@DLTF        ORNE      ' '
     C     H@DDLT        ORNE      ' '
     C                   MOVE      'N'           OKDLNO
     C                   MOVE      'N'           OKVDAT
     C                   MOVE      'N'           OKSEQN
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0150'     MsgIdArr(Ix)
     C                   GOTO      EVALAI
     C                   END
     C*
     C** Output Midas deal type
     C*
     C                   MOVEL     H@MTYP        HNOMDT
     C*
     C** Check that the deal does not exist on
     C** DEALSH file else, it is an error
     C*
     C     @@DLNO        CHAIN     DEALSH                             65
     C*
     C** Record already exists in DEALSH file
     C     *IN65         IFEQ      '0'
     C                   MOVE      'N'           OKDLNO
     C                   MOVE      'N'           OKVDAT
     C                   MOVE      'N'           OKSEQN
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0150'     MsgIdArr(Ix)
     C                   GOTO      EVALAI
     C                   END
     C*
     C** Check valid deal for key fields
     C                   EXSR      CHKKEYFLDS
     C*
     C** Set up Currency Fields and customer fields
     C                   MOVE      HKCCY         HNCCY
     C                   MOVE      HKCYDP        HNCYDP
     C                   MOVE      HKCNUM        HNCNUM
     C                   MOVE      HKCSNM        HNCSNM
     C*
     C     EVALAI        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACA - VALIDATION OF ACTION CODE 'A'
      *****************************************************************
     C     VALACA        BEGSR
     C*
     C**  If the deal number is blank, it is an error.
     C*
     C     DDDLNO        IFEQ      *BLANKS
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0111'     MsgIdArr(Ix)
     C                   GOTO      EVALAA
     C                   END
     C*
     C**  If there is no valid, undeleted record on MMDEAMLL , it is an
     C**  error.
     C*
     C                   Z-ADD     999           @DEAMS
     C     @DEAMK        SETGT     MMDEAMLL                           65
     C*
     C                   DOU       HNMTYP = 'PI' or HNMTYP = 'PD'
     C                             or *IN65 = *On                                             185131
     C                   READP     MMDEAMLL                               65
     C                   ENDDO
     C*
     C     *IN65         IFEQ      '1'
     C*****HNDLTF        ANDNE     *BLANK                                                     185131
     C     *IN65         OREQ      '0'
     C     @@DLNO        ANDNE     HNDA38
     C     *IN65         OREQ      '0'
     C     @VDYY         ANDNE     HNVDYY
     C     *IN65         OREQ      '0'
     C     @VDMM         ANDNE     HNVDMM
     C     *IN65         OREQ      '0'
     C     @VDDD         ANDNE     HNVDDD
     C                   MOVE      'N'           OKDLNO
     C                   MOVE      'N'           OKVDAT
     C                   MOVE      'N'           OKSEQN
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0157'     MsgIdArr(Ix)
     C                   GOTO      EVALAA
     C                   END
     C*
     C**  If the deam has been deleted, then it may not be amended.
     C*
     C     HNDDLT        IFNE      *BLANK
     C                   MOVE      'N'           OKDLNO
     C                   MOVE      'N'           OKVDAT
     C                   MOVE      'N'           OKSEQN
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0151'     MsgIdArr(Ix)
     C                   GOTO      EVALAA
     C                   END
     C*
     C**  If the record exists, its status must be C,A or R.
     C*
     C     HNDSTS        IFNE      'C'
     C     HNDSTS        ANDNE     'A'
     C     HNDSTS        ANDNE     'R'
     C                   MOVE      'N'           OKDLNO
     C                   MOVE      'N'           OKVDAT
     C                   MOVE      'N'           OKSEQN
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0152'     MsgIdArr(Ix)
     C                   GOTO      EVALAA
     C                   END
     C*
     C** Check valid deal for key fields
     C                   EXSR      CHKKEYFLDS
     C*
     C     EVALAA        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACD - VALIDATION OF ACTION CODE 'D'
      *****************************************************************
     C     VALACD        BEGSR
     C*
     C**  If the deal number is blank, it is an error.
     C*
     C     DDDLNO        IFEQ      *BLANKS
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0111'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
     C*
     C**  If there is no valid, undeleted record on MMDEAMLL , it is an
     C**  error.
     C*
     C                   Z-ADD     999           @DEAMS
     C     @DEAMK        SETGT     MMDEAMLL                           65
     C                   DOU       HNMTYP = 'PI' or HNMTYP = 'PD'
     C                             or *IN65 = *On                                             185131
     C                   READP     MMDEAMLL                               65
     C                   ENDDO
     C*
     C**  Check for a valid record.
     C*
     C     *IN65         IFEQ      '1'
     C     HNDLTF        ORNE      *BLANKS
     C     *IN65         OREQ      '0'
     C     @@DLNO        ANDNE     HNDA38
     C     *IN65         OREQ      '0'
     C     @VDYY         ANDNE     HNVDYY
     C     *IN65         OREQ      '0'
     C     @VDMM         ANDNE     HNVDMM
     C     *IN65         OREQ      '0'
     C     @VDDD         ANDNE     HNVDDD
     C     HNDLTF        ORNE      *BLANK
     C                   MOVE      'N'           OKDLNO
     C                   MOVE      'N'           OKVDAT
     C                   MOVE      'N'           OKSEQN
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0157'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
     C*
     C**  If a valid record exists and the deal deleted indicator is
     C**  not blank, it is an error.
     C*
     C     HNDDLT        IFNE      *BLANK
     C                   MOVE      'N'           OKDLNO
     C                   MOVE      'N'           OKVDAT
     C                   MOVE      'N'           OKSEQN
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0151'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
     C*
     C** if the record exists the status must be C A or R
     C*
     C     HNDSTS        IFNE      'C'
     C     HNDSTS        ANDNE     'A'
     C     HNDSTS        ANDNE     'R'
     C                   MOVE      'N'           OKDLNO
     C                   MOVE      'N'           OKVDAT
     C                   MOVE      'N'           OKSEQN
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0156'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
     C*
     C**If amendment type is 'PI' execute process 'Check deal amendment
     C** principle'   : MMP0082.
     C*
     C     DDMTYP        IFEQ      'PI'
     C     DDAMNP        IFNE      *BLANKS
     C*
     C                   EXSR      CHKDEAMPPL
     C*
     C** If invalid exit routine
     C     OKACTN        IFEQ      'N'
     C     OKDLNO        OREQ      'N'
     C                   GOTO      EVALAD
     C                   END
     C*
     C**  Reset deams file if amount passed principle validation check
     C**  Access only if current deam is not deam last accessed.
     C     @@DLNO        IFNE      HNDA38
     C     @VDYY         ORNE      HNVDYY
     C     @VDMM         ORNE      HNVDMM
     C     @VDDD         ORNE      HNVDDD
     C**   @DEAMS        ORNE      HNDS38
     C*
     C** deam must exist
     C     @DEAMK        CHAIN     MMDEAMLL                           65
     C     *IN65         IFEQ      '1'
     C     HNDLTF        ORNE      *BLANK
     C                   MOVE      'N'           OKDLNO
     C                   MOVE      'N'           OKVDAT
     C                   MOVE      'N'           OKSEQN
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0157'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
     C                   END
     C                   END
     C                   END
     C*
     C     EVALAD        ENDSR
      *****************************************************************
      /EJECT
     C*****************************************************************
     C*      CHKKEYFLDS - Check valid deal for key fields
     C*****************************************************************
     C     CHKKEYFLDS    BEGSR
     C*
     C** Access MMDEALLL if this has not been done for this deal number
     C     @@DLNO        IFNE      H@DN38
     C     @@DLNO        CHAIN     MMDEALLL                           65
     C     *IN65         IFEQ      '1'
     C                   MOVE      'N'           OKDLNO
     C                   MOVE      'N'           OKVDAT
     C                   MOVE      'N'           OKSEQN
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0184'     MsgIdArr(Ix)
     C                   GOTO      CHKKEYEND
     C                   END
     C                   END
     C*
     C** Convert dates used in compares to midas day numbers
     C*
     C                   Z-ADD     H@SLDT        DateIn
     C                   CALLB     'ZDATE10'
     C                   PARM                    DateIn
     C                   PARM                    DateOut
     C                   Z-ADD     DateOut       @SLDYN            5 0
     C*
     C                   Z-ADD     H@IADT        DateIn
     C                   CALLB     'ZDATE10'
     C                   PARM                    DateIn
     C                   PARM                    DateOut
     C                   Z-ADD     DateOut       @IADYN            5 0
     C*
     C     H@RCID        IFEQ      'HK'
     C                   Z-ADD     H@MATD        DateIn
     C                   CALLB     'ZDATE10'
     C                   PARM                    DateIn
     C                   PARM                    DateOut
     C                   Z-ADD     DateOut       @MDAYN            5 0
     C                   ELSE
     C                   Z-ADD     0             @MDAYN
     C                   END
     C*
     C     @VDYNO        IFLT      @SLDYN
     C     @VDYNO        ORLT      @IADYN
     C                   MOVE      'N'           OKVDAT
     C                   ADD       1             Ix
     C                   MOVEL     'DDVDAT'      FldNameArr(Ix)
     C                   MOVEL     'MMM0153'     MsgIdArr(Ix)
     C                   GOTO      CHKKEYEND
     C                   END
     C*
     C** Value date must be = or < than maturity date if maturity date
     C** is present
     C     @MDAYN        IFNE      0
     C     @VDYNO        ANDGE     @MDAYN
     C                   MOVE      'N'           OKVDAT
     C                   ADD       1             Ix
     C                   MOVEL     'DDVDAT'      FldNameArr(Ix)
     C                   MOVEL     'MMM0154'     MsgIdArr(Ix)
     C                   GOTO      CHKKEYEND
     C                   END
     C*
     C** For deam type 'SI' the deam value date must not be the same
     C** as the value date of a deam already existing on the deal.
     C** Also applys to deam type 'CI'.
     C     DDMTYP        IFEQ      'SI'
     C     DDACTN        ANDEQ     'I'
     C     DDMTYP        OREQ      'CI'
     C     DDACTN        ANDEQ     'I'
     C*
     C** Check for all possible deam sequence  values
     C                   MOVE      *LOVAL        @DEAMS
     C     @DEAMK        SETLL     MMLVDMLL
     C                   READ      MMLVDMLL                               65
     C*
     C**  Place value date from files into same sequence as display (DDMMYY)
     C                   MOVE      @DMVYR        @DMVY
     C     BJDFIN        IFEQ      'D'
     C                   MOVE      @DMVMT        @DMVM
     C                   MOVE      @DMVDY        @DMVD
     C                   ELSE
     C                   MOVE      @DMVMT        @DMVD
     C                   MOVE      @DMVDY        @DMVM
     C                   END
     C*
     C**  If a live record is found then a deam already exists
     C**  for the value date & deal number
     C     *IN65         IFEQ      '0'
     C     @@DLNO        ANDEQ     HNDA38
     C     DDVDAT        ANDEQ     @DMVDT
      *
     C                   MOVE      'N'           OKDLNO
     C                   MOVE      'N'           OKVDAT
     C                   MOVE      'N'           OKSEQN
     C                   ADD       1             Ix
     C                   MOVEL     'DDVDAT'      FldNameArr(Ix)
     C     DDMTYP        IFEQ      'SI'
     C                   MOVEL     'MMM0577'     MsgIdArr(Ix)
     C                   ELSE
     C                   MOVEL     'MMM2548'     MsgIdArr(Ix)
     C                   END
     C                   END
     C                   END
     C*
     C     CHKKEYEND     ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*          CHKDEAMPPL      - Check deal amendment principle
     C*****************************************************************
     C     CHKDEAMPPL    BEGSR
     C*
     C**  Access Original Deal:
     C**  If no valid record is found, or the record does not have a
     C**  status of 'A' or 'R', it is an error.
     C*
     C     HNDA38        CHAIN     MMDEALLL                           65
     C*
     C     *IN65         IFEQ      '1'
     C     H@DSTS        ORNE      'A'
     C     H@DSTS        ANDNE     'R'
     C                   MOVE      'N'           OKDLNO
     C                   MOVE      'N'           OKVDAT
     C                   MOVE      'N'           OKSEQN
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0165'     MsgIdArr(Ix)
     C                   GOTO      CHKDEAMEND
     C                   END
     C*
     C** If deal amount is -ve make +ve for calculation
     C     H@AMNP        IFLT      0
     C                   Z-SUB     H@AMNP        H@AMNP
     C                   END
     C*
     C** Process all deams on file for this deal
     C*
     C                   MOVE      DDDLNO        KeyDealNo         6 0
     C                   MOVE      *LOVAL        KeyValDatD        2 0
     C                   MOVE      *LOVAL        KeyValDatM        2 0
     C                   MOVE      *LOVAL        KeyValDatY        4 0
     C                   MOVE      *LOVAL        KeySeqNum         3 0
     C                   MOVE      'N'           ErrorFound
     C                   MOVE      *ALL' '       DlnoOnFile        6
     C     @DMKY2        SETLL     MMLVDMLL
     C     *IN65         DOUEQ     '1'
     C     ErrorFound    OREQ      'Y'
     C                   READ      MMLVDMLL                               65
     C                   MOVE      HNDA38        DlnoOnFile
     C*
     C**  If a live record is found then a deam exists
     C**  for the deal number
     C     *IN65         IFEQ      '0'
     C     DlnoOnFile    ANDEQ     DDDLNO
     C*
     C**  Place value date from files into same sequence as display (DDMMYY)
     C                   MOVE      @DMVYR        @DMVY
     C     BJDFIN        IFEQ      'D'
     C                   MOVE      @DMVMT        @DMVM
     C                   MOVE      @DMVDY        @DMVD
     C                   ELSE
     C                   MOVE      @DMVMT        @DMVD
     C                   MOVE      @DMVDY        @DMVM
     C                   END
     C*
     C** If DEAM amount is -ve make +ve for calculation
     C     HNAMNP        IFLT      0
     C                   Z-SUB     HNAMNP        HNAMNP
     C                   END
     C*
 
     C     H@AMNP        IFLT      *ZERO
     C                   MOVE      'N'           OKACTN
     C                   MOVE      'Y'           ErrorFound
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'MMM0295'     MsgidArr(Ix)
     C                   GOTO      CHKDEAMEND
     C                   END
     C*
     C** If current transaction is a delete of a 'PI' & record read
     C** is record to be deleted ignore it
     C*
     C     DDMTYP        IFEQ      'PI'
     C*
     C** Place sequence number into alpha field for comparison
     C                   MOVE      *BLANKS       SeqNoAlpha
     C                   MOVE      HNDS38        SeqNoAlpha        3
     C     DDACTN        IFNE      'D'
     C*
     C     DDVDAT        ORNE      @DMVDT
     C     SeqNoAlpha    ORNE      DDDS38
     C*
     C** If record read is PI add deam amount to deal principle
     C     HNMTYP        IFEQ      'PI'
     C     H@AMNP        ADD       HNAMNP        H@AMNP
     C                   END
     C                   END
     C** Move end to after check if PCPL >= 0.
     C*
     C** If read transaction is a 'PD' subtract deam amount
     C** from deal principle
     C     HNMTYP        IFEQ      'PD'
     C     H@AMNP        SUB       HNAMNP        H@AMNP
     C                   END
     C*
     C** New principle must be = or > 0.
     C     H@AMNP        IFLT      *ZERO
     C                   MOVE      'N'           OKACTN
     C                   MOVE      'Y'           ErrorFound
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'MMM0295'     MsgidArr(Ix)
     C                   GOTO      CHKDEAMEND
     C                   END
     C                   END
     C                   END
     C                   END
     C*
     C*
     C     CHKDEAMEND    ENDSR
     C*
     C/EJECT
      *****************************************************************
      * ACSSEC - ACCESS SECURITY CHECKING
      *****************************************************************
     C     ACSSEC        BEGSR
     C*
     C* If not multi-branching, check authority to only action code
     C*
     C     BJSBRC        IFNE      *BLANK
     C                   CALL      'ZVACTU'
     C                   PARM      DDACTN        ZACTN             1
     C                   PARM                    @@ERR             1 0
     C     @@ERR         IFEQ      1
     C                   MOVE      'N'           OKACTN
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'FXM0292'     MsgIdArr(Ix)
     C                   GOTO      EACSSE
     C                   END
     C                   END
     C*
     C* If multi-branching, check authority to booking branch
     C*
     C     BJSBRC        IFEQ      *BLANK
     C*
     C*  Access file for deal associated  branch code
     C*  for validation.
     C     @@DLNO        CHAIN     MMDEALLL                           65
     C*
     C                   CALL      'ZVACTBU'
     C                   PARM      DDACTN        ZACTN             1
     C                   PARM      H@BRCA        ZBR               3
     C                   PARM                    @@ERR             1 0
     C*
     C     @@ERR         IFEQ      1
     C                   MOVE      'N'           OKACTN
     C                   MOVE      'N'           OKDLNO
     C                   MOVE      'N'           OKVDAT
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'FXM0290'     MsgIdArr(Ix)
     C                   GOTO      EACSSE
     C                   END
     C*
     C     @@ERR         IFEQ      2
     C                   MOVE      'N'           OKACTN
     C                   MOVE      'N'           OKDLNO
     C                   MOVE      'N'           OKVDAT
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'FXM0291'     MsgIdArr(Ix)
     C                   GOTO      EACSSE
     C                   END
     C*
     C* Check authority to originating branch
     C*
     C     BKOBUV        IFEQ      'Y'
     C     DDACTN        ANDNE     'E'
     C     DDACTN        ANDNE     'I'
     C                   CALL      'ZVOBU'
     C                   PARM      H@ORBR        ZOBRX             3
     C                   PARM                    @@ERR             1 0
     C     @@ERR         IFEQ      1
     C                   MOVE      'N'           OKACTN
     C                   MOVE      'N'           OKDLNO
     C                   MOVE      'N'           OKVDAT
     C                   MOVE      'N'           OKSEQN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'FXM0287'     MsgIdArr(Ix)
     C                   GOTO      EACSSE
     C                   END
     C     @@ERR         IFEQ      2
     C                   MOVE      'N'           OKACTN
     C                   MOVE      'N'           OKDLNO
     C                   MOVE      'N'           OKVDAT
     C                   MOVE      'N'           OKSEQN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'FXM0288'     MsgIdArr(Ix)
     C                   GOTO      EACSSE
     C                   END
     C                   END
     C                   END
     C*
     C     EACSSE        ENDSR
      *****************************************************************
      /EJECT
     C*****************************************************************
     C* INIT - INITIALIZATION
     C*****************************************************************
     C     INIT          BEGSR
      *
      * CLEAR OUTPUTS
      *
     C                   CLEAR                   DeamFilFmt
     C                   MOVEL     'Y'           OKACTN
     C                   MOVEL     'Y'           OKDLNO
     C                   MOVEL     'Y'           OKVDAT
     C                   MOVEL     'Y'           OKSEQN
      *
     C                   Z-ADD     0             Ix
     C                   ENDSR
     C********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      * Parameters
      *
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      * Return code
     C                   PARM                    RetCodeIn
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM                    ModeofOp          6
      *
      * Response mode
     C                   PARM                    RespMode          1
      *
      * Action Code
     C                   PARM                    DDACTN            1
      *
      * Front Office Transaction ID
     C                   PARM                    FOTRID           20
      *
      * Front Office Associated Transaction Id
     C                   PARM                    FOASID           20
      *
      * (Midas) Deal Number
     C                   PARM                    DDDLNO            6
      *
      * Value Date
     C                   PARM                    DDVDAT            6
      *
      * Cash/Securites Indicator
     C                   PARM                    DDCASE            1
      *
      * Sequence Number
     C                   PARM                    DDDS38            3
      *
      * Deal Amendment Amount
     C                   PARM                    DDAMNP           15
      *
      * Deal Amendment Type
     C                   PARM                    DDMTYP            2
      *
      * OUTPUTS
      *
      * Type
     C                   PARM                    DDRTYP           14
      *
      * (Current) deal in file format
     C                   PARM                    DeamFilFmt
      *
      * OK - Action code
     C                   PARM                    OKACTN            1
      *
      * OK - Deal Number
     C                   PARM                    OKDLNO            1
      *
      * OK - Value Date
     C                   PARM                    OKVDAT            1
      *
      * OK - Sequence Number
     C                   PARM                    OKSEQN            1
      *
      * OK - Cash/Securites Field
     C                   PARM                    OKCASE            1
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Warning Error field/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Ix
      *
      ** Initialize program name
      *
     C                   MOVEL     'MMDEAMRTV'   DBPGM
      *
      * Key Lists
      *
      * Deal Amendments
     C     @DEAMK        KLIST
     C                   KFLD                    @@DLNO            6 0
     C                   KFLD                    @VDYY             4 0
     C                   KFLD                    @VDMM             2 0
     C                   KFLD                    @VDDD             2 0
     C                   KFLD                    @DEAMS            3 0
      *
      * Deal Amendments
     C     @DEAMY        KLIST
     C                   KFLD                    @@DLNO
     C                   KFLD                    @VDYY
     C                   KFLD                    @VDMM
     C                   KFLD                    @VDDD
      *
      * Deal Amendments 2
     C     @DMKY2        KLIST
     C                   KFLD                    KeyDealNo
     C                   KFLD                    KeyValDatY
     C                   KFLD                    KeyValDatM
     C                   KFLD                    KeyValDatD
     C                   KFLD                    KeySeqNum
     C*
     C** Key List for MMDEAML0
     C     FrntOfKey     KLIST
     C                   KFLD                    UniqDeamID       20
     C                   KFLD                    OrigDealNo       20
     C*
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   MOVEL     '901'         DBASE                          * DBERR 901*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
      *
      ** ACCESS GENERAL LEDGER DETAILS
      *
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDGELRPD'    DBFILE                         ************
     C                   MOVEL     '902'         DBASE                          * DBERR 902*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
      *
      ** ACCESS DEALING DETAILS
      *
     C**********         CALL      'AODEALR0'                                                 CGL029
     C                   CALL      'AODEALR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDDEALPD'    DBFILE                         *************
     C                   MOVEL     '903'         DBASE                          * DBERR 903 *
     C                   EXSR      *PSSR                                        *************
     C                   END
      *
      ** ACCESS DEAL NUMBER RECORD
      *
     C     1             CHAIN     FDDLNMLL                           99
      *
      * DATABASE ERROR
      *
     C     *IN99         IFEQ      '1'
     C     NODLTF        OREQ      '*'
     C                   MOVEL     '1     '      DBKEY
     C                   MOVEL     'FDDLNMLL'    DBFILE                         *************
     C                   MOVEL     '904'         DBASE                          * DBERR 904 *
     C                   EXSR      *PSSR                                        *************
     C                   END
      *
      **  GET ZMUSER to access default branch.
      *
     C******DTAARA       DEFINE                  ZMUSER                                      BUG8550
     C**********         IN        ZMUSER                                                    BUG8550
     C**********         UNLOCK    ZMUSER                                                    BUG8550
      *
     C                   ENDSR
     C********************************************************************
      /EJECT
      *****************************************************************
      * *RESETERRS - RESET ERRORS
      *****************************************************************
     C     RESETERRS     BEGSR
      *
     C                   EVAL      MsgID1 = *Blanks
     C                   EVAL      MsgID2 = *Blanks
     C                   EVAL      WMsgID1 = *Blanks
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
** @DT2  ARRAY OF POSSIBLE MIDAS DEAL TYPES
ITIPTDTICILNCDCLDLC1C2BPBDILID
