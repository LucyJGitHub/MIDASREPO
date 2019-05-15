     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE DPMV retrieve function')                      *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEDPMVRTV - Depot Movement Retrieve Module.                  *
      *                                                               *
      *  Function:   This module retrieves a Depot Movement           *
      *              Transaction from the database.  As it does so,   *
      *              validation and cross validation are performed    *
      *              for the Action Code, Depot Movement Reference    *
      *              Number.                                          *
      *                                                               *
      *  Component of SE0070 - Depot Movement Maintenance             *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD000091           Date 16May13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG8550            Date 07Oct05               *
      *                 CAP087             Date 02Sep05               *
      *                 CGL031             Date 05Jul04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 CSE039             Date 21Jan03               *
      * Midas Release 4.01.01 ----------------------------------------*
      *                 206589             Date 18Jun02               *
      *                 207006             Date 18Jun02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 174742             Date 17Jan01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 183768             Date 15Sep00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CSE018             Date 20APR00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSE015             Date 06Dec99               *
      *                 CSE017             Date 20Oct99               *
      *                 CSE012             Date 16Aug99               *
      *                 CPB001             Date 06Oct99               *
      *                 164735             Date 30Sep99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP006             Date 17Mar99               *
      *                 CAP003  *CREATE    Date 27Apr98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD000091 - Event Codes Substitution                          *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG8550 - Reposition capture of ZMUSER data area             *
      *  CAP087 - Depot Movement API - Java Wrapper in Midasplus.     *
      *           Change file to retrieve details using keys          *
      *           Securities + Depot Ref + Depot Mvmt Type.           *
      *  CGL031 - Taxation of Savings Income (Recompile)              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CSE039 - Auto-settle of trades. Amendment to allow SEDPMVSIN *
      *           to be called from SE4400 in 'E' mode.               *
      *  206589 - Extended settlement on depot movement walk in       *
      *  207006 - Add Counterparty & Market Centre to SSI (Recompile) *
      *  174742 - Walk in transactions showing on Walk out screen with*
      *         - Walk out transactions showing on Walk in screen     *
      *  183768 - Error in Switchable feature processing              *
      *           - features are always set on.                       *
      *  CSE018 - Deletion of Walk-in and Walk-out depot movement     *
      *           after movement date.                                *
      *  CSE015 - Forward Valued Depot Movmements (Recompiled)        *
      *  CSE017 - Cum/Ex Indicator on Depot Movmements (Recompiled)   *
      *  CSE012 - SE Depot Movement Narratives (Recompiled).          *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Recompiled due to database changes                  *
      *         - 'Private Banking' Module                            *
      *  164735 - Make sure that the Depot Reference number is a      *
      *           six-digit numerical value.                          *
      *  CAP006 - Do not check for FXM0164 if deal number has been    *
      *           generated through APIs                              *
      *  CAP003 - Conversion of SE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
 
     FSEDPMVL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(DPTMVDF:DPTMVDFOI)
 
     F*DPTMVDL1*IF***E**         K DISK    INFSR(*PSSR)                                       CAP087
     FDPTMV     IF   E           K DISK    INFSR(*PSSR)                                       CAP087
     F                                     RENAME(DPTMVDF:DPTMVDREF)
 
     FZATNRGL1  IF   E           K DISK    INFSR(*PSSR)
 
     F/COPY WNCPYSRC,SEDPMVIF01
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
 
     D***Include*the*SE*standard*declares*******************************************          CAP087
     D*C*PY*SECPYSRC,STDDECLARE*****************************************************          CAP087
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
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
      *
      ** Definition for Error Arrays
      *
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      ** Externam DS for Bank Details
      ** External DS for General Ledger Details
      ** External DS for Branch Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)                                  CSE018
 
      ** Depot Movement File format
      ** Security Details
 
     D DPMVFilfmt    E DS                  EXTNAME(DPTMVD)
 
      ** DS for Access Programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CSE018
 
     D ZMUSER          DS            17
     D  USRBRCH               11     13
     D  DEPT                  14     16
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Ix              S              3P 0
 
      ** Inputs
      ** ------
 
     ** Screen Fields
 
     D DDACTN          S              1A
     D DDDPRN          S              6A
     D DDDPBA          S              3A
     D DDORBR          S              3A
      *
      ** Operation Details
      *
     D ModeOfOP        S              6A
     D RespMode        S              1A
     D FOTRID          S             20A
      *                                                                                       CAP087
      ** Key fields for DPMTMV                                                                CAP087
      *                                                                                       CAP087
     D DPSSKey         S             10A                                                      CAP087
     D DPRNKey         S              6A                                                      CAP087
      *                                                                                       CAP087
      ** Input fields                                                                         CAP087
      *                                                                                       CAP087
     D DPMVSec         S             10A                                                      CAP087
     D/COPY WNCPYSRC,SEH00129
 
      ** Output fields
      ** -------------
 
     ** Ok Indicators
 
     D DDACTNOk        S              1A
     D DDDPRNOk        S              1A
     D DDDPBAOk        S              1A
     D DDORBROk        S              1A
 
      *
      ** Working Fields
      *
     D DDDPRNN         S              6S 0
 
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
                                                                                            MD000091
 
     D/COPY WNCPYSRC,SEDPMVID01
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      ** Initialization
      *
      *                                                                                      BUG8550
      **  GET ZMUSER to access default branch.                                               BUG8550
      *                                                                                      BUG8550
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG8550
     C                   IN        ZMUSER                                                    BUG8550
     C                   UNLOCK    ZMUSER                                                    BUG8550
      *                                                                                      BUG8550
     C                   EXSR      SRInit
      *
      ** Front Office Details Validation.
      *
     C     ModeofOp      IFEQ      '*FRONT'
     C                   EXSR      SRValFrnt
     C                   END
      *
      ** If Error Occurred Terminate processing
      *
     C     DDACTNOk      IFEQ      'N'
     C     DDDPRNOk      OREQ      'N'
     C                   Return
     C                   END
      *
      ** Perform Primary Validation
      *
     C                   EXSR      SRPrimVal
      *
      ** If Error Occurred Terminate processing
      *
     C     DDACTNOk      IFEQ      'N'
     C     DDDPRNOk      OREQ      'N'
     C                   Return
     C                   END
      *                                                                                       CAP087
      ** Passed the primary validation, now set up the retrieval key.                         CAP087
      *                                                                                       CAP087
     C                   EVAL      DPSSKey = DPMVSec                                          CAP087
     C                   EVAL      DPRNKey = DDDPRN                                           CAP087
      *
      ** Perform Cross Validation
      *
     C     DDACTN        CASEQ     'E'           SrValEnq
     C     DDACTN        CASEQ     'D'           SrValDel
     C     DDACTN        CASEQ     'A'           SrValAmd
     C     DDACTN        CASEQ     'I'           SrValIns
     C/COPY WNCPYSRC,SEDPMVIC01
     C                   ENDCS
      *
      ** If Error Occurred Terminate processing
      *
     C     DDACTNOk      IFEQ      'N'
     C     DDDPRNOk      OREQ      'N'
     C                   Return
     C                   END
 
     C     RespMode      IFEQ      'S'
      *
      ** Perform Authorization Validation Routine
      *
      * If calling program is SE4400 (Securities Movements Enquiry)                           CSE039
      * then bypass the SPF validation.                                                       CSE039
     C     CallProg      IfEq      *BLANKS                                                    CSE039
     C                   EXSR      SRAutVal
     C                   EndIf                                                                CSE039
 
     C                   END
      *
      ** Return
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * SRInit - Initialization Routine                               *
      *                                                               *
      * Called by: Main Program                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRInit        BEGSR
 
     C                   CLEAR                   DPMVFilFmt
     C                   MOVEL     'Y'           DDACTNOK
     C                   MOVEL     'Y'           DDDPRNOK
     C                   MOVEL     'Y'           DDDPBAOK
     C                   MOVEL     'Y'           DDORBROK
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValFrnt - Front Office Details Validation Routine           *
      *                                                               *
      * Called by: Main Program                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRValFrnt     BEGSR
      *
      ** Error if action Code is not 'I', 'A, or 'D'
      *
     C     DDACTN        IFNE      'I'
     C     DDACTN        ANDNE     'A'
     C     DDACTN        ANDNE     'D'
     C/COPY WNCPYSRC,SEDPMVIC02
     C                   MOVE      'N'           DDACTNOk
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0111'     MsgIdArr(Ix)
     C                   GOTO      EVFRNT
     C                   END
      *
      ** Error if Front office Transaction Id is blank
      *
     C     FOTRID        IFEQ      *BLANK
     C                   MOVE      'N'           DDACTNOk
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0101'     MsgIdArr(Ix)
     C                   GOTO      EVFRNT
     C                   END
      *
      ** Access transaction with Front Office Transaction ID
      *
     C/COPY WNCPYSRC,SEDPMVIC03
     C     FOTRID        CHAIN     SEDPMVL0                           99
     C/COPY WNCPYSRC,SEDPMVIC04
      *
      ** If Insert
      *
     C     DDACTN        IFEQ      'I'
      *
      ** Front office transaction ID can't be present already
      *
     C     *IN99         IFEQ      '0'
     C                   MOVE      'N'           DDACTNOk
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0102'     MsgIdArr(Ix)
     C**********         MOVEL     FOTRID        MsgDtaArr(Ix)                              MD000091
     C                   EVAL      BLen = %Len(%Trim(FOTRID))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(FOTRID)                    MD000091
     C                   GOTO      EVFRNT
     C                   END
      *
     C                   ELSE
      *
      ** If not insert, front office transaction ID must be present
      *
     C     *IN99         IFEQ      '1'
     C                   MOVE      'N'           DDACTNOk
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0103'     MsgIdArr(Ix)
     C**********         MOVEL     FOTRID        MsgDtaArr(Ix)                              MD000091
     C                   EVAL      BLen = %Len(%Trim(FOTRID))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(FOTRID)                    MD000091
     C                   GOTO      EVFRNT
     C                   END
      *
      ** If not insert, update Depot Movement Reference Number
      *
     C                   MOVEL     DPRN          DDDPRN
 
     C                   END
 
     C     EVFRNT        ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPrimVal - Primary Validation Routine for Action Code and    *
      *             Transaction Reference Number.                     *
      *                                                               *
      * Called by: Main Program                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRPrimVal     BEGSR
      *
      ** Check action code is valid.
      *
     C/COPY WNCPYSRC,SEDPMVIC05
     C     DDACTN        IFNE      'I'
     C     DDACTN        ANDNE     'A'
     C     DDACTN        ANDNE     'D'
     C     DDACTN        ANDNE     'E'
      *
      ** Error 100
      *
     C                   MOVE      'N'           DDACTNOk
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'MMA0381'     MsgIdArr(Ix)
     C                   GOTO      EndVAL
     C                   END
     C/COPY WNCPYSRC,SEDPMVIC06
 
     C     DDDPRN        IFEQ      *BLANKS
     C     DDACTN        IFNE      'I'
      *
      ** Error 103
      *
     C                   MOVE      'N'           DDDPRNOk
     C                   ADD       1             Ix
     C                   MOVEL     'DDDPRN'      FldNameArr(Ix)
     C                   MOVEL     'MMA0382'     MsgIdArr(Ix)
     C                   END
 
     C                   ELSE
      *
      ** Test if Reference is numeric
      *
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM      DDDPRN        ZFIELD           16
     C                   PARM      0             ZADEC             1 0
     C                   PARM      6             ZADIG             2 0
 
     C     ZALIGNOk      IFNE      'Y'
     C     ZFIELD        OREQ      *ZERO
     C     DDDPRN        OREQ      '999999'
      *
      ** Error 103
      *
     C                   MOVE      'N'           DDDPRNOk
     C                   ADD       1             Ix
     C                   MOVEL     'DDDPRN'      FldNameArr(Ix)
     C                   MOVEL     'MMA0382'     MsgIdArr(Ix)
     C                   GOTO      EndVAL
     C                   END
      *                                                                         164735
      ** Error 103                                                              164735
      ** Make sure Reference number is six-digit numerical value.               164735
      *                                                                         164735
     C                   MOVE      DDDPRN        DATEN             6 0          164735
     C                   MOVE      DATEN         DATEA             6            164735
     C     DDDPRN        IFNE      DATEA                                        164735
     C                   MOVE      'N'           DDDPRNOk                       164735
     C                   ADD       1             Ix                             164735
     C                   MOVEL     'DDDPRN'      FldNameArr(Ix)                 164735
     C                   MOVEL     'MMA0382'     MsgIdArr(Ix)                   164735
     C                   GOTO      EndVAL                                       164735
     C                   END                                                    164735
      *
      ** Update file details (Reference)
      *
     C                   MOVE      DDDPRN        DPRN
 
     C                   END
 
     C     EndVAL        ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValIns -  Validation Routine for Insert                     *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRValIns      BEGSR
      *
      ** Validate Transaction Reference
      *
     C                   IF        DDDPRN <> *BLANKS
     C                             AND DPMVSec <> *BLANKS                                     CAP087
 
     C/COPY WNCPYSRC,SEDPMVIC07
     C*****DPRN**********CHAIN     DPTMVDREF                          33                      CAP087
     C     DPMVKey       CHAIN     DPTMVDREF                          33                      CAP087
     C/COPY WNCPYSRC,SEDPMVIC08
 
     C******IN33         IFEQ      '0'                                                        CAP087
     C     *IN33         DOWEQ     '0'                                                        CAP087
     C     DPRN          IFEQ      DDDPRN                                                     CAP087
     C     DPSS          ANDEQ     DPMVSec                                                    CAP087
     C     DPMV          IFEQ      DPMVType                                                   CAP087
      *
      ** Error 102
      *
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'MMA0383'     MsgIdArr(Ix)
     C                   MOVE      'N'           DDACTNOK
     C                   MOVE      '1'           *IN33                                        CAP087
     C                   ELSE                                                                 CAP087
     C                   READ      DPTMVDREF                              33                  CAP087
     C                   ENDIF                                                                CAP087
      *                                                                                       CAP087
     C                   ELSE
      *
      ** Reference number validation
      *
      * Should now use DDDPRN due to multiple READs to the file (DPRN can be                  CAP087
      * different value after a READ).                                                        CAP087
     C***********        MOVE      DPRN          DDDPRNN                                      CAP087
     C                   MOVE      DDDPRN        DDDPRNN                                      CAP087
     C                   MOVE      DPRN          DDDPRNN
 
     C     DDDPRNN       IFLT      FNOR
     C     ModeofOp      IFNE      '*FRONT'                                     CAP006
     C                   ADD       1             Ix
     C                   MOVEL     'DDDPRN'      FldNameArr(Ix)
     C                   MOVEL     'FXM0164'     MsgIdArr(Ix)
     C                   MOVE      'N'           DDDPRNOK
     C                   END                                                    CAP006
     C                   END
      *                                                                                       CAP087
     C                   LEAVE                                                                CAP087
     C                   ENDIF                                                                CAP087
 
     C************       END                                                                  CAP087
     C                   ENDDO                                                                CAP087
     C/COPY WNCPYSRC,SEH00130
 
     C                   END
 
 
     C     EVALI         ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValDel -  Validation Routine for Delete                     *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRValDel      BEGSR
      *
      ** Validate Transaction Reference
      *
     C/COPY WNCPYSRC,SEDPMVIC09
     C*****DPRN**********CHAIN     DPTMVDREF                          33                      CAP087
     C     DPMVKey       CHAIN     DPTMVDREF                          33                      CAP087
     C/COPY WNCPYSRC,SEDPMVIC10
 
     C******IN33         IFEQ      '0'                                                        CAP087
     C     *IN33         DOWEQ     '0'                                                        CAP087
     C     DPRN          IFEQ      DDDPRN                                                     CAP087
     C     DPSS          ANDEQ     DPMVSec                                                    CAP087
     C     DPMV          IFEQ      DPMVType                                                   CAP087
      *                                                                                       CSE018
      ** Check movement date - Movement date must be within the                               CSE018
      ** Backvalue Period.                                                                    CSE018
      *                                                                                       CSE018
     C     DPMV          IFEQ      'WI'                                                       CSE018
     C     DPMV          OREQ      'RR'                                                       CAP087
     C     DPMV          OREQ      'RP'                                                       CAP087
     C     DPMV          OREQ      'BL'                                                       CAP087
     C     DPMV          OREQ      'BB'                                                       CAP087
     C     DPMV          OREQ      'PL'                                                       CAP087
     C     DPMV          OREQ      'PD'                                                       CAP087
     C     DPMV          OREQ      'DT'                                                       CAP087
     C                   Z-ADD     DPMD          MoveDate          5 0                        CSE018
     C                   ELSE                                                                 CSE018
     C                   Z-ADD     DPDO          MoveDate                                     CSE018
     C                   ENDIF                                                                CSE018
     C*                                                                                       CSE018
     C     MoveDate      IFLE      Backval                                                    CSE018
     C                   MOVE      'N'           MovedOK           1                          CSE018
     C                   ELSE                                                                 CSE018
     C                   MOVE      'Y'           MovedOK                                      CSE018
     C                   ENDIF                                                                CSE018
     C*                                                                                       CSE018
     C     RECI          IFEQ      '*'
     C     RECI          OREQ      'S'
     C     CSE018        ANDNE     'Y'                                                        CSE018
     C     RECI          OREQ      'S'
     C     CSE018        ANDEQ     'Y'                                                        CSE018
     C     MovedOK       ANDEQ     'N'                                                        CSE018
     C     RECI          OREQ      'R'
     C     DPMV          ORNE      DPMVType                                                   206589
     C                   MOVE      '1'           *IN33
     C                   END
      *                                                                                       CAP087
     C                   LEAVE                                                                CAP087
     C                   ELSE                                                                 CAP087
     C                   READ      DPTMVDREF                              33                  CAP087
     C                   ENDIF                                                                CAP087
      *                                                                                       CAP087
     C                   ELSE                                                                 CAP087
     C                   MOVE      '1'           *IN33                                        CAP087
     C                   ENDIF                                                                CAP087
 
     C************       END                                                                  CAP087
     C                   ENDDO                                                                CAP087
 
     C     *IN33         IFEQ      '1'
      *
      ** Error 101
      *
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'MMA0384'     MsgIdArr(Ix)
     C                   MOVE      'N'           DDACTNOK
     C                   END
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValEnq -  Validation Routine for Enquiry                    *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRValEnq      BEGSR
      *
      ** Validate Transaction Reference
      *
     C/COPY WNCPYSRC,SEDPMVIC11
     C*****DPRN**********CHAIN     DPTMVDREF                          33                      CAP087
     C     DPMVKey       CHAIN     DPTMVDREF                          33                      CAP087
     C/COPY WNCPYSRC,SEDPMVIC12
     C***********                                                                      174742 CAP087
     C***If valid chain check to see if the movement type is the same as the           174742 CAP087
     C***calling program i.e. if a WALK IN transaction has been called from            174742 CAP087
     C***SEDMWIDSP and not SEDMWODSP or a WALK out has not been called from            174742 CAP087
     C***SEDMWIDSP.                                                                    174742 CAP087
     C***********                                                                      174742 CAP087
     C******IN33*        IFEQ      '0'                                                 174742 CAP087
     C*****DPMV**        ANDNE     DPMVType                                            174742 CAP087
     C***********        MOVE      '1'           *IN33                                 174742 CAP087
     C***********        END                                                           174742 CAP087
     C***********                                                                      174742 CAP087
     C     *IN33         DOWEQ     '0'                                                        CAP087
      *                                                                                       CAP087
     C     DPRN          IFEQ      DDDPRN                                                     CAP087
     C     DPSS          ANDEQ     DPMVSec                                                    CAP087
      *                                                                                       CAP087
     C     DPMV          IFEQ      DPMVType                                                   CAP087
     C                   LEAVE                                                                CAP087
     C                   ELSE                                                                 CAP087
     C                   READ      DPTMVDREF                              33                  CAP087
     C                   ENDIF                                                                CAP087
      *                                                                                       CAP087
     C                   ELSE                                                                 CAP087
     C                   MOVE      '1'           *IN33                                        CAP087
     C                   ENDIF                                                                CAP087
      *                                                                                       CAP087
     C                   ENDDO                                                                CAP087
 
     C     *IN33         IFEQ      '1'
      *
      ** Error 101
      *
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'MMA0384'     MsgIdArr(Ix)
     C                   MOVE      'N'           DDACTNOK
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValAmd -  Validation Routine for Amend                      *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRValAmd      BEGSR
      *
      ** Validate Transaction Reference
      *
     C/COPY WNCPYSRC,SEDPMVIC13
     C*****DPRN**********CHAIN     DPTMVDREF                          33                      CAP087
     C     DPMVKey       CHAIN     DPTMVDREF                          33                      CAP087
     C/COPY WNCPYSRC,SEDPMVIC14
 
     C******IN33         IFEQ      '0'                                                        CAP087
     C     *IN33         DOWEQ     '0'                                                        CAP087
     C     DPRN          IFEQ      DDDPRN                                                     CAP087
     C     DPSS          ANDEQ     DPMVSec                                                    CAP087
     C     DPMV          IFEQ      DPMVType                                                   CAP087
 
     C     RECI          IFEQ      '*'
     C     RECI          OREQ      'S'
     C     RECI          OREQ      'R'
     C     DPMV          ORNE      DPMVType                                                   206589
     C                   MOVE      '1'           *IN33
     C                   END
 
     C                   LEAVE                                                                CAP087
      *                                                                                       CAP087
     C                   ELSE                                                                 CAP087
     C                   READ      DPTMVDREF                              33                  CAP087
     C                   ENDIF                                                                CAP087
      *                                                                                       CAP087
     C                   ELSE                                                                 CAP087
     C                   MOVE      '1'           *IN33                                        CAP087
     C                   END
      *                                                                                       CAP087
     C                   ENDDO                                                                CAP087
 
     C     *IN33         IFEQ      '1'
      *
      ** Error 101
      *
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'MMA0384'     MsgIdArr(Ix)
     C                   MOVE      'N'           DDACTNOK
     C                   END
 
     C                   ENDSR
      *****************************************************************
     C/COPY WNCPYSRC,SEDPMVIC15
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAutVal -  Authorsation Validation Routine                   *
      *                                                               *
      * Called by: Main Program                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRAutVal      BEGSR
      *
      ** Validate SPF-Action for this user
      ** ---------------------------------
      *
      ** Move Branch fields to working variables
      *
     C                   MOVE      DDORBR        @DORBR            3
     C                   MOVE      DDDPBA        @DDPBA            3
 
      *
      ** - If single branch environment
      *
     C     BJSBRC        IFNE      *BLANK
     C                   CALL      'ZVACTU'
     C                   PARM      DDACTN        @ZACTN            1
     C                   PARM                    @ERR              1 0
 
     C     @ERR          IFNE      *ZERO
      *
      ** Error 302
      *
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'MMA0385'     MsgIdArr(Ix)
     C                   MOVE      'N'           DDACTNOK
     C                   END
 
     C                   END
      *
      ** - If Multibranching environment
      *
     C     BJSBRC        IFEQ      *BLANK
 
     C     DDACTN        IFEQ      'I'
      *
      ** Check entry from file
      *
     C     DDDPBA        IFEQ      *BLANKS
     C                   MOVE      USRBRCH       @DDPBA
     C                   MOVE      USRBRCH       DDDPBA
     C                   ELSE
 
     C**********         CALLB     'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDDPBA        @DDPBA
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
      *
      **  Invalid Branch
      *
     C     @RTCD         IFNE      *BLANKS
      *
      ** Error 212
      *
     C                   ADD       1             Ix
     C                   MOVEL     'DDDPBA'      FldNameArr(Ix)
     C                   MOVEL     'MMA0342'     MsgIdArr(Ix)
     C                   MOVE      'N'           DDDPBAOK
     C                   ELSE
     C                   MOVE      A8BRCD        DDDPBA
     C                   MOVE      DDDPBA        @DDPBA            3
     C                   END
 
     C                   END
 
     C                   ELSE
      *
      ** Move branch fields for authority validation
      *
     C                   MOVE      DPBA          @DDPBA
     C                   MOVE      ORBR          @DORBR            3
     C                   END
     C
     C                   CALL      'ZVACTBU'
     C                   PARM      DDACTN        @ZACTN            1
     C                   PARM      @DDPBA        @ZBR              3
     C                   PARM                    @ERR              1 0
 
     C     @ERR          IFEQ      2
 
     C     DDACTN        IFEQ      'I'
     C                   MOVE      'N'           DDDPBAOk
     C                   ELSE
     C                   MOVE      'N'           DDDPRNOk
     C                   END
      *
      ** Error 304
      *
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'MMA0386'     MsgIdArr(Ix)
     C                   END
 
     C     @ERR          IFEQ      1
 
     C     DDACTN        IFEQ      'I'
     C                   MOVE      'N'           DDDPBAOk
     C                   ELSE
     C                   MOVE      'N'           DDDPRNOk
     C                   END
      *
      ** Error 303
      *
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'MMA0387'     MsgIdArr(Ix)
     C                   END
      *
      ** If Originating branch is blank, default it to the booking branch
      *
     C     DDORBR        IFEQ      *BLANKS
     C     DDACTN        ANDEQ     'I'
     C     DDDPBAOk      ANDNE     'N'
     C                   MOVE      DDDPBA        DDORBR
     C                   MOVE      DDORBR        @DORBR
     C                   END
      *
      ** Originating branch code validation only when
      ** originating branch used flag is YES
      *
     C     BKOBRU        IFEQ      'Y'
     C     @DORBR        ANDNE     *BLANKS
      *
      ** Check that originating branch code exists on SDBRCHPD
      *
     C**********         CALL      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      @DORBR        @BRCA             3
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
 
     C     @RTCD         IFNE      *BLANKS
      *
      ** Error 212
      *
     C                   MOVE      'N'           DDORBRok
     C                   ADD       1             Ix
     C                   MOVEL     'DDORBR'      FldNameArr(Ix)
     C                   MOVEL     'MMA0345'     MsgIdArr(Ix)
 
     C                   ELSE
 
     C     DDACTN        IFEQ      'I'
     C                   MOVEL     A8BRCD        DDORBR
     C                   END
 
     C                   END
     C                   END
      *
      **  Perform Originating Branch validation
      *
     C     BKOBUV        IFEQ      'Y'
     C     DDORBR        ANDNE     *BLANKS
      *
     C     DDACTN        IFEQ      'A'
     C     DDACTN        OREQ      'D'
     C     DDACTN        OREQ      'E'
     C/COPY WNCPYSRC,SEDPMVIC16
     C                   MOVE      ORBR          ZOBRX
     C                   ELSE
     C                   MOVE      DDORBR        ZOBRX
     C                   END
      *
     C                   CALL      'ZVOBU'
     C                   PARM                    ZOBRX             3
     C                   PARM                    ERR               1 0
      *
      ** No valid origination branches for this user
      *
     C     ERR           IFEQ      1
      *
      ** Error 305
      *
     C                   MOVE      'N'           DDACTNOk
     C                   MOVE      'N'           DDDPRNOk
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'MMA0198'     MsgIdArr(Ix)
     C                   END
      *
      ** this originating branch invalid for user
      *
     C     ERR           IFEQ      2
      *
      ** Error 306
      *
     C                   MOVE      'N'           DDACTNOk
     C                   MOVE      'N'           DDDPRNOk
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'MMA0199'     MsgIdArr(Ix)
     C                   END
     C                   END
 
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *InzSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Received Parameters
      ** -------------------
 
     ** Screen Fields
      * Action Code (1A)
      * Depot Movement Reference Number (6A)
      * Booking Branch  (3A)
      * Originating Branch  (3A)
 
     C                   PARM                    DDACTN
     C                   PARM                    DDDPRN
     C                   PARM                    DDDPBA
     C                   PARM                    DDORBR
 
     ** Operation Details
      * Mode of Operation (6A)
      * Response Mode (1A)
      * Front Office ID No. (20A)
      * Walk In/ Walk out indicator (2A)                                                      174742
      * Calling Program                                                                       CSE039
      * Securities name                                                                       CAP087
 
     C                   PARM                    ModeOfOP
     C                   PARM                    RespMode
     C                   PARM                    FOTRID
     C                   PARM                    DPMVType          2                          174742
     C                   PARM                    CallProg         10                          CSE039
     C                   PARM                    DPMVSec                                      CAP087
      *
      ** Returned Parameters
      ** -------------------
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      * Error Index (3P 0)
     C                   PARM                    Ix
 
      * Depot movement transaction file Output
     C                   PARM                    DPMVFilFmt
 
     ** Ok Indicators
      * Action Code Ok Indicator (1A)
      * Transaction ID number Ok Indicator (1A)
      * Security Shortname Ok indicator (1A)
      * Booking Branch Ok indicator (1A)
      * Originating Branch Ok indicator (1A)
 
     C                   PARM                    DDACTNOk
     C                   PARM                    DDDPRNOk
     C                   PARM                    DDDPBAOk
     C                   PARM                    DDORBROk
     C/COPY WNCPYSRC,SEH00131
      *
      ** Initialize Program Name
      *
     C                   MOVEL     'SEDPMVRTV'   DBPGM
      *
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
      ** Access General Ledger Details
      *
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      * Database Error
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDGELRPD'    DBFILE                         ************
     C                   MOVEL     '902'         DBASE                          * DBERR 902*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
      *                                                                                       CSE018
      ** Securities Trading                                                                   CSE018
      *                                                                                       CSE018
     C                   CALL      'AOSTRDR0'                                                 CSE018
     C                   PARM      '*DBERR '     @RTCD                                        CSE018
     C                   PARM      '*FIRST '     @OPTN                                        CSE018
     C     SDSTRD        PARM      SDSTRD        DSSDY                                        CSE018
      *                                                                                       CSE018
      ** DATABASE ERROR                                                                       CSE018
      *                                                                                       CSE018
     C     @RTCD         IFNE      *BLANKS                                                    CSE018
     C                   MOVEL     '*FIRST '     DBKEY                                        CSE018
     C                   MOVEL     'SDSTRDPD'    DBFILE                         ************  CSE018
     C                   MOVEL     '903'         DBASE                          * DBERR 903*  CSE018
     C                   EXSR      *PSSR                                        ************  CSE018
     C                   END                                                                  CSE018
      *                                                                                       CSE018
      ** Find Backvalue date                                                                  CSE018
      *                                                                                       CSE018
     C                   Z-ADD     0             Backval           5 0                        CSE018
     C                   EVAL      Backval = BJRDNB - BVBVP                                   CSE018
      *                                                                                       CSE018
      **  Access SAR details file to see if ? allowed for security
      *
     C                   MOVE      'N'           CSE003            1
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSE003'      @SARD
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CSE003'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************
     C                   MOVEL     '903'         DBASE                          * DBERR 903*
     C                   EXSR      *PSSR                                        ************
     C                   ELSE
     C     @RTCD         IFEQ      *BLANKS                                      183768
     C                   MOVE      'Y'           CSE003
     C                   END                                                    183768
     C                   END
      *                                                                                       CSE018
      **  Access SAR details file to see if ? allowed for security                            CSE018
      *                                                                                       CSE018
     C                   CALLB     'AOSARDR0'                                                 CSE018
     C                   PARM      *BLANKS       @RTCD                                        CSE018
     C                   PARM      '*VERIFY'     @OPTN                                        CSE018
     C                   PARM      'CSE018'      @SARD                                        CSE018
      *                                                                                       CSE018
      ** DATABASE ERROR                                                                       CSE018
      *                                                                                       CSE018
     C     @RTCD         IFNE      *BLANKS                                                    CSE018
     C     @RTCD         ANDNE     '*NRF   '                                                  CSE018
     C                   MOVEL     'CSE018'      DBKEY                                        CSE018
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************  CSE018
     C                   MOVEL     '905'         DBASE                          * DBERR 905*  CSE018
     C                   EXSR      *PSSR                                        ************  CSE018
     C                   ENDIF                                                                CSE018
                                                                                              CSE018
     C     @RTCD         IFEQ      *BLANKS                                                    CSE018
     C                   MOVE      'Y'           CSE018                                       CSE018
     C                   ELSE                                                                 CSE018
     C                   MOVE      'N'           CSE018            1                          CSE018
     C                   END                                                                  CSE018
     C/COPY WNCPYSRC,SEH00132
      *                                                                                       CAP087
      ** Key to chain to DPTMV                                                                CAP087
      *                                                                                       CAP087
     C     DPMVKey       KLIST                                                                CAP087
     C                   KFLD                    DPSSKey                                      CAP087
     C                   KFLD                    DPRNKey                                      CAP087
 
     C     Refnokey      KLIST
     C                   KFLD                    MODUK             2
     C                   KFLD                    TRTYK             1
 
     C                   EVAL      MODUK = 'SE'
     C                   EVAL      TRTYK = 'D'
 
     C     RefnoKey      CHAIN     ZATNRGL1                           99
 
     C     *IN99         IFNE      '0'
     C                   MOVEL     'SE ,D  '     DBKEY
     C                   MOVEL     'ZATNRGPD'    DBFILE                         ************
     C                   MOVEL     '904'         DBASE                          * DBERR 904*
     C                   EXSR      *PSSR                                        ************
     C                   END
      *
      **  GET ZMUSER to access default branch.
      *
     C******DTAARA       DEFINE                  ZMUSER                                      BUG8550
     C**********         IN        ZMUSER                                                    BUG8550
     C**********         UNLOCK    ZMUSER                                                    BUG8550
     C/COPY WNCPYSRC,SEDPMVIC17
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
