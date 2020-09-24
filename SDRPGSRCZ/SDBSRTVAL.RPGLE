     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Base Rate Validation')                        *
      *****************************************************************
      *                                                               *
      *  Midas - Standing data Module                                 *
      *                                                               *
      *  SDBSRTVAL - SD Base Rate Validation                          *
      *                                                               *
      *  Function: This Program Validates Base Rate for Input into    *
      *            the Midas database.                                *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD000091           Date 03May13               *
      *                 AR817540           Date 15Aug12               *
      *                 AR641183           Date 27Nov12               *
      *                 CER059             Date 19Jul10               *
      *                 BUG26041           Date 17Sep09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG22368           Date 12Feb08               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 211983             Date 03Nov06               *
      *                 210546             Date 03Nov06               *
      *                 240065             Date 09Jun06               *
      *                 235685             Date 17Aug05               *
      *                 BUG8550            Date 07Oct05               *
      *                 BUG3360            Date 04Nov04               *
      *                 BUG3124            Date 23Aug04               *
      *                 CDL016             Date 19Feb04               *
      *                 CAP084             Date 25Jun03               *
      *                 213576             Date 11Jun03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSW200             Date 21Aug00               *
      *                 CSD006             Date 25Jan01               *
      *                 CAP038 *CREATE     Date 24Feb00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  MD000091 - Event Codes Substitution                          *
      *  AR817540 - Cannot input negative all-in-rate on Lending.     *
      *             Allow input and computation for negative          *
      *             all-in-rate on Lending.                           *
      *           - Applied for AR1092639                             *
      *  AR641183 - Validate the Front Office ID when feature CSC011  *
      *             or CSD006 is switched on. Applied fix 248163.     *
      *             (Child: AR641184)                                 *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26041 - Issue ICB9999 as a warning message. Applied fix   *
      *             252844.                                           *
      *  BUG22368 - Loan Activity Enquiry showing incorrect events    *
      *  211983 - Update Current Rate Value Date if New Rate Value    *
      *           Date has been changed.                              *
      *  210546 - Upgrade of SCR ICBC01.                              *
      *  240065 - Allow negative base rate for base rate code 77.     *
      *  235685 - Allow zero base rate.                               *
      *  BUG8550 - Reposition capture of ZMUSER data area             *
      *  BUG3360 - CDL016 should actually be CDL020                   *
      *  BUG3124 - Do not allow trailing blank on the base rate code. *
      *  CDL016 - Automatic Rollover of Fixed Term Loan/Deposit       *
      *  CAP084 - Wrapper project                                     *
      *         - Same error message sent twice                       *
      *  213576 - Base rates tolerance not working                    *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CSW200 - SWIFT 2000 Changes                                  *
      *  CSD006 - Market Data Feeds                                   *
      *  CAP038 - Conversion of SD inputs into modular structure      *
      *           to use as APIs.                                     *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************

      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,SDBSRTV001

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

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.

     D/COPY ZACPYSRC,PROCPARMS

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
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
      ** Alpha Num Base Rate Code                                                             CSD103
     D AlphaBSRC       C                   Const('ALPHABASRATCOD')                            CSD103

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D ArrayNbrt       S              1A   DIM(12)                                            240065
      * Incoming Base Rate in screen format                                                   240065
                                                                                              240065
     D BaseRateIn    E DS                  EXTNAME(SDBSRSPD)
      * Incoming Base Rate in screen format

     D ValdBasRat    E DS                  EXTNAME(SDVBSRTPD)
      * Valid Base Rate Layout


     D SDBASR        E DS                  EXTNAME(SDBSRTPD)
      ** EXTERNAL DS FOR BASE RATE DETAILS

     D PBTOBS        E DS                  EXTNAME(PBTOBSPD)
      ** EXTERNAL DS FOR BASE RATE NAME

     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** External DS for SAR details

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS

     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS

     D DSFDY         E DS                  EXTNAME(DSFDY)
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE

     D DSSDY         E DS                  EXTNAME(DSSDY)
      * SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE

      ** 24X7 status data area                                                                CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
                                                                                              CSC011
      ** SD data area                                                                         CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
                                                                                              CSC011
     D ZMUSER          DS            17
     D  BRC                   11     13
     D  DEPT                  14     16

     D ExtData       E DS                  EXTNAME(SDBSEXPD)
      * SD Extra Data - File (D/B) format

     D SDMDFC        E DS                  EXTNAME(SDMDFCPD)                                  CSD006
      ** External DS for Market Data Feeds ICD                                                CSD006
                                                                                              CSD006
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)                                  240065
      ** External DS for Dealing Details                                                      240065
                                                                                              240065
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D   MsgDtaTmp                   99                                                     MD000091
      ** Data Structure for Event Codes Substitution                                        MD000091
                                                                                              CSD103
      ** BSRT Backward-Looking Rate Fields                                                    CSD103
     D BasRBckfld      DS            27                                                       CSD103
     D  DDBLRT                 1      1                                                       CSD103
     D  DDLBDY                 2      3                                                       CSD103
     D  DDLODY                 4      5                                                       CSD103
     D  DDPDLY                 6      7                                                       CSD103
     D  DDBADJ                 8     21                                                       CSD103
     D  DDAVOP                22     22                                                       CSD103
     D  DDBRAC                23     24                                                       CSD103
     D  DDWGHT                25     25                                                       CSD103

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+


      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
     D Ix              S              3P 0

      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0

      ** Flags to indicate whether Base Rate fields are valid
     D OKFlagsDS     E DS                  EXTNAME(SDEBSRTPD)

      ** A code to indicate the calling function to the lower level modules
     D BSRT            S              4A   INZ('BSRT')

      ** Response Mode, received as a parameter from the common header
     D RespMode        S              1A

      * Switchable features
     D CSD006F         S              1A
     D CSW005          S              1A
     D CSW011          S              1A
     D CSW200          S              1A
     D****** CDL016          S              1A                                         CDL016 BG3360
     D CDL020          S              1A                                                      BG3360

      ** Time stamp field in file format, defaulted if necessary                              CSD006
     D JDFTS           S             14  0                                                    CSD006
                                                                                              CSC011
     D CSC011          S              1A                                                      CSC011
     D PRtCd           S              7A                                                      CSC011
     D POptn           S              7A                                                      CSC011
     D PSard           S              6A                                                      CSC011
     D WRunDay         S                   LIKE(BJRDNB)                                       CSC011
                                                                                              CSC011
     D #1TESTN         S              1A                                                     BUG3124
                                                                                             BUG3124
      ** Alpha field for numeric validation                                                   240065
     D @@ALPH          S             16A                                                      240065
      ** Millions/Thousands id (Y=function on)                                                240065
     D @@MTID          S              1A                                                      240065
      ** Amount calculation field                                                             240065
     D @@AMT           S             15  0                                                    240065
      ** Error code                                                                           240065
     D @@ERCD          S              1  0                                                    240065
      ** Number of decimal places                                                             240065
     D @@IDP           S              3  0                                                    240065
      ** Number of integers                                                                   240065
     D @@IINT          S              3  0                                                    240065
                                                                                              240065
     D PZASignOk       S              1A                                                      240065
     D PZFld17         S             17A                                                      240065
     D PZDig           S              2P 0                                                    240065
     D PZDec           S              1P 0                                                    240065
     D PZSDCSP         S              1A                                                      240065
     D PZOut15         S             15A                                                      240065
     D PZFSign         S              1A                                                      240065
                                                                                              240065
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SDBSRTV002

      *****************************************************************
      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *                                                                                      BUG8550
      **  GET ZMUSER to access default branch.                                               BUG8550
      *                                                                                      BUG8550
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG8550
     C                   IN        ZMUSER                                                    BUG8550
     C                   UNLOCK    ZMUSER                                                    BUG8550
      *                                                                                      BUG8550

      /COPY WNCPYSRC,SDBSRTV003

      * Call Validation Modules in Sequence

                                                                                             BUG3124
      ** Validate Base Rate Code                                                             BUG3124
                                                                                             BUG3124
     C                   EXSR      VBRTC                                                     BUG3124
                                                                                             BUG3124
      *
      * Validate Front Office Id (Base Rate MDF id)
      *
      /COPY WNCPYSRC,SDBSRTV016

     C                   IF        CSC011 = 'Y' OR                                          AR641183
     C                             CSD006F = 'Y'                                            AR641183
     C                   EXSR      VFRNT
     C                   ENDIF                                                              AR641183

      /COPY WNCPYSRC,SDBSRTV017


      ** Validate Base Rate Name
      *
      /COPY WNCPYSRC,SDBSRTV004

     C                   EXSR      VBASRNAM
      *
      /COPY WNCPYSRC,SDBSRTV005

      *
      ** Validate New Base Rate
      *
      /COPY WNCPYSRC,SDBSRTV006

     C                   EXSR      VNEWBSR
      *
      /COPY WNCPYSRC,SDBSRTV007

      ** Validate Value Date for new base rate
      *
      /COPY WNCPYSRC,SDBSRTV008

     C                   EXSR      VVDAT
      *
      /COPY WNCPYSRC,SDBSRTV009

      ** Validate ISDA Definition and Designated Maturity
      *
      /COPY WNCPYSRC,SDBSRTV010

     C                   IF        CSW005  =  'Y'  OR
     C                             CSW011  =  'Y'  AND
     C                             CSW200  =  'Y'
     C                   EXSR      VISDADM
     C                   ENDIF
      *
      /COPY WNCPYSRC,SDBSRTV011
      *                                                                                       CSD006
      * Validate Data Source Override                                                         CSD006
      *                                                                                       CSD006
     C                   IF        CSD006F =  'Y'                                             CSD006
      /COPY WNCPYSRC,SDBSRTV018                                                               CSD006
                                                                                              CSD006
     C                   EXSR      VBSOV                                                      CSD006
                                                                                              CSD006
      /COPY WNCPYSRC,SDBSRTV019                                                               CSD006
                                                                                              CSD006
                                                                                              CSD006
      *                                                                                       CSD006
      * Validate Data Request Identifier                                                      CSD006
      *                                                                                       CSD006
      /COPY WNCPYSRC,SDBSRTV020                                                               CSD006
                                                                                              CSD006
     C                   EXSR      VDFRQ                                                      CSD006
                                                                                              CSD006
      /COPY WNCPYSRC,SDBSRTV021                                                               CSD006
                                                                                              CSD006
                                                                                              CSD006
      *                                                                                       CSD006
      * Validate Data Feed Timestamp                                                          CSD006
      *                                                                                       CSD006
      /COPY WNCPYSRC,SDBSRTV022                                                               CSD006
                                                                                              CSD006
     C                   EXSR      VDFTS                                                      CSD006
                                                                                              CSD006
      /COPY WNCPYSRC,SDBSRTV023                                                               CSD006
                                                                                              CSD006
     C                   ENDIF                                                                CSD006
      *  *-------------------------------------------------------*
      *  * If no errors set up outstanding fields for valid file *
      *  *-------------------------------------------------------*

      /COPY WNCPYSRC,SDBSRTV012

     C                   IF        Idx = 0
     C                   EXSR      SetupValid
     C                   ENDIF
      *
      /COPY WNCPYSRC,SDBSRTV013

      * RETURN
      *
     C                   RETURN
      *****************************************************************
     C/EJECT

      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SDBSRTV014
      *****************************************************************
      ** VFRNT - Validate Front Office Id
      *****************************************************************
     C     VFRNT         BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
      ** Validate Front Office Id
      *
     C                   CALLB     'SDVBRFRNT'
     C                   PARM                    RetCodeIn
     C                   PARM                    DDFRNT
     C                   PARM                    DDCYCD
     C                   PARM                    DDBSRC
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    BVFOTRANID
     C                   PARM                    DDFRNTOK
     C                   PARM                    CSC011                                       CSC011
      *
      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VBASRNAM - Validate base rate name
      *****************************************************************
     C     VBASRNAM      BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
      * If 'Private Banking' Module is not installed the Base Rate
      * name must be entered.
     C     BGN4ST        IFNE      'Y'
     C     DDBSRN        IFEQ      *BLANKS
     C                   MOVE      'N'           DDBsrnOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDBSRN'      FldNamXAr(Ix)
     C                   MOVEL     'USR4442'     MsgIdXAr(Ix)
     C                   ELSE
     C                   MOVEL     DDBSRN        BVBSRN
     C                   ENDIF
      *
     C                   ELSE
      * If 'Private Banking' Module is installed the Base Rate name
      * must equal to the Base Rate from PBTOBSR0, or equal to
      * blank for input.
      * Check if Base Rate Code exist
     C                   MOVE      DDBSRC        @KEYBR
     C                   CALL      'AOTOBSR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY  '      @OPTN             7
     C                   PARM                    @KEYBR            2
     C     PBTOBS        PARM      PBTOBS        DSSDY
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           DDBsrnOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDBSRN'      FldNamXAr(Ix)
     C                   MOVEL     'USR4576'     MsgIdXAr(Ix)
     C                   ELSE
     C     DDACTN        IFEQ      'A'
     C     DDBSRN        IFNE      AOBANA
     C     DDBSRN        ANDNE     *BLANKS
     C                   MOVE      'N'           DDBsrnOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDBSRN'      FldNamXAr(Ix)
     C                   MOVEL     'USR4446'     MsgIdXAr(Ix)
     C                   ELSE
     C                   MOVEL     AOBANA        BVBSRN
     C                   MOVEL     AOBACD        DDBSRC
     C                   MOVEL     AOBANA        DDBSRN
     C                   ENDIF
     C                   ENDIF
     C     DDACTN        IFEQ      'I'
     C     DDBSRN        IFNE      *BLANKS
     C     DDBSRN        ANDNE     AOBANA
     C                   MOVE      'N'           DDBsrnOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDBSRN'      FldNamXAr(Ix)
     C                   MOVEL     'USR4446'     MsgIdXAr(Ix)
     C                   ELSE
     C                   MOVEL     AOBANA        BVBSRN
     C                   MOVEL     AOBACD        DDBSRC
     C                   MOVEL     AOBANA        DDBSRN
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF
     C                   ENDIF
      *
      * Display Base Rate Shortname
      *
     C     DDCYCD        CAT       DDBSRC        DDBSRS

      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VNEWBSR - Validate new base rate
      *****************************************************************
     C     VNEWBSR       BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
      ** Validate New Base Rate
      ** Ensure rate is correctly formatted                                                   240065
      *                                                                                       240065
     C                   Z-ADD     7             @@IDP                                        240065
     C                   Z-ADD     4             @@IINT                                       240065
     C                   MOVE      *BLANKS       @@ALPH                                       240065
     C                   MOVE      DDNBRT        @@ALPH                                       240065
     C                   MOVE      'N'           @@MTID            1                          240065
      *                                                                                       240065
     C                   EXSR      VALAMT                                                     240065
      *                                                                                       240065
     C                   MOVE      *BLANKS       PZFld17                                      240065
     C     RetCodeIn     IFEQ      *BLANKS                                                    240065
     C                   MOVEL     DDNBRT        PZFld17                                      240065
     C                   END                                                                  240065
     C                   Z-ADD     4             PZDig                                        240065
     C                   Z-ADD     7             PZDec                                        240065
      *                                                                                       240065
     C                   EXSR      FMTAMT                                                     240065
      *                                                                                       240065
     C*****DDNBRT        IFNE      *BLANKS                                                    240065
     C**********         MOVE      *BLANKS       WBasRat1                                     240065
     C**********         MOVEL     DDNBRT        WBasRat1                                     240065
      **Call*ZALIGN*&*ZEDIT                                                                   240065
      **ZALIGN*Screen*Field*-*Standard Functions                                              240065
     C**********         CALL      'ZALIGN'                             90                    240065
     C**********         PARM                    ReturnCode                                   240065
     C**********         PARM                    WBasRat1         16                          240065
     C**********         PARM      7             WNb_Dec           1 0                        240065
     C**********         PARM      4             WNb_Dig           2 0                        240065
     C**********         PARM      *BLANK        WBasRat2         16                          240065
      **********                                                                              240065
     C******IN90         IFEQ      '1'                                                        240065
     C*****ReturnCode    ORNE      *BLANKS                                                    240065
     C**********         MOVE      'N'           DDNbrtOK                                     240065
     C**********         ADD       1             Ix                                           240065
     C**********         MOVEL     'DDNBRT'      FldNamXAr(Ix)                                240065
     C**********         MOVEL     'USR0904'     MsgIdXAr(Ix)                                 240065
     C**********         ELSE                                                                 240065
      **********                                                                              240065
      **ZEDIT*Screen*Field*-*Standard*Functions                                               240065
     C**********         CALL      'ZEDIT'                              90                    240065
     C**********         PARM                    WBasRat1         16                          240065
     C**********         PARM      7             WQ0024            1 0                        240065
      **********                                                                              240065
     C******IN90         IFEQ      '1'                                                        240065
     C**********         MOVE      'N'           DDNbrtOK                                     240065
     C**********         ADD       1             Ix                                           240065
     C**********         MOVEL     'DDNBRT'      FldNamXAr(Ix)                                240065
     C**********         MOVEL     'USR0904'     MsgIdXAr(Ix)                                 240065
     C**********         ELSE                                                                 240065
     C**********         MOVE      DDNBRT        WNumBas          11 7                        240065
     C**********         ENDIF                                                                240065
      **********                                                                              240065
     C**********         ENDIF                                                                240065
      **********                                                                              240065
     C**********         ELSE                                                                 240065
      **CASE:**OTHERWISE                                                                      240065
     C**********         Z-ADD     *ZERO         WNumBas          11 7                        240065
     C**********         ENDIF                                                                240065
     C**********                                                                              240065
      **CASE:*New*Base*rate*is*zero************************************                       235685
     C**********                                                                              235685
     C*****WNumBas       IFEQ      *ZERO                                                      235685
     C*****DDNbrtOK      IFEQ      'Y'                                                        235685
     C**********                                                                              235685
     C**********         MOVE      'N'           DDNbrtOK                                     235685
     C**********         ADD       1             Ix                                           235685
     C**********         MOVEL     'DDNBRT'      FldNamXAr(Ix)                                235685
     C**********         MOVEL     'USR3621'     MsgIdXAr(Ix)                                 235685
     C**********         ENDIF                                                                235685
     C**********         ELSE                                                                 235685
     C                   Z-ADD     BVNBRT        BVCBSR                                       213576
     C                   MOVE      PZOut15       WNumBas          11 7                        240065
     C                   IF        DDNGVI = 'Y'                                               240065
     C                   Z-SUB     WNumBas       BVNBRT                                       240065
     C                   ELSE                                                                 240065
     C                   Z-ADD     WNumBas       BVNBRT
     C                   ENDIF                                                                240065
     C**********         ENDIF                                                                235685
      *                                                                                       CSD006
      * Set a flag if the value is not within the MDF ICD Base Rate tolerance                 CSD006
      * of the previous base rate. If the tolerance is set at 999.99 then no                  CSD006
      * tolerance checking is to be performed.                                                CSD006
                                                                                              CSD006
      * If market data feed is on (CSD006)                                                    CSD006
      * If action code is amend, new base rate and current base rate are different            CSD006
     C                   IF        CSD006F= 'Y' AND                                           CSD006
     C                             DDACTN = 'A' AND                                           CSD006
     C                             BVNBRT <> BVCBSR AND                                       CSD006
     C                             BVCBSR <> 0                                                CSD006
     C                                                                                        CSD006
                                                                                              CSD006
      * do not check MDF ICD securities rate tolerance of current rate if the tol -           CSD006
      * erance is set at 999.99                                                               CSD006
                                                                                              CSD006
     C*******************IF        MDSPTL <>  999.99  OR                               CSD006 213576
     C                   IF        MDBRTL <>  999.99  OR                                      213576
     C                             DDNBRT <> *BLANKS                                          CSD006
      * clear work fields                                                                     CSD006
     C                   MOVE      *ZEROS        WK13             13 8                        CSD006
     C                   MOVE      *ZEROS        DIFFRT           15 8                        CSD006
                                                                                              CSD006
      * for amended rate : new rate  - previous rate                                          CSD006
     C                   EVAL      WK13  = BVNBRT - BVCBSR                                    CSD006
                                                                                              CSD006
      * if WK13 is negative, Z-SUB the field                                                  CSD006
     C                   IF        WK13 < 0                                                   CSD006
     C                   Z-SUB     WK13          WK13                                         CSD006
     C                   ENDIF                                                                CSD006
                                                                                              CSD006
      * divide WK13 by previous rate                                                          CSD006
     C                   EVAL      DIFFRT = (WK13/BVCBSR) * 100                               CSD006
                                                                                              CSD006
      * DIFFRT is compared to MDF ICD Sec rate  tolerance                                     CSD006
      * If DIFFRT is greater then flag is to set to 'Y', else 'N'                             CSD006
                                                                                              CSD006
     C*******************IF        DIFFRT > MDSPTL                                     CSD006 213576
     C                   IF        DIFFRT > MDBRTL                                            213576
     C                   EVAL      BVTLEX = 'Y'                                               CSD006
     C                   ELSE                                                                 CSD006
     C                   EVAL      BVTLEX = 'N'                                               CSD006
     C                   ENDIF                                                                CSD006
                                                                                              CSD006
     C                   ENDIF                                                                CSD006
     C                   EVAL      BVCBSR= BVNBRT                                             CSD006
     C                   ELSE                                                                 CSD006
     C                   EVAL      BVCBSR= BVNBRT                                             CSD006
     C                   ENDIF                                                                CSD006

      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VVDAT    - Validate Value Date for the New Base Rate
      *****************************************************************
     C     VVDAT         BEGSR

      * Reset variables updated by each subroutine

     C                   EXSR      RESETERRS

      * Validate Value Date for the New Base Rate

     C     DDVDNR        IFEQ      *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDVDNR'
     C                   EVAL      MsgIDArr(Idx) = 'USR0887'
     C                   EVAL      DDVdnrOK  = 'N'
     C                   ELSE
      * Check valid date
     C                   MOVE      DDVDNR        DATEN             6 0
     C                   MOVE      DATEN         DATEA             6
      **
      ** Valid date format
      **      Test if date is numeric
      **
     C                   TESTN                   DATEA                9798
     C                   CALLB     'ZDATE1'
     C                   PARM                    DATEA             6
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag         1

      **   - invalid format or not numeric
     C     ErrorFlag     IFEQ      'Y'
     C     *IN97         OREQ      '0'
     C     *IN98         ANDEQ     '0'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDVDNR'
     C                   EVAL      MsgIDArr(Idx) = 'USR4443'
     C                   EVAL      DDVdnrOK  = 'N'
     C                   ELSE
      **
     C                   Z-ADD     ZDAYNO        WVDNR             5 0
      * Calculate the back value day number
     C*****BJRDNB        SUB       BJBVPD        WBVRD             5 0                        CSC011
     C     WRunDay       SUB       BJBVPD        WBVRD             5 0                        CSC011
     C                   ENDIF
      *
     C                   SELECT

      *  An error occured during the date conversion
      **********                                                                              CAP084
     C**********         WHEN      ErrorFlag  = 'Y'                                           CAP084
     C**********         MOVE      'N'           DDVdnrOK                                     CAP084
     C**********         ADD       1             Ix                                           CAP084
     C**********         MOVEL     'DDVDNR'      FldNamXAr(Ix)                                CAP084
     C**********         MOVEL     'USR4443'     MsgIdXAr(Ix)                                 CAP084
      *                                                                                       210546
      ** Value Date cannot be before today's date                                             210546
      *                                                                                       210546
     C                   WHEN      WVDNR  <  BJRDNB  and                                      210546
     C                             WVDNR  >= WBVRD                                            210546
     C**********         IF        WFLAG1 <> 'Y'                                     210546 BUG26041
     C**********         MOVE      'N'           DDVdnrOK                            210546 BUG26041
     C**********         ADD       1             Ix                                  210546 BUG26041
     C**********         MOVEL     'DDVDNR'      FldNamXAr(Ix)                       210546 BUG26041
     C**********         MOVEL     'ICB9999'     MsgIdXAr(Ix)                        210546 BUG26041
     C**********         MOVEL     'Y'           WFLAG1            1                 210546 BUG26041
     C**********         ELSE                                                        210546 BUG26041
     C**********         MOVEL     'N'           WFLAG1                              210546 BUG26041
     C                   MOVE      'W'           DDVdnrOK                                   BUG26041
     C                   ADD       1             WIdx                                       BUG26041
     C                   EVAL      WFldNmXAr(WIdx) = 'DDVDNR'                               BUG26041
     C                   EVAL      WMsgIDXar(WIdx) = 'ICB9999'                              BUG26041
     C                   Z-ADD     WVDNR         BVVDNR                                       210546
     C                   Z-ADD     BVVDNR        BVVDRC                                       211983
     C**********         ENDIF                                                       210546 BUG26041

      * Value Date must be after the back value Date
     C                   WHEN      WVDNR  <  WBVRD
     C                   Z-ADD     WBVRD         ZDAYNO
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7

     C                   MOVE      'N'           DDVdnrOK
     C                   ADD       1             Ix
     C**********         MOVEL     ZDATE         MsgDtaXAr(Ix)                              MD000091
     C                   MOVEL     ZDATE         MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaXAr(Ix) = LenStr + %Trim(MsgDtaTmp)                MD000091
     C                   MOVEL     'DDVDNR'      FldNamXAr(Ix)
     C                   MOVEL     'USR4444'     MsgIdXAr(Ix)
     C**********         MOVEL     'N'           WFLAG1                              210546 BUG26041

      * Value Date cannot be after today's date
     C**********         WHEN      WVDNR  >  BJRDNB                                           CSC011
     C**********         WHEN      WVDNR  >  WRunDay                                   CSC011 CDL016
     C                   WHEN      WVDNR  >  WRunDay AND                                      CDL016
     C**********                   CDL016 <> 'Y'                                       CDL016 BG3360
     C                             CDL020 <> 'Y'                                              BG3360
     C                   MOVE      'N'           DDVdnrOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDVDNR'      FldNamXAr(Ix)
     C                   MOVEL     'USR4445'     MsgIdXAr(Ix)
     C**********         MOVEL     'N'           WFLAG1                              210546 BUG26041


      * Value Date is correct
     C                   OTHER
     C                   Z-ADD     WVDNR         BVVDNR
     C                   Z-ADD     BVVDNR        BVVDRC                                       211983
     C                   ENDSL

     C                   ENDIF
      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VISDADM  - Validate ISDA Definition and Designated Maturity
      *****************************************************************
     C     VISDADM       BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
      *
      *  Validate Designated Maturity
      *
     C                   CALLB     'SDVISDMAT'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** ISDA Definition
      ** Designated Maturity
      ** Other Maturity Description (1 & 2)
     C                   PARM                    DDSCDD
     C                   PARM                    DDDGMA
     C                   PARM                    DDOMD1
     C                   PARM                    DDOMD2
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** ISDA Definition     - OK
      ** Designated Maturity - OK
      ** Other Maturity Desc.- OK
     C                   PARM                    DDScddOK          1
     C                   PARM                    DDDgmaOK          1
     C                   PARM                    DDOmd1OK          1
     C                   PARM                    DDOmd2OK          1
      *
      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************                       CSD006
      **   VBSOV - Base Rate Data Source Override                                             CSD006
      *****************************************************************                       CSD006
     C     VBSOV         BEGSR                                                                CSD006
                                                                                              CSD006
      * Reset variables updated by validation                                                 CSD006
                                                                                              CSD006
     C                   EXSR      RESETERRS                                                  CSD006
      *                                                                                       CSD006
      ** Validate Base Rate Data Source Override                                              CSD006
      *                                                                                       CSD006
     C                   CALLB     'SDVBSOV01'                                                CSD006
      ** Return Code                                                                          CSD006
     C                   PARM                    RetCodeOut                                   CSD006
      ** Base Rate Data Source Override (Screen fmt)                                          CSD006
     C                   PARM                    DDBRDS           32                          CSD006
      *                                                                                       CSD006
      * OUTPUTS                                                                               CSD006
      *                                                                                       CSD006
      * Error fields/message IDs/message data (arrays) from/to caller                         CSD006
     C                   PARM                    FldNamXAr                                    CSD006
     C                   PARM                    MsgIDXAr                                     CSD006
     C                   PARM                    MsgDtaXAr                                    CSD006
      ** Base Rate Data Source Override (file format)                                         CSD006
     C                   PARM                    BVBRDS           32                          CSD006
      ** Base Rate Data Source Override OK Flag                                               CSD006
     C                   PARM                    DDBRDSOK          1                          CSD006
                                                                                              CSD006
      * Update error info with that returned from the validation module                       CSD006
                                                                                              CSD006
     C                   EXSR      UPDATERRS                                                  CSD006
      *                                                                                       CSD006
     C                   ENDSR                                                                CSD006
      *****************************************************************                       CSD006
     C/EJECT                                                                                  CSD006
      *****************************************************************                       CSD006
      **   VDFRQ  Data Feed Request ID                                                        CSD006
      *****************************************************************                       CSD006
     C     VDFRQ         BEGSR                                                                CSD006
                                                                                              CSD006
      * Reset variables updated by validation                                                 CSD006
                                                                                              CSD006
     C                   EXSR      RESETERRS                                                  CSD006
      *                                                                                       CSD006
      ** Validate Data Feed Request ID                                                        CSD006
      *                                                                                       CSD006
     C                   CALLB     'SEVDFRQ01'                                                CSD006
      ** Return Code                                                                          CSD006
     C                   PARM                    RetCodeIn                                    CSD006
      ** Data Feed Request ID                                                                 CSD006
     C     BVDTFR        PARM                    DDDTFR           32                          CSD006
      *                                                                                       CSD006
      * OUTPUTS                                                                               CSD006
      *                                                                                       CSD006
      * Warning fields/message IDs/message data (arrays) from/to caller                       CSD006
     C                   PARM                    WFldNmXAr                                    CSD006
     C                   PARM                    WMsgIdXar                                    CSD006
     C                   PARM                    WMsgDtXAR                                    CSD006
      *  Data Feed Req Id OK flag                                                             CSD006
     C                   PARM                    DDDTFROK          1                          CSD006
      ** Data Feed Request ID                                                                 CSD006
     C                   PARM                    WDDTFR           32                          CSD006
                                                                                              CSD006
      * Update error info with that returned from the validation module                       CSD006
     C                   EXSR      UPDATERRS                                                  CSD006
      *                                                                                       CSD006
     C                   ENDSR                                                                CSD006
      *****************************************************************                       CSD006
     C/EJECT                                                                                  CSD006
      *****************************************************************                       CSD006
      **   VDFTS  Data Feed Timestamp                                                         CSD006
      *****************************************************************                       CSD006
     C     VDFTS         BEGSR                                                                CSD006
                                                                                              CSD006
      * Reset variables updated by validation                                                 CSD006
                                                                                              CSD006
     C                   EXSR      RESETERRS                                                  CSD006
      *                                                                                       CSD006
      ** Validate Time Stamp                                                                  CSD006
      *                                                                                       CSD006
     C                   CALLB     'SEVPRTM01'                                                CSD006
      ** Return Code                                                                          CSD006
     C                   PARM                    RetCodeIn                                    CSD006
      ** Data Feed Timestamp                                                                  CSD006
     C                   PARM                    DDDFTS                                       CSD006
      ** Data Feed Request ID                                                                 CSD006
     C                   PARM                    DDDTFR                                       CSD006
      * OUTPUTS                                                                               CSD006
      *                                                                                       CSD006
      * Error fields/message IDs/message data (arrays) from/to caller                         CSD006
     C                   PARM                    FldNamXAr                                    CSD006
     C                   PARM                    MsgIdXar                                     CSD006
     C                   PARM                    MsgDtaXAr                                    CSD006
                                                                                              CSD006
      *  Data Feed Req Id OK flag                                                             CSD006
     C                   PARM                    DDDTFROK          1                          CSD006
      *  Data Feed Timestamp OK flag                                                          CSD006
     C                   PARM                    DDDFTSOK          1                          CSD006
      ** Data Feed Timestamp                                                                  CSD006
     C     BVDFTS        PARM      *ZERO         JDFTS                                        CSD006
      *                                                                                       CSD006
      * Update error info with that returned from the validation module                       CSD006
                                                                                              CSD006
     C                   EXSR      UPDATERRS                                                  CSD006
      *                                                                                       CSD006
     C                   ENDSR                                                                CSD006
      *****************************************************************
      /EJECT                                                                                 BUG3124
      *****************************************************************                      BUG3124
      ** VBRTC - Validate Base Rate Code                                                     BUG3124
      *****************************************************************                      BUG3124
     C     VBRTC         BEGSR                                                               BUG3124
                                                                                             BUG3124
      * Reset variables updated by each module                                               BUG3124
                                                                                             BUG3124
     C                   EXSR      RESETERRS                                                 BUG3124
                                                                                             BUG3124
      ** Validate Base Rate Code                                                             BUG3124
                                                                                             BUG3124
                                                                                             BUG3124
     ** Used MOVE op code to validate Base Rate Code                                         BUG3124
                                                                                             BUG3124
     C     AlphaCode     IFNE      'Y'                                                        CSD103
     C                   MOVE      DDBSRC        #1TESTN                                     BUG3124
     C     DDBSRC        IFLE      '00'                                                      BUG3124
     C     DDBSRC        ORGT      '99'                                                      BUG3124
     C     #1TESTN       ORLT      '0'                                                       BUG3124
     C     #1TESTN       ORGT      '9'                                                       BUG3124
     C                   MOVE      'N'           DDBSRCOK                                    BUG3124
     C                   ADD       1             Idx                                         BUG3124
     C                   EVAL      FldNamXAr(Idx) = 'DDBSRN'                                 BUG3124
     C                   EVAL      MsgIdXAr(Idx) = 'USR4572'                                 BUG3124
     C                   END                                                                 BUG3124
     C                   ENDIF                                                                CSD103
                                                                                             BUG3124
                                                                                             BUG3124
      * Update error info with that returned from the validation module                      BUG3124
                                                                                             BUG3124
     C                   EXSR      UPDATERRS                                                 BUG3124
      *                                                                                      BUG3124
     C                   ENDSR                                                               BUG3124
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPVALID - Set up additional fields that are needed on the  *
      *   Valid file record.                                         *
      *                                                               *
      *****************************************************************

     C     SETUPVALID    BEGSR

      * Other BVxxxx fields are set up during the individual data
      *  validation, such as the ones where the input & database formats
      *  are different, e.g. dates, amounts.
      * This SR sets up the fields with the same (or compatible) attributes

      * Base rate Code
     C                   MOVE      DDCYCD        BVCYCD
     C                   MOVE      DDBSRC        BVBSRC
     C     DDCYCD        CAT       DDBSRC        BVBSRS
      *
      *
     C                   MOVE      DDSCDD        BVSCDD
     C                   MOVE      DDDGMA        BVDGMA
     C                   MOVE      DDOMD1        BVOMD1
     C                   MOVE      DDOMD2        BVOMD2
      *                                                                                       CSD103
     C                   MOVEL     DDBLRT        BVBLRT                                       CSD103
     C                   MOVEL     DDLBDY        BVLBDY                                       CSD103
     C                   MOVEL     DDLODY        BVLODY                                       CSD103
     C                   MOVEL     DDPDLY        BVPDLY                                       CSD103
     C                   MOVEL     DDBADJ        BVBADJ                                       CSD103
     C                   MOVEL     DDAVOP        BVAVOP                                       CSD103
     C                   MOVEL     DDBRAC        BVBRAC                                       CSD103
     C                   MOVEL     DDWGHT        BVWGHT                                       CSD103
      *
      *
     C     DDCYCD        CAT       DDBSRC        DDBSRS
      *
      * Setup indicators
     C                   MOVE      'Y'           BVDLLC
     C                   MOVE      'Y'           BVCSLL
     C                   MOVE      'Y'           BVACLT
     C                   MOVE      'Y'           BVACRC
     C                   MOVE      'Y'           BVDLRC
     C                   MOVE      'Y'           BVCSLR
      * Last Change Date
     C                   Z-ADD     BJRDNB        BVLCD

      * Last Change type
     C                   MOVEL     DDACTN        BVTYLC

     C                   SELECT
      * AMEND -  Set the specific fields for amend
     C                   WHEN         DDACTN = 'A'
      * Indicators
     C                   MOVE      'Y'           BVSYLL
     C                   MOVE      'Y'           BVSYLR

      * INPUT -  Set the specific fields for input
     C                   WHEN         DDACTN = 'I'
      * Current Base Rate Code and value date
     C                   Z-ADD     *ZERO         BVCBSR
     C**********         Z-ADD     *ZERO         BVVDRC                                     BUG22368
      * Indicators
     C                   MOVE      *BLANK        BVSYLL
     C                   MOVE      *BLANK        BVSYLR
      ** Midas Export Value BSCD
     C                   MOVE      *BLANKS       BVBSCD
      *
     C                   ENDSL

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
      * Response mode (1A), from source system common header
     C                   PARM                    RespMode
      * Transaction information (DS) from source system
     C                   PARM                    BaseRateIn
     C                   PARM                    ExtData
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKFlagsDS
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      * Valid Base Rate (DS) from/to caller
     C                   PARM                    ValdBasRat
     C                   PARM                    CSD006F                                      CSD006
     C                   PARM                    CSW005
     C                   PARM                    CSW011
     C                   PARM                    CSW200
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Backward-Looking Rate Fields                                                          CSD103
     C                   PARM                    BasRBckfld                                   CSD103
      *
      **  GET ZMUSER to access default branch.
      *
     C******DTAARA       DEFINE                  ZMUSER                                      BUG8550
     C**********         IN        ZMUSER                                                    BUG8550
     C**********         UNLOCK    ZMUSER                                                    BUG8550
      *
      **  Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBSRTVAL'   DBPGM
     C                   OUT       LDA
      *
      ** Access Bank details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      *  Set up the name of the MSGF from which the message handler will
      *   get the messages
     C                   EVAL      #MsgFile = 'SDUSRMSG'
      *
      ** ACCESS MIDAS MODULE DETAILS
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDMMODPD'    DBFILE                         *************
     C                   MOVEL     '001'         DBASE                          * DBERR 900 *
     C                   EXSR      *PSSR                                        *************
     C                   END
      *
      *
      ** Access Market Data Feed if switchable CSD006 is installed.                           CSD006
                                                                                              CSD006
     C                   IF        CSD006F= 'Y'                                               CSD006
     C                   CALLB     'AOMDFCR0'                                                 CSD006
     C                   PARM      *BLANKS       @RTCD                                        CSD006
     C                   PARM      '*FIRST '     @OPTN                                        CSD006
     C     SDMDFC        PARM      SDMDFC        DSSDY                                        CSD006
                                                                                              CSD006
     C                   IF        @RTCD <> *Blanks                                           CSD006
     C                   MOVEL     'SDMDFCPD'    DBFILE                                       CSD006
     C                   MOVEL     '080'         DBASE                                        CSD006
     C                   MOVEL     @OPTN         DBKEY                                        CSD006
     C                   EXSR      *PSSR                                                      CSD006
     C                   ENDIF                                                                CSD006
     C                   ENDIF                                                                CSD006
                                                                                              CSC011
     C                   EVAL      WRunDay = BJRDNB                                           CSC011
                                                                                              CSC011
      ** Check if switchable feature CSC011 is switched on.                                   CSC011
                                                                                              CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
                                                                                              CSC011
     C                   CALL      'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRtCd                                        CSC011
     C                   PARM      '*VERIFY'     POptn                                        CSC011
     C                   PARM      'CSC011'      PSard                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
      ** Database error                                                                       CSC011
                                                                                              CSC011
     C                   IF        (PRtCd <> *BLANKS) and                                     CSC011
     C                             (PRtCd <> '*NRF   ')                                       CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE = 2                                                  CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   IF        PRtCd = *BLANKS                                            CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IF        LIBR = S1SUPP                                              CSC011
     C                   EVAL      WRunDay = S1DATE                                           CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CDL016
      ***Check*if*switchable*feature*CDL016*is*switched*on.************                CDL016 BG3360
      ** Check if switchable feature CDL020 is switched on.                                   BG3360
                                                                                              CDL016
     C*******            EVAL      CDL016 = 'N'                                        CDL016 BG3360
     C                   EVAL      CDL020 = 'N'                                               BG3360
                                                                                              CDL016
     C                   CALL      'AOSARDR0'                                                 CDL016
     C                   PARM      *BLANKS       PRtCd                                        CDL016
     C                   PARM      '*VERIFY'     POptn                                        CDL016
     C*******            PARM      'CDL016'      PSard                                 CDL016 BG3360
     C                   PARM      'CDL020'      PSard                                        BG3360
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL016
                                                                                              CDL016
     C                   IF        PRtCd = *BLANKS                                            CDL016
     C*******            EVAL      CDL016 = 'Y'                                        CDL016 BG3360
     C                   EVAL      CDL020 = 'Y'                                               BG3360
     C                   ENDIF                                                                CDL016
      *                                                                                       240065
      ** Access Dealing Details                                                               240065
      *                                                                                       240065
     C                   CALL      'AODEALR1'                                                 240065
     C                   PARM      *BLANKS       @RTCD             7                          240065
     C                   PARM      '*FIRST '     @OPTN             7                          240065
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        240065
      *                                                                                       240065
      * Database Error                                                                        240065
      *                                                                                       240065
     C     @RTCD         IFNE      *BLANK                                                     240065
     C                   EVAL      BNDCSP =  '.'                                              240065
     C                   END                                                                  240065
      ** Check for Alpha Num Base Rate Code system value                                      CSD103
     C                   CALLB     'AOSVALR0'                                                 CSD103
     C                   PARM      *BLANKS       @RTCD                                        CSD103
     C                   PARM      AlphaBSRC     PSysVal01        20                          CSD103
     C                   PARM      *BLANKS       PCurSet01       200                          CSD103
     C                   PARM      *BLANKS       PSysVal02        20                          CSD103
     C                   PARM      *BLANKS       PCurSet02       200                          CSD103
     C                   PARM      *BLANKS       PSysVal03        20                          CSD103
     C                   PARM      *BLANKS       PCurSet03       200                          CSD103
     C                   PARM      *BLANKS       PSysVal04        20                          CSD103
     C                   PARM      *BLANKS       PCurSet04       200                          CSD103
     C                   PARM      *BLANKS       PSysVal05        20                          CSD103
     C                   PARM      *BLANKS       PCurSet05       200                          CSD103
     C                   PARM      *BLANKS       PSysVal06        20                          CSD103
     C                   PARM      *BLANKS       PCurSet06       200                          CSD103
     C                   PARM      *BLANKS       PSysVal07        20                          CSD103
     C                   PARM      *BLANKS       PCurSet07       200                          CSD103
     C                   PARM      *BLANKS       PSysVal08        20                          CSD103
     C                   PARM      *BLANKS       PCurSet08       200                          CSD103
     C                   PARM      *BLANKS       PSysVal09        20                          CSD103
     C                   PARM      *BLANKS       PCurSet09       200                          CSD103
     C                   PARM      *BLANKS       PSysVal10        20                          CSD103
     C                   PARM      *BLANKS       PCurSet10       200                          CSD103
      * If the system value is not found then default value to 'N'                            CSD103
     C     @RTCD         IFNE      *BLANKS                                                    CSD103
     C                   MOVE      'N'           AlphaCode         1                          CSD103
     C                   ELSE                                                                 CSD103
     C                   MOVEL     PCurSet01     AlphaCode         1                          CSD103
     C                   ENDIF                                                                CSD103

      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area

      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SDBSRTV015

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RESETERRS - Reset error information that is received back     *
      *    from each validation module.                               *
      *****************************************************************

     C     RESETERRS     BEGSR

     C                   EVAL      RetCodeOut = *Blanks
     C                   EVAL      Ix = *ZERO
      *
      * Reset error & warning fields/message IDs/message data (arrays)
     C                   MOVEL     *BLANK        FldNamXAr
     C                   MOVEL     *BLANK        MsgIDXAr
     C                   MOVEL     *BLANK        MsgDtaXAr
     C                   MOVEL     *BLANK        WFldNmXAr
     C                   MOVEL     *BLANK        WMsgIDXAr
     C                   MOVEL     *BLANK        WMsgDtXAr

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATERRS - Update error information with that received back  *
      *    from each validation module.                               *
      *****************************************************************

     C     UPDATERRS     BEGSR
      *
      * Update error fields/message IDs/message data (arrays)
      *
     C                   Z-ADD     1             I                 3 0
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     *IN99         IFEQ      '1'
     C                   MOVEA     FldNamXAr     FlDNameArr(I)
     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
     C                   END
      *
      * Set Error Index
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     I             SUB       1             Idx
      *
      * Update warning fields/message IDs/message data (arrays)
      *
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     *IN99         IFEQ      '1'
     C                   MOVEA     WFldNmXAr     WFldNamArr(I)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(I)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(I)
     C                   END
      *
      * Set Warning Index
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     I             SUB       1             WIdx
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * #TERM - Termination processing.
      *****************************************************************
     C     #TERM         BEGSR
      *
      **  Terminate program
      *
     C                   MOVE      '1'           *INLR
      *
     C     *INU7         IFEQ      '1'
     C                   DUMP
     C                   END
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       240065
      * VALAMT - VALIDATE/REFORMAT AMOUNT                             *                       240065
      *****************************************************************                       240065
      *                                                                                       240065
     C     VALAMT        BEGSR                                                                240065
      *****************************************************************              240065 AR817540
      **Allow*negative*base*rate*only*for*base*rate*code*77.***********              240065 AR817540
      *****************************************************************              240065 AR817540
     C*****DDBSRC        IFEQ      '77'                                              240065 AR817540
      *                                                                                       240065
     C                   CALLB     'ZA0841'                                                   240065
      *                                                                                       240065
     C                   PARM      *BLANK        RetCodeOut                                   240065
     C                   PARM                    @@ALPH                         Display field 240065
     C                   PARM                    @@IDP                          no.of dec.plcs240065
     C                   PARM                    @@IINT                         no.of integers240065
     C                   PARM      'N'           @@MTID                         Mil/Thou      240065
     C                   PARM      *ZERO         @@ERCD                         Error code    240065
     C                   PARM      *ZERO         @@AMT                          File field    240065
     C                   PARM                    BNDCSP                                       240065
      *                                                                                       240065
     C**********         ELSE                                                        240065 AR817540
      **********                                                                     240065 AR817540
     C**********         CALLB     'ZA0840'                                          240065 AR817540
      **********                                                                     240065 AR817540
     C**********         PARM      *BLANK        RetCodeOut                          240065 AR817540
     C**********         PARM                    @@ALPH                         Displ240065 AR817540
     C**********         PARM                    @@IDP                          no.of240065 AR817540
     C**********         PARM                    @@IINT                         no.of240065 AR817540
     C**********         PARM      'N'           @@MTID                         Mil/T240065 AR817540
     C**********         PARM      *ZERO         @@ERCD                         Error240065 AR817540
     C**********         PARM      *ZERO         @@AMT                          File 240065 AR817540
     C**********         PARM                    BNDCSP                              240065 AR817540
      **********                                                                     240065 AR817540
     C**********         END                                                         240065 AR817540
      *                                                                                       240065
     C     @@Ercd        IFNE      0                                                          240065
     C                   MOVE      'N'           DDNbrtOK                                     240065
     C                   ADD       1             Ix                                           240065
     C                   MOVEL     'DDNBRT'      FldNamXAr(Ix)                                240065
     C**********         MOVEL     'USR0935'     MsgIdXAr(Ix)                        240065 AR817540
     C                   MOVEL     'USR0904'     MsgIdXAr(Ix)                               AR817540
     C                   ELSE                                                                 240065
      *                                                                                       240065
      ** Return the formatted amount                                                          240065
     C                   MOVE      @@ALPH        DDNBRT                                       240065
      *                                                                                       240065
     C                   END                                                                  240065
      *                                                                                       240065
     C                   ENDSR                                                                240065
      *****************************************************************                       240065
      /EJECT                                                                                  240065
      *****************************************************************                       240065
      * FMTAMT - FORMAT AMOUNT FOR DISPLAY                            *                       240065
      *****************************************************************                       240065
     C     FMTAMT        BEGSR                                                                240065
      *                                                                                       240065
      * Sadly ZASIGN rejects a minus with a non blank following. So format                    240065
      * non-siged version for database update and use DDNGVI to sign amount.                  240065
      *                                                                                       240065
     C     '-'           SCAN      DDNBRT        PT                2 0                        240065
     C     PT            IFNE      0                                                          240065
      *                                                                                       240065
     C                   MOVE      'Y'           DDNGVI            1                          240065
      *                                                                                       240065
     C                   MOVEA     DDNBRT        ArrayNbrt                                    240065
     C                   MOVE      ' '           ArrayNbrt(PT)                                240065
     C                   MOVEA     ArrayNbrt     PZFld17                                      240065
      *                                                                                       240065
     C                   ELSE                                                                 240065
     C                   MOVE      ' '           DDNGVI                                       240065
     C                   ENDIF                                                                240065
      *                                                                                       240065
     C                   CALLB     'ZASIGN'                                                   240065
     C                   PARM      'Y'           PZASignOk                                    240065
     C                   PARM                    PZFld17                                      240065
     C                   PARM                    PZDig                                        240065
     C                   PARM                    PZDec                                        240065
     C                   PARM      BNDCSP        PZSDCSP                                      240065
     C                   PARM                    PZOut15                                      240065
     C                   PARM                    PZFSign                                      240065
      *                                                                                       240065
     C                   ENDSR                                                                240065
      *****************************************************************                       240065
      /EJECT                                                                                  240065
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      /EJECT
